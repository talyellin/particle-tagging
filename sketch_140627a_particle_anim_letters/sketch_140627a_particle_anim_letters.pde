import processing.video.*;
Movie mov;
ArrayList<Item> items;
 
void setup() {
  size(640, 360);
  mov = new Movie(this, "animated-letters.mov");
  mov.loop();
  smooth();
  items = new ArrayList<Item>();
  noStroke();
}
 
void draw() {
  background(255);
  mov.loadPixels();
  for (int x = 0; x < mov.width; x+=2) { 
    for (int y = 0; y < mov.height; y+=2) {
      int loc = x+y*width;
      if (brightness(mov.pixels[loc]) >= 25.0) {
        items.add(new Item(new PVector(x, y)));
        //ellipse(x,y,5,5); // (still chokes with a basic ellipse)
      }
    }
  }
  mov.updatePixels();
  //image(mov, 0, 0);
  for (int i=items.size()-1;i>=0;i--) {
    Item item = items.get(i);
    item.run();
    if (item.isDead()) {
      items.remove(i);
    }
  }
  //saveFrame("output2/animated####.tga");
}
 
// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
 
class Item {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan = 255.0;
  float lifesize;
 
  Item(PVector l) {
    location = l.get();
    velocity = new PVector(random(-0.3, 0.3), random(-0.3, 0.3));
    acceleration = new PVector(0.5, random(-0.3, 0.3));
  }
  void run() {
    update();
    display();
  }
  void update() {
    //acceleration = PVector.random2D();
    velocity.add(acceleration);
    velocity.limit(3.0);
    location.add(velocity);
    lifespan -= random(10,20);
  }
  void display() {
    lifesize = map(lifespan, 0, 255, 1, 7);
    //lifesize = 5;
    fill(0, lifespan);
    ellipse(location.x, location.y, lifesize, lifesize);
  }
  boolean isDead() {
    if (lifespan < 5.0) {
      //println("particle dead");
      return true;
    } 
    else {
      return false;
    }
  }
}
