
class Vector{
   float x;
   float y;
   float z;
   public Vector(float a, float b, float c){
      x = roundToTwoDecimalPlaces(a);
      y  = roundToTwoDecimalPlaces(b);
      z = roundToTwoDecimalPlaces(c);
   }
   
   public String toString(){
     String ch  = "(" + this.x + ","+this.y+","+this.z+")";
     return ch;
     
     
   }
   
   
}


class Droite{
   Vector depart;
   Vector v;
  
   public Droite(Vector D, Vector v){
      this.depart  = D;
      this.v = v;
   }
    public String toString(){
       return "Debut : " + this.depart + "  Vecteur directeur : "+ this.v; 
      
      
    }
  
}

Vector bougerSurDroite(Droite D, float ratio){
    
  return new Vector(D.depart.x + ratio*D.v.x,D.depart.y + ratio*D.v.y,D.depart.z + ratio*D.v.z);
  
}







Vector intersect(Droite D1, Droite D2){
   // Calcule le point d'intersection de deux droites dans l'espace si il existe
   
    // Résolution d'un système d'équations
    
    //On donne un meilleur nom aux variables
    float a1, b1, c1, x1, y1, z1,x2, y2, z2, a2, b2, c2;
    //Le point de depart de la première droite et deuxième droite
    a1 = D1.depart.x;  a2 = D2.depart.x;
    b1 = D1.depart.y;  b2 = D2.depart.y;
    c1 = D1.depart.z;  c2 = D2.depart.z;
 
    //Les vecteurs directeurs des droites
    x1 = D1.v.x;  x2 = D2.v.x;
    y1 = D1.v.y;  y2 = D2.v.y;
    z1 = D1.v.z;  z2 = D2.v.z;
    
    
     float d = x2*y1 - y2*x1;
     
   if (d == 0){
   
      return null; 
     
   }else{
     println(d);
     float t1 = (1/d)*(-y2*(a2-a1)+x2*(b2-b1));
     float t2 = (1/d)*(-y1*(a2-a1)+x1*(b2-b1));
      //println(t1);
      //println(t2);
     if (z1*t1-z2*t2 <= c2 - c1 + 1e-6){
        return new Vector(a1+t1*x1, b1 + t1*y1, c1+t1*z1); 
     }else{
       return null;}
   }
 
}


void point(PShape struct, Vector Point){
   struct.vertex(Point.x, Point.y, Point.z); 
  
}


Droite droiteFrom(Vector A, Vector B){
   return new Droite(A, new Vector(B.x - A.x, B.y - A.y, B.z- A.z)); 
  
  
  
}

float roundToTwoDecimalPlaces(float number) {
   // return round(number * 100) / 100;
    return number;
}




Vector symetrie(Vector P){
   return new Vector(-P.x, -P.y, P.z); 
  
}

void drawLine(PShape struct, Vector A, Vector B){
   struct.beginShape(LINES);
   point(struct, A);
   point(struct, B);
   struct.endShape();
  
  
}


void etage(PShape structure, Vector Pgauche, Vector Pdroite, Droite Dgauche, Droite Ddroite, int numEtage, int nbEtages ){
 
  if (numEtage <= nbEtages){
    //println(Pgauche, Pdroite);
    
    
    
  //On calcule les coordonées des points 
    float ratio = (float)numEtage/ (float)nbEtages;
    ratio = (1- pow(0.9, numEtage))*1.4;
    Vector hautGauche = bougerSurDroite(Dgauche, ratio);
    Vector hautDroite = bougerSurDroite(Ddroite, ratio);
   // et on trace les lignes
   drawLine(structure, Pgauche, hautDroite);
   drawLine(structure, Pdroite, hautGauche);
   
   drawLine(structure, Pdroite, symetrie(hautGauche));
   drawLine(structure, hautDroite, symetrie(Pgauche));
   
   drawLine(structure, Pgauche, symetrie(hautDroite));
   drawLine(structure, hautGauche, symetrie(Pdroite));
   
    drawLine(structure, symetrie(Pgauche), symetrie(hautDroite));
   drawLine(structure, symetrie(Pdroite), symetrie(hautGauche));
   
   
   
    etage(structure, hautGauche, hautDroite, Dgauche, Ddroite, numEtage + 1, nbEtages);
   
  }else{
     return; 
  }
  
  
}
PShape pyl(float hauteur, float base, float angle){
   float cote = sqrt(2) * base;
   PShape pylone = createShape();
   strokeWeight(1);
   noFill();
   PShape structure = createShape();
   Vector basGauche = new Vector(0, cote, 0);
   Vector basDroite = new Vector(cote, 0, 0);
   Vector sommet = new Vector(0, 0, hauteur);
   
   ////Forme de base
   structure.beginShape();
    structure.vertex(cote, 0, 0);
     structure.vertex(0, 0, hauteur);
    structure.vertex(0, cote, 0);
   structure.vertex(0, 0, hauteur);
    
    structure.vertex(-cote, 0, 0);
    structure.vertex(0, 0, hauteur);
    
    structure.vertex(0, -cote, 0);
    structure.vertex(0, 0, hauteur);
   structure.vertex(0,hauteur, 0);
    structure.vertex(cote, 0, 0);
   
   
   Droite Dgauche = droiteFrom(basGauche, sommet); 
    Droite Ddroite = droiteFrom(basDroite, sommet); 
    println(Dgauche);
    println(Ddroite);
   
   structure.endShape();
    etage(structure, basGauche, basDroite, droiteFrom(basGauche, sommet),  droiteFrom(basDroite, sommet), 0, 11);
     
    
     return structure;
    //return pylone;
}
