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

    if (!breakWords) {
      //this.words.put(sentenceString, new Word(sentenceString, pos, new Vec2(0,1), this.fsize));
      this.words.add(new Word(sentenceString, pos, new Vec2(0, 1), this.fsize));
    } else {

      for (String s:sentenceString.split(" ")) {
        Word word = new Word(s, new Vec2(pos_x, pos_y), new Vec2(0, 0), this.fsize);
        // word.growSize = 30;
        this.words.add(word);
        pos_x += word.w + 10; 
        //pos_x += 5 + s.fsize*word.s.length();
      }
    }

    this.sentence = sentenceString;
  }

  void update() {
    long now = millis();

    switch (this.state) {

    case 0:
      if (this.pos.y >= 550) {

        if (floor(this.toRandX) == 0) {
          boolean r = random(1) < 0.5;

          if ((r && this.pos.x < width/2 + 100) || (!r && this.pos.x < width/2 - 100)) {
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

        this.pos.y -= 1;
        this.sizeFactor += 0.005;
     
      } else {
          this.state = 1;        
      }
      break;
    }
  }

  void display() {
    textFont(this.fontA, this.sizeFactor*this.fsize);
    textAlign(CENTER);
    text(this.sentence, this.pos.x, this.pos.y, this.sizeFactor*100, this.sizeFactor*50);
  }
}

