// Created by Leopold Lemmermann on 07.03.26.

import Foundation

public struct Adjustment: Codable, Identifiable, Hashable, Sendable {
  public let id: String
  public let createdAt: Date
  public let almosts: [Almost.ID]

  public var text: String?

  public var state: State

  public init(
    id: String = UUID().uuidString,
    createdAt: Date = .now,
    almosts: [Almost.ID] = [],
    text: String?,
    state: State = .suggested
  ) {
    self.id = id
    self.createdAt = createdAt
    self.almosts = almosts
    
    self.text = text
    self.state = state
  }
}

public extension Adjustment {
  enum State: String, Codable, CaseIterable, Sendable {
    case suggested
    case active
    case stabilized
    case archived
  }
}

public extension Adjustment {
  var isActive: Bool { state == .active }
}
