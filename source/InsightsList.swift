// Created by Leopold Lemmermann on 24.07.25.

import SwiftUI
import SwiftUIExtensions
import TipKit

public struct InsightsList: View {
  public let insights: [Insight]
  public let placeholder: Text
  @Environment(Settings.self) private var settings

  public var body: some View {
    if insights.isEmpty {
      Section {
        VStack(spacing: 12) {
          Image(systemName: "sparkles")
            .font(.largeTitle)
            .foregroundStyle(.tertiary)

          placeholder
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
      }
    }

    Section {
      ForEach(insights) { insight in
        NavigationLink(destination: InsightDetailView(insight)) {
          insightsListEntry(insight)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
          AsyncButton { await insight.delete() } label: {
            Label("Delete", systemImage: "trash")
          }
          .tint(.red)
        }
      }
    }
  }

  @ViewBuilder
  private func insightsListEntry(_ insight: Insight) -> some View {
    HStack(spacing: 12) {
      if settings.favoritesEnabled {
        AsyncButton {
          var insight = insight
          insight.isFavorite.toggle()
          await insight.save()
          UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
          Image(systemName: insight.isFavorite ? "star.fill" : "star")
            .foregroundStyle(.yellow)
        }
        .buttonStyle(.plain)
        .popoverTip(FavoriteTip())
      }

      if settings.moodEnabled {
        Text(insight.mood.rawValue)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(insight.mood.color.opacity(0.2))
          .clipShape(Capsule())
      }

      Text((insight.title ?? insight.content).prefix(100))
        .lineLimit(2)
        .multilineTextAlignment(.leading)
    }
    .padding(.vertical, 4)
  }

  public init(insights: [Insight], placeholder: Text) {
    self.insights = insights
    self.placeholder = placeholder
  }
}

private struct FavoriteTip: Tip {
  var title: Text { Text("Mark Favorites") }
  var message: Text { Text("Use the star to highlight important insights.") }
  var image: Image? { Image(systemName: "star") }
}

#Preview {
  InsightsList(
    insights: [
      Insight(
        userID: "",
        title: "This is a title",
        content: "This is an example insight.\n It should show up in the detail view.",
        mood: .mindBlown
      ),
      Insight(
        userID: "",
        title: "This is a title",
        content: "This is an example insight.\n It should show up in the detail view.",
        mood: .mindBlown
      )
    ],
    placeholder: Text("Nothing to see here…")
  )
}
