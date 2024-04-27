/* Projet IGSD
 Raphael LEONARDI, Baptiste PRAS, LDDIM2 Groupe 1
 
 Penser à importer Minim ou à commenter les lignes qui y sont liées:
 Sketch -> Importer une bibliothèque -> Minim
 
 Boutons de déplacement:
 Z: avancer
 S: reculer
 Q: tourner vers la gauche
 D: tourner vers la droite
 Flèche du haut: monter
 Flèche du bas: descendre
 SHIFT: tourner vers le bas
 CTRL: Tourner vers le haut
 BACKSPACE: Retourner au point de départ
 
 Boutons de modification du shader:
 ALT: activer/désactiver le shader
 A: augmenter la hauteur de la vallée
 E: diminuer la hauteur de la vallée
 TAB: réinitialiser la hauteur de la vallée
 Flèche de gauche: augmenter la taille des traits
 Flèche de droite: diminiuer la taille des traits
 ENTER: réinitialiser la taille des traits
*/

// Variables musique
import ddf.minim.*;
Minim minim;
AudioPlayer musique;
AudioPlayer ambiance;

// Variables caméra
float posX = -10;
float posY = 0;
float posZ = 0;
float tmp = 0;
float dtmp = 0;
float angle=1.2252215;;
float dAngle;
float dx;
float dz;
float avance_x;
float avance_z;

// Variables texture
PShape rocket;
PImage textureimg;
PImage ciel;
PShader shader;
boolean activate = true;  // true si le shader est activé, false sinon
float ajustement = 9.95;  // Plus ce nombre est haut, moins la vallée sera coloriée en vert, 9.95 permet un équilibre parfait à la ligne noire
float taille = 0.04;  // Plus le nombre est petit, plus les lignes seront fines, et inversement, valeur de base = 0.04

// Variables structures
boolean[] keys = new boolean[256];
Vector[] filsBas;
Vector[] filsHaut;
Pylone[] pylones;
PShape  p;
int C = 20;
PVector centre = new PVector(0, 0, 0);
PShape pylModele;
PShape pal;
Eolienne[] eoliennes;

public void repere() {
  beginShape(LINES);
  stroke(255, 0, 0);
  vertex(0, 0, 0);
  vertex(C, 0, 0);

  stroke(0, 255, 0);
  vertex(0, 0, 0);
  vertex(0, C, 0);

  stroke(0, 0, 255);
  vertex(0, 0, 0);
  vertex(0, 0, C);
  endShape();
}


// Fonctions de déplacement
void keyPressed() {
  keys[keyCode] = true;

  // Déplacement vers l'avant ou l'arrière
  if (key == 'z' || key == 'Z') {
    dx = 0.2;  // Déplacement vers l'avant
  } else if (key == 's' || key == 'S') {
    dx = -0.2;  // Déplacement vers l'arrière
  } else {
    dx = 0;
  }

  // Rotation vers la droite ou la gauche
  if (key == 'q' || key == 'Q') {
    dAngle = -PI/200;  // Rotation vers la gauche
    musique.play();
  } else if (key == 'd' || key == 'D') {
    dAngle = PI/200;  // Rotation vers la droite
    musique.play();
  } else {
    dAngle = 0;
  }

  // Déplacement vers le bas ou le haut
  if (keys[UP]) {
    dz = avance_z;  // Déplacement vers le haut
  } else if (keys[DOWN]) {
    dz = -1*avance_z;  // Déplacement vers le bas
  } else {
    dz = 0;
  }

  // Rotation vers le bas ou le haut
  if (keys[CONTROL]) {  
    dtmp = 0.01;  // Rotation vers le haut
  } else if (keys[SHIFT]) {
    dtmp= -0.01;  // Rotation vers le bas
  }

  // Activation/Désactivation du shader
  if (keys[ALT]) {
    activate = !activate;
  }
  
  // Augmentation/Diminution de la hauteur de la vallée
  if (key == 'a' || key == 'A') {
    ajustement -= 0.05;  // Augmenter la hauteur de la vallée
  } else if (key == 'e' || key == 'E') {
    ajustement += 0.05;  // Diminuer la hauteur de la vallée
  } else if (keys[TAB]) {
    ajustement = 9.95;  // Réinitialiser la taille des traits
  }
  
   // Augmentation/Diminution de la taille des traits de niveau
  if (keys[LEFT]) {
    taille += 0.01;  // Augmenter la taille des traits
  } else if (keys[RIGHT]) {
    taille -= 0.01;  // Diminuer la taille des traits
  } else if (keys[ENTER]) {
    taille = 0.05;  // Réinitialiser la taille des traits
  }
  
  // Retourner au point de départ
  if (keys[BACKSPACE]) {
    posX = -10;
    posY = 0;
    posZ = 0;
    tmp = 0;
    dtmp = 0;
    angle = 1.2252215;
  }
}

void keyReleased() {
  keys[keyCode] = false;
  dx = 0;
  dAngle = 0;
  dz = 0;
  dtmp = 0;
  musique.pause();
}


// Fonctions de structures
int filCorrespond(int i) {
  if (i == 0 || i == 2) {
    return i;
  } else {
    return 3;
  }
}

void afficheFils() {
  strokeWeight(1);
  stroke(0, 0, 0);
  color(0, 0, 0);
  for (int i = 1; i < 14; i++) {
    pushMatrix();
    translate(pylones[i].position.x, pylones[i].position.y, pylones[i].position.z);
    shape(pylModele);
    noFill();
    //On fait les fils hauts

    for (int j = 0; j < 3; j++) {
      int numero = filCorrespond(j);

      float departx = filsHaut[j].x;
      float departy = filsHaut[j].y;
      float departz = filsHaut[j].z;

      // vertex(departx, departy, departz);

      float x = pylones[i -1].position.x - pylones[i].position.x+ filsHaut[numero].x;
      float y = pylones[i -1].position.y - pylones[i].position.y + filsHaut[numero].y;
      float z = pylones[i -1].position.z - pylones[i].position.z + filsHaut[numero].z ;

      Vector pointMilieu = new Vector((departx + x)/2, (departy+y)/2, min(z, departz) * 0.6);
      bezier(departx, departy, departz, pointMilieu.x, pointMilieu.y, pointMilieu.z, pointMilieu.x, pointMilieu.y, pointMilieu.z, x, y, z);

      //vertex(x, y, z);
    }
    //Maintenant les fils du bas
    for (int j = 0; j < 3; j++) {
      int numero = filCorrespond(j);

      //vertex(filsBas[j].x, filsBas[j].y, filsBas[j].z);

      float departx = filsBas[j].x;
      float departy = filsBas[j].y;
      float departz = filsBas[j].z;

      float x = pylones[i -1].position.x - pylones[i].position.x+ filsBas[numero].x;
      float y = pylones[i -1].position.y - pylones[i].position.y + filsBas[numero].y;
      float z = pylones[i -1].position.z - pylones[i].position.z + filsBas[numero].z ;

      //float ecartZ = abs(z - departz)/2;

      Vector pointMilieu = new Vector((departx + x)/2, (departy+y)/2, min(z, departz) * 0.6);

      bezier(departx, departy, departz, pointMilieu.x, pointMilieu.y, pointMilieu.z, pointMilieu.x, pointMilieu.y, pointMilieu.z, x, y, z);
    }
    endShape();
    popMatrix();
  }
}
//vertex(filsBas[0].x, filsBas[0].y, filsBas[0].z);

void afficheEol(Eolienne E) {
  pushMatrix();
  translate(E.position.x, E.position.y, E.position.z);
  //On affiche la partie immobile

  shape(p);
  translate(E.centrePale.x, E.centrePale.y, E.centrePale.z);
  float theta = frameCount/-15.0;//L'angle des pales

  //La première pale
  rotateY(theta);
  shape(pal);

  rotateY(TWO_PI/3 );
  shape(pal);
  rotateY(TWO_PI/3  );
  shape(pal);
  rotateY(TWO_PI/3);
  //PShape pale1 = pal.copy();

  popMatrix();
}

void affEoliennes() {
  for (Eolienne E : eoliennes) {
    afficheEol(E);
  }
}


// Fonctions principales
public void setup() {
  size(1000, 648, P3D);
  avance_x = 2;
  avance_z = 0.5;

  // Import de tous les fichiers
  minim = new Minim(this);
  musique = minim.loadFile("musique.mp3");
  ambiance = minim.loadFile("MC.mp3");
  ambiance.loop();
  shader = loadShader( "fragmentShader.glsl", "vertexShader.glsl");
  ciel = loadImage("ciel.jpg");
  textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  rocket.translate(0, 0, 190);
  println(rocket.getVertexCount());

  // Import des structures
  p = modeleEolienne(4);
  pylones = creerPylones(rocket, 15);
  centre.z = findZForXY(0, 0)+ 190;
  filsBas  = new Vector[4];
  filsHaut = new Vector[4];
  pal = pale(4);
  eoliennes = new Eolienne[8];
  for (int i = 0; i <8; i++) {
    eoliennes[i] = new Eolienne(new Vector(30, 30+15*i, findZForXY(30, 30+20*i)+190), 4);
  }
  //eoliennes[0] = new Eolienne(new Vector(30, 30, findZForXY(30, 30)+190) , 4);
  //eoliennes[1] = new Eolienne(new Vector(100, 30, findZForXY(100, 30)+190), 4 );
  pylModele = pyl(8, 0.8, 1.0, filsBas, filsHaut);
  println(filsBas);
  println(filsHaut);
  //pushMatrix();
}

public void draw() {
  // Initialisation de la texture
  background(ciel);
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 1, 1000);
  lights();
  if (activate) {
    shader.set("ajustement", ajustement);
    shader.set("taille", taille);
    shader.set("texture", textureimg);
    shader(shader);
  }
  textureMode(NORMAL);
  shape(rocket);
  strokeWeight(4);
  resetShader();
  camera(posX, posY, posZ, posX+(1*cos(angle)), posY+(1*sin(angle)), posZ+tmp, 0, 0, -1);
  repere();

  // Pylones
  pushMatrix();
  translate(pylones[0].position.x, pylones[0].position.y, pylones[0].position.z);
  shape(pylModele);
  popMatrix();

  // Fils et éoliennes
  afficheFils();
  affEoliennes();
  shape(p);

  // Mouvement de la caméra
  angle += dAngle;
  if (dx != 0) {
    posX += cos(angle)* dx * avance_x;
    posY += sin(angle)* dx * avance_x;
  }
  if (posZ > -6.5 || dz > 0) {  // Pour ne pas aller sous la map
    posZ += dz;
  }
  tmp += dtmp;
}
