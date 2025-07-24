// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct NewInsightView: View {
  public let userID: String?
  @State private var insight = Insight(title: "", content: "", mood: .neutral)

  public var body: some View {
    EditInsightView($insight, userID: userID)
      .trackScreen("NewInsightView")
  }

  public init(userID: String?) {
    self.userID = userID
  }
}

#Preview {
  NewInsightView(userID: nil)
}
