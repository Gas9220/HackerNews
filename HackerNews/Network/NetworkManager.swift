//
//  NetworkManager.swift
//  HackerNews
//
//  Created by Gaspare Monte on 19/03/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func getFromJson<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData

        } catch {
            throw APIError.unableToComplete
        }
    }
}
