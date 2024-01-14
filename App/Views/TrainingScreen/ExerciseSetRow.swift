//
// Created by Maximillian Stabe on 14.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct ExerciseSetRow: View {
  let currentSet: TrainingSet
  let isTrainingView: Bool
  let labels: [String]
  let placeholders: [String]
  let bindings: [Binding<String>]
  let keyboardType: UIKeyboardType

  var body: some View {
    HStack {
      Image(systemName: "\(currentSet.order + 1).circle")
        .padding(.trailing, 20)
      HStack(alignment: .top) {
        ForEach(0 ..< labels.count, id: \.self) { index in
          CommonSetTextField(
            label: labels[index],
            placeholder: placeholders[index],
            text: bindings[index],
            keyboardType: keyboardType)
        }
      }
      if isTrainingView {
        Spacer()
        Image(systemName: "ellipsis")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
    }
  }
}

struct CommonSetTextField: View {
  var label: String
  var placeholder: String
  var text: Binding<String>
  var keyboardType: UIKeyboardType

  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .foregroundStyle(.gray).font(.system(size: 14))
      TextField(placeholder, text: text)
        .keyboardType(keyboardType)
        .onSubmit { try? CoreDataStack.shared.mainContext.save() }
    }
    .padding(.leading, -20)
  }
}
