//
//  MediumWidgetView.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 22/09/2020.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {

    let discoverGroup: DiscoverGroup

    var body: some View {
        HStack(spacing: 5) {
            Image("DiscoverGroupIcon")
            Text(discoverGroup.groupTitle)
                .font(.custom("Montserrat", size: 11, relativeTo: .headline))
                .bold()
                .lineLimit(2)
                .textCase(.uppercase)
            Spacer()
            Image("K!Logo")
                .unredacted()
        }
    }
}

struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {

        let discoverGroup = DiscoverGroup(cardTitle: "World architecture",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "Jay N.",
                                          groupTitle: "Top picks",
                                          numberOfQuestions: 6)

        MediumWidgetView(discoverGroup: discoverGroup)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
