//
//  MusicPlayerView.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import AVKit
import SwiftUI

struct MusicPlayerView: View {
    @StateObject var audioPlayer = AudioPlayer()
    @State var sliderValue: Double = 0
    var songLength: Double
    @State var albumArt: Image = Image(systemName: "photo")
    var url: String

    init(url: String, songLength: Double) {
        self.url = url
        self.songLength = songLength
    }

    var body: some View {
        VStack {
            albumArt
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()

            Slider(value: $sliderValue, in: 0 ... songLength)
                .padding()
                .onChange(of: sliderValue) { _, newSliderValue in
                    audioPlayer.seek(to: newSliderValue)
                }

            HStack {
                Button(action: {
                    // Add your logic for previous song
                }) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                }

                Button(action: {
                    audioPlayer.togglePlayback()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .padding()
                }

                Button(action: {
                    // Add your logic for next song
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                }
            }
            .padding()

            Spacer()
        }
        .onAppear {
            audioPlayer.setupAudioPlayer(with: url)
        }
    }
}

class AudioPlayer: ObservableObject {
    private var audioPlayer: AVPlayer?
    @Published var isPlaying = false

    func setupAudioPlayer(with url: String) {
        guard let url = URL(string: url) else {
            print(url)
            print("Invalid url...\(url)")
            return
        }
        audioPlayer = AVPlayer(url: url)
        playAudio()
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
    }
}

#Preview {
    MusicPlayerView(url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/8JMMjCyyznI/mary%20on%20cross", songLength: 200)
}
