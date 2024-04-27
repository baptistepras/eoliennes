// Attribute
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

// Varying
varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 vertPos;

// Uniform
uniform mat4 transform;
uniform mat4 texMatrix;

void main() {
  // Ces valeurs seront passées au fragmentShader
  gl_Position = transform * position;
  vertPos = position;
  vertColor = color;
  vertTexCoord = texMatrix*vec4(texCoord, 1.0, 1.0);
}