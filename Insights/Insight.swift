// Created by Leopold Lemmermann on 22.07.25.

import Foundation

/// The heart of our reflection journey, insights enable users to grow.
public struct Insight: Codable, Identifiable, Hashable, Sendable {
  public var id = UUID().uuidString
  public var createdAt: Date
  public var updatedAt: Date?

  /// Optional: e.g. “Botched presentation”
  public var title: String?
  /// What didn’t work — and what did you learn?/
  public var content: String
  /// Optional: user-selected emoji/mood tag/
  public var mood: Mood?
  /// Optional UX feature/
  public var isFavorite: Bool
  
  public init(
    id: String = UUID().uuidString,
    createdAt: Date = .now,
    updatedAt: Date? = nil,
    title: String? = nil,
    content: String,
    mood: Mood? = nil,
    isFavorite: Bool = false
  ) {
    self.id = id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.title = title
    self.content = content
    self.mood = mood
    self.isFavorite = isFavorite
  }
}

/// The mood associated with the insight can provide helpful context.
public enum Mood: String, Codable, CaseIterable, Sendable {
  case sad = "😞"
  case neutral = "😐"
  case happy = "🙂"
  case excited = "😄"
  case mindBlown = "🤯"
  case idea = "💡"
}
