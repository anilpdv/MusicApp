//
//  SongList.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Combine
import SwiftUI

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct SongList: View {
    var songViewModel = SongViewModel()
    @StateObject private var debouncer = Debouncer()
    @State var searchText = ""
    @State var searchTextPublisher = ""

    init() {
        songViewModel.fetchSongs(query: "mary on cross")
    }

    var body: some View {
        List(songViewModel.songList, id: \.id) { song in
            let imageUrl = song.thumbnails[safe: 1]?.url ?? song.thumbnails[safe: 0]?.url

            NavigationLink {
                MusicPlayerView(songId: song.id, url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/\(song.id)/\(song.title).mp3", songLength: song.duration ?? 200, imageUrl: imageUrl ?? "", songTitle: song.title)
            } label: {
                SongItemView(song: song, imageUrl: imageUrl ?? "")
            }
        }
        .searchable(text: $debouncer.searchText)
        .onReceive(debouncer.publisher) { debouncedSearchText in

            songViewModel.fetchSongs(query: debouncedSearchText)
        }
    }
}

#Preview {
    SongList()
}
