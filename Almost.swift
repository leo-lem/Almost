// Created by Leopold Lemmermann on 20.05.23.

import Firebase
import FirebaseAnalytics
import SwiftUI

@main
public struct AlmostApp: App {
  @State private var session: UserSession
  @State private var config: RemoteSettings

  public var body: some Scene {
    WindowGroup {
      AlmostView()
        .environment(session)
        .environment(config)
    }
  }

  public init() {
    FirebaseApp.configure()

    session = UserSession()
    config = RemoteSettings()

#if DEBUG
    Analytics.setAnalyticsCollectionEnabled(true)
#else
    Analytics.setAnalyticsCollectionEnabled(
      UserDefaults.standard.bool(forKey: "isAnalyticsEnabled")
    )
#endif
  }
}
