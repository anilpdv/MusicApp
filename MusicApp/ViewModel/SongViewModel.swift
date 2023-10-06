//
//  SongViewModel.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Foundation
import Observation

@Observable class SongViewModel {
    var songList = [Track]()
    var relatedSongs = [Track]()

    func fetchSongs(query: String) {
        guard let url = URL(string: "https://warm-river-15003-2ccb4c8eac08.herokuapp.com/search/tracks/\(query)") else {
            print("Invalid URL")
            return
        }

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
                print("HTTP response error: \(httpResponse.statusCode) fetchSongs")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let songList = try JSONDecoder().decode(Song.self, from: data)
                DispatchQueue.main.async {
                    self.songList = songList.tracks.items
                }

            } catch {
                print(String(describing: error))
            }
        }.resume()
    }

    func fetchRelatedSongsById(id: String) {
        guard let url = URL(string: "https://warm-river-15003-2ccb4c8eac08.herokuapp.com/recommendation/tracks/\(id)/0.4/60") else {
            print("Invalid URL")
            return
        }

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
                print("HTTP response error: \(httpResponse.statusCode) fetchRelatedSongsById")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let relatedSongs = try JSONDecoder().decode(RelatedSongs.self, from: data)
                DispatchQueue.main.async {
                    self.relatedSongs = relatedSongs.tracks
                }

            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}

@Observable class MusicPlayerStore {
    var currentSong = CurrentSong(id: "", title: "", imageUrl: "", url: "", duration: 0)

    func setCurrentSong(song: Track) {
        let imageUrl = song.album.images[1].url

        currentSong = CurrentSong(id: song.id, title: song.name, imageUrl: imageUrl, url: "https://warm-river-15003-2ccb4c8eac08.herokuapp.com/listen/\(song.artists[0].name) - \(song.name)", duration: song.durationMs)
    }
}

struct CurrentSong: Identifiable, Hashable, Decodable {
    var id: String
    var title: String
    var imageUrl: String
    var url: String
    var duration: Int
}
