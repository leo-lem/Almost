// Created by Leopold Lemmermann on 22.07.25.

import Foundation

public struct Insight: Codable, Identifiable, Hashable, Sendable {
  public var id = UUID().uuidString
  public var userID: String  // Required for filtering in Firestore
  public var createdAt: Date
  public var updatedAt: Date?

  public var title: String?         // Optional: e.g. “Botched presentation”
  public var content: String        // What didn’t work — and what did you learn?
  public var mood: Mood?            // Optional: user-selected emoji/mood tag
  public var isFavorite: Bool       // Optional UX feature
  
  public init(
    id: String = UUID().uuidString,
    userID: String,
    createdAt: Date = .now,
    updatedAt: Date? = nil,
    title: String? = nil,
    content: String,
    mood: Mood? = nil,
    isFavorite: Bool = false
  ) {
    self.id = id
    self.userID = userID
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.title = title
    self.content = content
    self.mood = mood
    self.isFavorite = isFavorite
  }
}

public enum Mood: String, Codable, CaseIterable, Sendable {
  case sad = "😞"
  case neutral = "😐"
  case happy = "🙂"
  case excited = "😄"
  case mindBlown = "🤯"
  case idea = "💡"
}
