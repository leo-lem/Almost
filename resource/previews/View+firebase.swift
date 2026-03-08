// Created by Leopold Lemmermann on 24.07.25.

import SwiftUI

public extension View {
  func firebase() -> some View {
    self
      .accentColor(.accent)
      .environment(Authentication())
      .environment(Settings())
      .environment(Repository())
      .environment(Intelligence())
  }
}
