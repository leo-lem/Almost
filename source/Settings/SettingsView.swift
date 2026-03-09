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
        Toggle(.enableAi, systemImage: "brain",
               isOn: Binding { config.aiEnabled } set: { config.aiEnabled = $0 })
        Toggle(.localOnlyMode, systemImage: "internaldrive",
               isOn: Binding { config.localOnly } set: { config.localOnly = $0 })
      } header: {
        Label(.features, systemImage: "puzzlepiece.extension")
      }

      Section {
        Toggle(.enableAnalytics, systemImage: "chart.bar.xaxis",
               isOn: Binding { config.analyticsEnabled } set: { config.analyticsEnabled = $0})

        Toggle(.recentAlmosts, systemImage: "clock",
               isOn: Binding { config.showRecentAlmosts } set: { config.showRecentAlmosts = $0})

        Stepper(
          .activeAdjustments(config.maxActiveAdjustments),
          value: Binding { config.maxActiveAdjustments } set: { config.maxActiveAdjustments = $0 },
          in: 1...8
        )

        if session.hasAccount {
          Button(.deleteAccount, systemImage: "trash", role: .destructive) {
            deleteAccountAlertIsPresented = true
          }
          .foregroundStyle(.red)
          .alert(.areYouSureYouWantToDeleteYourAccount, isPresented: $deleteAccountAlertIsPresented) {
            AsyncButton("Delete Account", systemImage: "trash", role: .destructive) {
              try? await session.deleteAccount()
            }
          } message: {
            Text(.youWillLoseAllYourData)
          }
        }
      } header: {
        Label(.preferences, systemImage: "gear")
      }

      Section {
        Link(destination: URL(string: "https://almost.leolem.dev")!) {
          Label(.findOutMore, systemImage: "safari")
        }
        .labelStyle(.external(color: .accent, transfer: true))
        .foregroundStyle(.accent)

        Link(destination: URL(string: "https://almost.leolem.dev/privacy")!) {
          Label(.privacyPolicy, systemImage: "lock.shield")
        }
        .labelStyle(.external(color: .indigo, transfer: true))
        .foregroundStyle(.indigo)

        Link(destination: URL(string: "https://leolem.dev")!) {
          Label(.aboutMe, systemImage: "person.circle")
        }
        .labelStyle(.external(color: .green, transfer: true))
        .foregroundStyle(.green)
      } header: {
        Label(.links, systemImage: "link")
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
        Label(.development, systemImage: "hammer")
      }
#endif
    }
    .navigationTitle(.settings)
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
