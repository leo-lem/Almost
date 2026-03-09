// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var auth: Authentication
  @State private var config: Settings
  @State private var repo: Repository
  @State private var ai: Intelligence

  public var body: some View {
    NavigationStack {
      JourneyView()
        .background(Color.background)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) { AuthenticationButton() }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    .background(Color(uiColor: .systemBackground))
    .foregroundStyle(.primary)
    .accentColor(.accent)
    .environment(auth)
    .environment(config)
    .environment(repo)
    .environment(ai)
  }
  
  public init(
    _ auth: Authentication = Authentication(),
    _ config: Settings = Settings()
  ) {
    self.auth = auth
    self.config = config
    self.repo = Repository(auth, config)
    self.ai = Intelligence(config)
  }
}

#Preview {
  AlmostView()
    .firebase()
}
