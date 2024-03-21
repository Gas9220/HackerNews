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
    @State private var isFirstLaunch: Bool = true
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
                } else {
                    List {
                        ForEach(favoriteStories) { story in
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
                if isFirstLaunch {
                    self.favoriteStories = await getFavorites()
                    self.isFirstLaunch.toggle()

                }
            }
            .onChange(of: favoritesStore.ids.count) {
                Task {
                    self.favoriteStories = await getFavorites()
                    self.path = NavigationPath()
                }
            }
        }
    }

    func getFavorites() async -> [Story] {
        let storiesIds = favoritesStore.ids

        var stories = [Story]()

        for storyId in storiesIds {
            do {
                let story: Story = try await NetworkManager.shared.getFromJson(from: "https://hacker-news.firebaseio.com/v0/item/\(storyId).json")
                stories.append(story)
            } catch {
                print(error.localizedDescription)
            }
        }

        return stories
    }

}

#Preview {
    NavigationStack {
        FavoritesListView()
            .environmentObject(FavoritesStore())
    }
}
