//
//  Music.swift
//  flo-swiftui
//
//  Created by 영현 on 3/19/24.
//

import Foundation

struct Music: Codable, Hashable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
}

struct Lyric: Codable, Hashable {
    let time: TimeInterval
    let text: String
}

extension Music {
    static let MOCK_MUSIC: Music = .init(
        singer: "챔버오케스트라",
        album: "캐롤 모음",
        title: "We Wish You A Merry Christmas",
        duration: 198,
        image: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/cover.jpg",
        file: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3",
        lyrics: "")
}

extension Lyric {
    static let MOCK_LYTICS: [Lyric] = [
        Lyric(time: 16.2, text: "we wish you a merry christmas"),
        Lyric(time: 18.3, text: "we wish you a merry christmas"),
        Lyric(time: 21.1, text: "we wish you a merry christmas"),
        Lyric(time: 23.6, text: "and a happy new year"),
        Lyric(time: 26.3, text: "we wish you a merry christmas"),
        Lyric(time: 28.7, text: "we wish you a merry christmas"),
        Lyric(time: 31.4, text: "we wish you a merry christmas"),
        Lyric(time: 33.6, text: "and a happy new year"),
        Lyric(time: 36.5, text: "good tidings we bring"),
        Lyric(time: 38.9, text: "to you and your kin"),
        Lyric(time: 41.5, text: "good tidings for christmas"),
        Lyric(time: 44.2, text: "and a happy new year"),
        Lyric(time: 46.6, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 49.3, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 52.2, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 54.5, text: "And bring it right here"),
        Lyric(time: 57.0, text: "Good tidings we bring"),
        Lyric(time: 59.7, text: "to you and your kin"),
        Lyric(time: 62.1, text: "Good tidings for Christmas"),
        Lyric(time: 64.8, text: "and a happy new year"),
        Lyric(time: 67.4, text: "we wish you a merry christmas"),
        Lyric(time: 70.0, text: "we wish you a merry christmas"),
        Lyric(time: 72.5, text: "we wish you a merry christmas"),
        Lyric(time: 75.0, text: "and a happy new year"),
        Lyric(time: 77.7, text: "We won't go until we get some"),
        Lyric(time: 80.2, text: "We won't go until we get some"),
        Lyric(time: 82.8, text: "We won't go until we get some"),
        Lyric(time: 85.3, text: "So bring some out here"),
        Lyric(time: 89.8, text: "연주"),
        Lyric(time: 131.9, text: "Good tidings we bring"),
        Lyric(time: 134.0, text: "to you and your kin"),
        Lyric(time: 136.5, text: "good tidings for christmas"),
        Lyric(time: 139.4, text: "and a happy new year"),
        Lyric(time: 142.0, text: "we wish you a merry christmas"),
        Lyric(time: 144.4, text: "we wish you a merry christmas"),
        Lyric(time: 147.0, text: "we wish you a merry christmas"),
        Lyric(time: 149.6, text: "and a happy new year"),
        Lyric(time: 152.2, text: "Good tidings we bring"),
        Lyric(time: 154.5, text: "to you and your kin"),
        Lyric(time: 157.2, text: "Good tidings for Christmas"),
        Lyric(time: 160.0, text: "and a happy new year"),
        Lyric(time: 162.4, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 165.0, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 167.6, text: "Oh, bring us some figgy pudding"),
        Lyric(time: 170.2, text: "And bring it right here"),
        Lyric(time: 172.6, text: "we wish you a merry christmas"),
        Lyric(time: 175.3, text: "we wish you a merry christmas"),
        Lyric(time: 177.9, text: "we wish you a merry christmas"),
        Lyric(time: 180.5, text: "and a happy new year")
    ]
}
