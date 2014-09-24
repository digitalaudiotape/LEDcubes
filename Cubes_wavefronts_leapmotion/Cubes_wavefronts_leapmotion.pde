import de.voidplus.leapmotion.*;

LeapMotion leap;
int lastId = -1;
float lastX, lastY;



OPC opc;
PImage texture;
Ring rings[];
boolean f = false;

void setup()
{
  size(640, 320, P3D);
  colorMode(HSB, 100);
  texture = loadImage("ring.png");

  leap = new LeapMotion(this);

  opc = new OPC(this, "127.0.0.1", 7890);
  
  // cube 1
  opc.led(0, width * 1/6, height * 3/6);
  opc.led(1, width * 1/6, height * 3/6);
  opc.led(2, width * 1/6, height * 3/6);
  opc.led(3, width * 1/6, height * 3/6);
  
  // cube 2
  opc.led(4, width * 2/6, height * 4/6);
  opc.led(5, width * 2/6, height * 4/6);
  opc.led(6, width * 2/6, height * 4/6);
  opc.led(7, width * 2/6, height * 4/6);
  
  // cube 3
  opc.led(8, width * 1/6, height * 3/6);
  opc.led(9, width * 1/6, height * 3/6);
  opc.led(10, width * 1/6, height * 3/6);
  opc.led(11, width * 1/6, height * 3/6);
   
  // cube 4
  opc.led(12, width * 2/6, height * 2/6);
  opc.led(13, width * 2/6, height * 2/6);
  opc.led(14, width * 2/6, height * 2/6);
  opc.led(15, width * 2/6, height * 2/6);
   
  // cube 5
  opc.led(16, width * 3/6, height * 1/6);
  opc.led(17, width * 3/6, height * 1/6);
  opc.led(18, width * 3/6, height * 1/6);
  opc.led(19, width * 3/6, height * 1/6);
  
  // cube 6
  opc.led(20, width * 2/6, height * 2/6);
  opc.led(21, width * 2/6, height * 2/6);
  opc.led(22, width * 2/6, height * 2/6);
  opc.led(23, width * 2/6, height * 2/6);
  
  // cube 7
  opc.led(24, width * 3/6, height * 3/6);
  opc.led(25, width * 3/6, height * 3/6);
  opc.led(26, width * 3/6, height * 3/6);
  opc.led(27, width * 3/6, height * 3/6);

  // cube 8
  opc.led(28, width * 4/6, height * 2/6);
  opc.led(29, width * 4/6, height * 2/6);
  opc.led(30, width * 4/6, height * 2/6);
  opc.led(31, width * 4/6, height * 2/6);
  
  // cube 9
  opc.led(32, width * 5/6, height * 1/6);
  opc.led(33, width * 5/6, height * 1/6);
  opc.led(34, width * 5/6, height * 1/6);
  opc.led(35, width * 5/6, height * 1/6);
    
  // cube 10
  opc.led(36, width * 4/6, height * 2/6);
  opc.led(37, width * 4/6, height * 2/6);
  opc.led(38, width * 4/6, height * 2/6);
  opc.led(39, width * 4/6, height * 2/6);
  
 
  // cube 11
  opc.led(40, width * 5/6, height * 3/6);
  opc.led(41, width * 5/6, height * 3/6);
  opc.led(42, width * 5/6, height * 3/6);
  opc.led(43, width * 5/6, height * 3/6);
  
  // cube 12
  opc.led(44, (width * 6/6) -1, height * 4/6);
  opc.led(45, (width * 6/6) -1, height * 4/6);
  opc.led(46, (width * 6/6) -1, height * 4/6);
  opc.led(47, (width * 6/6) -1, height * 4/6);
 
  // cube 13
  opc.led(48, width * 5/6, height * 5/6);
  opc.led(49, width * 5/6, height * 5/6);
  opc.led(50, width * 5/6, height * 5/6);
  opc.led(51, width * 5/6, height * 5/6);
 
  // cube 14
  opc.led(52, (width * 6/6) -1, (height * 6/6) -1);
  opc.led(53, (width * 6/6) -1, (height * 6/6) -1);
  opc.led(54, (width * 6/6) -1, (height * 6/6) -1);
  opc.led(55, (width * 6/6) -1, (height * 6/6) -1);
    
  // cube 15
  opc.led(56, width * 5/6, height * 5/6);
  opc.led(57, width * 5/6, height * 5/6);
  opc.led(58, width * 5/6, height * 5/6);
  opc.led(59, width * 5/6, height * 5/6);
    

  // We can have up to 100 rings. They all start out invisible.
  rings = new Ring[100];
  for (int i = 0; i < rings.length; i++) {
    rings[i] = new Ring();
  }
}

void draw()
{
  background(0);

  Finger f = leap.getFrontFinger();

  if (f != null) {
    PVector position = f.getPosition();

    float x = (position.x - 200) * width / 300;
    float y = (position.y - 200) * width / 100;

    float smoothX = lastX + (x - lastX) * 0.2;
    float smoothY = lastY + (y - lastY) * 0.2;

    if (f.getId() == lastId && lastId >= 0) {
      rings[int(random(rings.length))].respawn(lastX, lastY, smoothX, smoothY);
    }
     
    lastX = lastId < 0 ? x : smoothX;
    lastY = lastId < 0 ? y : smoothY;
    lastId = f.getId();
  } else {
    lastId = -1;
  }

  // Give each ring a chance to redraw and update
  for (int i = 0; i < rings.length; i++) {
    rings[i].draw();
  }
}

