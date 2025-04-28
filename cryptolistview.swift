//
//  CryptoListView.swift
//  CryptoWatcher
//
//  Created by Damir Kamalov on 27.04.2025.
//
import SwiftUI

struct CryptoListView: View {
    @StateObject var service = CryptoService()
    @State private var searchText = ""

    let currencies = ["usd", "eur", "jpy", "gbp", "aud", "twd", "rub", "krw"]

    var filteredCryptos: [Crypto] {
        if searchText.isEmpty {
            return service.cryptos
        } else {
            return service.cryptos.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Currency", selection: $service.selectedCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency.uppercased()).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: service.selectedCurrency) { _ in
                    Task {
                        await service.fetchCryptos()
                    }
                }
                
                List(filteredCryptos) { crypto in
                    HStack {
                        AsyncImage(url: URL(string: crypto.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(crypto.name)
                                .font(.headline)
                            Text(crypto.symbol.uppercased())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(formattedPrice(for: crypto.currentPrice))
                                .font(.headline)
                            Text(String(format: "%.2f%%", crypto.priceChangePercentage24h))
                                .font(.subheadline)
                                .foregroundColor(crypto.priceChangePercentage24h >= 0 ? .green : .red)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Crypto Tracker")
            .searchable(text: $searchText, prompt: "Search...")
            .task {
                await service.fetchCryptos()
            }
        }
    }
    
    private func formattedPrice(for price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = service.selectedCurrency.uppercased()
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
