class SentenceCreator {

  World world;

  SentenceCreator(World world) {
    this.world = world;
  } 
  /*
  void createFromString(String sentence, float x, float y, float fsize) {
   Sentence newSentence = new Sentence(sentence, x, y, fsize, 5000); 
   this.world.addSentence(newSentence);
   this.world.addWords(newSentence.words.values());
   }
   */
  void breakSentence(Sentence s) {
    // Remove sentença inteira do mundo
    Vec2 pos = box2d.getBodyPixelCoord(this.world.words.get(s.sentence).body);

    Word w = this.world.words.get(s.sentence);
    w.killWord();
    this.world.words.remove(s.sentence);

    float pos_x = pos.x;
    for (String ss:s.sentence.split(" ")) {
      Word word = new Word(ss, pos_x, pos.y, s.fsize);
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
        println(frase);

        if (frameCount%10==0) {
          Sentence so = new Sentence(frase, width/2-70, height/2, 8, 5000, false);
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
    String s = "Fazer sexo oral não cansa a boca"; 


    // Adiciona Sentenca

    if (frameCount == 10) {
      Sentence so = new Sentence(s, width/2-70, height/2, 8, 5000, true);

      this.world.addSentence(so);
      this.world.addWords(so.words.values());
    }

    /*

     if (frameCount == 15) {
     String ss = "Fazer sexo cansa"; 
     
     Sentence so2 = new Sentence(ss, width/2-70, height/2, 8);
     this.world.addSentence(so2);
     this.world.addWords(so2.words.values());
     }
     
     if (frameCount == 20) {
     String ss = "Fazer sexo pode cansar"; 
     
     Sentence so3 = new Sentence(ss, width/2-70, height/2, 8);
     this.world.addSentence(so3);
     this.world.addWords(so3.words.values());
     }
     if (frameCount >= 20 && frameCount <= 2 ) {
     String ss = "Fazer cansa"; 
     
     Sentence so3 = new Sentence(ss, width/2-70, height/2, 8);
     this.world.addSentence(so3);
     this.world.addWords(so3.words.values());
     }
     
     if (frameCount == 100) {
     for (Sentence si:this.world.sentences.values()) {
     breakSentence(si);
     }
     }*/
  }
}

