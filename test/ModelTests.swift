// Created by Leopold Lemmermann on 27.07.25.

import FirebaseFirestore
import Testing
import Foundation
import SwiftUI
@testable import Almost

@Suite("Model Tests")
struct ModelTests {
  @Suite("Insight Tests")
  struct InsightTests {
    @Test("Insight with empty title should set title to nil")
    func testInsightEmptyTitleHandling() {
      let insight = Insight(userID: "test-user", title: "")
      #expect(insight.title == nil)
    }
    
    @Test("Insight should be Hashable and Equatable")
    func testInsightHashableEquatable() {
      let now = Date.now

      let insight1 = Insight(
        userID: "test-user",
        timestamp: now,
        title: "Same Title",
        content: "Same content",
        mood: .happy
      )
      
      let insight2 = Insight(
        userID: "test-user",
        timestamp: now,
        title: "Same Title",
        content: "Same content",
        mood: .happy
      )
      
      let insight3 = Insight(
        userID: "different-user",
        timestamp: now,
        title: "Same Title",
        content: "Same content",
        mood: .happy
      )
      
      #expect(insight1 == insight2)
      #expect(insight1 != insight3)
      #expect(insight1.hashValue == insight2.hashValue)
    }
  }
  
  @Suite("Mood Tests")
  struct MoodTests {
    
    @Test("Mood enum cases")
    func testMoodCases() {
      let allMoods: [Mood] = [.happy, .disappointed, .overwhelmed, .angry, .calm, .mindblown]
      #expect(Mood.allCases.count == 6)
      #expect(Set(Mood.allCases) == Set(allMoods))
    }
    
    @Test("Mood emoji mapping", arguments: [
      (Mood.happy, "😊"),
      (Mood.disappointed, "😞"),
      (Mood.overwhelmed, "😩"),
      (Mood.angry, "😡"),
      (Mood.calm, "😌"),
      (Mood.mindblown, "🤯")
    ])
    func testMoodEmojis(mood: Mood, expectedEmoji: String) {
      #expect(mood.emoji == expectedEmoji)
    }

    @Test("Test that each mood has a distinct color")
    func testAllMoodColors() {
      let moods = Mood.allCases
      let colors = moods.map { $0.color }

      #expect(colors.count == moods.count)
    }

    @Test("Mood color mapping", arguments: [
      (Mood.happy, Color.Mood.happy),
       (Mood.disappointed, Color.Mood.disappointed),
       (Mood.overwhelmed, Color.Mood.overwhelmed),
      (Mood.angry, Color.Mood.angry),
      (Mood.calm, Color.Mood.calm),
      (Mood.mindblown, Color.Mood.mindblown)
    ])
    func testMoodColors(mood: Mood, expectedColor: Color) {
      #expect(mood.color == expectedColor)
    }
    
    @Test("Mood raw value encoding")
    func testMoodRawValues() {
      #expect(Mood.happy.rawValue == "happy")
      #expect(Mood.disappointed.rawValue == "disappointed")
      #expect(Mood.overwhelmed.rawValue == "overwhelmed")
      #expect(Mood.angry.rawValue == "angry")
      #expect(Mood.calm.rawValue == "calm")
      #expect(Mood.mindblown.rawValue == "mindblown")
    }
    
    @Test("Mood initialization from raw value")
    func testMoodFromRawValue() {
      #expect(Mood(rawValue: "happy") == .happy)
      #expect(Mood(rawValue: "disappointed") == .disappointed)
      #expect(Mood(rawValue: "invalid") == nil)
    }
    
    @Test("Mood is Codable")
    func testMoodCodable() throws {
      let mood = Mood.happy
      
      let encoder = JSONEncoder()
      let data = try encoder.encode(mood)
      
      let decoder = JSONDecoder()
      let decodedMood = try decoder.decode(Mood.self, from: data)
      
      #expect(decodedMood == mood)
    }
    
    @Test("Mood is Sendable")
    func testMoodSendable() {
      // This test verifies that Mood conforms to Sendable
      // which is important for concurrent access
      let mood = Mood.happy
      
      Task {
        let taskMood = mood
        #expect(taskMood == .happy)
      }
    }
  }
}
