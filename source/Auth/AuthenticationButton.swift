// Created by Leopold Lemmermann on 21.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AuthenticationButton: View {
  @State private var showingSettings = false

  @Environment(UserSession.self) private var session
  
  public var body: some View {
    if !session.syncAvailable {
      Label("No Connection", systemImage: "xmark.circle")
        .labelStyle(.iconOnly)
        .foregroundColor(.yellow.opacity(0.7))
    } else if !session.hasAccount {
      SheetLink {
        AuthenticationView()
      } label: {
        Label("Sign In", systemImage: "person.crop.circle.badge.plus")
          .labelStyle(.iconOnly)
          .foregroundColor(.accentColor)
      }
    } else {
      Menu {
        if let email = session.user?.email {
          Text(email)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }

        Toggle(isOn: $showingSettings) {
          Label("Settings", systemImage: "gearshape.fill")
        }

        Button(role: .destructive) {
          try? session.signOut()
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
    }
  }
  
  public init() {}
}

#Preview {
  NavigationStack {
    Text("Hello")
      .toolbar { AuthenticationButton() }
  }
  .firebase()
}
