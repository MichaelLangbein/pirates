/**
The Message is the base type of communication in this engine.
Most information should be comfortably represented in the bodies String => String representation.
If further fields are required, the class can be extended. 
For example: class Collision extends Message
*/

class Message{
  public ArrayList<Messaging> recipients; // Recipients are not only Items, but maybe also the ItemManager.
  public HashMap<String, Item> involved;
  public String type;
  public HashMap<String, String> body = new HashMap();
  
  Message(){
    this.recipients = new ArrayList<Messaging>();
    this.involved = new HashMap<String, Item>();
    this.body = new HashMap<String, String>();
  }
  
  public void addRecipient(Item i){
    recipients.add(i);
  }
  
  public void addInvolved(String descr, Item i){
    involved.put(descr, i);
  }

  public void setType(String type){
    this.type = type;
  }
  
  public void addToBody(String name, String val){
    body.put(name, val);
  }

}