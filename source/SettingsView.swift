// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI
import SwiftUIExtensions

struct SettingsView: View {
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session
  @Environment(\.dismiss) private var dismiss

  @State private var deleteAccountAlertIsPresented: Bool = false

  var body: some View {
    Form {
      Section {
        Toggle(isOn: Binding { settings.moodEnabled } set: { settings.moodEnabled = $0}) {
          Label("Enable Moods", systemImage: "face.smiling")
        }
        Toggle(isOn: Binding { settings.favoritesEnabled } set: { settings.favoritesEnabled = $0}) {
          Label("Enable Favorites", systemImage: "star.fill")
        }
      } header: {
        Label("Features", systemImage: "puzzlepiece.extension")
      } footer: {
        Text("Requires restart of app")
          .foregroundStyle(.yellow)
      }

      Section {
        Toggle(isOn: Binding { settings.analyticsEnabled } set: { settings.analyticsEnabled = $0}) {
          Label("Enable Analytics", systemImage: "chart.bar.xaxis")
        }

        if session.hasAccount {
          Button(role: .destructive) { deleteAccountAlertIsPresented = true } label: {
            Label("Delete Account", systemImage: "trash")
          }
          .foregroundStyle(.red)
          .alert("Are you sure you want to delete your account?", isPresented: $deleteAccountAlertIsPresented) {
            AsyncButton(role: .destructive) { await session.deleteAccount(dismiss: dismiss) } label: {
              Label("Delete Account", systemImage: "trash")
            }
          } message: {
            Text("You will lose all your data!")
          }
        }
      } header: {
        Label("Preferences", systemImage: "gear")
      }

      Section {
        Link(destination: URL(string: "https://almost.leolem.dev")!) {
          Label("Find out more about Almost", systemImage: "safari")
        }
        .labelStyle(.external(color: .accent, transfer: true))
        .foregroundStyle(.accent)

        Link(destination: URL(string: "https://almost.leolem.dev/privacy")!) {
          Label("Privacy Stuff", systemImage: "lock.shield")
        }
        .labelStyle(.external(color: .indigo, transfer: true))
        .foregroundStyle(.indigo)

        Link(destination: URL(string: "https://leolem.dev")!) {
          Label("About Me", systemImage: "person.circle")
        }
        .labelStyle(.external(color: .green, transfer: true))
        .foregroundStyle(.green)
      } header: {
        Label("Links", systemImage: "link")
      }
    }
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.fraction(0.7)])
    .trackScreen("SettingsView")
  }
}

#Preview {
  Text("")
    .sheet(isPresented: .constant(true)) {
      NavigationStack {
        SettingsView()
      }
    }
    .firebase()
}
