//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable function_body_length

import BeatzCoreData
import Foundation
import Styleguide
import SwiftUI

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

extension ExerciseCategory {
  func createExerciseCell(
    currentSet: TrainingSet,
    isTrainingView: Bool,
    alertCase: Binding<TrainingScreenAlerts>) -> AnyView
  {
    switch self {
    case .weightlifting, .bodyweight:
      return AnyView(
        ExerciseSetRow(
          currentSet: currentSet,
          isTrainingView: isTrainingView,
          labels: ["Gewicht", "Wdh.", "Notizen"],
          placeholders: [currentSet.weightPlaceholder, currentSet.repsPlaceholder, currentSet.notesPlaceholder],
          bindings: [
            Binding(get: { currentSet.weight },
                    set: { currentSet.weight = $0 }),
            Binding(get: { currentSet.reps },
                    set: { currentSet.reps = $0 }),
            Binding(get: { currentSet.notes },
                    set: { currentSet.notes = $0 })
          ],
          alertCase: alertCase)
      )

    case .staticexercise, .time:
      return AnyView(
        ExerciseSetRow(
          currentSet: currentSet,
          isTrainingView: isTrainingView,
          labels: ["Min.", "Sek.", "Notizen"],
          placeholders: [currentSet.minutesPlaceholder, currentSet.secondsPlaceholder, currentSet.notesPlaceholder],
          bindings: [
            Binding(get: { currentSet.minutes },
                    set: { currentSet.minutes = $0 }),
            Binding(get: { currentSet.seconds },
                    set: { currentSet.seconds = $0 }),
            Binding(get: { currentSet.notes },
                    set: { currentSet.notes = $0 })
          ],
          alertCase: alertCase)
      )

    case .supported:
      return AnyView(
        ExerciseSetRow(
          currentSet: currentSet,
          isTrainingView: isTrainingView,
          labels: ["+Gewicht", "Wdh.", "Notizen"],
          placeholders: [currentSet.weightPlaceholder, currentSet.repsPlaceholder, currentSet.notesPlaceholder],
          bindings: [
            Binding(get: { currentSet.weight },
                    set: { currentSet.weight = $0 }),
            Binding(get: { currentSet.reps },
                    set: { currentSet.reps = $0 }),
            Binding(get: { currentSet.notes },
                    set: { currentSet.notes = $0 })
          ],
          alertCase: alertCase)
      )

    case .repsonly:
      return AnyView(
        ExerciseSetRow(
          currentSet: currentSet,
          isTrainingView: isTrainingView,
          labels: ["Wdh.", "Notizen"],
          placeholders: [currentSet.repsPlaceholder, currentSet.notesPlaceholder],
          bindings: [
            Binding(get: { currentSet.reps },
                    set: { currentSet.reps = $0 }),
            Binding(get: { currentSet.notes },
                    set: { currentSet.notes = $0 })
          ],
          alertCase: alertCase)
      )

    case .cardio:
      return AnyView(
        HStack {
          Image(systemName: "\(currentSet.order + 1).circle")
            .padding(.trailing, 20)
          HStack(alignment: .top) {
            VStack(alignment: .leading) {
              CommonSetTextField(
                label: "Min",
                placeholder: currentSet.minutesPlaceholder,
                text: Binding(
                  get: { currentSet.minutes },
                  set: { currentSet.minutes = $0 }),
                alertCase: alertCase)
              CommonSetTextField(
                label: "Strecke",
                placeholder: currentSet.distanceKMPlaceholder,
                text: Binding(
                  get: { currentSet.distanceKM },
                  set: { currentSet.distanceKM = $0 }),
                alertCase: alertCase)
            }
            VStack(alignment: .leading) {
              CommonSetTextField(
                label: "Sek.",
                placeholder: currentSet.secondsPlaceholder,
                text: Binding(
                  get: { currentSet.seconds },
                  set: { currentSet.seconds = $0 }),
                alertCase: alertCase)
              CommonSetTextField(
                label: "kcal",
                placeholder: currentSet.caloriesPlaceholder,
                text: Binding(
                  get: { currentSet.calories },
                  set: { currentSet.calories = $0 }),
                alertCase: alertCase)
            }
            CommonSetTextField(
              label: "Notizen",
              placeholder: currentSet.notesPlaceholder,
              text: Binding(
                get: { currentSet.notes },
                set: { currentSet.notes = $0 }),
              alertCase: alertCase)
              .padding(.leading, -20)
          }
          if isTrainingView {
            Spacer()
            Image(systemName: "ellipsis")
              .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          }
        })
    }
  }
}

// swiftlint:enable function_body_length
