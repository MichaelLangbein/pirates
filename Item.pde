abstract class Item implements Messaging{
  public PVector pos;
  public BBox bb;
  
  Item(PVector pos,  PVector bbox1, PVector bbox2){
    this.pos = pos;
    this.bb = new BBox(pos, bbox1, bbox2);
  }
  
  public void put(PVector pos){
    this.pos = pos;
    updateBBox();
  }
  
  public void updateBBox(){
    bb.put(pos);
  }
  
  abstract public void drawSelf();
  
  abstract public ArrayList<Message> react(Message e);
  
}