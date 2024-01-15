//
// Created by Maximillian Stabe on 15.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

extension String {
  func toDouble() -> Double {
    return NumberFormatter().number(from: self)?.doubleValue ?? -1
  }

  func isDecimalNumber() -> Bool {
    let pattern = #"^\d+,\d+$|^\d+$|^\d+.\d+$|^$"#
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let range = NSRange(location: 0, length: self.utf16.count)
      if regex.firstMatch(in: self, options: [], range: range) != nil {
        return true
      }
    } catch {
      print("Error creating or using regex: \(error)")
    }
    return false
  }
}
