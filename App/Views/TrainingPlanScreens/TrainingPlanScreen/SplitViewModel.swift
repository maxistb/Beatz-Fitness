//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import CoreData
import Foundation
import SwiftUI

class SplitViewModel: ObservableObject {
  func createSplit(name: String, notes: String, lastTraining: Training?, exercises: Set<Exercise>) {
    let order = (try? CoreDataStack.shared.mainContext.fetch(Split.fetchRequest()).count) ?? 0
    Split.createSplit(
      name: name,
      notes: notes,
      lastTraining: lastTraining,
      exercises: exercises,
      order: Int16(order))
  }

  func deleteSplit(splits: FetchedResults<Split>, indicesToDelete: IndexSet) {
    for indexToDelete in indicesToDelete {
      for split in splits {
        if split.order > indexToDelete {
          split.order -= 1
        } else if split.order == indexToDelete {
          CoreDataStack.shared.mainContext.delete(split)
        }
      }
    }
    try? CoreDataStack.shared.mainContext.save()
  }

  func moveSplit(splits: FetchedResults<Split>, oldIndices: IndexSet, newIndex: Int) {
    var splitArray = Array(splits)
    splitArray.move(fromOffsets: oldIndices, toOffset: newIndex)
    for (index, split) in splitArray.enumerated() {
      split.order = Int16(index)
    }
    try? CoreDataStack.shared.mainContext.save()
  }
}
