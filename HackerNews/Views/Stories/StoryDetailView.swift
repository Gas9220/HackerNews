//
//  StoryDetailView.swift
//  HackerNewsShadow
//
//  Created by Gaspare Monte on 20/03/24.
//

import SwiftUI

struct StoryDetailView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore

    let story: Story

    var body: some View {
        VStack {
            Text(story.title)
                .font(.title2)

            HStack {
                Text(story.date.formatted(date: .complete, time: .omitted))
                Text(story.type)
                Text(story.score, format: .number)
            }

            if let url = story.url {
                Link("Read the full article", destination: URL(string: url)!)
            }

            Spacer()
        }
        .navigationTitle(story.by)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let isFavorite = favoritesStore.ids.contains(story.id)

                Button {
                    if isFavorite {
                        self.favoritesStore.removeFromFavorites(id: story.id)
                    } else {
                        self.favoritesStore.addToFavorites(id: story.id)
                    }
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StoryDetailView(story: Story.example)
            .environmentObject(FavoritesStore())
    }
}
