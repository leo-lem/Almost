// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public struct TagMenu<Value: CaseIterable & Hashable & RawRepresentable & Labeled>: View
    where Value.RawValue == String {
  public let title: String
  public let kind: Almost.Tag
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
      Label(title, systemImage: kind.symbol)
        .labelStyle(.capsule(kind.color))
    }
  }

  private init(
    title: String,
    kind: Almost.Tag,
    selection: Binding<Set<Value>>
  ) {
    self.title = title
    self.kind = kind
    self._selection = selection
  }
}

public extension TagMenu where Value == Almost.Failure {
  init(_ selection: Binding<Set<Almost.Failure>>) {
    self.init(title: "Failures", kind: .failure, selection: selection)
  }
}

public extension TagMenu where Value == Almost.Trigger {
  init(_ selection: Binding<Set<Almost.Trigger>>) {
    self.init(title: "Triggers", kind: .trigger, selection: selection)
  }
}

public extension TagMenu where Value == Almost.Context {
  init(_ selection: Binding<Set<Almost.Context>>) {
    self.init(title: "Contexts", kind: .context, selection: selection)
  }
}

public extension TagMenu where Value == Almost.State {
  init(_ selection: Binding<Set<Almost.State>>) {
    self.init(title: "States", kind: .state, selection: selection)
  }
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
