//
// Created by Maximillian Stabe on 01.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Styleguide
import SwiftUI

struct TrainingBottomSheetView: View {
  @Environment(\.dismiss) private var dismiss
  let split: Split
  let exercise: Exercise?
  var exercises: Binding<Set<Exercise>>?

  @State private var showReplaceExerciseView = false
  @State private var showSwapExerciseView = false
  @State private var showEditExerciseView = false

  var body: some View {
    NavigationStack {
      List {
        Section {
          createListElement(label: "Ersetzen", imageName: "arrow.left.arrow.right") { showReplaceExerciseView = true }
          createListElement(label: "Löschen", imageName: "delete.left") { deleteExercise() }
          createListElement(label: "Verschieben", imageName: "rectangle.2.swap") { showSwapExerciseView = true }
          createListElement(label: "Übung bearbeiten", imageName: "square.and.pencil") { showEditExerciseView = true }
        }
      }
      .navigationTitle(exercise?.name ?? "")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button { dismiss() }
            label: { Image(systemName: "xmark.circle") }
        }
      }
      .sheet(isPresented: $showReplaceExerciseView) {
        if let exercise = exercise {
          if let exercises = exercises {
            MachinesView(
              appearance: .replaceExercise(exercises, exercise),
              showCurrentView: $showReplaceExerciseView
            )
            .onDisappear { dismiss() }
          }
        }
      }
      .sheet(isPresented: $showSwapExerciseView) {
        SwapExerciseView(exercises: exercises?.wrappedValue)
          .onDisappear { dismiss() }
      }
      .sheet(isPresented: $showEditExerciseView) {
        if let exercise = exercise {
          AddEditExerciseView(appearance: .editExercise(exercise), showCurrentView: $showEditExerciseView)
            .onDisappear { dismiss() }
        }
      }
    }
  }

  private func createListElement(label: String, imageName: String, action: @escaping () -> Void) -> some View {
    HStack {
      Text(label)
      Spacer()
      Image(systemName: imageName)
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
    .contentShape(Rectangle())
    .onTapGesture { action() }
  }

  private func deleteExercise() {
    if let exercise = exercise {
      if let exercises = exercises {
        exercises.wrappedValue.remove(exercise)
        dismiss()
      }
    }
  }
}
