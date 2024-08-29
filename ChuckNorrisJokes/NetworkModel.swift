//
//  NetworkModel.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 26.08.24.
//

import Foundation

struct codableJoke: Codable {
    let categories: [String?]
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case value
    }
}
