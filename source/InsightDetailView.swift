// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct InsightDetailView: View {
  @State private var insight: Insight
  @Environment(\.dismiss) private var dismiss
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session
  
  public var body: some View {
    VStack(spacing: 16) {
      Text(insight.timestamp.formatted(date: .abbreviated, time: .omitted))
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
      
      if settings.moodEnabled {
        VStack {
          Text(insight.mood.rawValue)
            .font(.system(size: 64))
            .frame(maxWidth: .infinity)
            .padding()
            .background(insight.mood.color.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
      }
      
      if settings.favoritesEnabled {
        AsyncButton {
          insight.isFavorite.toggle()
          await insight.save()
          UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
          Label(
            insight.isFavorite ? "Marked as Favorite" : "Mark as Favorite",
            systemImage: insight.isFavorite ? "star.fill" : "star"
          )
          .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
      }
      
      if let title = insight.title {
        Text(title)
          .font(.largeTitle)
      }
      
      ScrollView {
        Text(insight.content)
          .font(.body)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        VStack(spacing: 0) {
          Divider()
          Spacer()
          Divider()
        }
      )
      
      NavigationLink {
        EditInsightView($insight)
      } label: {
        Label("Edit this insight", systemImage: "pencil")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .foregroundColor(.background)
      
      AsyncButton { await insight.delete(dismiss: dismiss) } label: {
        Label("Delete this insight", systemImage: "trash")
          .frame(maxWidth: .infinity)
      }
      .tint(.red)
      .buttonStyle(.borderless)
    }
    .padding()
    .background(insight.mood.color.opacity(0.1))
    .navigationTitle("Your Insight 💭")
    .navigationBarTitleDisplayMode(.inline)
    .trackScreen("InsightDetailView")
  }
  
  public init(_ insight: Insight) { self.insight = insight }
}

#Preview {
  NavigationStack {
    InsightDetailView(
      Insight(
        userID: "",
        title: "This is a title",
        content: "This is an example insight.\n It should show up in the detail view.",
        mood: .mindBlown
      )
    )
  }
  .preview()
}
