class SnapPoint{
  PVector pos;
  
  SnapPoint(PVector pos){
    this.pos = pos;
  }
  
  SnapPoint(float x, float y){
    this.pos = new PVector(x, y);
  }
  
  void drawSnapPoint(){
    stroke(255, 0, 0);
    strokeWeight(1);
    circle(this.pos.x, this.pos.y, 1);
  }
}
