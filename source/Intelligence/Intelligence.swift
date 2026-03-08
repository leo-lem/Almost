// Created by Leopold Lemmermann on 08.03.26.

import FirebaseAnalytics
import Foundation
import FoundationModels

@MainActor
@Observable
public final class Intelligence {
  private var aiEnabled = true

  private let model = SystemLanguageModel.default

  public init() {}
}

public extension Intelligence {
  var isAvailable: Bool { model.availability == .available }
  var canUseAI: Bool { aiEnabled && isAvailable }

  func updateAIEnabled(_ aiEnabled: Bool) {
    self.aiEnabled = aiEnabled
  }
}

public extension Intelligence {
  func predictTags(for almost: Almost, instructions: String = """
      You classify short near-miss notes into structured tags.

      Rules:
      - Only use the provided enum values.
      - Choose only tags clearly supported by the text.
      - Keep the result sparse and conservative.
      - Prefer literal context over inferred context.
      - Only assign internal states when directly supported.
      - When uncertain, return fewer tags.
      """) async -> Almost {
    var almost = almost

    if canUseAI {
      do {
        let response = try await LanguageModelSession(model: model, instructions: instructions)
          .respond(to: """
            Classify this near-miss note into the schema.
            
            Note: \(almost.text)
            """, generating: Almost.Prediction.self)

        almost.failures = Set(response.content.failures)
        almost.triggers = Set(response.content.triggers)
        almost.contexts = Set(response.content.contexts)
        almost.states = Set(response.content.states)

        Analytics.logEvent("predict_tags", parameters: [
          "text_length": almost.text.count,
          "failures_count": almost.failures.count,
          "triggers_count": almost.triggers.count,
          "contexts_count": almost.contexts.count,
          "states_count": almost.states.count
        ])
      } catch {
        Analytics.logFailure("predict_tags", parameters: ["text_length": almost.text.count], error: error)
      }
    }

    return almost
  }

  func suggestAdjustment(for pattern: Pattern, instructions: String = """
      You help derive one practical personal rule from a cluster of recurring near-miss entries.
      
      Rules:
      - Base the suggestion only on the provided entries and tags.
      - Prefer concrete operational rules over abstract advice.
      - The rule must be short, specific, and actionable.
      - Do not moralize.
      - Do not explain.
      - Do not mention emotions unless clearly necessary.
      - Good rules sound like small instructions someone can actually follow.
      - If possible, target the repeated mechanism rather than a single event.
      - Do not introduce actions not clearly supported by the entries or tags.
      """) async -> Adjustment {
    var suggestion = Adjustment(almosts: pattern.map(\.id), text: nil, state: .suggested)

    if canUseAI, pattern.isValid {
      do {
        let response = try await LanguageModelSession(model: model, instructions: instructions)
          .respond(to: """
            Derive one suggested adjustment from these recurring near-miss entries. Return only a concise rule text.
            
            Entries:
            \(pattern.promptEntries)
            """, generating: Adjustment.Suggestion.self)

        suggestion.text = response.content.text

        Analytics.logEvent("suggest_adjustment", parameters: [
          "pattern_count": pattern.count,
          "score": pattern.score,
          "has_text": suggestion.text != nil
        ])
      } catch {
        Analytics.logFailure(
          "suggest_adjustment", parameters: ["pattern_count": pattern.count, "score": pattern.score], error: error
        )
      }
    }

    return suggestion
  }
}
