//
//  FavoritesListView.swift
//  HackerNews
//
//  Created by Gaspare Monte on 20/03/24.
//

import SwiftUI

struct FavoritesListView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore

    @State private var favoriteStories: [Story] = []
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if favoriteStories.isEmpty {
                    ContentUnavailableView(
                        "No favorites",
                        systemImage: "star.fill",
                        description: Text("Add favorites from the news list.")
                    )
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesListView()
            .environmentObject(FavoritesStore())
    }
}
