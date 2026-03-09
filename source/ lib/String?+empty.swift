// Created by Leopold Lemmermann on 09.03.26.

public extension String? {
  var empty: String {
    get { self ?? "" }
    set { self = newValue.isEmpty ? nil : newValue }
  }
}
