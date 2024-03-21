//
//  Endpoint.swift
//  HackerNews
//
//  Created by Gaspare Monte on 21/03/24.
//

import Foundation

enum Endpoint: CaseIterable {
    case newStories
    case topStories
    case bestStories

    var description: String {
        switch self {
        case .newStories:
            return "New stories"
        case .topStories:
            return "Top stories"
        case .bestStories:
            return "Best stories"
        }
    }

    var url: String {
        let baseURL = "https://hacker-news.firebaseio.com/v0/"

        switch self {
        case .newStories:
            return baseURL + "/newstories.json"
        case .topStories:
            return baseURL + "/topstories.json"
        case .bestStories:
            return baseURL + "/beststories.json"
        }
    }
}
