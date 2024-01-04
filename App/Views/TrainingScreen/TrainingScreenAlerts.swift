//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

enum TrainingScreenAlerts {
  case saveTraining
  case exitTraining
  case saveAsTrainingplan
  case notDecimalInput

  var getAlertTitle: String {
    switch self {
    case .saveTraining:
      "Training abgeschlossen"
    case .exitTraining:
      "Möchtest du das Training abbrechen?"
    case .saveAsTrainingplan:
      "Gespeichert"
    case .notDecimalInput:
      "Error"
    }
  }

  var getAlertMessage: String {
    switch self {
    case .saveTraining:
      "Das Training wurde erfolgreich gespeichert."
    case .exitTraining:
      "Die Daten werden nicht gespeichert."
    case .saveAsTrainingplan:
      "Der Trainingsplan wurde mit den aktuellen Änderungen überschrieben."
    case .notDecimalInput:
      "Gib nur Dezimalzahlen ein"
    }
  }

  var action: () -> Void {
    switch self {
    case .saveTraining:
      {}
    case .exitTraining:
      {}
    case .saveAsTrainingplan:
      {}
    case .notDecimalInput:
      {}
    }
  }
}
