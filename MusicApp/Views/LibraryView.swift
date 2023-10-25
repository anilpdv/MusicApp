//
//  LibraryView.swift
//  MusicApp
//
//  Created by anil pdv on 24/10/23.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query() private var songs: [SongStore]
    @State var songViewModel = SongViewModel()
    @State var musicStore = MusicPlayerStore()
    @State var showMusicPlayer = false
    var body: some View {
        VStack {
            List {
                ForEach(songs, id: \.id) { song in

                    HStack(alignment: .center, spacing: 10) {
                        ImageView(url: song.imageUrl, frameWidth: 50, frameHeight: 50)
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                .font(.headline)
                                .bold()

                        }.foregroundStyle(.white)
                        Spacer()
                        Button(action: {
                            showMusicPlayer.toggle()

                            songViewModel.setRelatedSongsForLibrary(songs: songs)
                            musicStore.setCurrentSongForLibrary(song: song)
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding()
                                .foregroundStyle(.white)
                        }
                    }
                }.onDelete(perform: { indexSet in
                    for index in indexSet {
                        let song = songs[index]
                        let fileManager = FileManager.default
                        do {
                            try fileManager.removeItem(at: URL(string: song.url)!)
                            try fileManager.removeItem(at: URL(string: song.imageUrl)!)
                            context.delete(song)
                        } catch {
                            print("Error deleting song: \(error)")
                        }
                    }
                })
            }
            .fullScreenCover(isPresented: $showMusicPlayer, content: {
                NavigationStack {
                    MusicPlayerView().environment(musicStore).environment(songViewModel)
                }

            })
        }
    }
}

struct LibraryItemView: View {
    var song: SongStore
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ImageView(url: song.imageUrl, frameWidth: 50, frameHeight: 50)
            VStack(alignment: .leading) {
                Text(song.title)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .font(.headline)
                    .bold()

            }.foregroundStyle(.white)
        }
    }
}

#Preview {
    LibraryView().modelContainer(for: SongStore.self, inMemory: true)
}
