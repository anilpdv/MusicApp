//
//  CategoryPlaylistsView.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import SwiftUI

struct CategoryPlaylistsView: View {
    var songViewModel = SongViewModel()
    let categoryId: String
    let name: String

    init(categoryId: String, name: String) {
        self.categoryId = categoryId
        self.name = name
        songViewModel.fetchCategoriesPlaylists(id: categoryId)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(songViewModel.categoriesPlaylists, id: \.id) { playlist in
                        NavigationLink(destination: SongListView(playlist: playlist)) {
                            CategoriesPlaylistListView(playlist: playlist)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoriesPlaylistListView: View {
    let playlist: Playlist

    var body: some View {
        let imageUrl = playlist.images[0].url
        VStack {
            ImageView(url: imageUrl, frameWidth: 150, frameHeight: 150)
        }
    }
}

#Preview {
    CategoryPlaylistsView(categoryId: "toplists", name: "Top Lists").environment(SongViewModel())
}
