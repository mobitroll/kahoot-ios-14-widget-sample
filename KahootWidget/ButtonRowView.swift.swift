//
//  ButtonRowView.swift.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 22/09/2020.
//

import SwiftUI
import WidgetKit

struct LinkButtonView: View {
    var imageName: String
    var shadow: Bool = false
    var text: String
    var url: URL

    var body: some View {
        Link(destination: url) {
            VStack {
                Image(imageName)
                    .shadow(radius: self.shadow ? 4 : 0)

                Text(text).font(.custom("Montserrat", size: 12, relativeTo: .title))
                    .bold()
                    .foregroundColor(Color("Gray4"))
            }.unredacted()
        }
    }
}

struct ButtonRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            LinkButtonView(imageName: "Search", text: "Search", url: URL(string: "kahoot://search")!)
            Spacer()
            LinkButtonView(imageName: "EnterPIN", shadow: true, text: "Enter PIN", url: URL(string: "kahoot://enterpin")!)
            Spacer()
            LinkButtonView(imageName: "Create", text: "Create", url: URL(string: "kahoot://create")!)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

struct ButtonRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ButtonRowView()
                .background(Color("MediumAndLargeWidgetBackground"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.colorScheme, colorScheme)
                .previewDisplayName("\(colorScheme)")
        }
    }
}
