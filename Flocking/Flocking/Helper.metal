#include <metal_stdlib>
using namespace metal;
#include "Helper.h"

float2 wrapPosition(float2 position, float2 size) {
  float width = size.x;
  float height = size.y;
  float2 newPosition = position;
  if (position.x < 0) {
    newPosition.x = width;
  } else if (position.x > width) {
    newPosition.x = 0;
  }
  if (position.y < 0) {
    newPosition.y = height;
  } else if (position.y > height) {
    newPosition.y = 0;
  }
  return newPosition;
}

Boid bounceBoid(float2 position, float2 velocity, float2 size, int type) {
  float2 newPosition = position;
  float2 newVelocity = velocity;
  float width = size.x;
  float height = size.y;
  if (position.x <= 0 || position.x >= width) {
    newVelocity.x *= -1;
    if (position.x <= 0) {
      newPosition.x = 25;
    } else if (position.x >= width) {
      newPosition.x = width - 25;
    }
  }
  if (position.y <= 0 || position.y >= height) {
    newVelocity.y *= -1;
    if (position.y <= 0) {
      newPosition.y = 25;
    } else if (position.y >= height) {
      newPosition.y = height - 25;
    }
  }

    newVelocity *= 0.8;
  return Boid { newPosition, newVelocity, type };
}

