//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import ActivityKit
import BeatzCoreData
import SwiftUI

public struct TimerView: View {
  @ObservedObject var model: TimerViewModel
  @Environment(\.dismiss) private var dismiss

  public init(model: TimerViewModel) {
    self.model = model
  }

  var timerControls: some View {
    HStack {
      Button("Abbruch") {
        model.state = .cancelled
      }
      .buttonStyle(CancelButtonStyle())

      Spacer()

      switch model.state {
      case .cancelled:
        Button("Start") {
          model.state = .active
        }
        .buttonStyle(StartButtonStyle())
      case .paused:
        Button("Weiter") {
          model.state = .resumed
        }
        .buttonStyle(PauseButtonStyle())
      case .active, .resumed:
        Button("Pause") {
          model.state = .paused
        }
        .buttonStyle(PauseButtonStyle())
      }
    }
    .padding(.horizontal, 32)
  }

  var timePickerControl: some View {
    HStack {
      TimePickerView(title: "min", range: model.minutesRange, binding: $model.selectedMinutesAmount)
      TimePickerView(title: "sek", range: model.secondsRange, binding: $model.selectedSecondsAmount)
    }
    .frame(width: 360, height: 255)
    .padding(.all, 32)
  }

  var progressView: some View {
    ZStack {
      withAnimation {
        CircularProgressView(progress: $model.progress)
      }

      VStack {
        Text(model.secondsToCompletion.asTimestamp)
          .font(.largeTitle)
        HStack {
          Image(systemName: "bell.fill")
          Text(model.completionDate, format: .dateTime.hour().minute())
        }
      }
    }
    .frame(width: 360, height: 255)
    .padding(.all, 32)
  }

  public var body: some View {
    NavigationView {
      VStack {
        if model.state == .cancelled {
          timePickerControl
        } else {
          progressView
        }

        timerControls

        Spacer()
        AddTimerSection(model: model)
          .padding()
        Spacer()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            dismiss.callAsFunction()
          } label: {
            Image(systemName: "xmark.circle.fill")
          }
        }
      }
    }
  }
}

private struct AddTimerSection: View {
  @FetchRequest(
    entity: TimerEntity.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \TimerEntity.minutes, ascending: true),
      NSSortDescriptor(keyPath: \TimerEntity.seconds, ascending: true)
    ])
  private var timers: FetchedResults<TimerEntity>

  @State private var showAddTimerView = false
  @State private var showEditTimerView = false
  var model: TimerViewModel

  var body: some View {
    VStack {
      HStack {
        Text("Timer").font(.title2).padding()
        Spacer()
        Button {
          showEditTimerView = true
        } label: {
          Image(systemName: "square.and.pencil").font(.title2).padding()
        }
      }
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .center) {
          Button("\(Image(systemName: "plus"))") {
            showAddTimerView = true
          }
          .buttonStyle(PauseButtonStyle())
          .padding(.top, 16)

          ForEach(timers.indices, id: \.self) { index in
            let timer = timers[index]
            let formattedTimer = String(format: "%02d:%02d", timer.minutes, timer.seconds)

            Button(formattedTimer) {
              startTimer(at: index)
            }
            .buttonStyle(StartButtonStyle())
            .padding(.top, 16)
          }
        }
      }
    }
    .sheet(isPresented: $showAddTimerView) {
      AddTimerView(isPresented: $showAddTimerView, model: model)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    .sheet(isPresented: $showEditTimerView) {
      EditTimerView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
  }

  private func startTimer(at index: Int) {
    model.state = .cancelled
    let timer = timers[index]
    model.selectedMinutesAmount = Int(timer.minutes)
    model.selectedSecondsAmount = Int(timer.seconds)
    model.state = .active
  }
}
