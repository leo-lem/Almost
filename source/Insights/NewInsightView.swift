// Created by Leopold Lemmermann on 22.07.25.

import FirebaseFirestore
import SwiftUI
import SwiftUIExtensions

public struct NewInsightView: View {
  @State private var title = ""
  @State private var content = ""
  @State private var mood = Mood.neutral
  @State private var error: String?
  @Environment(\.dismiss) private var dismiss
  @Environment(UserSession.self) private var session

  public var body: some View {
    NavigationStack {
      Form {
        Section("Today's almost moment? What didn't work — and what did you learn?") {
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
          AsyncButton(action: save) { Text("Save") }
            .disabled(content.isEmpty)
        }
        
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss.callAsFunction)
        }
      }
    }
  }

  public init() {}

  private func save() async {
    do {
      guard let userID = session.userID else {
        return error = "You need to be logged in to save an insight."
      }

      try Firestore.firestore()
        .collection("users/\(userID)/insights")
        .addDocument(
          from: Insight(
            title: title,
            content: content,
            mood: mood
          )
        )

      dismiss()
    } catch {
      self.error = error.localizedDescription
    }
  }
}

#Preview {
  NewInsightView()
}
