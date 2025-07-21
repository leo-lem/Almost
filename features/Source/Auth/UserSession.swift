// Created by Leopold Lemmermann on 21.07.25.

@_exported import Dependencies
import FirebaseAuth

public struct UserSession: Sendable {
  public var signInAnonymously: @Sendable () async throws -> String
  public var currentUserID: @Sendable () -> String?
  public var createUser: @Sendable (_ email: String, _ password: String) async throws -> String
  public var signInWithEmail: @Sendable (_ email: String, _ password: String) async throws -> String
  public var linkEmailToAnonymous: @Sendable (_ email: String, _ password: String) async throws -> String

  public init(
    signInAnonymously: @escaping @Sendable () async throws -> String,
    currentUserID: @escaping @Sendable () -> String?,
    createUser: @escaping @Sendable (String, String) async throws -> String,
    signInWithEmail: @escaping @Sendable (String, String) async throws -> String,
    linkEmailToAnonymous: @escaping @Sendable (String, String) async throws -> String
  ) {
    self.signInAnonymously = signInAnonymously
    self.currentUserID = currentUserID
    self.createUser = createUser
    self.signInWithEmail = signInWithEmail
    self.linkEmailToAnonymous = linkEmailToAnonymous
  }
}

extension UserSession: DependencyKey {
  public static let liveValue = UserSession(
    signInAnonymously: {
      let result = try await Auth.auth().signInAnonymously()
      return result.user.uid
    },
    currentUserID: {
      Auth.auth().currentUser?.uid
    },
    createUser: { email, password in
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      return result.user.uid
    },
    signInWithEmail: { email, password in
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      return result.user.uid
    },
    linkEmailToAnonymous: { email, password in
      let credential = EmailAuthProvider.credential(withEmail: email, password: password)
      guard let user = Auth.auth().currentUser else {
        throw NSError(domain: "UserSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])
      }
      let result = try await user.link(with: credential)
      return result.user.uid
    }
  )
}

public extension DependencyValues {
  var session: UserSession {
    get { self[UserSession.self] }
    set { self[UserSession.self] = newValue }
  }
}
