// Created by Leopold Lemmermann on 08.03.26.

import Extensions
import SwiftUI

public struct AlmostRow: View {
  @Binding public var almost: Almost

  @State private var isEditing = false
  @FocusState private var textFieldIsFocused
  @Namespace private var animations

  public var body: some View {
    VStack(alignment: .leading) {
      Group {
        if isEditing {
          TextField("Describe the almost…", text: $almost.text, axis: .vertical)
            .textFieldStyle(.plain)
            .focused($textFieldIsFocused)
        } else {
          Text(almost.text)
            .onLongPressGesture { isEditing = true }
        }
      }
      .lineLimit(2)
      .matchedGeometryEffect(id: "text-\(almost.id)", in: animations)
      .onChange(of: isEditing) { textFieldIsFocused = $1 }

      HStack {
        if isEditing {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              TagMenu($almost.failures)
              TagMenu($almost.triggers)
              TagMenu($almost.contexts)
              TagMenu($almost.states)
            }
          }
        } else {
          Text(almost.relativeTimestamp)
            .font(.caption)
            .foregroundStyle(.secondary)

          ScrollView(.horizontal, showsIndicators: false) {
            HStack { tags }
              .onLongPressGesture { isEditing = true }
          }
        }

        Spacer()

        Button { isEditing.toggle() } label: {
          Label(isEditing ? "Done" : "Edit", systemImage: isEditing ? "checkmark.circle" : "pencil")
            .labelStyle(.iconOnly)
        }
      }
      .matchedGeometryEffect(id: "meta-\(almost.id)", in: animations)
    }
    .padding()
    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 16))
    .animation(.default, value: isEditing)
  }

  public init(almost: Binding<Almost>) {
    self._almost = almost
  }
}

private extension AlmostRow {
  @ViewBuilder
  var tags: some View {
    ForEach(Array(almost.failures), id: \.rawValue) { tag in
      Label(tag.label, systemImage: Almost.Tag.failure.symbol)
        .labelStyle(.capsule(Almost.Tag.failure.color, compact: true))
    }

    ForEach(Array(almost.triggers), id: \.rawValue) {
      Label($0.label, systemImage: Almost.Tag.trigger.symbol)
        .labelStyle(.capsule(Almost.Tag.trigger.color, compact: true))
    }

    ForEach(Array(almost.contexts), id: \.rawValue) {
      Label($0.label, systemImage: Almost.Tag.context.symbol)
        .labelStyle(.capsule(Almost.Tag.context.color, compact: true))
    }

    ForEach(Array(almost.states), id: \.rawValue) {
      Label($0.label, systemImage: Almost.Tag.state.symbol)
        .labelStyle(.capsule(Almost.Tag.state.color, compact: true))
    }
  }
}

#Preview("Almost Row") {
  @Previewable @State var almost = Almost(
    createdAt: .now.addingTimeInterval(-3600),
    text: "Packed for the trip at the last minute and almost forgot my passport on the kitchen table.",
    failures: [.forgetting, .poorPreparation],
    triggers: [.rushedMorning, .noChecklist],
    contexts: [.atHome, .beforeLeaving],
    states: [.rushed]
  )

  VStack {
    AlmostRow(almost: $almost)
  }
  .padding()
}
