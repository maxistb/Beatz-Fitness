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

  private var groupedTrainings: [GroupedDiary] {
    Dictionary(grouping: trainings) { training in
      Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: training.date)) ?? Date()
    }
    .sorted(by: { $0.key > $1.key })
    .map { GroupedDiary(date: $0.key, entries: $0.value) }
  }

  var body: some View {
    NavigationStack {
      List(groupedTrainings, id: \.self) { groupedTraining in
        Section(groupedTraining.date.diaryHeaderFormat) {
          ForEach(groupedTraining.entries, id: \.self) { training in
            DiaryCell(training: training)
          }
        }
      }
      .navigationTitle("Tagebuch")
    }
  }
}

private struct GroupedDiary: Hashable {
  let date: Date
  let entries: [Training]
}
