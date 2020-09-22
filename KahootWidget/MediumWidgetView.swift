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
        VStack {
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
            GeometryReader { geometryProxy in
                HStack {
                    Image("DummyImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometryProxy.size.width/3,
                               height: geometryProxy.size.height)
                        .clipped()
                    VStack(alignment: .leading) {
                        Text(discoverGroup.cardTitle)
                            .font(.custom("Montserrat", size: 14, relativeTo: .title))
                            .bold()
                            .foregroundColor(Color("Gray5"))
                        Spacer()
                        Text(discoverGroup.creatorUsername)
                            .font(.custom("Montserrat", size: 14, relativeTo: .title))
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(Color("Gray4"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                .background(Color("CardBackground"))
                .cornerRadius(4)
            }
        }
        .padding()
        .background(Color("MediumAndLargeWidgetBackground"))
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
