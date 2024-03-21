//
//  FavoritesStore.swift
//  HackerNews
//
//  Created by Gaspare Monte on 20/03/24.
//

import Foundation

/// A class responsible for managing save/load favorite story IDs.
class FavoritesStore: ObservableObject {
    @Published var ids: [Int] = []

    init() {
        do {
            try load()
        } catch {
            print("Unable to load favorites store")
        }
    }

    /// Returns the path to favorites.plist inside document directory. If the file is note present it will be created.
    var dataURL: URL {
        print(URL.documentsDirectory)
        return URL.documentsDirectory
            .appendingPathComponent("favorites.plist")
    }

    /// Saves the current list of favorite IDs to the data file.
    /// - Throws: A `FileError` if the operation encounters an error.
    func save() throws {
        let plistData = self.ids

        do {
            let data = try PropertyListSerialization.data(
                fromPropertyList: plistData,
                format: .binary,
                options: .zero)
            try data.write(to: dataURL, options: .atomic)
        } catch {
            throw FileError.saveFailure
        }
    }

    /// Loads the list of favorite IDs from the data file.
    /// - Throws: A `FileError` if the operation encounters an error.
    func load() throws {
        guard let data = try? Data(contentsOf: dataURL) else {
            return
        }

        do {
            let plistData = try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil)
            let convertedPlistData = plistData as? [Int] ?? []
            self.ids = convertedPlistData
        } catch {
            throw FileError.loadFailure
        }
    }

    /// Adds the specified ID to the list of favorite IDs and saves the changes.
    /// - Parameter id: The ID of the story to add to favorites.
    func addToFavorites(id: Int) {
        self.ids.append(id)

        do {
            try save()
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Removes the specified ID from the list of favorite IDs and saves the changes.
    /// - Parameter id: The ID of the story to remove from favorites.
    func removeFromFavorites(id: Int) {
        if let itemToRemove = ids.firstIndex(of: id) {
            self.ids.remove(at: itemToRemove)

            do {
                try save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /// An enumeration representing errors that can occur during save/load operations.
    enum FileError: Error {
        case loadFailure
        case saveFailure
    }
}
