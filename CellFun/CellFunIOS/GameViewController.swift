import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    let appState = AppState()

    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("menu", for: .normal)
        
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded viewcontroller")
        let skView = SKView(frame: self.view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(skView)

        // Create and present the SpriteKit scene


        // Load the SKScene from 'GameScene.sks'
        let screenSize = UIScreen.main.bounds
        let scene = GameScene(size: skView.bounds.size)
        scene.appState = appState
        scene.size = CGSize(width: screenSize.width, height: screenSize.height)
        scene.scaleMode = .fill

        scene.scaleMode = .aspectFill

        skView.presentScene(scene)

        skView.ignoresSiblingOrder = true
        skView.preferredFramesPerSecond = 30
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)



        skView.addSubview(menuButton)

//        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true
//        menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100).isActive = true
//        menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true


        menuButton.bringSubviewToFront(skView)


    }
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        view.backgroundColor = .green
    }




    override var prefersStatusBarHidden: Bool {
        return true
    }

    func presentMenu() {
        let menuViewController = MenuViewController(appState: appState)
        menuViewController.modalPresentationStyle = .pageSheet
        present(menuViewController, animated: true, completion: nil)
    }



    @objc func menuButtonTapped() {
        presentMenu()
    }
}

import SwiftUI


class MenuViewController: UIHostingController<MenuView> {

    init(appState: AppState) {
        super.init(rootView: MenuView(appState: appState))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
