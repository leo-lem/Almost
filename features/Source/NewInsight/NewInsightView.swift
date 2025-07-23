// Created by Leopold Lemmermann on 22.07.25.

import Data
import SwiftUI
import SwiftUIExtensions

public struct NewInsightView: View {
  let userID: String
  
  @State var title = ""
  @State var content = ""
  @State var mood = Mood.neutral
  @State var error: String?
  
  @Environment(\.dismiss) var dismiss
  @Dependency(\.insights) var insights

  public var body: some View {
    NavigationStack {
      Form {
        Section("Today’s almost moment? What didn’t work — and what did you learn?") {
          TextField("(Optional) Title", text: $title)
          TextEditor(text: $content)
            .frame(minHeight: 100)
        }

        Section("Mood") {
          Picker("Mood", selection: $mood) {
            ForEach(Mood.allCases, id: \.self) { mood in
              Text(mood.rawValue).tag(mood)
            }
          }
          .pickerStyle(.segmented)
        }

        if let error {
          Text(error)
            .foregroundColor(.red)
        }
      }
      .navigationTitle("New Insight")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          AsyncButton {
            do {
              try await insights.save(
                Insight(
                  userID: userID,
                  title: title,
                  content: content,
                  mood: mood
                )
              )
              dismiss()
            } catch {
              self.error = error.localizedDescription
            }
          } label: { Text("Save") }
          .disabled(content.isEmpty)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss.callAsFunction)
        }
      }
    }
  }

  public init(userID: String) {
    self.userID = userID
  }
}

#Preview {
  NewInsightView(userID: "preview")
}
