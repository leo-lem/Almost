// Created by Leopold Lemmermann on 08.03.26.

import Extensions
import SwiftUI

public struct AdjustmentCard: View {
  @Binding public var adjustment: Adjustment

  let setState: (() -> Void)?

  @State private var isEditing = false
  @FocusState private var textFieldIsFocused
  @Namespace private var animations

  public var body: some View {
    VStack(alignment: .leading) {
      Group {
        if isEditing {
          TextField("Short, actionable rule for this pattern", text: $adjustment.defaultText, axis: .vertical)
            .textFieldStyle(.plain)
            .focused($textFieldIsFocused)
        } else {
          Text(adjustment.text ?? "Short, actionable rule for this pattern")
            .foregroundStyle(adjustment.text == nil ? .secondary : .primary)
            .onLongPressGesture { isEditing = true }
        }
      }
      .multilineTextAlignment(.leading)
      .font(.headline)
      .transition(.identity)
      .matchedGeometryEffect(id: "text-\(adjustment.id)", in: animations)
      .onChange(of: isEditing) { textFieldIsFocused = $1 }

      HStack {
        Button { setState?() } label: {
          Label(adjustment.state.label, systemImage: adjustment.state.symbol)
            .labelStyle(.capsule(adjustment.state.color))
        }

        if !adjustment.almosts.isEmpty {
          Label("\(adjustment.almosts.count)", systemImage: "link")
            .labelStyle(.capsule(.secondary))
        }

        Spacer()

        Button { isEditing.toggle() } label: {
          Label(isEditing ? "Done editing" : "Edit", systemImage: isEditing ? "checkmark.circle" : "pencil")
            .labelStyle(.iconOnly)
        }
      }
      .matchedGeometryEffect(id: "meta-\(adjustment.id)", in: animations)
    }
    .padding()
    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16))
    .animation(.default, value: isEditing)
  }

  public init(
    _ adjustment: Binding<Adjustment>,
    setState: (() -> Void)? = nil
  ) {
    self._adjustment = adjustment
    self.setState = setState
  }
}

#Preview("Adjustment Card") {
  @Previewable @State var adjustment = Adjustment(
    almosts: ["a1", "a2", "a3"],
    text: "Check essentials before leaving",
    state: .active
  )

  VStack {
    AdjustmentCard($adjustment)
  }
  .padding()
}

#Preview("Adjustment Card Empty") {
  @Previewable @State var adjustment = Adjustment(
    almosts: ["a1", "a2"],
    text: nil,
    state: .suggested
  )

  VStack {
    AdjustmentCard($adjustment)
  }
  .padding()
}
