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
              VStack(alignment: .leading) {
                Text(insight.content.prefix(100))
                  .font(.body)
                HStack {
                  if let mood = insight.mood {
                    Text(mood.rawValue)
                  }
                  Spacer()
                  Text(insight.createdAt
                    .formatted(date: .abbreviated, time: .shortened))
                  .font(.caption)
                  .foregroundColor(.gray)
                }
              }
            }
          }
        }
    }
    .refreshable {
      // do nothing, just for good feeling :)
      try? await Task.sleep(for: .seconds(1))
    }
  }

  public init(userID: String) {
    _journey = FirestoreQuery(
      collectionPath: "users/\(userID)/insights",
      predicates: [.order(by: "createdAt", descending: true)]
    )
  }
}

#Preview {
  NavigationView {
    JourneyView(userID: "anonymous")
  }
}
