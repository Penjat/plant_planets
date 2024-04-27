//
//  GameScene.swift
//  CellularAutomata
//
//  Created by Spencer Symington on 2024-04-26.
//

import SpriteKit
import GameplayKit

class Cell {
    var velocity = CGVector.zero
}

class GameScene: SKScene {
    var lastUpdateTime: TimeInterval = 0
    private var label : SKLabelNode?
    private var testNode: SKShapeNode?
    private var nodes = [SKShapeNode: Cell]()
    private var centerNode: SKShapeNode?

    var accelerationSpeed: CGFloat = 4.0
    var maxSpeed: CGFloat = 50.0


    override func didMove(to view: SKView) {
        let w = (self.size.width + self.size.height) * 0.05
        self.testNode = SKShapeNode.init(circleOfRadius: 12)
        self.centerNode = SKShapeNode.init(circleOfRadius: 8)
        centerNode!.strokeColor = SKColor.yellow

        self.addChild(centerNode!)
        if let testNode = self.testNode {
            testNode.lineWidth = 2.5

            testNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))

        }
    }


    func touchDown(atPoint pos : CGPoint) {
        if let n = self.testNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            nodes[n] = Cell()
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.testNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
    }

    func touchUp(atPoint pos : CGPoint) {
        //        if let n = self.testNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)

//        print(deltaTime)
        // Called before each frame is rendered
        for (shapeNode, cell) in nodes {
            // Calculate the distance to (0, 0)
            let distanceX = -shapeNode.position.x
            let distanceY = -shapeNode.position.y

            // Calculate acceleration towards (0, 0)
            let accelerationX = distanceX * accelerationSpeed
            let accelerationY = distanceY * accelerationSpeed

            // Update velocity with acceleration scaled by delta time
            cell.velocity.dx += accelerationX * deltaTime
            cell.velocity.dy += accelerationY * deltaTime

            // Limit velocity to maxSpeed
            let speed = hypot(cell.velocity.dx, cell.velocity.dy)
            if speed > maxSpeed {
                let scale = maxSpeed / speed
                cell.velocity.dx *= scale
                cell.velocity.dy *= scale
            }

            // Update position with velocity scaled by delta time
            shapeNode.position.x += cell.velocity.dx * deltaTime
            shapeNode.position.y += cell.velocity.dy * deltaTime
        }
    }

    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        // When the level is started or after the game has been paused, the last update time is reset to the current time.
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }

        // Calculate delta time since `update` was last called.
        let deltaTime = currentTime - lastUpdateTime

        // Use current time as the last update time on next game loop update.
        lastUpdateTime = currentTime

        return deltaTime
    }
}
