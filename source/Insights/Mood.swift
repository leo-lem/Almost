// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI

/// The mood associated with the insight can provide helpful context.
public enum Mood: String, Codable, CaseIterable, Sendable {
  case happy, disappointed, overwhelmed, angry, calm, mindblown

  var emoji: String {
    switch self {
    case .happy: "😊"
    case .disappointed: "😞"
    case .overwhelmed: "😩"
    case .angry: "😡"
    case .calm: "😌"
    case .mindblown: "🤯"
    }
  }

  var color: Color {
    switch self {
    case .happy: .Mood.happy
    case .disappointed: .Mood.disappointed
    case .overwhelmed: .Mood.overwhelmed
    case .angry: .Mood.angry
    case .calm: .Mood.calm
    case .mindblown: .Mood.mindblown
    }
  }
}
