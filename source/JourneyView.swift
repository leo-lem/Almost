// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct JourneyView: View {
  @State private var showAllAdjustments = false
  @State private var activeLimitAlertIsPresented = false

  @Environment(Repository.self) private var repo

  public var body: some View {
    ZStack(alignment: .bottom) {
      List {
        VStack {
          adjustments

          if repo.orderedAdjustments.count > repo.maxActiveAdjustments {
            Button(
              showAllAdjustments ? "Show fewer adjustments" : "Show all adjustments",
              systemImage: showAllAdjustments ? "chevron.up" : "chevron.down"
            ) { showAllAdjustments.toggle() }
            .buttonStyle(.plain)
            .font(.subheadline.weight(.medium))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
          }

          NavigationLink { ReviewView() } label: {
            VStack(alignment: .leading) {
              Text("Review patterns")
                .font(.headline)
              Text("\(repo.openPatterns.count) new patterns")
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .cardStyle(.accent.opacity(0.25))
          }
        }

        if !repo.recentAlmosts.isEmpty {
          Section {
            ForEach(repo.recentAlmosts.prefix(3), id: \.id) { almost in
              AlmostRow(repo.binding(for: almost.id))
            }
          } header: {
            Text("Recent Almosts")
              .font(.headline)
          }
        }
      }
      .listStyle(.plain)

      QuickCaptureBar()
        .padding()
    }
    .navigationTitle("You Journey of Almost?")
    .trackScreen("JourneyView")
  }

  public init() {}
}

private extension JourneyView {
  var adjustments: some View {
    ForEach(showAllAdjustments ? repo.orderedAdjustments : repo.topAdjustments, id: \.id) { adjustment in
      NavigationLink { ReviewView(adjustment: adjustment) } label: {
        AdjustmentCard(repo.binding(for: adjustment.id))
      }
    }
    .replaceIfEmpty {
      Text("Capture a few almosts and review a pattern to create your first adjustment.")
        .padding()
        .foregroundStyle(.secondary)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
  }
}

#Preview {
  NavigationStack {
    JourneyView()
  }
  .firebase()
}
