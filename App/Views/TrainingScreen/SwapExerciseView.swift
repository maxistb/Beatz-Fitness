//
// Created by Maximillian Stabe on 01.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct SwapExerciseView: View {
  @Environment(\.dismiss) private var dismiss
  let split: Split

  var body: some View {
    NavigationStack {
      List {
        ForEach(split.splitExercises, id: \.id) { exercise in
          Text(exercise.name)
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
    split.splitExercises.move(fromOffsets: source, toOffset: destination)
  }
}
