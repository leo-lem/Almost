// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var patterns: [Pattern] {
    almosts.patterns()
  }

  func hasAdjustment(for pattern: Pattern) -> Bool {
    let ids = Set(pattern.map(\.id))
    return adjustments.contains { Set($0.almosts) == ids }
  }

  var openPatterns: [Pattern] {
    patterns.filter { !hasAdjustment(for: $0) }
  }
}
