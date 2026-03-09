// Created by Leopold Lemmermann on 07.03.26.

import Foundation
import Testing
@testable import Almost

@Suite("Model Logic Tests")
struct ModelTests {
  @Suite("Almost Logic")
  struct AlmostLogicTests {
    @Test("Overlap score weights shared axes correctly")
    func testOverlapScore() {
      let first = Almost(
        text: "Packed late and almost forgot my passport.",
        failures: [.forgetting, .poorPreparation],
        triggers: [.rushedMorning, .noChecklist],
        contexts: [.beforeLeaving, .atHome],
        states: [.rushed]
      )

      let second = Almost(
        text: "Rushed out and almost forgot my laptop.",
        failures: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving, .commuting],
        states: [.rushed]
      )

      // forgetting = 3
      // rushedMorning = 2
      // beforeLeaving = 2
      // rushed = 1
      // total = 8
      #expect(first.overlapScore(with: second) == 8)
    }

    @Test("Relatedness uses minimum overlap threshold")
    func testIsRelated() {
      let first = Almost(
        text: "Packed late and almost forgot my passport.",
        failures: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let related = Almost(
        text: "Rushed out and almost forgot my laptop.",
        failures: [.forgetting],
        triggers: [.noChecklist],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let unrelated = Almost(
        text: "Stayed up late and almost overslept.",
        failures: [.lateness],
        triggers: [.lateNight],
        contexts: [.bedtime],
        states: [.tired]
      )

      #expect(first.isRelated(to: related, minimumScore: 4))
      #expect(!first.isRelated(to: unrelated, minimumScore: 4))
    }
  }

  @Suite("Pattern Logic")
  struct PatternLogicTests {
    @Test("Pattern score sums pairwise overlap")
    func testPatternScore() {
      let first = Almost(
        text: "Forgot passport before leaving.",
        failures: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let second = Almost(
        text: "Forgot laptop before commuting.",
        failures: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let third = Almost(
        text: "Stayed up late and almost overslept.",
        failures: [.lateness],
        triggers: [.lateNight],
        contexts: [.bedtime],
        states: [.tired]
      )

      let pattern: Pattern = [first, second, third]

      // first-second = 8
      // first-third = 0
      // second-third = 0
      #expect(pattern.score == 8)
    }

    @Test("Pattern createdAtRange spans earliest to latest")
    func testPatternCreatedAtRange() {
      let now = Date.now
      let earlier = now.addingTimeInterval(-3600)
      let later = now.addingTimeInterval(3600)

      let pattern: Pattern = [
        Almost(createdAt: now, text: "A"),
        Almost(createdAt: earlier, text: "B"),
        Almost(createdAt: later, text: "C")
      ]

      #expect(pattern.createdAtRange?.lowerBound == earlier)
      #expect(pattern.createdAtRange?.upperBound == later)
    }
  }
}
