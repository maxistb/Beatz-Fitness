//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

class CoursesViewModel: ObservableObject {
  @Published var selectedDayIndex = 0
  @Published var days = [
    NSLocalizedString("Montag", comment: ""),
    NSLocalizedString("Dienstag", comment: ""),
    NSLocalizedString("Mittwoch", comment: ""),
    NSLocalizedString("Donnerstag", comment: ""),
    NSLocalizedString("Freitag", comment: "")
  ]
  @Published var courseTitles = [
    NSLocalizedString("Kurse für Montag", comment: ""),
    NSLocalizedString("Kurse für Dienstag", comment: ""),
    NSLocalizedString("Kurse für Mittwoch", comment: ""),
    NSLocalizedString("Kurse für Donnerstag", comment: ""),
    NSLocalizedString("Kurse für Freitag", comment: "")
  ]

  func getWeekdayName(index: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEEEE"
    return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: index, to: Date())!)
  }

  func getKurseForSelectedDay() -> [Kurs] {
    switch selectedDayIndex {
    case 0:
      return kurseMontag
    case 1:
      return kurseDienstag
    case 2:
      return kurseMittwoch
    case 3:
      return kursDonnerstag
    case 4:
      return kurseFreitag
    default:
      return []
    }
  }

  struct Kurs: Identifiable {
    var id = UUID()
    var kursname: String
    var kurszeit: String
    var anmelden: String?
    var kursmacher: String
  }

  var kurseMontag = [
    Kurs(kursname: NSLocalizedString("Functional Fitness", comment: ""), kurszeit: NSLocalizedString("9 - 10 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Dome", comment: "")),
    Kurs(kursname: NSLocalizedString("Rückenfit", comment: ""), kurszeit: NSLocalizedString("10 - 11 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Larissa", comment: "")),
    Kurs(kursname: NSLocalizedString("Jumping", comment: ""), kurszeit: NSLocalizedString("18 - 19 Uhr mit Anmeldung", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: "")),
    Kurs(kursname: NSLocalizedString("Body Complete", comment: ""), kurszeit: NSLocalizedString("19 - 20 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: ""))
  ]

  var kurseDienstag = [
    Kurs(kursname: NSLocalizedString("Yoga", comment: ""), kurszeit: NSLocalizedString("10 - 11 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Jelena", comment: "")),
    Kurs(kursname: NSLocalizedString("Knock-Out", comment: ""), kurszeit: NSLocalizedString("18 - 19 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Larissa", comment: "")),
    Kurs(kursname: NSLocalizedString("Bauch, Beine & Po", comment: ""), kurszeit: NSLocalizedString("19 - 20 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Larissa", comment: ""))
  ]

  var kurseMittwoch = [
    Kurs(kursname: NSLocalizedString("Zumba", comment: ""), kurszeit: NSLocalizedString("18 - 19 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: "")),
    Kurs(kursname: NSLocalizedString("Bauch Intensiv", comment: ""), kurszeit: NSLocalizedString("19 - 19:30 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Dome", comment: ""))
  ]

  var kursDonnerstag = [
    Kurs(kursname: NSLocalizedString("Zumba", comment: ""), kurszeit: NSLocalizedString("9:30 - 10:30 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: "")),
    Kurs(kursname: NSLocalizedString("Rückenexpress", comment: ""), kurszeit: NSLocalizedString("10:30 - 11 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: "")),
    Kurs(kursname: NSLocalizedString("Hit am Cage", comment: ""), kurszeit: NSLocalizedString("18 - 18:30 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Larissa", comment: "")),
    Kurs(kursname: NSLocalizedString("Yoga", comment: ""), kurszeit: NSLocalizedString("18 - 19", comment: ""), kursmacher: NSLocalizedString("mit Jelena", comment: "")),
    Kurs(kursname: NSLocalizedString("Piloxing", comment: ""), kurszeit: NSLocalizedString("19 - 20 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Larissa", comment: ""))
  ]

  var kurseFreitag = [
    Kurs(kursname: NSLocalizedString("Body Complete", comment: ""), kurszeit: NSLocalizedString("19 - 20 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: "")),
    Kurs(kursname: NSLocalizedString("Functional Fitness", comment: ""), kurszeit: NSLocalizedString("10 - 11 Uhr", comment: ""), kursmacher: NSLocalizedString("mit Dome", comment: "")),
    Kurs(kursname: NSLocalizedString("Jumping", comment: ""), kurszeit: NSLocalizedString("18 - 19 Uhr mit Anmeldung", comment: ""), kursmacher: NSLocalizedString("mit Birte", comment: ""))
  ]
}
