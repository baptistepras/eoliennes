uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 position; // C'est les appels a Vertex(x,y,z)
attribute vec4 color; // Les fill(r,g,b,a) au dessus de vertex()
attribute vec3 normal; // appel a normal(dxn, dy, dz)

attribute vec4 texCoord; 
// vertex a 5 params: vertex(x, y, z, u, v) (u,v) textures  

varying vec4 vertColor;

void main() {

  vec4 nposition= vec4(position.x, position.y, position.z + texCoord.x, position.w );

  //on modifie ici nposition
  gl_Position   = transform * nposition;
  vertColor     = color;
}