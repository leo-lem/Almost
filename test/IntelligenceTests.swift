// Created by Leopold Lemmermann on 08.03.26.

import FoundationModels
import Testing
@testable import Almost

@Suite("Intelligence Tests")
struct IntelligenceTests {
  @Suite("Tag Prediction")
  struct TagPredictionTests {
    @Test("Predicts useful tags for representative almosts", .enabled(if: SystemLanguageModel.default.isAvailable))
    @MainActor
    func testPredictTags() async throws {
      let intelligence = Intelligence()
      intelligence.updateAIEnabled(true)

      let cases: [(Almost, expectedFailures: Set<Almost.Failure>, expectedTriggers: Set<Almost.Trigger>, expectedContexts: Set<Almost.Context>, expectedStates: Set<Almost.State>)] = [
        (
          Almost(text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table."),
          expectedFailures: [.forgetting, .poorPreparation],
          expectedTriggers: [.rushedMorning, .noChecklist],
          expectedContexts: [.atHome, .beforeLeaving],
          expectedStates: [.rushed]
        ),
        (
          Almost(text: "Stayed on my phone too long at night and almost overslept for my morning run."),
          expectedFailures: [.lateness],
          expectedTriggers: [.lateNight],
          expectedContexts: [.bedtime, .workout],
          expectedStates: [.tired]
        ),
        (
          Almost(text: "Tried to do three things at once while cooking and almost let the pan burn."),
          expectedFailures: [.distraction, .overload],
          expectedTriggers: [.multitasking],
          expectedContexts: [.atHome],
          expectedStates: [.distracted]
        )
      ]

      for (input, expectedFailures, expectedTriggers, expectedContexts, expectedStates) in cases {
        let result = await intelligence.predictTags(for: input)

        let matchingAxes = [
          !result.failures.intersection(expectedFailures).isEmpty,
          !result.triggers.intersection(expectedTriggers).isEmpty,
          !result.contexts.intersection(expectedContexts).isEmpty,
          !result.states.intersection(expectedStates).isEmpty
        ].filter { $0 }.count

        #expect(
          !result.failures.isEmpty || !result.triggers.isEmpty || !result.contexts.isEmpty || !result.states.isEmpty,
          "Expected at least some predicted tags for: \(input.text)"
        )

        #expect(
          matchingAxes >= 2,
          "Expected at least two plausible matching axes for: \(input.text)"
        )
      }
    }

    @Test("Returns input unchanged when AI is disabled")
    @MainActor
    func testPredictTagsDisabledFallback() async {
      let intelligence = Intelligence()
      intelligence.updateAIEnabled(false)

      let input = Almost(
        text: "Packed late and almost forgot my passport.",
        failures: [],
        triggers: [],
        contexts: [],
        states: []
      )

      let result = await intelligence.predictTags(for: input)

      #expect(result == input)
    }
  }

  @Suite("Adjustment Suggestion")
  struct AdjustmentSuggestionTests {
    @Test("Suggests an adjustment for representative patterns", .enabled(if: SystemLanguageModel.default.isAvailable))
    @MainActor
    func testSuggestAdjustment() async throws {
      let intelligence = Intelligence()
      intelligence.updateAIEnabled(true)

      let pattern1: Pattern = [
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
        ),
        Almost(
          id: "a3",
          text: "Forgot to charge my headphones and almost had no audio for the train ride to campus.",
          failures: [.forgetting, .poorPreparation],
          triggers: [.noChecklist],
          contexts: [.commuting],
          states: [.rushed]
        )
      ]

      let pattern2: Pattern = [
        Almost(
          id: "b1",
          text: "Stayed on my phone too long at night and almost overslept for my morning run.",
          failures: [.lateness],
          triggers: [.lateNight],
          contexts: [.bedtime, .workout],
          states: [.tired]
        ),
        Almost(
          id: "b2",
          text: "Watched videos too late and almost slept through my alarm before work.",
          failures: [.lateness],
          triggers: [.lateNight],
          contexts: [.bedtime, .workday],
          states: [.tired]
        )
      ]

      for pattern in [pattern1, pattern2] {
        let result = await intelligence.suggestAdjustment(for: pattern)

        #expect(result.state == .suggested)
        #expect(result.almosts == pattern.map(\.id))

        if let text = result.text {
          #expect(!text.isEmpty)
          #expect(text.count <= 120)
        }
      }
    }

    @Test("Returns fallback adjustment when AI is disabled")
    @MainActor
    func testSuggestAdjustmentDisabledFallback() async {
      let intelligence = Intelligence()
      intelligence.updateAIEnabled(false)

      let pattern: Pattern = [
        Almost(id: "a1", text: "Packed late and almost forgot my passport.")
      ]

      let result = await intelligence.suggestAdjustment(for: pattern)

      #expect(result.state == .suggested)
      #expect(result.almosts == ["a1"])
      #expect(result.text == nil)
    }

    @Test("Returns fallback adjustment for invalid pattern")
    @MainActor
    func testSuggestAdjustmentInvalidPatternFallback() async {
      let intelligence = Intelligence()
      intelligence.updateAIEnabled(true)

      let pattern: Pattern = [
        Almost(id: "a1", text: "Single entry should not form a valid pattern.")
      ]

      let result = await intelligence.suggestAdjustment(for: pattern)

      #expect(result.state == .suggested)
      #expect(result.almosts == ["a1"])
      #expect(result.text == nil)
    }
  }
}
