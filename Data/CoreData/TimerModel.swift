//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Timer)
public class Timer: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
    return NSFetchRequest<Timer>(entityName: "Timer")
  }

  @NSManaged public var minutes: Int16
  @NSManaged public var seconds: Int16
}
