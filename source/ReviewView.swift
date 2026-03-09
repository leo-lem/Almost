// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI
import SwiftUIExtensions

public struct ReviewView: View {
  @Environment(Repository.self) private var repo

  public var body: some View {
    ScrollView {
      if displayedPatterns.isEmpty {
        Text(.noNewPatternsAddMoreAlmosts)
          .frame(maxWidth: .infinity)
          .cardStyle(.accent.opacity(0.1))
      }

      ForEach(displayedPatterns, id: \.createdAtRange) { pattern in
        PatternView(pattern)
          .cardStyle(.accent.opacity(0.1))
      }
    }
    .padding()
    .navigationTitle(.reviewPatternsInAlmosts)
    .trackScreen("ReviewView")
  }

  public init() {}
}

private extension ReviewView {
  var displayedPatterns: [Pattern] { repo.openPatterns }
}

#Preview {
  NavigationStack {
    ReviewView()
  }
  .firebase()
}
