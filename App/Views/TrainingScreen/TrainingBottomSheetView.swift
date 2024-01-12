//
// Created by Maximillian Stabe on 01.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

#warning("TODO: Implement Functions")

struct TrainingBottomSheetView: View {
  @Environment(\.dismiss) private var dismiss
  let split: Split
  let exercise: Exercise
  let exercises: Set<Exercise>

  @State private var showReplaceExerciseView = false
  @State private var showSwapExerciseView = false
  @State private var showEditExerciseView = false

  var body: some View {
    NavigationStack {
      List {
        Section {
          createListElement(label: "Ersetzen", imageName: "arrow.left.arrow.right") { showReplaceExerciseView = true }
          createListElement(label: "Löschen", imageName: "delete.left") { }
          createListElement(label: "Verschieben", imageName: "rectangle.2.swap") { showSwapExerciseView = true }
          createListElement(label: "Übung bearbeiten", imageName: "square.and.pencil") { showEditExerciseView = true }
        }
      }
      .navigationTitle(exercise.name)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button { dismiss() }
            label: { Image(systemName: "xmark.circle") }
        }
      }
      .sheet(isPresented: $showReplaceExerciseView) { BeatzExercisesView(split: split, action: {}) }
      .sheet(isPresented: $showSwapExerciseView) { SwapExerciseView(exercises: exercises) }
      .sheet(isPresented: $showEditExerciseView) { AddEditUebungView(split: split, exercise: exercise) }
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
}
