import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;


import processing.opengl.*;
import codeanticode.glgraphics.*;

import com.csvreader.*; // lib para csv


World w;
float g_x = 0;
float g_y = -1.0;
color bck_color = color(100, 24, 44);
int E=2;
PBox2D box2d;
GLGraphicsOffScreen glg1;


CornerPinSurface surface, surface2;
Keystone ks;    


String outputFile = "FrasesLista.csv"; //csv



void setup() {
  // size(730*E, 335*E, OPENGL);
  // size(screen.width, screen.height, GLConstants.GLGRAPHICS);
  size(1360, 768, GLConstants.GLGRAPHICS);
  glg1 = new GLGraphicsOffScreen(this, 1360, 768, true, 4);
  ks = new Keystone(this);

  surface = ks.createCornerPinSurface(0, 0, width/2, height, 40);
  surface2 = ks.createCornerPinSurface(width/2, 0, width/2, height, 40);


  hint( ENABLE_OPENGL_4X_SMOOTH );  
  hint(ENABLE_NATIVE_FONTS); //fontes nativas do JAVA, para as fontes serem renderizadas em tempo real
  smooth();
  initCSV(); // testa se o arquivo CSV existe , caso contrario cria ele
  //Modo full screen
  ///fs = new FullScreen(this); 
  //fs.enter();
  //Inicializa box2d world

  // enter fullscreen mode
  // Inicializa box2d world
  glg1.beginDraw();
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  //cria o mundo e as condicoes de contorno
  w = new World(); 
  w.create();
  glg1.endDraw();
}

void draw() {
  glg1.beginDraw();

  glg1.background(bck_color);
  w.update();
  w.display();


  //image(glg1.getTexture(), 0, 0, width/2, height); 


  glg1.endDraw();   

  background(0);


  GLTexture g1 = glg1.getTexture();


  surface.render(g1, 0);

  surface2.render(g1, width/2  );
}

void mouseClicked() {

  println(mouseX + " " + mouseY);
  box2d.setGravity(0, random(100, 200));
}


void keyPressed() {

  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // & moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}



