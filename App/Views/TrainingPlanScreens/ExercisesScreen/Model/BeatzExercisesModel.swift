//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation



struct BeatzExerciseModel {
  let name: String
  let category: String
  let imageURL: String
}

struct Machines: Codable {
  let machines: [Machine]

  enum CodingKeys: String, CodingKey {
    case machines = "Machines"
  }
}

struct Machine: Codable, Hashable {
  let displayName: String
  let muscleGroup: MachineMuscleGroup
  let category: MachineCategory
  let imageURL: String
  let description: String

  enum CodingKeys: String, CodingKey {
    case displayName, muscleGroup, category, description
    case imageURL = "imageUrl"
  }
}

enum MachineCategory: String, Codable {
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
    [(getWeightliftingSection(), "Krafttraining"), (getBodyweightSection(), "Eigengewicht"), (getCardioSection(), "Cardio")]
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

enum MachineMuscleGroup: String, Codable {
  case chest
  case back
  case legs
  case shoulder
  case cardio
  case core
  case bicep
  case tricep

  static let allCases: [MachineMuscleGroup] = [
    .core,
    .legs,
    .bicep,
    .chest,
    .cardio,
    .back,
    .shoulder,
    .tricep
  ]

  func getName() -> String {
    switch self {
    case .chest:
      "Brust"
    case .back:
      "Rücken"
    case .legs:
      "Beine"
    case .shoulder:
      "Schultern"
    case .cardio:
      "Cardio"
    case .core:
      "Bauch"
    case .bicep:
      "Bizeps"
    case .tricep:
      "Trizeps"
    }
  }
}
