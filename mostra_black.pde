import pbox2d.*;
import processing.opengl.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;


World w;
float g_x = 0;
float g_y = -1.0;
color bck_color = color(100, 24, 44);
int E=2;
PBox2D box2d;
PGraphics pg;

void setup() {
  size(730*E, 335*E, OPENGL);
  pg = createGraphics(730*E, 335*E, P2D);
  smooth();

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

