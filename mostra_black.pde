import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;


import processing.opengl.*;

import fullscreen.*;  // biblioteca para fullscreen 
import com.csvreader.*; // lib para csv


World w;
float g_x = 0;
float g_y = -1.0;
color bck_color = color(100, 24, 44);
int E=2;
PBox2D box2d;

String outputFile = "FrasesLista.csv"; //csv

FullScreen fs;   //instancia para api Fullsceen


void setup() {
  size(730*E, 335*E, OPENGL);
  hint(ENABLE_NATIVE_FONTS); //fontes nativas do JAVA, para as fontes serem renderizadas em tempo real
  smooth();
  initCSV(); // testa se o arquivo CSV existe , caso contrario cria ele
  loadBadWords();
  //Modo full screen
  //fs = new FullScreen(this); 
  ///fs.enter(); 
  //Inicializa box2d world

  // Inicializa box2d world
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -1);

  //cria o mundo e as condicoes de contorno
  w = new World(); 
  w.create();
}

void draw() {
  background(bck_color);
  w.update();
  w.display();
}

void mouseClicked(){
  
 println(mouseX + " " + mouseY); 
  
}

