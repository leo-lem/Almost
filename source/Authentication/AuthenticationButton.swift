// Created by Leopold Lemmermann on 21.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AuthenticationButton: View {
  @State private var signingIn = false
  @State private var showingSettings = false

  @Environment(Authentication.self) private var session
  
  public var body: some View {
    if !session.syncAvailable {
      Label("No Connection", systemImage: "xmark.circle")
        .foregroundColor(.yellow.opacity(0.7))
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

        if session.hasAccount {
          Button(role: .destructive) {
            try? session.signOut()
          } label: {
            Label("Sign Out", systemImage: "xmark.circle.fill")
          }
        } else {
          Toggle(isOn: $signingIn) {
            Label("Sign In", systemImage: "person.crop.circle.badge.plus")
          }
        }
      } label: {
        Label("Signed In", systemImage: "person.crop.circle.fill")
      }
      .labelStyle(.iconOnly)
      .foregroundColor(.accent)
      .sheet(isPresented: $showingSettings) { SettingsView().embedInNavigationStack() }
      .sheet(isPresented: $signingIn) { AuthenticationView() }
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
