// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI

public struct AuthButton: View {
  let userID: String?
  
  @State var signingIn: Bool
  @Dependency(\.authentication) var authentication
  
  public var body: some View {
    Group {
      if userID == nil {
        Button("Sign In (or Up)") { signingIn = true }
      } else {
        Button("Sign Out") { try? authentication.signOut() }
      }
    }
    .sheet(isPresented: $signingIn, content: AuthView.init)
    .buttonStyle(.bordered)
  }
  
  public init(_ userID: String?) {
    self.userID = userID
    _signingIn = State(initialValue: userID == nil)
  }
}

#Preview("signed out") {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthButton(nil) }
  }
}

#Preview("signed in") {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthButton("preview") }
  }
}
