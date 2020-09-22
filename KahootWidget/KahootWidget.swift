//
//  KahootWidget.swift
//  KahootWidget
//
//  Created by Andreas Schjønhaug on 18/09/2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetTimelineEntry {
        let discoverGroup = DiscoverGroup(cardTitle: "------------",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "------",
                                          groupTitle: "--------",
                                          numberOfQuestions: 10)
        return WidgetTimelineEntry(date: Date(), discoverGroup: discoverGroup)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetTimelineEntry) -> ()) {

        let discoverGroup = DiscoverGroup(cardTitle: "World architecture",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "Jay N.",
                                          groupTitle: "Top picks",
                                          numberOfQuestions: 6)

        let entry = WidgetTimelineEntry(date: Date(), discoverGroup: discoverGroup)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let discoverGroup = DiscoverGroup(cardTitle: "World architecture",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "Jay N.",
                                          groupTitle: "Top picks",
                                          numberOfQuestions: 6)

        let entry = WidgetTimelineEntry(date: Date(), discoverGroup: discoverGroup)

        let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

        let timeline = Timeline(entries: [entry], policy: TimelineReloadPolicy.after(date))

        completion(timeline)
    }
}

struct WidgetTimelineEntry: TimelineEntry {
    let date: Date
    let discoverGroup: DiscoverGroup
}

struct KahootWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWidgetView(discoverGroup: entry.discoverGroup)
        case .systemMedium:
            MediumWidgetView(discoverGroup: entry.discoverGroup)
        @unknown default:
            fatalError()
        }

    }
}

@main
struct KahootWidget: Widget {
    let kind: String = "KahootWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KahootWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
