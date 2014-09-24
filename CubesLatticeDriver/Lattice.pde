// class to maintain a collection of Cubes in 3D space

public class Lattice
{
  int x, y, z;
  Cube[] cubes;
  int [][][] cubeIndices; // array that holds indices of objects in the cubes array, organized by xyz coordinates
  
  
  // x y z for space dimensions
  public Lattice (int sx, int sy, int sz, int [][][] laticeElements, int maxCubes, int pixelsPerCube)
  {
    x = sx;
    y = sy;
    z = sz;
 
    cubeIndices = new int[x][y][z];
    clearIndices();
    
    // the index of the first LED in linear coordinates
    int root;
    
    // initialize the cubes in the Cube array
    cubes = new Cube[maxCubes];
    for (int i = 0; i < maxCubes; i++)
    {
      root = i * pixelsPerCube;
      cubes[i] = new Cube(root, root + 1, root + 2, root + 3); 
    }
     
    cubeIndices = laticeElements; 
  }
  
  
  Cube getCubeAtPos(int x, int y, int z)
  {
    int index = cubeIndices[x][y][z];
    // if there exists an index, return the cube at the index stored at x,y,z
    if (index < 0)
      return null;
    else
      return cubes[index];
  }
  
  Cube getCubeAtIndex(int i)
  {
   return cubes[i]; 
  }
  

// set all elements in 3D array as -1 so that any value 0 and above will be recognized as a registered cube  
  void clearIndices ()
  {
      // initialize cubeIndices as empty
    for (int i = 0; i < x; i++)
    {
      for (int j = 0; j < y; j++)
      {
        for (int k = 0; k < z; k++)
        {
         cubeIndices[i][j][k] = -1; 
        }        
      }
    }
  }
}
