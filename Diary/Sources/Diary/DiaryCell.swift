//
// Created by Maximillian Stabe on 11.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import UIComponents
import BeatzCoreData

public struct DiaryCell: View {
  let training: Training

  public init(training: Training) {
    self.training = training
  }

  public var body: some View {
    NavigationLink {
//      TrainingScreen(split: training.split, training: training)
    } label: {
      HStack(alignment: .top) {
        DatumWidget(dayName: training.date.dayOfWeek(), dayNumber: training.date.dayNumberString())
          .padding(.leading, -5)
          .padding(.trailing, 5)
          .padding(.top, -3)

        VStack(alignment: .leading) {
          Text(training.name)
            .font(.headline)

          ForEach(training.exerciseArray, id: \.self) { exercise in
            Text("\(exercise.countSets)x \(exercise.name)")
              .font(.subheadline)
          }
        }
      }
    }
  }
}
