// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI

public struct AuthButton: View {
  let authState: Authentication.State
  
  @State var signingIn: Bool
  @Dependency(\.authentication) var authentication
  
  public var body: some View {
    Group {
      switch authState {
      case .loading:
        ProgressView().progressViewStyle(.circular)
      case .signedIn:
        Button("Sign Out") { try? authentication.signOut() }
      case .signedOut:
        Button("Sign In (or Up)") { signingIn = true }
      }
    }
    .sheet(isPresented: $signingIn, content: AuthView.init)
    .buttonStyle(.bordered)
  }
  
  public init(_ authState: Authentication.State) {
    self.authState = authState
    _signingIn = State(initialValue: authState == .signedOut)
  }
}

#Preview("signed out") {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthButton(.signedOut) }
  }
}

#Preview("signed in") {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthButton(.signedIn("")) }
  }
}

#Preview("loading") {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthButton(.loading) }
  }
}
