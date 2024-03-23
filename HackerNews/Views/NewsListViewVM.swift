//
//  NewsListViewVM.swift
//  HackerNews
//
//  Created by Gaspare Monte on 20/03/24.
//

import Foundation

extension NewsListView {
    class ViewModel: ObservableObject {
        @Published var storiesIds: [Int] = []
        @Published var stories: [Story] = []

        @Published var isFinished: Bool = false
        @Published var isLoading = false

        @Published var task: Task<Void, Error>?
        /// The current endpoint used for fetching stories.
        @Published var endPoint: Endpoint = .topStories

        var topStoriesCache: [Story] = []
        var bestStoriesCache: [Story] = []
        var newStoriesCache: [Story] = []

        init() {
            task = Task {
                await getStoriesIds()
                await fetchStories()
            }
        }

        @MainActor
        func switchStoriesList(from endpoint1: Endpoint, to endpoint2: Endpoint) async {
            self.endPoint = endpoint2
            await self.getStoriesIds()

            if endpoint1 == .topStories {
                self.topStoriesCache = stories
            } else if endpoint1 == .bestStories {
                self.bestStoriesCache = stories
            } else {
                self.newStoriesCache = stories
            }

            self.stories = selectStoriesArray()

            if stories.isEmpty {
                await fetchStories()
            }
        }

        func selectStoriesArray() -> [Story] {
            switch endPoint {
            case .newStories:
                return self.newStoriesCache
            case .topStories:
                return self.topStoriesCache
            case .bestStories:
                return self.bestStoriesCache
            }
        }

        /// Fetches the IDs of stories asynchronously.
        @MainActor
        func getStoriesIds() async {
            self.storiesIds = []

            do {
                self.storiesIds = try await NetworkManager.shared.getFromJson(from: self.endPoint.url)
            } catch {
                print("Unable to retreive ids for \(self.endPoint.description)")
            }
        }

        /// Fetches stories asynchronously.
        @MainActor
        func fetchStories() async {
            if stories.count == storiesIds.count && stories.count > 10 {
                isFinished = true
            } else {
                if !isLoading {
                    isLoading = true

                    var previousStoriesCount = stories.count
                    let newStoriesCount = stories.count + 10

                    while previousStoriesCount < newStoriesCount {
                        await getStory(id: self.storiesIds[previousStoriesCount])
                        previousStoriesCount += 1
                    }

                    isLoading = false

                }
            }
        }

        /// Fetches a story asynchronously from the Hacker News API based on the provided ID.
        /// - Parameter id: The ID of the story to fetch.
        @MainActor
        func getStory(id: Int) async {
            do {
                let story: Story = try await NetworkManager.shared.getFromJson(from: "https://hacker-news.firebaseio.com/v0/item/\(id).json")
                self.stories.append(story)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
