//
//  CellFunTests.swift
//  CellFunTests
//
//  Created by Spencer Symington on 2024-04-28.
//

import XCTest

final class CellFunTests: XCTestCase {
    func testNormalSpacingReturnsNormalDistance() {
        let scene = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let shape1 = Node(position: CGPoint(x: 0, y: 0))
        let shape2 = Node(position: CGPoint(x: 100, y: 0))

        let (distance, direction) = getDirection(scene: scene, shapeNode: shape1, otherShapeNode: shape2)
        XCTAssertEqual(distance, 100.0)
        XCTAssertEqual(direction, CGVector(dx: 100.0, dy: 0))
    }

    func testWrapSpacingReturnsWrapDistance() {
        XCTAssert(true)
        
        let scene = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let shape1 = Node(position: CGPoint(x: -400, y: 0))
        let shape2 = Node(position: CGPoint(x: 400, y: 0))

        let (distance, direction) = getDirection(scene: scene, shapeNode: shape1, otherShapeNode: shape2)


        var myDistance = shape2.position.x - shape1.position.x
        if myDistance > scene.width/2 {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = (500 - value)*(-1)
            print(result)
        } else if myDistance < -scene.width/2  {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = 500 - value
            print(result)

        } else {
            print(myDistance)
        }
        XCTAssertEqual(distance, 200.0)
        XCTAssertEqual(direction, CGVector(dx: -200.0, dy: 0))
    }

    func testWrapSpacingReturnsWrapDistance2() {
        XCTAssert(true)

        let scene = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let shape1 = Node(position: CGPoint(x: -450, y: 0))
        let shape2 = Node(position: CGPoint(x: 450, y: 0))

        let (distance, direction) = getDirection(scene: scene, shapeNode: shape1, otherShapeNode: shape2)

        var myDistance = shape2.position.x - shape1.position.x
        if myDistance > scene.width/2 {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = (500 - value)*(-1)
            print(result)
        } else if myDistance < -scene.width/2  {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = 500 - value
            print(result)

        } else {
            print(myDistance)
        }

        XCTAssertEqual(distance, 100.0)
        XCTAssertEqual(direction, CGVector(dx: -100.0, dy: 0))
    }

    func testWrapSpacingReturnsWrapDistance3() {
        XCTAssert(true)

        let scene = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let shape1 = Node(position: CGPoint(x: 450, y: 0))
        let shape2 = Node(position: CGPoint(x: -450, y: 0))

        let (distance, direction) = getDirection(scene: scene, shapeNode: shape1, otherShapeNode: shape2)


        var myDistance = shape2.position.x - shape1.position.x
        if myDistance > scene.width/2 {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = (500 - value)*(-1)
            print(result)
        } else if myDistance < -scene.width/2  {
            let value = (abs(myDistance)).truncatingRemainder(dividingBy: 500)

            let result = 500 - value
            print(result)

        } else {
            print(myDistance)
        }



        XCTAssertEqual(distance, 100.0)
        XCTAssertEqual(direction, CGVector(dx: 100.0, dy: 0))
    }


    func getDirection(scene: CGRect, shapeNode: Node, otherShapeNode: Node) -> (CGFloat, CGVector) {
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


        // Calculate the direction of the force
        let direction = CGVector(dx: xPosition - shapeNode.position.x,
                                 dy: yPosition - shapeNode.position.y)

        return (distance, direction)
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

    struct Node {
        let position: CGPoint
    }
