// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI

public struct InsightDetailView: View {
  public let insight: Insight

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        header
        
        if let title = insight.title {
          Text(title)
            .font(.title2)
            .fontWeight(.semibold)
        }
        
        Text(insight.content)
          .font(.body)
          .fixedSize(horizontal: false, vertical: true)
        
        Spacer()
      }
      .padding()
    }
    .navigationTitle("Insight")
    .navigationBarTitleDisplayMode(.inline)
  }

  @ViewBuilder
  private var header: some View {
    HStack(spacing: 8) {
      if let mood = insight.mood {
        Text(mood.rawValue)
          .font(.headline)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(Color.secondary.opacity(0.1))
          .clipShape(Capsule())
      }

      if insight.isFavorite {
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
      }

      Spacer()

      Text(insight.timestamp.formatted(date: .abbreviated, time: .omitted))
        .font(.caption)
        .foregroundColor(.gray)
    }
  }
  
  public init(_ insight: Insight) {
    self.insight = insight
  }
}

#Preview {
  NavigationStack {
    InsightDetailView(
      Insight(title: "First Insight", content: "Hello", mood: .mindBlown)
    )
  }
}
