// Created by Leopold Lemmermann on 08.03.26.

import Foundation

extension Almost: Storable {
  public static let analyticsName = "almost"
  public static let collectionName = "almosts"

  public var parameters: [String: Any] {
    [
      "failures_count": failures.count,
      "triggers_count": triggers.count,
      "contexts_count": contexts.count,
      "states_count": states.count
    ]
  }
}

extension Adjustment: Storable {
  public static let analyticsName = "adjustment"
  public static let collectionName = "adjustments"

  public var parameters: [String: Any] {
    [
      "state": state.rawValue,
      "almosts_count": almosts.count
    ]
  }
}
