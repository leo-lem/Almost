// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import FirebaseFirestore
import SwiftUI

@MainActor public extension Insight {
  func save(dismiss: DismissAction? = nil) async {
    let collection = Firestore.firestore()
      .collection("insights")

    do {
      if let id {
        try collection.document(id).setData(from: self)
      } else {
        try collection.addDocument(from: self)
      }
    } catch {
      return Analytics.logEvent("insight_save_failure", parameters: [
        "message": error.localizedDescription
      ])
    }

    if id == nil {
      Analytics.logEvent("insight_added", parameters: [
        "has_title": title != nil,
        "is_favorite": isFavorite,
        "mood": mood.rawValue
      ])
    } else {
      Analytics.logEvent("insight_updated", parameters: [
        "has_title": title != nil,
        "is_favorite": isFavorite,
        "mood": mood.rawValue
      ])
    }

    dismiss?()
  }

  func delete(dismiss: DismissAction? = nil) async {
    guard let id else { return }

    do {
      try await Firestore.firestore()
        .collection("insights")
        .document(id)
        .delete()
    } catch {
      return Analytics.logEvent("insight_delete_failure", parameters: [
        "message": error.localizedDescription
      ])
    }

    Analytics.logEvent("insight_deleted", parameters: [
      "has_title": title != nil,
      "is_favorite": isFavorite,
      "mood": mood.rawValue
    ])

    dismiss?()
  }
}
