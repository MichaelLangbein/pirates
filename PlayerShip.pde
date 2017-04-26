class PlayerShip extends Ship implements KeySubscribed{
  
  PlayerShip(PVector pos){
     super(pos);
     colors[0] = 30;
     colors[1] = 100;
     colors[2] = 80;
  }
  
     
   public ArrayList<Message> onKey(ArrayList<Item> il, int k){
     ArrayList<Message> ml = new ArrayList<Message>();
     if(k == DOWN){
       updateDir(3);
     }if(k == UP){
       updateDir(-3);
     }if(k == LEFT){
       Message m = shoot('b');
       ml.add(m);
     }if(k == RIGHT){
       Message m = shoot('s');
       ml.add(m);
     }
     return ml;
   }
}