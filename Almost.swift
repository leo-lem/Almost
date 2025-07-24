// Created by Leopold Lemmermann on 20.05.23.

import Firebase
import SwiftUI
import TipKit

@main
public struct AlmostApp: App {
  public var body: some Scene {
    WindowGroup {
      AlmostView()
        .onAppear {
#if DEBUG
          Tips.showAllTipsForTesting()
#endif
        }
    }
  }

  public init() {
    FirebaseApp.configure()
    try? Tips.configure()
  }
}
