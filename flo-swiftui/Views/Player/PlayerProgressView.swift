//
//  PlayerProgressView.swift
//  flo-swiftui
//
//  Created by 영현 on 3/19/24.
//

import SwiftUI

struct PlayerProgressView: View {
    @StateObject var viewModel: PlayerViewModel = PlayerViewModel.shared
    let background = Color.black
    
    var body: some View {
        ZStack {
//            background

            VStack {
                Slider(value: Binding(
                    get: { viewModel.currentTime },
                    set: { newValue in
                        viewModel.seek(to: newValue)
                        viewModel.currentTime = newValue
                    }),
                       in: 0...Double(viewModel.duration),
                       step: 1)
                .accentColor(.blue)
                
                
                HStack {
                    Text(viewModel.currentTimeText)
                        .font(.footnote)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(viewModel.endTimeText)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 16)
                
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        if viewModel.isPlaying {
                            viewModel.pause()
                        } else {
                            viewModel.play()
                        }
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 48)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.end.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerProgressView()
}
