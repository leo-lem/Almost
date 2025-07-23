// Created by Leopold Lemmermann on 20.05.23.

import Firebase
import SwiftUI

@main
public struct AlmostApp: App {
  public var body: some Scene {
    WindowGroup {
      AlmostView()
    }
  }

  public init() {
    FirebaseApp.configure()
  }
}
