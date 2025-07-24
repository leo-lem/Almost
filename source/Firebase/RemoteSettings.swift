// Created by Leopold Lemmermann on 24.07.25.

import FirebaseRemoteConfig
import SwiftUI

@Observable final class RemoteSettings {
  let config = RemoteConfig.remoteConfig()

  var moodPickerEnabled: Bool { config["mood_picker_enabled"].boolValue }
  var analyticsEnabled: Bool { config["analytics_enabled"].boolValue }
  var favoritesEnabled: Bool { config["favorites_enabled"].boolValue }

  init() {
    config.setDefaults(fromPlist: "RemoteConfig")
    config.fetchAndActivate { status, _ in
      print("Remote Config activated: \(status == .successFetchedFromRemote)")
    }
  }
}
