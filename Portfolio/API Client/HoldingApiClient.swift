//
//  HoldingAPIClient.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Combine
import Foundation

protocol HoldingApiClientProtocol {
    func fetchHoldings() -> AnyPublisher<HoldingResponse, Error>
}

struct HoldingApiClient: HoldingApiClientProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchHoldings() -> AnyPublisher<HoldingResponse, Error> {
        networkService
            .perform(endPoint: HoldingEndPointProvider.fetchHoldings, parsingKey: "data")
    }
}
