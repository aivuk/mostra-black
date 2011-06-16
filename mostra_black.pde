import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;


import processing.opengl.*;
import codeanticode.glgraphics.*;

import com.csvreader.*; // lib para csv

//lib para load de sample....
import ddf.minim.*;

Minim minim;
AudioPlayer ambientSound;
AudioSample sequenceLSound;


//libs para comunicao TCP/IP com OSC
import oscP5.*;
import netP5.*;


World w;
float g_x = 0;
float g_y = -1.0;
color bck_color = color(100, 24, 22);
int E=2;

PBox2D box2d;
GLGraphicsOffScreen glg1;


CornerPinSurface surface, surface2;
Keystone ks;    


static final int OSCPORT = 7777;
//static final String REMOTEADDR = "192.168.2.23";
OscP5 receiveOSC;
NetAddress remoteAddress;


String outputFile = "FrasesLista.csv"; //csv




void setup() {


  receiveOSC = new OscP5(this, OSCPORT); //inicia escuta OSC na porta OSCPORT

  /* inicia libs do som */

  minim = new Minim(this); //inicia sáida de som
  ambientSound =minim.loadFile("data/ambient2.mp3", 2048);
  sequenceLSound =minim.loadSample("data/sequence.wav", 2048);
  ambientSound.play(0);

  // size(730*E, 335*E, OPENGL);
  // size(screen.width, screen.height, GLConstants.GLGRAPHICS);

  /*tamnho da janela, opengl via GLGraphics lib */
  size(2000, 768, GLConstants.GLGRAPHICS);
  glg1 = new GLGraphicsOffScreen(this, 2000, 768, true, 4);
  /*cria keystone para ajustes da posicao das texturas */

  ks = new Keystone(this);
  /*cria duas superficies */
  surface = ks.createCornerPinSurface(0, 0, width/2, height, 40, 0);
  surface2 = ks.createCornerPinSurface(width/2, 0, width/2, height, 40, width/2);

  hint(ENABLE_OPENGL_4X_SMOOTH );  
  hint(ENABLE_NATIVE_FONTS); //fontes nativas do JAVA, para as fontes serem renderizadas em tempo real
  smooth();
  initCSV(); // testa se o arquivo CSV existe , caso contrario cria ele
  //Modo full screen
  //Inicializa box2d world
  //se o arquivo do keystone exister já carrega a aultima configuracao salva!

  ks.load();


  // enter fullscreen mode
  // Inicializa box2d world
  glg1.beginDraw();
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
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

  surface.render(g1);
  surface2.render(g1);
}
long time;


void mouseDragged() {
  println(mouseX + " " + mouseY);
  box2d.setGravity(0, random(100, 200));
  time = millis();
}
void mouseReleased() {
  if (millis() - time>300) {
    time = millis();
    box2d.setGravity(0, -100);
  }
  else {
    box2d.setGravity(0, -10);
  }
}

void mouseClicked() {
  PFont f = createFont("Helvetica", 32);
  textAlign(CENTER);

  // Set the font and its size (in units of pixels)
  textFont(f, 32);
  String s = "x: "+mouseX + "y: " + mouseY;
  text(s, mouseX, mouseY, textWidth(s), 32);
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
  case 'r':
    ks.resetMesh();

    break;
  }
}

//evento vindo do SMS
void oscEvent(OscMessage theOscMessage) {
  // print the message for now
  String foo = theOscMessage.addrPattern();
  if (foo.equals("/android/twitter")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase();
    createSentence(frase);
    println("Server twitter received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/sms")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase();
    createSentence(frase);
    println("Server sms received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/hp")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase();
    createSentence(frase);
    println("Server hp received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/debug")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase();
    createSentence(frase);
    println("Server received: "+theOscMessage.get(0).stringValue());
  }
}

void createSentence(String frase) {
  writeFrase2CSV(frase);
  w.sc.sentencesToAdd.push(new Sentence(frase, new Vec2(width/2, height/2 + 200), new Vec2(0, 0), 10, true));
}

void stop()
{
  // always close Minim audio classes when you are done with them
  ambientSound.close();
  sequenceLSound.close();
  // always stop Minim before exiting.
  minim.stop();

  super.stop();
}

