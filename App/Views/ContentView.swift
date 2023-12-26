//
//  ContentView.swift
//  Beatz Fitness
//
//  Created by Maximillian Stabe on 24.12.23.
//

import CoreData
import Styleguide
import SwiftUI
import UIComponents

struct ContentView: View {
  var body: some View {
    Text(L10n.trainingsplansHeader)
      .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)

    DatumWidget(dayName: "Di.", dayNumber: 22)
  }
}
