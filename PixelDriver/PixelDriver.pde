/*
 *
 * Test Low-Level Programming for FadeCandy
 * 
 * Dat Phan September 2014 
 */

int MAX_PIXELS = 4 ;
int BRIGHTNESS = 130;           // How bright should our test pattern be?

int S_WAITING    = 0;
int S_START_BIT  = 1;
int S_SETTLE_BIT = 2;
int S_FINALIZE = 3;

int state;
int bit;
int numBitsInUse;
OPCLowLevel opc;
//Capture video;
//int[][] bitImages;

int time, oldTime;
int delay = 500;

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
  
  cube.display(opc);
  
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
    cube.display(opc);
    oldTime = millis();
  }

}
