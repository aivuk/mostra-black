class Sentence {

  HashMap <String, Word>words;
  float x, y, v_x, v_y, fsize;
  String sentence; 

  Sentence(String sentenceString, float x, float y, float fsize/*, float v_x, float v_y*/) {
    this.x = x;
    this.y = y;
    this.fsize = fsize;
    float pos_x = this.x;
    float pos_y = this.y;
    this.sentence = sentenceString.toUpperCase();
    this.words = new HashMap<String, Word>();
    this.words.put(sentence, new Word(sentence, this.x, this.y, this.fsize));
  }
}

