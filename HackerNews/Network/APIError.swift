//
//  APIError.swift
//  HackerNews
//
//  Created by Gaspare Monte on 21/03/24.
//

import Foundation

enum APIError: String, Error {
    case invalidURL = "Invalid url"
    case unableToComplete = "Unable to complete the request."
    case invalidResponse = "Invalid response from the server."
}
