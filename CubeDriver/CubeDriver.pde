/*
 *
 * Test Low-Level Programming for FadeCandy
 * 
 * Dat Phan September 2014 
 */

//int BRIGHTNESS = 130;           // incorporate

int MAX_PIXELS = 4;

OPCLowLevel opc;

int time, oldTime;
int delay = 1000;

Cube cube;

void setup()
{
  opc = new OPCLowLevel("127.0.0.1", 7890, MAX_PIXELS);
  
  // manually build a cube to test
  cube = new Cube(0, 1, 2, 3);
  cube.setAnteriorRGB(255, 255, 255);
  cube.setSuperiorRGB(255, 0, 0);
  cube.setPosteriorRGB(0, 255, 0);
  cube.setInferiorRGB(0, 0, 255);
  
  cube.loadPixelPacket(opc);
  opc.sendPixels();
  
  time = millis();
  oldTime = time;
}

void allPixelsOff()
{
  for (int i = 0; i < MAX_PIXELS; i++) {
    opc.setPixel(i, 0, 0, 0);
  }
  opc.sendPixels();
} 

void draw()
{
  time = millis();
  if (time - oldTime > delay)
  {
    cube.rotateForward();
    cube.loadPixelPacket(opc);
    
    // Try to only send pixels when updates to cubes are made.
    // Sending pixels too often, eg for every draw call, stunts the fade effect.
    opc.sendPixels(); 
    
    oldTime = millis();
  }

}
