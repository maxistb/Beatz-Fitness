//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import UIComponents

#warning("Wann wird hier splitLastDiaryEntry angepasst?")

struct AddSplitView: View {
  @Environment(\.dismiss) var dismiss
  @State private var splitName = ""

  var body: some View {
    NavigationStack {
      List {
        TextField("Name vom Split", text: $splitName)

        Section {
          HStack(alignment: .center, content: {
            Spacer()
            SaveButton(title: "Speichern") {
              Split.createSplit(
                name: splitName,
                notes: splitName,
                splitLastDiaryEntry: nil,
                splitExercises: nil,
                order: 1)
              dismiss()
            }
            Spacer()
          })
        }
        .listRowBackground(Color.clear)
      }
      .navigationTitle("Split hinzufügen")
    }
  }
}

#Preview {
  AddSplitView()
}
