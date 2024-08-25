//
//  Shaders.metal
//  Pipeline
//
//  Created by Spencer Symington on 2024-05-04.
//

#include <metal_stdlib>
using namespace metal;

// 1
struct VertexIn {
    float4 position [[attribute(0)]];
};
// 2
vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]])
{
    float4 position = vertexIn.position;
//    position.y += position.x;
    return position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 1, 1);
}
