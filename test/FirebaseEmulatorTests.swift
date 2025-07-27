// Created by Leopold Lemmermann on 27.07.25.

import Testing
import Foundation
import FirebaseFirestore
import FirebaseAuth
@testable import Almost

/// Firebase Emulator Tests - These tests are designed to run with Firebase Emulator Suite
/// 
/// To run these tests:
/// 1. Install Firebase CLI: npm install -g firebase-tools
/// 2. Start emulators: firebase emulators:start --project demo-test
/// 3. Run tests in Xcode or via command line
///
/// These tests validate the actual Firestore rules and authentication behavior
@Suite("Firebase Emulator Tests", .enabled(if: ProcessInfo.processInfo.environment["FIREBASE_EMULATOR_SUITE"] != nil))
struct FirebaseEmulatorTests {
  
  static let testProjectID = "demo-test"
  static let firestoreHost = "localhost"
  static let firestorePort = 8080
  static let authHost = "localhost"
  static let authPort = 9099
  
  /// Set up Firebase emulator connections
  static func setupEmulator() {
    // Configure Firestore to use emulator
    let settings = Firestore.firestore().settings
    settings.host = "\(firestoreHost):\(firestorePort)"
    settings.isSSLEnabled = false
    Firestore.firestore().settings = settings
    
    // Configure Auth to use emulator
    Auth.auth().useEmulator(withHost: authHost, port: authPort)
  }
  
  /// Clean up test data after tests
  static func cleanupEmulator() async throws {
    // Clear all test data from emulator
    try await Firestore.firestore().clearPersistence()
  }
  
  @Suite("Emulator Authentication Tests")
  struct EmulatorAuthenticationTests {
    
    @Test("Anonymous authentication works")
    func testAnonymousAuthentication() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      
      // Sign in anonymously
      let result = try await auth.signInAnonymously()
      let user = result.user
      
      #expect(user.isAnonymous == true)
      #expect(!user.uid.isEmpty)
      
      // Test UserSession integration
      let session = UserSession()
      // Wait for auth state change
      try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
      
      #expect(session.canAddInsights == true)
      #expect(session.hasAccount == false)
      
      // Clean up
      try await user.delete()
    }
    
    @Test("Email authentication works")
    func testEmailAuthentication() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let testEmail = "test@example.com"
      let testPassword = "testpassword123"
      
      // Create user
      let createResult = try await auth.createUser(withEmail: testEmail, password: testPassword)
      let user = createResult.user
      
      #expect(user.isAnonymous == false)
      #expect(!user.uid.isEmpty)
      #expect(user.email == testEmail)
      
      // Sign out
      try auth.signOut()
      
      // Sign in
      let signInResult = try await auth.signIn(withEmail: testEmail, password: testPassword)
      let signedInUser = signInResult.user
      
      #expect(signedInUser.uid == user.uid)
      #expect(signedInUser.email == testEmail)
      
      // Test UserSession integration
      let session = UserSession()
      try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
      
      #expect(session.canAddInsights == true)
      #expect(session.hasAccount == true)
      
      // Clean up
      try await signedInUser.delete()
    }
  }
  
  @Suite("Emulator Firestore Rules Tests")
  struct EmulatorFirestoreRulesTests {
    
    @Test("Authenticated user can create valid insight")
    func testCreateValidInsight() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Create valid insight
      let insight = Insight(
        userID: user.uid,
        content: "Test insight content",
        mood: .happy,
        isFavorite: true
      )
      
      // Save to Firestore
      let collection = firestore.collection("insights")
      let docRef = try collection.addDocument(from: insight)
      
      #expect(!docRef.documentID.isEmpty)
      
      // Verify document exists
      let document = try await docRef.getDocument()
      #expect(document.exists)
      
      let retrievedInsight = try document.data(as: Insight.self)
      #expect(retrievedInsight.userID == user.uid)
      #expect(retrievedInsight.content == "Test insight content")
      #expect(retrievedInsight.mood == .happy)
      #expect(retrievedInsight.isFavorite == true)
      
      // Clean up
      try await docRef.delete()
      try await user.delete()
    }
    
    @Test("Unauthenticated user cannot create insight")
    func testUnauthenticatedCannotCreate() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Ensure no user is signed in
      try auth.signOut()
      
      // Try to create insight
      let insight = Insight(
        userID: "any-user-id",
        content: "Test content",
        mood: .calm,
        isFavorite: false
      )
      
      let collection = firestore.collection("insights")
      
      do {
        _ = try collection.addDocument(from: insight)
        #expect(Bool(false), "Should have thrown permission denied error")
      } catch {
        // Should fail with permission denied
        #expect(error.localizedDescription.contains("permission") || 
                error.localizedDescription.contains("PERMISSION_DENIED"))
      }
    }
    
    @Test("User cannot create insight with wrong userID")
    func testCannotCreateWithWrongUserID() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Try to create insight with different userID
      let insight = Insight(
        userID: "different-user-id", // Wrong userID
        content: "Test content",
        mood: .calm,
        isFavorite: false
      )
      
      let collection = firestore.collection("insights")
      
      do {
        _ = try collection.addDocument(from: insight)
        #expect(Bool(false), "Should have thrown permission denied error")
      } catch {
        // Should fail with permission denied
        #expect(error.localizedDescription.contains("permission") || 
                error.localizedDescription.contains("PERMISSION_DENIED"))
      }
      
      // Clean up
      try await user.delete()
    }
    
    @Test("User can read their own insights")
    func testReadOwnInsights() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Create insight
      let insight = Insight(
        userID: user.uid,
        content: "Readable content",
        mood: .happy,
        isFavorite: false
      )
      
      let collection = firestore.collection("insights")
      let docRef = try collection.addDocument(from: insight)
      
      // Read the insight
      let document = try await docRef.getDocument()
      #expect(document.exists)
      
      let retrievedInsight = try document.data(as: Insight.self)
      #expect(retrievedInsight.userID == user.uid)
      #expect(retrievedInsight.content == "Readable content")
      
      // Clean up
      try await docRef.delete()
      try await user.delete()
    }
    
    @Test("User can update their own insight")
    func testUpdateOwnInsight() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Create insight
      var insight = Insight(
        userID: user.uid,
        content: "Original content",
        mood: .calm,
        isFavorite: false
      )
      
      let collection = firestore.collection("insights")
      let docRef = try collection.addDocument(from: insight)
      
      // Update insight
      insight.content = "Updated content"
      insight.mood = .happy
      insight.isFavorite = true
      
      try docRef.setData(from: insight)
      
      // Verify update
      let document = try await docRef.getDocument()
      let updatedInsight = try document.data(as: Insight.self)
      
      #expect(updatedInsight.content == "Updated content")
      #expect(updatedInsight.mood == .happy)
      #expect(updatedInsight.isFavorite == true)
      #expect(updatedInsight.userID == user.uid) // UserID unchanged
      
      // Clean up
      try await docRef.delete()
      try await user.delete()
    }
    
    @Test("User can delete their own insight")
    func testDeleteOwnInsight() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Create insight
      let insight = Insight(
        userID: user.uid,
        content: "Content to delete",
        mood: .calm,
        isFavorite: false
      )
      
      let collection = firestore.collection("insights")
      let docRef = try collection.addDocument(from: insight)
      
      // Verify it exists
      let beforeDelete = try await docRef.getDocument()
      #expect(beforeDelete.exists)
      
      // Delete it
      try await docRef.delete()
      
      // Verify it's gone
      let afterDelete = try await docRef.getDocument()
      #expect(!afterDelete.exists)
      
      // Clean up
      try await user.delete()
    }
    
    @Test("Insight must have required fields")
    func testRequiredFields() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      let firestore = Firestore.firestore()
      
      // Authenticate user
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      let collection = firestore.collection("insights")
      
      // Test missing content
      do {
        try await collection.addDocument(data: [
          "userID": user.uid,
          "mood": "happy",
          "isFavorite": false
          // Missing content
        ])
        #expect(Bool(false), "Should have failed validation")
      } catch {
        #expect(error.localizedDescription.contains("permission") || 
                error.localizedDescription.contains("PERMISSION_DENIED"))
      }
      
      // Test missing mood
      do {
        try await collection.addDocument(data: [
          "userID": user.uid,
          "content": "Valid content",
          "isFavorite": false
          // Missing mood
        ])
        #expect(Bool(false), "Should have failed validation")
      } catch {
        #expect(error.localizedDescription.contains("permission") || 
                error.localizedDescription.contains("PERMISSION_DENIED"))
      }
      
      // Test missing isFavorite
      do {
        try await collection.addDocument(data: [
          "userID": user.uid,
          "content": "Valid content",
          "mood": "happy"
          // Missing isFavorite
        ])
        #expect(Bool(false), "Should have failed validation")
      } catch {
        #expect(error.localizedDescription.contains("permission") || 
                error.localizedDescription.contains("PERMISSION_DENIED"))
      }
      
      // Clean up
      try await user.delete()
    }
  }
  
  @Suite("Emulator Integration Tests")
  struct EmulatorIntegrationTests {
    
    @Test("Complete insight lifecycle in emulator")
    func testCompleteInsightLifecycle() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      let auth = Auth.auth()
      
      // Authenticate
      let authResult = try await auth.signInAnonymously()
      let user = authResult.user
      
      // Create UserSession and wait for auth state
      let session = UserSession()
      try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
      
      #expect(session.canAddInsights == true)
      #expect(session.userID == user.uid)
      
      // Create insight using session userID
      var insight = Insight(
        userID: session.userID!,
        title: "Lifecycle Test",
        content: "Testing complete lifecycle",
        mood: .happy,
        isFavorite: false
      )
      
      #expect(insight.id == nil) // New insight
      
      // Save insight (this would trigger save() method)
      let collection = Firestore.firestore().collection("insights")
      let docRef = try collection.addDocument(from: insight)
      insight.id = docRef.documentID
      
      #expect(insight.id != nil) // Now has ID
      
      // Update insight
      insight.content = "Updated lifecycle content"
      insight.isFavorite = true
      
      try docRef.setData(from: insight)
      
      // Verify update
      let document = try await docRef.getDocument()
      let updatedInsight = try document.data(as: Insight.self)
      
      #expect(updatedInsight.content == "Updated lifecycle content")
      #expect(updatedInsight.isFavorite == true)
      
      // Delete insight
      try await docRef.delete()
      
      // Verify deletion
      let deletedDoc = try await docRef.getDocument()
      #expect(!deletedDoc.exists)
      
      // Clean up
      try await user.delete()
    }
    
    @Test("Settings with Remote Config emulator")
    func testSettingsWithRemoteConfig() async throws {
      FirebaseEmulatorTests.setupEmulator()
      
      // This would test Remote Config with emulator
      // For now, test local settings behavior
      let settings = Settings()
      
      // Test default values
      #expect(settings.moodEnabled == true)
      #expect(settings.favoritesEnabled == true)
      #expect(settings.analyticsEnabled == true)
      
      // Test value changes
      settings.moodEnabled = false
      #expect(settings.moodEnabled == false)
      
      settings.favoritesEnabled = false
      #expect(settings.favoritesEnabled == false)
      
      // Values should persist in UserDefaults
      let newSettings = Settings()
      #expect(newSettings.moodEnabled == false)
      #expect(newSettings.favoritesEnabled == false)
    }
  }
}