//
//  KahootWidget.swift
//  KahootWidget
//
//  Created by Andreas Schjønhaug on 18/09/2020.
//

import Combine
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
        return WidgetTimelineEntry(date: Date(),
                                   discoverGroup: discoverGroup,
                                   widgetURL: URL(string: "https://kahoot.com")!)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetTimelineEntry) -> ()) {

        let discoverGroup = DiscoverGroup(cardTitle: "World architecture",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "Jay N.",
                                          groupTitle: "Top picks",
                                          numberOfQuestions: 6)

        let entry = WidgetTimelineEntry(date: Date(),
                                        discoverGroup: discoverGroup,
                                        widgetURL: URL(string: "https://kahoot.com")!)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        DispatchQueue.main.async {

            self.downloadDiscoverGroup({ result in

                guard let data = try? result.get() else { return }
                self.createDiscoverGroupTimeline(data, completion: completion)

            })

        }

    }

    private func downloadDiscoverGroup(_ completion: @escaping (Result<Data, Error>) -> Void) {

        let url = URL(string: "https://create.kahoot.it/rest/campaigns/discovergroups/")!

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "primaryUsage", value: "student"),
            URLQueryItem(name: "includeKahoot", value: "false"),
            URLQueryItem(name: "language", value: "en"),
        ]

        urlComponents?.queryItems = queryItems

        guard let requestUrl = urlComponents?.url else {
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        URLSession.shared.dataTask(with: requestUrl) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                // No-op
            }
        }.resume()



    }

    private func createDiscoverGroupTimeline(_ data: Data, completion: @escaping (Timeline<Entry>) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let remoteDiscoverGroups = try decoder.decode(RemoteDiscoverGroups.self, from: data)

            guard
                let firstDiscoverGroups = remoteDiscoverGroups.discoverGroups.first,
                firstDiscoverGroups.data.isEmpty == false
            else {
                return
            }

            let data = firstDiscoverGroups.data.randomElement()!

            var coverUIImage: UIImage?
            var creatorAvatarUIImage: UIImage?

            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            dispatchGroup.enter()

            // Download cover and avatar image


            URLSession.shared.dataTask(with: data.card.cover) { data, _, _ in

                if let data = data {
                    coverUIImage = UIImage(data: data)
                }

                dispatchGroup.leave()

            }.resume()

            if let creatorAvatarImageURL = data.card.creatorAvatar?.url {


                URLSession.shared.dataTask(with: creatorAvatarImageURL) { data, _, _ in

                    if let data = data {
                        creatorAvatarUIImage = UIImage(data: data)
                    }

                    dispatchGroup.leave()

                }.resume()

            } else {
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: DispatchQueue.main) {

                guard let coverUIImage = coverUIImage else { return }
                let coverImage = Image(uiImage: coverUIImage)


                let creatorAvatarImage: Image?

                if let creatorAvatarUIImage = creatorAvatarUIImage {
                    creatorAvatarImage = Image(uiImage: creatorAvatarUIImage)
                } else {
                    creatorAvatarImage = nil
                }


                let discoverGroup = DiscoverGroup(
                    cardTitle: data.card.title,
                    coverImage: coverImage,
                    creatorAvatarImage: creatorAvatarImage,
                    creatorUsername: data.card.creatorUsername,
                    groupTitle: firstDiscoverGroups.title,
                    numberOfQuestions: data.card.numberOfQuestions
                )

                let widgetURL = URL(string: "kahoot://quiz/\(data.card.uuid)")!

                let entry = WidgetTimelineEntry(date: Date(),
                                                discoverGroup: discoverGroup,
                                                widgetURL: widgetURL)

                let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                let timeline = Timeline(entries: [entry], policy: TimelineReloadPolicy.after(date))

                completion(timeline)
            }
        } catch {
           // No-op
        }
    }
}

struct WidgetTimelineEntry: TimelineEntry {
    let date: Date
    let discoverGroup: DiscoverGroup
    let widgetURL: URL
}

struct KahootWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch widgetFamily {
            case .systemSmall:
                SmallWidgetView(discoverGroup: entry.discoverGroup)
            case .systemMedium:
                MediumWidgetView(discoverGroup: entry.discoverGroup)
            case .systemLarge:
                LargeWidgetView(discoverGroup: entry.discoverGroup)
            @unknown default:
                fatalError()
            }
        }.widgetURL(entry.widgetURL)
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
