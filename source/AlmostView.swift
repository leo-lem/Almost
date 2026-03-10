// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var auth: Authentication
  @State private var config: Settings
  @State private var repo: Repository
  @State private var ai: Intelligence
  @State private var router = AppRouter()

  public var body: some View {
    NavigationStack(path: $router.path) {
      JourneyView()
        .background(Color.background)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) { AuthenticationButton() }
        }
        .navigationDestination(for: AppRouter.Destination.self) { destination in
          switch destination {
          case .review: ReviewView()
          }
        }
    }
    .background(Color(uiColor: .systemBackground))
    .foregroundStyle(.primary)
    .accentColor(.accent)
    .onReceive(NotificationCenter.default.publisher(for: .openReviewFromNotification)) { _ in
      router.openReview()
    }
    .environment(auth).environment(config).environment(repo).environment(ai).environment(router)
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
