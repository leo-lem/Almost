// Created by Leopold Lemmermann on 22.07.25.

import SwiftUI
import SwiftUIExtensions

public struct EditInsightView: View {
  @Binding public var insight: Insight
  @Environment(\.dismiss) private var dismiss
  @Environment(Settings.self) private var settings
  @Environment(UserSession.self) private var session
  
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
        
        if settings.moodEnabled {
          Section("Mood") {
            Picker("Mood", selection: $insight.mood) {
              ForEach(Mood.allCases, id: \.self) { mood in
                Text(mood.rawValue).tag(mood)
              }
            }
            .pickerStyle(.segmented)
          }
        }
      }
      .navigationTitle("Your Almost Moment?")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          AsyncButton { await insight.save(dismiss: dismiss) } label: {
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
  
  public init(_ insight: Binding<Insight>) { _insight = insight }
}

#Preview {
  @Previewable @State var insight = Insight(
    userID: "",
    title: "I fucked up",
    content: "I will be better in the future.",
    mood: .excited
  )
  
  EditInsightView($insight)
    .preview()
}
