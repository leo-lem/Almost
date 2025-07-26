// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import FirebaseRemoteConfig
import SwiftUI

@MainActor
@Observable
public final class Settings {
  public var moodEnabled: Bool {
    get { defaults.exists("moodEnabled") ? defaults.bool(forKey: "moodEnabled") : true }
    set { UserDefaults.standard.set(newValue, forKey: "moodEnabled") }
  }
  public var favoritesEnabled: Bool {
    get { defaults.exists("favoritesEnabled") ? defaults.bool(forKey: "favoritesEnabled") : true }
    set { UserDefaults.standard.set(newValue, forKey: "favoritesEnabled") }
  }

  public var analyticsEnabled: Bool {
    get { defaults.exists("analyticsEnabled") ? defaults.bool(forKey: "analyticsEnabled") : true }
    set {
      UserDefaults.standard.set(newValue, forKey: "analyticsEnabled")
      Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }
  }

  private let config = RemoteConfig.remoteConfig()
  private let defaults = UserDefaults.standard

  public init() {
    config.setDefaults([
      "mood_picker_enabled": moodEnabled as NSObject,
      "favorites_enabled": favoritesEnabled as NSObject,
      "analytics_enabled": analyticsEnabled as NSObject
    ])

    config.fetchAndActivate { _, _ in
      Task { @MainActor in
        if !self.defaults.exists("moodEnabled") {
          self.moodEnabled = self.config["mood_picker_enabled"].boolValue
        }

        if !self.defaults.exists("favorites_enabled") {
          self.favoritesEnabled = self.config["favorites_enabled"].boolValue
        }

        if !self.defaults.exists("favorites_enabled") {
          self.analyticsEnabled = self.config["analytics_enabled"].boolValue
        }
      }
    }
  }
}

extension UserDefaults {
  public func exists(_ key: String) -> Bool { object(forKey: key) != nil }
}
