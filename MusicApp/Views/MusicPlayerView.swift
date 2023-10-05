//
//  MusicPlayerView.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import AVKit
import SwiftUI

struct MusicPlayerView: View {
    @StateObject var audioPlayer = AudioPlayer.shared
    @State var sliderValue: Double = 0
    @State var isDragging: Bool = false
    @State var albumArt: Image = Image(systemName: "photo")
    @State var showPlaylist = false
    var songViewModel = SongViewModel()

    var songId: String
    var url: String
    var songLength: Double
    var imageUrl: String
    var songTitle: String

    init(songId: String, url: String, songLength: Double, imageUrl: String, songTitle: String) {
        self.songId = songId
        self.url = url
        self.songLength = songLength
        self.imageUrl = imageUrl
        self.songTitle = songTitle
    }

    var body: some View {
        VStack {
            ImageView(url: imageUrl, frameWidth: 320, frameHeight: 320)

                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)

                .padding()

            Text(songTitle)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                .lineLimit(1)

            // Calculate current time
            let currentMinutes = Int(audioPlayer.currentTime / 60)
            let currentSeconds = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
            let formattedCurrentTime = String(format: "%02d:%02d", currentMinutes, currentSeconds)

            // Calculate total time
            let totalMinutes = Int(songLength / 60)
            let totalSeconds = Int(songLength.truncatingRemainder(dividingBy: 60))
            let formattedSongLength = String(format: "%02d:%02d", totalMinutes, totalSeconds)

            Slider(value: $sliderValue, in: 0 ... songLength, onEditingChanged: { isEditing in

                isDragging = isEditing

            })
            .accentColor(.white)
            .padding(.horizontal)
            .onChange(of: sliderValue) { _, newValue in
                if isDragging {
                    audioPlayer.seek(to: newValue)
                }
            }

            HStack {
                Text("\(formattedCurrentTime)")
                Spacer()
                Text("\(formattedSongLength)")
            }.padding(.horizontal)

            HStack {
                Button(action: {
                    showPlaylist.toggle()
                }) {
                    Image(systemName: "music.note.list")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    // Add your logic for previous song
                }) {
                    Image(systemName: "backward.end")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    audioPlayer.togglePlayback()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                        .foregroundStyle(.white)
                }

                Spacer()
                Button(action: {
                    // Add your logic for next song
                }) {
                    Image(systemName: "forward.end")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    // Add your logic for download
                }) {
                    Image(systemName: "arrow.down.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
            }

        }.sheet(isPresented: $showPlaylist, content: {
            NavigationStack {
                List(songViewModel.relatedSongs, id: \.id) { song in
                    let imageUrl = song.thumbnails[safe: 1]?.url ?? song.thumbnails[safe: 0]?.url

                    NavigationLink {
                        MusicPlayerView(songId: song.id, url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/\(song.id)/\(song.title).mp3", songLength: song.duration ?? 200, imageUrl: imageUrl ?? "", songTitle: song.title)
                    } label: {
                        SongItemView(song: song, imageUrl: imageUrl ?? "")
                    }
                }
            }
        }).onAppear {
            Task {
                songViewModel.fetchRelatedSongsById(id: songId)
            }
        }
        .padding()
        .onChange(of: audioPlayer.currentTime, { _, newValue in
            if !isDragging {
                sliderValue = newValue
            }

        })
        .onAppear {
            Task {
                audioPlayer.setupAudioPlayer(with: url)
            }
        }
    }
}

class AudioPlayer: ObservableObject {
    private var audioPlayer: AVPlayer?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    static let shared = AudioPlayer()

    func addPeriodicTimeObserver() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        audioPlayer?.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { time in
            self.currentTime = time.seconds
        }
    }

    func setupAudioPlayer(with url: String) {
        stopAudio() // Stop current song
        currentTime = 0
        audioPlayer?.seek(to: CMTime.zero)
        guard let url = URL(string: url) else {
            print(url)
            print("Invalid url...\(url)")
            return
        }
        audioPlayer = AVPlayer(url: url)
        playAudio()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay, .allowBluetoothA2DP, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        addPeriodicTimeObserver()
    }

    func playAudio() {
        audioPlayer?.play()
        isPlaying = true
    }

    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func togglePlayback() {
        isPlaying ? pauseAudio() : playAudio()
    }

    func seek(to seconds: Double) {
        audioPlayer?.seek(to: CMTime(seconds: seconds, preferredTimescale: 1000))
        currentTime = seconds
    }

    func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
}
//
// #Preview {
//    MusicPlayerView(songId: "k5mX3NkA7jM", url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/8JMMjCyyznI/mary%20on%20cross", songLength: 200, imageUrl: "https://i.ytimg.com/vi/KOrXKiSy8ZY/hqdefault.jpg?sqp=-oaymwE9CNACELwBSFryq4qpAy8IARUAAAAAGAElAADIQj0AgKJDeAHwAQH4Af4JgALQBYoCDAgAEAEYZSBLKFUwDw==&rs=AOn4CLDWyiNMrqa4UfmFSo5x3oUfzheHGQ", songTitle: "Mary on Cross")
// }
