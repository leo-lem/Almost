// Created by Leopold Lemmermann on 23.07.25.

import FirebaseFirestore
import SwiftUI

public struct JourneyView: View {
  @FirestoreQuery private var journey: [Insight]

  public var body: some View {
    List {
        if journey.isEmpty {
          Text("Add an insight to start your journey")
            .foregroundColor(.secondary)
        } else {
          ForEach(journey) { insight in
            NavigationLink(destination: InsightDetailView(insight)) {
              HStack {
                if let mood = insight.mood { Text(mood.rawValue) }

                if let title = insight.title, !title.isEmpty {
                  Text(title.prefix(100))
                } else {
                  Text(insight.content.prefix(100))
                }
              }
            }
          }
        }
    }
  }

  public init(userID: String) {
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
