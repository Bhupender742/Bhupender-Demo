//
//  HoldingsViewModelTests.swift
//  PortfolioTests
//
//  Created by Lucifer on 28/12/24.
//

import XCTest
@testable import Portfolio

final class HoldingsViewModelTests: XCTestCase {
    private var viewModel: HoldingsViewModel!
    private var apiClient: HoldingApiClientProtocol!
    private var networkService: NetworkServiceProtocol!

    override func setUp() {
        networkService = MockService()
        apiClient = HoldingApiClient(networkService: networkService)
        viewModel = HoldingsViewModel(apiClient: apiClient)
    }
}

extension HoldingsViewModelTests {
    func testFetchHoldings() {
        viewModel.fetchHoldings()
        XCTAssertTrue(viewModel.holdings.isEmpty)
        let expectation = expectation(description: "Fetch Holdings!")
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertFalse(viewModel.holdings.isEmpty)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testFetchInvestment() {
        viewModel.fetchHoldings()
        XCTAssertNil(viewModel.investment)
        let expectation = expectation(description: "Fetch Investment!")
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(viewModel.investment)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
