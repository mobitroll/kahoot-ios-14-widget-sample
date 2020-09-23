//
//  URLSession+fetchImage.swift
//  KahootWidgetExtension
//
//  Created by Andreas Schjønhaug on 22/09/2020.
//

import Combine
import Foundation
import UIKit

extension URLSession {
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in
                UIImage(data: data)!
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
