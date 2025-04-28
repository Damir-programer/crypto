//
//  crypto.swift
//  cryptowatcher
//
//  Created by Damir Kamalov on 27.04.2025.
//
import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24h: Double
    let marketCap: Double

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCap = "market_cap"
    }
}
