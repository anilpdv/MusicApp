//
//  Album.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import Foundation

struct AlbumsResponse: Decodable {
    let albums: Albums
}

struct Albums: Decodable {
    let href: String
    let items: [Album]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
