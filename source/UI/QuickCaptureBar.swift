// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI
import SwiftUIExtensions

public struct QuickCaptureBar: View {
  @Environment(Repository.self) private var repo
  @Environment(Intelligence.self) private var ai

  @State private var text: String = ""
  @State private var pendingAlmost: Almost?
  @State private var isSubmitting = false

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("Add an almost…", text: $text, axis: .vertical)
          .textFieldStyle(.plain)
          .disabled(isSubmitting)
          .onSubmit { Task { await submit() } }

        AsyncButton { await submit() } label: {
          Label(isSubmitting ? "Submitting…" : "Add almost",
                systemImage: isSubmitting ? "hourglass" : "plus.circle.fill")
            .labelStyle(.iconOnly)
        }
        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
      }
      .font(.headline.weight(.semibold))
      .padding()
      .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16))

      if let pendingAlmost {
        AlmostRow(almost: binding(for: pendingAlmost.id))

        HStack {
          Button(role: .destructive) { self.pendingAlmost = nil } label: {
            Label("Discard", systemImage: "trash")
          }

          Spacer()

          AsyncButton { await savePending() } label: {
            Label("Save", systemImage: "checkmark.circle")
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
  }

  public init() {}
}

private extension QuickCaptureBar {
  func binding(for id: String) -> Binding<Almost> {
    Binding {
      pendingAlmost!
    } set: {
      pendingAlmost = $0
    }
  }

  func submit() async {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty, !isSubmitting else { return }

    isSubmitting = true

    let base = Almost(text: trimmed)
    pendingAlmost = await ai.predictTags(for: base)
    text = ""

    isSubmitting = false
  }

  func savePending() async {
    guard let pendingAlmost else { return }

    do {
      try await repo.save(pendingAlmost)
      self.pendingAlmost = nil
    } catch {
      // keep pendingAlmost around so the user can retry
    }
  }
}

#Preview {
  QuickCaptureBar()
    .padding()
    .firebase()
}
