//
//  FavoritesListView.swift
//  HackerNews
//
//  Created by Gaspare Monte on 20/03/24.
//

import SwiftUI

struct FavoritesListView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @StateObject var vm: ViewModel = ViewModel()

    var body: some View {
        NavigationStack(path: $vm.path) {
            Group {
                if vm.favoriteStories.isEmpty {
                    ContentUnavailableView(
                        "No favorites",
                        systemImage: "star.fill",
                        description: Text("Add favorites from the news list.")
                    )
                } else {
                    List {
                        ForEach(vm.favoriteStories) { story in
                            NavigationLink(value: story) {
                                StoryRowView(story: story)
                            }
                        }
                    }
                    .navigationDestination(for: Story.self) { story in
                        StoryDetailView(story: story)
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                if vm.isFirstLaunch {
                    await reloadData()
                }
            }
            .onChange(of: favoritesStore.ids.count) {
                Task {
                    await reloadData()
                }
            }
        }
    }

    func reloadData() async {
        vm.favoriteStories = await vm.getFavorites(ids: favoritesStore.ids)
        vm.path = NavigationPath()
    }
}

#Preview {
    NavigationStack {
        FavoritesListView()
            .environmentObject(FavoritesStore())
    }
}
