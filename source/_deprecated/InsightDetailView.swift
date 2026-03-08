// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct InsightDetailView: View {
  @State private var insight: Insight
  @Environment(\.dismiss) private var dismiss
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session
  
  public var body: some View {
    VStack(spacing: 16) {
      Text(insight.timestamp.formatted(date: .abbreviated, time: .omitted))
        .font(.caption)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
      
      if let title = insight.title {
        Text(title)
          .font(.largeTitle)
          .foregroundStyle(insight.mood.color)
      }
      
      ScrollView {
        Text(insight.content)
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.vertical)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        VStack {
          Divider()
          Spacer()
          Divider()
        }
      )
      
      NavigationLink {
        EditInsightView($insight)
      } label: {
        Label("Edit this insight", systemImage: "pencil")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .foregroundColor(.background)
      
      AsyncButton { await insight.delete(dismiss: dismiss) } label: {
        Label("Delete this insight", systemImage: "trash")
          .frame(maxWidth: .infinity)
      }
      .tint(.red)
      .buttonStyle(.borderless)
    }
    .padding()
    .background(insight.mood.color.opacity(0.1))
    .navigationTitle("Your Insight 💭")
    .navigationBarTitleDisplayMode(.inline)
    .trackScreen("InsightDetailView")
  }
  
  public init(_ insight: Insight) { self.insight = insight }
}

#Preview {
  NavigationStack {
    InsightDetailView(.example)
  }
  .firebase()
}
