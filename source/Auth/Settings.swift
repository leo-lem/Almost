import FirebaseAnalytics
import FirebaseRemoteConfig
import SwiftUI

@MainActor
@Observable
public final class Settings {
  public var analyticsEnabled: Bool {
    get { defaults.exists("analyticsEnabled") ? defaults.bool(forKey: "analyticsEnabled") : true }
    set {
      defaults.set(newValue, forKey: "analyticsEnabled")
      Analytics.setAnalyticsCollectionEnabled(newValue)
    }
  }

  public var aiEnabled: Bool {
    get { defaults.exists("aiEnabled") ? defaults.bool(forKey: "aiEnabled") : true }
    set { defaults.set(newValue, forKey: "aiEnabled") }
  }

  public var localOnly: Bool {
    get { defaults.exists("localOnly") ? defaults.bool(forKey: "localOnly") : false }
    set { defaults.set(newValue, forKey: "localOnly") }
  }

  private let config = RemoteConfig.remoteConfig()
  private let defaults = UserDefaults.standard

  public init() {
    config.setDefaults([
      "analytics_enabled": analyticsEnabled as NSObject,
      "ai_enabled": aiEnabled as NSObject,
      "local_only": localOnly as NSObject
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
      }
    }
  }
}

extension UserDefaults {
  public func exists(_ key: String) -> Bool { object(forKey: key) != nil }
}
