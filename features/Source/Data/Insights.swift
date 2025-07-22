// Created by Leopold Lemmermann on 22.07.25.

@_exported import Dependencies
import FirebaseFirestore

public struct Insights: Sendable {
  public var fetch: @Sendable (_ userID: String) async throws -> [Insight]
  public var save: @Sendable (_ insight: Insight) async throws -> Void
  public var delete: @Sendable (_ insight: Insight) async throws -> Void
}

extension Insights: DependencyKey {
// Firebase does not work in previews because it requires a network connection and specific configurations.
// This workaround provides a mock implementation to enable previews without runtime errors.
#if !targetEnvironment(simulator)
  public static let liveValue = Insights(
    fetch: { userID in
      let snapshot = try await Firestore.firestore()
        .collection("insights")
        .whereField("userID", isEqualTo: userID)
        .order(by: "createdAt", descending: true)
        .getDocuments()

      return try snapshot.documents.map { try $0.data(as: Insight.self) }
    },
    save: { insight in
      try Firestore.firestore()
        .collection("insights")
        .document(insight.id)
        .setData(from: insight)
    },
    delete: { insight in
      try await Firestore.firestore()
        .collection("insights")
        .document(insight.id)
        .delete()
    }
  )
#else
  public static let liveValue = Insights.previewValue
#endif

  public static let previewValue = Insights(
    fetch: { _ in [] },
    save: { print("Saving insight: \($0)") },
    delete: { print("Deleting insight: \($0)") }
  )
}

extension DependencyValues {
  public var insights: Insights {
    get { self[Insights.self] }
    set { self[Insights.self] = newValue }
  }
}
