// Created by Leopold Lemmermann on 25.07.25.

extension Insight {
  static var example: Insight {
    Insight(
      userID: "",
      title: "This is a title",
      content: "This is an example insight.\n It should show up in the detail view.",
      mood: .mindBlown,
      isFavorite: .random()
    )
  }
}
