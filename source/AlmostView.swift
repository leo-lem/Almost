// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var session = UserSession()
  @State private var config = Settings()
  
  public var body: some View {
    NavigationStack {
      JourneyView()
        .background(Color(uiColor: .systemBackground))
        .foregroundStyle(.primary)
        .navigationTitle("Your Journey 🌱")
        .toolbar {
          ToolbarItem(placement: .topBarLeading) { AuthenticationButton() }
        }
    }
    .animation(.default, value: session.userID)
    .accentColor(.accent)
    .environment(session)
    .environment(config)
  }
  
  public init() {}
}

#Preview {
  AlmostView()
    .firebase()
}
