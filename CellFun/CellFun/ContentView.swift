//
//  ContentView.swift
//  CellFun
//
//  Created by Spencer Symington on 2024-04-27.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct ContentView: View {
    @StateObject var appState = AppState()
    @State var showMenu = false
    var scene: SKScene {
        let screenSize = UIScreen.main.bounds

            let scene = GameScene()
        scene.appState = appState
        scene.size = CGSize(width: screenSize.width, height: screenSize.height)
            scene.scaleMode = .fill
            return scene
        }

        var body: some View {
            let screenSize = UIScreen.main.bounds
            ZStack {
                SpriteView(scene: scene)
                    .frame(width: screenSize.width, height: screenSize.height)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {

                    }
                    Button("menu") {
                        print("button press")
                        showMenu.toggle()
                    }

                }.padding(40)
            }.sheet(isPresented: $showMenu) {
                // Content of the modal view
                MenuView()
            }.environmentObject(appState)
        }
}

#Preview {
    ContentView()
}
