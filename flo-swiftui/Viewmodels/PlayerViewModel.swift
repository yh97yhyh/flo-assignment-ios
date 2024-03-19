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
    private var timer: Timer?
    
    @Published var currentLyricIndex = 0
    @Published var currentLyricText = ""
    @Published var nextLyricText = ""
    
    @Published var currentTimeText = "00:00"
    @Published var endTimeText = "00:00"
    
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
        setupTimer()
        setHighlightLyrics()
    }
    
    deinit {
        timer?.invalidate()
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
                    if let duration = self.audioPlayer?.duration {
                        self.updateEndTimeText(duration)
                    }
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
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        timer?.fireDate = Date.distantFuture
    }
    
    @objc private func updateCurrentTime() {
        guard let currentTime = audioPlayer?.currentTime else { return }
        DispatchQueue.main.async {
            self.currentTime = currentTime
            self.updateCurrentTimeText(currentTime)
            self.updateHighlightLyrics()
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        timer?.fireDate = Date()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        timer?.fireDate = Date.distantFuture
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        timer?.fireDate = Date.distantFuture
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        updateCurrentTimeText(time)
    }
    
    private func updateCurrentTimeText(_ currentTime: TimeInterval) {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        currentTimeText = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateEndTimeText(_ duration: TimeInterval) {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        endTimeText = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func setHighlightLyrics() {
        currentLyricText = lyrics[0].text
        nextLyricText = lyrics[1].text
    }
    
    private func updateHighlightLyrics() {
        guard let audioPlayer = audioPlayer else { return }
        
        if let currentIndex = lyrics.firstIndex(where: { $0.time > audioPlayer.currentTime }) {
            if currentIndex > 0 {
                currentLyricText = lyrics[currentIndex - 1].text
                currentLyricIndex = currentIndex - 1
            }
            
            if currentIndex < lyrics.count {
                nextLyricText = lyrics[currentIndex].text
            }
            
        } else {
            currentLyricIndex = lyrics.count - 1
            currentLyricText = lyrics[lyrics.count - 1].text
            nextLyricText = ""
        }
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        currentTimeText = "00:00"
        setHighlightLyrics()
    }
    
}
