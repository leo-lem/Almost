// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import SwiftUI

public struct AnalyticsScreenModifier: ViewModifier {
  public let screenName: String

  public func body(content: Content) -> some View {
    content
      .onAppear {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
          AnalyticsParameterScreenName: screenName,
          AnalyticsParameterScreenClass: screenName
        ])
      }
  }
}

public extension View {
  func trackScreen(_ name: String) -> some View {
    self.modifier(AnalyticsScreenModifier(screenName: name))
  }
}
