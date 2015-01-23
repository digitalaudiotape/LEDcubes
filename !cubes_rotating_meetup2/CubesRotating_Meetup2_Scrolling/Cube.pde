// Class to draw one cube at a time

// Each cube has 4 pixels, arranged in positions, anterior (1), superior (2), posterior (3), inferior (4)

// Initialize each cube with a mapping to linear dimension along LED strip

public class Cube
{
  private Pixel anterior, superior, posterior, inferior;
  
  int speed, timeOfLastRotation, timeOfLastSpeedIncrease;
  
  // initialize cube 4 pixel objects with default color of black
  public Cube(int a, int s, int p, int i)
  {
    anterior = new Pixel(a, 0, 0, 0);
    superior = new Pixel(s, 0, 0, 0);
    posterior = new Pixel(p, 0, 0, 0);
    inferior = new Pixel(i, 0, 0, 0);
    
    speed = 0; // range between -6 and 6
    
    timeOfLastRotation = millis();
    timeOfLastSpeedIncrease = millis();
  }
    
  void setAnteriorRGB(int r, int g, int b) { anterior.setRGB(r, g, b); }
  void setSuperiorRGB(int r, int g, int b) { superior.setRGB(r, g, b); }  
  void setPosteriorRGB(int r, int g, int b) { posterior.setRGB(r, g, b); }
  void setInferiorRGB(int r, int g, int b) { inferior.setRGB(r, g, b); }
  
  void setAnteriorColor(color c){ anterior.setColor(c); }
  void setSuperiorColor(color c){ superior.setColor(c); }
  void setPosteriorColor(color c){ posterior.setColor(c); }
  void setInferiorColor(color c){ inferior.setColor(c); }
  
  color getAnteriorColor(){ return anterior.getColor(); }
  color getSuperiorColor(){ return superior.getColor(); }
  color getPosteriorColor(){ return posterior.getColor(); }
  color getInferiorColor(){ return inferior.getColor(); }
  
  Pixel getAnterior(){ return anterior; }
  Pixel getSuperior(){ return superior; }
  Pixel getPosterior(){ return posterior; }
  Pixel getInferior(){ return inferior; }
  
  // Load cube pixels into the current pixel packet
  void loadPixelPacket(OPCLowLevel opc)
  {
    //read and load each cube pixel
    anterior.loadPixel(opc);
    superior.loadPixel(opc);
    posterior.loadPixel(opc);
    inferior.loadPixel(opc);
  }
  
  boolean rotate(int currentTime) // rotates the colors of the LEDs one step forward, towards the viewer
  {
    boolean rotated = false;
    color temp;
    //int currentTime = millis();
    
    // check time against rotation speed to know if it's time to rotate again
    if (currentTime - timeOfLastRotation >= speedToTime(abs(speed)))
    {
      if (speed > 0)
      {
        this.rotateForward();
      }
      else if (speed < 0)
      {
        this.rotateBack();
      }
      
      timeOfLastRotation = currentTime;
      
      rotated = true;
    }
    
    return rotated;
  }
  
  boolean rotateSampleIndex(int currentTime) // rotates the colors of the LEDs one step forward, towards the viewer
  {
    boolean rotated = false;
    color temp;
    //int currentTime = millis();
    
    // check time against rotation speed to know if it's time to rotate again
    if (currentTime - timeOfLastRotation >= speedToTime(abs(speed)))
    {
      if (speed > 0)
      {
        this.rotateSampleIndexForward();
      }
      else if (speed < 0)
      {
        this.rotateSampleIndexBack();
      }
      
      timeOfLastRotation = currentTime;
      
      rotated = true;
    }
    
    return rotated;
  }
  
  void rotateForward() // rotates the colors of the LEDs one step forward, towards the viewer
  {
    color temp;
    
    temp = anterior.getColor();
    
    anterior.setColor(superior.getColor());
    superior.setColor(posterior.getColor());
    posterior.setColor(inferior.getColor());

    inferior.setColor(temp);
  }
  
  void rotateBack() // rotates the colors of the LEDs one step backward, away from the viewer
  {
    color temp;
    
    temp = inferior.getColor();
    
    inferior.setColor(posterior.getColor());
    posterior.setColor(superior.getColor());
    superior.setColor(anterior.getColor());

    anterior.setColor(temp);
  }
  
  void rotateSampleIndexForward() // rotates indices of pixels in strip space one step forward within a cube
  {
    int temp;
    
    temp = anterior.getSampleIndex();
    
    anterior.setSampleIndex(superior.getSampleIndex());
    superior.setSampleIndex(posterior.getSampleIndex());
    posterior.setSampleIndex(inferior.getSampleIndex());
    
    inferior.setSampleIndex(temp);
  }
  
  void rotateSampleIndexBack() // rotates indices of pixels in strip space one step forward within a cube
  {
    int temp;
    
    temp = inferior.getSampleIndex();
    
    inferior.setSampleIndex(posterior.getSampleIndex());
    posterior.setSampleIndex(superior.getSampleIndex());
    superior.setSampleIndex(anterior.getSampleIndex());
    
    anterior.setSampleIndex(temp);
  }
  
  // cube life functions
  
   void setSpeed(int s) { speed = s; }
   
   float getSpeed() { return speed; }
  
   void incSpeed(int currentTime)
   {
      if(currentTime - timeOfLastSpeedIncrease >= 20) // slowing the acceleration so it is more gradual and noticable
      {
        speed = speed + 1;
        if (speed > 6)
        {
         speed = 6;
        }
        //println("Speed increased to : " + speed);
        
        timeOfLastSpeedIncrease = currentTime;
      }
   } 
   
   void decSpeed(int currentTime)
   {
      if(currentTime - timeOfLastSpeedIncrease >= 20) // slowing the acceleration so it is more gradual and noticable
      {
        speed = speed - 1;
        if (speed < -6)
        {
         speed = -6;
        }
        //println("Speed decreased to : " + speed);
        timeOfLastSpeedIncrease = currentTime;
      }
   } 
   
   void slowSpeed()
   {
     if (speed > 0)
     {
       speed = speed - 1;
       if (speed < 0)
       {
         speed = 0;
       }
     }
     else if (speed < 0)
     {
       speed = speed + 1;
       if (speed > 0)
       {
         speed = 0;
       }
     }
   }
   
     // Load cube pixels into the current pixel packet
  void loadPixelPacketLife(OPCLowLevel opc, float life)
  {
    
    //read and load each cube pixel
    anterior.loadPixelLife(opc, life);
    superior.loadPixelLife(opc, life);
    posterior.loadPixelLife(opc, life);
    inferior.loadPixelLife(opc, life);
  }
  
  //return the necessary amount of elapsed time to do the next rotation
  int speedToTime(int s)
  {
    int t = 0;
    switch (s)
    {
      case 0:
        t = 1000000; // 11 days
        break;
      
      case 1:
        t = 1000;
        break;
      
      case 2:
        t = 500;
        break;
      
      case 3:
        t = 250;
        break;
      
      case 4:
        t = 125;
        break;
      
      case 5:
        t = 62;
        break;
      
      case 6:
        t = 31;
        break;
      
    }
    
    return t;
  } 
  
  
  // Load cube pixels into the current pixel packet
  void loadPixelPacketSample(OPCLowLevel opc, Samples sample)
  {
    
     // load the color for each pixel sample index in each cube
    anterior.loadPixelSample(opc, sample);
    superior.loadPixelSample(opc, sample);
    posterior.loadPixelSample(opc, sample);
    inferior.loadPixelSample(opc, sample);
  }
  
    // Load cube pixels into the current pixel packet
  void loadPixelPacketSampleLife(OPCLowLevel opc, Samples sample, float life)
  {
    
     // load the color for each pixel sample index in each cube
    anterior.loadPixelSampleLife(opc, sample, life);
    superior.loadPixelSampleLife(opc, sample, life);
    posterior.loadPixelSampleLife(opc, sample, life);
    inferior.loadPixelSampleLife(opc, sample, life);
  }
}
