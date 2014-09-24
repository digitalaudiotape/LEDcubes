// class to maintain a collection of Cubes in 3D space

public class Lattice
{
  int x, y, z;
  Cube[] cubes;
  int [][][] volumeXYZ; // array that holds indices of objects in the cubes array, organized by xyz coordinates
  
  
  // x y z for space dimensions
  public Lattice(int sx, int sy, int sz, int [][][] laticeElements, int maxCubes, int pixelsPerCube)
  {
    x = sx;
    y = sy;
    z = sz;
 
    volumeXYZ = new int[x][y][z];
    
    // set all elements in 3D array as -1 so that any value 0 and above will be recognized as a registered cube  
//    clearVolumeXYZ();
    
    // the index of the first LED in linear coordinates
    int root;
    
    // initialize the cubes in the Cube array
    cubes = new Cube[maxCubes];
    for (int i = 0; i < maxCubes; i++)
    {
      root = i * pixelsPerCube;
      cubes[i] = new Cube(root, root + 1, root + 2, root + 3); 
    }

   volumeXYZ = laticeElements;
    
   
  }
    
  void printContents()
  {
 
    //print out contents of cubeIndicies:
    for (int i = 0; i < x; i++)
    {
      for (int j = 0; j < y; j++)
      {
        for (int k = 0; k < z; k++)
        {
          println(i + ", " + j + ", " + k + ": " + volumeXYZ[i][j][k]);
        } 
      }
    }
  
  }
  
  Cube getCubeAtXYZ(int x, int y, int z)
  {
    int index = volumeXYZ[x][y][z];
    // if there exists an index, return the cube at the index stored at x,y,z
    if (index < 0)
      return null;
    else
      return cubes[index];
  }
  
  int getCubeIndexAtXYZ(int x, int y, int z)
  {
    return volumeXYZ[x][y][z];
  }
  
  Cube getCubeAtIndex(int i)
  {
   return cubes[i]; 
  }
  

// set all elements in 3D array as -1 so that any value 0 and above will be recognized as a registered cube  
  void clearVolumeXYZ ()
  {
      // initialize volume as empty
    for (int i = 0; i < x; i++)
    {
      for (int j = 0; j < y; j++)
      {
        for (int k = 0; k < z; k++)
        {
         volumeXYZ[i][j][k] = -1; 
         println(" should equal -1: " + volumeXYZ[i][j][k]);
        }        
      }
    }
  }
}
