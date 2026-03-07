// Created by Leopold Lemmermann on 07.03.26.

import FirebaseAnalytics
@preconcurrency import FirebaseFirestore
import Foundation
import Observation

@MainActor
@Observable
public final class AppRepository {
  public private(set) var almosts: [Almost] = []
  public private(set) var adjustments: [Adjustment] = []
  public private(set) var isSyncing = false
  public private(set) var lastErrorMessage: String?

  private let firestore = Firestore.firestore()

  private var userId: String?
  private var almostsListener: ListenerRegistration?
  private var adjustmentsListener: ListenerRegistration?

  public init() {}

  func stop() {
    detachListeners()
  }
}

public extension AppRepository {
  func setUserId(_ userId: String?) {
    guard self.userId != userId else { return }

    self.userId = userId
    detachListeners()

    almosts = []
    adjustments = []
    lastErrorMessage = nil

    guard let userId else { return }

    attachAlmostsListener(for: userId)
    attachAdjustmentsListener(for: userId)
  }
}

public extension AppRepository {
  func save(_ almost: Almost) async {
    guard let userId else { return }

    do {
      try firestore
        .collection("almosts")
        .document(almost.id)
        .setData(from: Almost.Record(almost, userId: userId))

      Analytics.logEvent("almost_saved", parameters: [
        "failure_modes_count": almost.failureModes.count,
        "triggers_count": almost.triggers.count,
        "contexts_count": almost.contexts.count,
        "states_count": almost.states.count
      ])
    } catch {
      lastErrorMessage = error.localizedDescription

      Analytics.logEvent("almost_save_failure", parameters: [
        "message": error.localizedDescription
      ])
    }
  }

  func delete(_ almost: Almost) async {
    do {
      try await firestore
        .collection("almosts")
        .document(almost.id)
        .delete()

      Analytics.logEvent("almost_deleted", parameters: [:])
    } catch {
      lastErrorMessage = error.localizedDescription

      Analytics.logEvent("almost_delete_failure", parameters: [
        "message": error.localizedDescription
      ])
    }
  }

  func save(_ adjustment: Adjustment) async {
    guard let userId else { return }

    do {
      try firestore
        .collection("adjustments")
        .document(adjustment.id)
        .setData(from: Adjustment.Record(adjustment, userId: userId))

      Analytics.logEvent("adjustment_saved", parameters: [
        "state": adjustment.state.rawValue,
        "almosts_count": adjustment.almosts.count
      ])
    } catch {
      lastErrorMessage = error.localizedDescription

      Analytics.logEvent("adjustment_save_failure", parameters: [
        "message": error.localizedDescription
      ])
    }
  }

  func delete(_ adjustment: Adjustment) async {
    do {
      try await firestore
        .collection("adjustments")
        .document(adjustment.id)
        .delete()

      Analytics.logEvent("adjustment_deleted", parameters: [:])
    } catch {
      lastErrorMessage = error.localizedDescription

      Analytics.logEvent("adjustment_delete_failure", parameters: [
        "message": error.localizedDescription
      ])
    }
  }
}

public extension AppRepository {
  var activeAdjustments: [Adjustment] {
    adjustments
      .filter { $0.state == .active }
      .sorted { $0.createdAt > $1.createdAt }
  }

  var suggestedAdjustments: [Adjustment] {
    adjustments
      .filter { $0.state == .suggested }
      .sorted { $0.createdAt > $1.createdAt }
  }

  func almosts(with ids: [Almost.ID]) -> [Almost] {
    let idSet = Set(ids)
    return almosts.filter { idSet.contains($0.id) }
  }

  func adjustments(containing almostId: Almost.ID) -> [Adjustment] {
    adjustments.filter { $0.almosts.contains(almostId) }
  }
}

private extension AppRepository {
  func detachListeners() {
    almostsListener?.remove()
    adjustmentsListener?.remove()
    almostsListener = nil
    adjustmentsListener = nil
  }

  func attachAlmostsListener(for userId: String) {
    isSyncing = true

    almostsListener = firestore
      .collection("almosts")
      .whereField("userId", isEqualTo: userId)
      .order(by: "createdAt", descending: true)
      .addSnapshotListener { [weak self] snapshot, error in
        guard let self else { return }

        if let error {
          self.lastErrorMessage = error.localizedDescription
          self.isSyncing = false
          return
        }

        guard let snapshot else {
          self.isSyncing = false
          return
        }

        self.almosts = snapshot.documents.compactMap { document in
          do {
            let record = try document.data(as: Almost.Record.self)
            return record.domain(id: document.documentID)
          } catch {
            return nil
          }
        }

        self.isSyncing = false
      }
  }

  func attachAdjustmentsListener(for userId: String) {
    isSyncing = true

    adjustmentsListener = firestore
      .collection("adjustments")
      .whereField("userId", isEqualTo: userId)
      .order(by: "createdAt", descending: true)
      .addSnapshotListener { [weak self] snapshot, error in
        guard let self else { return }

        if let error {
          self.lastErrorMessage = error.localizedDescription
          self.isSyncing = false
          return
        }

        guard let snapshot else {
          self.isSyncing = false
          return
        }

        self.adjustments = snapshot.documents.compactMap { document in
          do {
            let record = try document.data(as: Adjustment.Record.self)
            return record.domain(id: document.documentID)
          } catch {
            return nil
          }
        }

        self.isSyncing = false
      }
  }
}
