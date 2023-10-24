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
    @StateObject var audioPlayer = AudioPlayer.shared
    @State var searchText = ""
    @State var searchTextPublisher = ""
    @State var showMusicPlayer = false
    @State var currentId: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            List(songViewModel.songList, id: \.id) { song in
                let imageUrl = song.album.images[0].url

                Button {
                    showMusicPlayer.toggle()
                    currentId = song.id
                    songViewModel.fetchRelatedSongsById(id: currentId)
                    musicStore.setCurrentSong(song: song)

                } label: {
                    SongItemView(song: song, imageUrl: imageUrl)
                        .environment(musicStore)
                }
            }
            .searchable(text: $debouncer.searchText)
            .onReceive(debouncer.publisher) { debouncedSearchText in

                songViewModel.fetchSongs(query: debouncedSearchText)
            }.fullScreenCover(isPresented: $showMusicPlayer, content: {
                NavigationStack {
                    MusicPlayerView().environment(musicStore).environment(songViewModel)
                }

            })

            if audioPlayer.isPlaying && musicStore.currentType == "search" {
                MiniMusicPlayer().padding(0).environment(musicStore)

                    .onTapGesture {
                        showMusicPlayer.toggle()
                    }
            }
        }
    }
}

#Preview {
    SongList()
}
