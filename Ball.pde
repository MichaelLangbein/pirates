class Ball extends PItem implements FrameSubscribed {
  
  private int radius;
  private int ttl = 100;
  
  Ball(PVector pos, int radius){
    super(
      pos, 
      PVector.add(pos, new PVector(-radius-2, -radius-2)), 
      PVector.add(pos, new PVector(radius+2, radius+2))
     );
     this.radius = radius;
  }

  public ArrayList<Message> react(Message m){
    ArrayList<Message> ml = new ArrayList<Message>();
    
    if(m.type == "collision"){
      ml.add(onCollision(m));
    }
    
    return ml;
  }
  
  public ArrayList<Message> onFrame(ArrayList<Item> il){
    ArrayList<Message> ml = new ArrayList<Message>();
    
    moveNewtonian();
    drawSelf();
    ml.addAll(coarseCollControl(il));
    Message m = checkTtl();
    if(m.type == "kill"){
      ml.add(m);
    }
    
    return ml;
  }
  
  private Message onCollision(Message e){
    Message m = new Message();
    m.type = "kill";
    m.recipients.add(im);
    m.involved.put("kill",this);
    return m;
  }
  
  public void drawSelf(){
    stroke(1);
    
    if(debug){
      fill(100,100,100);
      rect(bb.upleft.x, bb.upleft.y, bb.w, bb.h);
    }
    
    fill(100,100,100);
    ellipse(pos.x, pos.y, 2*radius, 2*radius);
    
    if(debug) point(bb.position.x, bb.position.y);
  }
  
  private Message checkTtl(){
    Message m = new Message();
    ttl -=1;
    if(ttl <= 0){
      m.type = "kill";
      m.involved.put("kill",this);
      m.recipients.add(im);
    }
    return m;
  }
  
  private ArrayList<Message> coarseCollControl(ArrayList<Item> il){
    ArrayList<Message> ml = new ArrayList<Message>();
    for(Item i : il){
      if( i != this ){
        if( i instanceof PItem){
          Message e = checkCol( (PItem)i );
          if(e.body.get("will collide") == "true"){
            ml.add(e);
          }
        }
      }
    }
    return ml;
  }
  
  
  private String calcDirection(PItem i){
    
    float[] times = timeToImpact(i);
    float[] positions = getPositionsAtTimes(times);
    boolean[] hits = checkActualIntersection(i, positions);
    
    String coltext = "will not collide";  
    float shortestTime = 9999;
    int directionOfHit = -1;
    
    for(int n = 0; n < 3; n++){
      if(hits[n]){
        if(times[n] < shortestTime){
          shortestTime = times[n];
          directionOfHit = n;
          if(shortestTime <= 2){
            coltext = "will collide";
          }
        }
      }
    }
    
    String dir = translateIntToDir(directionOfHit);
    if(debug) println("Collision from " + dir + " in " + shortestTime);
    
    return dir;
  }
  
  private float[] timeToImpact(PItem i){
    float[] times = new float[4];
    
    float timeToImpactLeft = ( i.bb.upleft.x - this.pos.x ) / this.vel.x ;
    float timeToImpactTop = ( i.bb.upleft.y - this.pos.y ) / this.vel.y ;
    float timeToImpactRight = ( i.bb.downright.x - this.pos.x ) / this.vel.x ;
    float timeToImpactBot = ( i.bb.downright.y - this.pos.y ) / this.vel.y ;
    
    times[0] = timeToImpactLeft;
    times[1] = timeToImpactTop;
    times[2] = timeToImpactRight;
    times[3] = timeToImpactBot;
    
    for(int n = 0; n < 3; n++){
      if(times[n] < 0){
        times[n] = 9999;
      }
    }
    
    return times;
  }
  
  private float[] getPositionsAtTimes(float[] times){
    float[] positions = new float[4];
    
    float posYImpactLeft  = pos.y + times[0] * vel.y;
    float posXImpactTop   = pos.x + times[1] * vel.x;
    float posYImpactRight = pos.y + times[2] * vel.y;
    float posXImpactBot   = pos.x + times[3] * vel.x;
    
    positions[0] = posYImpactLeft;
    positions[1] = posXImpactTop;
    positions[2] = posYImpactRight;
    positions[3] = posXImpactBot;
  
    return positions;
  }
  
  private boolean[] checkActualIntersection(PItem i, float[] positions){
    boolean[] impacts = new boolean[4];
    
    boolean impactsLeft  = i.bb.upleft.y <= positions[0] && positions[0] <= i.bb.downright.y;
    boolean impactsTop   = i.bb.upleft.x <= positions[1] && positions[1] <= i.bb.downright.x;
    boolean impactsRight = i.bb.upleft.y <= positions[2] && positions[2] <= i.bb.downright.y;
    boolean impactsBot   = i.bb.upleft.x <= positions[3] && positions[3] <= i.bb.downright.x;
    
    impacts[0] = impactsLeft;
    impacts[1] = impactsTop;
    impacts[2] = impactsRight;
    impacts[3] = impactsBot;
    
    return impacts;
  }
  
  private String translateIntToDir(int d){
    String out = "n";
    
    switch(d){
      case 0:
      out = "l";
      break;
      case 1:
      out = "t";
      break;
      case 2:
      out = "r";
      break;
      case 3:
      out = "b";
      break;
    }
    
    return out;
  }
 
}