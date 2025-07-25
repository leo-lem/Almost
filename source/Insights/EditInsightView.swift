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
        Section {
          VStack(spacing: 8) {
            Text("How did you feel?")
              .font(.headline)
            
            Text(insight.mood.emoji)
              .font(.system(size: 64))

            Text(insight.mood.rawValue)
              .font(.caption)
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(insight.mood.color.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 16))
          
          Picker("Mood", selection: $insight.mood) {
            ForEach(Mood.allCases, id: \.self) { mood in
              Text(mood.emoji).tag(mood)
            }
          }
          .pickerStyle(.segmented)
          .padding(.top)
        } header: {
          Label("Mood", systemImage: "face.smiling")
        }
      }
      
      if settings.favoritesEnabled {
        Section {
          Toggle(isOn: $insight.isFavorite) {
            Label(
              insight.isFavorite ? "Marked as Favorite" : "Highlight this insight",
              systemImage: insight.isFavorite ? "star.fill" : "star"
            )
          }
          .toggleStyle(.switch)
          .tint(.accentColor)
        } header: {
          Label("Mark as Favorite", systemImage: "sparkles")
        }
      }
      
      Section {
        TextEditor(text: $insight.content)
          .frame(minHeight: 150)

        TextField("Optional title (e.g., what went wrong)", text: Binding {
          insight.title ?? ""
        } set: {
          insight.title = $0
        })
        .textContentType(.none)
        .font(.headline)
        .foregroundStyle(insight.mood.color)
      } header: {
        Label("What did you learn?", systemImage: "doc.fill")
      }
    }
    .navigationTitle("Almost Did It?")
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        AsyncButton {
          await insight.save(dismiss: dismiss)
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } label: {
          Text("Save Almost 💭")
        }
        .foregroundStyle(insight.mood.color)
      }
    }
    .trackScreen("EditInsightView")
  }
  
  public init(_ insight: Binding<Insight>) { _insight = insight }
}

#Preview {
  @Previewable @State var insight = Insight.example

  NavigationStack {
    EditInsightView($insight)
  }
  .firebase()
}
