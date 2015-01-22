/*
 *
 * Class to translate linear LEDs to cubes in 3D space, with Leap Motion support
 * 
 * Dat Phan September 2014 
 */

//added leap motion code
import de.voidplus.leapmotion.*;

LeapMotion leap;

int lastId = -1;
float lastX, lastY; 

int numHands = 0;
int[] cubeHand_id = new int[2];
PVector[] cubeHand = new PVector[2];

float last_x_position = 0;
float last_y_position = 0;


// end leap motion

int PIXELS_PER_CUBE = 4;
int MAX_CUBES = 20 ; // this was set to only 16 before, caused exceptions
int MAX_LATTICE_VOLUME = 252;

//lattice space dimensions
int LSX = 6;
int LSY = 7;
int LSZ = 6;

OPCLowLevel opc;


int travelingIndex;
int time, oldTime;
int delay = 100;

Lattice lattice;

int [][][] latticeElements;


PVector handXYZ;

int[] cubeIndexCluster; 

void setup()
{
  size(800, 450);
  //added leap motion code, with gestures
  leap = new LeapMotion(this).withGestures();
  
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
  
  latticeElements[3][5][4] = 15;
  latticeElements[2][4][3] = 16;
  latticeElements[1][5][2] = 17;
  latticeElements[2][6][1] = 18;
  latticeElements[3][5][0] = 19;
  
  opc = new OPCLowLevel("127.0.0.1", 7890, MAX_CUBES * PIXELS_PER_CUBE);
  
  
// uncomment these if you want to disable either feature. See Dithering_Interpolation_Info tab for more
// opc.setDithering(false);
// opc.setInterpolation(false);
  
  allPixelsOff();
  
  lattice = new Lattice(LSX, LSY, LSZ, latticeElements, MAX_CUBES, PIXELS_PER_CUBE);

  // give each cube a single white LED at its root
  for (int i = 0; i < MAX_CUBES; i++)
  {
    lattice.getCubeAtIndex(i).setAnteriorRGB(255,255,255);
    lattice.getCubeAtIndex(i).setPosteriorRGB(0,0,255);
  }  
  
  lattice.printContents();
  
  cubeIndexCluster = new int[27];
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
int currentCubeIndex;
int cubeIndex = -1;


int iter = 0;

void draw()
{
    

  background(0);

  iter = 0;
  
//  numHands = leap.countHands();
  int dirx = 0;
  int diry = 0;
  
  float current_x_position;
  float current_y_position;
  
  int hand_id = 0;
  PVector handPosition = new PVector(0,0,0);
  
  PVector dirv = new PVector(0,0,0);
  
  PVector volumeXYZ = new PVector(0,0,0);
  
    for (Hand hand : leap.getHands()) 
    {
      if (iter < 2)
      {
 
        hand_id          = hand.getId();
        handPosition  = hand.getStabilizedPosition();
//        handPosition  = hand.getPosition();
  
        cubeHand_id[iter] = hand_id;
        cubeHand[iter] = leapNormalize(handPosition);
      
        current_x_position = handPosition.x;
        current_y_position = handPosition.y;
        //dirv = hand.getDirection();
        dirv.x = current_x_position - last_x_position;
        dirv.y = current_y_position - last_y_position;
      

// determine x direction 
//        println("dirv.x = " + dirv.x);
        if (dirv.x > 1)
        {
//           println("right");
          dirx = 1;
        }
        else if (dirv.x <= 1 && dirv.x >= -1)
        {
//        println("static");
          dirx = 0;
        }
        else //dirv.x < -1
        {
//          println("left");
          dirx = -1;
        }
        last_x_position = current_x_position;
      

/* maybe implement this later, as well as z direction input
// determine y direction 
        println("dirv.y = " + dirv.y);
        if (dirv.y > 1)
        {
//           println("right");
          dir_y = 1;
        }
        else if (dirv.y <= 1 && dirv.y >= -1)
        {
//        println("static");
          dir_y = 0;
        }
        else //dirv.x < -1
        {
//          println("left");
          dir_y = -1;
        }
        last_y_position = current_y_position;
      
      */
        
        if (cubeHand[0] != null)
        {
          volumeXYZ =  normalizedLeapToVolumeXYZ(cubeHand[0]);
        }
        
        //

///////////////////////// cube cluster selection code

        cubeIndexCluster = lattice.adjacentCubesXYZ(volumeXYZ);
        
        for (int i = 0; i < 80; i++)
        {
          if (cubeIndexCluster[i] > -1)
          { 
            currentCubeIndex = cubeIndexCluster[i];
            currentCube = lattice.getCubeAtIndex(currentCubeIndex);
          
            //if (currentCube != null)
            {
              currentCube.rotateForward();
              currentCube.loadPixelPacket(opc);              
            }
          }
        }
        opc.sendPixels();
        
  
        
///////////////////////////  single cube selection code 
/*
        currentCube = lattice.getCubeAtXYZ(volumeXYZ);
        //currentCube = lattice.getCubeAtIndex(0);
        
        if (currentCube != null)
        {
          currentCube.rotateForward();
          currentCube.loadPixelPacket(opc);
          opc.sendPixels();
        }
  */      
        
      

//      println ("num_hands: " + num_hands + ", hand 1 id = " + blinkyHand_id[0] + ", hand 2 id = " + blinkyHand_id[1]);
        iter++;
        currentCube = null;
      }
    }
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
        }        
      }
    }
}

//translate leap motion coordinates into lattice volume space coordinates
PVector normalizedLeapToVolumeXYZ(PVector leapHand)
{
  PVector xyz = new PVector(0,0,0);
  
  xyz.x = leapHand.x * LSX;// print("leapHand x = " + floor(xyz.x));
  xyz.y = leapHand.y * LSY;// print(", leapHand y = " + floor(xyz.y));
  xyz.z = leapHand.z * LSZ;// print(", leapHand z = " + floor(xyz.z) + "\n");
  
  return xyz;
}



// normalize leap motion position vector into a unit vector
PVector leapNormalize(PVector handPosition) {

  PVector v = new PVector(0, 0, 0);
  
  // xmin = -400 ~~~~ 10
  // xmax = 1300 ~~~~ 70
  // xrange = 1700 ~~ 60

  // normalize x position:
  v.x = (handPosition.x - 40) / 660;
//  println("handPosition.x = " + handPosition.x);

  // safeguard vector.x
  if (v.x >= 1)
  {
    v.x = .99;
  }
  else if (v.x < 0)
  {
    v.x = 0;
  }

  // ymin = -200 ~~ -40   ~ cubes -> 20
  // ymax = 450 ~~~ 90    ~ cubes -> 70
  // yrange = 650 - 130   ~ cubes -> 50

    // normalize y position:
  v.y =  1 - ((-1 * (50 - handPosition.y)) / 200);

//  println("handPosition.y = " + handPosition.y);
  
  // safeguard vector.y
  if (v.y >= 1)
  {
    v.y = .99;
  }
  else if (v.y < 0)
  {
    v.y = 0;
  }

  // zmin = -61
  // zmax = 190
  // zrange = 251

  // normalize z position:
  v.z = (handPosition.z - 10) / 70;
// println("handPosition.z = " + handPosition.z);

  // safeguard vector.z
  if (v.z >= 1)
  {
    v.z = .99;
  }
  else if (v.z < 0)
  {
    v.z = 0;
  }

  return v;
}










// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Available Leap Motion Gestures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// SWIPE GESTURE
void leapOnSwipeGesture(SwipeGesture g, int state){
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position         = g.getPosition();
  PVector   position_start   = g.getStartPosition();
  PVector   direction        = g.getDirection();
  float     speed            = g.getSpeed();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
//      println("SwipeGesture: "+id);
      break;
  }
}

// CIRCLE GESTURE
void leapOnCircleGesture(CircleGesture g, int state){
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position_center  = g.getCenter();
  float     radius           = g.getRadius();
  float     progress         = g.getProgress();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
//      println("CircleGesture: "+id);
      break;
  }
}

// SCREEN TAP GESTURE
void leapOnScreenTapGesture(ScreenTapGesture g){
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position         = g.getPosition();
  PVector   direction        = g.getDirection();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();

//  println("ScreenTapGesture: "+id);
}

// KEY TAP GESTURE
void leapOnKeyTapGesture(KeyTapGesture g){
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position         = g.getPosition();
  PVector   direction        = g.getDirection();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();
  
//  println("KeyTapGesture: "+id);
}
