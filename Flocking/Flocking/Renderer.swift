import MetalKit
import Combine
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable function_body_length

class Renderer: NSObject {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue!
    var clearPSO: MTLComputePipelineState!
    var flockingPSO: MTLComputePipelineState!

    let options: Options
    var emitter: Emitter?
    var params = Params()
    var size: CGSize = .zero
    var bag = Set<AnyCancellable>()

    init(metalView: MTKView, options: Options) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        self.device = device
        self.commandQueue = commandQueue
        self.options = options
        
        super.init()

        let library = device.makeDefaultLibrary()
        do {
            guard let clearFunction = library?.makeFunction(name: "clearScreen"),
                  let flockingFunction = library?.makeFunction(name: "flocking") else {
                fatalError("Compute functions do not exist")
            }
            clearPSO = try device.makeComputePipelineState(function: clearFunction)
            flockingPSO = try device.makeComputePipelineState(function: flockingFunction)
        } catch {
            fatalError("Failed to create Metal Pipeline")
        }

        metalView.delegate = self
        metalView.device = device
        metalView.framebufferOnly = false
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)

        options.commandSubject.sink { [weak self] command in
            switch command {
            case .createCell(position: let point):
                print("tell emiter to create point \(point) \(options.particleCount)")
                self?.emitter?.createCell(x: Float(point.x*2), y: Float(point.y*2), type: options.selectedType.rawValue, options: options)
            case .randomizePosition:
                self?.emitter?.randomizePosition(options: options)
            }


        }.store(in: &bag)
    }

    func buildEmitter(options: Options, size: CGSize, device: MTLDevice) -> Emitter? {
        options.rebuildEmitter = false
        if size.width > 0 && size.height > 0 {
            return Emitter(options: options, size: size, device: device)
        }
        return nil
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {
        self.size = size
        emitter = buildEmitter(options: options, size: size, device: device)
    }

    func updateParameters() {
        params.cohesionStrength = options.cohesionStrength
        params.separationStrength = options.separationStrength
        params.alignmentStrength = options.alignmentStrength
        params.predatorStrength = options.predatorStrength
        params.neighborRadius = options.neighborRadius
        params.separationRadius = options.separationRadius
        params.predatorRadius = options.predatorRadius
        params.predatorSeek = options.predatorSeek
        params.particleCount = UInt32(options.particleCount)
        params.minSpeed = options.minSpeed
        params.maxSpeed = options.maxSpeed
        params.predatorSpeed = options.predatorSpeed
        params.attraction_matrix = options.attractionMatrixTuple()
        params.particleSize = options.particleSize
        params.friction = options.friction
    }

    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeComputeCommandEncoder(),
              let drawable = view.currentDrawable else {
            return
        }

        if options.rebuildEmitter {
            emitter = buildEmitter(options: options, size: size, device: device)
        }

        guard let emitter else {
            return
        }

        updateParameters()

        // first pass - clear the screen
        commandEncoder.setComputePipelineState(clearPSO)
        commandEncoder.setTexture(drawable.texture, index: 0)
        let width = clearPSO.threadExecutionWidth
        let height = clearPSO.maxTotalThreadsPerThreadgroup / width
        var threadsPerGroup = MTLSizeMake(width, height, 1)
        var threadsPerGrid = MTLSizeMake(Int(view.drawableSize.width),
                                         Int(view.drawableSize.height),
                                         1)
#if os(iOS)
        if device.supportsFamily(.apple4) {
            commandEncoder.dispatchThreads(threadsPerGrid,
                                           threadsPerThreadgroup: threadsPerGroup)
        } else {
            let width = (view.drawableSize.width / CGFloat(width)).rounded(.up)
            let height = (view.drawableSize.height / CGFloat(height)).rounded(.up)
            let groupsPerGrid = MTLSize(width: Int(width),
                                        height: Int(height),
                                        depth: 1)
            commandEncoder.dispatchThreadgroups(groupsPerGrid,
                                                threadsPerThreadgroup: threadsPerGroup)
        }
#elseif os(macOS)
        commandEncoder.dispatchThreads(threadsPerGrid,
                                       threadsPerThreadgroup: threadsPerGroup)
#endif

        // second pass - calculate boid movement
        commandEncoder.setComputePipelineState(flockingPSO)
        threadsPerGroup = MTLSizeMake(1, 1, 1)
        threadsPerGrid = MTLSizeMake(options.particleCount, 1, 1)
        commandEncoder.setBuffer(emitter.particleBuffer,
                                 offset: 0,
                                 index: 0)

        commandEncoder.setBytes(&params,
                                length: MemoryLayout<Params>.stride,
                                index: 1)
#if os(iOS)
        if device.supportsFamily(.apple4) {
            commandEncoder.dispatchThreads(threadsPerGrid,
                                           threadsPerThreadgroup: threadsPerGroup)
        } else {
            let threads = min(clearPSO.threadExecutionWidth,
                              options.particleCount)
            let threadsPerThreadgroup = MTLSize(width: threads,
                                                height: 1,
                                                depth: 1)
            let groups = options.particleCount / threads + 1
            let groupsPerGrid = MTLSize(width: groups,
                                        height: 1,
                                        depth: 1)
            commandEncoder.dispatchThreadgroups(groupsPerGrid,
                                                threadsPerThreadgroup: threadsPerThreadgroup)
        }
#elseif os(macOS)
        commandEncoder.dispatchThreads(threadsPerGrid,
                                       threadsPerThreadgroup: threadsPerGroup)
#endif
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
