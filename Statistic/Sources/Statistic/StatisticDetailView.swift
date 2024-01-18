//
// Created by Maximillian Stabe on 18.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

struct StatisticDetailView: View {
  let split: Split

  init(split: Split) {
    self.split = split
  }

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(split.exerciseArray, id: \.self) { exercise in
          NavigationLink {
            RandomView()
          } label: {
            Text(exercise.name)
          }
        }
      }
    }
    .navigationTitle(split.name)
  }
}
