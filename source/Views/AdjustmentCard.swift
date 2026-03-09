// Created by Leopold Lemmermann on 08.03.26.

import Extensions
import SwiftUI
import SwiftUIExtensions

public struct AdjustmentCard: View {
  @Binding public var adjustment: Adjustment
  public let saveAfterEdit: Bool

  @State private var isEditing = false
  @State private var limitAlerting = false

  @Environment(Repository.self) var repo

  @FocusState private var textFieldIsFocused
  @Namespace private var animations

  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if isEditing {
          TextField(adjustment.textPlaceholder, text: $adjustment.text.empty, axis: .vertical)
            .textFieldStyle(.plain)
            .focused($textFieldIsFocused)
        } else {
          Text(adjustment.text ?? adjustment.textPlaceholder)
            .foregroundStyle(adjustment.text == nil ? .secondary : .primary)
            .onLongPressGesture { isEditing = true }
        }

        if isEditing { delete }
      }
      .multilineTextAlignment(.leading)
      .font(.headline)
      .transition(.identity)
      .matchedGeometryEffect(id: "text-\(adjustment.id)", in: animations)

      HStack {
        Button(adjustment.state.label, systemImage: adjustment.state.symbol) { advanceState() }
          .labelStyle(.capsule(adjustment.state.color))

        if !adjustment.almosts.isEmpty {
          Label("\(adjustment.almosts.count) almosts", systemImage: "link")
            .labelStyle(.capsule(.secondary))
        }

        Spacer()

        Button(isEditing ? "Done" : "Edit",
               systemImage: isEditing ? "checkmark.circle" : "pencil") { isEditing.toggle() }
          .labelStyle(.iconOnly)
      }
      .matchedGeometryEffect(id: "meta-\(adjustment.id)", in: animations)
    }
    .buttonStyle(.borderless)
    .animation(.default, value: isEditing)
    .alert("Only \(repo.maxActiveAdjustments) active adjustments", isPresented: $limitAlerting) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("Stabilize or archive an active adjustment before activating another one.")
    }
    .swipeActions { delete }
    .onChange(of: isEditing) { _, isEditing in
      textFieldIsFocused = isEditing
      if !isEditing, saveAfterEdit { Task { try? await repo.save(adjustment) } }
    }
  }

  public init(_ adjustment: Binding<Adjustment>, saveAfterEdit: Bool = true) {
    self._adjustment = adjustment
    self.saveAfterEdit = saveAfterEdit
  }
}

private extension AdjustmentCard {
  var delete: some View {
    AsyncButton("Delete", systemImage: "trash", role: .destructive) {
      try? await repo.delete(adjustment)
      isEditing = false
    }
    .labelStyle(.iconOnly)
  }

  func advanceState() {
    if adjustment.state.next != .active || repo.canActivate(adjustment) {
      adjustment.nextState()
      if saveAfterEdit { Task { try? await repo.save(adjustment) } }
    } else {
      limitAlerting = true
    }
  }
}

#Preview("Adjustment Card") {
  @Previewable @State var adjustment = Adjustment(
    almosts: ["a1", "a2", "a3"],
    text: "Check essentials before leaving",
    state: .active
  )

  @Previewable @State var other = Adjustment(
    almosts: ["a1", "a2", "a3", "a4"],
    text: "Bring it on, because this is a longer text. And it's even longer!",
    state: .archived
  )

  @Previewable @State var empty = Adjustment(
    almosts: ["a1", "a2"],
    text: nil,
    state: .stabilized
  )

  List {
    AdjustmentCard($adjustment)
    AdjustmentCard($other)
    AdjustmentCard($empty)
  }
  .firebase()
}
