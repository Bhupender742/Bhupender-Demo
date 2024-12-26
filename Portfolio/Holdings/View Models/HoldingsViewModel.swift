//
//  HoldingsViewModel.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Combine
import CoreData
import Foundation

enum ViewState {
    case loading
    case loaded
}

protocol HoldingsDelegate: AnyObject {
    func reloadTableView()
}

final class HoldingsViewModel {
    private let apiClient: HoldingApiClientProtocol
    private var cancellables = Set<AnyCancellable>()
    private(set) var holdings: [UserHolding] = []
    var viewState: ViewState = .loaded
    weak var delegate: HoldingsDelegate?
    
    init(apiClient: HoldingApiClientProtocol = HoldingApiClient()) {
        self.apiClient = apiClient
    }
}

// MARK: - API
extension HoldingsViewModel {
    func fetchHoldings() {
        viewState = .loading
        apiClient
            .fetchHoldings()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                if case .failure(_) = result {
                    self.loadSavedHoldings()
                }
                self.viewState = .loaded
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.holdings = response.userHolding ?? []
                self.saveHoldings()
                self.delegate?.reloadTableView()
            })
            .store(in: &cancellables)
    }

    var investment: Investment? {
        guard !holdings.isEmpty else { return nil }
        var totalCurrentValue: Double = 0
        var totalInvestment: Double = 0
        var todaysProfitAndLoss: Double = 0
        
        holdings.forEach { holding in
            totalCurrentValue += holding.currentValue
            totalInvestment += holding.investmentValue
            todaysProfitAndLoss += (holding.closePrice - holding.ltp ) * Double(holding.quantity)
        }

        let totalProfitAndLoss: Double = totalCurrentValue - totalInvestment
        return Investment(totalCurrentValue: totalCurrentValue,
                          totalInvestment: totalInvestment,
                          totalProfitAndLoss: totalProfitAndLoss,
                          todaysProfitAndLoss: todaysProfitAndLoss)
    }
    
}

// MARK: - Private
private extension HoldingsViewModel {
    func saveHoldings() {
        // Delete All Existing Entries
        CoreDataHelper.shared.deleteData(entityName: "Holding")

        holdings.forEach {
            let paths: [String: Any] = [
                "symbol": $0.symbol,
                "quantity": Int32($0.quantity),
                "ltp": $0.ltp,
                "averagePrice": $0.averagePrice,
                "closePrice": $0.closePrice
            ]
            CoreDataHelper.shared.saveData(entityName: "Holding", paths: paths)
        }
    }

    func loadSavedHoldings() {
        let userHoldings: [Holding] = CoreDataHelper.shared.fetchData()
        
        holdings.removeAll()
        userHoldings.forEach {
            let holding = UserHolding(symbol: $0.symbol ?? "",
                                      quantity: Int($0.quantity),
                                      ltp: $0.ltp,
                                      averagePrice: $0.averagePrice,
                                      closePrice: $0.closePrice)
            holdings.append(holding)
        }

        delegate?.reloadTableView()
    }
}
