//
// Created by Maximillian Stabe on 01.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct SwapExerciseView: View {
  @Environment(\.dismiss) private var dismiss
  let exercises: Set<Exercise>
  @State private var exerciseArray: [Exercise]

  init(exercises: Set<Exercise>) {
    self.exercises = exercises
    self._exerciseArray = State(initialValue: exercises.sorted { $0.order < $1.order })
  }

  var body: some View {
    NavigationStack {
      List {
        ForEach(exerciseArray, id: \.self) { exercise in
          Text(exercise.name)
        }
        .onMove { source, destination in
          moveExercise(source: source, destination: destination)
        }
      }
      .environment(\.editMode, .constant(.active))
      .navigationBarTitle("Übungen neu anordnen")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Fertig") { dismiss() }
        }
      }
    }
  }

  private func moveExercise(source: IndexSet, destination: Int) {
    exerciseArray.move(fromOffsets: source, toOffset: destination)

    for (index, exercise) in exerciseArray.enumerated() {
      exercise.order = Int16(index)
    }
  }
}
