//
//  HTTPTask.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import Foundation

typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
                           urlParameters: Parameters?,
                           additionalHeaders: HTTPHeaders?)
}
