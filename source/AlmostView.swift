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
    .accentColor(.accent)
    .environment(session)
    .environment(config)
    .animation(.default, value: session.userID)
  }
  
  public init() {}
}

#Preview {
  AlmostView()
    .firebase()
}
