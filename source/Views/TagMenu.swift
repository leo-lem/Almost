// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public struct TagMenu<Value: Almost.Tagged>: View {
  @Binding public var selection: Set<Value>

  public var body: some View {
    Menu {
      ForEach(Array(Value.allCases), id: \.self) { value in
        Button {
          if selection.contains(value) {
            selection.remove(value)
          } else {
            selection.insert(value)
          }
        } label: {
          Label(value.label, systemImage: selection.contains(value) ? "checkmark.circle.fill" : "circle")
        }
      }
    } label: {
      Label(Value.category, systemImage: Value.symbol)
        .labelStyle(.capsule(Value.color))
    }
    .menuActionDismissBehavior(.disabled)
  }

  public init(_ selection: Binding<Set<Value>>) { self._selection = selection }
}

#Preview("Tag Menus") {
  @Previewable @State var failures: Set<Almost.Failure> = [.avoidance, .forgetting]
  @Previewable @State var triggers: Set<Almost.Trigger> = [.rushedMorning]
  @Previewable @State var contexts: Set<Almost.Context> = [.commuting]
  @Previewable @State var states: Set<Almost.State> = [.calm]

  VStack(alignment: .leading) {
    HStack {
      TagMenu($failures)
      TagMenu($triggers)
    }

    HStack {
      TagMenu($contexts)
      TagMenu($states)
    }
  }
  .padding()
}
