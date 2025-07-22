// Created by Leopold Lemmermann on 20.05.23.

import App
import Firebase
import SwiftUI

@main
struct AlmostApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      AlmostView()
    }
  }
}
