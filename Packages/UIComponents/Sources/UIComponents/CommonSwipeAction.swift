//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

public struct SwipeActionWithAlert: ViewModifier {
  @State private var showingAlert = false
  let buttonTitle: String
  let confirmationDialog: String
  let action: () -> Void

  public init(buttonTitle: String, confirmationDialog: String, action: @escaping () -> Void) {
    self.buttonTitle = buttonTitle
    self.confirmationDialog = confirmationDialog
    self.action = action
  }

  public func body(content: Content) -> some View {
    content
      .swipeActions {
        Button(action: {
          showingAlert = true
        }, label: {
          Image(systemName: "trash")
        })
        .tint(.red)
      }
      .confirmationDialog(confirmationDialog, isPresented: $showingAlert, titleVisibility: .visible) {
        Button(buttonTitle) {
          action()
        }
      }
  }
}
