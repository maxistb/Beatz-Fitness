//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI
import UIComponents

struct AddSplitView: View {
  @Environment(\.dismiss) var dismiss
  @State private var splitName = ""
  let viewModel: SplitViewModel

  var body: some View {
    NavigationStack {
      List {
        TextField(L10n.nameOfSplit, text: $splitName)

        Section {
          HStack(alignment: .center, content: {
            Spacer()
            SaveButton(title: L10n.save) {
              viewModel.createSplit(name: splitName, notes: "", lastTraining: nil, exercises: [])
              dismiss()
            }
            Spacer()
          })
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle(L10n.addSplit)
    }
  }
}
