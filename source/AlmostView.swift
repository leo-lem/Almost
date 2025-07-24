// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI
import SwiftUIExtensions

public struct AlmostView: View {
  @State private var session = UserSession()
  @State private var config = Settings()
  
  public var body: some View {
    NavigationStack {
      Group {
        JourneyView()
      }
      .navigationTitle("Almost? Your Journey!")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          AuthenticationButton()
        }
        
#if DEBUG
        ToolbarItem {
          Button("Crash") {
            fatalError("Crash triggered for Firebase Crashlytics")
          }
          .foregroundStyle(.red)
        }
#endif
      }
    }
    .environment(session)
    .environment(config)
    .animation(.default, value: session.userID)
  }
  
  public init() {}
}

#Preview {
  AlmostView()
    .preview()
}
