//
//  KahootWidget.swift
//  KahootWidget
//
//  Created by Andreas Schjønhaug on 18/09/2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct KahootWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geometryProxy in
                Image("DummyImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                    .clipped()
            }
            VStack(alignment: .leading) {
                Text("TOP PICKS")
                    .font(.custom("Montserrat", size: 11, relativeTo: .title))
                    .bold()
                    .foregroundColor(Color("Title"))
                Text("World architecture")
                    .font(.custom("Montserrat", size: 12, relativeTo: .body))
                    .bold()
                    .foregroundColor(Color("Body"))

            }
            .padding(EdgeInsets(top: 4, leading: 16, bottom: 16, trailing: 16))

        }.background(Color("Background"))

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

struct KahootWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            KahootWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, colorScheme)

        }
    }
}

/*
struct DiscoverGroupSmallViewPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        let shortTitle = "Short title"
        let longTitle = "Lorem ipsum dolor sit amet consectetur adipiscing elit."
        let username = "n/a"

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in

            KahootWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, ColorScheme.dark)
                .redacted(reason: .placeholder)


        }

    }
}
*/
