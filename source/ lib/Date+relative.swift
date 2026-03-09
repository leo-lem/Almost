// Created by Leopold Lemmermann on 09.03.26.

import Foundation

public extension Date {
  var relative: String {
    RelativeDateTimeFormatter().localizedString(for: self, relativeTo: .now)
  }
}
