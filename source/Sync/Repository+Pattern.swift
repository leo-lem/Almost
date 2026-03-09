// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var patterns: [Pattern] { almosts.patterns(minimumScore: minimumPatternScore) }

  var openPatterns: [Pattern] {
    patterns.filter { !hasAdjustment(for: $0) }
  }

  func pattern(for adjustment: Adjustment) -> Pattern { almosts(with: adjustment.almosts) }

  func hasAdjustment(for pattern: Pattern) -> Bool {
    let ids = Set(pattern.map(\.id))
    return adjustments.contains { Set($0.almosts) == ids }
  }
}
