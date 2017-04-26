/**
Compared to an Item, a PItem contains a lot of extra stuff. 
It has methods for Newtonian physics and a very simple collision detector.
However, more advanced collision detection is only implemented by more advanced items.
*/

abstract class PItem extends Item implements Messaging{
  public PVector vel;
  public PVector acc;
  
  PItem(PVector pos, PVector bbox1, PVector bbox2){
    super(pos, bbox1, bbox2);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  
  public void push(PVector p){
    acc.add(p); //<>//
  }
  
  public void moveNewtonian(){
    vel.add(acc);
    pos.add(vel);
    updateBBox();
    acc.mult(0);
  }
  
  public void moveBackNewtonian(){
    pos.sub(vel);
    updateBBox();
  }
  
  public Message checkCol(PItem i){
    
    Message e = new Message();
    e.setType("collision");
    e.addRecipient(this);
    e.addRecipient(i);
    e.addInvolved("hitter", this);
    e.addInvolved("hittee", i);
    
    if(this.bb.intersects(i.bb)){ // Is there already a collision?
      e.addToBody("will collide", "true");
    }else{
      moveNewtonian(); // Will the next step lead to a collision?
      if(this.bb.intersects(i.bb)){
        e.addToBody("will collide", "true");
      }else{
        e.addToBody("will collide", "false");
      }
      moveBackNewtonian();
    }
    
    return e;
  }
   
}