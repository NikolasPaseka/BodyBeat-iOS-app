//
//  SplashScreen.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI

struct SplashScreen: View {
    @State var size = 0.8
    @State var active = false
    
    var body: some View {
        if (active) {
            ContentView()
        } else {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .foregroundColor(Color.lighterOrange)
                    .scaleEffect(size)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.active = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
