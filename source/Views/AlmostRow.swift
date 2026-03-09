// Created by Leopold Lemmermann on 08.03.26.

import Extensions
import SwiftUI
import SwiftUIExtensions

public struct AlmostRow: View {
  @Binding public var almost: Almost
  public let saveAfterEdit: Bool

  @State private var isEditing = false

  @Environment(Repository.self) var repo

  @FocusState private var textFieldIsFocused
  @Namespace private var animations

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if isEditing {
          TextField("Describe the almost…", text: $almost.text, axis: .vertical)
            .textFieldStyle(.plain)
            .focused($textFieldIsFocused)
        } else {
          Text(almost.text)
            .onLongPressGesture { isEditing = true }
        }

        if isEditing { delete }
      }
      .multilineTextAlignment(.leading)
      .lineLimit(2)
      .transition(.identity)
      .matchedGeometryEffect(id: "text-\(almost.id)", in: animations)

      HStack {
        if !isEditing {
          Text(almost.createdAt.relative)
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            if isEditing {
              TagMenu($almost.failures)
              TagMenu($almost.triggers)
              TagMenu($almost.contexts)
              TagMenu($almost.states)
            } else {
              ForEach(tags, id: \.label) { tag in
                Label(tag.label, systemImage: tag.symbol)
                  .labelStyle(.capsule(tag.color, compact: true))
              }
            }
          }
          .onLongPressGesture { isEditing = true }
        }

        Spacer()

        Button(isEditing ? "Done" : "Edit",
               systemImage: isEditing ? "checkmark.circle" : "pencil") { isEditing.toggle() }
          .labelStyle(.iconOnly)
      }
      .matchedGeometryEffect(id: "meta-\(almost.id)", in: animations)
    }
    .buttonStyle(.borderless)
    .animation(.default, value: isEditing)
    .swipeActions { delete }
    .onChange(of: isEditing) { _, isEditing in
      textFieldIsFocused = isEditing
      if isEditing, saveAfterEdit { Task { try? await repo.save(almost) } }
    }
  }

  public init(_ almost: Binding<Almost>, saveAfterEdit: Bool = true) {
    self._almost = almost
    self.saveAfterEdit = saveAfterEdit
  }
}

private extension AlmostRow {
  var tags: [any Almost.Tagged] {
    Array(almost.failures) + Array(almost.triggers) + Array(almost.contexts) + Array(almost.states)
  }
}

private extension AlmostRow {
  var delete: some View {
    AsyncButton("Delete", systemImage: "trash", role: .destructive) {
      try? await repo.delete(almost)
      isEditing = false
    }
    .labelStyle(.iconOnly)
  }
}

#Preview("Almost Row") {
  @Previewable @State var almost = Almost(
    createdAt: .now.addingTimeInterval(-3600),
    text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table."
    + "This text could be a little longer still.",
    failures: [.forgetting, .poorPreparation],
    triggers: [.rushedMorning, .noChecklist],
    contexts: [.atHome, .beforeLeaving],
    states: [.rushed]
  )

  List {
    AlmostRow($almost)
  }
  .firebase()
}
