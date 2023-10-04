//
//  Song.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Foundation

// MARK: - SongElement

struct SongElement: Decodable, Hashable, Identifiable {
    let id: String

    let title: String
    let thumbnails: [Thumbnail]
    let uploadDate: String?
    let description: String
    let duration: Double?
    // Add an `id` property to the struct
    var songID: String {
        return id
    }

    // Implement the `hash(into:)` method
    func hash(into hasher: inout Hasher) {
        hasher.combine(songID)
    }

    // Implement the `==` operator
    static func == (lhs: SongElement, rhs: SongElement) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Channel

struct Channel: Decodable {
    let id, name: String
    let thumbnails: [Thumbnail]
}

struct Thumbnail: Decodable {
    let url: String?
    let width, height: Int
}

typealias Song = [SongElement]
