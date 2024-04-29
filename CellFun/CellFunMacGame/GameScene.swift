//
//  GameScene.swift
//  CellFunMacGame
//
//  Created by Spencer Symington on 2024-04-28.
//

import SpriteKit
import GameplayKit
import Combine

class GameScene: SKScene {
    var appState: AppState?
    var lastUpdateTime: TimeInterval = 0
    private var label : SKLabelNode?
    private var testNode: SKShapeNode?

    private var centerNode: SKShapeNode?

    var accelerationSpeed: CGFloat = 4.0

    override func didMove(to view: SKView) {

        self.testNode = SKShapeNode.init(circleOfRadius: 2)
        self.centerNode = SKShapeNode.init(circleOfRadius: 8)
        centerNode!.strokeColor = SKColor.yellow

        self.addChild(centerNode!)
        if let testNode = self.testNode {
            testNode.lineWidth = 2.5

            //            testNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))

        }
    }


    func touchDown(atPoint pos : CGPoint) {
        print("touch down")
        guard let appState else {
            return
        }

        if let n = self.testNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = appState.selectedType.skcolor
            appState.nodes.append((n, Cell(type: appState.selectedType)))
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







    override func update(_ currentTime: TimeInterval) {
        guard let appState, let scene, appState.isRunning else {
            return
        }

        let deltaTime = calculateDeltaTime(from: currentTime)

        // Constants for attraction and repulsion forces
        let maxDistance: CGFloat = 500.0
        let minDistance: CGFloat = 8.0
        let frictionCoefficient: CGFloat = 0.8

        for (shapeNode, cell) in appState.nodes {
            for (otherShapeNode, otherCell) in appState.nodes where shapeNode != otherShapeNode {
                // check the 3 distances
                // for which ever is smaller
                // we want the xPosition that gives that distance
                // Is there and easier way to do this 😅
                // Modulus?
                let xArray = [(distance: abs(otherShapeNode.position.x - shapeNode.position.x), position: otherShapeNode.position.x),
                             (distance: abs((otherShapeNode.position.x+scene.size.width) - shapeNode.position.x), position: otherShapeNode.position.x+scene.size.width),
                             (distance: abs((otherShapeNode.position.x-scene.size.width) - shapeNode.position.x), position: otherShapeNode.position.x-scene.size.width)]
                let xPosition = xArray.sorted { $0.distance < $1.distance }[0].position

                let yArray = [(distance: abs(otherShapeNode.position.y - shapeNode.position.y), position: otherShapeNode.position.y),
                             (distance: abs((otherShapeNode.position.y+scene.size.height) - shapeNode.position.y), position: otherShapeNode.position.y+scene.size.height),
                             (distance: abs((otherShapeNode.position.y-scene.size.height) - shapeNode.position.y), position: otherShapeNode.position.y-scene.size.height)]
                let yPosition = yArray.sorted { $0.distance < $1.distance }[0].position



                // Calculate the distance between cells
                let distance = shapeNode.position.distance(to: CGPoint(x: xPosition, y: yPosition))

                // Beyond a certain distance, there is no effect
                if distance > maxDistance {
                    continue
                }

                // Calculate the direction of the force
                let direction = CGVector(dx: xPosition - shapeNode.position.x,
                                         dy: yPosition - shapeNode.position.y)

                // Calculate the magnitude of the force
                var forceMagnitude: CGFloat = 0.0
                if distance < minDistance {
                    // Repulsion force
                    forceMagnitude = appState.repulsionForce * (minDistance - distance)/minDistance
                } else {
                    // Attraction force
                    forceMagnitude = appState.cellAttractionModel.cellAttractionMatrix[cell.type.rawValue][otherCell.type.rawValue].attraction * (maxDistance - distance)/maxDistance
                }

                // Normalize the direction
                let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)

                let normalizedDirection: CGVector
                if length != 0 {
                    normalizedDirection = CGVector(dx: direction.dx / length, dy: direction.dy / length)
                } else {
                    normalizedDirection = CGVector.zero // Handle the case when length is zero
                }

                // Apply force to both cells
                cell.velocity.dx += normalizedDirection.dx * forceMagnitude * deltaTime
                cell.velocity.dy += normalizedDirection.dy * forceMagnitude * deltaTime
                let speed = hypot(cell.velocity.dx, cell.velocity.dy)
                if speed > appState.maxSpeed {
                    let scale = appState.maxSpeed / speed
                    cell.velocity.dx *= scale
                    cell.velocity.dy *= scale
                }

                // Check for collisions with walls and wrap around if colliding
                if shapeNode.position.x < 0 {
                    shapeNode.position.x = scene.size.width
                }
                if shapeNode.position.x > scene.size.width {
                    shapeNode.position.x = 0
                }
                if shapeNode.position.y < 0 {
                    shapeNode.position.y = scene.size.height
                }
                if shapeNode.position.y > scene.size.height {
                    shapeNode.position.y = 0
                }
            }
        }

        for (shapeNode, cell) in appState.nodes {
            shapeNode.position.x += cell.velocity.dx
            shapeNode.position.y += cell.velocity.dy
            cell.velocity.dx *= (1.0 - frictionCoefficient * deltaTime)
            cell.velocity.dy *= (1.0 - frictionCoefficient * deltaTime)
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

    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }

    func normalized() -> CGPoint {
        let length = sqrt(x * x + y * y)
        return CGPoint(x: x / length, y: y / length)
    }
}
