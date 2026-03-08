// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI
import SwiftUIExtensions

public struct PatternCard: View {
  @Environment(Repository.self) private var repo
  @Environment(Intelligence.self) private var ai

  public let pattern: Pattern

  @State private var adjustment: Adjustment
  @State private var isSuggesting = false
  @State private var isSaving = false
  @State private var hasSuggested = false

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Label("\(pattern.count)", systemImage: "square.stack.3d.up.fill")
          .labelStyle(.capsule(.blue))

        if pattern.score > 0 {
          Label("\(pattern.score)", systemImage: "sparkle")
            .labelStyle(.capsule(.secondary))
        }

        Spacer()

        if isSuggesting {
          ProgressView()
            .controlSize(.small)
        }
      }

      VStack(alignment: .leading) {
        ForEach(pattern, id: \.id) {
          AlmostRow(almost: binding(for: $0.id))
        }
      }

      AdjustmentCard($adjustment)
        .background {
          RoundedRectangle(cornerRadius: 16)
            .fill(.thickMaterial)
            .shadow(radius: 1)
        }

      AsyncButton { await save() } label: {
        Label(
          isSaving ? "Saving" : hasBeenAdded ? "Update" : "Save",
          systemImage: isSaving ? "hourglass" : "square.and.arrow.down")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.accent.opacity(0.75))
      .disabled(isSaving || isSuggesting)
    }
    .padding()
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    .task { await suggestIfNeeded() }
  }

  public init(pattern: Pattern, adjustment: Adjustment? = nil) {
    self.pattern = pattern
    self._adjustment = State(
      initialValue: adjustment ?? Adjustment(
        almosts: pattern.map(\.id),
        text: nil,
        state: .suggested
      )
    )
    self._hasSuggested = State(initialValue: adjustment != nil)
  }
}

private extension PatternCard {
  var hasBeenAdded: Bool {
    repo.adjustments.contains { $0.id == adjustment.id}
  }

  func binding(for id: Almost.ID) -> Binding<Almost> {
    Binding {
      pattern.first { $0.id == id }!
    } set: { _ in }
  }

  func suggestIfNeeded() async {
    guard !hasSuggested else { return }
    guard pattern.isValid else { return }

    isSuggesting = true
    adjustment = await ai.suggestAdjustment(for: pattern)
    hasSuggested = true
    isSuggesting = false
  }

  func save() async {
    guard !isSaving else { return }

    isSaving = true
    defer { isSaving = false }

    do {
      try await repo.save(adjustment)
    } catch {
      return
    }
  }
}

#Preview("Pattern Card") {
  let pattern: Pattern = [
    Almost(
      id: "a1",
      text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table.",
      failures: [.forgetting, .poorPreparation],
      triggers: [.rushedMorning],
      contexts: [.atHome, .beforeLeaving],
      states: [.rushed]
    ),
    Almost(
      id: "a2",
      text: "Rushed out the door without checking my bag and almost arrived at university without my laptop.",
      failures: [.forgetting],
      triggers: [.rushedMorning, .noChecklist],
      contexts: [.beforeLeaving, .commuting],
      states: [.rushed]
    )
  ]

  VStack {
    PatternCard(pattern: pattern)
  }
  .padding()
  .firebase()
}
