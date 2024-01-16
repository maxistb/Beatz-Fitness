//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Styleguide
import SwiftUI

struct ExercisesScreen: View {
  @State private var showAddUebungSheet = false
  @State private var showMachinesBeatzSheet = false

  let split: Split
  @FetchRequest var exercises: FetchedResults<Exercise>

  init(split: Split) {
    self.split = split

    _exercises = FetchRequest(
      entity: Exercise.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Exercise.order, ascending: true)
      ],
      predicate: NSPredicate(format: "split == %@", split)
    )
  }

  var body: some View {
    Form {
      Section {
        NavigationLink("Training starten", destination: TrainingScreen(split: split))
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
        notesTextField()
      }

      Section("Übungen") {
        ForEach(exercises, id: \.self) { exercise in
          NavigationLink { AddEditExerciseView(appearance: .editExercise(exercise), showCurrentView: .constant(false)) }
            label: { createExerciseLabel(exercise: exercise) }
        }
        .onDelete { indexSet in
          ExercisesViewModel.shared.deleteExercise(exercises: split.exercises, indicesToDelete: indexSet)
        }
        .onMove { indices, newOffset in
          ExercisesViewModel.shared.moveExercise(
            exercises: split.exercises,
            oldIndices: indices,
            newIndex: newOffset
          )
        }
      }
    }
    .navigationTitle(split.name)
    .toolbar { createToolbar() }
    .sheet(isPresented: $showAddUebungSheet) {
      AddEditExerciseView(appearance: .addExercise(split), showCurrentView: $showAddUebungSheet)
    }
    .sheet(isPresented: $showMachinesBeatzSheet) {
      BeatzExercisesView(
        appearance: .addExercises(split),
        showCurrentView: $showMachinesBeatzSheet
      )
    }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Menu {
        Button {
          showAddUebungSheet = true
        } label: {
          Label("Eigene Übung", systemImage: "square.and.pencil")
        }

        Button {
          showMachinesBeatzSheet = true
        } label: {
          Label("Vordefinierte Übungen", systemImage: "dumbbell.fill")
        }
      } label: {
        Image(systemName: "plus")
      }
    }
  }

  private func notesTextField() -> some View {
    TextField("Notizen", text: Binding(
      get: { split.notes },
      set: { newValue in
        split.notes = newValue
        try? CoreDataStack.shared.mainContext.save()
      }))
  }

  private func createExerciseLabel(exercise: Exercise) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(exercise.name)
        .font(.headline)

      Text("\(exercise.countSets) \(exercise.countSets == 1 ? "Satz" : "Sätze")")
        .foregroundStyle(.gray)

      TextField("Notizen", text: Binding(
        get: { exercise.notes },
        set: { newValue in
          exercise.notes = newValue
          try? CoreDataStack.shared.mainContext.save()
        }
      ))
      .foregroundStyle(.secondary)
    }
  }
}
