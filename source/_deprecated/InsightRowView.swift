// Created by Leopold Lemmermann on 25.07.25.

import SwiftUI
import SwiftUIExtensions
import TipKit

public struct InsightRowView: View {
  @State private var insight: Insight
  @Environment(Settings.self) private var settings

  public var body: some View {
    HStack(spacing: 12) {
      Text((insight.title ?? insight.content).prefix(100))
        .font(.headline)
        .lineLimit(1)
        .multilineTextAlignment(.leading)
    }
    .padding(.vertical, 4)
  }

  public init(_ insight: Insight) {
    self.insight = insight
  }
}

private struct FavoriteTip: Tip {
  var title: Text { Text("Mark Favorites") }
  var message: Text { Text("Use the star to highlight important insights.") }
  var image: Image? { Image(systemName: "star") }
}

#Preview {
  List {
    InsightRowView(.example)
  }
  .firebase()
}
