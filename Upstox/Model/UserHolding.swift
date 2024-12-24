//
//  UserHolding.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Foundation

struct UserHolding: Decodable {
    let symbol: String?
    let quantity: Int
    let ltp, avgPrice: Double
    let close: Int

    enum CodingKeys: CodingKey {
        case symbol
        case quantity
        case ltp
        case avgPrice
        case close
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        self.ltp = try container.decodeIfPresent(Double.self, forKey: .ltp) ?? 0
        self.avgPrice = try container.decodeIfPresent(Double.self, forKey: .avgPrice) ?? 0
        self.close = try container.decodeIfPresent(Int.self, forKey: .close) ?? 0
    }
    
    var currentValue: Double {
        return ltp * Double(quantity)
    }

    var investmentValue: Double {
        return avgPrice * Double(quantity)
    }

    var profitAndLoss: Double {
        return currentValue - investmentValue
    }
}
