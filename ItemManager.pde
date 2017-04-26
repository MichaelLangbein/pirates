class ItemManager implements Messaging{
  public ArrayList<Item> items;
  public ArrayList<FrameSubscribed> fs;
  public ArrayList<KeySubscribed> ks;
  
  ItemManager(){
    items = new ArrayList<Item>();
    fs = new ArrayList<FrameSubscribed>();
    ks = new ArrayList<KeySubscribed>();
  }
  
  public ArrayList<Message> react(Message e){
    if(e.type == "newBall"){
      addItem(e.involved.get("newBall"));
    }else if(e.type == "kill"){
      killItem(e.involved.get("kill"));
    }
    return new ArrayList<Message>();
  }
  
  public void onFrame(){
    ArrayList<Message> el = new ArrayList<Message>();
    for(FrameSubscribed f : fs){
      el.addAll(f.onFrame(items));
    } 
    dispatch(el);
  }

  public void onKey(int ky){
    ArrayList<Message> el = new ArrayList<Message>();
    for(KeySubscribed k : ks){
      el.addAll(k.onKey(items, ky));
    } 
    dispatch(el);
  }
  
  private void dispatch(ArrayList<Message> ml){
    if(ml.size() <= 0) return;
    ArrayList<Message> ml2 = new ArrayList<Message>();
    for( Message m : ml ){ //<>//
      if(debug) println("Now dispatching: " + m.type + m.body);
      for(int j = 0; j<m.recipients.size(); j++){
      // It could happen that Item i has been destroyed by the time that message m is beeing worked off.
      // That's why we first must check that the Item still exists.
        if(m.recipients.get(j) != null){
          Messaging i = m.recipients.get(j);
          ml2.addAll( i.react(m) );
        }
      }
    }
    dispatch(ml2);
  }
  
  public void addItem(Item i){
    items.add(i);
    if(i instanceof FrameSubscribed) fs.add((FrameSubscribed)i);
    if(i instanceof KeySubscribed) ks.add((KeySubscribed)i);
  }
  
  public void killItem(Item i){
    if(debug) println("Now killing " + i);
    if(debug) println("Counts before: " + items.size() + ", " + fs.size() + ", " + ks.size());
    items.remove(i);
    if(i instanceof FrameSubscribed) fs.remove((FrameSubscribed)i);
    if(i instanceof KeySubscribed) ks.remove((KeySubscribed)i);
    if(debug) println("Counts after: " + items.size() + ", " + fs.size() + ", " + ks.size());
  }
}