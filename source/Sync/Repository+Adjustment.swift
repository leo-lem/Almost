// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var orderedAdjustments: [Adjustment] {
    adjustments
      .sorted {
        if $0.state != $1.state {
          return $0.state.displayOrder < $1.state.displayOrder
        }

        return $0.createdAt > $1.createdAt
      }
  }

  func canActivate(_ adjustment: Adjustment, limit: Int = 2) -> Bool {
    adjustments
      .filter { $0.state == .active && $0.id != adjustment.id }
      .count < limit
  }

  func adjustments(containing almostId: Almost.ID) -> [Adjustment] {
    adjustments.filter { $0.almosts.contains(almostId) }
  }
}

private extension Adjustment.State {
  var displayOrder: Int {
    switch self {
    case .active: 0
    case .suggested: 1
    case .stabilized: 2
    case .archived: 3
    }
  }
}
