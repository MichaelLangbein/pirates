class AIShip extends Ship{
  
  private int turning;
  
  AIShip(PVector pos){
    super(pos);
    turning = 1;
  }
  
  public ArrayList<Message> onFrame(ArrayList<Item> il){
    ArrayList<Message> ml =  new ArrayList<Message>();
    if(random(1) > 0.98) {
      Message m = doShoot();
      ml.add(m);
    }
    doMove();
    doPhysics();
    drawSelf();
    return ml;
   }
   
   public void doMove(){
     if(random(1) >= 0.98) turning = turning*(-1);
     updateDir(turning);
   }
   
   public Message doShoot(){
     char dir = 'b';
     if(random(1) > 0.5) dir = 's';
     Message m = shoot(dir);
     return m;
   }
}