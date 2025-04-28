//
//  cryptoservice.swift
//  cryptowatcher
//
//  Created by Damir Kamalov on 27.04.2025.
//
import Foundation

class CryptoService: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var selectedCurrency: String = "usd"
    
    func fetchCryptos() async {
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(selectedCurrency)&order=market_cap_desc&per_page=20&page=1&sparkline=false"
        ) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Crypto].self, from: data)
            DispatchQueue.main.async {
                self.cryptos = decoded
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
