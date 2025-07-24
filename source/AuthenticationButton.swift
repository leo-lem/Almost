// Created by Leopold Lemmermann on 21.07.25.
import SwiftUI

public struct AuthenticationButton: View {
  @State private var signingIn = false
  @Environment(UserSession.self) private var session

  public var body: some View {
    switch session.state {
    case .loading, .error:
      ProgressView()
        .progressViewStyle(.circular)

    case let .signedIn(user):
      Menu {
        if let email = user.email {
          Text(email)
            .font(.caption)
            .foregroundColor(.secondary)
        }

        Button("Sign Out", role: .destructive) {
          session.signOut()
        }
      } label: {
        Label("Signed In", systemImage: "person.crop.circle.fill")
          .labelStyle(.iconOnly)
          .foregroundColor(.accentColor)
      }

    case .signedOut:
      Button {
        signingIn = true
      } label: {
        Label("Sign In", systemImage: "person.crop.circle.badge.plus")
          .labelStyle(.iconOnly)
          .foregroundColor(.accentColor)
      }
      .sheet(isPresented: $signingIn, content: AuthenticationView.init)
    }
  }

  public init() {}
}

#Preview {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthenticationButton() }
  }
  .preview()
}
