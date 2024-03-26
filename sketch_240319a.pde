float posX = -180;
float posY = 0;
float posZ = -250;

PShape rocket;
PImage textureimg;

void keyPressed() {
  if (keyCode == UP) {
    posZ += 10; // Augmentez la position Z lors de l'appui sur la touche UP
  } else if (keyCode == DOWN) {
    posZ -= 10; // Diminuez la position Z lors de l'appui sur la touche DOWN
  }
  
  if (keyCode == LEFT) {
    posX += 10; // Augmentez la position X lors de l'appui sur la touche LEFT
  } else if (keyCode == RIGHT) {
    posX -= 10; // Diminuez la position X lors de l'appui sur la touche RIGHT
  }
  
  if (keyCode == TAB) {
    posY += 10; // Augmentez la position Y lors de l'appui sur la touche UP
  } else if (keyCode == ENTER) {
    posY -= 10; // Diminuez la position Y lors de l'appui sur la touche DOWN
  }
}

public void setup() {
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
  camera(posX, posY, posZ, posX+10, posY, posZ, 0, 0, 1);
  print(posX, posY, posZ, "\n");
  //perspective();
  
  texture(textureimg);
  shape(rocket);

  popMatrix();
}
