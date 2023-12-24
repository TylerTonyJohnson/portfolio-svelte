varying vec2 vUvs;
varying vec2 vScreenPosition;

uniform float iTime;

const float TwoPI = 6.28318530718;

// void main() {
//     gl_FragColor = vec4(abs(sin(iTime + gl_FragCoord.x * 0.1)), abs(cos(iTime + gl_FragCoord.y * 0.1)), 0.0, 1.0);
// }

uint hash(uint x, uint seed) {
    const uint m = 0x5bd1e995U;
    uint hash = seed;
    // process input
    uint k = x;
    k *= m;
    k ^= k >> 24;
    k *= m;
    hash *= m;
    hash ^= k;
    // some final mixing
    hash ^= hash >> 13;
    hash *= m;
    hash ^= hash >> 15;
    return hash;
}

uint hash(uvec3 x, uint seed) {
    const uint m = 0x5bd1e995U;
    uint hash = seed;
    // process first vector element
    uint k = x.x;
    k *= m;
    k ^= k >> 24;
    k *= m;
    hash *= m;
    hash ^= k;
    // process second vector element
    k = x.y;
    k *= m;
    k ^= k >> 24;
    k *= m;
    hash *= m;
    hash ^= k;
    // process third vector element
    k = x.z;
    k *= m;
    k ^= k >> 24;
    k *= m;
    hash *= m;
    hash ^= k;
	// some final mixing
    hash ^= hash >> 13;
    hash *= m;
    hash ^= hash >> 15;
    return hash;
}

vec3 gradientDirection(uint hash) {
    switch(int(hash) & 15) { // look at the last four bits to pick a gradient direction
        case 0:
            return vec3(1, 1, 0);
        case 1:
            return vec3(-1, 1, 0);
        case 2:
            return vec3(1, -1, 0);
        case 3:
            return vec3(-1, -1, 0);
        case 4:
            return vec3(1, 0, 1);
        case 5:
            return vec3(-1, 0, 1);
        case 6:
            return vec3(1, 0, -1);
        case 7:
            return vec3(-1, 0, -1);
        case 8:
            return vec3(0, 1, 1);
        case 9:
            return vec3(0, -1, 1);
        case 10:
            return vec3(0, 1, -1);
        case 11:
            return vec3(0, -1, -1);
        case 12:
            return vec3(1, 1, 0);
        case 13:
            return vec3(-1, 1, 0);
        case 14:
            return vec3(0, -1, 1);
        case 15:
            return vec3(0, -1, -1);
    }
}

float interpolate(float value1, float value2, float value3, float value4, float value5, float value6, float value7, float value8, vec3 t) {
    return mix(mix(mix(value1, value2, t.x), mix(value3, value4, t.x), t.y), mix(mix(value5, value6, t.x), mix(value7, value8, t.x), t.y), t.z);
}

vec3 fade(vec3 t) {
    // 6t^5 - 15t^4 + 10t^3
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float singleNoise(vec3 position, uint seed) {
    vec3 floorPosition = floor(position);
    vec3 fractPosition = position - floorPosition;
    uvec3 cellCoordinates = uvec3(floorPosition);
    float value1 = dot(gradientDirection(hash(cellCoordinates, seed)), fractPosition);
    float value2 = dot(gradientDirection(hash((cellCoordinates + uvec3(1, 0, 0)), seed)), fractPosition - vec3(1, 0, 0));
    float value3 = dot(gradientDirection(hash((cellCoordinates + uvec3(0, 1, 0)), seed)), fractPosition - vec3(0, 1, 0));
    float value4 = dot(gradientDirection(hash((cellCoordinates + uvec3(1, 1, 0)), seed)), fractPosition - vec3(1, 1, 0));
    float value5 = dot(gradientDirection(hash((cellCoordinates + uvec3(0, 0, 1)), seed)), fractPosition - vec3(0, 0, 1));
    float value6 = dot(gradientDirection(hash((cellCoordinates + uvec3(1, 0, 1)), seed)), fractPosition - vec3(1, 0, 1));
    float value7 = dot(gradientDirection(hash((cellCoordinates + uvec3(0, 1, 1)), seed)), fractPosition - vec3(0, 1, 1));
    float value8 = dot(gradientDirection(hash((cellCoordinates + uvec3(1, 1, 1)), seed)), fractPosition - vec3(1, 1, 1));
    return interpolate(value1, value2, value3, value4, value5, value6, value7, value8, fade(fractPosition));
}

float perlinNoise(vec3 position, int frequency, int octaveCount, float persistence, float lacunarity, uint seed) {
    float value = 0.0;
    float amplitude = 1.0;
    float currentFrequency = float(frequency);
    uint currentSeed = seed;
    for(int i = 0; i < octaveCount; i++) {
        currentSeed = hash(currentSeed, 0x0U); // create a new seed for each octave
        value += singleNoise(position * currentFrequency, currentSeed) * amplitude;
        amplitude *= persistence;
        currentFrequency *= lacunarity;
    }
    return value;
}

void main() {

    /* 
        Rainbow
     */

    // General rocking
    float rockingDistance = 0.5;
    float rockingSpeed = 1.0;

    float rocking = 0.0;
    rocking = (sin((iTime) * rockingSpeed) * rockingDistance) / TwoPI;  // Angle

    // Individual colors
    float r = 0.0;
    float g = 0.0;
    float b = 0.0;

    // Color rocking
    r += vUvs.x + rocking;
    g += vUvs.x + rocking;
    b += vUvs.x + rocking;

    // Offset
    r += 0.0;
    g += 1.0 / 3.0;
    b += 2.0 / 3.0;

    // Color rocking
    r = cos(TwoPI * r);
    g = cos(TwoPI * g);
    b = cos(TwoPI * b);

    // Scaling
    r = r * 0.5 + 0.5;
    g = g * 0.5 + 0.5;
    b = b * 0.5 + 0.5;

    /* 
       Noise 
    */
    uint seed = 0x578437adU;

    float radius = 1.0 / TwoPI;

    float xValue = radius * cos(vScreenPosition.x * TwoPI) + 1.0;
    float yValue = radius * sin(vScreenPosition.x * TwoPI) + 1.0;
    float zValue = vScreenPosition.y;
    
    // Move over time
    zValue += iTime * 0.1;

    // Calculate color
    float value = 0.0;
    value = perlinNoise(vec3(xValue, yValue, zValue), 4, 6, 0.5, 2.0, seed);
    // value = perlinNoise(vec3(vUvs, iTime * 0.1), 2, 6, 0.5, 2.0, seed);
    
    
    // Scale color
    value = (value + 1.0) * 0.5;

    // Vignette color
    // value = mix(0.0, value, vUvs.y * 2.0);

    
    /* 
        Output
    */

    
    // gl_FragColor = vec4(r, g, b, value);
    gl_FragColor = vec4(r, g, b, value);
}
