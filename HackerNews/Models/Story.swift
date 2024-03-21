//
//  Story.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import Foundation

/// Represents a story fetched from Hacker News API.
struct Story: Decodable, Identifiable {
    let by: String
    let id: Int
    let score: Int
    let time: TimeInterval
    let title: String
    let type: String
    let url: String?

    /// Converts the Unix timestamp (`time`) into a `Date` object.
    var date: Date {
        let date = Date(timeIntervalSince1970: time)
        return date
    }
}

extension Story: Hashable {
    /// Provides a hash value for the `Story` struct based on its `id` required to use `NavigationLink(value:label:)` init.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Story: Comparable {
    /// Compares two `Story` instances based on their `date` required to sort an array of `[Story]`using `.sort()`.
    static func < (lhs: Story, rhs: Story) -> Bool {
        return rhs.date < lhs.date
    }
}

extension Story {
    /// An example instance of `Story` for preview purposes.
    static let example: Story = Story(
        by: "dhouston",
        id: 8863,
        score: 104,
        time: 1175714200,
        title: "My YC app: Dropbox - Throw away your USB drive",
        type: "story",
        url: "http://www.getdropbox.com/u/2/screencast.html"
    )
}
