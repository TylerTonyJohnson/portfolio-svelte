varying vec2 vUvs;
varying vec2 vScreenPosition;

void main() {
  vec4 localPosition = vec4(position, 1.0);
  gl_Position = projectionMatrix * modelViewMatrix * localPosition;

  // Output
  vUvs = uv;
  vScreenPosition = vec2(gl_Position.x, gl_Position.y);
}