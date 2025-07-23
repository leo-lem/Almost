// Created by Leopold Lemmermann on 19.02.25.

import Auth
import NewInsight
import SwiftUI

public struct AlmostView: View {
  @State var insertError: String?
  @State var authState: Authentication.State = .loading
  @State var addingInsight = false

  @Dependency(\.authentication) var auth

  public var body: some View {
    NavigationStack {
      Text("Your journey will be here")
        .navigationTitle("Almost? Your Journey!")
        .font(.title)
        .sheet(isPresented: $addingInsight) {
          if case let .signedIn(userID) = authState {
            NewInsightView(userID: userID)
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            AuthButton(authState)
          }
          ToolbarItem(placement: .primaryAction) {
            Button("Add Insight") { addingInsight = true }
              .buttonStyle(.borderedProminent)
              .disabled(authState == .signedOut || authState == .loading)
          }
        }
    }
    .task {
      for await authState in auth.session() { self.authState = authState }
    }
  }

  public init() {}
}

#Preview {
  AlmostView()
}
