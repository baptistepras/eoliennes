
class Vector{
   double x;
   double y;
   double z;
  
}

class Droite{
   PVector depart;
   PVector v;
  
   public Droite(PVector D, PVector v){
      this.depart  = D;
      this.v = v;
   }
  
}

PVector intersect(Droite D1, Droite D2){
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
        return new PVector(a1+t1*x1, b1 + t1*y1, c1+t1*z1); 
     }else{
       return null;}
   }
 
  
}
