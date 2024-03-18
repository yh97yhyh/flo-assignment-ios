//
//  PlayerViewModel.swift
//  flo-swiftui
//
//  Created by 영현 on 3/19/24.
//

import Foundation
import AVFoundation

class PlayerViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = PlayerViewModel()
    
    @Published var singer: String
    @Published var album: String
    @Published var title: String
    @Published var duration: Int
    @Published var image: String
    @Published var file: String
    @Published var lyrics: [Lyric]
    @Published var isFetching = true
    
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    
    @Published var currentTimeText = "00:00"
    @Published var endTimeText = "02:23"
    
    init(singer: String = Music.MOCK_MUSIC.singer, album: String = Music.MOCK_MUSIC.album, title: String = Music.MOCK_MUSIC.title, duration: Int = Music.MOCK_MUSIC.duration, image: String = Music.MOCK_MUSIC.image, file: String = Music.MOCK_MUSIC.singer, lyrics: [Lyric] = Lyric.MOCK_LYTICS) {
        self.singer = singer
        self.album = album
        self.title = title
        self.duration = duration
        self.image = image
        self.file = file
        self.lyrics = lyrics
        
        super.init()
        fetchMusicInfo()
    }
    
    func fetchMusicInfo() {
        NetworkManager<Music>.fetch {result in
            switch result {
            case .success(let music):
                self.singer = music.singer
                self.album = music.album
                self.title = music.title
                self.duration = music.duration
                self.image = music.image
                self.file = music.file
                self.lyrics = self.parseLyrics(lyricsString: music.lyrics)
                self.fetchMusic(file: music.file)
                print("succeed to get music info!")
            case .failure(let error):
                print("failed to get music info.. \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMusic(file: String) {
        guard let fileUrl = URL(string: file) else {
            print("failed to get music file url..")
            return
        }
        
        NetworkManager<Music>.download(from: fileUrl) { result in
            switch result {
            case .success(let data):
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.delegate = self
                    self.audioPlayer?.prepareToPlay()
                    self.isFetching = false
                    print("Succeed to get music file!")
                } catch {
                    print("Failed to create audio player: \(error)")
                }
            case .failure(let error):
                print("Failed to download music file.. \(error)")
            }
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    private func parseLyrics(lyricsString: String) -> [Lyric] {
        let lines = lyricsString.components(separatedBy: "\n")
        var lyrics: [Lyric] = []
        
        for line in lines {
            let components = line.components(separatedBy: "]")
            if components.count >= 2 {
                let timeString = components[0].replacingOccurrences(of: "[", with: "")
                let text = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                let timeComponents = timeString.components(separatedBy: ":")
                if timeComponents.count == 3,
                   let minute = Double(timeComponents[0]),
                   let second = Double(timeComponents[1]),
                   let millisecond = Double(timeComponents[2]) {
                    
                    let time = (minute * 60) + second + (millisecond / 1000)
                    let lyric = Lyric(time: time, text: text)
                    lyrics.append(lyric)
                }
            }
        }
        
        return lyrics
    }
    
    func audioPlayer(_ player: AVAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
}
