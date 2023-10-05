//
//  ImageView.swift
//  MusicApp
//
//  Created by anil pdv on 05/10/23.
//

import SwiftUI

struct ImageView: View {
    let url: String
    let frameWidth: CGFloat
    let frameHeight: CGFloat
    init(url: String, frameWidth: CGFloat, frameHeight: CGFloat) {
        self.url = url
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
    }

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image.resizable().frame(width: frameWidth, height: frameHeight)
            } else if phase.error != nil {
                Image(systemName: "carrot")
            } else {
                Shimmer().frame(width: frameWidth, height: frameHeight)
            }
        }
    }
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
    ImageView(url: "https://i.ytimg.com/vi/KOrXKiSy8ZY/hqdefault.jpg?sqp=-oaymwE9CNACELwBSFryq4qpAy8IARUAAAAAGAElAADIQj0AgKJDeAHwAQH4Af4JgALQBYoCDAgAEAEYZSBLKFUwDw==&rs=AOn4CLDWyiNMrqa4UfmFSo5x3oUfzheHGQ", frameWidth: 300, frameHeight: 400)
}
