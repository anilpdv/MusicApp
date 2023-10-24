//
//  SongItemView.swift
//  MusicApp
//
//  Created by anil pdv on 05/10/23.
//

import SwiftUI

struct SongItemView: View {
    let song: Track
    let imageUrl: String
    @Environment(MusicPlayerStore.self) private var musicStore
    @State private var isPlayingAnimation = false
    init(song: Track, imageUrl: String) {
        self.song = song
        self.imageUrl = imageUrl
    }

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            let songLength = song.durationMs

            let totalSeconds = Int(songLength / 1000)
            let totalMinutes = totalSeconds / 60
            let remainingSeconds = totalSeconds % 60
            let formattedSongLength = String(format: "%02d:%02d", totalMinutes, remainingSeconds)
            ImageView(url: imageUrl, frameWidth: 60, frameHeight: 60)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(100)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(song.name)")
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .bold()
                HStack(alignment: .center) {
                    Text(formattedSongLength)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            if musicStore.currentSong.id == song.id {
                Image(systemName: "waveform")
                    .font(.system(size: 25))
                    .padding()
                    .scaleEffect(isPlayingAnimation ? 1.05 : 1.0)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            isPlayingAnimation = true
                        }
                    }
                    .onDisappear {
                        withAnimation {
                            isPlayingAnimation = false
                        }
                    }
            }
        }
    }
}
