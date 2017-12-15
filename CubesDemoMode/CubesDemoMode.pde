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
  opc.led(0, -0 + width * 1/6, -0 + height * 3/7);
  opc.led(1, -1 + width * 1/6, -1 + height * 3/7);
  opc.led(2, -2 + width * 1/6, -2 + height * 3/7);
  opc.led(3, -3 + width * 1/6, -3 + height * 3/7);
  
  // cube 2
  opc.led(4, -0 + width * 2/6, -0 +  height * 4/7);
  opc.led(5, -1 + width * 2/6, -1 + height * 4/7);
  opc.led(6, -2 + width * 2/6, -2 + height * 4/7);
  opc.led(7, -3 + width * 2/6, -3 + height * 4/7);
  
  // cube 3
  opc.led(8, -4 + width * 1/6, -0 + height * 3/7);
  opc.led(9, -5 + width * 1/6, -1 + height * 3/7);
  opc.led(10, -6 + width * 1/6, -2 + height * 3/7);
  opc.led(11, -7 + width * 1/6, -3 + height * 3/7);
   
  // cube 4
  opc.led(12, -4 + width * 2/6, -0 + height * 2/7);
  opc.led(13, -5 + width * 2/6, -1 + height * 2/7);
  opc.led(14, -6 + width * 2/6, -2 + height * 2/7);
  opc.led(15, -7 + width * 2/6, -3 + height * 2/7);
   
  // cube 5
  opc.led(16, -0 + width * 3/6, -4 + height * 1/7);
  opc.led(17, -1 + width * 3/6, -5 + height * 1/7);
  opc.led(18, -2 + width * 3/6, -6 + height * 1/7);
  opc.led(19, -3 + width * 3/6, -7 + height * 1/7);
  
  // cube 6
  opc.led(20, -0 + width * 2/6, -4 + height * 2/7);
  opc.led(21, -1 + width * 2/6, -5 + height * 2/7);
  opc.led(22, -2 + width * 2/6, -6 + height * 2/7);
  opc.led(23, -3 + width * 2/6, -7 + height * 2/7);
  
  // cube 7
  opc.led(24, -0 + width * 3/6, -0 + height * 3/7);
  opc.led(25, -1 + width * 3/6, -1 + height * 3/7);
  opc.led(26, -2 + width * 3/6, -2 + height * 3/7);
  opc.led(27, -3 + width * 3/6, -3 + height * 3/7);

  // cube 8
  opc.led(28, -0 + width * 4/6, -0 + height * 2/7);
  opc.led(29, -1 + width * 4/6, -1 + height * 2/7);
  opc.led(30, -2 + width * 4/6, -2 + height * 2/7);
  opc.led(31, -3 + width * 4/6, -3 + height * 2/7);
  
  // cube 9
  opc.led(32, -0 + width * 5/6, -0 + height * 1/7);
  opc.led(33, -1 + width * 5/6, -1 + height * 1/7);
  opc.led(34, -2 + width * 5/6, -2 + height * 1/7);
  opc.led(35, -3 + width * 5/6, -3 + height * 1/7);
    
  // cube 10
  opc.led(36, -0 + width * 4/6, -4 + height * 2/7);
  opc.led(37, -1 + width * 4/6, -5 + height * 2/7);
  opc.led(38, -2 + width * 4/6, -6 + height * 2/7);
  opc.led(39, -3 + width * 4/6, -7 + height * 2/7);
  
 
  // cube 11
  opc.led(40, -0 + width * 5/6, -0 + height * 3/7);
  opc.led(41, -1 + width * 5/6, -1 + height * 3/7);
  opc.led(42, -2 + width * 5/6, -2 + height * 3/7);
  opc.led(43, -3 + width * 5/6, -3 + height * 3/7);
  
  // cube 12
  opc.led(44, -0 + (width * 6/6) -1, -0 + height * 4/7);
  opc.led(45, -1 + (width * 6/6) -1, -1 + height * 4/7);
  opc.led(46, -2 + (width * 6/6) -1, -2 + height * 4/7);
  opc.led(47, -3 + (width * 6/6) -1, -3 + height * 4/7);
 
  // cube 13
  opc.led(48, -0 + width * 5/6, -0 + height * 5/7);
  opc.led(49, -1 + width * 5/6, -1 + height * 5/7);
  opc.led(50, -2 + width * 5/6, -2 + height * 5/7);
  opc.led(51, -3 + width * 5/6, -3 + height * 5/7);
 
  // cube 14
  opc.led(52, -0 + (width * 6/6) -1, -0 + height * 6/7);
  opc.led(53, -1 + (width * 6/6) -1, -1 + height * 6/7);
  opc.led(54, -2 + (width * 6/6) -1, -2 + height * 6/7);
  opc.led(55, -3 + (width * 6/6) -1, -3 + height * 6/7);
    
  // cube 15
  opc.led(56, -4 + width * 5/6, -0 + height * 5/7);
  opc.led(57, -5 + width * 5/6, -1 + height * 5/7);
  opc.led(58, -6 + width * 5/6, -2 + height * 5/7);
  opc.led(59, -7 + width * 5/6, -3 + height * 5/7);

  // cube 16
  opc.led(60, -0 + width * 4/6, -0 + height * 5/7);
  opc.led(61, -1 + width * 4/6, -1 + height * 5/7);
  opc.led(62, -2 + width * 4/6, -2 + height * 5/7);
  opc.led(63, -3 + width * 4/6, -3 + height * 5/7);
      
  // cube 17
  opc.led(64, -0 + width * 3/6, -0 + height * 5/7);
  opc.led(65, -1 + width * 3/6, -1 + height * 5/7);
  opc.led(66, -2 + width * 3/6, -2 + height * 5/7);
  opc.led(67, -3 + width * 3/6, -3 + height * 5/7);    
       
  // cube 18
  opc.led(68, -0 + width * 2/6, -0 + height * 6/7);
  opc.led(69, -1 + width * 2/6, -1 + height * 6/7);
  opc.led(70, -2 + width * 2/6, -2 + height * 6/7);
  opc.led(71, -3 + width * 2/6, -3 + height * 6/7);    
  
  // cube 19
  opc.led(72, -0 + width * 3/6, -0 + (height * 7/7) - 1);
  opc.led(73, -1 + width * 3/6, -1 + (height * 7/7) - 1);
  opc.led(74, -2 + width * 3/6, -2 + (height * 7/7) - 1);
  opc.led(75, -3 + width * 3/6, -3 + (height * 7/7) - 1);

// cube 20
  opc.led(76, -0 + width * 4/6, -4 + height * 6/7);
  opc.led(77, -1 + width * 4/6, -5 + height * 6/7);
  opc.led(78, -2 + width * 4/6, -6 + height * 6/7);
  opc.led(79, -3 + width * 4/6, -7 + height * 6/7);


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

