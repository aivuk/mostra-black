class World {

  HashMap<String, Word> words;
  HashMap<String, Sentence> sentences;
  ArrayList<Boundary> boundaries;
  SentenceCreator sc;

  World() {
    this.sentences = new HashMap<String, Sentence>();
    this.words = new HashMap<String, Word>();
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
    } else {
      this.words.put(w.s, w);
    }
  }

  void update() {
    box2d.step();
    sc.update();
  }  

  void display() {

    //desenha na tela as condicoes de contorno
    for (Boundary b:boundaries) {
      b.display();
    }

    //desenha na tela as palavras
    for (String w:this.words.keySet()) { 
      this.words.get(w).display();
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
  }
}

