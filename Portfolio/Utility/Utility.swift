//
//  Utility.swift
//  Upstox
//
//  Created by Lucifer on 25/12/24.
//

import Foundation

final class Utility {
    static var currencyFormat: String {
        return Constants.CustomStringFormats.rupeeSign + Constants.CustomStringFormats.formattedValueString
    }

    static func getPriceType(for price: Double) -> PriceType {
        if price == 0 { return .neutral }
        return price > 0 ? .profit: .loss
    }
}
