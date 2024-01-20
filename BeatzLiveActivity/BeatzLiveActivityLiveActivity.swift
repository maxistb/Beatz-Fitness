//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import ActivityKit
import SwiftUI
import WidgetKit

public struct BeatzLiveActivityAttributes: ActivityAttributes {
  public init(splitName: String) {
    self.splitName = splitName
  }

  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    var date: Date
    var timeSinceStart: String
    var isTimerActive: Bool
    var timerTime: String
    var currentExerciseName: String
    var currentSet: Int
    var setCount: Int
  }

  // Fixed non-changing properties about your activity go here!
  var splitName: String
}

struct BeatzLiveActivityLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: BeatzLiveActivityAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        badgeNameAndTime(context)
        if !context.state.isTimerActive {
          exerciseWithoutTimer(context)
        } else {
          exerciseWithTimer(context)
        }
      }
      .padding()
      .activityBackgroundTint(.black)

    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.leading) {
          Text(context.state.currentExerciseName)
        }
        DynamicIslandExpandedRegion(.trailing) {
          dynamicIslandTrailing(context)
        }
        DynamicIslandExpandedRegion(.bottom) {
          Text("Satz \(context.state.currentSet) von \(context.state.setCount)")
        }
      } compactLeading: {
        Text("Satz \(context.state.currentSet)/\(context.state.setCount)")
      } compactTrailing: {
        dynamicIslandTrailing(context)
      } minimal: {
        Text(context.state.currentExerciseName)
      }
      .keylineTint(Color.red)
    }
  }

  private func badgeNameAndTime(_ context: ActivityViewContext<BeatzLiveActivityAttributes>) -> some View {
    HStack {
      Text(context.attributes.splitName)
      Spacer()
      Text(context.state.date, style: .timer)
    }
  }

  private func exerciseWithoutTimer(_ context: ActivityViewContext<BeatzLiveActivityAttributes>) -> some View {
    VStack {
      Text(context.state.currentExerciseName).bold()
      Text("Satz \(context.state.currentSet) von \(context.state.setCount)")
    }
  }

  private func exerciseWithTimer(_ context: ActivityViewContext<BeatzLiveActivityAttributes>) -> some View {
    HStack {
      VStack {
        Text(context.state.currentExerciseName).bold()
        Text("Satz \(context.state.currentSet) von \(context.state.setCount)")
      }
      Spacer()
      VStack {
        Text(context.state.timerTime).font(.title).bold()
      }
    }
    .padding(.horizontal)
  }

  private func dynamicIslandTrailing(_ context: ActivityViewContext<BeatzLiveActivityAttributes>) -> some View {
    if !context.state.isTimerActive {
      Text(context.state.date, style: .timer)
    } else {
      Text("\(context.state.timerTime)")
    }
  }
}
