ArrayList<Ball> balls;
ArrayList<Rect> rectangle;
ArrayList stars;
int ballWidth = 36;
final int NB_PARTICLES = 32;
ArrayList<Triangle> triangles;
Particle[] parts = new Particle[NB_PARTICLES];
PImage image;
MyColor myColor = new MyColor();

import oscP5.*;
import netP5.*;
import codeanticode.syphon.*;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation, myRemoteLocation2;

void settings() {
  size(1280,720, P3D);
  PJOGL.profile=1;
}

void setup() {
  frameRate(30);
  noStroke();
  
  // Create an empty ArrayList (will store Ball objects)
  balls = new ArrayList<Ball>();
  
  rectangle = new ArrayList<Rect>();
  
  for (int i = 0; i < NB_PARTICLES; i++)
  {
    parts[i] = new Particle();
  }
  
  stars = new ArrayList();
  for(int i = 1; i <= 300; i++){
    stars.add(new star());
  }
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  myRemoteLocation2 = new NetAddress("127.0.0.1",13000);
  
  server = new SyphonServer(this,"Processing Syphon");
}

void draw() {
   background(0);
   
   for(int i = 0; i <= stars.size()-1; i++){
    star starUse = (star) stars.get(i);
    starUse.display();
  }
  
  myColor.update();
  noStroke();
  fill(0, 100);
  
  for (int i = rectangle.size()-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Rect rect = rectangle.get(i);
    rect.display();
    if (rect.finished()) {
      // Items can be deleted with remove()
      rectangle.remove(i);
    }
    
  }
  
  triangles = new ArrayList<Triangle>();
  Particle p1, p2;
  
    // With an array, we say balls.length, with an ArrayList, we say balls.size()
  // The length of an ArrayList is dynamic
  // Notice how we are looping through the ArrayList backwards
  // This is because we are deleting elements from the list  
  for (int i = balls.size()-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Ball ball = balls.get(i);
    ball.move();
    ball.display();
    if (ball.finished()) {
      // Items can be deleted with remove()
      balls.remove(i);
    }
    
  }
  
  for (int i = 0; i < NB_PARTICLES; i++)
  {
    parts[i].move();
  }

  for (int i = 0; i < NB_PARTICLES; i++)
  {
    p1 = parts[i];
    p1.neighboors = new ArrayList<Particle>();
    p1.neighboors.add(p1);
    for (int j = i+1; j < NB_PARTICLES; j++)
    {
      p2 = parts[j];
      float d = PVector.dist(p1.pos, p2.pos); 
      if (d > 0 && d < Particle.DIST_MAX)
      {
        p1.neighboors.add(p2);
      }
    }
    if(p1.neighboors.size() > 0.5)
    {
      addTriangles(p1.neighboors);
    }
  }
  drawTriangles();
      
  server.sendScreen();
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("red")==true) {
  // A new ball object is added to the ArrayList (by default to the end)
  rectangle.add(new Rect(0, 660, 215, 60, 245, 50, 50));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 245, 50, 50));
  }
  if(theOscMessage.checkAddrPattern("orange")==true) {
  rectangle.add(new Rect(215, 660, 215, 60, 255, 127, 80));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 127, 80));
  }
  if(theOscMessage.checkAddrPattern("yellow")==true) {
  rectangle.add(new Rect(430, 660, 215, 60, 255, 255, 102));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 255, 102));
  }
  if(theOscMessage.checkAddrPattern("green")==true) {
  rectangle.add(new Rect(645, 660, 215, 60, 0, 250, 154));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 0, 250, 154));
  }
  if(theOscMessage.checkAddrPattern("blue")==true) {
  rectangle.add(new Rect(860, 660, 215, 60, 0, 191, 255));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 0, 191, 255));
  }
  if(theOscMessage.checkAddrPattern("white")==true) {
  rectangle.add(new Rect(1075, 660, 205, 60, 255, 255, 255));
  balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 255, 255));
  }
}

void drawTriangles()
{
  noStroke();
  fill(myColor.R, myColor.G, myColor.B, 5);
  stroke(max(myColor.R-15, 5), max(myColor.G-15, 5), max(myColor.B-15, 5), 5);
  //noFill();
  beginShape(TRIANGLES);
  for (int i = 0; i < triangles.size(); i ++)
  {
    Triangle t = triangles.get(i);
    t.display();
  }
  endShape();  
}

void addTriangles(ArrayList<Particle> p_neighboors)
{
  int s = p_neighboors.size();
  if (s > 2)
  {
    for (int i = 1; i < s-1; i ++)
    { 
      for (int j = i+1; j < s; j ++)
      { 
         triangles.add(new Triangle(p_neighboors.get(0).pos, p_neighboors.get(i).pos, p_neighboors.get(j).pos));
      }
    }
  }
}