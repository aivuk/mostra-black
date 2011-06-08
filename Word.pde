class Word {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  PFont fontA;
  String s;
  float fsize;
  color colorf;
  float x;
  float y;
  int count;
  float growSize;
  int state;
  // Constructor
  Word(String s, float x, float y, float fsize) {
    this.s = s;
    this.fsize = fsize;
    this.growSize = this.fsize;  
    this.x = x;
    this.y = y;
    this.count = 0;
    this.state = 0;

    fontA = createFont("HelveticaBold",50);
    textFont(this.fontA, this.fsize);
    this.w = textWidth(this.s);   
    h = fsize;
    // Add the box to the box2d world
    colorf = int(random(255));
    makeBody(new Vec2(x, y), w, h);
  }

  // This function removes the particle from the box2d world
  void killWord() {
    box2d.destroyBody(this.body);
  }

  void grow() {
    this.fsize += 1;
    this.h = this.fsize;
    textFont(this.fontA, this.fsize);
    this.w = textWidth(this.s);    
    Vec2 pos = box2d.getBodyPixelCoord(this.body);
    box2d.destroyBody(this.body);
    makeBody(pos, w, h);    
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killWord();
      return true;
    }
    return false;
  }

  void display() {

    if (this.fsize < this.growSize) {
       this.grow(); 
    }
    
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    textFont(this.fontA, this.fsize + this.count);
    this.w = textWidth(this.s);    
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(colorf);
    stroke(0);
    // rect(0,0,w,h);
    text(s, 0, 0, w, h + this.count);

    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonDef sd = new PolygonDef();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Parameters that affect physics
    sd.density = 1.0f;
    sd.friction = 0.3f;
    sd.restitution = 0.5f;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createShape(sd);
    body.setMassFromShapes();

    // Give it some initial random velocity
   // body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
  //  body.setAngularVelocity();
  }
}

