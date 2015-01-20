// Class to draw one cube at a time

// Each cube has 4 pixels, arranged in positions, anterior (1), superior (2), posterior (3), inferior (4)

// Initialize each cube with a mapping to linear dimension along LED strip

public class Cube
{
  Pixel anterior, superior, posterior, inferior;
  
  float life;
  
  // initialize cube 4 pixel objects with default color of black
  public Cube(int a, int s, int p, int i)
  {
    anterior = new Pixel(a, 0, 0, 0);
    superior = new Pixel(s, 0, 0, 0);
    posterior = new Pixel(p, 0, 0, 0);
    inferior = new Pixel(i, 0, 0, 0);
    
    life = 1.0;
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
  
  // cube life functions
  
   void setLife(float l) { life = l; }
   
   float getLife() { return life; }
  
   void incLife(float inc)
   {
    life = life + inc;
    if (life > 1.0)
    {
     life = 1.0;
    }
   } 
   
   void decLife(float dec)
   {
     life = life - dec;
     if (life < 0.0)
     {
       life = 0;
     }
   }
   
     // Load cube pixels into the current pixel packet
  void loadPixelPacketLife(OPCLowLevel opc)
  {
    //read and load each cube pixel
    anterior.loadPixelLife(opc, life);
    superior.loadPixelLife(opc, life);
    posterior.loadPixelLife(opc, life);
    inferior.loadPixelLife(opc, life);
  }
}
