//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), emoji: "😀")
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), emoji: "😀")
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, emoji: "😀")
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let emoji: String
}

struct BeatzLiveActivityEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Text("Time:")
      Text(entry.date, style: .time)

      Text("Emoji:")
      Text(entry.emoji)
    }
  }
}

struct BeatzLiveActivity: Widget {
  let kind: String = "BeatzLiveActivity"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        BeatzLiveActivityEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        BeatzLiveActivityEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  BeatzLiveActivity()
} timeline: {
  SimpleEntry(date: .now, emoji: "😀")
  SimpleEntry(date: .now, emoji: "🤩")
}
