// Created by Leopold Lemmermann on 19.02.25.

import Auth
import Data
import FirebaseAnalytics
import SwiftUI

public struct AlmostView: View {
  @State var signingIn = false
  @State var insertError: String?

  @Dependency(\.authentication) var auth
  @Dependency(\.insights) var insights
  
  @StateObject var session = UserSession()

  public var body: some View {
    VStack(spacing: 16) {
      Text("Almost?")
        .font(.title)
        .sheet(isPresented: $signingIn, content: AuthView.init)
      
      if session.isSignedIn {
        Button("Sign Out") { try? auth.signOut() }
      } else {
        Button("Sign In") { signingIn = true }
      }
      
      if let userID = session.user?.uid {
          Button("Insert Example Insight") {
            Task {
              do {
                try await insights.save(Insight(
                  userID: userID,
                  title: "Forgot to push today’s commits",
                  content: "Didn’t realize I hadn’t pushed changes. Need to double check next time."
                ))
                insertError = nil
              } catch {
                insertError = error.localizedDescription
              }
            }
          }
        }

        if let insertError {
          Text("Insert failed: \(insertError)")
            .foregroundColor(.red)
        }
    }
    .padding()
    .onAppear { signingIn = !session.isSignedIn }
  }

  public init() {}
}

#Preview {
  AlmostView()
}
