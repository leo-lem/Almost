// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import FirebaseRemoteConfig
import SwiftUI

@MainActor
@Observable
public final class Settings {
  public var moodEnabled: Bool = true
  public var favoritesEnabled: Bool = true

  public var analyticsEnabled: Bool {
    get { UserDefaults.standard.bool(forKey: "analyticsEnabled") }
    set {
      UserDefaults.standard.set(newValue, forKey: "analyticsEnabled")
      Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }
  }

  private let config = RemoteConfig.remoteConfig()

  public init() {
    config.setDefaults([
      "mood_picker_enabled": true as NSObject,
      "favorites_enabled": true as NSObject,
      "analytics_enabled": true as NSObject
    ])
    
    config.fetchAndActivate { _, _ in
      Task { @MainActor in
        self.moodEnabled = self.config["mood_picker_enabled"].boolValue
        self.favoritesEnabled = self.config["favorites_enabled"].boolValue
      }
    }

    Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
  }
}
