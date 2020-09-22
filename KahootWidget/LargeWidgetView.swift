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

            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { geometryProxy in
                    discoverGroup.coverImage
                        .resizable()
                        .scaledToFill()

                        .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                        .clipped()
                        .numberOfQuestions(discoverGroup.numberOfQuestions)
                }

                VStack(alignment: .leading) {
                    Text(discoverGroup.cardTitle)
                        .font(.custom("Montserrat", size: 14, relativeTo: .title))
                        .bold()
                        .lineLimit(2)
                        .foregroundColor(Color("Gray5"))
                    HStack {
                        Group {
                            if let creatorAvatarImage = discoverGroup.creatorAvatarImage {
                                creatorAvatarImage
                                    .resizable()
                            } else {
                                Image("CreatorAvatarMissing")
                                    .unredacted()
                            }
                        }
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        Text(discoverGroup.creatorUsername)
                            .font(.custom("Montserrat", size: 14, relativeTo: .title))
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(Color("Gray4"))
                    }
                }
                .padding(8)


            }
            .background(Color("CardBackground"))
            .cornerRadius(4)

            ButtonRowView()

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
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.colorScheme, colorScheme)
        }
    }
}
