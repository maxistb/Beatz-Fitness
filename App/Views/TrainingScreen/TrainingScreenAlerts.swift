//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

enum TrainingScreenAlerts: Equatable {
  static func == (lhs: TrainingScreenAlerts, rhs: TrainingScreenAlerts) -> Bool {
    lhs.getAlertMessage == rhs.getAlertMessage
    && lhs.getAlertTitle == rhs.getAlertTitle
  }

  case saveTraining(DismissAction, TrainingViewModel, Split)
  case exitTraining(DismissAction)
  case saveAsTrainingplan(TrainingViewModel)
  case notDecimalInput

  var createAlert: Alert {
    switch self {
    case .saveTraining:
      Alert(
        title: Text(self.getAlertTitle),
        message: Text(self.getAlertMessage),
        dismissButton: .default(
          Text("OK"),
          action: { self.action() }))
    case .exitTraining:
      Alert(
        title: Text(self.getAlertTitle),
        message: Text(self.getAlertMessage),
        primaryButton: .cancel(Text("Abbrechen")),
        secondaryButton: .default(
          Text("OK"),
          action: { self.action() }))
    case .saveAsTrainingplan:
      Alert(
        title: Text(self.getAlertTitle),
        message: Text(self.getAlertMessage),
        primaryButton: .cancel(Text("Abbrechen")),
        secondaryButton: .default(
          Text("OK"),
          action: { self.action() }))
    case .notDecimalInput:
      Alert(
        title: Text(self.getAlertTitle),
        message: Text(self.getAlertMessage),
        dismissButton: .default(Text("OK")))
    }
  }

  private var getAlertTitle: String {
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

  private var getAlertMessage: String {
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

  private var action: () -> Void {
    switch self {
    case .saveTraining(let dismissAction, let viewModel, _):
        viewModel.saveTraining()
        return dismissAction.callAsFunction
    case .exitTraining(let dismissAction):
      return dismissAction.callAsFunction
    case .saveAsTrainingplan(let viewModel):
      return viewModel.saveAsTrainingPlan
    case .notDecimalInput:
      return {}
    }
  }
}
