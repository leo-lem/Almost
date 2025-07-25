// Created by Leopold Lemmermann on 24.07.25.

import SwiftUI
import SwiftUIExtensions
import TipKit

public struct InsightsList: View {
  public let insights: [Insight]
  public let placeholder: Text
  @Environment(Settings.self) private var settings
  
  public var body: some View {
    if insights.isEmpty {
      Section {
        VStack(spacing: 12) {
          Image(systemName: "sparkles")
            .font(.largeTitle)
            .foregroundStyle(.tertiary)
          
          placeholder
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
      }
    }
    
    Section {
      ForEach(insights) { insight in
        NavigationLink(destination: InsightDetailView(insight)) {
          InsightRowView(insight)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
          AsyncButton { await insight.delete() } label: {
            Label("Delete", systemImage: "trash")
          }
          .tint(.red)
        }
      }
    }
  }
  
  public init(insights: [Insight], placeholder: Text) {
    self.insights = insights
    self.placeholder = placeholder
  }
}

#Preview {
  InsightsList(
    insights: [.example, .example, .example],
    placeholder: Text("Nothing to see here…")
  )
}
