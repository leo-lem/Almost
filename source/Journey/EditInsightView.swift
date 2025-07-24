// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct EditInsightView: View {
  public let userID: String?
  @Binding public var insight: Insight
  @State private var error: FirebaseError?
  @Environment(\.dismiss) private var dismiss

  public var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField(
            "(Optional) What didn't work?",
            text: Binding { insight.title ?? "" } set: { insight.title = $0 }
          )
          TextField("What did you learn?", text: $insight.content)
            .frame(minHeight: 100)
        }

        Section("Mood") {
          Picker("Mood", selection: $insight.mood) {
            ForEach(Mood.allCases, id: \.self) { mood in
              Text(mood.rawValue).tag(mood)
            }
          }
          .pickerStyle(.segmented)
        }

        if let error {
          Text(error.localizedDescription)
            .foregroundColor(.red)
        }
      }
      .navigationTitle("Your Almost Moment?")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          AsyncButton {
            do {
              try await insight.save(userID, dismiss: dismiss)
            } catch is FirebaseError {
              self.error = error
            } catch {}
          } label: {
            Text("Save")
          }
          .disabled(insight.content.isEmpty)
        }
        
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss.callAsFunction)
        }
      }
    }
    .trackScreen("EditInsightView")
  }

  public init(_ insight: Binding<Insight>, userID: String?) {
    self.userID = userID
    _insight = insight
  }
}

#Preview {
  @Previewable @State var insight = Insight(
    title: "I fucked up",
    content: "I will be better in the future.",
    mood: .excited
  )

  EditInsightView($insight, userID: nil)
}
