//
//  MusicPlayerView.swift
//  MusicApp
//
//  Created by anil pdv on 04/10/23.
//

import AVKit
import MobileCoreServices
import SwiftUI

struct MusicPlayerView: View {
    @StateObject var audioPlayer = AudioPlayer.shared
    @State var sliderValue: Double = 0
    @State var isDragging: Bool = false
    @State var albumArt: Image = Image(systemName: "photo")
    @State var showPlaylist = false
    @State var currentSongIndex = 0
    @State var isLike = false
    @State var currentSong = CurrentSong(id: "", title: "", imageUrl: "", url: "", duration: 0)
    @Environment(MusicPlayerStore.self) private var musicStore
    @Environment(SongViewModel.self) private var songViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    var body: some View {
        VStack {
            ImageView(url: musicStore.currentSong.imageUrl, frameWidth: 320, frameHeight: 320)

                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)

                .padding()

            Text(musicStore.currentSong.title)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                .lineLimit(1)

            // Calculate current time
            let currentMinutes = Int(audioPlayer.currentTime / 60)
            let currentSeconds = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
            let formattedCurrentTime = String(format: "%02d:%02d", currentMinutes, currentSeconds)

            // Calculate total time
            let songLength = Double(musicStore.currentSong.duration) / 1000.0
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

                    if musicStore.currentType == "library" {
                        if currentSongIndex < 0 {
                            currentSongIndex = songViewModel.playlistRelatedSongsForLibrary.count - 1
                        }
                        let song = songViewModel.playlistRelatedSongsForLibrary[currentSongIndex]
                        musicStore.setCurrentSongForLibrary(song: song)
                    } else if musicStore.currentType == "playlist" {
                        if currentSongIndex < 0 {
                            currentSongIndex = songViewModel.playlistRelatedSongs.count - 1
                        }
                        let song = songViewModel.playlistRelatedSongs[currentSongIndex]
                        musicStore.setCurrentSongForPlaylist(song: song)
                    } else {
                        if currentSongIndex < 0 {
                            currentSongIndex = songViewModel.relatedSongs.count - 1
                        }
                        let song = songViewModel.relatedSongs[currentSongIndex]
                        musicStore.setCurrentSong(song: song)
                    }

                    currentSongIndex -= 1
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
                    if musicStore.currentType == "library" {
                        if currentSongIndex >= songViewModel.playlistRelatedSongsForLibrary.count {
                            self.currentSongIndex = 0
                        }
                        let song = songViewModel.playlistRelatedSongsForLibrary[currentSongIndex]
                        musicStore.setCurrentSongForLibrary(song: song)
                    } else if musicStore.currentType == "playlist" {
                        if currentSongIndex >= songViewModel.playlistRelatedSongs.count {
                            self.currentSongIndex = 0
                        }
                        let song = songViewModel.playlistRelatedSongs[currentSongIndex]
                        musicStore.setCurrentSongForPlaylist(song: song)
                    } else {
                        if currentSongIndex >= songViewModel.relatedSongs.count {
                            self.currentSongIndex = 0
                        }
                        let song = songViewModel.relatedSongs[currentSongIndex]
                        musicStore.setCurrentSong(song: song)
                    }

                    self.currentSongIndex += 1
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
                    withAnimation {
                        isLike.toggle()
                    }
                    let song = SongStore(id: musicStore.currentSong.id, title: musicStore.currentSong.title, imageUrl: musicStore.currentSong.imageUrl, url: musicStore.currentSong.url, duration: musicStore.currentSong.duration)

                    let songDownloadTask = URLSession.shared.downloadTask(with: URL(string: musicStore.currentSong.url)!) { location, _, error in
                        guard let location = location else {
                            print("Error downloading song: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let destinationURL = documentsDirectoryURL.appendingPathComponent("\(song.id).mp3")

                        do {
                            try FileManager.default.moveItem(at: location, to: destinationURL)
                            song.url = destinationURL.absoluteString

                            let imageDownloadTask = URLSession.shared.downloadTask(with: URL(string: musicStore.currentSong.imageUrl)!) { location, _, error in
                                guard let location = location else {
                                    print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                                    return
                                }

                                let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let destinationURL = documentsDirectoryURL.appendingPathComponent("\(song.id).jpg")

                                do {
                                    try FileManager.default.moveItem(at: location, to: destinationURL)
                                    song.imageUrl = destinationURL.absoluteString
                                    context.insert(song)
                                } catch {
                                    print("Error saving image to device: \(error.localizedDescription)")
                                }
                            }

                            imageDownloadTask.resume()
                        } catch {
                            print("Error saving song to device: \(error.localizedDescription)")
                        }
                    }

                    songDownloadTask.resume()

                }) {
                    Image(systemName: isLike ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
            }
        }

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowtriangle.down.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showPlaylist, content: {
            NavigationStack {
                if musicStore.currentType == "library" {
                    List(songViewModel.playlistRelatedSongsForLibrary, id: \.id) { song in

                        Button {
                            musicStore.setCurrentSongForLibrary(song: song)
                        } label: {
                            LibraryItemView(song: song)
                        }
                    }
                } else if musicStore.currentType == "playlist" {
                    List(songViewModel.playlistRelatedSongs, id: \.track.id) { song in

                        Button {
                            musicStore.setCurrentSongForPlaylist(song: song)
                        } label: {
                            SongDetailView(song: song)
                        }
                    }
                } else {
                    List(songViewModel.relatedSongs, id: \.id) { song in
                        let imageUrl = song.album.images[1].url

                        Button {
                            musicStore.setCurrentSong(song: song)
                        } label: {
                            SongItemView(song: song, imageUrl: imageUrl)
                        }
                    }
                }
            }
        })

        .padding()
        .onChange(of: audioPlayer.isSongEnded
                  , { _, newValue in

                      if !isDragging && newValue {
                          print("song finished")
                          currentSongIndex += 1
                          if musicStore.currentType == "library" {
                              print("setting the player for library")
                              if currentSongIndex >= songViewModel.playlistRelatedSongsForLibrary.count {
                                  currentSongIndex = 0
                              }
                              let song = songViewModel.playlistRelatedSongsForLibrary[currentSongIndex]
                              print("library current song", song)
                              musicStore.setCurrentSongForLibrary(song: song)
                          } else if musicStore.currentType == "playlist" {
                              if currentSongIndex >= songViewModel.playlistRelatedSongs.count {
                                  currentSongIndex = 0
                              }
                              let song = songViewModel.playlistRelatedSongs[currentSongIndex]
                              musicStore.setCurrentSongForPlaylist(song: song)
                          } else {
                              if currentSongIndex >= songViewModel.relatedSongs.count {
                                  currentSongIndex = 0
                              }
                              let song = songViewModel.relatedSongs[currentSongIndex]
                              musicStore.setCurrentSong(song: song)
                          }
                      }
                  })
        .onChange(of: audioPlayer.currentTime, { _, newValue in
            if !isDragging {
                sliderValue = newValue
            }
        })
        .onAppear {
            Task {
                if songViewModel.currentSong.id != musicStore.currentSong.id {
                    print(musicStore.currentSong.url)
                    audioPlayer.setupAudioPlayer(with: musicStore.currentSong.url)
                    songViewModel.setCurrentSong(song: musicStore.currentSong)
                }
            }
        }
        .onChange(of: musicStore.currentSong) { _, currentSong in
            Task {
                audioPlayer.setupAudioPlayer(with: currentSong.url)
                songViewModel.setCurrentSong(song: currentSong)
            }
        }
    }
}

class AudioPlayer: ObservableObject {
    private var audioPlayer: AVPlayer?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var isSongEnded = false

    static let shared = AudioPlayer()
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    func addPeriodicTimeObserver() {
        let timeInterval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        audioPlayer?.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { time in
            self.currentTime = time.seconds
        }
    }

    func setupAudioPlayer(with url: String) {
        print("Setup started")
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
        print("started playing audio")
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

    @objc func playerDidFinishPlaying(notification: Notification) {
        // This method will be called when the current song has finished playing.
        // Set the isSongEnded flag to true.
        print(notification)
        isSongEnded = true
    }
}

//
// #Preview {
//    MusicPlayerView(songId: "k5mX3NkA7jM", url: "https://musiq-ecf9a99fa8d9.herokuapp.com/api/listen/8JMMjCyyznI/mary%20on%20cross", songLength: 200, imageUrl: "https://i.ytimg.com/vi/KOrXKiSy8ZY/hqdefault.jpg?sqp=-oaymwE9CNACELwBSFryq4qpAy8IARUAAAAAGAElAADIQj0AgKJDeAHwAQH4Af4JgALQBYoCDAgAEAEYZSBLKFUwDw==&rs=AOn4CLDWyiNMrqa4UfmFSo5x3oUfzheHGQ", songTitle: "Mary on Cross")
// }
