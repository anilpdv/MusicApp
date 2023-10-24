//
//  PlaylistItems.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import Foundation

struct PlaylistItemsResponse: Decodable {
    let href: String
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
 

    let track: Track
}
