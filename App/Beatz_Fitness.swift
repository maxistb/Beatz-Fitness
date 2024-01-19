//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
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
