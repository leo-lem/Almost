// Created by Leopold Lemmermann on 08.03.26.

import FoundationModels

extension Almost {
  @Generable struct Prediction {
    @Guide(description: "The main structural ways this near miss happened. Pick only the most relevant ones.")
    let failures: [Almost.Failure]

    @Guide(description: "What most likely triggered or preceded the near miss. Pick only the most relevant ones.")
    let triggers: [Almost.Trigger]

    @Guide(description: "The situational context in which this happened.")
    let contexts: [Almost.Context]

    @Guide(description: "The person's internal state during the near miss.")
    let states: [Almost.State]
  }
}
