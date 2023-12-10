varying vec2 vUvs;

uniform float rotation;

void main() {
  vec4 localPosition = vec4(position, 1.0);
  gl_Position = projectionMatrix * modelViewMatrix * localPosition;

  // Output
  vUvs = uv;
}