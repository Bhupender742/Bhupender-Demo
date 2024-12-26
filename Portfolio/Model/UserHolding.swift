//
//  UserHolding.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Foundation

enum PriceType {
    case profit
    case loss
    case neutral
}

struct HoldingResponse: Codable {
    let userHolding: [UserHolding]?
}

struct UserHolding: Codable {
    let symbol: String
    let quantity: Int
    let ltp, averagePrice: Double
    let closePrice: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case quantity
        case ltp
        case averagePrice = "avgPrice"
        case closePrice = "close"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        self.ltp = try container.decodeIfPresent(Double.self, forKey: .ltp) ?? 0
        self.averagePrice = try container.decodeIfPresent(Double.self, forKey: .averagePrice) ?? 0
        self.closePrice = try container.decodeIfPresent(Double.self, forKey: .closePrice) ?? 0
    }

    init(symbol: String, quantity: Int, ltp: Double,
         averagePrice: Double, closePrice: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.averagePrice = averagePrice
        self.closePrice = closePrice
    }
    
    var currentValue: Double {
        return ltp * Double(quantity)
    }

    var investmentValue: Double {
        return averagePrice * Double(quantity)
    }

    var profitOrLoss: Double {
        return currentValue - investmentValue
    }

    var priceType: PriceType {
        let value = currentValue - investmentValue
        
        if value == 0 {
            return .neutral
        }
        
        return value > 0 ? .profit: .loss
    }
}
