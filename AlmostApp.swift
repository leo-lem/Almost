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
          let granted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
          if granted == true {
            UIApplication.shared.registerForRemoteNotifications()
          }
        }
    }
  }

  public init() {
    FirebaseApp.configure()
    try? Tips.configure()
  }
}
