import MetalKit
import SwiftUI

struct Emitter {
    var particleBuffer: MTLBuffer!
    let size: CGSize

    init(
        options: Options,
        size: CGSize,
        device: MTLDevice
    ) {
        let bufferSize = MemoryLayout<Particle>.stride * options.maxParticles
        particleBuffer = device.makeBuffer(length: bufferSize)
        particleBuffer.contents().bindMemory(
            to: Particle.self,
            capacity: options.maxParticles)
        self.size = size
    }

    func createCell(x: Float, y: Float, type: Int32, options: Options) {
        var pointer = particleBuffer.contents().bindMemory(
            to: Particle.self,
            capacity: options.maxParticles)
        pointer = pointer.advanced(by: options.particleCount)
        pointer = addCell(pointer: pointer, x: x, y: y, type: type)
        options.particleCount += 1
    }

    func randomizePosition(options: Options) {
        var pointer = particleBuffer.contents().bindMemory(
            to: Particle.self,
            capacity: options.maxParticles)

        for _ in 0..<options.particleCount {
            let xPosition = random(Int(size.width))
            let yPosition = random(Int(size.height))
            pointer.pointee.velocity = float2(0, 0)
            pointer.pointee.position = float2(xPosition, yPosition)
            pointer = pointer.advanced(by: 1)
        }
    }

    func createRandomCells(_ numberOfCells: Int ) {
        for i in 0..<numberOfCells {
            let xPosition = random(Int(size.width))
            let yPosition = random(Int(size.height))
//            TODO: Fix This
//            createCell(x: xPosition, y: yPosition, type: BoidType.allCases.randomElement().rawValue, options: )
        }
    }

    func addCell(pointer: UnsafeMutablePointer<Particle>, x: Float, y: Float, type: Int32) -> UnsafeMutablePointer<Particle>{
        pointer.pointee.velocity = float2(0, 0)
        pointer.pointee.position = float2(x, y)
        pointer.pointee.type = type
        return pointer.advanced(by: 1)
    }

    func random(_ max: Int) -> Float {
        guard max > 0 else { return 0 }
        return Float.random(in: 0..<Float(max))
    }
}
