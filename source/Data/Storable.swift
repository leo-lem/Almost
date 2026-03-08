// Created by Leopold Lemmermann on 07.03.26.

import Foundation

public protocol Storable: Codable, Identifiable where ID == String {
  static var collectionName: String { get }
  static var analyticsName: String { get }

  var parameters: [String: Any] { get }
}
