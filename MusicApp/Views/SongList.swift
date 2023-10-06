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
    @State var songViewModel = SongViewModel()
    @State var musicStore = MusicPlayerStore()
    @StateObject private var debouncer = Debouncer()
    @State var searchText = ""
    @State var searchTextPublisher = ""
    @State var showMusicPlayer = false
    @State var currentId: String = ""

    init() {
        songViewModel.fetchSongs(query: "mary on cross")
    }

    var body: some View {
        List(songViewModel.songList, id: \.id) { song in
            let imageUrl = song.album.images[0].url

            Button {
                showMusicPlayer.toggle()
                currentId = song.id
                songViewModel.fetchRelatedSongsById(id: currentId)
                musicStore.setCurrentSong(song: song)

            } label: {
                SongItemView(song: song, imageUrl: imageUrl)
            }
        }
        .searchable(text: $debouncer.searchText)
        .onReceive(debouncer.publisher) { debouncedSearchText in

            songViewModel.fetchSongs(query: debouncedSearchText)
        }.sheet(isPresented: $showMusicPlayer, content: {
            NavigationStack {
                MusicPlayerView().environment(musicStore).environment(songViewModel)
            }

        })
    }
}

#Preview {
    SongList()
}
