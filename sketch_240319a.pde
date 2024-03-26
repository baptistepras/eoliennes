float posX = -180;
float posY = 0;
float posZ = -250;
float tmp = 0;

PShape rocket;
PImage textureimg;

float angle;

float dAngle;
float dx;
float dz;


float avance_x;
float avance_z;



void keyPressed() {
  if (keyCode == UP) {
    //posZ += 10; // Augmentez la position Z lors de l'appui sur la touche UP
    dx = 1;
    
  } else if (keyCode == DOWN) {
    //posZ -= 10; // Diminuez la position Z lors de l'appui sur la touche DOWN
    dx = -1;
  }else{
    dx = 0;}
  
  if (keyCode == LEFT) {
    //posX += 10; // Augmentez la position X lors de l'appui sur la touche LEFT
    dAngle = PI/200;
  } else if (keyCode == RIGHT) {
    //posX -= 10; // Diminuez la position X lors de l'appui sur la touche RIGHT  
    dAngle = -PI/200;
  }else{
     dAngle = 0; 
  }
  
  if (keyCode == SHIFT) {
    //posY += 10; // Augmentez la position Y lors de l'appui sur la touche UP
    dz = avance_z;
  } else if (keyCode == CONTROL) {
    dz = -1*avance_z; // Diminuez la position Y lors de l'appui sur la touche DOWN
  }else{
    dz = 0;
    
  }
  
  if (keyCode == TAB){
     tmp++; 
    
  } 
  if (keyCode == ENTER){
     tmp--; 
    
  }
}

void keyReleased(){
   dx = 0;
   dAngle = 0;
   dz = 0;
  
}


public void setup() {
  size(1000, 800, P3D);
  avance_x = 2;
  avance_z = 2;
  
  
  textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  //pushMatrix();
}

public void draw() {
  fill(255, 0, 0);
  pushMatrix();
  background(255);
  textureMode(NORMAL);
  //println(angle);
  angle += dAngle;
  if (dx != 0){
    posX += cos(angle)* dx * avance_x;
  
  
      posY += sin(angle)* dx * avance_x;
  }

  posZ += dz;



  lights();
  camera(posX, posY, posZ, posX+(10*cos(angle)), posY+(10*sin(angle)), posZ+tmp, 0, 0, 1);
  print(posX, posY, posZ, "\n");
  perspective();
  
  texture(textureimg);
  shape(rocket);

  popMatrix();
}
