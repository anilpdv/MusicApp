//
//  SongList.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import Combine
import SwiftUI

struct SongList: View {
    var songViewModel = SongViewModel()
    @StateObject private var debouncer = Debouncer()
    @State var searchText = ""
    @State var searchTextPublisher = ""

    init() {
        songViewModel.fetchSongs(query: "mary on cross")
    }

    var body: some View {
        List(songViewModel.songList, id: \.songID) { song in

            NavigationLink {
                MusicPlayerView(url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/\(song.id)/\(song.title).mp3", songLength: song.duration ?? 200)
            } label: {
                HStack(alignment: .center, spacing: 20) {
                    AsyncImage(url: URL(string: song.thumbnails[0].url ?? "")) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            Image(systemName: "carrot")
                        } else {
                            Shimmer().frame(width: 60, height: 60)
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(100)
                    Text("\(song.title)")
                        .textCase(.lowercase)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .bold()
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

struct Shimmer: View {
    @State private var gradientStart = UnitPoint(x: -1, y: 0.5)
    @State private var gradientEnd = UnitPoint(x: 2, y: 0.5)

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.white.opacity(0.5), Color.gray.opacity(0.3)]), startPoint: gradientStart, endPoint: gradientEnd)
            .mask(Rectangle())
            .onAppear {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    gradientStart = UnitPoint(x: 1, y: 0.5)
                    gradientEnd = UnitPoint(x: 4, y: 0.5)
                }
            }
    }
}

#Preview {
    SongList()
}
