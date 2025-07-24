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
    List {
      InsightsList(insights: insights, placeholder: Text(
          session.userID == nil
          ? "Sign in to start your Journey!"
          : fav
          ? "No favorite insights yet."
          : "Add an insight to start your journey")
      )

      Section {
        AddInsightButton()
          .listRowSeparator(.hidden)
          .frame(maxWidth: .infinity, alignment: .center)
          .popoverTip(AddInsightTip())
      } header: {
        if !insights.isEmpty {
          Text(" ")
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        if settings.favoritesEnabled {
          Toggle(isOn: $fav) {
            Image(systemName: fav ? "star.fill" : "star")
          }
          .toggleStyle(.button)
          .labelStyle(.iconOnly)
          .popoverTip(SwitchViewTip())
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.background)
    .animation(.easeInOut(duration: 0.3), value: insights)
    .animation(.default, value: fav)
    .onAppear { updateInsights() }
    .onChange(of: fav) { updateInsights(fav: $1) }
    .onChange(of: session.userID) { updateInsights($1) }
    .trackScreen("JourneyView")
  }

  public init() {}

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
  NavigationView {
    JourneyView()
  }
  .preview()
}
