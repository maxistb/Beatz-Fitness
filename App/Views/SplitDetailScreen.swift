//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct SplitDetailScreen: View {
  private let url = URL(string: Machines.abduktormaschine.getURLForCase())

  var body: some View {
    ScrollView {
      ForEach(Machines.allCases, id: \.rawValue) { machine in
        let url = URL(string: machine.getURLForCase())

        Text(machine.getMachineName())
          .padding(.top, 5)
        LazyImage(url: url) { state in
          if let image = state.image {
            image.resizable()
              .frame(width: 250, height: 250)
          }
        }
        .padding(10)
      }
    }
  }
}
