// Created by Leopold Lemmermann on 23.07.25.

import FirebaseFirestore
import SwiftUI
import SwiftUIExtensions
import TipKit

public struct JourneyView: View {
  @FirestoreQuery(collectionPath: "insights") var insights: [Insight]
  @AppStorage("fav") private var fav = false

  @Environment(UserSession.self) private var session
  @Environment(Settings.self) private var settings

  public var body: some View {
    VStack {
      List {
        InsightsList(insights: insights, placeholder: placeholder)
      }
      .scrollContentBackground(.hidden)
      .toolbar {
        if settings.favoritesEnabled {
          ToolbarItem(placement: .topBarTrailing) {
            Toggle(isOn: $fav) {
              Label("Favorites only", systemImage: fav ? "star.fill" : "star")
            }
            .toggleStyle(.button)
            .labelStyle(.iconOnly)
            .popoverTip(SwitchViewTip())
          }
        }
      }

      Spacer()

      AddInsightButton()
        .popoverTip(AddInsightTip())
    }
    .background(Color.background)
    .animation(.easeInOut(duration: 0.3), value: insights)
    .animation(.default, value: fav)
    .onAppear { updateInsights() }
    .onChange(of: fav) { updateInsights(fav: $1) }
    .onChange(of: session.userID) { updateInsights($1) }
    .trackScreen("JourneyView")
  }

  public init() {}

  private var placeholder: Text {
    if session.userID == nil {
      Text("Sign in to start your Journey!")
    } else if fav {
      Text("No favorite insights yet.")
    } else {
      Text("Add an insight to start your journey")
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

private struct SwitchViewTip: Tip {
  var title: Text { Text("Filter by Favorites") }
  var message: Text { Text("Toggle here to show only your marked insights.") }
  var image: Image? { Image(systemName: "slider.horizontal.3") }
}

private struct AddInsightTip: Tip {
  var title: Text { Text("Create Your First Insight") }
  var message: Text { Text("Tap here to reflect on something you nearly accomplished.") }
  var image: Image? { Image(systemName: "plus.circle") }
}

#Preview {
  NavigationStack {
    JourneyView()
  }
  .firebase()
}
