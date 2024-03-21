//
//  HackerNewsApp.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import SwiftUI

@main
struct HackerNewsApp: App {
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
    }
}
