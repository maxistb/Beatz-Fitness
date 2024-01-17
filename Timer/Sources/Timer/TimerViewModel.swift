//
// Created by Maximillian Stabe on 01.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation
import SwiftUI

public final class TimerViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
  // Represents the different states the timer can be in
  public enum TimerState {
    case active
    case paused
    case resumed
    case cancelled
  }

  // MARK: Private Properties

  private var timer = Timer()
  private var totalTimeForCurrentSelection: Int {
    (selectedMinutesAmount * 60) + selectedSecondsAmount
  }

  // MARK: Public Properties

  @Published var selectedMinutesAmount = 1
  @Published var selectedSecondsAmount = 30
  @Published var isTimerRunning = false

  @Published var state: TimerState = .cancelled {
    didSet {
      switch state {
      case .cancelled:
        timer.invalidate()
        secondsToCompletion = 0
        progress = 0

      case .active:
        startTimer()
        secondsToCompletion = totalTimeForCurrentSelection
        progress = 1.0
        updateCompletionDate()

      case .paused:
        timer.invalidate()

      case .resumed:
        startTimer()
        updateCompletionDate()
      }
    }
  }

  // Powers the ProgressView
  @Published public var secondsToCompletion = 0
  @Published public var progress: Float = 0.0
  @Published public var completionDate = Date()

  let minutesRange = 0...59
  let secondsRange = 0...59

  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      guard let self else { return }
      isTimerRunning = true

      self.secondsToCompletion -= 1
      self.progress = Float(self.secondsToCompletion) / Float(self.totalTimeForCurrentSelection)

      if self.secondsToCompletion == 1 {
//        NotificationCenter.shared.scheduleNotification(
//          title: "Timer",
//          subtitle: "Ist abgelaufen!",
//          badge: 0,
//          triggerSeconds: 1)
      }

      // We can't do <= here because we need the time from T-1 seconds to
      // T-0 seconds to animate through first
      if self.secondsToCompletion < 0 {
        self.isTimerRunning = false
        self.state = .cancelled
      }
    })
  }

  private func updateCompletionDate() {
    completionDate = Date.now.addingTimeInterval(Double(secondsToCompletion))
  }
}
