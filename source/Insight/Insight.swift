// Created by Leopold Lemmermann on 22.07.25.

import FirebaseFirestore
import SwiftUI

/// The heart of our reflection journey, insights enable users to grow.
public struct Insight: Codable, Identifiable, Hashable {
  @DocumentID public var id: String?
  public let userID: String
  public let timestamp: Date

  /// Optional: e.g. “Botched presentation”
  public var title: String?
  /// What didn’t work — and what did you learn?/
  public var content: String
  /// Optional: user-selected emoji/mood tag/
  public var mood: Mood
  /// Optional UX feature/
  public var isFavorite: Bool
  
  public init(
    userID: String,
    timestamp: Date = .now,
    title: String,
    content: String,
    mood: Mood,
    isFavorite: Bool = false
  ) {
    self.userID = userID
    self.timestamp = timestamp
    self.title = title.isEmpty ? nil : title
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
