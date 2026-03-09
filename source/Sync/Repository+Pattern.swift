// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var openPatterns: [Pattern] { patterns.filter { !hasAdjustment(for: $0) } }
  func pattern(for adjustment: Adjustment) -> Pattern { almosts(with: adjustment.almosts) }

  private var patterns: [Pattern] { almosts.patterns(minimumScore: minimumPatternScore) }
  private func hasAdjustment(for pattern: Pattern) -> Bool {
    adjustments.contains { Set($0.almosts) == Set(pattern.map(\.id)) }
  }
}
