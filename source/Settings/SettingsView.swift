// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI
import SwiftUIExtensions

struct SettingsView: View {
  @Environment(Settings.self) private var config
  @Environment(Authentication.self) private var session
  @Environment(Repository.self) private var repo
  @Environment(\.dismiss) private var dismiss

  @State private var deleteAccountAlertIsPresented: Bool = false

  var body: some View {
    Form {
      Section {
        Toggle("Enable AI", systemImage: "brain",
               isOn: Binding { config.aiEnabled } set: { config.aiEnabled = $0 })
        Toggle("Local only mode [May lose data]", systemImage: "internaldrive",
               isOn: Binding { config.localOnly } set: { config.localOnly = $0 })
      } header: {
        Label("Features", systemImage: "puzzlepiece.extension")
      }

      Section {
        Toggle("Enable Analytics", systemImage: "chart.bar.xaxis",
               isOn: Binding { config.analyticsEnabled } set: { config.analyticsEnabled = $0})

        Toggle("Show Recent Almosts", systemImage: "clock",
               isOn: Binding { config.showRecentAlmosts } set: { config.showRecentAlmosts = $0})

        Stepper(
          "Active Adjustments: \(config.maxActiveAdjustments)",
          value: Binding { config.maxActiveAdjustments } set: { config.maxActiveAdjustments = $0 },
          in: 1...8
        )

        if session.hasAccount {
          Button("Delete Account", systemImage: "trash", role: .destructive) {
            deleteAccountAlertIsPresented = true
          }
          .foregroundStyle(.red)
          .alert("Are you sure you want to delete your account?", isPresented: $deleteAccountAlertIsPresented) {
            AsyncButton("Delete Account", systemImage: "trash", role: .destructive) {
              try? await session.deleteAccount()
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
          Label("Find out more", systemImage: "safari")
        }
        .labelStyle(.external(color: .accent, transfer: true))
        .foregroundStyle(.accent)

        Link(destination: URL(string: "https://almost.leolem.dev/privacy")!) {
          Label("Privacy Policy", systemImage: "lock.shield")
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

#if DEBUG
      Section {
        AsyncButton("Add Preview Almosts", systemImage: "wand.and.stars") {
          for almost in Almost.previewData {
            try? await repo.save(almost)
          }
        }

        AsyncButton("Clear Preview Data", systemImage: "trash", role: .destructive) {
          for almost in repo.almosts {
            try? await repo.delete(almost)
          }
          for adjustment in repo.adjustments {
            try? await repo.delete(adjustment)
          }
        }
      } header: {
        Label("Development", systemImage: "hammer")
      }
#endif
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
