#include <metal_stdlib>
using namespace metal;
#import "Helper.h"

float2 checkSpeed(float2 vector, float maxSpeed)
{
    float speed = length(vector);
    if (speed > maxSpeed) {
        return vector / speed * maxSpeed;
    }
    return vector;
}

float2 cohesion(Params params, uint index, device Boid* boids) {
    Boid thisBoid = boids[index];
    float neighborsCount = 0;
    float2 cohesion = 0.0;
    for (uint i = 1; i < params.particleCount; i++) {
        Boid boid = boids[i];
        float d = distance(thisBoid.position, boid.position);
        if (d < params.neighborRadius && i != index) {
            cohesion += boid.position;
            neighborsCount++;
        }
    }

    if (neighborsCount > 0) {
        cohesion /= neighborsCount;
        cohesion -= thisBoid.position;
        cohesion *= params.cohesionStrength;
    }
    return cohesion;
}

float2 alignment(Params params, uint index, device Boid* boids)
{

    Boid thisBoid = boids[index];
    float neighborsCount = 0;
    float2 velocity = 0.0;

    for (uint i = 1; i < params.particleCount; i++) {
        Boid boid = boids[i];
        float d = distance(thisBoid.position, boid.position);
        if (d < params.neighborRadius && i != index) {
            velocity += boid.velocity;
            neighborsCount++;
        }
    }

    if (neighborsCount > 0) {
        velocity = velocity / neighborsCount;

        velocity = (velocity - thisBoid.velocity);
        velocity *= params.alignmentStrength;
    }
    return velocity;
}

float2 separation(Params params, uint index, device Boid* boids)
{
    Boid thisBoid = boids[index];
    float2 separation = float2(0);

    for (uint i = 1; i < params.particleCount; i++) {
        Boid boid = boids[i];
        if (i != index) {
            if (abs(distance(boid.position, thisBoid.position))
                < params.separationRadius) {
                separation -= (boid.position - thisBoid.position);
            }
        }
    }
    separation *= params.separationStrength;
    return separation;
}

float getElement(int row, int col, float matrix[]) {
    int index = row * 6 + col;
    return matrix[index];
}

float2 moving(Params params, uint index, device Boid* boids, float2 viewSize) {
    Boid thisBoid = boids[index];
    float half_width = viewSize.x/2;
    float half_height = viewSize.y/2;

    float2 force = 0.0;
    for (uint i = 0; i < params.particleCount; i++) {
        Boid boid = boids[i];

        float2 pos = boid.position - thisBoid.position;

        if (pos.x >= half_width) {
            pos.x = pos.x - viewSize.x;
        } else if (pos.x <= -half_width) {
            pos.x = pos.x + viewSize.x;
        }

        if (pos.y >= half_height) {
            pos.y = pos.y - viewSize.y;
        } else if (pos.x <= -half_height) {
            pos.x = pos.y + viewSize.y;
        }

        float d = distance(vector_float2(0,0), pos);
        float push_strength = 0.05;
        float min_radius = 20.0;

        if (d < min_radius && i != index) {
            force -= ((pos) * (min_radius - d)/min_radius)*push_strength;
        } else if (d < params.neighborRadius && i != index) {
            force += ((pos) * ((params.neighborRadius - d)/params.neighborRadius))*getElement(thisBoid.type, boid.type, params.attraction_matrix);
        }
    }

    return force;
}

kernel void flocking(
                     texture2d<half, access::write> output [[texture(0)]],
                     device Boid *boids [[buffer(0)]],
                     constant Params &params [[buffer(1)]],
                     uint id [[thread_position_in_grid]])
{
    Boid boid = boids[id];
    float2 position = boid.position;
    int type = boid.type;
    float2 viewSize = float2(output.get_width(),
                             output.get_height());
    float2 velocity = boid.velocity;
    float2 movingVector = moving(params, id, boids, viewSize);

    velocity += movingVector;

    position += velocity;


    boid.velocity = checkSpeed(velocity, params.maxSpeed);
    boid.position = wrapPosition(position, viewSize);
    boid.velocity *= params.friction;

    boids[id] = boid;

    half4 color = half4(1.0);

    if (type == 0) {
        color = half4(1, 0, 0, 1);
    }

    if (type == 1) {
        color = half4(1, 0.5, 0, 1);
    }

    if (type == 2) {
        color = half4(1, 1, 0, 1);
    }
    //
    if (type == 3) {
        color = half4(0, 1, 0, 1);
    }

    if (type == 4) {
        color = half4(0, 0, 1, 1);
    }

    if (type == 5) {
        color = half4(1, 0, 1, 1);
    }


    uint2 location = uint2(position);
    int size = params.particleSize;
    for (int x = -size; x <= size; x++) {
        for (int y = -size; y <= size; y++) {
            output.write(color, location + uint2(x, y));
        }
    }
}

kernel void clearScreen(
                        texture2d<half, access::read_write> output [[texture(0)]],
                        uint2 id [[thread_position_in_grid]])
{
    half4 currentColor = output.read(id);
    currentColor.b -= 0.1;
    currentColor.r -= 0.1;
    currentColor.g -= 0.1;
//    currentColor.a -= 0.02;
    output.write(currentColor, id);
}
