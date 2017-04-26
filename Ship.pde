abstract class Ship extends PItem implements FrameSubscribed{
  
  private float drag;
  private float direction;
  private PVector dirV;
  private int hitpoints;
  protected int colors[];
  private PImage img;
  
  Ship(PVector pos){
    super(pos, new PVector(pos.x-30, pos.y-30), new PVector(pos.x+30, pos.y+30));
    drag = 0.9;
    direction = 0;
    dirV = angleToUnitV(direction);
    hitpoints = 100;
    colors = new int[3];
    colors[0] = 100;
    colors[1] = 100;
    colors[2] = 100;
    
    img = loadImage("ship.png");
  }
  
  public void drawSelf(){
    if(debug){
      fill(50,50,50);
      rect(bb.upleft.x, bb.upleft.y, bb.w, bb.h);
      point(bb.position.x, bb.position.y);
    }
    fill(colors[0], colors[1], colors[2]);
    ellipse(pos.x, pos.y, bb.w, bb.h);
    PVector dirU = PVector.mult(dirV, 30);
    PVector pos2 = PVector.add(pos, dirU);
    fill(150,150,150);
    line(pos.x, pos.y, pos2.x, pos2.y);
    
    stroke(200,200,200);
    fill(10,10,10);
    rect(bb.upleft.x, bb.upleft.y - 20, bb.w, 17);
    fill(150,150,150);
    rect(bb.upleft.x, bb.upleft.y - 20, (int)hitpoints*bb.w/100, 17);
    
    pushMatrix();
    translate(bb.upleft.x + bb.w/2, bb.upleft.y+bb.h/2);
    rotate(radians(direction-90)); 
    imageMode(CENTER);
    image(img, 0, 0, bb.w, bb.h);
    popMatrix();
  }
  
  public ArrayList<Message> react(Message m){
    ArrayList<Message> ml = new ArrayList<Message>();
    if(m.type == "collision"){
      ml.add(onCollision(m));
    }
    return ml;
  }
  
   public ArrayList<Message> onFrame(ArrayList<Item> il){
     doPhysics();
     drawSelf();
     return new ArrayList<Message>();
   }
  
  private Message onCollision(Message m){
    Message n = new Message();
    if(m.involved.get("hitter") instanceof Ball){
      hitpoints -= 10;
      if(debug) println("Hitpoints of " + this + ": " + hitpoints);
      if(hitpoints <= 0){
         
         explosion.rewind();
         explosion.setGain(-15);
         explosion.play();
        
        m.type = "kill";
        m.recipients.add(im);
        m.involved.put("kill",this);
      }
    }
    return n;
  }
  
  protected void updateDir(int change){
    direction += change;
    dirV = angleToUnitV(direction);
  }
  
   private PVector angleToUnitV(float angle){
    float x = cos(radians(angle));
    float y = sin(radians(angle));
    return new PVector(x,y);
  }
  
  private PVector projectOnDir(PVector v){
    float angle = PVector.dot(dirV, v);
    PVector vEff = PVector.mult(dirV,  angle*v.mag() );
    return vEff;
  }
  
  protected void doPhysics(){
    // Wind dazu
     PVector wind = angleToUnitV(windAngle).mult(windStrength/250);
     PVector windEff = projectOnDir(wind);
     acc.add(windEff);
     // Eigengeschwindigkeit
     PVector ownSpeed = angleToUnitV(direction).mult(0.1);
     vel.add(ownSpeed);
     // Drag
     vel.mult(drag);
     // Bewegen
     moveNewtonian();
     overEdge();
  }
  
  private void overEdge(){
    if(this.pos.x > width) put(new PVector(20, this.pos.y));
    if(this.pos.x < 0) put(new PVector(width - 20, this.pos.y));
    if(this.pos.y > height) put(new PVector(this.pos.x, 20));
    if(this.pos.y < 0) put(new PVector(this.pos.x, height - 20));
  }
   
   protected Message shoot(char d){
     PVector bp = new PVector();
     PVector dir = new PVector();
     if(d == 's'){
       dir = angleToUnitV(direction+90);
       bp = new PVector(pos.x, pos.y).add(dir.mult(60));
     }else if(d == 'b'){
       dir = angleToUnitV(direction-90);
       bp = new PVector(pos.x, pos.y).add(dir.mult(60));
     }
     Ball b = new Ball(bp, 10);
     b.push(dir.mult(1.0/10));
     
     
     shot.rewind();
     shot.setGain(-15);
     shot.play();
     
     Message m = new Message();
     m.type = "newBall";
     m.recipients.add(im);
     m.involved.put("newBall", b);
     return m;
   }

}