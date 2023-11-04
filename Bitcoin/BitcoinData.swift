//
//  BitcoinData.swift
//  Bitcoin
//
//  Created by Kovács Márk on 21/10/2023.
//

import Foundation

struct BitcoinData: Decodable {
    let bpi: BPI
}

struct BPI: Decodable {
    let EUR: EURRate
}

struct EURRate: Decodable {
    let rate: String
    let code: String
}
