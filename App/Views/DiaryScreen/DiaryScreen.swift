//
// Created by Maximillian Stabe on 11.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct DiaryScreen: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Training.date,
        ascending: false)
    ])
  var trainings: FetchedResults<Training>

  var body: some View {
    NavigationStack {
      List(trainings, id: \.self) { training in
        Section(training.name) {
          DiaryCell(training: training)
        }
      }
      .navigationTitle("Tagebuch")
    }
  }
}
