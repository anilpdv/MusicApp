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

    init(song: Track, imageUrl: String) {
        self.song = song
        self.imageUrl = imageUrl
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
                    Text("\(song.popularity)")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
