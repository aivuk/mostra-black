class SentenceCreator {

  World world;
  float vec_x_min, vec_x_max, vec_y_min, vec_y_max;

  SentenceCreator(World world, float vec_x_min, float vec_x_max, float vec_y_min, float vec_y_max) {
    this.world = world;
    this.vec_x_min = vec_x_min;
    this.vec_x_max = vec_x_max;
    this.vec_y_min = vec_y_min;
    this.vec_y_max = vec_y_max;
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

  void importWordsFromCsv() {

    try {

      CsvReader frasesFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + outputFile), "UTF-8"));
      frasesFile.readHeaders();

      while (frasesFile.readRecord ())
      {
        String frase = frasesFile.get("Frase");
        
        if (frameCount%40==0) {
          Sentence so = new Sentence(frase, new Vec2(width/2-70, height/2), 8, 5000, true);
          world.addSentence(so);
          world.addWords(so.words.values());
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
  
  void update() {
   
  }
}

