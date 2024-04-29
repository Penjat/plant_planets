//
//  ViewController.swift
//  CellFunMacGame
//
//  Created by Spencer Symington on 2024-04-28.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    let appState = AppState()
    @IBOutlet var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let screenSize = NSScreen.main?.frame ?? CGRect.zero
            let scene = GameScene()
            scene.appState = appState
            scene.size = CGSize(width: screenSize.width, height: screenSize.height)
            scene.scaleMode = .fill

            scene.scaleMode = .aspectFill

            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

