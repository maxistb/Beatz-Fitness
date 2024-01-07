//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import UIComponents

struct AddEditUebungView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.colorScheme) var colorScheme

  @State private var exerciseName: String
  @State private var exerciseNotes: String
  @State private var exerciseSets: Int
  @State private var exerciseCategory: String
  @State private var showEmptyNameAlert = false
  @State private var category: ExerciseCategory = .weightlifting

  let split: Split
  let exercise: FetchedResults<Exercise>.Element?
  private let isExerciseNil: Bool

  init(split: Split, exercise: FetchedResults<Exercise>.Element? = nil) {
    self.split = split
    self.exercise = exercise
    self._exerciseName = State(initialValue: exercise?.name ?? "")
    self._exerciseNotes = State(initialValue: exercise?.notes ?? "")
    self._exerciseSets = State(initialValue: Int(exercise?.countSets ?? 1))
    self._exerciseCategory = State(initialValue: exercise?.category ?? "weightlifting")
    if exercise != nil { self.isExerciseNil = false } else { self.isExerciseNil = true }
  }

  var body: some View {
    NavigationStack {
      Form {
        Section("Name & Notizen") {
          TextField("Übungsname", text: $exerciseName)
          TextField("Notizen", text: $exerciseNotes)
        }
        stepperSection
        categorySelectionSection
        saveButton
      }
      .alert(isPresented: $showEmptyNameAlert) {
        Alert(
          title: Text("Fehler"),
          message: Text("Der Übungsname darf nicht leer sein."),
          dismissButton: .default(Text("OK"))
        )
      }
      .navigationTitle(isExerciseNil ? "Übung hinzufügen" : "Übung bearbeiten")
      .onChange(of: self.exerciseCategory) { _ in
        self.category = getExerciseCategoryForString(
          exerciseCategory: exerciseCategory)
      }
      .onAppear { self.category = getExerciseCategoryForString(exerciseCategory: exerciseCategory) }
    }
  }

  private var stepperSection: some View {
    Section {
      HStack {
        Text("Sätze:")

        Stepper(value: $exerciseSets, in: 1 ... 20) {
          Text("\(exerciseSets)")
        }
      }
    }
  }

  private var categorySelectionSection: some View {
    Section("Übungsart") {
      NavigationLink {
        CategorySelectionView(exerciseCategory: $exerciseCategory)
      } label: {
        VStack(alignment: .leading) {
          Text(category.getCategoryHeader())
            .foregroundStyle(self.colorScheme == .dark ? .white : .black)
          Text(category.getHeader())
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
    }
  }

  private var saveButton: some View {
    Section {
      HStack {
        Spacer()
        SaveButton(title: "Speichern") { isExerciseNil ? validateAndSave() : updateExercise() }
        Spacer()
      }
    }
    .listRowBackground(Color.clear)
  }
}

extension AddEditUebungView {
  private func validateAndSave() {
    if !exerciseName.isEmpty {
      ExercisesViewModel.shared.createExerciseForSplit(
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

  private func getExerciseCategoryForString(exerciseCategory: String) -> ExerciseCategory {
    switch exerciseCategory {
    case "staticexercise":
      return .staticexercise
    case "bodyweight":
      return .bodyweight
    case "supported":
      return .supported
    case "repsonly":
      return .repsonly
    case "time":
      return .time
    case "cardio":
      return .cardio
    default:
      return .weightlifting
    }
  }
}
