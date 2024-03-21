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

        @Published var task: Task<Void, Error>?
        /// The current endpoint used for fetching stories.
        @Published var endPoint: Endpoint = .topStories

        init() {
           task = Task {
                await fetchStories()
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
            do {
                await getStoriesIds()

                var previousStoriesCount = stories.count
                let newStoriesCount = previousStoriesCount + 10

                while previousStoriesCount < newStoriesCount {
                    await getStory(id: self.storiesIds[previousStoriesCount])
                    previousStoriesCount += 1
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
