// Created by Leopold Lemmermann on 07.03.26.

import FirebaseAnalytics
import FirebaseFirestore
import struct SwiftUI.Binding

@MainActor
@Observable
public final class Repository {
  public private(set) var almosts: [Almost] = []
  public private(set) var adjustments: [Adjustment] = []

  private var almostsListener: ListenerRegistration?
  private var adjustmentsListener: ListenerRegistration?

  private let auth: Authentication,
              config: Settings,
              firestore = Firestore.firestore()

  public init(_ auth: Authentication, _ config: Settings) {
    self.auth = auth
    self.config = config

    sync()
  }
}

public extension Repository {
  var userId: String? { localOnly ? nil : auth.userId }
  
  var localOnly: Bool { config.localOnly }
  var maxActiveAdjustments: Int { config.maxActiveAdjustments }
  var showRecentAlmosts: Bool { config.showRecentAlmosts }
  var minimumPatternScore: Int { 10 }
}

public extension Repository {
  func binding<T: Storable>(for id: T.ID) -> Binding<T> {
    let initial: T? =
    if T.self == Almost.self {
      almosts.first { $0.id == id } as? T
    } else if T.self == Adjustment.self {
      adjustments.first { $0.id == id } as? T
    } else {
      nil
    }

    precondition(initial != nil, "Unsupported or missing storable type: \(T.self)")

    return Binding {
      if T.self == Almost.self {
        return (self.almosts.first { $0.id == id } as? T) ?? initial!
      }

      if T.self == Adjustment.self {
        return (self.adjustments.first { $0.id == id } as? T) ?? initial!
      }

      return initial!
    } set: { newValue in
      if let almost = newValue as? Almost,
         let index = self.almosts.firstIndex(where: { $0.id == almost.id }) {
        self.almosts[index] = almost
      } else if let adjustment = newValue as? Adjustment,
                let index = self.adjustments.firstIndex(where: { $0.id == adjustment.id }) {
        self.adjustments[index] = adjustment
      } else {
        assertionFailure("Unsupported storable type: \(T.self)")
      }
    }
  }
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
  private func sync() {
    withObservationTracking {
      _ = auth.userId
      _ = config.localOnly
    } onChange: { [weak self] in
      Task { @MainActor in
        self?.sync()
      }
    }

    detachListeners()

    guard let userId else { return }

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
