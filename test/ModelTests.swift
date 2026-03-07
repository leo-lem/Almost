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
        userId: "test-user",
        text: "Packed late and almost forgot my passport.",
        failureModes: [.forgetting, .poorPreparation],
        triggers: [.rushedMorning, .noChecklist],
        contexts: [.beforeLeaving, .atHome],
        states: [.rushed]
      )

      let second = Almost(
        userId: "test-user",
        text: "Rushed out and almost forgot my laptop.",
        failureModes: [.forgetting],
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
        userId: "test-user",
        text: "Packed late and almost forgot my passport.",
        failureModes: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let related = Almost(
        userId: "test-user",
        text: "Rushed out and almost forgot my laptop.",
        failureModes: [.forgetting],
        triggers: [.noChecklist],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let unrelated = Almost(
        userId: "test-user",
        text: "Stayed up late and almost overslept.",
        failureModes: [.lateness],
        triggers: [.lateNight],
        contexts: [.bedtime],
        states: [.tired]
      )

      #expect(first.isRelated(to: related))
      #expect(!first.isRelated(to: unrelated))
    }
  }

  @Suite("Pattern Logic")
  struct PatternLogicTests {
    @Test("Pattern shared values are the intersection across all almosts")
    func testPatternSharedValues() {
      let pattern: Pattern = [
        Almost(
          userId: "test-user",
          text: "Forgot passport before leaving.",
          failureModes: [.forgetting, .poorPreparation],
          triggers: [.rushedMorning, .noChecklist],
          contexts: [.beforeLeaving, .atHome],
          states: [.rushed]
        ),
        Almost(
          userId: "test-user",
          text: "Forgot laptop before commuting.",
          failureModes: [.forgetting],
          triggers: [.rushedMorning],
          contexts: [.beforeLeaving, .commuting],
          states: [.rushed]
        ),
        Almost(
          userId: "test-user",
          text: "Forgot headphones before train.",
          failureModes: [.forgetting, .poorPreparation],
          triggers: [.noChecklist, .rushedMorning],
          contexts: [.beforeLeaving, .commuting],
          states: [.rushed]
        )
      ]

      #expect(pattern.sharedFailureModes == [.forgetting])
      #expect(pattern.sharedTriggers == [.rushedMorning])
      #expect(pattern.sharedContexts == [.beforeLeaving])
      #expect(pattern.sharedStates == [.rushed])
    }

    @Test("Pattern score sums pairwise overlap")
    func testPatternScore() {
      let first = Almost(
        userId: "test-user",
        text: "Forgot passport before leaving.",
        failureModes: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let second = Almost(
        userId: "test-user",
        text: "Forgot laptop before commuting.",
        failureModes: [.forgetting],
        triggers: [.rushedMorning],
        contexts: [.beforeLeaving],
        states: [.rushed]
      )

      let third = Almost(
        userId: "test-user",
        text: "Stayed up late and almost overslept.",
        failureModes: [.lateness],
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
        Almost(userId: "test-user", text: "A", createdAt: now),
        Almost(userId: "test-user", text: "B", createdAt: earlier),
        Almost(userId: "test-user", text: "C", createdAt: later)
      ]

      #expect(pattern.createdAtRange?.lowerBound == earlier)
      #expect(pattern.createdAtRange?.upperBound == later)
    }
  }
}
