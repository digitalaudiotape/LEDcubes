/*
 *
 * Class to translate linear LEDs to cubes in 3D space
 * 
 * Dat Phan September 2014 
 */

int PIXELS_PER_CUBE = 4;
int MAX_CUBES = 15 ;
int MAX_LATTICE_VOLUME = 216;

//lattice space dimensions
int LSX = 6;
int LSY = 6;
int LSZ = 6;

OPCLowLevel opc;

int travelingIndex;
int time, oldTime;
int delay = 100;

Lattice lattice;

int [][][] latticeElements;

XYZ travelingXYZ;

void setup()
{
  travelingIndex = 0;
  
  //initialize the lattice elements array
  latticeElements = new int[LSX][LSY][LSZ];

  clearVolume(latticeElements, LSX, LSY, LSZ);  
  
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
  allPixelsOff();
  
  lattice = new Lattice(LSX, LSY, LSZ, latticeElements, MAX_CUBES, PIXELS_PER_CUBE);

  // give each cube a single white LED at its root
  for (int i = 0; i < MAX_CUBES; i++)
  {
    lattice.getCubeAtIndex(i).setAnteriorRGB(255,0,0);
    lattice.getCubeAtIndex(i).setPosteriorRGB(0,0,255);
  }  
  

  lattice.printContents();
  
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

int a = 0;
int b = 0;
int c = 0;

Cube currentCube;
int cubeIndex;

void draw()
{
  
  
// visit each volume position, and interact with a cube there if it exists  
  
  time = millis();
  if (time - oldTime > delay)
  {
    if (travelingIndex == MAX_LATTICE_VOLUME)
    {
      travelingIndex = 0;
      allPixelsOff();
    }

    travelingXYZ = indexToXYZ(travelingIndex);
    
    cubeIndex = lattice.getCubeIndexAtXYZ(travelingXYZ.x, travelingXYZ.y, travelingXYZ.z);
    currentCube = lattice.getCubeAtXYZ(travelingXYZ.x, travelingXYZ.y, travelingXYZ.z);
    
    if (currentCube != null)
    {
      println(travelingXYZ.x + ", " + travelingXYZ.y + ", " + travelingXYZ.z + ": current cube exists, cube index = " + cubeIndex);
      currentCube.rotateForward();
      currentCube.loadPixelPacket(opc);
      opc.sendPixels();
    }
    else
    {
      println(travelingXYZ.x + ", " + travelingXYZ.y + ", " + travelingXYZ.z + ": current cube is null");
    }
    
//    lattice.getCubeAtXYZ(travelingXYZ.x, travelingXYZ.y, travelingXYZ.z).rotateForward();
//    lattice.getCubeAtXYZ(travelingXYZ.x, travelingXYZ.y, travelingXYZ.z).loadPixelPacket(opc);
     
//    opc.sendPixels();
   
    oldTime = time;
    travelingIndex++; 
   }
  
}

XYZ indexToXYZ(int travIndex)
{
   XYZ xyz = new XYZ();
   
   // travel along x
   xyz.x = travIndex % LSX;
   
   // travel along y
    
   xyz.y = (ceil(travIndex / LSX)) % LSY;
   
   // travel along z
   xyz.z = (ceil(travIndex / (LSX * LSY))) % (LSX * LSY * LSZ);
   
     
   return xyz;
}


void clearVolume(int [][][] vol, int x, int y, int z)
{
    //set every element as -1 as default

    for (int i = 0; i < x; i++)
    {
      for (int j = 0; j < y; j++)
      {
        for (int k = 0; k < z; k++)
        {
         vol[i][j][k] = -1; 
         println(" should equal -1: " + vol[i][j][k]);
        }        
      }
    }
}

