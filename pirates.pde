import ddf.minim.*; //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer music;
AudioPlayer noise;
AudioPlayer shot;
AudioPlayer explosion;

ItemManager im;
boolean debug = false;
float t;
int frameNumber;
float deltat = 0.0001;
float windAngle;
float windStrength;

void setup(){
  size(600, 400);
  background(0);
  t = 0.0;
  frameNumber = 0;
  
  minim = new Minim(this);
  noise = minim.loadFile("ship.wav");
  music = minim.loadFile("song2.wav");
  shot = minim.loadFile("cannon.wav");
  explosion = minim.loadFile("explosion.wav");
  
  noise.loop();
  music.loop();
  
  im = new ItemManager();
  
  WindRose wr = new WindRose(new PVector(50, 50), 30);
  im.addItem(wr);
  
  PlayerShip s = new PlayerShip(new PVector(200, 200));
  im.addItem(s);
  
  for(int i = 0; i<3; i++){
    AIShip a = new AIShip(new PVector(random(10, width-10), random(10, height-10)));
    im.addItem(a);
  }
}

void draw(){
  background(117, 168, 249);
  frameNumber += 1;
  t += deltat;
  windAngle = noise(t)*360; // noise allways between 0 and 1
  windStrength = noise(t)*100;
  im.onFrame();
  checkWin();
  checkLoss();
}

void keyPressed(){
  im.onKey(keyCode);
}

void checkWin(){
  int e = checkEnemyCount();
  if(e == 0){
    textSize(32);
    text("You won!", 100, 200);
  }
}

void checkLoss(){
  int e = checkPlayerCount();
  if(e == 0){
    textSize(32);
    text("You lost...", 100, 200);
  }
}

int checkEnemyCount(){
  int count = 0;
  for(Item i : im.items){
    if(i instanceof AIShip){
      count += 1;
    }
  }
  return count;
}

int checkPlayerCount(){
  int count = 0;
  for(Item i : im.items){
    if(i instanceof PlayerShip){
      count += 1;
    }
  }
  return count;
}