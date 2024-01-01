//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct SaveButton: View {
  @State private var isClicked = false
  private let action: () -> Void
  private let title: String

  public init(title: String, action: @escaping () -> Void) {
    self.action = action
    self.title = title
  }

  public var body: some View {
    Button {
      action()
      isClicked = true
    } label: {
      Text(title)
    }
    .font(.headline)
    .foregroundStyle(.white)
    .frame(width: 200, height: 50)
    .background(isClicked ? Color.blue : Asset.Color.beatzColor.swiftUIColor)
    .cornerRadius(15.0)
  }
}
