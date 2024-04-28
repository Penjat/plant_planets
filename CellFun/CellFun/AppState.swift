import Foundation
import Combine

class AppState: ObservableObject {
    @Published var maxSpeed: CGFloat = 50.0
    @Published var repulsionForce: CGFloat = -100.0
    @Published var selectedType = CellType.orange
    let cellAttractionModel = CellAttractionModel()
}
