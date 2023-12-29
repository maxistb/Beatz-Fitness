//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct SplitScreen: View {
  @FetchRequest(
    entity: Exercise.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)]
  ) var exercises: FetchedResults<Exercise>
  @ObservedObject private var viewModel = UebungViewModel()

  @State private var showAddUebungSheet = false
  @State private var showMachinesBeatzSheet = false

  let split: Split

  var body: some View {
    Form {
      Section {
        NavigationLink("Training starten", destination: SplitDetailScreen())
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
        notesTextField()
      }

      Section("Übungen") {
        ForEach(exercises.filter { $0.exerciseSplit == split }, id: \.self) { exercise in
          NavigationLink { SplitDetailScreen() }
            label: { createExerciseLabel(exercise: exercise) }
        }
        .onDelete { indexSet in viewModel.deleteExercise(exercises: exercises, indicesToDelete: indexSet) }
        .onMove { indices, newOffset in viewModel.moveExercise(exercises: exercises, oldIndices: indices, newIndex: newOffset) }
      }
    }
    .navigationTitle(split.name)
    .toolbar { createToolbar() }
    .sheet(isPresented: $showAddUebungSheet) { AddUebungView(split: split, viewModel: viewModel) }
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
      Text("\(exercise.order) \(exercise.name)")
        .font(.headline)

      Text("\(exercise.countSets) \(exercise.countSets == 1 ? "Satz" : "Sätze")")
        .foregroundColor(.gray)

      TextField("Notizen", text: Binding(
        get: { exercise.notes },
        set: { newValue in
          exercise.notes = newValue
          try? CoreDataStack.shared.mainContext.save()
        }
      ))
      .foregroundColor(.secondary)
    }
  }
}
