// Created by Leopold Lemmermann on 23.07.25.

import FirebaseFirestore
import SwiftUI
import SwiftUIExtensions
import TipKit

public struct JourneyView: View {
  @Environment(Authentication.self) private var session
  @Environment(Settings.self) private var settings

  public var body: some View {
    VStack {
      List {
        
      }
      .scrollContentBackground(.hidden)

      Spacer()
        .popoverTip(AddInsightTip())
    }
    .background(Color.background)
    .navigationTitle("Your Journey 🌱")
    .trackScreen("JourneyView")
  }

  public init() {}

  private var placeholder: Text {
    if session.userId == nil {
      Text("Sign in to start your Journey!")
    } else {
      Text("Add an insight to start your journey")
    }
  }
}

private struct SwitchViewTip: Tip {
  var title: Text { Text("Filter by Favorites") }
  var message: Text { Text("Toggle here to show only your marked insights.") }
  var image: Image? { Image(systemName: "slider.horizontal.3") }
}

private struct AddInsightTip: Tip {
  var title: Text { Text("Create Your First Insight") }
  var message: Text { Text("Tap here to reflect on something you nearly accomplished.") }
  var image: Image? { Image(systemName: "plus.circle") }
}

#Preview {
  NavigationStack {
    JourneyView()
  }
  .firebase()
}
