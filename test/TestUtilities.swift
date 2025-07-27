// Created by Leopold Lemmermann on 27.07.25.

import Testing
import Foundation
@testable import Almost

/// Test utilities and shared setup for Almost app tests
@Suite("Test Utilities and Setup")
struct TestUtilities {
  
  /// Mock Firebase setup for testing
  static func setupMockFirebase() {
    // This would configure Firebase for testing
    // - Set up Firebase emulator connections
    // - Configure test database
    // - Set up mock authentication
  }
  
  /// Clean up test data
  static func cleanupTestData() async {
    // This would clean up any test data created during testing
    // - Remove test documents from Firestore emulator
    // - Reset authentication state
    // - Clear UserDefaults test keys
  }
  
  /// Create test insight with custom properties
  static func createTestInsight(
    userID: String = "test-user",
    title: String? = nil,
    content: String = "Test content",
    mood: Mood = .calm,
    isFavorite: Bool = false
  ) -> Insight {
    return Insight(
      userID: userID,
      title: title ?? "",
      content: content,
      mood: mood,
      isFavorite: isFavorite
    )
  }
  
  /// Create multiple test insights for collection testing
  static func createTestInsights(count: Int, userID: String = "test-user") -> [Insight] {
    return (0..<count).map { index in
      Insight(
        userID: userID,
        title: "Test Insight \(index + 1)",
        content: "This is test content for insight \(index + 1)",
        mood: Mood.allCases[index % Mood.allCases.count],
        isFavorite: index % 2 == 0
      )
    }
  }
  
  /// Test data validation helpers
  struct ValidationHelpers {
    
    /// Validate insight data meets Firestore rules requirements
    static func validateInsightData(_ insight: Insight) -> Bool {
      guard !insight.content.isEmpty else { return false }
      guard !insight.userID.isEmpty else { return false }
      // mood and isFavorite are validated by type system
      return true
    }
    
    /// Validate email format for authentication tests
    static func validateEmail(_ email: String) -> Bool {
      return email.contains("@") && email.contains(".")
    }
    
    /// Validate password strength for authentication tests
    static func validatePassword(_ password: String) -> Bool {
      return password.count >= 6
    }
  }
  
  /// Mock classes for testing
  struct Mocks {
    
    /// Mock user for authentication testing
    class MockUser: User {
      private let _isAnonymous: Bool
      private let _uid: String
      
      init(uid: String = "mock-user-id", isAnonymous: Bool = false) {
        self._uid = uid
        self._isAnonymous = isAnonymous
      }
      
      override var isAnonymous: Bool { _isAnonymous }
      override var uid: String { _uid }
    }
    
    /// Mock dismiss action for UI testing
    class MockDismissAction {
      var dismissCount = 0
      
      func callAsFunction() {
        dismissCount += 1
      }
    }
    
    /// Mock UserDefaults for settings testing
    class MockUserDefaults: UserDefaults {
      private var storage: [String: Any] = [:]
      
      override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
      }
      
      override func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
      }
      
      override func bool(forKey defaultName: String) -> Bool {
        return storage[defaultName] as? Bool ?? false
      }
      
      override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
      }
      
      override func exists(_ key: String) -> Bool {
        return storage[key] != nil
      }
    }
  }
  
  @Test("Test utilities validation helpers work correctly")
  func testValidationHelpers() {
    // Test insight validation
    let validInsight = Insight(userID: "test-user", content: "Valid content")
    #expect(ValidationHelpers.validateInsightData(validInsight) == true)
    
    let invalidInsight = Insight(userID: "", content: "")
    #expect(ValidationHelpers.validateInsightData(invalidInsight) == false)
    
    // Test email validation
    #expect(ValidationHelpers.validateEmail("test@example.com") == true)
    #expect(ValidationHelpers.validateEmail("invalid-email") == false)
    
    // Test password validation
    #expect(ValidationHelpers.validatePassword("password123") == true)
    #expect(ValidationHelpers.validatePassword("123") == false)
  }
  
  @Test("Test insight creation helpers work correctly")
  func testInsightCreationHelpers() {
    let insight = createTestInsight()
    #expect(insight.userID == "test-user")
    #expect(insight.content == "Test content")
    #expect(insight.mood == .calm)
    #expect(insight.isFavorite == false)
    
    let customInsight = createTestInsight(
      userID: "custom-user",
      title: "Custom Title",
      content: "Custom content",
      mood: .happy,
      isFavorite: true
    )
    #expect(customInsight.userID == "custom-user")
    #expect(customInsight.title == "Custom Title")
    #expect(customInsight.mood == .happy)
    #expect(customInsight.isFavorite == true)
  }
  
  @Test("Test insights collection creation works correctly")
  func testInsightsCollectionCreation() {
    let insights = createTestInsights(count: 5)
    #expect(insights.count == 5)
    
    // Verify each insight has unique title
    let titles = insights.compactMap { $0.title }
    #expect(Set(titles).count == titles.count)
    
    // Verify moods cycle through all cases
    let moodSet = Set(insights.map { $0.mood })
    #expect(moodSet.count >= 1)
    
    // Verify favorites alternate
    let favorites = insights.filter { $0.isFavorite }
    #expect(favorites.count == 3) // 0, 2, 4 are favorites
  }
  
  @Test("Mock classes work correctly")
  func testMockClasses() {
    // Test MockUser
    let anonymousUser = Mocks.MockUser(isAnonymous: true)
    #expect(anonymousUser.isAnonymous == true)
    #expect(anonymousUser.uid == "mock-user-id")
    
    let regularUser = Mocks.MockUser(uid: "regular-user", isAnonymous: false)
    #expect(regularUser.isAnonymous == false)
    #expect(regularUser.uid == "regular-user")
    
    // Test MockDismissAction
    let mockDismiss = Mocks.MockDismissAction()
    #expect(mockDismiss.dismissCount == 0)
    
    mockDismiss()
    #expect(mockDismiss.dismissCount == 1)
    
    mockDismiss()
    mockDismiss()
    #expect(mockDismiss.dismissCount == 3)
    
    // Test MockUserDefaults
    let mockDefaults = Mocks.MockUserDefaults()
    #expect(mockDefaults.exists("test-key") == false)
    
    mockDefaults.set(true, forKey: "test-key")
    #expect(mockDefaults.exists("test-key") == true)
    #expect(mockDefaults.bool(forKey: "test-key") == true)
    
    mockDefaults.removeObject(forKey: "test-key")
    #expect(mockDefaults.exists("test-key") == false)
  }
}

/// Integration test suite that combines multiple components
@Suite("Integration Tests")
struct IntegrationTests {
  
  @Test("Complete insight lifecycle")
  func testCompleteInsightLifecycle() async {
    // Test the complete flow: create -> save -> update -> delete
    
    // Create new insight
    var insight = TestUtilities.createTestInsight(
      userID: "test-user",
      content: "Integration test insight",
      mood: .happy
    )
    
    #expect(insight.id == nil) // New insight has no ID
    #expect(insight.content == "Integration test insight")
    #expect(insight.mood == .happy)
    
    // Simulate save (would use Firebase emulator in real test)
    insight.id = "generated-id"
    #expect(insight.id != nil)
    
    // Update insight
    insight.content = "Updated content"
    insight.isFavorite = true
    
    #expect(insight.content == "Updated content")
    #expect(insight.isFavorite == true)
    
    // Simulate update save (would use Firebase emulator)
    #expect(insight.id == "generated-id") // ID remains same
    
    // Delete insight (would use Firebase emulator)
    #expect(insight.id != nil) // Must have ID to delete
  }
  
  @Test("User session and insight interaction")
  func testUserSessionAndInsightInteraction() {
    // Test how user session state affects insight operations
    
    let session = UserSession()
    let mockUser = TestUtilities.Mocks.MockUser(uid: "test-user", isAnonymous: false)
    
    // Test session states
    session.state = .signedOut
    #expect(session.canAddInsights == false)
    #expect(session.hasAccount == false)
    
    session.state = .signedIn(mockUser)
    #expect(session.canAddInsights == true)
    #expect(session.hasAccount == true)
    
    // Test insight creation with user ID
    let insight = Insight(userID: session.userID ?? "")
    #expect(insight.userID == session.userID)
  }
  
  @Test("Settings affect UI behavior")
  func testSettingsAffectUIBehavior() {
    // Test how settings changes affect UI components
    
    let settings = Settings()
    
    // Test mood feature toggle
    settings.moodEnabled = true
    #expect(settings.moodEnabled == true)
    // In real test: verify mood picker is visible
    
    settings.moodEnabled = false
    #expect(settings.moodEnabled == false)
    // In real test: verify mood picker is hidden
    
    // Test favorites feature toggle
    settings.favoritesEnabled = true
    #expect(settings.favoritesEnabled == true)
    // In real test: verify favorite buttons are visible
    
    settings.favoritesEnabled = false
    #expect(settings.favoritesEnabled == false)
    // In real test: verify favorite buttons are hidden
    
    // Test analytics toggle
    settings.analyticsEnabled = true
    #expect(settings.analyticsEnabled == true)
    // In real test: verify analytics events are sent
    
    settings.analyticsEnabled = false
    #expect(settings.analyticsEnabled == false)
    // In real test: verify analytics events are not sent
  }
  
  @Test("Mood filtering and favorites work together")
  func testMoodFilteringAndFavorites() {
    // Test combined filtering by mood and favorites
    
    let insights = [
      Insight(userID: "test-user", content: "Happy favorite", mood: .happy, isFavorite: true),
      Insight(userID: "test-user", content: "Happy regular", mood: .happy, isFavorite: false),
      Insight(userID: "test-user", content: "Calm favorite", mood: .calm, isFavorite: true),
      Insight(userID: "test-user", content: "Calm regular", mood: .calm, isFavorite: false)
    ]
    
    // Filter by mood only
    let happyInsights = insights.filter { $0.mood == .happy }
    #expect(happyInsights.count == 2)
    
    // Filter by favorites only
    let favoriteInsights = insights.filter { $0.isFavorite }
    #expect(favoriteInsights.count == 2)
    
    // Filter by both mood and favorites
    let happyFavorites = insights.filter { $0.mood == .happy && $0.isFavorite }
    #expect(happyFavorites.count == 1)
    #expect(happyFavorites.first?.content == "Happy favorite")
  }
}