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
void keyPressed() {
  keys[keyCode] = true;
  if (keys[UP]) {
    //posZ += 10; // Augmentez la position Z lors de l'appui sur la touche UP
    dx = 1;
  } else if (keys[DOWN]) {
    //posZ -= 10; // Diminuez la position Z lors de l'appui sur la touche DOWN
    dx = -1;
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





void keyReleased() {
  keys[keyCode] = false;
  dx = 0;
  dAngle = 0;
  dz = 0;
  dtmp = 0;
}
PShape  p;
int C = 20;


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
  p = pyl(80, 8, 1.0);
  //pushMatrix();
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
   shape(p);
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
  

  texture(textureimg);
  shape(rocket);
  strokeWeight(4);
  //translate(0,0,0);
  //box(20);
   //shape(p);
  
  popMatrix();
}
