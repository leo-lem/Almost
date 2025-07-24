// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import FirebaseRemoteConfig
import SwiftUI

@Observable public final class Settings {
  private let config = RemoteConfig.remoteConfig()

  public var moodEnabled: Bool { config["mood_picker_enabled"].boolValue }
  public var favoritesEnabled: Bool { config["favorites_enabled"].boolValue }
  public var analyticsEnabled: Bool {
    UserDefaults.standard.bool(forKey: "isAnalyticsEnabled")
  }

  public init() {
    config.setDefaults(fromPlist: "RemoteConfig")
    config.fetchAndActivate { status, _ in
      print("Remote Config activated: \(status == .successFetchedFromRemote)")
    }

#if DEBUG
    Analytics.setAnalyticsCollectionEnabled(true)
#else
    Analytics.setAnalyticsCollectionEnabled(
      UserDefaults.standard.bool(forKey: "isAnalyticsEnabled")
    )
#endif
  }
}
