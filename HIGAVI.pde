ArrayList<Ball> balls;
ArrayList<Rect> rectangle;
ArrayList stars;
int ballWidth = 36;
final int NB_PARTICLES = 32;
ArrayList<Triangle> triangles;
Particle[] parts = new Particle[NB_PARTICLES];
PImage image;
MyColor myColor = new MyColor();

void settings() {
  size(1280,720,P2D);
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
}

void keyPressed() {
  if(keyPressed) {
    if (key == 'a' || key == 'A') {
      // A new ball object is added to the ArrayList (by default to the end)
      rectangle.add(new Rect(0, 660, 215, 60, 245, 50, 50));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 245, 50, 50));
      }
    if(key == 's' || key == 'S') {
      rectangle.add(new Rect(215, 660, 215, 60, 255, 127, 80));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 127, 80));
      }
    if(key == 'd' || key == 'D') {
      rectangle.add(new Rect(430, 660, 215, 60, 255, 255, 102));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 255, 102));
      }
    if(key == 'f' || key == 'F') {
      rectangle.add(new Rect(645, 660, 215, 60, 0, 250, 154));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 0, 250, 154));
      }
    if(key == 'j' || key == 'J') {
      rectangle.add(new Rect(860, 660, 215, 60, 0, 191, 255));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 0, 191, 255));
      }
    if(key == 'k' || key == 'K') {
      rectangle.add(new Rect(1075, 660, 205, 60, 255, 255, 255));
      balls.add(new Ball(random(100,1000), random(50,600), ballWidth, 255, 255, 255));
    }
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

class Ball {
  
  float x;
  float y;    
  float xspeed = random(6);  // Speed of the shape
  float yspeed = random(6);  // Speed of the shape
  
  float R;
  float G;
  float B;

  float xdirection = random(-1,1);  // Left or Right
  float ydirection = random(-1,1);  // Top to Bottom
  float speed;
  float w;
  float life = 255*random(0.5,4);
  
  float s = second();
  
  Ball(float tempX, float tempY, float tempW, float tempR, float tempG, float tempB) {
    x = tempX;
    y = tempY;
    w = tempW;
    R = tempR;
    G = tempG;
    B = tempB;
    speed = 0;
  }
  
    void move() {
     // Update the position of the shape
  x = x + ( xspeed * xdirection );
  y = y + ( yspeed * ydirection );
  
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (x > width - w) {
    xdirection *= -1;
  }
  if (x < w) {
    xdirection *= -1;
  }
  if (y > 660 - w) {
    ydirection *= -1;
  }
  if (y < w) {
    ydirection *= -1;
  }
      
    }
  
  boolean finished() {
    // Balls fade out
    
    life--;
    if (life < 0) {
       return true;
    } else {
       return false;
    }
  }
  
  void display() {
    // Display the circle
    fill(R,G,B,life);
    //stroke(0,life);
    ellipse(x,y,w,w);
  }
}

class MyColor
{
  float R, G, B, Rspeed, Gspeed, Bspeed;
  final static float minSpeed = .5;
  final static float maxSpeed = 1;
  MyColor()
  {
    init();
  }
  
  public void init()
  {
    R = random(100,255);
    G = random(100,255);
    B = random(100,255);
    Rspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Gspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Bspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
  }
  
  public void update()
  {
    Rspeed = ((R += Rspeed) > 255 || (R < 100)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 100)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 100)) ? -Bspeed : Bspeed;
  }
}

class Particle
{
  final static float RAD = 50;
  final static float BOUNCE = -1;
  final static float SPEED_MAX = 0.1;
  final static float DIST_MAX = 300;
  PVector speed = new PVector(random(-SPEED_MAX, SPEED_MAX), random(-SPEED_MAX, SPEED_MAX));
  PVector acc = new PVector(0, 0);
  PVector pos;
  //neighboors contains the particles within DIST_MAX distance, as well as itself
  ArrayList<Particle> neighboors;
  
  Particle()
  {
    pos = new PVector (random(width), random(height));
  }

  public void move()
  {    
    pos.add(speed);
    
    acc.mult(0);
    
    if (pos.x < 0)
    {
      pos.x = 0;
      speed.x *= BOUNCE;
    }
    else if (pos.x > width)
    {
      pos.x = width;
      speed.x *= BOUNCE;
    }
    if (pos.y < 0)
    {
      pos.y = 0;
      speed.y *= BOUNCE;
    }
    else if (pos.y > 660)
    {
      pos.y = 660;
      speed.y *= BOUNCE;
    }
  }
  
  public void display()
  {
    fill(255, 55);
    ellipse(pos.x, pos.y, RAD, RAD);
  }
}

class Rect {
  
  float x;
  float y;
  
  float R;
  float G;
  float B;
  
  float w;
  float h;
  float life = 255 / 1.25;
  
  Rect(float tempX, float tempY, float tempW, float tempH, float tempR, float tempG, float tempB) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    R = tempR;
    G = tempG;
    B = tempB;
  }
  
  boolean finished() {
    // Balls fade out
    
    life = life-- / 1.1;
    if (life < 0) {
       return true;
    } else {
       return false;
    }
  }
  
  void display() {
    // Display the rect
    fill(R,G,B,life);
    //stroke(0,life);
    rect(x,y,w,h);
  }
}

class star {
  int xPos, yPos, starSize;
  float flickerRate, light;
  boolean rise;
  
  star(){
    flickerRate = random(2,5);
    starSize = int(random(2,5));
    xPos = int(random(0,1280 - starSize));
    yPos = int(random(0,660 - starSize));
    light = random(10,245);
    rise = true;
  }
  
  void display(){
    if(light >= 245){
      rise = false;
    }
    if(light <= 10){
      flickerRate = random(2,5);
      starSize = int(random(2,5));
      rise = true;
      xPos = int(random(0,1280 - starSize));
      yPos = int(random(0,660 - starSize));
    }
    if(rise == true){
      light += flickerRate;
    }
    if(rise == false){
      light -= flickerRate;
    }
    
    fill(light);
    ellipse(xPos, yPos, starSize, starSize);
  }
}

class Triangle
{
  PVector A, B, C; 

  Triangle(PVector p1, PVector p2, PVector p3)
  {
    A = p1;
    B = p2;
    C = p3;
  }
  
  public void display()
  {
    vertex(A.x, A.y);
    vertex(B.x, B.y);
    vertex(C.x, C.y);
  }
}
