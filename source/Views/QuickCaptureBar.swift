// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI
import SwiftUIExtensions

public struct QuickCaptureBar: View {
  @State private var text: String = ""
  @State private var pendingAlmost: Almost?
  @State private var isSubmitting = false

  @Environment(Repository.self) private var repo
  @Environment(Intelligence.self) private var ai

  public var body: some View {
    VStack {
      HStack {
        TextField(.addAnAlmost, text: $text, axis: .vertical)
          .textFieldStyle(.plain)
          .onSubmit { Task { await submit() } }
          .disabled(!canType)

        AsyncButton("Add almost", systemImage: "plus.circle.fill", indicatorStyle: .replace) { await submit() }
          .labelStyle(.iconOnly)
          .disabled(!canSubmit)
      }
      .font(.headline)
      .padding()
      .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16))

      if let pendingAlmost {
        AlmostRow(Binding { pendingAlmost } set: { self.pendingAlmost = $0 }, saveAfterEdit: false)
          .cardStyle()

        HStack {
          Button(.discard, systemImage: "trash", role: .destructive) { self.pendingAlmost = nil }
          Spacer()
          AsyncButton("Save", systemImage: "checkmark.circle") { await savePending() }
            .buttonStyle(.borderedProminent)
        }
      }
    }
  }

  public init() {}
}

private extension QuickCaptureBar {
  var canSubmit: Bool {
    pendingAlmost == nil &&
    !isSubmitting &&
    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var canType: Bool {
    pendingAlmost == nil &&
    !isSubmitting
  }

  func submit() async {
    guard canSubmit else { return }
    isSubmitting = true
    defer { isSubmitting = false }

    pendingAlmost = await ai.predictTags(for: Almost(text: text.trimmingCharacters(in: .whitespacesAndNewlines)))
    text = ""
  }

  func savePending() async {
    guard let pendingAlmost else { return }
    try? await repo.save(pendingAlmost)
    self.pendingAlmost = nil
  }
}

#Preview {
  QuickCaptureBar()
    .padding()
    .firebase()
}
