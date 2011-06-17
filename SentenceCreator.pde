class SentenceCreator {

  Set<String> badwords;
  World world;
  float vec_x_min, vec_x_max, vec_y_min, vec_y_max;
  float x_min, x_max, y_min, y_max;
  Stack <Word>wordsToAdd;
  Stack <Sentence>sentencesToAdd;
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
    this.timeInWords = 1000;
    this.animation = false;
    this.wordsToAdd = new Stack();
    this.sentencesToAdd = new Stack();
    this.badwords = new HashSet<String>();
    this.loadBadWords();
  } 

  void loadBadWords() {
      try {

      CsvReader badwordsFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + "badwords.csv"), "UTF-8"));
      badwordsFile.readHeaders();

      while (badwordsFile.readRecord()) {
        String badword = badwordsFile.get("badword");
        this.badwords.add(badword); 
      }
      badwordsFile.close();
    }
    
    catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    
    catch (IOException e) {
      e.printStackTrace();
    }  
  }

  ArrayList<String> cleanSentence(String sentence) {
    ArrayList<String> cleanWords = new ArrayList();

    for (String word:sentence.split(" ")) {
       if (!this.badwords.contains(word.toLowerCase()) && word.length() >= 2) {
         cleanWords.add(word);
       }     
     }
     
    return cleanWords;
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

      CsvReader frasesFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath(outputFile)), "UTF-8"));
      frasesFile.readHeaders();

      while (frasesFile.readRecord ()) {
        String frase = frasesFile.get("Frase");
        this.sentencesToAdd.push(new Sentence(frase, new Vec2(width/2, height/2 + 200), new Vec2(0, 0), this.startFontSize, true));
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

  void addWords(Sentence s) {
   
       for (String w:this.cleanSentence(s.sentence)) {
         Word word = new Word(w, new Vec2(s.pos.x, s.pos.y), new Vec2(random(vec_x_min, vec_x_max), random(vec_y_min, vec_y_max)), s.fsize);
         this.world.addWord(word);
       }
  }

  void update() {
    
    if (this.world.actualSentence != null) {
      Sentence s = this.world.actualSentence;
      s.update();
      if (s.state == 1) {
          this.addWords(s);
          this.world.actualSentence = null;  
      }
    } else if (!this.sentencesToAdd.empty()) {
      sequenceLSound.trigger();
      Sentence s = this.sentencesToAdd.pop();
      this.world.actualSentence = s;
    }
  }
}

