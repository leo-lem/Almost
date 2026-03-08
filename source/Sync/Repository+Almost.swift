// Created by Leopold Lemmermann on 08.03.26.

import Foundation

public extension Repository {
  var recentAlmosts: [Almost] { almosts.sorted { $0.createdAt > $1.createdAt } }

  func almosts(with ids: [Almost.ID]) -> [Almost] {
    let idSet = Set(ids)
    return almosts.filter { idSet.contains($0.id) }
  }
}
