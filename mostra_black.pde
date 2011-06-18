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
color bck_color = color(255, 4, 3);
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

int resizeMode = 0;

void writeObjectCoords(World w) {

    //stream com ecoding UTF-8
    try {
    OutputStreamWriter out = new OutputStreamWriter(new FileOutputStream(dataPath("") + "objcoords.csv", false)); 
    CsvWriter csvOutput = new CsvWriter(out, ',');

    csvOutput.write("x");
    csvOutput.write("y");
    csvOutput.write("w");
    csvOutput.write("h");
    csvOutput.endRecord();
    
    for (Boundary b:w.boundaries) {
      csvOutput.write(str(b.x));
      csvOutput.write(str(b.y));
      csvOutput.write(str(b.w));
      csvOutput.write(str(b.h));      
      csvOutput.endRecord();
    }
    csvOutput.close();
    }
      catch (IOException e) {
    e.printStackTrace();
  }
}


void loadObjectsCoords(World w) {

      try {
      CsvReader coordsFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + "objcoords.csv")));
      coordsFile.readHeaders();
      
      w.boundaries = new ArrayList<Boundary>();
      int i = 0;
      while (coordsFile.readRecord()) {
        
        String bx = coordsFile.get("x");
        String by = coordsFile.get("y");
        String bw = coordsFile.get("w");
        String bh = coordsFile.get("h");
        if (i == 0 || i == 2) {
          w.boundaries.add(new Boundary(float(bx), float(by), float(bw), float(bh))); 
        } else { 
          w.boundaries.add(new Boundary(float(bx), float(by), float(bw), float(bh))); 
        }
        ++i;
      }
      coordsFile.close();
      }
        catch (IOException e) {
    e.printStackTrace();
  }
}

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
  size(2048, 768, GLConstants.GLGRAPHICS);
  glg1 = new GLGraphicsOffScreen(this, 2048, 768, true, 4);
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
  background(0);
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
  Boundary b;
  if (key == CODED) {
    switch(keyCode) {
    case LEFT:
      switch (resizeMode) {
      case 1:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x - 1, b.y, b.w, b.h));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w - 1, b.h));
        break;
       case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x - 1, b.y, b.w, b.h));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w - 1, b.h));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x - 1, b.y, b.w, b.h));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w - 1, b.h));
        break;
      }
      break;
    case RIGHT:
      switch (resizeMode) {
        case 1:
          b = w.boundaries.get(0);
          w.boundaries.remove(0);
          box2d.destroyBody(b.b);  
          w.boundaries.add(0, new Boundary(b.x + 1, b.y, b.w, b.h));
          break;
        case 2:
          b = w.boundaries.get(0);
          w.boundaries.remove(0);
          box2d.destroyBody(b.b);
          w.boundaries.add(0, new Boundary(b.x, b.y, b.w + 1, b.h));
          break;
        case 3:
          b = w.boundaries.get(1);
          w.boundaries.remove(1);
          box2d.destroyBody(b.b);  
          w.boundaries.add(1, new Boundary(b.x + 1, b.y, b.w, b.h));
          break;
        case 4:
          b = w.boundaries.get(1);
          w.boundaries.remove(1);
          box2d.destroyBody(b.b);
          w.boundaries.add(1, new Boundary(b.x, b.y, b.w + 1, b.h));
          break;
        case 5:
          b = w.boundaries.get(2);
          w.boundaries.remove(2);
          box2d.destroyBody(b.b);  
          w.boundaries.add(2, new Boundary(b.x + 1, b.y, b.w, b.h));
          break;
        case 6:
          b = w.boundaries.get(2);
          w.boundaries.remove(2);
          box2d.destroyBody(b.b);
          w.boundaries.add(2, new Boundary(b.x, b.y, b.w + 1, b.h));
          break;
      }
      break;
    case UP:
      switch (resizeMode) {
        case 1:
          b = w.boundaries.get(0);
          w.boundaries.remove(0);
          box2d.destroyBody(b.b);  
          w.boundaries.add(0, new Boundary(b.x, b.y + 1, b.w, b.h));
          break;
        case 2:
          b = w.boundaries.get(0);
          w.boundaries.remove(0);
          box2d.destroyBody(b.b);
          w.boundaries.add(0, new Boundary(b.x, b.y, b.w, b.h + 1));
          break;
        case 3:
          b = w.boundaries.get(1);
          w.boundaries.remove(1);
          box2d.destroyBody(b.b);  
          w.boundaries.add(1, new Boundary(b.x, b.y + 1, b.w, b.h));
          break;
        case 4:
          b = w.boundaries.get(1);
          w.boundaries.remove(1);
          box2d.destroyBody(b.b);
          w.boundaries.add(1, new Boundary(b.x, b.y, b.w, b.h + 1));
          break;
        case 5:
          b = w.boundaries.get(2);
          w.boundaries.remove(2);
          box2d.destroyBody(b.b);  
          w.boundaries.add(2, new Boundary(b.x, b.y + 1, b.w, b.h));
          break;
        case 6:
          b = w.boundaries.get(2);
          w.boundaries.remove(2);
          box2d.destroyBody(b.b);
          w.boundaries.add(2, new Boundary(b.x, b.y, b.w, b.h + 1));
          break;
      }
      break;
   case DOWN:
      switch (resizeMode) {
      case 1:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);  
        w.boundaries.add(0, new Boundary(b.x, b.y - 1, b.w, b.h));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w, b.h - 1));
        break;
      case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);  
        w.boundaries.add(1, new Boundary(b.x, b.y - 1, b.w, b.h));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w, b.h - 1));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);  
        w.boundaries.add(2, new Boundary(b.x, b.y - 1, b.w, b.h));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w, b.h - 1));
        break;
      }
      break;
  } 
  }
  else {

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

    case 'Q':
      if (resizeMode != 1 && resizeMode != 2) {
        resizeMode = 1;
      } 
      else if (resizeMode == 1) {
        resizeMode = 2;
      } 
      else {
        resizeMode = 1;
      }
      break;
    case 'W':
      if (resizeMode != 3 && resizeMode != 4) {
        resizeMode = 3;
      } 
      else if (resizeMode == 3) {
        resizeMode = 4;
      } 
      else {
        resizeMode = 3;
      }
      break;
    case 'E':
      if (resizeMode != 5 && resizeMode != 6) {
        resizeMode = 5;
      } 
      else if (resizeMode == 5) {
        resizeMode = 6;
      } 
      else {
        resizeMode = 5;
      }
      break;
      case 'Z':
       writeObjectCoords(w);
      break;
    }
  }
}



//evento vindo do SMS
void oscEvent(OscMessage theOscMessage) {
  // print the message for now
  Locale ptLocale = new Locale("pt", "BR");
  String foo = theOscMessage.addrPattern();
  if (foo.equals("/android/twitter")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase);
    println("Server twitter received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/sms")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase);
    println("Server sms received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/hp")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase);
    println("Server hp received: "+theOscMessage.get(0).stringValue());
  }
  else if (foo.equals("/android/debug")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
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

