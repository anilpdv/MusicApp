//
//  SongViewModel.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Foundation
import Observation

let BASE_URL = "https://agile-journey-25441-7adaeb370f64.herokuapp.com"

@Observable class SongViewModel {
    var songList = [Track]()
    var relatedSongs = [Track]()
    var categories = [Category]()
    var playlists = [Playlist]()
    var albums = [Album]()
    var categoriesPlaylists = [Playlist]()
    var playlistSongs = [PlaylistItem]()
    var playlistRelatedSongs = [PlaylistItem]()
    var playlistRelatedSongsForLibrary = [SongStore]()
    var currentSong = CurrentSong(id: "", title: "", imageUrl: "", url: "", duration: 0)

    func fetchSongs(query: String) {
        guard let url = URL(string: "\(BASE_URL)/search/tracks/\(query)") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (songList: Song) in
            DispatchQueue.main.async {
                self.songList = songList.tracks.items
            }
        })
    }

    func fetchRelatedSongsById(id: String) {
        guard let url = URL(string: "\(BASE_URL)/recommendation/tracks/\(id)/0.4/60") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (relatedSongs: RelatedSongs) in
            DispatchQueue.main.async {
                self.relatedSongs = relatedSongs.tracks
            }
        })
    }

    func fetchCategories() {
        guard let url = URL(string: "\(BASE_URL)/featured/categories") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (categoriesResponse: CategoriesResponse) in
            DispatchQueue.main.async {
                self.categories = categoriesResponse.categories.items
            }
        })
    }

    // fetch categories by id \(BASE_URL)/featured/categories/{id}
    func fetchCategoriesPlaylists(id: String) {
        guard let url = URL(string: "\(BASE_URL)/featured/categories/\(id)") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (playlistResponse: PlaylistResponse) in
            DispatchQueue.main.async {
                self.categoriesPlaylists = playlistResponse.playlists.items
            }
        })
    }

    // fetch playlist songs by id \(BASE_URL)/featured/playlists/{id}
    func fetchPlaylistSongs(id: String) {
        guard let url = URL(string: "\(BASE_URL)/featured/playlists/\(id)") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (playlistResponse: PlaylistItemsResponse) in
            DispatchQueue.main.async {
                self.playlistSongs = playlistResponse.items
            }
        })
    }

    func fetchPlaylists() {
        guard let url = URL(string: "\(BASE_URL)/featured") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (playlistResponse: PlaylistResponse) in
            DispatchQueue.main.async {
                self.playlists = playlistResponse.playlists.items
            }
        })
    }

    func fetchAlbums() {
        guard let url = URL(string: "\(BASE_URL)/featured/new") else {
            print("Invalid URL")
            return
        }

        fetchData(url: url, completion: { (albumsResponse: AlbumsResponse) in
            DispatchQueue.main.async {
                self.albums = albumsResponse.albums.items
            }
        })
    }

    func setCurrentSong(song: CurrentSong) {
        currentSong = song
    }

    func setRelatedSongs(songs: [PlaylistItem]) {
        playlistRelatedSongs = Array(songs.dropFirst())
    }

    func setRelatedSongsForLibrary(songs: [SongStore]) {
        playlistRelatedSongsForLibrary = Array(songs.dropFirst())
    }

    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                print("HTTP response error: \(httpResponse.statusCode) fetchData")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}

@Observable class MusicPlayerStore {
    var currentSong = CurrentSong(id: "", title: "", imageUrl: "", url: "", duration: 0)
    var currentType = ""

    func setCurrentSong(song: Track) {
        let imageUrl = song.album.images[1].url

        currentSong = CurrentSong(id: song.id, title: song.name, imageUrl: imageUrl, url: "\(BASE_URL)/listen/\(song.artists[0].name) - \(song.name)", duration: song.durationMs)

        currentType = "search"
    }

    func setCurrentSongForPlaylist(song: PlaylistItem) {
        let imageUrl = song.track.album.images[1].url

        currentSong = CurrentSong(id: song.track.id, title: song.track.name, imageUrl: imageUrl, url: "\(BASE_URL)/listen/\(song.track.artists[0].name) - \(song.track.name)", duration: song.track.durationMs)
        currentType = "playlist"
    }

    func setCurrentSongForLibrary(song: SongStore) {
        currentSong = CurrentSong(id: song.id, title: song.title, imageUrl: song.imageUrl, url: song.url, duration: song.duration)
        currentType = "library"
    }
}

struct CurrentSong: Identifiable, Hashable, Decodable {
    var id: String
    var title: String
    var imageUrl: String
    var url: String
    var duration: Int
}
