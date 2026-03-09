// Created by Leopold Lemmermann on 08.03.26.

import Extensions
import SwiftUI
import SwiftUIExtensions

public struct PatternView: View {
  public let pattern: Pattern
  @State private var adjustment: Adjustment

  @Environment(Repository.self) private var repo
  @Environment(Intelligence.self) private var ai

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Label("\(pattern.count) almosts", systemImage: "square.stack.3d.up.fill")
          .labelStyle(.capsule(.accent))

        Label("\(pattern.score) similarity", systemImage: "sparkle")
          .labelStyle(.capsule(.secondary))

        Spacer()

        if ai.usable {
          AsyncButton("Suggest", systemImage: "brain", indicatorStyle: .replace) { await suggest() }
            .labelStyle(.iconOnly)
            .buttonStyle(.bordered)
        }
      }

      ForEach(Array(pattern), id: \.id) { almost in
        AlmostRow(repo.binding(for: almost.id))
        Divider()
      }

      AdjustmentCard($adjustment, saveAfterEdit: false)
        .cardStyle()

      AsyncButton(indicatorStyle: .edge(.trailing)) { try? await repo.save(adjustment) } label: {
        Label(repo.adjustments.contains { $0.id == adjustment.id } ? "Update" : "Save",
              systemImage: "square.and.arrow.down")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.accent.opacity(0.75))
    }
    .task {
      self.adjustment ?= repo.adjustment(for: pattern)
      if adjustment.text == nil { await suggest() }
    }
  }

  public init(_ pattern: Pattern) {
    self.pattern = pattern
    self.adjustment = Adjustment(pattern)
  }
}

private extension PatternView {
  func suggest() async {
    guard pattern.isValid else { return }
    adjustment = await ai.suggestAdjustment(for: pattern)
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
    PatternView(pattern)
  }
  .padding()
  .firebase()
}
