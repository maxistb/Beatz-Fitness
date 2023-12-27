//
//  Beatz_FitnessApp.swift
//  Beatz Fitness
//
//  Created by Maximillian Stabe on 24.12.23.
//

import CoreData
import SwiftUI

@main
struct BeatzFitnessApp: App {
  var body: some Scene {
    WindowGroup {
      BottomTabView()
        .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)
    }
  }
}
