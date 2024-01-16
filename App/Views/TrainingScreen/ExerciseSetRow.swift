//
// Created by Maximillian Stabe on 14.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Combine
import Styleguide
import SwiftUI

struct ExerciseSetRow: View {
  let currentSet: TrainingSet
  let isTrainingView: Bool
  let labels: [String]
  let placeholders: [String]
  let bindings: [Binding<String>]
  let alertCase: Binding<TrainingScreenAlerts>

  var body: some View {
    HStack {
      Image(systemName: "\(self.currentSet.order + 1).circle")
        .padding(.trailing, 20)
      HStack(alignment: .top) {
        ForEach(0 ..< self.labels.count, id: \.self) { index in
          CommonSetTextField(
            label: self.labels[index],
            placeholder: self.placeholders[index],
            text: self.bindings[index],
            alertCase: alertCase)
        }
      }
      if self.isTrainingView {
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
  var alertCase: Binding<TrainingScreenAlerts>
  private let numberFormatter: NumberFormatter

  init(label: String, placeholder: String, text: Binding<String>, alertCase: Binding<TrainingScreenAlerts>) {
    self.label = label
    self.placeholder = placeholder
    self.text = text
    self.alertCase = alertCase

    self.numberFormatter = {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      numberFormatter.maximumFractionDigits = 2
      return numberFormatter
    }()
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.label)
        .foregroundStyle(.gray).font(.system(size: 14))
      TextField(self.placeholder, text: self.text)
        .keyboardType(.default)
        .onReceive(Just(self.text)) { newValue in
          if self.label != "Notizen" {
            if newValue.wrappedValue.isDecimalNumber() {
              self.text.wrappedValue = newValue.wrappedValue
            } else {
              alertCase.wrappedValue = .notDecimalInput
              self.text.wrappedValue = ""
            }
          }
        }
        .onSubmit {
          if self.label != "Notizen" {
            if !self.text.wrappedValue.isDecimalNumber() {
              alertCase.wrappedValue = .notDecimalInput
              self.text.wrappedValue = ""
            }
          }
        }
    }
    .padding(.leading, -20)
  }
}
