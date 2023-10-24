//
//  MiniMusicPlayer.swift
//  MusicApp
//
//  Created by anil pdv on 07/10/23.
//

import SwiftUI

struct MiniMusicPlayer: View {
    @Environment(MusicPlayerStore.self) private var musicStore
    @StateObject var audioPlayer = AudioPlayer.shared

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ImageView(url: musicStore.currentSong.imageUrl,
                      frameWidth: 50, frameHeight: 50)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(musicStore.currentSong.title)
                    .font(.headline)
                    .lineLimit(1)
            }

            Spacer()

            Button(action: {
                audioPlayer.togglePlayback()
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)

                    .foregroundStyle(.white)
            }
        }
        .padding()
        .background(Color(white: 0.2))
        .cornerRadius(10)
    }
}

#Preview {
    MiniMusicPlayer().environment(MusicPlayerStore())
}
