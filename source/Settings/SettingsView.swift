// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI
import SwiftUIExtensions

struct SettingsView: View {
  @Environment(Settings.self) private var settings
  @Environment(Authentication.self) private var session
  @Environment(Repository.self) private var repo
  @Environment(\.dismiss) private var dismiss

  @State private var deleteAccountAlertIsPresented: Bool = false

  var body: some View {
    Form {
      Section {
        Toggle(isOn: Binding { settings.aiEnabled } set: { settings.aiEnabled = $0}) {
          Label("Enable AI", systemImage: "brain")
        }
//        Toggle(isOn: Binding { settings.localOnly } set: { settings.localOnly = $0}) {
//          Label("Local only mode [May lose data]", systemImage: "internaldrive")
//        }
      } header: {
        Label("Features", systemImage: "puzzlepiece.extension")
      } footer: {
        Text("Requires app restart")
          .foregroundStyle(.yellow)
      }

      Section {
        Toggle(isOn: Binding { settings.analyticsEnabled } set: { settings.analyticsEnabled = $0}) {
          Label("Enable Analytics", systemImage: "chart.bar.xaxis")
        }

        Toggle(isOn: Binding { settings.showRecentAlmosts } set: { settings.showRecentAlmosts = $0}) {
          Label("Show Recent Almosts", systemImage: "clock")
        }

        Stepper(
          "Max Active Adjustments: \(settings.maxActiveAdjustments)",
          value: Binding { settings.maxActiveAdjustments } set: { settings.maxActiveAdjustments = $0 },
          in: 1...10
        )

        if session.hasAccount {
          Button(role: .destructive) { deleteAccountAlertIsPresented = true } label: {
            Label("Delete Account", systemImage: "trash")
          }
          .foregroundStyle(.red)
          .alert("Are you sure you want to delete your account?", isPresented: $deleteAccountAlertIsPresented) {
            AsyncButton(role: .destructive) { try? await session.deleteAccount() } label: {
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
        AsyncButton {
          for almost in Almost.previewData {
            try? await repo.save(almost)
          }
        } label: {
          Label("Add Preview Almosts", systemImage: "wand.and.stars")
        }

        AsyncButton(role: .destructive) {
          for almost in repo.almosts {
            try? await repo.delete(almost)
          }
          for adjustment in repo.adjustments {
            try? await repo.delete(adjustment)
          }
        } label: {
          Label("Clear Preview Data", systemImage: "trash")
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
