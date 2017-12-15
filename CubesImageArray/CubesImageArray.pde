OPC opc;
PImage im;
double start_time;
int i;
float m = 3.0; // minutes between switching images

void setup()
{
  // Initialize Dat's variables
  start_time = millis();
  i = 0;
  
  size(800, 200);

  // Load a sample image
   im = loadImage("flames.jpeg");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 80-LED strip to the center of the window
  opc.ledStrip(0, 80, width/2, height/2, width / 80.0, 0, false);
 
   
   
  
}

void draw()
{
  
  // Scale the image so that it matches the width of the window
  int imHeight = im.height * width / im.width;

  
  // Scroll down slowly, and wrap around
  float speed = 0.05;
  float y = (millis() * -speed) % imHeight;
  
  
  
  // Use two copies of the image, so it seems to repeat infinitely
  image(im, 0, y, width, imHeight);
  image(im, 0, y + imHeight, width, imHeight); 
  
  // load a different image periodically
  if ( millis() - start_time > 1000 * 60 * m)
  {
    start_time = millis();
    
     //go to next image; 
    i++;
    if (i == 4)
    {
      i = 0;
    } 
    
      switch (i){
    
  case 0:
   im = loadImage("flames.jpeg");
  break;
  
  case 1:  
    im = loadImage("gradients.jpeg");   
   break;
  
  case 2: 
    im = loadImage("rainbow4.jpeg");
  break;

  case 3:
    im = loadImage("rainbow7.jpeg");
  break;
  
  }


  }
     
     
  
  
}

