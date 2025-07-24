// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct EditInsightView: View {
  @Binding public var insight: Insight
  @Environment(\.dismiss) private var dismiss
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session

  public var body: some View {
    Form {
      if settings.moodEnabled {
        Section("Mood") {
          VStack(spacing: 8) {
            Text("How did you feel?")
              .font(.headline)

            Text(insight.mood.rawValue)
              .font(.system(size: 64))
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(insight.mood.color.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 16))

          Picker("Mood", selection: $insight.mood) {
            ForEach(Mood.allCases, id: \.self) { mood in
              Text(mood.rawValue).tag(mood)
            }
          }
          .pickerStyle(.segmented)
          .padding(.top)
        }
      }

      if settings.favoritesEnabled {
        Section("Mark as Favorite") {
          Toggle(isOn: $insight.isFavorite) {
            Label(
              insight.isFavorite ? "Marked as Favorite" : "Highlight this insight",
              systemImage: insight.isFavorite ? "star.fill" : "star"
            )
          }
          .toggleStyle(.switch)
          .tint(.accentColor)
        }
      }

      Section {
        TextField("What did you learn?", text: $insight.content)
          .frame(minHeight: 200)

        TextField("Optional title (e.g., what went wrong)", text: Binding {
          insight.title ?? ""
        } set: {
          insight.title = $0
        })
        .textContentType(.none)
        .font(.headline)
      }
    }
    .navigationTitle("Almost Did It?")
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        AsyncButton {
          await insight.save(dismiss: dismiss)
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
          Text("Save Almost")
        }
      }
    }
    .trackScreen("EditInsightView")
  }

  public init(_ insight: Binding<Insight>) { _insight = insight }
}

#Preview {
  @Previewable @State var insight = Insight(
    userID: "",
    title: "I fucked up",
    content: "I will be better in the future.",
    mood: .excited
  )

  NavigationStack {
    EditInsightView($insight)
  }
  .preview()
}
