//
// Created by Maximillian Stabe on 12.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

extension Date {
  var diaryHeaderFormat: String {
    formatted(
      .dateTime
        .month(.wide)
        .year()
    )
  }

  func dayOfWeek() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "E"
      return dateFormatter.string(from: self).capitalized
  }

  func dayNumberString() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd"
      return dateFormatter.string(from: self)
  }
}
