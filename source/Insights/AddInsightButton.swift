// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AddInsightButton: View {
  @State private var addingInsight = false
  @State private var insight = Insight(userID: "")
  @Environment(UserSession.self) private var session
  
  public var body: some View {
    Button {
      guard let userID = session.userID else { return }
      insight = Insight(userID: userID)
      addingInsight = true
      UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    } label: {
      Label("Add Insight", systemImage: "plus.circle.fill")
    }
    .tint(.accentColor)
    .disabled(!session.canAddInsights)
    .font(.title2.bold())
    .foregroundStyle(Color.background)
    .padding()
    .background(Color.accentColor, in: .capsule)
    .sheet(isPresented: $addingInsight) {
      NavigationStack {
        EditInsightView($insight)
      }
    }
  }
  
  public init() {}
}

#Preview {
  AddInsightButton()
    .firebase()
}
