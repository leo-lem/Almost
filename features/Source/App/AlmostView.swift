// Created by Leopold Lemmermann on 19.02.25.

import Auth
import FirebaseAnalytics
import SwiftUI

public struct AlmostView: View {
  @State private var userID: String?

  @Dependency(\.session) var session

  public var body: some View {
    VStack(spacing: 24) {
      if let userID {
        Text("Signed in as: \(userID)")
          .font(.headline)

        // Shows email/password sign-in form after anonymous sign-in
        SignInView()
      } else {
        Text("Signing in...")
          .onAppear {
            Task {
              do {
                userID = try await session.signInAnonymously()
              } catch {
                print("Sign-in error:", error)
              }
            }
          }
      }
    }
    .padding()
  }

  public init() {}
}

#Preview {
  AlmostView()
}
