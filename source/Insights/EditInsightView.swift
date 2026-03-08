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
