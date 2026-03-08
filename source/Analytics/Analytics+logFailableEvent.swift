// Created by Leopold Lemmermann on 08.03.26.

import FirebaseAnalytics

@MainActor
public extension Analytics {
  static func logFailableEvent<T>(
    _ label: String,
    parameters: [String: Any] = [:],
    action: @MainActor () async throws -> T
  ) async rethrows -> T {
    do {
      let result = try await action()
      Analytics.logEvent(label, parameters: parameters)
      return result
    } catch {
      Analytics.logFailure("\(label)_failed", parameters: parameters, error: error)
      throw error
    }
  }

  static func logFailableEvent<T>(
    _ label: String,
    parameters: [String: Any] = [:],
    action: @MainActor () throws -> T
  ) rethrows -> T {
    do {
      let result = try action()
      Analytics.logEvent(label, parameters: parameters)
      return result
    } catch {
      Analytics.logFailure("\(label)_failed", parameters: parameters, error: error)
      throw error
    }
  }
}
