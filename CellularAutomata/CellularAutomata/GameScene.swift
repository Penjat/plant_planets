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
        self.testNode = SKShapeNode.init(circleOfRadius: 6)
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

    class Cell {
        var velocity = CGVector.zero
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)

        // Constants for attraction and repulsion forces
        let attractionForce: CGFloat = 0.5
        let repulsionForce: CGFloat = -100.0
        let maxDistance: CGFloat = 500.0
        let minDistance: CGFloat = 50.0
        let maxSpeed: CGFloat = 20.0
        let frictionCoefficient: CGFloat = 0.2

        for (shapeNode, cell) in nodes {
            for (otherShapeNode, otherCell) in nodes where shapeNode != otherShapeNode {
                // Calculate the distance between cells
                let distance = shapeNode.position.distance(to: otherShapeNode.position)

                // Beyond a certain distance, there is no effect
                if distance > maxDistance {
                    continue
                }

                // Calculate the direction of the force
                let direction = CGVector(dx: otherShapeNode.position.x - shapeNode.position.x,
                                         dy: otherShapeNode.position.y - shapeNode.position.y)

                // Calculate the magnitude of the force
                var forceMagnitude: CGFloat = 0.0
                if distance < minDistance {
                    // Repulsion force
                    forceMagnitude = repulsionForce * (minDistance - distance)/minDistance
                } else {
                    // Attraction force
                    forceMagnitude = attractionForce * (maxDistance - distance)/maxDistance
                }

                // Normalize the direction
                let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
                let normalizedDirection = CGVector(dx: direction.dx / length, dy: direction.dy / length)

                // Apply force to both cells
                cell.velocity.dx += normalizedDirection.dx * forceMagnitude * deltaTime
                cell.velocity.dy += normalizedDirection.dy * forceMagnitude * deltaTime
                let speed = hypot(cell.velocity.dx, cell.velocity.dy)
                    if speed > maxSpeed {
                        let scale = maxSpeed / speed
                        cell.velocity.dx *= scale
                        cell.velocity.dy *= scale
                    }



            }
        }
        for (shapeNode, cell) in nodes {
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


