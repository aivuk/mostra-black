class Sentence {

  HashMap <String, Word>words;
  float x, y, v_x, v_y, fsize;
  String sentence; 
  long timeToLive;
  long startTime;
  int state;

  Sentence(String sentenceString, float x, float y, float fsize, long timeToLive, boolean breakWords/*, float v_x, float v_y*/) {
    this.x = x;
    this.y = y;
    this.state = 0;
    this.timeToLive = timeToLive;
    this.fsize = fsize;
    float pos_x = this.x;
    float pos_y = this.y;
    this.startTime = millis();
    this.words = new HashMap<String, Word>();
    
    if (!breakWords) {
      this.words.put(sentenceString, new Word(sentenceString, this.x, this.y, this.fsize));
    } else {
      for (String s:sentenceString.split(" ")) {
        Word word = new Word(s, pos_x, pos_y, this.fsize);
        word.growSize = 30;
        this.words.put(word.s, word);
        //pos_x += 5 + s.fsize*word.s.length();
      }
    }

    this.sentence = sentenceString;
  }

  void update() {
    long now = millis();

    switch (this.state) {

    case 0:
      if (now - startTime >= timeToLive) {
        this.state = 1;
        // Cria vinculos
        for (Word w:this.words.values()) {
//          w.killWord();
          w.state = 1;
            
        }
        println("cria vinculos");
      }  
      break;
    }
  }

 //   this.sentence = sentenceString.toUpperCase();
 //   this.words = new HashMap<String, Word>();
 //   this.words.put(sentence, new Word(sentence, this.x, this.y, this.fsize));
}

