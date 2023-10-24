//
//  Playlist.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import Foundation

struct PlaylistResponse: Decodable {
    let playlists: Playlists
}

struct Playlists: Decodable {
    let href: String
    let items: [Playlist]
}

struct Playlist: Decodable, Identifiable {
    let collaborative: Bool
    let description: String

    let href: String
    let id: String
    let images: [PlayImageUrl]
    let name: String
    let owner: Owner
    let tracks: TracksInfo
}

struct PlayImageUrl: Decodable {
    let height: Int?
    let url: String
    let width: Int?
}

struct Owner: Decodable {
    let href: String
    let id: String
    let type: String
    let uri: String
}

struct TracksInfo: Decodable {
    let href: String
    let total: Int
}
