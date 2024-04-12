#ifdef GL_ES
precision mediump float;
#endif

uniform float zValue; // Nouvel uniforme pour la valeur de z du modèle

void main() {
  float zMod = mod(gl_FragCoord.z, 2); // Calcul du modulo de la valeur de z interpolée

  // Si le reste de la division entière de z interpolé par 2 est 0, rendre le pixel noir
  if (zMod == 0) {
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); // Noir
  } else {
    // Sinon, teinter la vallée en vert si z interpolé est en dessous de la valeur spécifiée
    if (gl_FragCoord.z < zValue) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); // // Vert
    } else {
      gl_FragColor = vec4(0.0, 0.4, 0.0, 1.0); // Rendre le pixel blanc par défaut
    }
  }
 
}
