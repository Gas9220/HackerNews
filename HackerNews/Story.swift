//
//  Story.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import Foundation

struct Story: Decodable, Identifiable {
    let by: String
    let id: Int
    let score: Int
    let time: TimeInterval
    let title: String
    let type: String
    let url: String?

    var date: Date {
        let date = Date(timeIntervalSince1970: time)
        return date
    }
}

extension Story: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Story: Comparable {
    static func < (lhs: Story, rhs: Story) -> Bool {
        return rhs.date < lhs.date
    }
}

extension Story {
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
