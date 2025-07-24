// Created by Leopold Lemmermann on 24.07.25.

#if DEBUG
import SwiftUI

public extension View {
  func preview() -> some View {
    self
      .environment(UserSession())
      .environment(Settings())
  }
}

#endif
