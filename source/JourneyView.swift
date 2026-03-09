// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct JourneyView: View {
  @State private var showAllAdjustments = false

  @Environment(Repository.self) private var repo

  public var body: some View {
    List {
      Section {
        if repo.topAdjustments.isEmpty {
          Text(.captureAFewAlmostsAndReviewAPatternToCreateYourFirstAdjustment)
            .cardStyle()
        }

        ForEach(adjustments, id: \.id) { adjustment in
          NavigationLink {
            PatternView(repo.pattern(for: adjustment))
              .padding()
          } label: {
            AdjustmentCard(repo.binding(for: adjustment.id))
          }
        }

        if repo.orderedAdjustments.count > repo.maxActiveAdjustments {
          Button(
            showAllAdjustments ? .showFewerAdjustments : .showAllAdjustments,
            systemImage: showAllAdjustments ? "chevron.up" : "chevron.down"
          ) { showAllAdjustments.toggle() }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        NavigationLink { ReviewView() } label: {
          VStack(alignment: .leading) {
            Text(.reviewPatternsInAlmosts)
              .font(.headline)
            Text(.newPatterns(repo.openPatterns.count))
              .foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity)
          .cardStyle(.accent.opacity(0.75))
        }
      }
      .animation(.default, value: adjustments)

      if !almosts.isEmpty {
        Section {
          ForEach(almosts, id: \.id) { almost in
            AlmostRow(repo.binding(for: almost.id))
          }
        } header: {
          Text(.recentAlmosts)
            .font(.headline)
        }
        .animation(.default, value: repo.recentAlmosts)
      }

      Spacer()
    }
    .listStyle(.plain)
    .overlay(alignment: .bottom) { QuickCaptureBar().padding() }
    .navigationTitle(.yourJourneyThroughAlmost)
    .navigationBarTitleDisplayMode(.inline)
    .trackScreen("JourneyView")
  }

  public init() {}
}

private extension JourneyView {
  var almosts: [Almost] { Array(repo.recentAlmosts.prefix(3)) }
  var adjustments: [Adjustment] { showAllAdjustments ? repo.orderedAdjustments : repo.topAdjustments }
}

#Preview {
  NavigationStack {
    JourneyView()
  }
  .firebase()
}
