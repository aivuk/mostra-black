class World {

  HashMap<String, Word> words;
  HashMap<String, Sentence> sentences;
  ArrayList<Boundary> boundaries;
  SentenceCreator sc;
  MouseJoint mj;
  int i;
  World() {
    this.sentences = new HashMap<String, Sentence>();
    this.words = new HashMap<String, Word>();
    i = 0;
  }

  // Adiciona uma frase no mundo
  void addSentence(Sentence s) {
    this.sentences.put(s.sentence, s);
  }

  // Adiciona um conjunto de palavras a este mundo
  //provavelmente depois de mostrar a sentenca e quebra-la
  void addWords(Collection<Word> ws) {
    for (Word w: ws) {
      addWord(w);
    }
  }

  void addWord(Word w) {
    if (this.words.containsKey(w.s)) {
      this.words.get(w.s).count += 5;
      this.words.get(w.s).grow();
    } 
    else {
      this.words.put(w.s, w);
    }
  }

  void update() {
    box2d.step();
    sc.update();
    for (Sentence s: this.sentences.values()) {
      s.update();
    }
  }  

  void display() {

    //desenha na tela as condicoes de contorno
    for (Boundary b:boundaries) {
      b.display();
    }

    //desenha na tela as palavras
    
    for (String w:this.words.keySet()) { 
      Word word = this.words.get(w);
      word.display();

      if (word.state == 1 && i == 0) {
        i = 1;
        MouseJointDef j = new MouseJointDef();
        j.body1 = box2d.world.getGroundBody();
      //  j.anchorPoint.set(-10,0);
       // j.body1.position.set(-10,0);(0,0)
        Vec2 fixed_point = new Vec2(0,0);
        j.body2 = word.body;
        j.target.set(fixed_point);
        
        j.maxForce = 1000.0f * word.body.m_mass;
        j.frequencyHz = 5.0f;
        j.dampingRatio = 0.9f;

        mj = (MouseJoint) box2d.world.createJoint(j);
        this.words.get(w).state = 2;
      } else if (word.state == 2) {
    
      //  println(box2d.coordPixelsToWorld(mouseX,mouseY));
         Vec2 mouseWorld = box2d.coordPixelsToWorld(mouseX,mouseY);
          mj.setTarget(mouseWorld);
          
      }
    }
  }

  void create() {

    boundaries = new ArrayList<Boundary>();
    boundaries.add(new Boundary(150*E+80*E/2, 260*E-80*E/2, 80*E, 260*E)); 
    boundaries.add(new Boundary(490*E+80*E/2, 260*E-80*E/2, 80*E, 260*E));

    boundaries.add(new Boundary(0, 0, 1, height*2));
    boundaries.add(new Boundary(0, 0, width*2, 1));
    boundaries.add(new Boundary(width, 0, 1, height*2));
    boundaries.add(new Boundary(0, height, 2*width, 1));

    // Cria fonte das frase
    sc = new SentenceCreator(this);
 

    readCsv();


    //verifica se existem frases no arquivo
    //caso exista
  }

  void readCsv() {

    try {

      CsvReader frasesFile = new CsvReader(new InputStreamReader(new FileInputStream(dataPath("") + outputFile), "UTF-8"));
      frasesFile.readHeaders();

      while (frasesFile.readRecord ())
      {
        String frase = frasesFile.get("Frase");
        println(frase);

        if (frameCount%10==0) {
          Sentence so = new Sentence(frase, width/2-70, height/2, 8);
          addSentence(so);
          addWords(so.words.values());
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
}

