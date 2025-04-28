//
//  portfolioview.swift
//  cryptowatcher
//
//  Created by Damir Kamalov on 27.04.2025.
//
import SwiftUI

struct PortfolioCoin: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var buyPrice: Double
}

struct PortfolioView: View {
    @State private var portfolio: [PortfolioCoin] = []
    @State private var selectedCoin = ""
    @State private var amount = ""
    @State private var buyPrice = ""

    @State private var selectedCurrency = "usd"

    let currencies = [
        ("usd", "USD"), ("eur", "EUR"), ("jpy", "JPY"),
        ("gbp", "GBP"), ("aud", "AUD"), ("twd", "TWD"),
        ("rub", "RUB"), ("krw", "KRW")
    ]

    var totalProfit: Double {
        portfolio.reduce(0) { partialResult, coin in
            if let currentPrice = CryptoServiceMock.shared.price(for: coin.name) {
                return partialResult + (currentPrice - coin.buyPrice) * coin.amount
            }
            return partialResult
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        ForEach(currencies, id: \.0) { currency in
                            Button(currency.1) {
                                selectedCurrency = currency.0
                            }
                        }
                    } label: {
                        Text(selectedCurrency.uppercased())
                            .font(.headline)
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }

                Form {
                    Section(header: Text("Add Coin")) {
                        TextField("Coin name", text: $selectedCoin)
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Buy price (\(selectedCurrency.uppercased()))", text: $buyPrice)
                            .keyboardType(.decimalPad)
                        Button("Add to Portfolio") {
                            if let amt = Double(amount), let price = Double(buyPrice) {
                                portfolio.append(PortfolioCoin(name: selectedCoin, amount: amt, buyPrice: price))
                                selectedCoin = ""
                                amount = ""
                                buyPrice = ""
                            }
                        }
                    }
                    
                    Section(header: Text("Portfolio")) {
                        ForEach(portfolio) { coin in
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .font(.headline)
                                Text("Amount: \(coin.amount, specifier: "%.2f")")
                                Text("Buy price: \(formattedPrice(for: coin.buyPrice))")
                            }
                        }
                    }
                }

                Text("Total Profit/Loss: \(formattedPrice(for: totalProfit))")
                    .font(.title3)
                    .padding()
                    .foregroundColor(totalProfit >= 0 ? .green : .red)

                Spacer()
            }
            .navigationTitle("Portfolio")
        }
    }
    
    private func formattedPrice(for value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = selectedCurrency.uppercased()
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

class CryptoServiceMock {
    static let shared = CryptoServiceMock()

    private var mockPrices: [String: Double] = [
        "Bitcoin": 60000,
        "Ethereum": 3500,
        "Binance Coin": 500,
        "Tether": 1,
        "Cardano": 2,
        "Solana": 150
    ]
    
    func price(for name: String) -> Double? {
        return mockPrices[name]
    }
}
