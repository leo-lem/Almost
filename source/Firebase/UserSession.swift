// Created by Leopold Lemmermann on 23.07.25.

import FirebaseAnalytics
import FirebaseAuth
import SwiftUI

@MainActor
@Observable
public final class UserSession {
  public var state = State.loading
  public var userID: String?
  
  private let auth = Auth.auth()
  
  public init() {
    _ = auth.addStateDidChangeListener { _, user in
      self.state = if let user { .signedIn(user) } else { .signedOut }
      self.userID = user?.uid
    }
  }
}

public extension UserSession {
  enum State: Equatable {
    case loading
    case signedIn(_ user: User)
    case signedOut
    case error(_ message: String)
  }
  
  var errorMessage: String? {
    if case let .error(message) = state { message } else { nil }
  }

  var hasAccount: Bool {
    if case let .signedIn(user) = state { !user.isAnonymous } else { false }
  }

  var canAddInsights: Bool {
    if case .signedIn = state { true } else { false }
  }
  
  func signUp(
    email: String, password: String, dismiss: DismissAction? = nil
  ) async {
    do {
      // this is ridiculous, but i have found no better way
      try await Task { [auth] in try await Task.detached {
        _ = try await auth.createUser(withEmail: email, password: password)
      }.value}.value
      
      Analytics.logEvent("sign_up", parameters: [:])
      
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func signIn(
    email: String, password: String, dismiss: DismissAction? = nil
  ) async {
    do {
      try await Task { [auth] in try await Task.detached {
        _ = try await auth.signIn(withEmail: email, password: password)
      }.value}.value
      
      Analytics.logEvent("sign_in", parameters: ["anonymous": false])
      
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func signInAnonymously(dismiss: DismissAction? = nil) async {
    do {
      try await Task { [auth] in try await Task.detached {
        _ = try await auth.signInAnonymously()
      }.value}.value
      
      Analytics.logEvent("sign_in", parameters: ["anonymous": true])
      
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func signOut() {
    do {
      try auth.signOut()
      
      Analytics.logEvent("sign_out", parameters: [:])
    } catch {
      state = .error(error.localizedDescription)
    }
  }

  func deleteAccount(dismiss: DismissAction? = nil) async {
    guard let user = auth.currentUser else { return }
    do {
      try await Task { try await Task.detached {
        try await user.delete()
      }.value }.value

      Analytics.logEvent("account_deleted", parameters: [:])
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
