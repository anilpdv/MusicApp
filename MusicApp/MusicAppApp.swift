//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import SwiftData
import SwiftUI

@main
struct MusicAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: SongStore.self)
        }
    }
}
