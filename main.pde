float posX = -10;
float posY = 0;
float posZ = 0;
float tmp = 0;
float dtmp = 0;

PShape rocket;
PImage textureimg;
PImage ciel;

float angle=0;

float dAngle;
float dx;
float dz;


float avance_x;
float avance_z;
boolean[] keys = new boolean[256]; 

PShader shader;
Vector[] filsBas;
Vector[] filsHaut;


void keyPressed() {
  keys[keyCode] = true;
  if (keys[UP]) {
    //posZ += 10; // Augmentez la position Z lors de l'appui sur la touche UP
    dx = 0.2;
  } else if (keys[DOWN]) {
    //posZ -= 10; // Diminuez la position Z lors de l'appui sur la touche DOWN
    dx = -0.2;
  } else {
    dx = 0;
  }

  if (keys[LEFT]) {
    //posX += 10; // Augmentez la position X lors de l'appui sur la touche LEFT
    dAngle = -PI/200;
  } else if (keys[RIGHT]) {
    //posX -= 10; // Diminuez la position X lors de l'appui sur la touche RIGHT
    dAngle = PI/200;
  } else {
    dAngle = 0;
  }

  if (keys[SHIFT]) {
    //posY += 10; // Augmentez la position Y lors de l'appui sur la touche UP
    dz = avance_z;
  } else if (keys[CONTROL]) {
    dz = -1*avance_z; // Diminuez la position Y lors de l'appui sur la touche DOWN
  } else {
    dz = 0;
  }

  if( keys[TAB]) {
    dtmp = 0.01;
  }
  if (keys[ENTER]) {
    dtmp= -0.01;
  }
}



Pylone[] pylones;

void keyReleased() {
  keys[keyCode] = false;
  dx = 0;
  dAngle = 0;
  dz = 0;
  dtmp = 0;
}
PShape  p;
int C = 20;
PVector centre = new PVector(0, 0, 0);;
PShape pylModele;

PShape pal;

Eolienne[] eoliennes;

public void setup() {
  size(1000, 648, P3D);
  avance_x = 2;
  avance_z = 2;
shader = loadShader( "fragmentShaderProjet.glsl","vertexShaderProjet.glsl");
  ciel = loadImage("ciel.jpg");
  textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  //rocket.rotateY(PI);
  rocket.translate(0, 0, 190);
  println(rocket.getVertexCount());
  p = modeleEolienne(4);
  pylones = creerPylones(rocket, 15);
 
  centre.z = findZForXY(0,0)+ 190;
  
  
  filsBas  = new Vector[4];
  filsHaut = new Vector[4];
  
  
  pal = pale(4);
  eoliennes = new Eolienne[8];
  
  
  for (int i = 0; i <8; i++){
    eoliennes[i] = new Eolienne(new Vector(30, 30+15*i, findZForXY(30, 30+20*i)+190) , 4);
  }
  //eoliennes[0] = new Eolienne(new Vector(30, 30, findZForXY(30, 30)+190) , 4);
  
  //eoliennes[1] = new Eolienne(new Vector(100, 30, findZForXY(100, 30)+190), 4 );
  pylModele = pyl(8, 0.8, 1.0, filsBas, filsHaut);
   println(filsBas);
  println(filsHaut);
  //pushMatrix();
 
   
  
}

int filCorrespond(int i){
   if (i == 0 || i == 2){
      return i; 
   }else{
      return 3;
  
}}



void afficheFils(){
  strokeWeight(1);
  stroke(0, 0, 0);
  color(0,0,0);
  for (int i = 1; i < 14; i++){
     pushMatrix();
     translate(pylones[i].position.x , pylones[i].position.y, pylones[i].position.z);
     shape(pylModele);
     noFill();
     //On fait les fils hauts
     
     for (int j = 0; j < 3 ;j++){
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
      for (int j = 0; j < 3 ;j++){
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

         
  
  



void afficheEol(Eolienne E){
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


void affEoliennes(){
   for (Eolienne E: eoliennes){
      afficheEol(E); 
     
   }
  
}

public void repere(){
  
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



public void draw() {
  fill(255, 0, 0);
 
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
             1, 1000);

    
  background(ciel);
  textureMode(NORMAL);
   camera(posX, posY, posZ, posX+(1*cos(angle)), posY+(1*sin(angle)), posZ+tmp, 0, 0, -1);
   repere();
   
   pushMatrix();
   translate(pylones[0].position.x , pylones[0].position.y, pylones[0].position.z);
     shape(pylModele);
     popMatrix();
     
   afficheFils();
   affEoliennes();
//box(5);
    shape(p);
    

   //shape(p);
  pushMatrix();
  
  //shader(shader);
  
  //println(angle);
  angle += dAngle;
  if (dx != 0) {
    posX += cos(angle)* dx * avance_x;


    posY += sin(angle)* dx * avance_x;
  }

  posZ += dz;
  tmp += dtmp;



  lights();
 
  //print(posX, posY, posZ, angle,"\n");
  

  //texture(textureimg);
  shape(rocket);
  strokeWeight(4);
  //translate(0,0,0);
  //box(20);
   //shape(p);
  
  popMatrix();
}
