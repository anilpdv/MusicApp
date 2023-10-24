//
//  SongListView.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import SwiftUI

struct SongListView: View {
    var songViewModel = SongViewModel()
    var musicStore = MusicPlayerStore()
    @State var showMusicPlayer = false
    @StateObject var audioPlayer = AudioPlayer.shared
    let playlist: Playlist

    var body: some View {
        List(songViewModel.playlistSongs, id: \.track.id) { song in
            Button {
                musicStore.setCurrentSongForPlaylist(song: song)
                songViewModel.setRelatedSongs(songs: songViewModel.playlistSongs)
                showMusicPlayer.toggle()
            } label: {
                HStack {
                    ImageView(url: song.track.album.images[0].url, frameWidth: 50, frameHeight: 50)
                    VStack(alignment: .leading) {
                        Text(song.track.name)
                            .font(.headline)
                            .bold()
                        Text(song.track.artists[0].name)
                            .font(.subheadline)
                    }.foregroundStyle(.white)
                }
            }
        }
        .fullScreenCover(isPresented: $showMusicPlayer, content: {
            NavigationStack {
                MusicPlayerView().environment(musicStore).environment(songViewModel)
            }

        })
        .navigationTitle(playlist.name)
        .onAppear {
//            songViewModel.fetchSongs(query: play.name)
            Task {
                songViewModel.fetchPlaylistSongs(id: playlist.id)
            }
        }
    }
}

struct SongDetailView: View {
    let song: PlaylistItem

    var body: some View {
        HStack {
            ImageView(url: song.track.album.images[0].url, frameWidth: 50, frameHeight: 50)
            VStack(alignment: .leading) {
                Text(song.track.name)
                    .font(.headline)
                    .bold()
                Text(song.track.artists[0].name)
                    .font(.subheadline)
            }.foregroundStyle(.white)
        }
        .navigationTitle(song.track.name)
    }
}

// #Preview {
//    SongListView(playlist: (){})
// }
