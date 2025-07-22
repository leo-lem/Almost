// Created by Leopold Lemmermann on 21.07.25.

@_exported import Dependencies
import FirebaseAuth

public struct UserSession: Sendable {
  public var isSignedIn: @Sendable () -> Bool,
             signUp: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signIn: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signOut: @Sendable () throws -> Void
  
  // !!!: no public init, so we only instantiate via dependencies
}

extension UserSession: DependencyKey {
  public static let liveValue = UserSession(
    isSignedIn: { Auth.auth().currentUser != nil },
    signUp: { email, password in try await Auth.auth().createUser(withEmail: email, password: password) },
    signIn: { email, password in try await Auth.auth().signIn(withEmail: email, password: password) },
    signOut: { try Auth.auth().signOut() }
  )
  
  public static let previewValue = UserSession(
    isSignedIn: { .random() },
    signUp: { _, _ in },
    signIn: { _, _ in },
    signOut: { }
  )
}

public extension DependencyValues {
  var userSession: UserSession {
    get { self[UserSession.self] }
    set { self[UserSession.self] = newValue }
  }
}
