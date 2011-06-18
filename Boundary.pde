// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A fixed boundary class

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  float startTime;
  int t;
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_, float y_, float w_, float h_, int t_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    t = t_;
    startTime = millis();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    Vec2 center = new Vec2(x+w/2, y+h/2);

    // Define the polygon
    PolygonDef sd = new PolygonDef();
    sd.setAsBox(box2dW, box2dH);
    sd.density = 0;    // No density means it won't move!
    sd.friction = 0.3f;

    // Create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(center));
    b = box2d.createBody(bd);
    b.createShape(sd);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    glg1.fill(0);
    glg1.stroke(0);
     if (t==0 || t == 2) {

     glg1.imageMode(CORNER);
     if (millis() - startTime >= 1000) {
     startTime = millis();
     glg1.tint(50, 50, 50);
     glg1.image(porta1, x - w/3 - 24, y - h/3 + 68);
    glg1.tint(255);
     } else {
         glg1.tint(0);
     glg1.image(porta1, x - w/3 - 24, y - h/3 + 68);
    glg1.tint(255);
       
     }
    
    } 
    else {
    glg1.rectMode(CORNER);
    glg1.rect(x, y, w, h);
    }
  }
}

