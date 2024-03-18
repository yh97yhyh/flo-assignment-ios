//
//  SplashView.swift
//  flo-swiftui
//
//  Created by 영현 on 3/19/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("flo-splash")
                .resizable()
//                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SplashView()
}
