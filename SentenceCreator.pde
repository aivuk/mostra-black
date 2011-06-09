class SentenceCreator {

  World world;
  float vec_x_min, vec_x_max, vec_y_min, vec_y_max;
  float x_min, x_max, y_min, y_max;
  Stack <Word>wordsToAdd;
  float timeInWords, lastWordTime;
  Boolean animation;
  float startFontSize;

  SentenceCreator(World world, float vec_x_min, float vec_x_max, float vec_y_min, float vec_y_max, float x_min, float x_max, float y_min, float y_max, float startFontSize) {
    this.world = world;
    this.vec_x_min = vec_x_min;
    this.vec_x_max = vec_x_max;
    this.vec_y_min = vec_y_min;
    this.vec_y_max = vec_y_max;
    this.x_min = x_min;
    this.x_max = x_max;
    this.y_min = y_min;
    this.y_max = y_max;
    this.startFontSize = startFontSize;
    this.timeInWords = 3000;
    this.animation = false;
    this.wordsToAdd = new Stack();
  } 

  void breakSentence(Sentence s) {
    // Remove sentença inteira do mundo
    Vec2 pos = box2d.getBodyPixelCoord(this.world.words.get(s.sentence).body);

    Word w = this.world.words.get(s.sentence);
    w.killWord();
    this.world.words.remove(s.sentence);

    float pos_x = pos.x;
    for (String ss:s.sentence.split(" ")) {
      Word word = new Word(ss, new Vec2(pos_x, pos.y), new Vec2(random(vec_x_min, vec_x_max), random(vec_y_min, vec_y_max)), s.fsize);
      word.growSize = 30;
      this.world.addWord(word);
      pos_x += 5 + s.fsize*word.s.length();
    }
  }

  Word createWord(String wordString) {
    return new Word(wordString, new Vec2(random(this.x_min, this.x_max), random(this.y_min, this.y_max)), new Vec2(random(vec_x_min, vec_x_max), random(vec_y_min, vec_y_max)), this.startFontSize);
  }    
    
  void importWordsFromCsv() {

    try {

      CsvReader frasesFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + outputFile), "UTF-8"));
      frasesFile.readHeaders();

      while (frasesFile.readRecord ())
      {
        String frase = frasesFile.get("Frase");
        
        if (frameCount%40==0) {
          //Sentence so = new Sentence(frase, new Vec2(width/2-70, height/2), 8, 5000, true);
          //world.addSentence(so);
          //world.addWords(so.words.values());
          for (String ws:frase.split(" ")) {
            Word w = this.createWord(ws);
            this.wordsToAdd.push(w);
          }
        }
      }

      frasesFile.close();
    } 
    catch (FileNotFoundException e) {
      e.printStackTrace();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  void startAnimation() {
    this.animation = true;
    this.lastWordTime = 0;
  }
  
  void update() {
    if (this.animation && !this.wordsToAdd.empty()) {
      float now = millis();
      if (now - this.lastWordTime >= this.timeInWords) {
       Word w = this.wordsToAdd.pop();
       w.makeBody(w.pos, w.w, w.fsize);
       this.world.addWord(w);
     //  w.body.wakeUp();
       this.lastWordTime = millis();
      }
    }     
  }
}

