// Created by Leopold Lemmermann on 23.07.25.

import FirebaseAnalytics
import FirebaseAuth
import SwiftUI

@MainActor
@Observable
public final class Authentication {
  public var user: User?

  /// Stored separately because Firebase's `User` object has not reliably triggered
  /// SwiftUI observation updates in all places where the derived `uid` was needed.
  public var userId: String?

  private let auth = Auth.auth()

  /// Initialise and sign in anonymously.
  public init() {
    user = auth.currentUser
    userId = user?.uid

    _ = auth.addStateDidChangeListener { _, user in
      self.user = user
      self.userId = user?.uid
    }

    Task {
      if user == nil {
        _ = try? await Analytics.logFailableEvent("connect_sync") {
          try await auth.signInAnonymously()
        }
      }
    }
  }
}

public extension Authentication {
  var syncAvailable: Bool { user != nil }
  var hasAccount: Bool { !(user?.isAnonymous ?? false) }

  func signUp(email: String, password: String) async throws {
    _ = try await Analytics.logFailableEvent("sign_up") {
      try await auth.createUser(withEmail: email, password: password)
    }
  }
  
  func signIn(email: String, password: String) async throws {
    _ = try await Analytics.logFailableEvent("sign_in") {
      try await auth.signIn(withEmail: email, password: password)
    }
  }
  
  func signOut() throws {
    try Analytics.logFailableEvent("sign_out") {
      try auth.signOut()
    }
  }

  func deleteAccount() async throws {
    guard let user else { return }

    try await Analytics.logFailableEvent("delete_account") {
      try await user.delete()
    }
  }
}
