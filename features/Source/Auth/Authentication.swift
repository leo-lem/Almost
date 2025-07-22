// Created by Leopold Lemmermann on 22.07.25.

@_exported import Dependencies
import FirebaseAuth

public struct Authentication: Sendable {
  public var signUp: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signIn: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signOut: @Sendable () throws -> Void,
             userIDSession: @Sendable () -> AsyncStream<String?>
  
  // !!!: no public init, so we only instantiate via dependencies
}

extension Authentication: DependencyKey {
  public static let liveValue = Authentication(
    signUp: { email, password in try await Auth.auth().createUser(withEmail: email, password: password) },
    signIn: { email, password in try await Auth.auth().signIn(withEmail: email, password: password) },
    signOut: { try Auth.auth().signOut() },
    userIDSession: { AsyncStream { continuation in
      let handle = Auth.auth().addStateDidChangeListener { _, user in continuation.yield(user?.uid) }
      continuation.yield(Auth.auth().currentUser?.uid)
    } }
  )
  
  public static let previewValue = Authentication(
    signUp: { _, _ in },
    signIn: { _, _ in },
    signOut: { },
    userIDSession: { AsyncStream { $0.yield("preview") } }
  )
}

public extension DependencyValues {
  var authentication: Authentication {
    get { self[Authentication.self] }
    set { self[Authentication.self] = newValue }
  }
}
