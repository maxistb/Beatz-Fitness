//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct PauseButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 70, height: 70)
      .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      .background(Asset.Color.beatzColor.swiftUIColor.opacity(0.3))
      .clipShape(Circle())
      .padding(.all, 3)
      .overlay(
        Circle()
          .stroke(Asset.Color.beatzColor.swiftUIColor.opacity(0.3), lineWidth: 2)
      )
  }
}

struct StartButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 70, height: 70)
      .foregroundStyle(Asset.Color.timerButtonStart.swiftUIColor)
      .background(Asset.Color.timerButtonStart.swiftUIColor.opacity(0.3))
      .clipShape(Circle())
      .padding(.all, 3)
      .overlay(
        Circle()
          .stroke(Asset.Color.timerButtonStart.swiftUIColor.opacity(0.3), lineWidth: 2)
      )
  }
}

struct CancelButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme

  var isLightMode: Bool {
    return colorScheme == .light
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 70, height: 70)
      .foregroundStyle(isLightMode ? Asset.Color.timerButtonPause.swiftUIColor : Asset.Color.timerButtonCancel.swiftUIColor)
      .background(isLightMode ? Asset.Color.timerButtonPause.swiftUIColor.opacity(0.3) : Asset.Color.timerButtonCancel.swiftUIColor.opacity(0.3))
      .clipShape(Circle())
      .padding(.all, 3)
      .overlay(
        Circle()
          .stroke(isLightMode ? Asset.Color.timerButtonPause.swiftUIColor.opacity(0.3) : Asset.Color.timerButtonCancel.swiftUIColor.opacity(0.3), lineWidth: 2)
      )
  }
}
