// Created by Leopold Lemmermann on 25.07.25.

import FirebaseAnalytics
import FirebaseRemoteConfig
import SwiftUI

@MainActor
@Observable
public final class Settings {
  public var analyticsEnabled = true {
    didSet {
      defaults.set(analyticsEnabled, forKey: "analyticsEnabled")
      Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }
  }

  public var aiEnabled = true {
    didSet { defaults.set(aiEnabled, forKey: "aiEnabled") }
  }

  public var localOnly = false {
    didSet { defaults.set(localOnly, forKey: "localOnly") }
  }

  public var maxActiveAdjustments = 2 {
    didSet { defaults.set(maxActiveAdjustments, forKey: "maxActiveAdjustments") }
  }

  public var showRecentAlmosts = false {
    didSet { defaults.set(showRecentAlmosts, forKey: "showRecentAlmosts") }
  }

  private let config = RemoteConfig.remoteConfig()
  private let defaults = UserDefaults.standard

  public init() {
    config.setDefaults([
      "analytics_enabled": analyticsEnabled as NSObject,
      "ai_enabled": aiEnabled as NSObject,
      "local_only": localOnly as NSObject,
      "max_active_adjustments": maxActiveAdjustments as NSObject,
      "show_recent_almosts": showRecentAlmosts as NSObject
    ])

    Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)

    config.fetchAndActivate { _, _ in
      Task { @MainActor in
        if !self.defaults.exists("analyticsEnabled") {
          self.analyticsEnabled = self.config["analytics_enabled"].boolValue
        }

        if !self.defaults.exists("aiEnabled") {
          self.aiEnabled = self.config["ai_enabled"].boolValue
        }

        if !self.defaults.exists("localOnly") {
          self.localOnly = self.config["local_only"].boolValue
        }

        if !self.defaults.exists("maxActiveAdjustments") {
          self.maxActiveAdjustments = self.config["max_active_adjustments"].numberValue.intValue
        }

        if !self.defaults.exists("showRecentAlmosts") {
          self.showRecentAlmosts = self.config["show_recent_almosts"].boolValue
        }
      }
    }
  }
}

private extension UserDefaults {
  func exists(_ key: String) -> Bool {
    object(forKey: key) != nil
  }
}
