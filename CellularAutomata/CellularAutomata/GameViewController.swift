//
//  GameViewController.swift
//  CellularAutomata
//
//  Created by Spencer Symington on 2024-04-26.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a SpriteKit view
        let skView = SKView(frame: view.frame)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)

        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            skView.presentScene(scene)

            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }

        // Create a SwiftUI view
        let swiftUIView = SwiftUIOverlayView()

        // Create a UIHostingController to host the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// SwiftUI Overlay View
struct SwiftUIOverlayView: View {
    var body: some View {
        // You can customize your SwiftUI view here
        VStack {
            Text("Hello, SwiftUI!")
            Button(action: {
                print("Button tapped")
            }) {
                Text("Tap me!")
            }
        }
        .padding()
//        .background(Color.white.opacity(0.0))
        .cornerRadius(10)
        .padding()
    }
}
