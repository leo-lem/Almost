// Created by Leopold Lemmermann on 22.07.25.

@_exported import Dependencies
import FirebaseAuth

public struct Authentication: Sendable {
  public var signUp: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signIn: @Sendable (_ email: String, _ password: String) async throws -> Void,
             signOut: @Sendable () throws -> Void,
             session: @Sendable () -> AsyncStream<State>
  
  // !!!: no public init, so we only instantiate via dependencies
}

extension Authentication: DependencyKey {
  public static let liveValue = Authentication(
    signUp: { email, password in try await Auth.auth().createUser(withEmail: email, password: password) },
    signIn: { email, password in try await Auth.auth().signIn(withEmail: email, password: password) },
    signOut: { try Auth.auth().signOut() },
    session: { AsyncStream { continuation in
      _ = Auth.auth().addStateDidChangeListener { _, user in
        if let id = user?.uid {
          continuation.yield(.signedIn(id))
        } else {
          continuation.yield(.signedOut)
        }
      }
      
      if let id = Auth.auth().getUserID(){
        continuation.yield(.signedIn(id))
      } else {
        continuation.yield(.signedOut)
      }
    }}
  )
  
  public static let previewValue = Authentication(
    signUp: { _, _ in },
    signIn: { _, _ in },
    signOut: { },
    session: { AsyncStream { $0.yield(.signedIn("")) } }
  )
}

public extension DependencyValues {
  var authentication: Authentication {
    get { self[Authentication.self] }
    set { self[Authentication.self] = newValue }
  }
}

public extension Authentication {
  enum State: Equatable {
    case loading
    case signedIn(String)
    case signedOut
    
    public var userID: String? {
      return if case let .signedIn(id) = self {
        id
      } else {
        nil
      }
    }
  }
}
