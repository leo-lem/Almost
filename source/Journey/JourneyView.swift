// Created by Leopold Lemmermann on 23.07.25.

import FirebaseFirestore
import SwiftUI
import SwiftUIExtensions

public struct JourneyView: View {
  let userID: String?
  @FirestoreQuery private var journey: [Insight]

  public var body: some View {
    List {
      if journey.isEmpty {
        Text("Add an insight to start your journey")
          .foregroundColor(.secondary)
      } else {
        ForEach(journey) { insight in
          NavigationLink(destination: InsightDetailView(insight, userID: userID)) {
            HStack {
              Text(insight.mood.rawValue)

              if let title = insight.title, !title.isEmpty {
                Text(title.prefix(100))
              } else {
                Text(insight.content.prefix(100))
              }
            }
          }
          .swipeActions(edge: .trailing) {
            if let userID {
              AsyncButton {
                do { try await insight.delete(userID) } catch {}
              } label: {
                Label("Delete", systemImage: "trash")
              }
              .tint(.red)
            }
          }
        }
      }
    }
    .trackScreen("JourneyView")
  }

  public init(userID: String) {
    self.userID = userID
    _journey = FirestoreQuery(
      collectionPath: "users/\(userID)/insights",
      predicates: [.order(by: "timestamp", descending: true)]
    )
  }
}

#Preview {
  NavigationView {
    JourneyView(userID: "anonymous")
  }
}
