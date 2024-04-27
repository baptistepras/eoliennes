#ifdef GL_ES
precision mediump float;
#endif

// Uniform (depuis le main)
uniform sampler2D texture;
uniform float ajustement;  // Hauteur de la vallée
uniform float taille;  // Taille des lignes

// Varying (les mêmes que dans le vertexShader)
varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 vertPos;

void main() {
  float z = mod(gl_FragCoord.z, 2);

  if (vertPos.z < z-ajustement) {
    gl_FragColor = vec4(vertColor.x*(2*(34.0/255.0)), vertColor.y*(2*(96.0/255.0)), vertColor.z*(2*(49.0/255*0)), 1.0) * texture2D(texture, vertTexCoord.st);  // Vert
  } else {
    if (fract(vertPos.z) < taille) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);  // Lignes noires
    } else {
      gl_FragColor = vec4(vertColor.x*1.0, vertColor.y*1.0, vertColor.z*1.0, 1.0) * texture2D(texture, vertTexCoord.st);  // Gris
    }
  }

}
