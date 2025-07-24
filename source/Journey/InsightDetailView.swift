// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct InsightDetailView: View {
  public let userID: String?
  @State public var insight: Insight
  @State private var error: FirebaseError?
  @Environment(\.dismiss) private var dismiss

  public var body: some View {
      VStack {
        header

        ScrollView {
          Text(insight.content)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
        }

        Spacer()

          NavigationLink {
            EditInsightView($insight, userID: userID)
          } label: {
            Label("Edit this insight", image: "pencil")
              .frame(maxWidth: .infinity)
          }
          .tint(.yellow)
          .buttonStyle(.borderedProminent)

          if let error {
            Text(error.localizedDescription)
              .font(.callout)
              .foregroundStyle(.red)
          }
          AsyncButton {
            do { try await insight.delete(userID, dismiss: dismiss) } catch {}
          } label: {
            Label("Delete this insight", systemImage: "trash")
              .frame(maxWidth: .infinity)
          }
          .tint(.red)
          .buttonStyle(.borderless)
      }
      .padding()
      .navigationTitle(insight.title ?? "Your Insight 💭")
      .navigationBarTitleDisplayMode(.inline)
      .trackScreen("InsightDetailView")
  }

  @ViewBuilder
  private var header: some View {
    HStack(spacing: 8) {
      Text(insight.mood.rawValue)
        .font(.headline)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
        .clipShape(Capsule())

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
  
  public init(_ insight: Insight, userID: String?) {
    self.insight = insight
    self.userID = userID
  }
}

#Preview {
  NavigationStack {
    InsightDetailView(
      Insight(
        title: "",
        content: "This is an example insight.\n It should show up in the detail view.",
        mood: .mindBlown
      ),
      userID: nil
    )
  }
}
