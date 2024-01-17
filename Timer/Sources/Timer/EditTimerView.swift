//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import SwiftUI
import BeatzCoreData

struct EditTimerView: View {
  @State private var editMode: EditMode = .active
  @Environment(\.dismiss) private var dismiss

  @FetchRequest(
    entity: TimerEntity.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \TimerEntity.minutes, ascending: true),
      NSSortDescriptor(keyPath: \TimerEntity.seconds, ascending: true)
    ],
    animation: .default)
  private var timers: FetchedResults<TimerEntity>

  var body: some View {
    NavigationView {
      List {
        ForEach(timers.indices, id: \.self) { index in
          let timer = timers[index]
          let formattedTimer = String(format: "%02d:%02d", timer.minutes, timer.seconds)

          Text(formattedTimer)
        }
        .onDelete(perform: deleteTimers)
      }
      .navigationBarTitle("Timer bearbeiten")
      .navigationBarItems(trailing: doneButton)
      .environment(\.editMode, $editMode)
    }
  }

  private var doneButton: some View {
    Button("Fertig", action: {
      dismiss.callAsFunction()
    })
  }

  private func deleteTimers(at offsets: IndexSet) {
    offsets.forEach { index in
      let timer = timers[index]
      CoreDataStack.shared.mainContext.delete(timer)
    }

    try? CoreDataStack.shared.mainContext.save()
  }
}
