//
//  cryptowatcherApp.swift
//  cryptowatcher
//
//  Created by Damir Kamalov on 27.04.2025.
//
import SwiftUI

@main
struct CryptoWatcherApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CryptoListView()
                    .tabItem {
                        Label("Market", systemImage: "bitcoinsign.circle")
                    }
                
                PortfolioView()
                    .tabItem {
                        Label("Portfolio", systemImage: "chart.pie.fill")
                    }
            }
        }
    }
}
