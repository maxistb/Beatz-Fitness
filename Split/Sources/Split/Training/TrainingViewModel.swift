//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

class TrainingViewModel: ObservableObject {
  @Published var showSwapExerciseSheet: Bool = false
  @Published var showExerciseBottomSheet: Bool = false
  @Published var showTimer: Bool = false
  @Published var showAlert: Bool = false
  @Published var showAddExerciseSheet: Bool = false
  @Published var forceViewUpdate: Bool = false

  @Published var bodyWeight: String = ""
  @Published var notes: String = ""

  @Published var copyExercises: Set<Exercise> = []
  @Published var split: Split
  @Published var training: Training?

  @Published var alertCase: TrainingScreenAlerts = .notDecimalInput
  private let startingTime: Date

  var copyExerciseArray: [Exercise] {
    copyExercises.sorted { $0.order < $1.order }
  }

  init(split: Split, training: Training?) {
    self.split = split
    self.training = training
    self.startingTime = Date.now
    self.copyExercises = createExerciseCopy(from: split.exercises)

    if let training = training {
      self.bodyWeight = training.bodyWeight
      self.notes = training.notes
    }
  }

  private func createExerciseCopy(from exercises: Set<Exercise>) -> Set<Exercise> {
    var localCopy: Set<Exercise> = []
    for exercise in split.exercises {
      let exerciseCopy = Exercise.createTrainingExercise(
        name: exercise.name,
        category: exercise.category,
        countSets: Int(exercise.countSets),
        notes: exercise.notes,
        order: Int(exercise.order)
      )
      localCopy.insert(exerciseCopy)
    }

    return localCopy
  }

  private func saveExercisesForTraining(_ training: Training) {
    for exercise in copyExercises {
      exercise.training = training
    }
  }

  func adjustExercise() {
    guard let lastTraining = split.lastTraining else { return }

    for exercise in copyExercises {
      if let trainingExercise = lastTraining.exercises.first(where: { $0.name == exercise.name }) {
        for exerciseSet in exercise.trainingSets {
          if let trainingSet = trainingExercise.trainingSets.first(where: { $0.order == exerciseSet.order }) {
            exerciseSet.caloriesPlaceholder = trainingSet.calories
            exerciseSet.repsPlaceholder = trainingSet.reps
            exerciseSet.notesPlaceholder = trainingSet.notes
            exerciseSet.minutesPlaceholder = trainingSet.minutes
            exerciseSet.secondsPlaceholder = trainingSet.seconds
            exerciseSet.distanceKMPlaceholder = trainingSet.distanceKM
            exerciseSet.weightPlaceholder = trainingSet.weight
          }
        }
      }
    }
  }

  func startLiveActivity() {
//    let state1 = BeatzLiveActivityAttributes
//    let state = LiveActivityAttributes.ContentState(
//      datum: startDate,
//      timeSinceStart: updateTimeDisplay(),
//      isTimerActive: isTimerActive,
//      timerTime: timerTime,
//      currentUebung: currentUebungName,
//      currentSatz: currentSatz,
//      saetzeCount: saetzeCount
//    )
//    do {
//      let activity = try Activity<BeatzLiveActivity>
//        .request(attributes: attributes, content: ActivityContent(state: state, staleDate: .distantFuture), pushType: nil)
//      activityId = activity.id
//    } catch {
//      print(error.localizedDescription)
//    }
  }
}

// MARK: - Public Functions

extension TrainingViewModel {
  func deleteSet(exercise: Exercise, indexSet: IndexSet, isInitial: Bool = false) {
    if !exercise.trainingSets.isEmpty {
      withAnimation {
        for indexToDelete in indexSet {
          for trainingSet in exercise.trainingSets {
            if trainingSet.order > indexToDelete {
              trainingSet.order -= 1
            } else if trainingSet.order == indexToDelete {
              CoreDataStack.shared.mainContext.delete(trainingSet)
            }
          }
        }

        if !isInitial { exercise.countSets -= 1 }
        forceViewUpdate.toggle()
      }
      try? CoreDataStack.shared.mainContext.save()
    }
  }

  func addTrainingSet(exercise: Exercise, isInitial: Bool = false) {
    withAnimation {
      let newOrder = Int(exercise.trainingSets.count)
      let newTrainingSet = TrainingSet.createTrainingSet(exercise: exercise, order: newOrder)
      exercise.addToTrainingSets(newTrainingSet)

      if !isInitial { exercise.countSets += 1 }
      forceViewUpdate.toggle()
    }
    try? CoreDataStack.shared.mainContext.save()
  }

  func saveTraining() {
    if alertCase != .notDecimalInput {
      let training = Training.createTraining(split: split)
      training.bodyWeight = bodyWeight
      training.date = startingTime
      training.endTraining = Date.now
      training.notes = notes
      split.lastTraining = training
      saveExercisesForTraining(training)

      try? CoreDataStack.shared.mainContext.save()
    }
  }

  func generateTestData() {
    #warning("Only for Testing purpose")
    TestDataManager.shared.createDummyTraining()
  }

  func initializeTrainingSets() {
    for splitExercise in copyExerciseArray {
      let exerciseCount = splitExercise.trainingSets.count
      let targetCount = Int(splitExercise.countSets)

      // Initiate or remove sets if they have been changed
      switch exerciseCount {
      case targetCount:
        continue
      case _ where exerciseCount < targetCount:
        for _ in exerciseCount ..< targetCount {
          addTrainingSet(exercise: splitExercise, isInitial: true)
        }
      case _ where exerciseCount > targetCount:
        for index in targetCount ..< exerciseCount {
          deleteSet(exercise: splitExercise, indexSet: IndexSet(integer: index), isInitial: true)
        }
      default:
        break
      }
    }
  }

  func saveAsTrainingPlan() {
    split.exercises.removeAll()

    for exercise in copyExercises {
      Exercise.createExercise(
        name: exercise.name,
        category: exercise.category,
        countSets: Int(exercise.countSets),
        notes: exercise.notes,
        order: Int(exercise.order),
        split: split
      )
    }

    try? CoreDataStack.shared.mainContext.save()
  }

  func getExerciseCategoryForString(exerciseCategory: String) -> ExerciseCategory {
    switch exerciseCategory {
    case "staticexercise":
      return .staticexercise
    case "bodyweight":
      return .bodyweight
    case "supported":
      return .supported
    case "repsonly":
      return .repsonly
    case "time":
      return .time
    case "cardio":
      return .cardio
    default:
      return .weightlifting
    }
  }
}

public class TestDataManager {
  public static let shared = TestDataManager()

  private init() {}

  public func createDummyTraining() {
    let context = CoreDataStack.shared.mainContext
    let currentDate = Date()
    let calendar = Calendar.current

    for dayOffset in 0...1000 {
      guard let previousDay = calendar.date(byAdding: .day, value: -dayOffset, to: currentDate) else {
        continue
      }

      if dayOffset % 3 == 0 {
        let training = Training(context: context)
        training.date = previousDay
        training.name = "TestData"
        training.bodyWeight = String(Double.random(in: 60...85).rounded())
        training.id = UUID()

        // Generate a random time interval between 60 and 150 minutes in seconds
        let randomTimeInterval = TimeInterval(Int.random(in: 60...160) * 60)

        // Subtract the random time interval from previousDay to get the endTraining date
        training.endTraining = previousDay.addingTimeInterval(randomTimeInterval)

        training.bodyWeight = String(Double(Int.random(in: 80...85)))
        generateData(training: training, previousDay: previousDay)
      }
    }

    try? context.save()
  }

  func generateRandomDate() -> Date {
    let randomTimeInterval = TimeInterval.random(in: -900...0) * 24 * 60 * 60 // within the last year
    return Date().addingTimeInterval(randomTimeInterval)
  }

  func generateData(training: Training, previousDay: Date) {
    let context = CoreDataStack.shared.mainContext
    let newExercise = Exercise(context: context)
    newExercise.name = "Brustpresse"
    newExercise.countSets = Int16(Int.random(in: 1...15))
    newExercise.id = UUID()
    newExercise.training = training

    for index in 0 ..< newExercise.countSets {
      let trainingSet = TrainingSet(context: context)
      trainingSet.id = UUID()
      trainingSet.weight = String(Int.random(in: 10...40))
      trainingSet.reps = String(Int.random(in: 8...14))
      trainingSet.distanceKM = String(Int.random(in: 1...59))
      trainingSet.calories = String(Int.random(in: 10...40))
      trainingSet.minutes = String(Int.random(in: 1...3))
      trainingSet.seconds = String(Int.random(in: 1...59))
      trainingSet.category = "weightlifting"
      trainingSet.date = previousDay
      trainingSet.order = Int16(index + 1)
      trainingSet.exercise = newExercise
    }

    let secondExercise = Exercise(context: context)
    secondExercise.name = "Butterfly"
    secondExercise.countSets = Int16(Int.random(in: 1...15))
    secondExercise.id = UUID()
    secondExercise.training = training

    for index in 0 ..< secondExercise.countSets {
      let trainingSet = TrainingSet(context: context)
      trainingSet.id = UUID()
      trainingSet.weight = String(Int.random(in: 10...40))
      trainingSet.reps = String(Int.random(in: 8...14))
      trainingSet.distanceKM = String(Int.random(in: 1...59))
      trainingSet.calories = String(Int.random(in: 10...40))
      trainingSet.minutes = String(Int.random(in: 1...3))
      trainingSet.seconds = String(Int.random(in: 1...59))
      trainingSet.category = "weightlifting"
      trainingSet.date = previousDay
      trainingSet.order = Int16(index + 1)
      trainingSet.exercise = secondExercise
    }
  }
}
