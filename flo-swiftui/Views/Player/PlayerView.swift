//
//  PlayerView.swift
//  flo-swiftui
//
//  Created by 영현 on 3/18/24.
//

import SwiftUI
import Kingfisher
import AVFoundation

struct PlayerView: View {
    @StateObject var viewModel: PlayerViewModel = PlayerViewModel.shared
//    let background = Color(red: 2/255, green: 6/255, blue: 12/255)
    let background = Color.black
    
    var body: some View {
        ZStack {
            background
        
            VStack {
                if viewModel.isFetching {
                    ProgressView("")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text(viewModel.album)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.bottom, 1)
                    Text(viewModel.title)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 1)
                    Text(viewModel.singer)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    KFImage(URL(string: viewModel.image))
                        .resizable()
                        .frame(width: 200, height: 200)
                        .scaledToFill()
                        .clipped()
                        .cornerRadius(20)
                        .padding(.bottom)
                    
                    NavigationLink(destination: LyricView()) {
                        VStack {
                            Text(viewModel.currentLyricText)
                                .foregroundColor(.white)
                            Text(viewModel.nextLyricText)
                                .foregroundStyle(.gray)
                                .padding(.bottom, 40)
                        }
                    }
                    
                    PlayerProgressView()
                    
                }
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
//        .onReceive(viewModel.$currentTime) { newCurrentTime in
//            print("currentTime : \(newCurrentTime)")
//        }
//        .onReceive(viewModel.$isPlaying) { newIsPlaying in
//            print("isPlaying : \(newIsPlaying)")
//        }
    }
}

#Preview {
    PlayerView()
}
