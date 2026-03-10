// Created by Leopold Lemmermann on 09.03.26.

import Foundation

@MainActor
@Observable
public final class AppRouter {
  public enum Destination: Hashable {
    case review
  }

  public var path: [Destination] = []

  public func openReview() {
    path = [.review]
  }
}

extension Notification.Name {
  static let openReviewFromNotification = Notification.Name("openReviewFromNotification")
}
