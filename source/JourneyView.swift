// Created by Leopold Lemmermann on 23.07.25.

import SwiftUI
import SwiftUIExtensions

public struct JourneyView: View {
  @State private var showAllAdjustments = false
  @State private var activeLimitAlertIsPresented = false

  @Environment(Repository.self) private var repo
  @Environment(Settings.self) private var settings

  public var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading) {
          adjustments

          if repo.orderedAdjustments.count > 2 {
            Button { showAllAdjustments.toggle() } label: {
              Label(
                showAllAdjustments ? "Show fewer adjustments" : "Show all adjustments",
                systemImage: showAllAdjustments ? "chevron.up" : "chevron.down"
              )
              .font(.subheadline.weight(.medium))
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
          }

          review
        }
        .padding()
        .background(.accent.opacity(0.25), in: RoundedRectangle(cornerRadius: 20))

        if settings.showRecentAlmosts, !repo.recentAlmosts.isEmpty {
          Section {
            ForEach(repo.recentAlmosts.prefix(3), id: \.id) { almost in
              AlmostRow(almost: Binding { almost } set: { newValue in
                Task { try? await repo.save(newValue) }
              })
            }
          } header: {
            Text("Recent Almosts")
              .font(.headline)
          }
        }
      }

      QuickCaptureBar()
    }
    .padding()
    .navigationTitle("Journey")
    .trackScreen("JourneyView")
  }

  public init() {}

  private var review: some View {
    NavigationLink { ReviewView() } label: {
      HStack {
        VStack(alignment: .leading) {
          Text("Review patterns")
            .font(.headline)
          Text("\(repo.openPatterns.count) new patterns")
            .foregroundStyle(.secondary)
        }

        Spacer()

        Image(systemName: "chevron.right")
          .foregroundStyle(.tertiary)
      }
      .padding()
      .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
  }

  private var adjustments: some View {
    ForEach(
      repo.orderedAdjustments.prefix(showAllAdjustments ? repo.orderedAdjustments.count : 2),
      id: \.id
    ) { adjustment in
      NavigationLink { ReviewView(adjustment: adjustment) } label: {
        AdjustmentCard(
          Binding { adjustment } set: { newValue in
            Task { try? await repo.save(newValue) }
          }
        ) {
          var updated = adjustment

          if updated.state.next == .active, !repo.canActivate(updated, limit: settings.maxAdjustments) {
            return activeLimitAlertIsPresented = true
          }
          updated.state = updated.state.next
          Task { try? await repo.save(updated) }
        }
      }
    }
    .replaceIfEmpty {
      Text("Capture a few almosts and review a pattern to create your first adjustment.")
        .padding()
        .foregroundStyle(.secondary)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    .alert("Only \(settings.maxAdjustments) active adjustment\(settings.maxAdjustments == 1 ? "" : "s")", isPresented: $activeLimitAlertIsPresented) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("Stabilize or archive an active adjustment.")
    }
  }
}

#Preview {
  NavigationStack {
    JourneyView()
  }
  .firebase()
}
