//
//  View+Extensions.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 22/09/2020.
//

import Foundation
import SwiftUI

extension View {
    func numberOfQuestions(_ numberOfQuestions: Int) -> some View {
        self
            .overlay(
                Text("\(numberOfQuestions) Qs")
                    .font(.custom("Montserrat", size: 12, relativeTo: .title))
                    .bold()
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color("NumberOfQsBackground"))
                    .cornerRadius(4)
                    .padding(8),
                alignment: .bottomTrailing
            )
    }
}
