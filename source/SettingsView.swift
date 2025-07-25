// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI
import SwiftUIExtensions

struct SettingsView: View {
  @Environment(Settings.self) private var settings

  var body: some View {
    Form {
      Section {
        Toggle(isOn: Binding {
          settings.analyticsEnabled
        } set: {
          settings.analyticsEnabled = $0
        }) {
          Label("Enable Analytics", systemImage: "chart.bar.xaxis")
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
    .presentationDetents([.medium])
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
