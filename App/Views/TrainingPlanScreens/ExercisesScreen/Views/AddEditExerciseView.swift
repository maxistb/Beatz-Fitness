//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable function_body_length
import SwiftUI
import UIComponents

struct AddEditExerciseView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.colorScheme) var colorScheme

  @State private var exerciseName: String = ""
  @State private var exerciseNotes: String = ""
  @State private var exerciseSets: Int = 3
  @State private var exerciseCategory: String = ""
  @State private var showEmptyNameAlert = false
  @State private var category: ExerciseCategory = .weightlifting
  @State private var appearance: Appearance
  @Binding var showCurrentView: Bool

  init(appearance: Appearance, showCurrentView: Binding<Bool>) {
    self._appearance = State(initialValue: appearance)
    self._showCurrentView = showCurrentView

    switch appearance {
    case .editExercise(let exercise):
      self._exerciseName = State(initialValue: exercise.name)
      self._exerciseNotes = State(initialValue: exercise.notes)
      self._exerciseSets = State(initialValue: Int(exercise.countSets))
      self._exerciseCategory = State(initialValue: exercise.category)

    default:
      return
    }
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
      .navigationTitle(appearance.navigationTitle)
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
        SaveButton(title: appearance.buttonTitle) { action(); showCurrentView = false }
        Spacer()
      }
    }
    .listRowBackground(Color.clear)
  }
}

extension AddEditExerciseView {
  private func action() {
    if exerciseName.isEmpty {
      showEmptyNameAlert = true
      return
    }

    switch appearance {
    case .addExercise(let split):
      ExercisesViewModel.shared.createExerciseForSplit(
        name: exerciseName,
        category: exerciseCategory,
        countSets: 3,
        notes: exerciseNotes,
        split: split
      )

      try? CoreDataStack.shared.mainContext.save()
      dismiss()

    case .addTrainingExercise(let exercises):
      let newExercise = Exercise.createTrainingExercise(
        name: exerciseName,
        category: exerciseCategory,
        countSets: exerciseSets,
        notes: exerciseNotes,
        order: exercises.wrappedValue.count
      )
      exercises.wrappedValue.insert(newExercise)

      for order in 0 ..< newExercise.countSets {
        _ = TrainingSet.createTrainingSet(exercise: newExercise, order: Int(order))
      }

      try? CoreDataStack.shared.mainContext.save()
      dismiss()

    case .editExercise(let exercise):
      exercise.name = exerciseName
      exercise.notes = exerciseNotes
      exercise.countSets = Int16(exerciseSets)
      exercise.category = exerciseCategory

      try? CoreDataStack.shared.mainContext.save()
      dismiss()

    case .replaceExercise(let exercises, let exercise):
      let newExercise = Exercise.createTrainingExercise(
        name: exerciseName,
        category: exerciseCategory,
        countSets: exerciseSets,
        notes: exerciseNotes,
        order: Int(exercise.order)
      )
      exercises.wrappedValue.remove(exercise)
      exercises.wrappedValue.insert(newExercise)

      for order in 0 ..< newExercise.countSets {
        _ = TrainingSet.createTrainingSet(exercise: newExercise, order: Int(order))
      }

      try? CoreDataStack.shared.mainContext.save()
      dismiss()
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

extension AddEditExerciseView {
  enum Appearance {
    case replaceExercise(Binding<Set<Exercise>>, Exercise)
    case addExercise(Split)
    case addTrainingExercise(Binding<Set<Exercise>>)
    case editExercise(Exercise)

    var navigationTitle: String {
      switch self {
      case .replaceExercise:
        "Übung ersetzen"
      case .addExercise, .addTrainingExercise:
        "Übung hinzufügen"
      case .editExercise:
        "Übung bearbeiten"
      }
    }

    var buttonTitle: String {
      switch self {
      case .replaceExercise:
        "Ersetzen"
      case .addExercise, .addTrainingExercise:
        "Hinzufügen"
      case .editExercise:
        "Speichern"
      }
    }
  }
}

// swiftlint:enable function_body_length
