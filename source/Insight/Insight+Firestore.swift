// Created by Leopold Lemmermann on 24.07.25.

import FirebaseAnalytics
import FirebaseFirestore
import SwiftUI

enum FirebaseError: String, LocalizedError {
  case documentNotFound = "Document not found."
  case notAuthenticated = "You need to be logged in to perform this action."

  static func unknown(_ message: String? = nil) {
    Analytics.logEvent("Unknown error", parameters: [
      "message": message ?? "No message provided"
    ])
  }
}

@MainActor public extension Insight {
  func save(
    _ userID: String?,
    dismiss: DismissAction? = nil
  ) async throws {
    guard let userID else { throw FirebaseError.notAuthenticated }

    let collection = Firestore.firestore().collection("users/\(userID)/insights")
      do {
        if let id {
          try collection.document(id).setData(from: self)
        } else {
          try collection.addDocument(from: self)
        }
      } catch {
        FirebaseError.unknown(error.localizedDescription)
      }

    if id == nil {
      Analytics.logEvent("entry_created", parameters: ["mood": mood.rawValue])
    } else {
      Analytics.logEvent("entry_edited", parameters: [
        "mood": mood.rawValue,
        "isFavorite": isFavorite
      ])
    }

    dismiss?()
  }

  func delete(
    _ userID: String?,
    dismiss: DismissAction? = nil
  ) async throws {
    guard let userID else { throw FirebaseError.notAuthenticated }
    guard let id else { throw FirebaseError.documentNotFound }

    do {
      try await Firestore.firestore()
        .collection("users/\(userID)/insights")
        .document(id)
        .delete()
    } catch {
      FirebaseError.unknown(error.localizedDescription)
    }

    Analytics.logEvent("entry_deleted", parameters: [
      "mood": mood.rawValue,
      "isFavorite": isFavorite
    ])

    dismiss?()
  }
}
