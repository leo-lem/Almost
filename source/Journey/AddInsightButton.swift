// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AddInsightButton: View {
  @State private var addingInsight = false
  @State private var insight = Insight(userID: "", title: "", content: "", mood: .neutral)
  @Environment(UserSession.self) private var session

  public var body: some View {
    Button {
      if let userID = session.userID {
        insight = Insight(userID: userID, title: "", content: "", mood: .neutral)
      }
      addingInsight = true
    } label: {
      Label("Add Insight", systemImage: "plus.circle")
    }
    .sheet(isPresented: $addingInsight) {
      EditInsightView($insight)
    }
    .disabled(!session.canAddInsights)
  }

  public init() {}
}

#Preview {
  AddInsightButton()
    .preview()
}
