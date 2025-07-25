// Created by Leopold Lemmermann on 21.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AuthenticationButton: View {
  @State private var showingSettings = false
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

        Toggle(isOn: $showingSettings) {
          Label("Settings", systemImage: "gearshape.fill")
        }

        Button(role: .destructive) {
          session.signOut()
        } label: {
          Label("Sign Out", systemImage: "xmark.circle.fill")
        }
      } label: {
        Label("Signed In", systemImage: "person.crop.circle.fill")
          .labelStyle(.iconOnly)
          .foregroundColor(.accentColor)
      }
      .sheet(isPresented: $showingSettings) {
        NavigationStack {
          SettingsView()
        }
      }

    case .signedOut:
      SheetLink {
        AuthenticationView()
      } label: {
        Label("Sign In", systemImage: "person.crop.circle.badge.plus")
          .labelStyle(.iconOnly)
          .foregroundColor(.accentColor)
      }
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
