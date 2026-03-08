// Created by Leopold Lemmermann on 07.03.26.

import FirebaseAnalytics
import FirebaseFirestore

@MainActor
@Observable
public final class Repository {
  public private(set) var almosts: [Almost] = []
  public private(set) var adjustments: [Adjustment] = []

  private var userId: String?
  private var almostsListener: ListenerRegistration?
  private var adjustmentsListener: ListenerRegistration?

  private let firestore = Firestore.firestore()

  public init() {}
}

public extension Repository {
  func save<T: Storable>(_ storable: T) async throws {
    guard let userId else { return saveLocally(storable) }

    try await Analytics.logFailableEvent("save_\(T.analyticsName)", parameters: storable.parameters) {
      var data = try Firestore.Encoder().encode(storable)
      data.removeValue(forKey: "id")

      try await firestore
        .collection("users")
        .document(userId)
        .collection(T.collectionName)
        .document(storable.id)
        .setData(data)
    }
  }

  func delete<T: Storable>(_ storable: T) async throws {
    guard let userId else { return deleteLocally(storable) }

    try await Analytics.logFailableEvent("delete_\(T.analyticsName)") {
      try await firestore
        .collection("users")
        .document(userId)
        .collection(T.collectionName)
        .document(storable.id)
        .delete()
    }
  }

  private func saveLocally<T: Storable>(_ storable: T) {
    switch storable {
    case let almost as Almost:
      if let index = almosts.firstIndex(where: { $0.id == almost.id }) {
        almosts[index] = almost
      } else {
        almosts.insert(almost, at: 0)
      }

    case let adjustment as Adjustment:
      if let index = adjustments.firstIndex(where: { $0.id == adjustment.id }) {
        adjustments[index] = adjustment
      } else {
        adjustments.insert(adjustment, at: 0)
      }

    default:
      assertionFailure("Unsupported storable type: \(T.self)")
    }
  }

  private func deleteLocally<T: Storable>(_ storable: T) {
    switch storable {
    case let almost as Almost:
      almosts.removeAll { $0.id == almost.id }

    case let adjustment as Adjustment:
      adjustments.removeAll { $0.id == adjustment.id }

    default:
      assertionFailure("Unsupported storable type: \(T.self)")
    }
  }
}

extension Repository {
  public func updateSync(for userId: String?) {
    self.userId = userId

    detachListeners()

    guard let userId else {
      almosts = []
      adjustments = []
      return
    }

    almostsListener = firestore
      .collection("users")
      .document(userId)
      .collection("almosts")
      .order(by: "createdAt", descending: true)
      .addSnapshotListener { [weak self] snapshot, error in
        guard error == nil, let snapshot else { return }

        self?.almosts = snapshot.documents.compactMap { document in
          do {
            var data = document.data()
            data["id"] = document.documentID
            return try Firestore.Decoder().decode(Almost.self, from: data)
          } catch {
            return nil
          }
        }
      }

    adjustmentsListener = firestore
      .collection("users")
      .document(userId)
      .collection("adjustments")
      .order(by: "createdAt", descending: true)
      .addSnapshotListener { [weak self] snapshot, error in
        guard error == nil, let snapshot else { return }

        self?.adjustments = snapshot.documents.compactMap { document in
          do {
            var data = document.data()
            data["id"] = document.documentID
            return try Firestore.Decoder().decode(Adjustment.self, from: data)
          } catch {
            return nil
          }
        }
      }
  }

  private func detachListeners() {
    almostsListener?.remove()
    adjustmentsListener?.remove()
    almostsListener = nil
    adjustmentsListener = nil
  }
}
