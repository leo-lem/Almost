// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public extension Adjustment {
  var textPlaceholder: String { "Short, actionable rule for this pattern" }
}

public extension Adjustment.State {
  var label: String {
    switch self {
    case .suggested: "Suggested"
    case .active: "Active"
    case .stabilized: "Stabilized"
    case .archived: "Archived"
    }
  }

  var symbol: String {
    switch self {
    case .suggested: "sparkles"
    case .active: "checkmark.circle.fill"
    case .stabilized: "lock.circle.fill"
    case .archived: "archivebox.fill"
    }
  }

  var color: Color {
    switch self {
    case .suggested: .mint
    case .active: .green
    case .stabilized: .blue
    case .archived: .secondary
    }
  }
}
