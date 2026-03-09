// Created by Leopold Lemmermann on 09.03.26.

import SwiftUI

public extension View {
  func cardStyle(_ color: Color = Color(.systemBackground)) -> some View {
    self
      .padding()
      .background(color)
      .cornerRadius(16)
      .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 0)
  }
}
