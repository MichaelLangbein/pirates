class WindRose extends Item implements FrameSubscribed{
  
  int radius;
  
  WindRose(PVector pos,  int r){
    super(pos, new PVector(pos.x - r, pos.y - r), new PVector(pos.x + r, pos.y + r));
    this.radius = r;
  }
  
  public ArrayList<Message> onFrame(ArrayList<Item> il){
    drawSelf();
    return new ArrayList<Message>();
  }
  
  public PVector angleToUnitV(float angle){
    float x = cos(radians(angle));  
    float y = sin(radians(angle));
    return new PVector(x,y);
  }
  
  public void drawSelf(){
    fill(100, 100, 100);
    ellipse(this.pos.x, this.pos.y, radius, radius);
    fill(150, 150, 150);
    stroke(150, 150, 150);
    PVector dirU = angleToUnitV(windAngle);
    dirU.mult(windStrength);
    PVector pos2 = PVector.add(pos, dirU);
    line(this.pos.x, this.pos.y, pos2.x, pos2.y);
  }
  
  public ArrayList<Message> react(Message e){
    return new ArrayList<Message>();
  }
}