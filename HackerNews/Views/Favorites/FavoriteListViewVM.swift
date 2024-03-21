//
//  FavoriteListViewVM.swift
//  HackerNews
//
//  Created by Gaspare Monte on 21/03/24.
//

import Foundation
import SwiftUI

extension FavoritesListView {
    class ViewModel: ObservableObject {
        @Published var favoriteStories: [Story] = []
        @Published var isFirstLaunch: Bool = true
        @Published var path = NavigationPath()

        func getFavorites(ids: [Int]) async -> [Story] {
            var stories = [Story]()

            for storyId in ids {
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
}
