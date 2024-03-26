/**
 * Load and Display an OBJ Shape. 
 * 
 * The loadShape() command is used to read simple SVG (Scalable Vector Graphics)
 * files and OBJ (Object) files into a Processing sketch. This example loads an
 * OBJ file of a rocket and displays it to the screen. 
 */
float posX;
float posY;
float posZ;

PShape rocket;
PImage textureimg;
float ry;


void keyPressed(){
  
  if (keyCode == UP){
      posZ -= 5;
  }else{
     if (keyCode == DOWN){
        posY += 5; 
     }else{
        if (keyCode == LEFT){
           posZ += 5; 
          
        }
     }
    
  }
    
    
  
  
  
}
  
  
  
public void setup() {
  posX = 0;
  posY = 0;
  posZ = 0;
  size(1000, 800, P3D);
  textureimg = loadImage("StAuban_texture.jpg");
  rocket = loadShape("hypersimple.obj");
  //pushMatrix();
}

public void draw() {
  fill(255, 0, 0);
  pushMatrix();
  background(255);
  textureMode(NORMAL);
  
  
  
  lights();
 
  
  camera(60,-10,-190, 1000,10000,-1000,0,0,1);
  //perspective();
  translate(10, 10, 10);
  box(20);
  
  
  
  //rotateX(PI);
  //rotateY(ry);
  texture(textureimg);
  shape(rocket);
  
  ry += 0.02;
  popMatrix();
}
