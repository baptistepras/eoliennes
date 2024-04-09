float posX = -180;
float posY = 0;
float posZ = -150;
float tmp = 0;
float dtmp = 0;
import processing.core.*; 
PShape rocket;
PImage textureimg;
PImage ciel;

float angle;

float dAngle;
float dx;
float dz;


float avance_x;
float avance_z;
boolean[] keys = new boolean[256]; 
float limitZ = -194;

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
  println(posZ);
  if (keys[SHIFT]) {
    //posY += 10; // Augmentez la position Y lors de l'appui sur la touche UP
    dz = avance_z;
  } else if (keys[CONTROL] && posZ > limitZ) {
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


public void setup() {
  PVector A1 = new PVector(1,1,1);
  PVector v1 = new PVector(1, 4/3, 2);
  
  PVector A2 = new PVector(2,0,3);
  PVector v2 = new PVector(2, 5,4 );
  
  Droite D1 = new Droite(A1, v1);
  Droite D2 = new Droite(A2, v2);
  
  PVector I = intersect(D1, D2);
  println("");
  println(I.x);
  println(I.y);
  println(I.z);
  
  
  
  
  
  
  size(1000, 648, P3D);
  avance_x = 2;
  avance_z = 2;

  shader = loadShader("myFragmentShaderv2.glsl", 
               "myVertexShaderv2.glsl"); //2//

  ciel = loadImage("ciel.jpg");
  //textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  //pushMatrix();
}

public void draw() {
  fill(255, 0, 0);
  //shader(shader);
  pushMatrix();
  
  background(ciel);
  textureMode(NORMAL);
  //println(angle);
  angle += dAngle;
  if (dx != 0) {
    posX += cos(angle)* dx * avance_x;


    posY += sin(angle)* dx * avance_x;
  }

  posZ += dz;
  if (posZ < limitZ) {
    posZ = limitZ;
  }
  tmp += dtmp;



  lights();
  camera(posX, posY, posZ, posX+(1*cos(angle)), posY+(1*sin(angle)), posZ+tmp, 0, 0, -1);
  //print(posX, posY, posZ, "\n");
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
      0.001, cameraZ*10.0);

  texture(textureimg);
  shape(rocket);

  popMatrix();
}
