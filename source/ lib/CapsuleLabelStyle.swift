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
    HStack(spacing: compact ? 2 : 4) {
      configuration.icon
      configuration.title
    }
    .lineLimit(0)
    .font(compact ? .caption2 : .caption).bold()
    .padding(.horizontal, compact ? 4 : 8)
    .padding(.vertical, compact ? 2 : 4)
    .foregroundStyle(color)
    .background(color.opacity(0.2))
    .clipShape(.capsule)
  }
}

public extension LabelStyle where Self == CapsuleLabelStyle {
  static func capsule(_ color: Color, compact: Bool = false) -> CapsuleLabelStyle {
    CapsuleLabelStyle(color, compact: compact)
  }
}

#Preview {
  Label("Hello, World!", systemImage: "hand.thumbsup")
    .labelStyle(.capsule(.blue))
}
