import SwiftUI

enum CellType: Int32, CaseIterable {
    case red = 0
    case orange = 1
    case yellow = 2
    case green = 3
    case blue = 4
    case purple = 5

    var properties: CellTypeProperties {
        switch self {
        case .red:
            CellTypeProperties(color: .red, name: "Red")
        case .orange:
            CellTypeProperties(color: .orange, name: "Orange")
        case .yellow:
            CellTypeProperties(color: .yellow, name: "Yellow")
        case .green:
            CellTypeProperties(color: .green, name: "Green")
        case .blue:
            CellTypeProperties(color: .blue, name: "Blue")
        case .purple:
            CellTypeProperties(color: .purple, name: "Purple")
        }
    }

    var color: Color {
        self.properties.color
    }

    var name: String {
        self.properties.name
    }

    struct CellTypeProperties {
        let color: Color
        let name: String
    }
}
