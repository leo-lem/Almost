// Created by Leopold Lemmermann on 21.07.25.

import FirebaseAuth

public final class UserSession: ObservableObject {
  @Published public private(set) var user = Auth.auth().currentUser
  public var isSignedIn: Bool { user?.uid != nil }
  
  private var handle: AuthStateDidChangeListenerHandle?

  public init() {
    handle = Auth.auth().addStateDidChangeListener { self.user = $1 }
  }

  deinit {
    if let handle { Auth.auth().removeStateDidChangeListener(handle) }
  }
}
