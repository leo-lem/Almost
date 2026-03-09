// Created by Leopold Lemmermann on 24.07.25.

import SwiftUI

public extension View {
  func firebase() -> some View {
    let auth = Authentication(),
        config = Settings(),
        repo = Repository(auth, config),
        ai = Intelligence(config)

    return self
      .accentColor(.accent)
      .environment(auth)
      .environment(config)
      .environment(repo)
      .environment(ai)
  }
}
