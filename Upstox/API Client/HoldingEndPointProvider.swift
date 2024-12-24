//
//  HoldingEndPointProvider.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Foundation

enum HoldingEndPointProvider: EndPointProvider {
    case fetchHoldings
}

extension HoldingEndPointProvider {
    var path: String {
        "35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io"
    }
}
