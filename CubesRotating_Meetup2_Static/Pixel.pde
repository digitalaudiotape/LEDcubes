// Pixel format data that goes into each pixel

// RGB values are stored as individual INTs

// There are methods to access the RGB values as color datatypes

public class Pixel
{  
  int index;
  int sampleIndex;
  int red, green, blue;

  Pixel (int i, int r, int g, int b)
  {
    index = i;
    sampleIndex = i;
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
  
  void setSampleIndex(int i) { sampleIndex = i; }
  void setR(int r) { red = r; }
  void setG(int g) { green = g; }
  void setB(int b) { blue = b; }
  
  int getSampleIndex() { return sampleIndex; }
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
  
    void loadPixelLife(OPCLowLevel opc, float life)
  {
    //opc stuff goes here 
    opc.setPixel(index, (int)((float)red * life), (int)((float)green * life), (int)((float)blue * life));
  }
  
  //load a pixel into the current pixel packet to be sent
  void loadPixelSample(OPCLowLevel opc, Samples sample)
  {
    color c = sample.getColorAtIndex(sampleIndex);
          
    //opc stuff goes here 
    opc.setPixel(sampleIndex, (int)red(c), (int)green(c), (int)blue(c));
  }
  
  void loadPixelSampleLife(OPCLowLevel opc, Samples sample, float life)
  {
    color c = sample.getColorAtIndex(sampleIndex);
    //opc stuff goes here 
    opc.setPixel(sampleIndex, (int)((float)red(c) * life), (int)((float)green(c) * life), (int)((float)blue(c) * life));
  }

}
