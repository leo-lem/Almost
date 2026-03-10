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
    if !self.defaults.exists("analyticsEnabled") {
      analyticsEnabled = defaults.bool(forKey: "analyticsEnabled")
      Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }

    aiEnabled = self.defaults.exists("aiEnabled") ? defaults.bool(forKey: "aiEnabled") : true
    localOnly = self.defaults.exists("localOnly") ? defaults.bool(forKey: "localOnly") : false
    maxActiveAdjustments = self.defaults.exists("maxActiveAdjustments")
      ? defaults.integer(forKey: "maxActiveAdjustments")
      : 2
    showRecentAlmosts = self.defaults.exists("showRecentAlmosts") ? defaults.bool(forKey: "showRecentAlmosts") : false

    config.setDefaults([
      "analytics_enabled": analyticsEnabled as NSObject,
      "ai_enabled": aiEnabled as NSObject,
      "local_only": localOnly as NSObject,
      "max_active_adjustments": maxActiveAdjustments as NSObject,
      "show_recent_almosts": showRecentAlmosts as NSObject
    ])

    config.fetchAndActivate { _, _ in
      Task { @MainActor in
        guard !self.defaults.bool(forKey: "remoteConfigFetched") else { return }

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

        self.defaults.set(true, forKey: "remoteConfigFetched")
      }
    }
  }
}

private extension UserDefaults {
  func exists(_ key: String) -> Bool {
    object(forKey: key) != nil
  }
}
