// Created by Leopold Lemmermann on 22.07.25.

import FirebaseFirestore
import Foundation

/// The heart of our reflection journey, insights enable users to grow.
public struct Insight: Codable, Identifiable {
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
    title: String = "",
    content: String = "",
    mood: Mood = .calm,
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

extension Insight: Hashable {
  public func hash(into hasher: inout Hasher) {
    id?.hash(into: &hasher)
    userID.hash(into: &hasher)
    timestamp.hash(into: &hasher)
    title?.hash(into: &hasher)
    content.hash(into: &hasher)
    mood.hash(into: &hasher)
    isFavorite.hash(into: &hasher)
  }
}
