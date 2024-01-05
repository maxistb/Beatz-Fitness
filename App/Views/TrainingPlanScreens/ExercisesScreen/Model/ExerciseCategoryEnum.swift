//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

enum ExerciseCategory: String {
  case weightlifting
  case staticexercise
  case bodyweight
  case supported
  case repsonly
  case time
  case cardio

  func getHeader() -> String {
    switch self {
    case .weightlifting, .bodyweight:
      "Gewicht, Wdh."
    case .staticexercise:
      "Gewicht, Zeit"
    case .supported:
      "Unterstützte Übungen"
    case .repsonly:
      "Wdh."
    case .time:
      "Zeit"
    case .cardio:
      "Zeit, Strecke, kcal"
    }
  }

  func getSubHeader() -> String {
    switch self {
    case .weightlifting:
      "Bankdrücken, Brustpresse"
    case .staticexercise:
      "Statische Übungen"
    case .bodyweight:
      "Klimmzug, Dips"
    case .supported:
      "Klimmzug Unterstützt, Dips Unterstützt"
    case .repsonly:
      "Muscle-Up, Liegestütze"
    case .time:
      "Plank, Flagge"
    case .cardio:
      "Laufen, Fahrrad, Stepper"
    }
  }

  func getSectionsAndHeader() -> [([ExerciseCategory], String)] {
    [(getWeightliftingSection(), "Krafttraining"),
     (getBodyweightSection(), "Eigengewicht"),
     (getCardioSection(), "Cardio")]
  }

  func getCategoryHeader() -> String {
    switch self {
    case .weightlifting, .staticexercise:
      return "Krafttraining"
    case .bodyweight, .supported, .repsonly, .time:
      return "Eigengewicht"
    case .cardio:
      return "Cardio"
    }
  }

  private func getWeightliftingSection() -> [ExerciseCategory] {
    [.weightlifting, .staticexercise]
  }

  private func getBodyweightSection() -> [ExerciseCategory] {
    [.bodyweight, .supported, .repsonly, .time]
  }

  private func getCardioSection() -> [ExerciseCategory] {
    [.cardio]
  }
}
