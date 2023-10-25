//
//  SongStore.swift
//  MusicApp
//
//  Created by anil pdv on 24/10/23.
//

import Foundation
import SwiftData

@Model
class SongStore {
    var id: String
    var title: String
    var imageUrl: String
    var url: String
    var duration: Int
    
    init(id: String, title: String, imageUrl: String, url: String, duration: Int) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.url = url
        self.duration = duration
    }
}
