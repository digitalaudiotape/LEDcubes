/*
 *
 * Class to translate linear LEDs to cubes in 3D space, with Leap Motion support
 * This version gives each cube a life variable, which is reset to 1 when chosen
 * through the leap motion input
 * 
 * Dat Phan January 2015 
 */

//added leap motion code
import de.voidplus.leapmotion.*;

LeapMotion leap;

int ticker = 0;

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


int delay = 1000;

int fadeDelay = 30;
int lastFadeTime;

Cube[] cubes;

Lattice lattice;

int [][][] latticeElements;


PVector handXYZ;

int[] cubeIndexCluster; 

// Image sampling code
PImage im;

Samples samples;

// end sampling code

void setup()
{
  
  // Image sampling code
  size(800, 200);
  background(0);
  im = loadImage("rainbow7.jpeg");
//  im = loadImage("flames.jpeg");
//  im = loadImage("yellow.jpeg");

  
  samples = new Samples(MAX_CUBES * PIXELS_PER_CUBE);
  // End image sampling code
  
  
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
  

 
  allPixelsOff();
  
  lattice = new Lattice(LSX, LSY, LSZ, latticeElements, MAX_CUBES, PIXELS_PER_CUBE);

 
  cubeIndexCluster = new int[125];
  
// end lattice setup

// rotating cube colors setup
  int root;
  
  for (int i = 0; i < MAX_CUBES; i++)
  {   
    
/*    lattice.getCubeAtIndex(i).setAnteriorRGB(255, 255, 255);
    lattice.getCubeAtIndex(i).setSuperiorRGB(255, 0, 0);
    lattice.getCubeAtIndex(i).setPosteriorRGB(0, 255, 0);
    lattice.getCubeAtIndex(i).setInferiorRGB(0, 0, 255);
  */  
    
    /*lattice.getCubeAtIndex(i).setAnteriorRGB(255, 0, 0);
    lattice.getCubeAtIndex(i).setSuperiorRGB(255, 0, 0);
    lattice.getCubeAtIndex(i).setPosteriorRGB(0, 0, 255);
    lattice.getCubeAtIndex(i).setInferiorRGB(0, 0, 255);
    */
    lattice.getCubeAtIndex(i).loadPixelPacket(opc);
    opc.sendPixels();
  }

// end rotating cube colors setup
  
  time = millis();
  oldTime = time;
  lastFadeTime = time;
  
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

int lastHandDirection; // -1 is left, +1 is right

int iter = 0;

void draw()
{
  time = millis();
  
// Image sampling code
  // Scale the image so that it matches the width of the window
  int imHeight = im.height * width / im.width;

  // Scroll down slowly, and wrap around
  float speed = 0.05;
  float y = (millis() * -speed) % imHeight;
  
  // Use two copies of the image, so it seems to repeat infinitely  
  image(im, 0, y, width, imHeight);
  image(im, 0, y + imHeight, width, imHeight);
  
  loadPixels();
//  println("pixels[0] is r: " + red(pixels[0]) + " g: " + green(pixels[0]) + " b: " + blue(pixels[0]));
  samples.update(pixels, height, width);
  
    
  
// End image sampling code  

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
        if (dirv.x > 0)
        {
           //println("right");
          dirx = 1;
        }
        else if (dirv.x <= 1 && dirv.x >= -1)
        {
//        println("static");
          dirx = 0;
        }
        else //dirv.x < -1
        {
          //println("left");
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
              time = millis();
              if (dirx < 0)
              {
                 currentCube.incSpeed(time);
                 lastHandDirection = -1;
              }
              else if (dirx > 0)
              {
                 currentCube.decSpeed(time);
                 lastHandDirection = 1; 
              }
              
              // code to repeat the previous direction if hand is still "touching" cubes
              
              /*else
              {
                if (lastHandDirection == -1)
                {
                  currentCube.incSpeed(time);
                }
                else if (lastHandDirection == 1)
                {
                  currentCube.decSpeed(time); 
                }
              }*/
                       
            }
          }
        }
       

//      println ("num_hands: " + num_hands + ", hand 1 id = " + blinkyHand_id[0] + ", hand 2 id = " + blinkyHand_id[1]);
        iter++;
        currentCube = null;
      }
    }
    
    
    // outside of leap motion for-loop
    
    // check every cube each draw iteration to see if each needs to be rotated
//    if (time - lastFadeTime > fadeDelay)
    {
      for (int i = 0; i < MAX_CUBES; i++)
      { 
          currentCube = lattice.getCubeAtIndex(i);
          //if(currentCube.rotate(time))
          if(currentCube.rotateSampleIndex(time))
          {
//            println("cube at index: " + i);
            currentCube.loadPixelPacketSample(opc, samples);
            // speed needs to absolute value for translating to brightness
  //          currentCube.loadPixelPacketLife(opc, ((float)abs(currentCube.getSpeed()) + 14.0)/20.0); 
  
//            currentCube.loadPixelPacketSampleLife(opc, samples, ((float)abs(currentCube.getSpeed()) + 14.0)/20.0);
            opc.sendPixels();
//            println(ticker + " :sending pixels now");    
          }
      }
      
      lastFadeTime = time;
    }
    
    // end cube rotation code
    
    // decrement the rotation speed for all the cubes in the lattice after every second
//    time = millis();
    if (time - oldTime > delay)
    {
      for (int i = 0; i < MAX_CUBES; i++)
      {
        lattice.getCubeAtIndex(i).slowSpeed();
      }
      oldTime = time;
      ticker++;
    }     
    
    //commit the current state of all the cubes to fadecandy
    /*
    for (int i = 0; i < MAX_CUBES; i++)
      { 
          currentCube = lattice.getCubeAtIndex(i);
    
          //currentCube.loadPixelPacketSample(opc, samples);
          currentCube.loadPixelPacketSampleLife(opc, samples, ((float)abs(currentCube.getSpeed()) + 14.0)/20.0);
      }
    opc.sendPixels();
    */
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
