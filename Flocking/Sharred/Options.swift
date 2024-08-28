import Observation
import Combine
import MetalKit

enum Command {
    case createCell(position: CGPoint)
    case randomizePosition
}

@Observable
class Options {

    let attractionRange: ClosedRange<Float> = -0.001...0.001
    let maxParticles = 500
    
    var cohesionStrength: Float = 0.0002
    var separationStrength: Float = 0.085
    var alignmentStrength: Float = 0.05
    var predatorStrength: Float = 0.02
    var minSpeed: Float = 4.0
    var maxSpeed: Float = 9
    var predatorSpeed: Float = 10
    var neighborRadius: Float = 400
    var separationRadius: Float = 20
    var predatorRadius: Float = 140
    var predatorSeek: Float = 500
    var particleCount: Int = 1
    var particleSize: Float = 4
    var attraction_matrix: [Float] = Array(repeating: 0.0, count: 36)
    var selectedType = CellType.red
    var friction: Float = 0.99

    let commandSubject = PassthroughSubject<Command, Never>()

    var rebuildEmitter = false

    init() {

    }

    func getValueFromMatrix(row: Int, col: Int) -> Float {
        let index = row * 6 + col // Calculate the index for a 6x6 matrix
        return attraction_matrix[index]
    }

    func setValueInMatrix(row: Int, col: Int, value: Float) {
        let index = row * 6 + col // Calculate the index for a 6x6 matrix
        if index < attraction_matrix.count {
            attraction_matrix[index] = value
        } else {
            // Optionally handle the out-of-bounds error
            print("Attempted to set value out of the bounds of the attraction matrix.")
        }
    }

    func attractionMatrixTuple() -> (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float) {
        return (
            attraction_matrix[0], attraction_matrix[1], attraction_matrix[2], attraction_matrix[3], attraction_matrix[4], attraction_matrix[5],
            attraction_matrix[6], attraction_matrix[7], attraction_matrix[8], attraction_matrix[9], attraction_matrix[10], attraction_matrix[11],
            attraction_matrix[12], attraction_matrix[13], attraction_matrix[14], attraction_matrix[15], attraction_matrix[16], attraction_matrix[17],
            attraction_matrix[18], attraction_matrix[19], attraction_matrix[20], attraction_matrix[21], attraction_matrix[22], attraction_matrix[23],
            attraction_matrix[24], attraction_matrix[25], attraction_matrix[26], attraction_matrix[27], attraction_matrix[28], attraction_matrix[29],
            attraction_matrix[30], attraction_matrix[31], attraction_matrix[32], attraction_matrix[33], attraction_matrix[34], attraction_matrix[35]
        )
    }

    func randomizeMatrix() {
        attraction_matrix = attraction_matrix.map { _ in Float.random(in: attractionRange) } 
    }

    func clearMatrix() {
        attraction_matrix = Array(repeating: 0, count: 36)
    }
}
