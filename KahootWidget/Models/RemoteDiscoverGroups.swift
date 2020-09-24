//
//  RemoteDiscoverGroups.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 28/08/2020.
//  Copyright © 2020 Kahoot! AS. All rights reserved.
//

import Foundation

/*
    To avoid the whole array of discover groups to fail
    if one element fails, we use this struct

    Remove when https://bugs.swift.org/browse/SR-5953 is fixed
 */
struct Throwable<T: Decodable>: Decodable {
    let result: Result<T, Error>

    init(from decoder: Decoder) throws {
        self.result = Result(catching: { try T(from: decoder) })
    }
}

struct RemoteDiscoverGroups: Decodable {
    let discoverGroups: [RemoteDiscoverGroup]
}

struct RemoteDiscoverGroup: Decodable {
    let data: [RemoteDiscoverGroupData]
    let title: String

    enum CodingKeys: CodingKey {
        case data
        case title
    }

    /*
        Remove when https://bugs.swift.org/browse/SR-5953 is fixed
     */
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let throwableData = try values.decode([Throwable<RemoteDiscoverGroupData>].self, forKey: .data)
        self.data = throwableData.compactMap { try? $0.result.get() }
        self.title = try values.decode(String.self, forKey: .title)
    }
}

struct RemoteDiscoverGroupData: Decodable {
    let card: RemoteDiscoverGroupCard
}

struct RemoteDiscoverGroupCard: Decodable {
    let cover: URL
    let creatorAvatar: RemoteCreatorAvatar?
    let creatorUsername: String
    let numberOfQuestions: Int
    let title: String
    let uuid: String
}

struct RemoteCreatorAvatar: Decodable {
    let url: URL?
}
