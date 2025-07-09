////
////  LockScreenWidget.swift
////  LockScreenWidget
////
////  Created by eslam kamel on 07/07/2025.
////
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), emoji: "😀")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), emoji: "😀")
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, emoji: "😀")
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//
////    func relevances() async -> WidgetRelevances<Void> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let emoji: String
//}
//
//struct LockScreenWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Islamic Calendar - Lock screen widget")
////            Text(entry.date, style: .time)
////
////            Text("Emoji:")
////            Text(entry.emoji)
//        }
//    }
//}
//
//struct LockScreenWidget: Widget {
//    let kind: String = "LockScreenWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                LockScreenWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                LockScreenWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([
//            .accessoryCircular,
//            .accessoryRectangular,
//            .accessoryInline
//        ])
//    }
//}
//
//#Preview(as: .systemSmall) {
//    LockScreenWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    let appGroupID = "group.com.gaztec.lockwidget"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = loadEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadEntry() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: appGroupID)
        let count = defaults?.integer(forKey: "counter") ?? 0
        return SimpleEntry(date: Date(), counter: count)
    }
}

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let counter: Int
}

// MARK: - Widget UI
struct LockScreenWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Count:")
                .font(.caption)
            Text("\(entry.counter)")
                .font(.title2)
                .bold()
        }
    }
}

// MARK: - Widget Configuration
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                LockScreenWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LockScreenWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Counter Widget")
        .description("Shows the counter from the Flutter app.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

// MARK: - Preview
#Preview(as: .accessoryRectangular) {
    LockScreenWidget()
} timeline: {
    SimpleEntry(date: .now, counter: 1)
    SimpleEntry(date: .now, counter: 42)
}
