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
      this.words.get(w.s).count += 1;
      this.words.get(w.s).grow();
    } 
    else {
      w.makeBody(w.pos, w.w, w.fsize);
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
      /*
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
       
       }*/
    }
  }

  void create() {

    boundaries = new ArrayList<Boundary>();
    // boundaries.add(new Boundary(150*E+80*E/2, 260*E-80*E/2, 80*E, 260*E)); 
    //boundaries.add(new Boundary(490*E+80*E/2, 260*E-80*E/2, 80*E, 260*E));
    //(x2 - x1) , y2-y1

    boundaries.add(new Boundary(510, 455, (600-20)/2, (716-90))); 
    
    boundaries.add(new Boundary(1000, 700, (600-200)/2, (716-410))); 
    
    boundaries.add(new Boundary(1341+125, 455, (600-100)/2, (716-90))); 

    //    boundaries.add(new Boundary(351, 721, 495, 721));

    //382,142
    //604,143
    //351,721
    //495,721

    //1340 154
    //1597 164
    //1335 751
    //1569 748

    boundaries.add(new Boundary(0, 0, 10, height));
    boundaries.add(new Boundary(0, 0, width, 10));
    boundaries.add(new Boundary(width-10, 0, 10, height));
    boundaries.add(new Boundary(0, height-10, width, 10));

    // Cria fonte das frase
    sc = new SentenceCreator(this, -4, 4, 5, 10, width/2 - 40, width/2 + 40, height/2, height/2, 25);
    sc.importWordsFromCsv();
    sc.startAnimation();
  }
}

