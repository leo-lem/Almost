// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var addingInsight = false
  @State private var session = UserSession()

  public var body: some View {
    NavigationStack {
      Group {
        if let userID = session.userID {
          JourneyView(userID: userID)
            .sheet(isPresented: $addingInsight) {
              if case .signedIn = session.state {
                NewInsightView()
              }
            }
        } else {
          Text("Sign in to start your Journey!")
        }
      }
      .navigationTitle("Almost? Your Journey!")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          AuthenticationButton()
        }

        ToolbarItem(placement: .primaryAction) {
          Button("Add Insight") { addingInsight = true }
            .buttonStyle(.borderedProminent)
            .disabled(!session.canAddInsights)
        }
      }
    }
    .environment(session)
    .animation(.default, value: session.userID)
  }

  public init() {}
}

#Preview {
  AlmostView()
}
