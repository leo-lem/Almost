// Created by Leopold Lemmermann on 23.07.25.

import FirebaseFirestore
import SwiftUI
import SwiftUIExtensions

public struct JourneyView: View {
  @FirestoreQuery(collectionPath: "insights") var insights: [Insight]
  @AppStorage("fav") private var fav = false
  @Environment(UserSession.self) private var session
  @Environment(Settings.self) private var settings
  
  public var body: some View {
    List {
      if let userID = session.userID {
        if insights.isEmpty {
          Text("Add an insight to start your journey")
            .foregroundColor(.secondary)
        }
        
        insightsList(userID: userID)
      } else {
        Text("Sign in to start your Journey!")
      }
      
      AddInsightButton()
    }
    .id(session.userID)
    .animation(.default, value: insights)
    .animation(.default, value: fav)
    .onAppear { updateInsights() }
    .onChange(of: fav) { updateInsights(fav: $1) }
    .onChange(of: session.userID) { updateInsights($1) }
    .toolbar {
      if settings.favoritesEnabled {
        Toggle(isOn: $fav) {
          Label("Favorites", systemImage: "star")
        }
      }
    }
    .trackScreen("JourneyView")
  }
  
  public init() {}
  
  @ViewBuilder
  private func insightsList(userID: String) -> some View {
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
  
  @ViewBuilder
  private func insightsListEntry(_ insight: Insight) -> some View {
    HStack {
      if settings.favoritesEnabled {
        AsyncButton {
          var insight = insight
          insight.isFavorite.toggle()
          await insight.save()
        } label: {
          insight.isFavorite
          ? Label("A Favorite!", systemImage: "star.fill")
          : Label("Not a Favorite!", systemImage: "star")
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderless)
      }
      
      if settings.moodEnabled {
        Text(insight.mood.rawValue)
      }
      
      Text((insight.title ?? insight.content).prefix(100))
    }
  }
  
  private func updateInsights(_ userID: String? = nil, fav: Bool? = nil) {
    $insights.predicates = [
      .where("userID", isEqualTo: userID ?? session.userID ?? ""),
      .order(by: "timestamp", descending: true)
    ]
    
    if fav ?? self.fav {
      $insights.predicates += [.where("isFavorite", isEqualTo: true)]
    }
  }
}

#Preview {
  NavigationView {
    JourneyView()
  }
  .preview()
}
