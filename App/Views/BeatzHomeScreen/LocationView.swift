//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable line_length

import MapKit
import SwiftUI

struct LocationView: View {
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 53.749339,
      longitude: 9.697741),
    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
  @State private var showOpenInMaps = false

  var body: some View {
    ZStack {
      Map(coordinateRegion: $region)
        .frame(width: 330, height: 300)
        .edgesIgnoringSafeArea(.all)
        .cornerRadius(5)
      Rectangle()
        .fill(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
          showOpenInMaps = true
        }
    }
    .confirmationDialog("In Apple Karten öffnen", isPresented: $showOpenInMaps) {
      Button("In Apple Karten öffnen") {
        openInAppleMaps()
      }
      Button("In Google Maps öffnen") {
        openInGoogleMaps()
      }
    }
  }

  func openInAppleMaps() {
    let url = URL(string: "https://maps.apple.com/?address=Neuenkampsweg%203,%2025337%20K%C3%B6lln-Reisiek,%20Deutschland&auid=8460362964946639432&ll=53.749339,9.697741&lsp=9902&q=Beatz%20Fitness")!
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  func openInGoogleMaps() {
    let url = URL(string: "https://www.google.de/maps/place/Beatz+Fitness+GmbH/@53.7495187,9.6939435,17z/data=!4m14!1m7!3m6!1s0x47b3d56a1ecfbbd9:0x2fa88e3c6b9ddd96!2sBeatz+Fitness+GmbH!8m2!3d53.7495187!4d9.6965184!16s%2Fg%2F11rypdsj0c!3m5!1s0x47b3d56a1ecfbbd9:0x2fa88e3c6b9ddd96!8m2!3d53.7495187!4d9.6965184!16s%2Fg%2F11rypdsj0c?entry=ttu")!
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
