//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable line_length

import NukeUI
import SwiftUI
import UIComponents

struct BeatzHomeScreen: View {
  private var beatzImage = "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTi0uRxRcnKSOUH_oa50qIq5BMT9S_sxtwcS4dN3nSbnwIAhAAsWlwsahfQzTMq1E4FwDlD2aP_V6XqVnTC6OgcW7PmWg=s1600"
  private var courseImage = "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQzBVWhE4IguB9K1pcMDGT1yigd-X99XXJbDHIWT2lUxdKDeGPYCvLQESOA4ke-b5i6AFcMspRx7Z_8jUQZQjnlrXjVBg=s1600"

  var body: some View {
    NavigationStack {
      Form {
        coursesAndTrainerSection
        trainingTimesSchedule
        sauneTimesSchedule
        contactUs
        location
        credits
      }
      .navigationBarTitle("🏠 Beatz")
    }
  }

  @MainActor
  private var coursesAndTrainerSection: some View {
    Section(header: Text("Kursplan & Unsere Trainer")) {
      NavigationLinkWithImageAndText(
        imageURLString: courseImage,
        text: "Unser Kursplan 📅",
        destination: AnyView(CoursesView())
      )

      NavigationLinkWithImageAndText(
        imageURLString: beatzImage,
        text: "Unsere Trainer 💪🏼",
        destination: AnyView(TrainerView())
      )
    }
  }

  private var trainingTimesSchedule: some View {
    Section(header: Text("Trainerzeiten ⌛️")) {
      Text("Montag bis Freitag: 8 - 13 & 15 - 20 Uhr")
      Text("Wochenende: 10 - 14 Uhr, feiertags frei")
    }
  }

  private var sauneTimesSchedule: some View {
    Section(header: Text("Saunazeiten 🧖🏼‍♂️")) {
      Text("Montag bis Freitag: 8 - 13 & 15 - 21 Uhr")
      Text("Wochenende: 10 - 14 Uhr, feiertags frei")
    }
  }

  private var contactUs: some View {
    Section(header: Text("Kontaktiere uns!")) {
      HStack {
        Link(destination: URL(string: "https://www.instagram.com/beatzfitness_elmshorn/")!) {
          HStack {
            Text("Instagram @beatzfitness_elmshorn")
            Spacer()
            Image(systemName: "arrow.up.right")
          }
        }
      }
      Link(destination: URL(string: "https://beatz-fitness.de")!) {
        HStack {
          Text("Website beatz-fitness.de")
          Spacer()
          Image(systemName: "arrow.up.right")
        }
      }
    }
  }

  private var location: some View {
    Section(header: Text("Standort")) {
      LocationView()
    }
  }

  private var credits: some View {
    Section(header: Text("App entwickelt von")) {
      NavigationLink("Credits", destination: CreditsView())
    }
  }
}

// swiftlint:enable line_length
