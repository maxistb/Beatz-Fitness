//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import UIComponents

struct AddUebungView: View {
  @State private var exerciseName = ""
  @State private var exerciseNotes = ""
  @State private var exerciseSets = 1
  @State private var exerciseCategory = "Krafttraining"
  @State private var showEmptyNameAlert = false
  @Environment(\.dismiss) var dismiss
  let split: Split
  let viewModel: UebungViewModel

  var body: some View {
    NavigationStack {
      Form {
        Section("Name & Notizen") {
          TextField("Übungsname", text: $exerciseName)
          TextField("Notizen", text: $exerciseNotes)
        }

        Section {
          HStack {
            Text("Sätze:")

            Stepper(value: $exerciseSets, in: 1 ... 20) {
              Text("\(exerciseSets)")
            }
          }
        }

        Section("Übungsart") {
          Text("TODO")
        }

        Section {
          HStack {
            Spacer()
            SaveButton(title: "Speichern") { validateAndSave() }
            Spacer()
          }
        }
        .listRowBackground(Color.clear)
      }
      .alert(isPresented: $showEmptyNameAlert) {
        Alert(
          title: Text("Fehler"),
          message: Text("Der Übungsname darf nicht leer sein."),
          dismissButton: .default(Text("OK"))
        )
      }
      .navigationTitle("Übung hinzufügen")
    }
  }
}

extension AddUebungView {
  private func validateAndSave() {
    if !exerciseName.isEmpty {
      viewModel.createUebungForSplit(
        name: exerciseName,
        category: exerciseCategory,
        countSets: exerciseSets,
        notes: exerciseNotes,
        split: split
      )

      dismiss()
    } else {
      showEmptyNameAlert = true
    }
  }
}
