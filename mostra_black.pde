import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;
import com.csvreader.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;
 
Minim minim;
AudioPlayer ambientSound;
AudioSample sequenceLSound;
World w;
float g_x = 0;
float g_y = -1.0;
color bck_color = color(255, 4, 3);
int E=2;
long lstartTime = 0;
boolean blueLine = false;
PBox2D box2d;
GLGraphicsOffScreen glg1;
GLTexture porta1, porta2, bg;
CornerPinSurface surface, surface2;
Keystone ks;    
static final int OSCPORT = 7777;
//static final String REMOTEADDR = "192.168.2.23";
OscP5 receiveOSC;
NetAddress remoteAddress;
boolean messageEvent;
String outputFile = "FrasesLista.csv"; //csv
int resizeMode = 0;
long bgTime;
float fade;

void writeObjectCoords(World w) {

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
    } catch (IOException e) {
        e.printStackTrace();
    }
}


void loadObjectsCoords(World w) {

  try {
    CsvReader coordsFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + "objcoords.csv")));
    coordsFile.readHeaders();
    w.boundaries = new ArrayList<Boundary>();
    int i = 0;

    while (coordsFile.readRecord ()) {

      String bx = coordsFile.get("x");
      String by = coordsFile.get("y");
      String bw = coordsFile.get("w");
      String bh = coordsFile.get("h");

      if (i == 0 || i == 2) {
        if (i==0) { 
          w.boundaries.add(new Boundary(float(bx), float(by), float(bw), float(bh), 0));
        } else {
          w.boundaries.add(new Boundary(float(bx), float(by), float(bw), float(bh), 2));
        }
      } else { 
        w.boundaries.add(new Boundary(float(bx), float(by), float(bw), float(bh), 1));
      }
      ++i;
    }
    coordsFile.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void setup() {

  receiveOSC = new OscP5(this, OSCPORT);
  minim = new Minim(this);
  ambientSound = minim.loadFile("data/ambient2.mp3", 2048);
  sequenceLSound = minim.loadSample("data/sequence.wav", 2048);
  ambientSound.play();
  ambientSound.loop();
  messageEvent = false;

  // size(730*E, 335*E, OPENGL);
  // size(screen.width, screen.height, GLConstants.GLGRAPHICS);

  /*tamanho da janela, opengl via GLGraphics lib */
  size(2048, 768, GLConstants.GLGRAPHICS);
  glg1 = new GLGraphicsOffScreen(this, 2048, 768, true, 4);

  porta1 = new GLTexture(this, "Still/porta1-shadow.png");
  porta2 = new GLTexture(this, "Still/porta2-shadow.png");
  bg = new GLTexture(this, "Still/bg.jpg");

  /*cria keystone para ajustes da posicao das texturas */
  ks = new Keystone(this);
  
  /*cria duas superficies */
  surface = ks.createCornerPinSurface(0, 0, width/2, height, 40, 0);
  surface2 = ks.createCornerPinSurface(width/2, 0, width/2, height, 40, width/2);

  hint(ENABLE_OPENGL_4X_SMOOTH);  
  //fontes nativas do JAVA, para as fontes serem renderizadas em tempo real 
  hint(ENABLE_NATIVE_FONTS); 
  smooth();
  initCSV();
  ks.load();
  glg1.beginDraw();
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  w = new World(); 
  w.create();
  glg1.endDraw();
  bgTime = millis();
  fade = 0;
}

void draw() {

  GLTexture g1 = glg1.getTexture();

  background(0);
  glg1.beginDraw();
  glg1.image(bg, 0, 0);
  w.update();
  w.display();
  //image(glg1.getTexture(), 0, 0, width/2, height); 
  glg1.endDraw();   
  background(0);
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
  } else {
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
        w.boundaries.add(0, new Boundary(b.x - 1, b.y, b.w, b.h, 0));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w - 1, b.h, 0));
        break;
      case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x - 1, b.y, b.w, b.h, 1));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w - 1, b.h, 1));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x - 1, b.y, b.w, b.h, 2));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w - 1, b.h, 2));
        break;
      }
      break;
    case RIGHT:
      switch (resizeMode) {
      case 1:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);  
        w.boundaries.add(0, new Boundary(b.x + 1, b.y, b.w, b.h, 0));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w + 1, b.h, 0));
        break;
      case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);  
        w.boundaries.add(1, new Boundary(b.x + 1, b.y, b.w, b.h, 1));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w + 1, b.h, 1));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);  
        w.boundaries.add(2, new Boundary(b.x + 1, b.y, b.w, b.h, 2));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w + 1, b.h, 2));
        break;
      }
      break;

    case UP:
      switch (resizeMode) {
      case 1:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);  
        w.boundaries.add(0, new Boundary(b.x, b.y + 1, b.w, b.h, 0));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w, b.h + 1, 0));
        break;
      case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);  
        w.boundaries.add(1, new Boundary(b.x, b.y + 1, b.w, b.h, 1));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w, b.h + 1, 1));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);  
        w.boundaries.add(2, new Boundary(b.x, b.y + 1, b.w, b.h, 2));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w, b.h + 1, 2));
        break;
      }
      break;

    case DOWN:
      switch (resizeMode) {
      case 1:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);  
        w.boundaries.add(0, new Boundary(b.x, b.y - 1, b.w, b.h, 0));
        break;
      case 2:
        b = w.boundaries.get(0);
        w.boundaries.remove(0);
        box2d.destroyBody(b.b);
        w.boundaries.add(0, new Boundary(b.x, b.y, b.w, b.h - 1, 0));
        break;
      case 3:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);  
        w.boundaries.add(1, new Boundary(b.x, b.y - 1, b.w, b.h, 1));
        break;
      case 4:
        b = w.boundaries.get(1);
        w.boundaries.remove(1);
        box2d.destroyBody(b.b);
        w.boundaries.add(1, new Boundary(b.x, b.y, b.w, b.h - 1, 1));
        break;
      case 5:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);  
        w.boundaries.add(2, new Boundary(b.x, b.y - 1, b.w, b.h, 1));
        break;
      case 6:
        b = w.boundaries.get(2);
        w.boundaries.remove(2);
        box2d.destroyBody(b.b);
        w.boundaries.add(2, new Boundary(b.x, b.y, b.w, b.h - 1, 2));
        break;
      }
      break;
    }
  } else {

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
  messageEvent = true;
  String foo = theOscMessage.addrPattern();
  if (foo.equals("/android/twitter")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase, false);
    println("Server twitter received: "+theOscMessage.get(0).stringValue());

  } else if (foo.equals("/android/sms")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase, false);
    println("Server sms received: "+theOscMessage.get(0).stringValue());

  } else if (foo.equals("/android/hp")) {

    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase, false);
    println("Server hp received: "+theOscMessage.get(0).stringValue());

  } else if (foo.equals("/android/debug")) {
  
    String frase = theOscMessage.get(0).stringValue().toUpperCase(ptLocale);
    createSentence(frase, true);
    println("Server received: "+theOscMessage.get(0).stringValue());

  }
}

void createSentence(String frase, boolean debug) {
  if (!debug) writeFrase2CSV(frase);
  w.sc.sentencesToAdd.push(new Sentence(frase, new Vec2(width/2, height/2 + 200), new Vec2(0, 0), 20, true));
}

void stop() {
  ambientSound.close();
  sequenceLSound.close();
  minim.stop();
  super.stop();
}

