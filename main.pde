/* Projet IGSD
 Raphael LEONARDI, Baptiste PRAS, LDDIM2 Groupe 1
 
 Penser à importer Minim et à décommenter les lignes qui y sont liées
 si vous voulez avoir la musique:
 Sketch -> Importer une bibliothèque -> Minim
 Lignes: 35 -> 38, 111, 114, 209, 496 -> 499
 
 Boutons de déplacement:
 Z: avancer
 W: sprinter
 S: reculer
 Q: tourner vers la gauche
 D: tourner vers la droite
 Flèche du haut: monter
 Flèche du bas: descendre
 SHIFT: tourner vers le bas
 CTRL: tourner vers le haut
 BACKSPACE: retourner au point de départ
 H: afficher/désafficher les coordonnées
 R: afficher/désafficher le repère
 T: activer/désactiver les collisions
 F: activer/désactiver la vue FPS
 
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
// import ddf.minim.*;  // <- Voir explications ligne 4 avant de décommenter
// Minim minim;  // <- Voir explications ligne 4 avant de décommenter
// AudioPlayer musique;  // Easteregg  <- Voir explications ligne 4 avant de décommenter
// AudioPlayer ambiance;  // Musique d'ambiance  <- Voir explications ligne 4 avant de décommenter

// Variables caméra
float posX = -23;
float posY = -39;
float posZ = 22;
float orientationZ = -HALF_PI;
float dorientationZ;
float orientationX = -HALF_PI;
float dorientationX;
float dx;
float dz;
float avance_x = 2;
float avance_z = 0.5;
boolean col = true;
boolean fps = false;
boolean altMin = false;
boolean[] keys = new boolean[256];
boolean[] keysCoded = new boolean[256];
Vector pointAncrage = new Vector(0, -1.1*4/5, 4);

// Variables texture
PShape rocket;
float tempoX;
float tempoY;
float tempoZ;
PImage textureimg;
PImage ciel;
PShader shader;
float dajustement;
float dtaille;
float ajustement = 9.95;  // Plus ce nombre est haut, moins la vallée sera coloriée en vert, 9.95 permet un équilibre parfait à la ligne noire
float taille = 0.04;  // Plus le nombre est petit, plus les lignes seront fines, et inversement, valeur de base = 0.04
boolean afficherTexte = true;
boolean afficherRepere = true;
boolean afficherShader = true;

// Variables structures
int nbPylones = 14;
Vector[] filsBas;
Vector[] filsHaut;
Pylone[] pylones;
PShape  p;
int C = 20;
PVector centre = new PVector(0, 0, 0);
PShape pylModele;
PShape pal;
Eolienne[] eoliennes;


// Fonctions de déplacement
void keyPressed() {
  if (key == CODED) {
    keysCoded[keyCode] = true;
  } else {
    keys[key] = true;
  }

  // Déplacement vers l'avant ou l'arrière
  if (keys['z'] || keys['Z']) {
    dx = -0.2;  // Déplacement vers l'avant
  } else if (keys['s'] || keys['S']) {
    dx = 0.2;  // Déplacement vers l'arrière
  } else if (keys['w'] || keys['W']) {
    dx = -0.5;
  } else {
    dx = 0;
  }

  // Rotation vers la droite ou la gauche
  if (keys['q']  || keys['Q']) {
    dorientationX = -PI/200;  // Rotation vers la gauche
    // musique.play();  // <- Voir explications ligne 4 avant de décommenter
  } else if (keys['d']  || keys['D']) {
    dorientationX = PI/200;  // Rotation vers la droite
    // musique.play();  // <- Voir explications ligne 4 avant de décommenter
  } else {
    dorientationX = 0;
  }
  // Déplacement vers le bas ou le haut
  if (keysCoded[UP]) {
    dz = avance_z;  // Déplacement vers le haut
    altMin = false;
  } else if (keysCoded[DOWN] && (!altMin || !col)) {
    dz = -1*avance_z;  // Déplacement vers le bas
  } else {
    dz = 0;
  }

  // Rotation vers le bas ou le haut
  if (keysCoded[CONTROL]) {
    dorientationZ = 0.01;  // Rotation vers le haut
  } else if (keysCoded[SHIFT]) {
    dorientationZ= -0.01;  // Rotation vers le bas
  } else {
    dorientationZ = 0.0;
  }

  // Activation/Désactivation du shader
  if (keysCoded[ALT]) {
    afficherShader = !afficherShader;
  }

  // Augmentation/Diminution de la hauteur de la vallée
  if (keys['a'] || keys['A']) {
    dajustement = -0.02;  // Augmenter la hauteur de la vallée
  } else if (keys['e'] || keys['E']) {
    dajustement = 0.02;  // Diminuer la hauteur de la vallée
  } else if (keys[TAB]) {
    ajustement = 9.95;  // Réinitialiser la taille des traits
  } else {
    dajustement = 0.00;
  }

  // Augmentation/Diminution de la taille des traits de niveau
  if (keysCoded[LEFT]) {
    dtaille = 0.01;  // Augmenter la taille des traits
  } else if (keysCoded[RIGHT]) {
    dtaille = -0.01;  // Diminuer la taille des traits
  } else if (keys[ENTER]) {
    taille = 0.05;  // Réinitialiser la taille des traits
  } else {
    dtaille = 0.00;
  }

  // Affichage/Désaffichage des coordonnées
  if (keys['h'] || keys['H']) {
    afficherTexte = !afficherTexte;
  }

  // Affichage/Désaffichage du repère
  if (keys['r'] || keys['R']) {
    afficherRepere = !afficherRepere;
  }

  // Activation/Désactivation collisions
  if ((keys['t'] || keys['T']) && !fps) {
    col = !col;
  }

  // Activation/Désactivation de la vue FPS
  if (keys['f'] || keys['F']) {
    altMin = true;
    fps = !fps;
  }

  // Retourner au point de départ
  if (keys[BACKSPACE]) {
    posX = -23;
    posY = -39;
    posZ = 22;
    orientationZ = -HALF_PI;
    dorientationZ = 0;
    orientationX = -HALF_PI;
  }
}

void keyReleased() {
  if (key == CODED) {
    keysCoded[keyCode] = false;
  } else {
    keys[key] = false;
  }

  dx = 0;
  dorientationX = 0;
  dz = 0;
  dorientationZ = 0;
  dajustement = 0;
  dtaille = 0;
  // musique.pause();  // <- Voir explications ligne 4 avant de décommenter
}

void bouger() {
  tempoX = posX;
  tempoY = posY;
  tempoZ = posZ;

  orientationX = (orientationX + dorientationX) % TWO_PI;
  if ((orientationZ > -3.14 || dorientationZ > 0) && (orientationZ < 0.0 || dorientationZ < 0)) {  // Empêche de faire un tour complet vers le haut/bas
    orientationZ = (orientationZ + dorientationZ) % TWO_PI;
  }

  if (dx != 0) {
    tempoX += cos(orientationX)* dx * avance_x;
    tempoY += sin(orientationX)* dx * avance_x;
  }

  // Hauteur minimale
  if (tempoZ > -6.5 || dz > 0) {  // Pour ne pas aller sous la map
    tempoZ += dz;
  }

  // Contrôle de la hauteur de la vallée
  if ((ajustement < 13.2 || dajustement < 0) && (ajustement > -9.5 || dajustement > 0)) { // Empêche d'avoir des valeurs de ajustement incongrues
    ajustement += dajustement;
  }

  // Contrôle de l'épaisseur des lignes
  if ((taille < 1.04 || dtaille < 0) && (taille > -0.02 || dtaille > 0)) {  // Empêche d'avoir des valeurs de taille incongrues
    taille += dtaille;
  }

  // Contrôle du Z sur les déplacements
  float zallowed = findZForXY(tempoX, tempoY) + 193;
  if (fps) {  // Vue FPS
    if (tempoZ < zallowed-0.5) {
      posZ += avance_z;  // Monter
    } else if (tempoZ > zallowed+0.5) {
      posZ += -1*avance_z;  // Descendre
    } else if (tempoX < 128 && tempoX > -136 && tempoY < 160 && tempoY > -159) {  // Emêche de sortir de la map
      posX = tempoX;
      posY = tempoY;
    }
  }

  // Vue classique
  else if (tempoZ < zallowed && col) {  // Nous replace au-dessus de la map si on était en dessous
    posZ += avance_z;
    altMin = true;
  } else if ((tempoZ > zallowed || !col || dz > 0) && (tempoX < 128 && tempoX > -136 && tempoY < 160 && tempoY > -159)) {  // Collisions avec la map
    posX = tempoX;
    posY = tempoY;
    posZ = tempoZ;
    // Empêche de trembler si on reste appuyer vers le bas en étant au minimum
    if (tempoZ < zallowed+0.5 && col) {
      altMin = true;
      dz = 0;
    } else {
      altMin = false;
    }
  }
}

void afficherPosition() {
  if (afficherTexte) {
    camera();
    noLights();
    fill(0, 0, 0);
    ortho();
    //perspective();
    translate(10, 10);
    //box(10);
    beginShape(QUADS);
    stroke(0, 0, 0);
    fill(255, 255, 255);
    vertex(-10, -10, 0);
    vertex(200, -10, 0);
    vertex(200, 110, 0);
    vertex(-10, 110, 0);
    endShape();
    fill(0, 0, 0);
    text("Position x : "+ int(posX), 10, 10);
    text("Position y : "+ int(posY), 10, 30);
    text("Position z : "+ int(posZ), 10, 50);
    text("Orientation horizontale : " + int((180/PI)*orientationX) + " degrés", 10, 70);
    text("Orientation verticale : " + int((180/PI)*orientationZ) + " degrés", 10, 90);
  }
}

void repere() {
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
  //textSize(10);

  fill(255, 0, 0);
  text("X", C, 0, 0);

  fill(0, 255, 0);
  text("Y", 0, C, 0);

  fill(0, 0, 255);
  text("Z", 0, 0, C);
}


// Fonctions de structures
void filsPylEol() {
  return;
}

int filCorrespond(int i) {
  if (i == 0 || i == 2) {
    return i;
  } else {

    if (i == 1) {
      return 3;
    } else {
      return 1;
    }
  }
}

void afficheFils() {
  strokeWeight(1);
  stroke(0, 0, 0);
  color(0, 0, 0);
  for (int i = 0; i < nbPylones-1; i++) {
    pushMatrix();
    translate(pylones[i].position.x, pylones[i].position.y, pylones[i].position.z);
    shape(pylModele);
    popMatrix();
    noFill();

    // Fils du haut
    for (int j = 0; j < 3; j++) {
      int numero = filCorrespond(j);
      //vertex(filsBas[j].x, filsBas[j].y, filsBas[j].z);
      float departx = pylones[i].position.x + filsHaut[j].x;
      float departy = pylones[i].position.y + filsHaut[j].y;
      float departz = pylones[i].position.z + filsHaut[j].z;

      float x = pylones[i+1].position.x + filsHaut[numero].x;
      float y = pylones[i+1].position.y + filsHaut[numero].y;
      float z = pylones[i+1].position.z + filsHaut[numero].z ;
      Vector pointMilieu = new Vector((departx + x)/2, (departy+y)/2, (departz+z)/2 - 1.5 );
      bezier(departx, departy, departz, pointMilieu.x, pointMilieu.y, pointMilieu.z, pointMilieu.x, pointMilieu.y, pointMilieu.z, x, y, z);
    }

    // Fils du bas
    for (int j = 0; j < 3; j++) {
      int numero = filCorrespond(j);
      //vertex(filsBas[j].x, filsBas[j].y, filsBas[j].z);
      
      float departx = pylones[i].position.x + filsBas[j].x;
      float departy = pylones[i].position.y + filsBas[j].y;
      float departz = pylones[i].position.z + filsBas[j].z;

      float x = pylones[i+1].position.x + filsBas[numero].x;
      float y = pylones[i+1].position.y + filsBas[numero].y;
      float z = pylones[i+1].position.z + filsBas[numero].z ;

      Vector pointMilieu = new Vector((departx + x)/2, (departy+y)/2, (departz+z)/2 - 1.5 );
      bezier(departx, departy, departz, pointMilieu.x, pointMilieu.y, pointMilieu.z, pointMilieu.x, pointMilieu.y, pointMilieu.z, x, y, z);
    }

    if (i < 6) {
      pushMatrix();
      strokeWeight(2);

      // Eolienne gauche
      float eolGauchePosx = eoliennes[i].position.x + pointAncrage.x;
      float eolGauchePosy = eoliennes[i].position.y + pointAncrage.y;
      float eolGauchePosz = eoliennes[i].position.z + pointAncrage.z;
      
      // Eolienne droite
      float eolDroitePosx = eoliennes[i+6].position.x + pointAncrage.x;
      float eolDroitePosy = eoliennes[i+6].position.y + pointAncrage.y;
      float eolDroitePosz = eoliennes[i+6].position.z + pointAncrage.z;

      beginShape(LINES);
      //vertex(eolGauchePosx, eolGauchePosy, eolGauchePosz);
      bezier(eolGauchePosx, eolGauchePosy, eolGauchePosz,
        (eolGauchePosx + pylones[i].position.x + filsBas[2].x)/2,
        (eolGauchePosy + pylones[i].position.y + filsBas[2].y)/2,
        0.2*(eolGauchePosz + pylones[i].position.z+ filsBas[2].z)/2,
        (eolGauchePosx + pylones[i].position.x + filsBas[2].x)/2,
        (eolGauchePosy + pylones[i].position.y + filsBas[2].y)/2,
        0.2*(eolGauchePosz + pylones[i].position.z + filsBas[2].z)/2,
        pylones[i].position.x+ filsBas[2].x, pylones[i].position.y+ filsBas[2].y,
        pylones[i].position.z+ filsBas[2].z);

      //vertex(pylones[i].position.x+ filsBas[2].x, pylones[i].position.y+ filsBas[2].y, pylones[i].position.z+ filsBas[2].z);
      bezier(eolGauchePosx, eolGauchePosy, eolGauchePosz,
        (eolGauchePosx + pylones[i].position.x+ filsHaut[2].x)/2,
        (eolGauchePosy + pylones[i].position.y+ filsHaut[2].y)/2,
        0.2*(eolGauchePosz + pylones[i].position.z+ filsHaut[2].z)/2,
        (eolGauchePosx + pylones[i].position.x+ filsHaut[2].x)/2,
        (eolGauchePosy + pylones[i].position.y+ filsHaut[2].y)/2,
        0.2*(eolGauchePosz + pylones[i].position.z+ filsHaut[2].z)/2,
        pylones[i].position.x+ filsHaut[2].x, pylones[i].position.y+ filsHaut[2].y, pylones[i].position.z+ filsHaut[2].z);

      bezier(eolDroitePosx, eolDroitePosy, eolDroitePosz,
        (eolDroitePosx + pylones[i].position.x+ filsBas[0].x)/2,
        (eolDroitePosy + pylones[i].position.y+ filsBas[0].y)/2,
        0.2*(eolDroitePosz + pylones[i].position.z+ filsBas[0].z)/2,
        (eolDroitePosx + pylones[i].position.x+ filsBas[0].x)/2,
        (eolDroitePosy + pylones[i].position.y+ filsBas[0].y)/2,
        0.2*(eolDroitePosz + pylones[i].position.z+ filsBas[0].z)/2,
        pylones[i].position.x+ filsBas[0].x, pylones[i].position.y+ filsBas[0].y, pylones[i].position.z+ filsBas[0].z);

      //vertex(pylones[i].position.x+ filsBas[2].x, pylones[i].position.y+ filsBas[2].y, pylones[i].position.z+ filsBas[2].z);
      bezier(eolDroitePosx, eolDroitePosy, eolDroitePosz,
        (eolDroitePosx + pylones[i].position.x+ filsHaut[0].x)/2,
        (eolDroitePosy + pylones[i].position.y+ filsHaut[0].y)/2,
        0.2*(eolDroitePosz + pylones[i].position.z+ filsHaut[0].z)/2,
        (eolDroitePosx + pylones[i].position.x+ filsHaut[0].x)/2,
        (eolDroitePosy + pylones[i].position.y+ filsHaut[0].y)/2,
        0.2*(eolDroitePosz + pylones[i].position.z+ filsHaut[0].z)/2,
        pylones[i].position.x+ filsHaut[0].x, pylones[i].position.y+ filsHaut[0].y, pylones[i].position.z+ filsHaut[0].z);

      endShape();
      popMatrix();
      strokeWeight(1);
      stroke(0, 0, 0);
    }
  }
  endShape();

  pushMatrix();
  translate(pylones[nbPylones-1].position.x, pylones[nbPylones-1].position.y, pylones[nbPylones-1].position.z);
  shape(pylModele);
  popMatrix();
}
//vertex(filsBas[0].x, filsBas[0].y, filsBas[0].z);

void afficheEol(Eolienne E) {
  pushMatrix();
  translate(E.position.x, E.position.y, E.position.z);
  //On affiche la partie immobile
  rotateZ(3.5*PI/2);
  shape(p);
  translate(E.centrePale.x, E.centrePale.y, E.centrePale.z);
  float theta = frameCount/-15.0;//L'orientationX des pales

  // Première pale
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
  for (int i = 0; i < 12; i++) {
    Eolienne E= eoliennes[i];
    pushMatrix();
    //translate(E.position.x, E.position.y, E.position.z);
    afficheEol(E);
    popMatrix();
    // if (i < 7){}
  }
}

// Fonctions principales
void setup() {
  // Initialisation variables
  size(1000, 648, P3D);
  pointAncrage = rotateAxeZ(pointAncrage, 3.5*PI/2);

  // Import de tous les fichiers
  // minim = new Minim(this);  // <- Voir explications ligne 4 avant de décommenter
  // musique = minim.loadFile("musique.mp3");  // <- Voir explications ligne 4 avant de décommenter
  // ambiance = minim.loadFile("MC.mp3");  // <- Voir explications ligne 4 avant de décommenter
  // ambiance.loop();  // <- Voir explications ligne 4 avant de décommenter
  shader = loadShader( "fragmentShader.glsl", "vertexShader.glsl");
  ciel = loadImage("ciel.jpg");
  textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  rocket.translate(0, 0, 190);

  // Import des structures
  p = modeleEolienne(4);
  pylones = creerPylones(rocket, nbPylones);
  centre.z = findZForXY(0, 0)+ 190;
  filsBas  = new Vector[4];
  filsHaut = new Vector[4];
  pal = pale(4);
  eoliennes = new Eolienne[12];

  float debutEol1x = -115;
  float debutEol1y = -52;
  float finEol1x = -41;
  float finEol1y = -20;

  float debutEol2x = -116;
  float debutEol2y = -2;
  float finEol2x = -68;
  float finEol2y = 56;

  float DX1 = (finEol1x -debutEol1x)/5;
  float DY1 = (finEol1y -debutEol1y)/5;
  float DX2 = (finEol2x -debutEol2x)/5;
  float DY2 = (finEol2y -debutEol2y)/5;

  for (int i = 0; i <6; i++) {
    float x1 = debutEol1x+ DX1*i;
    float y1 = debutEol1y+ DY1*i;
    Vector sommet1= findSommet(x1, y1);
    float x2 = debutEol2x+ DX2*i;
    float y2 = debutEol2y+ DY2*i;
    float  sommet2= findZForXY(x2, y2);
    eoliennes[i] = new Eolienne(new Vector(sommet1.x, sommet1.y, sommet1.z + 190), 4);
    eoliennes[i+6] = new Eolienne(new Vector(x2, y2, sommet2 + 190), 4);
  }
  //eoliennes[0] = new Eolienne(new Vector(30, 30, findZForXY(30, 30)+190) , 4);
  //eoliennes[1] = new Eolienne(new Vector(100, 30, findZForXY(100, 30)+190), 4 );
  pylModele = pyl(8, 0.8, 1.0, filsBas, filsHaut);
  //pushMatrix();
}

void draw() {
  // Initialisation
  background(ciel);

  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  bouger();
  camera(posX, posY, posZ, posX+sin(orientationZ)*cos(orientationX), posY+(1*sin(orientationZ)*sin(orientationX)), posZ+cos(orientationZ), 0, 0, -1);
  perspective(fov, float(width)/float(height), 1, 10000);
  lights();

  if (afficherShader) {
    shader.set("ajustement", ajustement);
    shader.set("taille", taille);
    shader(shader);
  }

  textureMode(NORMAL);
  shape(rocket);
  resetShader();

  // Repère
  if (afficherRepere) {
    repere();
  }

  // Fils et éoliennes
  afficheFils();
  affEoliennes();

  // Affichage des coordonnées
  afficherPosition();
}
