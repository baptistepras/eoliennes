class Eolienne {
  Vector position;
  float hauteur;
  Vector centrePale;

  Eolienne(Vector p, float auteur) {
    position = p;
    hauteur = auteur;
    float R = hauteur / 5;
    centrePale = new Vector(0, R + 1.8*0.8*(R/2), hauteur + R/2);
  }
}

PShape base(float hauteur) {
  //renvoie la partie immobile de l'éolienne
  stroke(0, 0, 0);
  fill(255, 255, 255);
  float R = hauteur/5;

  // Pavé de la base
  float rayon = hauteur / 5;
  PShape struct = createShape();

  // Face sol
  struct.beginShape(QUADS);
  struct.vertex(-rayon/2, -rayon/2, 0);
  struct.vertex(rayon/2, -rayon/2, 0);
  struct.vertex(rayon/2, rayon/2, 0);
  struct.vertex(-rayon/2, rayon/2, 0);
  //struct.endShape();

  // Face haut
  //struct.beginShape(QUADS);
  struct.vertex(-rayon/2, -rayon/2, hauteur);
  struct.vertex(rayon/2, -rayon/2, hauteur);
  struct.vertex(rayon/2, rayon/2, hauteur);
  struct.vertex(-rayon/2, rayon/2, hauteur);

  // Face gauche
  struct.vertex(-rayon/2, -rayon/2, 0);
  struct.vertex(-rayon/2, -rayon/2, hauteur);
  struct.vertex(-rayon/2, rayon/2, hauteur);
  struct.vertex(-rayon/2, rayon/2, 0);

  // Face droite
  struct.vertex(rayon/2, -rayon/2, 0);
  struct.vertex(rayon/2, -rayon/2, hauteur);
  struct.vertex(rayon/2, rayon/2, hauteur);
  struct.vertex(rayon/2, rayon/2, 0);

  // Face avant
  struct.vertex( -rayon/2, -rayon/2, 0);
  struct.vertex( -rayon/2, -rayon/2, hauteur);
  struct.vertex( rayon/2, -rayon/2, hauteur);
  struct.vertex( rayon/2, -rayon/2, 0);

  // Face arrière
  struct.vertex( -rayon/2, rayon/2, 0);
  struct.vertex( -rayon/2, rayon/2, hauteur);
  struct.vertex( rayon/2, rayon/2, hauteur);
  struct.vertex( rayon/2, rayon/2, 0);

  struct.endShape();

  //triorientationX
  struct.beginShape(QUADS);
  struct.vertex(-rayon/2, -rayon, hauteur);
  struct.vertex(-rayon/2, rayon, hauteur + R);
  struct.vertex(-rayon/2, rayon, hauteur );
  struct.vertex(-rayon/2, -rayon, hauteur);

  struct.vertex(rayon/2, -rayon, hauteur);
  struct.vertex(rayon/2, rayon, hauteur + R);
  struct.vertex(rayon/2, rayon, hauteur );
  struct.vertex(rayon/2, -rayon, hauteur);

  struct.vertex(rayon/2, -rayon, hauteur);
  struct.vertex(rayon/2, rayon, hauteur );
  struct.vertex(-rayon/2, rayon, hauteur );
  struct.vertex(-rayon/2, -rayon, hauteur);

  struct.vertex(rayon/2, -rayon, hauteur);
  struct.vertex(rayon/2, rayon, hauteur + R );
  struct.vertex(-rayon/2, rayon, hauteur + R);
  struct.vertex(-rayon/2, -rayon, hauteur);

  struct.vertex(rayon/2, rayon, hauteur);
  struct.vertex(rayon/2, rayon, hauteur + R);
  struct.vertex(-rayon/2, rayon, hauteur+R);
  struct.vertex(-rayon/2, rayon, hauteur);

  //struct.vertex(-rayon/2, -rayon/2, hauteur);
  //struct.vertex(rayon/2, -rayon/2, hauteur);
  //struct.vertex(rayon/2, rayon, hauteur);
  //struct.vertex(-rayon/2, rayon, hauteur);
  ////struct.endShape();

  PShape cylindre = createShape();
  float rayonEol = R / 2;
  float decalageY = 1.8*0.8* rayonEol;
  float centreX = 0;
  float centreY = rayon;
  float centreZ = hauteur + R/2;
  //new Vector(0, rayon, hauteur + rayonEol);
  float x1, y1, z1, x2, y2, z2, orientationX1, orientationX2;
  struct.beginShape(QUADS);
  struct.strokeWeight(0); //noStroke();
  for (int i = 0; i < 50; i++) {
    orientationX1 = (TWO_PI*i)/50.0;
    orientationX2 = (TWO_PI*(i+1))/50.0;

    x1 = 0.8*rayonEol * cos(orientationX1) +centreX;
    y1 = centreY;
    z1 = 0.8*rayonEol*sin(orientationX1)+ centreZ;

    x2 = 0.8*rayonEol * cos(orientationX2) +centreX;
    y2 = centreY;
    z2 = 0.8*rayonEol*sin(orientationX2)+ centreZ;
    
    struct.vertex(x1, y1, z1);
    struct.vertex(x1, y1 + decalageY, z1);

    struct.vertex(x2, y2 + decalageY, z2);
    struct.vertex(x2, y2, z2);
  }
  struct.endShape();

  cylindre.beginShape();
  cylindre.fill(255, 255, 255);
  for (int i = 0; i < 200; i++) {
    orientationX1 = (TWO_PI*i)/200.0;
    orientationX2 = (TWO_PI*(i+1))/200.0;

    x1 = 0.8*rayonEol * cos(orientationX1) +centreX;
    y1 = centreY + decalageY ;
    z1 = 0.8*rayonEol*sin(orientationX1)+ centreZ;

    x2 = 0.8*rayonEol * cos(orientationX2) +centreX;
    y2 = centreY + decalageY;
    z2 = 0.8*rayonEol*sin(orientationX2)+ centreZ;
    
    cylindre.vertex(x1, y1, z1);
    cylindre.vertex(x2, y2, z2);
  }
  cylindre.endShape(CLOSE);

  PShape cylindre2 = createShape();
  cylindre2.beginShape();
  cylindre2.strokeWeight(2);
  for (int i = 0; i < 200; i++) {
    orientationX1 = (TWO_PI*i)/200.0;
    orientationX2 = (TWO_PI*(i+1))/200.0;

    x1 = 0.8*rayonEol * cos(orientationX1) +centreX;
    y1 = centreY ;
    z1 = 0.8*rayonEol*sin(orientationX1)+ centreZ;

    x2 = 0.8*rayonEol * cos(orientationX2) +centreX;
    y2 = centreY ;
    z2 = 0.8*rayonEol*sin(orientationX2)+ centreZ;
    
    cylindre2.vertex(x1, y1, z1);
    cylindre2.vertex(x2, y2, z2);
  }
  cylindre2.endShape(CLOSE);

  PShape group  = createShape(GROUP);
  group.addChild(cylindre);
  group.addChild(struct);
  group.addChild(cylindre2);
  return group;
}

PShape pale(float hauteur) {
  float rayon = 0.8*(hauteur/10);
  PShape total = createShape(GROUP);
  PShape p1 = createShape();
  PShape p2 = createShape();
  
  
  
  float larg = rayon *0.35;
  float haut = larg * 2;
  float debutZ = sqrt(rayon*rayon - (larg *larg)/4 );
  float profondeur = larg;
  float hautPal = 70*larg;
  //p.beginShape(QUADS);
  
  //


  
    
    p1.beginShape();
    p1.vertex(3.5* larg, 0, haut+debutZ);
    p1.bezierVertex(3.5*larg, 0, haut+debutZ,  0, 0, haut+debutZ+hautPal, -3.5*larg, 0, haut+debutZ);
    p1.vertex(-3.5 * larg, 0 , haut  + debutZ);
    p1.vertex(3.5 * larg, 0 , haut  + debutZ);
    p1.endShape();
    
 
 
    p2.beginShape(QUADS);
    p2.vertex( larg/2, 0, debutZ);
    p2.vertex(  larg/2, 0, debutZ+haut);
    p2.vertex(  -larg/2, 0, debutZ + haut);
    p2.vertex( -larg/2, 0, debutZ );
    p2.endShape();
   
   total.addChild(p1);
   total.addChild(p2);
 
  return total;
}

PShape modeleEolienne(float hauteur) {
  PShape struct = base(hauteur);
  return struct;
}
