class Sentence {

  //HashMap <String, Word>words;
  ArrayList<Word> words;
  float v_x, v_y, fsize;
  Vec2 pos, vel;
  String sentence; 
  long timeToLive;
  long startTime;
  int state;
  PFont fontA;
  float sizeFactor;
  float toRandX;

  Sentence(String sentenceString, Vec2 pos, Vec2 vel, float fsize, boolean breakWords) {
    this.pos = pos;
    this.vel = vel;
    this.state = 0;
    this.fsize = fsize;
    float pos_x = this.pos.x;
    float pos_y = this.pos.y;
    this.startTime = millis();
    this.sizeFactor = 1;
    this.fontA = createFont("HelveticaBold", 50);
    //this.words = new HashMap<String, Word>();
    this.words = new ArrayList<Word>();
    this.toRandX = 0;
    this.sentence = sentenceString;
  }

  void update() {
    switch (this.state) {

    case 0:
      if (this.pos.y >= 250) {

        if (floor(this.toRandX) == 0) {
          boolean r = random(1) < 0.5;

          if ((r && this.pos.x < width/2 + this.sizeFactor*150) || (!r && this.pos.x < width/2 - this.sizeFactor*150)) {
            this.toRandX = random(30, 40);
          } 
          else {
            this.toRandX = -random(30, 40);
          }
        } 
        else {
          if (this.toRandX > 0) {
            this.pos.x += 1;
            this.toRandX -= 1;
          } 
          else {
            this.pos.x -= 1;
            this.toRandX += 1;
          }
        }

        this.pos.y -= 3;
        this.sizeFactor += 0.003;
     
      } else {
          this.startTime = millis();
          this.state = 1;        
      }
      break;
      case 1:
        long n = millis();
        if (n - this.startTime >= 5000) {
           this.state = 2; 
                 messageEvent = true;

        }
    }
  }

  void display() {
    textFont(this.fontA, this.sizeFactor*this.fsize);
    float w = glg1.textWidth(this.sentence);    
    textAlign(CENTER);
    rectMode(CENTER);
    fill(0);
    text(this.sentence, this.pos.x, this.pos.y, this.sizeFactor*300, this.sizeFactor*200);
    fill(255);
    text(this.sentence, this.pos.x + 2, this.pos.y + 2, this.sizeFactor*300, this.sizeFactor*200);
  }
}

