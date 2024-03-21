//
//  FavoritesStore.swift
//  HackerNews
//
//  Created by Gaspare Monte on 20/03/24.
//

import Foundation

class FavoritesStore: ObservableObject {
    @Published var ids: [Int] = []

    init() {
        do {
            try load()
        } catch {
            print("Unable to load favorites store")
        }
    }

    var dataURL: URL {
        print(URL.documentsDirectory)
        return URL.documentsDirectory
            .appendingPathComponent("favorites.plist")
    }

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

    func addToFavorites(id: Int) {
        self.ids.append(id)

        do {
            try save()
        } catch {
            print(error.localizedDescription)
        }
    }

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

    enum FileError: Error {
        case loadFailure
        case saveFailure
    }
}
