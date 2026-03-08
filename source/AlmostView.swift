// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var session = Authentication()
  @State private var config = Settings()
  @State private var repo = Repository()
  @State private var ai = Intelligence()

  public var body: some View {
    NavigationStack {
      JourneyView()
        .background(Color.background)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) { AuthenticationButton() }
        }
    }
    .animation(.default, value: session.userId)
    .background(Color(uiColor: .systemBackground))
    .foregroundStyle(.primary)
    .accentColor(.accent)
    .environment(session)
    .environment(config)
    .environment(repo)
    .onChange(of: config.localOnly ? nil : session.userId, initial: true) { repo.updateSync(for: $1) }
    .environment(ai)
    .onChange(of: config.aiEnabled, initial: true) { ai.updateAIEnabled($1) }
  }
  
  public init() {}
}

#Preview {
  AlmostView()
    .firebase()
}
