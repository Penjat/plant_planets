import Foundation
import Combine
import SpriteKit
import SwiftUI

enum CellType: Int, CaseIterable {
    case red = 0
    case orange = 1
    case yellow = 2
    case green = 3
    case blue = 4
    case purple = 5

    var properties: CellTypeProperties {
        switch self {

        case .red:
            CellTypeProperties(color: .red, skColor: SKColor.red, name: "Red")
        case .orange:
            CellTypeProperties(color: .orange, skColor: SKColor.orange, name: "Orange")
        case .yellow:
            CellTypeProperties(color: .yellow, skColor: SKColor.yellow, name: "Yellow")
        case .green:
            CellTypeProperties(color: .green, skColor: SKColor.green, name: "Green")
        case .blue:
            CellTypeProperties(color: .blue, skColor: SKColor.blue, name: "Blue")
        case .purple:
            CellTypeProperties(color: .purple, skColor: SKColor.purple, name: "Purple")
        }
    }
    var skcolor: SKColor {
        self.properties.skColor
    }

    var color: Color {
        self.properties.color
    }

    var name: String {
        self.properties.name
    }

    struct CellTypeProperties {
        let color: Color
        let skColor: SKColor
        let name: String
    }
}

struct CellAttraction: Hashable {
    var maxDistance: CGFloat
    var attraction: CGFloat
}

class CellAttractionModel: ObservableObject {
    @Published var cellAttractionMatrix: [[CellAttraction]] = {
        CellAttractionModel.createEmptyMatrix()
    }()

    func resetMatrix() {
        cellAttractionMatrix = CellAttractionModel.createEmptyMatrix()
    }

    class func createEmptyMatrix() -> [[CellAttraction]] {
        var array = [[CellAttraction]]()
        for _ in CellType.allCases {
            var row = [CellAttraction]()
            for _ in CellType.allCases {
                row.append(CellAttraction(maxDistance: 500, attraction: 0.00))
            }
            array.append(row)
        }
        return array
    }
}
