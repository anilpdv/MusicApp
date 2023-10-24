//
//  HomeView.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import SwiftUI

struct CategoryView: View {
    let category: Category

    var body: some View {
        let imageUrl = category.icons[0].url
        VStack {
            NavigationLink {
                CategoryPlaylistsView(categoryId: category.id, name: category.name)

            } label: {
                VStack {
                    ImageView(url: imageUrl, frameWidth: 150, frameHeight: 150)
                    Text("\(category.name)")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.white)
                }
               
            }

            
        }
    }
}

struct PlaylistView: View {
    let playlist: Playlist

    var body: some View {
        let imageUrl = playlist.images[0].url
        VStack {
            ImageView(url: imageUrl, frameWidth: 150, frameHeight: 150)
            Text("\(playlist.name)")
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
        }
    }
}

struct HomeView: View {
    @State var songViewModel = SongViewModel()

    init() {
        songViewModel.fetchCategories()
        songViewModel.fetchPlaylists()
        songViewModel.fetchAlbums()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        Text(" Categories")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(songViewModel.categories, id: \.id) { category in
                                    CategoryView(category: category)
                                }
                            }
                        }
                    }.padding()

                    VStack {
                        Text(" Playlists")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(songViewModel.playlists, id: \.id) { playlist in
                                    PlaylistView(playlist: playlist)
                                }
                            }
                        }
                    }.padding()

                    VStack {
                        Text("New Releases")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(songViewModel.albums, id: \.id) { album in
                                    let imageUrl = album.images[0].url
                                    VStack {
                                        ImageView(url: imageUrl, frameWidth: 150, frameHeight: 150)
                                        Text("\(album.name)")
                                            .font(.headline)
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }.padding()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
