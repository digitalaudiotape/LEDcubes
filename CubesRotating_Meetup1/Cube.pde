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
    
    speed = 1;
    
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
  
  boolean rotateForward(int currentTime) // rotates the colors of the LEDs one step forward, towards the viewer
  {
    boolean rotated = false;
    color temp;
    //int currentTime = millis();
    
    // check time against rotation speed to know if it's time to rotate again
    if (currentTime - timeOfLastRotation >= speedToTime(speed))
    {
    
      temp = anterior.getColor();
      
      anterior.setColor(superior.getColor());
      superior.setColor(posterior.getColor());
      posterior.setColor(inferior.getColor());
  
      inferior.setColor(temp);
      
      timeOfLastRotation = currentTime;
      
      rotated = true;
    }
    
    return rotated;
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
  
  // cube life functions
  
   void setSpeed(int s) { speed = s; }
   
   float getSpeed() { return speed; }
  
   void incSpeed(int currentTime)
   {
      if(currentTime - timeOfLastSpeedIncrease >= 400) // slow increase of speed so it is more gradual and noticable
      {
        speed = speed + 1;
        if (speed > 6)
        {
         speed = 6;
        }
        //println("Speed increased to : " + speed);
      }
   } 
   
   void decSpeed()
   {
     speed = speed - 1;
     if (speed < 1)
     {
       speed = 1;
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
}
