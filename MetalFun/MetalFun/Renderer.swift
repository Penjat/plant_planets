import MetalKit

class Renderer: NSObject {
    init(metalView: MTKView) {
        super.init()
    }
}
extension Renderer: MTKViewDelegate {
    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize ){
        }
    func draw(in view: MTKView) {
        print("draw")
    }
}
