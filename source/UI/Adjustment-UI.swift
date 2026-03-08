// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public extension Adjustment {
  var defaultText: String {
    get { text ?? "" }
    set { text = newValue.isEmpty ? nil : newValue }
  }

  var relativeTimestamp: String {
    RelativeDateTimeFormatter().localizedString(for: createdAt, relativeTo: .now)
  }
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

  var next: Self {
    switch self {
    case .suggested: .active
    case .active: .stabilized
    case .stabilized: .archived
    case .archived: .suggested
    }
  }
}
