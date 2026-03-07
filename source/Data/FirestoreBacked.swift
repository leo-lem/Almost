// Created by Leopold Lemmermann on 07.03.26.

import Foundation

protocol FirestoreBacked: Identifiable where ID == String {
  associatedtype Record: Codable

  static var collectionName: String { get }

  func record(userId: String) -> Record
  static func domain(from record: Record, id: String) -> Self
}
