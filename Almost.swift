// Created by Leopold Lemmermann on 20.05.23.

import Firebase
import SwiftUI
import TipKit

@main
public struct AlmostApp: App {
  public var body: some Scene {
    WindowGroup {
      AlmostView()
    }
  }

  public init() {
    FirebaseApp.configure()
    try? Tips.configure()
  }
}
