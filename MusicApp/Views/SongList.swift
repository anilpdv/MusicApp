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

    func formatViewCount(_ count: Int?) -> String {
        guard let count = count else {
            return "0"
        }

        if count < 1000 {
            return "\(count)"
        } else if count < 1000000 {
            return "\(count / 1000)K"
        } else {
            return "\(count / 1000000)M"
        }
    }

    var body: some View {
        List(songViewModel.songList, id: \.songID) { song in
            let imageUrl = song.thumbnails[safe: 1]?.url ?? song.thumbnails[safe: 0]?.url

            NavigationLink {
                MusicPlayerView(url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/\(song.id)/\(song.title).mp3", songLength: song.duration ?? 200, imageUrl: imageUrl ?? "", songTitle: song.title)
            } label: {
                HStack(alignment: .center, spacing: 20) {
                    let songLength = song.duration ?? 200
                    let totalMinutes = Int(songLength / 60)
                    let totalSeconds = Int(songLength.truncatingRemainder(dividingBy: 60))
                    let formattedSongLength = String(format: "%02d:%02d", totalMinutes, totalSeconds)
                    ImageView(url: imageUrl ?? "", frameWidth: 60, frameHeight: 60)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(100)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(song.title)")
                            .textCase(.lowercase)
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .bold()
                        HStack(alignment: .center) {
                            Text(formattedSongLength)
                                .foregroundStyle(.gray)
                            Text(".")
                                .foregroundStyle(.gray)
                            Text(formatViewCount(song.viewCount))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
        .searchable(text: $debouncer.searchText)
        .onReceive(debouncer.publisher) { debouncedSearchText in
            print(debouncedSearchText)
            songViewModel.fetchSongs(query: debouncedSearchText)
        }
    }
}

class Debouncer: ObservableObject {
    private var timer: Timer?

    @Published var searchText: String = "" {
        didSet {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.debouncedSearchText = self.searchText
            }
        }
    }

    @Published private var debouncedSearchText: String = ""

    var publisher: Published<String>.Publisher { $debouncedSearchText }
}

#Preview {
    SongList()
}
