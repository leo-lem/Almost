// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct InsightDetailView: View {
  @State private var insight: Insight
  @Environment(\.dismiss) private var dismiss
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session
  
  public var body: some View {
    VStack {
      Text(insight.timestamp.formatted(date: .abbreviated, time: .omitted))
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
      
      HStack {
        if settings.moodEnabled {
          Text(insight.mood.rawValue)
            .font(.headline)
            .padding()
            .background(Color.secondary.opacity(0.2))
            .clipShape(Capsule())
        }
        
        Spacer()
        
        if settings.favoritesEnabled {
          AsyncButton {
            insight.isFavorite.toggle()
            await insight.save()
          } label: {
            insight.isFavorite
            ? Label("A Favorite!", systemImage: "star.fill")
            : Label("Not a Favorite!", systemImage: "star")
          }
          .foregroundStyle(Color.accentColor)
          .labelStyle(.stacked)
          .buttonStyle(.bordered)
        }
      }
      
      ScrollView {
        Text(insight.content)
          .font(.body)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      Spacer()
      NavigationLink {
        EditInsightView($insight)
      } label: {
        Label("Edit this insight", systemImage: "pencil")
          .frame(maxWidth: .infinity)
      }
      .tint(.yellow)
      .buttonStyle(.borderedProminent)
      
      AsyncButton { await insight.delete(dismiss: dismiss) } label: {
        Label("Delete this insight", systemImage: "trash")
          .frame(maxWidth: .infinity)
      }
      .tint(.red)
      .buttonStyle(.borderless)
    }
    .padding()
    .navigationTitle(insight.title ?? "Your Insight 💭")
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
        title: "",
        content: "This is an example insight.\n It should show up in the detail view.",
        mood: .mindBlown
      )
    )
  }
  .preview()
}
