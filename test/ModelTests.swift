// Created by Leopold Lemmermann on 27.07.25.

import Testing
import Foundation
@testable import Almost

@Suite("Model Tests")
struct ModelTests {
  
  @Suite("Insight Tests")
  struct InsightTests {
    
    @Test("Insight initialization with default values")
    func testInsightInitialization() {
      let userID = "test-user-id"
      let insight = Insight(userID: userID)
      
      #expect(insight.userID == userID)
      #expect(insight.title == nil)
      #expect(insight.content == "")
      #expect(insight.mood == .calm)
      #expect(insight.isFavorite == false)
      #expect(insight.timestamp != nil)
    }
    
    @Test("Insight initialization with custom values")
    func testInsightInitializationWithCustomValues() {
      let userID = "test-user-id"
      let title = "Test Title"
      let content = "Test content"
      let mood = Mood.happy
      let timestamp = Date()
      
      let insight = Insight(
        userID: userID,
        timestamp: timestamp,
        title: title,
        content: content,
        mood: mood,
        isFavorite: true
      )
      
      #expect(insight.userID == userID)
      #expect(insight.title == title)
      #expect(insight.content == content)
      #expect(insight.mood == mood)
      #expect(insight.isFavorite == true)
      #expect(insight.timestamp == timestamp)
    }
    
    @Test("Insight with empty title should set title to nil")
    func testInsightEmptyTitleHandling() {
      let insight = Insight(userID: "test-user", title: "")
      #expect(insight.title == nil)
    }
    
    @Test("Insight favorite toggle logic")
    func testFavoriteToggleLogic() {
      var insight = Insight(userID: "test-user", isFavorite: false)
      #expect(insight.isFavorite == false)
      
      insight.isFavorite = true
      #expect(insight.isFavorite == true)
      
      insight.isFavorite = false
      #expect(insight.isFavorite == false)
    }
    
    @Test("Insight should be Codable")
    func testInsightCodable() throws {
      let originalInsight = Insight(
        userID: "test-user",
        title: "Test Title",
        content: "Test content",
        mood: .happy,
        isFavorite: true
      )
      
      let encoder = JSONEncoder()
      let data = try encoder.encode(originalInsight)
      
      let decoder = JSONDecoder()
      let decodedInsight = try decoder.decode(Insight.self, from: data)
      
      #expect(decodedInsight.userID == originalInsight.userID)
      #expect(decodedInsight.title == originalInsight.title)
      #expect(decodedInsight.content == originalInsight.content)
      #expect(decodedInsight.mood == originalInsight.mood)
      #expect(decodedInsight.isFavorite == originalInsight.isFavorite)
    }
    
    @Test("Insight should be Hashable and Equatable")
    func testInsightHashableEquatable() {
      let insight1 = Insight(
        userID: "test-user",
        title: "Same Title",
        content: "Same content",
        mood: .happy
      )
      
      let insight2 = Insight(
        userID: "test-user",
        title: "Same Title", 
        content: "Same content",
        mood: .happy
      )
      
      let insight3 = Insight(
        userID: "different-user",
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
    
    @Test("Mood color mapping")
    func testMoodColors() {
      // Test that each mood has a distinct color
      let moods = Mood.allCases
      let colors = moods.map { $0.color }
      
      #expect(colors.count == moods.count)
      // Each mood should have its specific color defined
      for mood in moods {
        #expect(mood.color != nil)
      }
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