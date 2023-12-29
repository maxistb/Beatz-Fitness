//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import UIComponents

struct AddEditUebungView: View {
  @State private var exerciseName: String
  @State private var exerciseNotes: String
  @State private var exerciseSets: Int
  @State private var exerciseCategory: String
  @State private var showEmptyNameAlert = false
  @Environment(\.dismiss) var dismiss
  let split: Split
  let viewModel: SplitScreenViewModel
  let exercise: FetchedResults<Exercise>.Element?
  private var isExerciseNil: Bool

  init(split: Split, viewModel: SplitScreenViewModel, exercise: FetchedResults<Exercise>.Element? = nil) {
    self.split = split
    self.viewModel = viewModel
    self.exercise = exercise
    self._exerciseName = State(initialValue: exercise?.name ?? "")
    self._exerciseNotes = State(initialValue: exercise?.notes ?? "")
    self._exerciseSets = State(initialValue: Int(exercise?.countSets ?? 1))
    self._exerciseCategory = State(initialValue: exercise?.category ?? "Krafttraining")
    if let exercise = exercise { self.isExerciseNil = false } else { self.isExerciseNil = true }
  }

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
            SaveButton(title: "Speichern") { isExerciseNil ? validateAndSave() : updateExercise() }
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

extension AddEditUebungView {
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

  private func updateExercise() {
    if !exerciseName.isEmpty, let exercise = exercise {
      exercise.name = exerciseName
      exercise.notes = exerciseNotes
      exercise.countSets = Int16(exerciseSets)
      exercise.category = exerciseCategory

      try? CoreDataStack.shared.mainContext.save()

      dismiss()
    } else {
      showEmptyNameAlert = true
    }
  }
}
