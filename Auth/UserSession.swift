// Created by Leopold Lemmermann on 23.07.25.

import FirebaseAuth
import SwiftUI

@MainActor
@Observable
public final class UserSession {
  public var state = State.loading
  public var userID: String?

  private let auth = Auth.auth()
  private var listener: AuthStateDidChangeListenerHandle!

  public init() {
    listener = auth.addStateDidChangeListener { _, user in
      self.state = if let user { .signedIn(user) } else { .signedOut }
      self.userID = user?.uid
    }
  }

  deinit {
    // i cannot figure out how to do this with MainActor
//    auth.removeStateDidChangeListener(self.listener)
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

  var canAddInsights: Bool {
    if case let .signedIn(user) = state { true } else { false }
  }

  func signUp(
    email: String, password: String, dismiss: DismissAction? = nil
  ) async {
    do {
      // this is ridiculous, but i have found no better way
      try await Task { [auth] in try await Task.detached {
          _ = try await auth.createUser(withEmail: email, password: password)
      }.value}.value
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
      dismiss?()
    } catch {
      state = .error(error.localizedDescription)
    }
  }

  func signOut() {
    do {
      try auth.signOut()
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
