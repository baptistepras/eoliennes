class Vector {
  float x;
  float y;
  float z;

  Vector(float a, float b, float c) {
    x = a;
    y  = b;
    z = c;
  }

  String toString() {
    String ch  = "(" + this.x + ","+this.y+","+this.z+")";
    return ch;
  }
}

class Droite {
  Vector depart;
  Vector v;

  Droite(Vector D, Vector v) {
    this.depart  = D;
    this.v = v;
  }

  String toString() {
    return "Debut : " + this.depart + "  Vecteur directeur : "+ this.v;
  }
}

class Pylone {
  Vector position;

  Pylone(Vector p) {
    position = p;
  }
}

Vector bougerSurDroite(Droite D, float ratio) {
  return new Vector(D.depart.x + ratio*D.v.x, D.depart.y + ratio*D.v.y, D.depart.z + ratio*D.v.z);
}

Vector milieu(Vector A, Vector B) {
  return new Vector((A.x + B.x)/2, (A.y + B.y)/2, (A.z + B.z) /2);
}

Vector symetrie(Vector P) {
  return new Vector(-P.x, -P.y, P.z);
}

void drawLine(PShape struct, Vector A, Vector B) {
  struct.beginShape(LINES);
  point(struct, A);
  point(struct, B);
  struct.endShape();
}

float distance(Vector A, Vector B) {
  return sqrt( pow((B.x - A.x), 2) + pow((B.y - A.y), 2) +pow((B.z - A.z), 2));
}

Droite droiteFrom(Vector A, Vector B) {
  return new Droite(A, new Vector(B.x - A.x, B.y - A.y, B.z- A.z));
}

Vector symetrieX(Vector A) {
  return new Vector(A.y, A.x, A.z);
}

Vector symetrie2(Vector A) {
  return new Vector(-A.x, A.y, A.z);
}

Vector symetrie3(Vector A) {
  return new Vector(A.x, -A.y, A.z);
}

Vector diff(Vector A, Vector B) {
  return new Vector(B.x - A.x, B.y - A.y, B.z - A.z);
}

Vector ajouter(Vector A, Vector B) {
  return new Vector(A.x + B.x, A.y + B.y, A.z + B.z);
}

float calculeRatio(int numEtage) {
  return (1- pow(0.9, numEtage))*1.2;
}

void brasGauche(PShape struct, Droite gaucheDevant, Droite gaucheDerriere, Vector milieuDevant, Vector milieuArriere, int etage) {
  float ratio1 = calculeRatio(etage);
  float ratio2 = calculeRatio(etage + 1);

  Vector basDevant = bougerSurDroite(gaucheDevant, ratio1);
  Vector hautDevant = bougerSurDroite(gaucheDevant, ratio2);

  Vector basDerriere = bougerSurDroite(gaucheDerriere, ratio1);
  Vector hautDerierre = bougerSurDroite(gaucheDerriere, ratio2);

  Droite D1 = droiteFrom(milieuDevant, basDevant);
  Droite D3 = droiteFrom(milieuArriere, basDerriere);

  Vector extremiteDevant = bougerSurDroite(D1, -5);
  Vector extremiteBas = bougerSurDroite(D3, -5);
}

Vector swap(Vector V) {
  return new Vector(-V.y, -V.x, V.z);
}

void drawlignePylon(PShape struct, Vector A, Vector B) {
  struct.beginShape(LINES);
  point(struct, A);
  point(struct, B);
  point(struct, symetrieX(A));
  point(struct, symetrieX(B));
  point(struct, symetrie2(A));
  point(struct, symetrie2(B));
  point(struct, symetrie3(A));
  point(struct, symetrie3(B));
  struct.endShape();
}

Vector rotateAxeZ(Vector v, float theta) {
  //Calcule rotation d'un point autour de l'axe z d'un orientationX theta
  return new Vector(v.x*cos(theta) - v.y*sin(theta), v.x*sin(theta)+v.y*cos(theta), v.z);
}

void bras(PShape struct, Vector hautGauche, Vector hautDroite, Vector basGauche, Vector basDroite, Vector[] departFils) {
  float basL = distance(basGauche, basDroite);
  float hautL = distance(hautGauche, hautDroite);

  Vector G = basGauche;
  Vector D = basDroite;

  Droite bas = droiteFrom(milieu(basGauche, basDroite), basDroite);
  basGauche = bougerSurDroite(bas, -5);

  Vector fil = milieu(basGauche, swap(G));
  Vector filBas = new Vector(fil.x, fil.y, fil.z *0.92);

  for (int i = 0; i < 4; i++) {
    departFils[i] = rotateAxeZ(filBas, -i*HALF_PI);
  }

  struct.beginShape();
  struct.strokeWeight(7);
  drawlignePylon(struct, fil, filBas);
  struct.endShape();
  
  struct.beginShape();
  struct.strokeWeight(1);
  struct.endShape();

  basDroite = bougerSurDroite(bas, 5);

  drawlignePylon(struct, basGauche, basDroite);
  drawlignePylon(struct, basDroite, hautDroite);
  drawlignePylon(struct, swap(basGauche), swap(basDroite));
  drawlignePylon(struct, swap(basDroite), swap(hautDroite));

  Droite D1 = droiteFrom(basGauche, hautGauche);
  Droite D2 = droiteFrom(basGauche, G);
  Droite D3 =droiteFrom(basDroite, hautDroite);
  Droite D4 = droiteFrom(basDroite, D);

  Vector decalage = diff( basGauche, symetrie(basDroite));
  Vector lastHaut = bougerSurDroite(D1, 0);
  Vector lastBas = bougerSurDroite(D2, 0);

  for (int n = 0; n <= 5; n++) {
    float a1 = 0.2*n;
    float a2 = 0.2*(n+1);
    Vector BasDevant = bougerSurDroite(D2, a1);
    Vector HautDevant = bougerSurDroite(D1, a1);

    drawlignePylon(struct, HautDevant, BasDevant);
    drawlignePylon(struct, swap(HautDevant), swap(BasDevant));
    drawlignePylon(struct, HautDevant, swap(lastHaut));
    drawlignePylon(struct, swap(HautDevant), lastHaut);

    BasDevant = bougerSurDroite(D2, a2);
    lastBas = bougerSurDroite(D2, a1);

    drawlignePylon(struct, swap(lastBas), BasDevant );
    drawlignePylon(struct, swap(BasDevant), lastBas);

    drawlignePylon(struct, HautDevant, BasDevant);
    drawlignePylon(struct, swap(HautDevant), swap(BasDevant));
    //drawLine(struct, symetrieX(HautDevant), symetrieX(BasDevant));
    //drawlignePylon(struct, HautDevant, swap(HautDevant));

    lastHaut = HautDevant;
    lastBas = BasDevant;
  }
}

void point(PShape struct, Vector Point) {
  struct.vertex(Point.x, Point.y, Point.z);
}


Droite symetrieDroite(Droite D) {
  return new Droite(symetrie(D.depart), symetrie(D.v));
}

void etage(PShape structure, Vector Pgauche, Vector Pdroite, Droite Dgauche, Droite Ddroite, int numEtage, int nbEtages, Vector[] filsBas, Vector[] filsHaut ) {
  if (numEtage <= nbEtages) {

    // Calcul des coordonnées des points
    float ratio = (float)numEtage/ (float)nbEtages;
    ratio =calculeRatio(numEtage);
    Vector hautGauche = bougerSurDroite(Dgauche, ratio);
    Vector hautDroite = bougerSurDroite(Ddroite, ratio);

    // Traçage des lignes
    drawLine(structure, Pgauche, hautDroite);
    drawLine(structure, Pdroite, hautGauche);
    drawLine(structure, Pdroite, symetrie(hautGauche));
    drawLine(structure, hautDroite, symetrie(Pgauche));
    drawLine(structure, Pgauche, symetrie(hautDroite));
    drawLine(structure, hautGauche, symetrie(Pdroite));
    drawLine(structure, symetrie(Pgauche), symetrie(hautDroite));
    drawLine(structure, symetrie(Pdroite), symetrie(hautGauche));

    if (numEtage == 6) {
      bras(structure, bougerSurDroite(Dgauche, ratio*1.06), bougerSurDroite(Ddroite, ratio*1.06), Pgauche, Pdroite, filsBas);
    }

    if (numEtage == 11) {
      bras(structure, bougerSurDroite(Dgauche, ratio), bougerSurDroite(Ddroite, ratio), Pgauche, Pdroite, filsHaut);
    }

    etage(structure, bougerSurDroite(Dgauche, ratio), bougerSurDroite(Ddroite, ratio), Dgauche, Ddroite, numEtage + 1, nbEtages, filsBas, filsHaut);
  } else {
    return;
  }
}

PShape pyl(float hauteur, float base, float orientationX, Vector[] filsBas, Vector[] filsHaut) {
  float cote = sqrt(2) * base;
  PShape pylone = createShape();
  strokeWeight(1);
  noFill();
  PShape structure = createShape();
  Vector basGauche = new Vector(0, cote, 0);
  Vector basDroite = new Vector(cote, 0, 0);
  Vector sommet = new Vector(0, 0, hauteur);

  //// Forme de base
  structure.beginShape();
  structure.vertex(cote, 0, 0);
  structure.vertex(0, 0, hauteur);
  structure.vertex(0, cote, 0);
  structure.vertex(0, 0, hauteur);
  structure.vertex(-cote, 0, 0);
  structure.vertex(0, 0, hauteur);
  structure.vertex(0, -cote, 0);
  structure.vertex(0, 0, hauteur);
  structure.vertex(0, 0, hauteur);
  structure.vertex(cote, 0, 0);

  Droite Dgauche = droiteFrom(basGauche, sommet);
  Droite Ddroite = droiteFrom(basDroite, sommet);
  
  structure.endShape();
  etage(structure, basGauche, basDroite, droiteFrom(basGauche, sommet), droiteFrom(basDroite, sommet), 0, 15, filsBas, filsHaut);
  return structure;
  //return pylone;
}

float findZForXY(float x, float y) {
  float closestDist = Float.MAX_VALUE; 
  float closestZ = 0; 

  for (int i = 0; i < rocket.getChildCount(); i++) {
    PShape child = rocket.getChild(i);
   
    for (int j = 0; j < child.getVertexCount(); j++) {
      PVector vertex = child.getVertex(j);
      float dist = sqrt(pow(vertex.x - x, 2) + pow(vertex.y - y, 2));

      if (dist < closestDist) {
        closestDist = dist;
        closestZ = vertex.z; 
      }
    }
  }
  return closestZ;
}

Vector findSommet(float x, float y) {
  float closestDist = Float.MAX_VALUE;
  float closestZ = 0;
  float closestX = 0;
  float closestY = 0;
  PVector vertex = new PVector(0, 0, 0);
  
  for (int i = 0; i < rocket.getChildCount(); i++) {
    PShape child = rocket.getChild(i);

    for (int j = 0; j < child.getVertexCount(); j++) {
      vertex = child.getVertex(j);
      float dist = sqrt(pow(vertex.x - x, 2) + pow(vertex.y - y, 2));

      if (dist < closestDist) {
        closestDist = dist;
        closestZ = vertex.z;
        closestX = vertex.x;
        closestY = vertex.y;
      }
    }
  }

  return new Vector(closestX, closestY, closestZ);
}

Pylone[] creerPylones(PShape terrain, int nb) {
  Pylone[] pylones = new Pylone[nb];

  float debutX = -116;
  float debutY = -37;
  float finX = 70;
  float finY = 140;

  float dt_x = (finX - debutX) /nb;
  float dt_y = (finY - debutY) /nb;

  for (int i  = 0; i < nb; i++) {
    float x = debutX + i*dt_x;
    float y = debutY + i*dt_x;
    float z = findZForXY(x, y) + 190;
    pylones[i] = new Pylone(new Vector(x, y, z));
  }
  return pylones;
}
