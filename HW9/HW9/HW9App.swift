//
//  HW9App.swift
//  HW9
//
//  Created by ？？？ on 4/3/23.
//

import SwiftUI
@main
struct HW9App: App {
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}

struct LaunchScreenView: View {
    @State private var showMyContentView = false
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            if showMyContentView {
                ContentView()
            } else {
                Image("launchScreen")
                    
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                            showMyContentView = true
                        }
                    }
            }
        }
        .navigationBarHidden(true)
    }
}









