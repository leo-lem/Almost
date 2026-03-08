// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Pattern {
  var promptEntries: String {
    map { almost in
      """
      - text: \(almost.text)
        failures: \(almost.failures.map(\.rawValue).sorted())
        triggers: \(almost.triggers.map(\.rawValue).sorted())
        contexts: \(almost.contexts.map(\.rawValue).sorted())
        states: \(almost.states.map(\.rawValue).sorted())
      """
    }
    .joined(separator: "\n")
  }
}
