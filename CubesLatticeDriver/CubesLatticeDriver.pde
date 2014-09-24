/*
 *
 * Class to translate linear LEDs to cubes in 3D space
 * 
 * Dat Phan September 2014 
 */

int PIXELS_PER_CUBE = 4;
int MAX_CUBES = 15 ;

//lattice space dimensions
int LSX = 6;
int LSY = 6;
int LSZ = 6;

OPCLowLevel opc;

int travelingIndex;
int time, oldTime;
int delay = 600;

Lattice lattice;

int [][][] latticeElements;

void setup()
{
  travelingIndex = 0;
  
  //initialize the lattice elements array
  latticeElements = new int[LSX][LSY][LSZ];

  
  // hard-code the cube indices into the 3D array of possible lattice positions, origin is at closest bottom left corner
  latticeElements[0][2][1] = 0;
  latticeElements[1][3][2] = 1;
  latticeElements[0][2][3] = 2;
  latticeElements[1][1][4] = 3;
  latticeElements[2][0][3] = 4;
  
  latticeElements[1][1][2] = 5;
  latticeElements[2][2][1] = 6;
  latticeElements[3][1][0] = 7;
  latticeElements[4][0][1] = 8;
  latticeElements[3][1][2] = 9;
  
  latticeElements[4][2][3] = 10;
  latticeElements[5][3][4] = 11;
  latticeElements[4][4][5] = 12;
  latticeElements[5][5][4] = 13;
  latticeElements[4][4][3] = 14;
  
  opc = new OPCLowLevel("127.0.0.1", 7890, MAX_CUBES * PIXELS_PER_CUBE);
  
  
// uncomment these if you want to disable either feature. See this link for more
// https://github.com/scanlime/fadecandy/blob/master/doc/processing_opc_client.md

// opc.setDithering(false);
// opc.setInterpolation(false);


  
  lattice = new Lattice(LSX, LSY, LSZ, latticeElements, MAX_CUBES, PIXELS_PER_CUBE);

  // give each cube a red LED and a blue LED
  for (int i = 0; i < MAX_CUBES; i++)
  {
    lattice.getCubeAtIndex(i).setAnteriorRGB(255,0,0);
    lattice.getCubeAtIndex(i).setPosteriorRGB(0,0,255);
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
  
  // visit each volume position, and interact with a cube there if it exists
  
  time = millis();
  if (time - oldTime > delay)
  {
    
    if (travelingIndex == MAX_CUBES)
    {
      travelingIndex = 0;
    }
      
    lattice.getCubeAtIndex(travelingIndex).rotateForward();
    lattice.getCubeAtIndex(travelingIndex).loadPixelPacket(opc);
    
    opc.sendPixels();
    
    oldTime = time;  
    travelingIndex++;
   }
  
}
