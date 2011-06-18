class Line {
  
  float x_min, x_max;
  float y_min, y_max;
  float w;
  ArrayList<Boundary> boundaries;
 
 void Line(float x_min, float y_min, float x_max, float y_max, float w, ArrayList<Boundary> boundaries) {
   this.x_min = x_min;
   this.x_max = x_max;
   this.y_min = y_min;
   this.y_max = y_max;
   this.w = w;
   this.boundaries = boundaries;
 }
  
 void display() {
   strokeWeight(w);
   line(x_min, y_min, x_max, y_max); 
 }
  
}
