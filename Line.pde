class Line {

  float x_min, x_max;
  float y_min, y_max;
  float w;
  ArrayList<Boundary> boundaries;
  float animate;

  Line(float x_min, float y_min, float x_max, float y_max, float w, ArrayList<Boundary> boundaries) {
    this.x_min = x_min;
    this.x_max = x_max;
    this.y_min = y_min;
    this.y_max = y_max;
    this.w = w;
    this.boundaries = boundaries;
  }

  void display() {
    glg1.strokeWeight(w);

    if (messageEvent) {
      if (lstartTime == 0) {
        lstartTime = millis();
      }

      if (millis() - lstartTime <= 1000) {
        if (!blueLine && frameCount %10 == 0) {
          blueLine = true;
          // glg1.stroke(220, 180, 0);
          glg1.stroke(250, 20, 0);
        } 
        else {
          blueLine = false;
         // glg1.stroke(0, 170, 255);
            glg1.stroke(255, 0, 120);
        }
        glg1.line(x_min, y_min, x_max, y_max);
      } 
      else {
        messageEvent = false;
        lstartTime = 0;
        blueLine = false;
      }
    }
    else {
       //glg1.stroke(0, 170, 255);

      glg1.stroke(255, 0, 120);
      glg1.line(x_min, y_min, x_max, y_max);
    }
  }
}

