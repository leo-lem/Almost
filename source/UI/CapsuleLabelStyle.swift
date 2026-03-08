// Created by Leopold Lemmermann on 08.03.26.

import SwiftUI

public struct CapsuleLabelStyle: LabelStyle {
  public let color: Color
  public let compact: Bool

  public init(_ color: Color, compact: Bool = false) {
    self.color = color
    self.compact = compact
  }

  public func makeBody(configuration: Configuration) -> some View {
    Label { configuration.title } icon: { configuration.icon }
      .lineLimit(0)
      .foregroundStyle(color)
      .font(compact ? .caption2.bold() : .caption.bold())
      .padding(.horizontal, compact ? 4 : 8)
      .padding(.vertical, compact ? 2 : 4)
      .background(color.opacity(0.25))
      .clipShape(.capsule)
  }
}

public extension LabelStyle where Self == CapsuleLabelStyle {
  static func capsule(_ color: Color, compact: Bool = false) -> CapsuleLabelStyle {
    CapsuleLabelStyle(color, compact: compact)
  }
}
