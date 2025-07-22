// Created by Leopold Lemmermann on 19.02.25.

import Auth
import FirebaseAnalytics
import SwiftUI

public struct AlmostView: View {
  @State var signingIn = false
  
  @Dependency(\.userSession) var session

  public var body: some View {
    VStack {
      Text("Welcome to Almost?!")
        .onAppear { signingIn = !session.isSignedIn() }
        .sheet(isPresented: $signingIn, content: AuthView.init)
      
      if session.isSignedIn() { // TODO: enable update
        Button("Sign out") { try? session.signOut() }
      } else {
        Button("Sign in") { signingIn = true }
      }
    }
  }

  public init() {}
}

#Preview {
  AlmostView()
}
