// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var recentAlmosts: [Almost] {
    guard showRecentAlmosts else { return [] }
    return almosts.sorted { $0.createdAt > $1.createdAt }
  }

  func almosts(with ids: Set<Almost.ID>) -> [Almost] {
    almosts.filter { ids.contains($0.id) }
  }
}
