//
//  HoldingAPIClient.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Combine
import Foundation

protocol HoldingApiClientProtocol {
    func fetchHoldings() -> AnyPublisher<[UserHolding], Error>
}

struct HoldingApiClient: HoldingApiClientProtocol {
    let networkService = NetworkService()

    func fetchHoldings() -> AnyPublisher<[UserHolding], Error> {
        networkService
                .perform(endPoint: HoldingEndPointProvider.fetchHoldings,
                         parsingKey: "userHolding")
    }
}
