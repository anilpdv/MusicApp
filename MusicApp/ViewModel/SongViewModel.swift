//
//  SongViewModel.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Foundation
import Observation

@Observable class SongViewModel {
    var songList = [SongElement]()

    func fetchSongs(query: String) {
        guard let url = URL(string: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/search/\(query)") else {
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
                print("HTTP response error: \(httpResponse.statusCode)")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let songList = try JSONDecoder().decode([SongElement].self, from: data)
                DispatchQueue.main.async {
                    self.songList = songList
                }

            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}
