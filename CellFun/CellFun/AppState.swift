import Foundation
import Combine
import SpriteKit

class AppState: ObservableObject {
    @Published var maxSpeed: CGFloat = 50.0
    @Published var repulsionForce: CGFloat = -20.0
    
    @Published var selectedType = CellType.red
    @Published var isRunning = true
    let cellAttractionModel = CellAttractionModel()
    var nodes = [(SKShapeNode, Cell)]()

    func clearNodes() {
        for (node, _) in nodes {
            node.removeFromParent()
        }
        nodes = []
    }
}
