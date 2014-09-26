/*
 *
 * Test Low-Level Programming for FadeCandy
 * 
 * Dat Phan September 2014 
 */

int PIXELS_PER_CUBE = 4;
int MAX_CUBES = 20;

OPCLowLevel opc;

int time, oldTime;
int delay = 1000;

Cube[] cubes;

void setup()
{
  int root;
  opc = new OPCLowLevel("127.0.0.1", 7890, MAX_CUBES * PIXELS_PER_CUBE);
  
  cubes = new Cube[MAX_CUBES];
  for (int i = 0; i < MAX_CUBES; i++)
  {
    root = i * PIXELS_PER_CUBE;
    cubes[i] = new Cube(root, root + 1, root + 2, root + 3);
    
//    cubes[i].setAnteriorRGB(255, 255, 255);
    cubes[i].setSuperiorRGB(255, 0, 0);
    cubes[i].setPosteriorRGB(0, 255, 0);
    cubes[i].setInferiorRGB(0, 0, 255);
    
    cubes[i].loadPixelPacket(opc);
    opc.sendPixels();
  }
  
  time = millis();
  oldTime = time;
}

void allPixelsOff()
{
  for (int i = 0; i < MAX_CUBES * PIXELS_PER_CUBE; i++) {
    opc.setPixel(i, 0, 0, 0);
  }
  opc.sendPixels();
} 

void draw()
{
  time = millis();
  if (time - oldTime > delay)
  {
    for (int i = 0; i < MAX_CUBES; i++)
    { 
      if (i % 2 == 0)
        cubes[i].rotateForward();
      else
        cubes[i].rotateBack();
        
      cubes[i].loadPixelPacket(opc);
    }
    
    // Try to only send pixels when updates to cubes are made.
    // Sending pixels too often, eg for every draw call, stunts the fade effect.
    opc.sendPixels(); 
      
    oldTime = millis();
  }

}
