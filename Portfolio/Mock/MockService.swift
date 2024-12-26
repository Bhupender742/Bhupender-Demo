//
//  MockService.swift
//  Portfolio
//
//  Created by Lucifer on 28/12/24.
//

import Combine
import Foundation

struct MockService: NetworkServiceProtocol, Mockable {
    func perform<T: Decodable>(endPoint: EndPointProvider,
                               parsingKey: String?) -> AnyPublisher<T, Error> {
        Just(
            loadJSON(filename: endPoint.mockFile,
                     type: T.self, parsingKey: parsingKey)
            )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func mock() -> any NetworkServiceProtocol {
        return self
    }
}
