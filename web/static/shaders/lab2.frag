// based on https://github.com/mrdoob/three.js/blob/master/examples/webgl_buffergeometry_instancing_billboards.html

precision highp float;
uniform sampler2D map;
uniform float r;
uniform float g;
uniform float b;
varying vec2 vUv;
varying float vScale;

// HSL to RGB Convertion helpers
vec3 HUEtoRGB(float H){
  H = mod(H,1.0);
  float R = r * (abs(H * 6.0 - 3.0) - 1.0);
  float G = g * (1.0 - abs(H * 6.0 - 2.0));
  float B = b * (2.0 - abs(H * 6.0 - 4.0));
  return clamp(vec3(R,G,B),0.0,1.0);
}

vec3 HSLtoRGB(vec3 HSL){
  vec3 RGB = HUEtoRGB(HSL.x);
  float C = (1.0 - abs(2.0 * HSL.z - 1.0)) * HSL.y;
  return (RGB - 0.5) * C + HSL.z;
}

void main() {
  vec4 diffuseColor = texture2D( map, vUv );
  gl_FragColor = vec4( diffuseColor.xyz * HSLtoRGB(vec3(vScale/5.0, 1.0, 0.5)), diffuseColor.w );
  if ( diffuseColor.w < 0.5 ) discard;
}
