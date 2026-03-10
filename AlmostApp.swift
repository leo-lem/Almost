// Created by Leopold Lemmermann on 20.05.23.

import Firebase
import SwiftUI
import TipKit
import UIKit
import UserNotifications

@main
public struct AlmostApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  public var body: some Scene {
    WindowGroup {
      AlmostView()
        .task {
          let center = UNUserNotificationCenter.current()
          let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])

          if granted == true {
            await MainActor.run {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }
        }
    }
  }

  public init() {
    FirebaseApp.configure()
    try? Tips.configure()
  }
}
