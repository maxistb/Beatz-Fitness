//
// Created by Maximillian Stabe on 08.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(TimerEntity)
public class TimerEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TimerEntity> {
    return NSFetchRequest<TimerEntity>(entityName: "TimerEntity")
  }

  @NSManaged public var minutes: Int16
  @NSManaged public var seconds: Int16

  class func createTimerEntity(seconds: Int16, minutes: Int16) {
    let newTimer = TimerEntity(context: CoreDataStack.shared.mainContext)
    newTimer.seconds = seconds
    newTimer.minutes = minutes
  }
}

extension Int {
  var asTimestamp: String {
    let minute = self / 60 % 60
    let second = self % 60

    return String(format: "%02i:%02i", minute, second)
  }
}
