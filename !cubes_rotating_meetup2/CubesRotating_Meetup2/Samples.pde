/*

Array to store image samples

*/

private class Samples
{
  int size;
  private color[] colors;
    
  
  public Samples (int s)
  {
    size = s;
    colors = new color[size];
  }
    
  color getColorAtIndex(int i)
  {
   return colors[i]; 
  }
   
  void setColorAtIndex(int i, color c)
  {
    colors[i] = c;
  }
  
  void update(color[] display, int height, int width)
  {
    int margin = 10; // Number of pixels away from the edge of the window
    float spacing = (width - (2 * margin)) / size;
    int index = 0;
    
    // load an entire array of samples at once from what is displayed in the current window
    for(int i = 0; i < size; i++)
    {
      // sample the display pixels[] array for the size of the sampling array
      index = ((int)(height * width)/2 + margin) + (i * (int)spacing);
      //println("index before crashing = " + index);
      
      if (display != null)
      {
        colors[i] = display[index];
        //println("display not null!!");
      }     
    }
  }
  
}
