//
//  Mockable.swift
//  Portfolio
//
//  Created by Lucifer on 28/12/24.
//

import Foundation

protocol Mockable {
    func loadJSON<T: Decodable>(filename: String, type: T.Type, parsingKey: String?) -> T
}

extension Mockable {
    func loadJSON<T: Decodable>(filename: String, type: T.Type, parsingKey: String?) -> T {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            print("Data Fetched From Mock File")
            let data = try Data(contentsOf: path)
            let responseObject: T = try DecodingHelper.decode(from: data, for: parsingKey)
            return responseObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}
