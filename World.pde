class World {

  HashMap<String, Word> words;
  //HashMap<String, Sentence> sentences;
  Sentence actualSentence;
  ArrayList<Boundary> boundaries;
  ArrayList<Line> lines;
  float startTime;
  float changeGDelay;
  SentenceCreator sc;
  MouseJoint mj;
  Vec2 g;
  int i;
  World() {
//    this.sentences = new HashMap<String, Sentence>();
    //this.sentence = new ArrayList<Sentence>();
    this.words = new HashMap<String, Word>();
    this.lines = new ArrayList<Line>();
    i = 0;
    this.startTime = millis();
    this.changeGDelay = 15000;
    this.g = new Vec2(0,0);
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
      Word word = this.words.get(w.s);
      word.count += 1;
      word.grow();
    } else {
      w.makeBody(w.pos, w.w, w.fsize);
      this.words.put(w.s, w);
    }
  }

  void update() {
    box2d.step();
    sc.update();
    if (millis() - this.startTime > this.changeGDelay) {
      this.startTime = millis();    
      this.g.x = random(-5,5);
      this.g.y = random(-5,5);
      box2d.setGravity(this.g.x, this.g.y);

    } 
  }  

  void display() {

    //desenha na tela as condicoes de contorno
    for (Boundary b:boundaries) {
      b.display();
    }

    for (Line l:this.lines) {
      l.display(); 
    }

    //desenha na tela as palavras

    for (String w:this.words.keySet()) { 
      Word word = this.words.get(w);
      word.display();
    }

    // Desenha frase na tela
    if (this.actualSentence != null) {
      this.actualSentence.display(); 
    }
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

  void create() {

    loadObjectsCoords(this);
    
    // Cria fonte das frase
    sc = new SentenceCreator(this, -25, 25, 8, 13, width/2 - 40, width/2 + 40, height/2, height/2, 20);
    Boundary b = this.boundaries.get(1);
   // Line l = new Line(b.x, b.y - 10, b.x + b.w, b.y - 10, 20.0, this.boundaries);
    // topo
    Line l2 = new Line(15, 10, width-15, 10, 10.0, this.boundaries);
    // esquerda
    Line l3 = new Line(33, 10, 33, height, 6.0, this.boundaries);
    // direita
    Line l4 = new Line(width-50, 10, width-50, height, 6.0, this.boundaries);
    // embaixo esquerda
    Line l5 = new Line(33, height, 380, height, 6.0, this.boundaries);
    // embaixo direita
    Line l6 = new Line(width - 375, height, width-50, height, 6.0, this.boundaries);
    // centro esquerda
    Line l7 = new Line(660, height, 950, height, 6.0, this.boundaries);
    // centro direita
    Line l8 = new Line(1095, height, 1385, height, 6.0, this.boundaries);

    //this.lines.add(l);
    this.lines.add(l2);
    this.lines.add(l3);
    this.lines.add(l4);
    this.lines.add(l5);
    this.lines.add(l6);
    this.lines.add(l7);
    this.lines.add(l8);

    sc.importWordsFromCsv();
    sc.startAnimation();
  }
}
