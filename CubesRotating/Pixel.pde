// Pixel format data that goes into each pixel

// RGB values are stored as individual INTs

// There are methods to access the RGB values as color datatypes

public class Pixel
{  
  int index;
  int red, green, blue;

  Pixel (int i, int r, int g, int b)
  {
    index = i;
    red = r;
    green = g;
    blue = b;
  }
  
  void setRGB(int r, int g, int b)
  {
    red = r;
    green = g;
    blue = b;
  }
  
  void setR(int r) { red = r; }
  void setG(int g) { green = g; }
  void setB(int b) { blue = b; }
  
  int getR() { return red; }
  int getG() { return green; }
  int getB() { return blue; }
  
  void setColor(color c)
  {
    red = (int)red(c);
    green = (int)green(c);
    blue = (int)blue(c);
  }
  
  color getColor()
  {
    return color(red, green, blue); 
  }

  //load a pixel into the current pixel packet to be sent
  void loadPixel(OPCLowLevel opc)
  {
    //opc stuff goes here 
    opc.setPixel(index, red, green, blue);
  }

}
