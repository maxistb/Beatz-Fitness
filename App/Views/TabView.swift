//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzHome
import Diary
import Split
import Styleguide
import SwiftUI

struct BottomTabView: View {
  var body: some View {
    TabView {
      SplitScreen()
        .tabItem {
          Image(systemName: "list.clipboard.fill")
          Text(L10n.trainingplans)
        }
        .toolbarBackground(.visible, for: .tabBar)

      DiaryScreen()
        .tabItem {
          Image(systemName: "book")
          Text(L10n.trainingbook)
        }
        .toolbarBackground(.visible, for: .tabBar)

      DiaryScreen()
        .tabItem {
          Image(systemName: "chart.bar.xaxis")
          Text(L10n.statistic)
        }
        .toolbarBackground(.visible, for: .tabBar)

      BeatzHomeScreen()
        .tabItem {
          Image(systemName: "house.fill")
          Text(L10n.beatz)
        }
        .toolbarBackground(.visible, for: .tabBar)
    }
    .navigationBarBackButtonHidden()
    .tint(Asset.Color.beatzColor.swiftUIColor)
  }
}
