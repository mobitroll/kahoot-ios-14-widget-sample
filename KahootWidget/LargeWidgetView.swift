//
//  LargeWidgetView.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 22/09/2020.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {

    let discoverGroup: DiscoverGroup

    var body: some View {
        VStack {
            HeaderView(title: discoverGroup.groupTitle)
        }
        .padding()
        .background(Color("MediumAndLargeWidgetBackground"))
    }
}

struct LargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {

        let discoverGroup = DiscoverGroup(cardTitle: "World architecture",
                                          coverImage: Image("DummyImage"),
                                          creatorAvatarImage: nil,
                                          creatorUsername: "Jay N.",
                                          groupTitle: "Top picks",
                                          numberOfQuestions: 6)

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            LargeWidgetView(discoverGroup: discoverGroup)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, colorScheme)
        }
    }
}
