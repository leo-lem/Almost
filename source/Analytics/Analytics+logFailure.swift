// Created by Leopold Lemmermann on 08.03.26.

import FirebaseAnalytics

@MainActor
public extension Analytics {
  static func logFailure<E: Error>(_ label: String, parameters: [String: Any] = [:], error: E) {
      var parameters = parameters
      parameters["error_type"] = String(describing: type(of: error))
      parameters["error"] = error.localizedDescription
      Analytics.logEvent("\(label)_failed", parameters: parameters)
  }
}
