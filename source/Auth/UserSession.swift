// Created by Leopold Lemmermann on 23.07.25.

import FirebaseAnalytics
import FirebaseAuth
import SwiftUI

@MainActor
@Observable
public final class UserSession {
  public var state = State.loading
  public var user: User?
  public var userId: String?

  private let auth = Auth.auth()
  
  public init() {
    _ = auth.addStateDidChangeListener { _, user in
      self.user = user
      self.userId = user?.uid
      self.state = if user?.isAnonymous ?? true {
        .signedOut
      } else {
        .signedIn
      }
    }

    Task {
      if auth.currentUser == nil {
        await signInAnonymously()
      }
    }
  }
}

public extension UserSession {
  enum State: Equatable {
    case loading
    case signedOut
    case signedIn
    case error(_ message: String)
  }

  var hasAccount: Bool {
    if case .signedIn = state { true } else { false }
  }

  var errorMessage: String? {
    if case let .error(message) = state { message } else { nil }
  }

  func signUp(
    email: String, password: String, dismiss: DismissAction? = nil
  ) async {
    do {
      _ = try await auth.createUser(withEmail: email, password: password)
      
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
      _ = try await auth.signIn(withEmail: email, password: password)
      
      Analytics.logEvent("sign_in", parameters: ["anonymous": false])
      
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  func signInAnonymously(dismiss: DismissAction? = nil) async {
    do {
      _ = try await auth.signInAnonymously()

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
      try await Task {
        try await user.delete()
      }.value

      Analytics.logEvent("account_deleted", parameters: [:])

      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
