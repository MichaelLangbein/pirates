class BBox {
  public PVector position;
  public PVector upleft;
  public PVector downright;
  public int w;
  public int h;
  
  BBox(PVector pos, PVector bbox1, PVector bbox2){
    position = new PVector(pos.x, pos.y);
    upleft = new PVector(bbox1.x, bbox1.y);
    downright = new PVector(bbox2.x, bbox2.y);
    w = (int)(bbox2.x - bbox1.x);
    h = (int)(bbox2.y - bbox1.y);
  }
  
  public void put(PVector newPos){
    PVector delta = PVector.sub(newPos, position);
    position.add(delta);
    upleft.add(delta);
    downright.add(delta);
  }
  
  public boolean intersects(BBox bb){
    boolean intersects = false;
    
    boolean x1ints = (upleft.x <= bb.upleft.x && bb.upleft.x <= downright.x) || (bb.upleft.x <= upleft.x && upleft.x <= bb.downright.x);
    boolean x2ints = (upleft.x <= bb.downright.x && bb.downright.x <= downright.x) || (bb.downright.x <= upleft.x && downright.x <= bb.downright.x);
    boolean y1ints = (upleft.y <= bb.upleft.y && bb.upleft.y <= downright.y) || (bb.upleft.y <= upleft.y && upleft.y <= bb.downright.y);
    boolean y2ints = (upleft.y <= bb.downright.y && bb.downright.y <= downright.y) || (bb.upleft.y <= downright.y && downright.y <= bb.downright.y);
    
    boolean xints = x1ints || x2ints;
    boolean yints = y1ints || y2ints;
    
    intersects = ( xints && yints); 
    
    return intersects;
  }
  
  
}