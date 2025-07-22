// Created by Leopold Lemmermann on 19.02.25.

import Auth
import NewInsight
import SwiftUI

public struct AlmostView: View {
  @State var insertError: String?
  @State var userID: String? = "loading..."
  @State var addingInsight = false

  @Dependency(\.authentication) var auth

  public var body: some View {
    NavigationStack {
      Text("Your journey will be here")
        .navigationTitle("Almost? Your Journey!")
        .font(.title)
        .sheet(isPresented: $addingInsight) {
          if let userID { NewInsightView(userID: userID) }
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) { AuthButton(userID) }
          ToolbarItem(placement: .primaryAction) {
            Button("Add Insight") { addingInsight = true }
              .buttonStyle(.borderedProminent)
              .disabled(userID == nil)
          }
        }
    }
    .task {
      for await userID in auth.userIDSession() { self.userID = userID }
    }
  }

  public init() {}
}

#Preview {
  AlmostView()
}
