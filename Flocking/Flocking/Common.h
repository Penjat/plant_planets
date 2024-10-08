#ifndef Common_h
#define Common_h

#import <simd/simd.h>

struct Particle {
    vector_float2 position;
    vector_float2 velocity;
    int type;
};

typedef struct Particle Boid;

struct Params {
    float cohesionStrength;
    float separationStrength;
    float alignmentStrength;
    float predatorStrength;
    float minSpeed;
    float maxSpeed;
    float predatorSpeed;
    float neighborRadius;
    float separationRadius;
    float predatorRadius;
    float predatorSeek;
    float attraction_matrix[36];
    float particleSize;
    float friction;
    uint particleCount;
};
#endif /* Common_h */
