//
//  ContentView.swift
//  flo-swiftui
//
//  Created by 영현 on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    @StateObject var playerViewModel = PlayerViewModel.shared
    
    var body: some View {
        VStack {
            if showMainView {
                NavigationStack {
                    PlayerView()
//                        .environmentObject(playerViewModel)
                }
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
