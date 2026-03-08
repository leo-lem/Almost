// Created by Leopold Lemmermann on 08.03.26.

import FoundationModels

extension Adjustment {
  @Generable struct Suggestion {
    @Guide(description: "One short operational rule. Imperative. Concrete. Max 12 words. No moralizing, no vagueness.")
    let text: String?
  }
}
