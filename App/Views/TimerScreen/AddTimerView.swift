//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

struct AddTimerView: View {
  @Binding var isPresented: Bool
  var model: TimerViewModel

  @State private var minutes: Int = 1
  @State private var seconds: Int = 0

  var body: some View {
    VStack {
      HStack {
        TimePickerView(title: "min", range: model.minutesRange, binding: $minutes)
        TimePickerView(title: "sek", range: model.secondsRange, binding: $seconds)
      }
      .frame(width: 360, height: 255)
      .padding(.all, 32)

      Button("Add") {
        let newTimer = TimerEntity(context: CoreDataStack.shared.mainContext)
        newTimer.minutes = Int16(minutes)
        newTimer.seconds = Int16(seconds)

        do {
          try CoreDataStack.shared.mainContext.save()
          isPresented = false
        } catch {
          print("Error saving timer to Core Data: \(error)")
        }
      }
      .buttonStyle(StartButtonStyle())
      .padding(.top, 16)
    }
    .padding()
    .cornerRadius(16)
  }
}
