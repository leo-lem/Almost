// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import SwiftUI

public extension View {
  func trackScreen(_ name: String) -> some View {
    onAppear {
      Analytics.logEvent(AnalyticsEventScreenView, parameters: [
        AnalyticsParameterScreenName: name,
        AnalyticsParameterScreenClass: name
      ])
    }
  }
}
