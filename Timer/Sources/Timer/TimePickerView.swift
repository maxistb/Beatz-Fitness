//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct TimePickerView: View {
  // This is used to tighten up the spacing between the Picker and its
  // respective label
  //
  // This allows us to avoid having to use custom
  private let pickerViewTitlePadding: CGFloat = 4.0

  let title: String
  let range: ClosedRange<Int>
  let binding: Binding<Int>

  var body: some View {
    HStack(spacing: -pickerViewTitlePadding) {
      Picker(title, selection: binding) {
        ForEach(range, id: \.self) { timeIncrement in
          HStack {
            // Forces the text in the Picker to be right-aligned
            Spacer()
            Text("\(timeIncrement)")
              .multilineTextAlignment(.trailing)
          }
        }
      }
      .pickerStyle(InlinePickerStyle())
      .labelsHidden()

      Text(NSLocalizedString(title, comment: "min oder sek"))
        .fontWeight(.bold)
    }
  }
}
