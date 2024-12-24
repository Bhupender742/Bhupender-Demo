//
//  NetworkError.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Foundation

enum NetworkError: Error {
    case missingURL
    case noResponse
    case noData
    case unknownError
}
