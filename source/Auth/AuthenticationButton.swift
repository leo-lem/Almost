// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI

public struct AuthenticationButton: View {
  @State private var signingIn = false
  @Environment(UserSession.self) private var session

  public var body: some View {
    Group {
      switch session.state {
      case .loading, .error:
        ProgressView().progressViewStyle(.circular)

      case let .signedIn(user):
        Button { session.signOut() } label: {
          VStack {
            Text("Sign Out")
            Text(user.email ?? "Anonymous")
              .font(.caption)
          }
        }

      case .signedOut:
        Button("Sign In (or Up)") { signingIn = true }
      }
    }
    .sheet(isPresented: $signingIn, content: AuthenticationView.init)
    .buttonStyle(.bordered)
  }

  public init() {}
}

#Preview {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthenticationButton() }
  }
  .environment(UserSession())
}
