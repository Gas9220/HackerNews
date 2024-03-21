//
//  NetworkManager.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import Foundation

/// A singleton class responsible for managing network requests.
class NetworkManager {
    /// Shared instance of the NetworkManager.
    static let shared = NetworkManager()

    /// Private initializer to prevent direct instantiation of the class.
    private init() {}

    /// Fetches and decodes JSON data from the specified URL.
        /// - Parameters:
        ///   - urlString: The URL string from which to fetch JSON data.
        /// - Returns: An instance of the specified generic type decoded from the JSON data.
        /// - Throws: An `APIError` if the operation encounters an error.
    func getFromJson<T: Decodable>(from urlString: String) async throws -> T {
        // Validate the URL.
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            // Fetch data from the URL using async/await.
            let (data, response) = try await URLSession.shared.data(from: url)

            // Validate the response status code.
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            let decoder = JSONDecoder()

            // Decode the JSON data into the specified generic type.
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData

        } catch {
            throw APIError.unableToComplete
        }
    }
}
