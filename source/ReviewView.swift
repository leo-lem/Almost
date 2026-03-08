// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI
import SwiftUIExtensions

public struct ReviewView: View {
  @Environment(Repository.self) private var repo

  private let adjustment: Adjustment?

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ForEach(displayedPatterns, id: \.createdAtRange) { pattern in
          PatternView(
            pattern: pattern,
            adjustment: adjustmentFor(pattern)
          )
        }
        .replaceIfEmpty {
          Text("No new patterns. Add more almosts…")
            .padding()
            .foregroundStyle(.secondary)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
      }
      .padding()
    }
    .navigationTitle("Review")
    .trackScreen("ReviewView")
  }

  public init(adjustment: Adjustment? = nil) {
    self.adjustment = adjustment
  }
}

private extension ReviewView {
  var displayedPatterns: [Pattern] {
    if let adjustment {
      let pattern = repo.almosts(with: adjustment.almosts)
      return pattern.count >= 2 ? [pattern] : []
    }

    return repo.openPatterns
  }

  func adjustmentFor(_ pattern: Pattern) -> Adjustment? {
    if let adjustment {
      return adjustment
    }

    let ids = Set(pattern.map(\.id))
    return repo.adjustments.first { Set($0.almosts) == ids }
  }
}

#Preview {
  NavigationStack {
    ReviewView()
  }
  .firebase()
}
