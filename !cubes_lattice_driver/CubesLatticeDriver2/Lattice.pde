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
  
  Cube getCubeAtXYZ(PVector xyz)
  { 

    int index = getCubeIndexAtXYZ(xyz);
    // if there exists an index, return the cube at the index stored at x,y,z
    println("attempting to get cube at: " + (int)xyz.x + ", " + (int)xyz.y + ", " + (int)xyz.z);
    if (index < 0)
      return null;
    else
    {
      println("cube with index " + index + " found at " + (int)xyz.x + ", " + (int)xyz.y + ", " + (int)xyz.z);
      return cubes[index];
    }
  }
  
  int getCubeIndexAtXYZ(PVector xyz)
  {
    PVector v = coordinateFiltering(xyz);
    return volumeXYZ[(int)v.x][(int)v.y][(int)v.z];
  }
  
  // input a normalized vector to get indices for the volume 3D array
  PVector coordinateFiltering(PVector xyz)
  {
    PVector v = new PVector (xyz.x, xyz.y, xyz.z);
    if (v.x > 5)
    {
      v.x = 5;
    }
    else if (v.x < 0)
    {
      v.x = 0;
    }
    
    else if (v.y > 6)
    {
      v.y = 6;
    }
    else if (v.y < 0)
    {
      v.y = 0;
    }
    
    else if (v.z > 5)
    {
      v.z = 5;
    }
    else if (v.z < 0)
    {
      v.z = 0;
    }
    
    v.x = floor(v.x);
    v.y = floor(v.y);
    v.z = floor(v.z);
    
    return v;
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
        }        
      }
    }
  }
  
  //return all the cube indexes adjacent to an XYZ coordinate that correspont to a real cube
  // in an array of 27 ints
  int[] adjacentCubesXYZ(PVector xyz)
  {
    int clusterIndex = 0;
    int[] cluster = new int[100];
    
    for (int i= 0; i < 100; i++)
    {
      
      cluster[i] = -2;
    }
    
    println("testing for adjacent cubes at "+ (int)xyz.x + ", " + (int)xyz.y + ", " + (int)xyz.z);
    
    PVector v = new PVector(0, 0, 0);
    
    for (int i = (int)xyz.x - 1; i <= (int)xyz.x + 1; i++)
    {
      for (int j = (int)xyz.y - 1; j <= (int)xyz.y + 1; j++)
      {
        for (int k = (int)xyz.z - 1; k <= (int)xyz.z + 1; k++)
        {
          clusterIndex = (i*9) + (j*3) + k;
          // make sure the spot we're testing is within the volume bounds
            if (clusterIndex < 100 && i >= 0 && i < x && j >= 0 && j < y && k >= 0 && k < z)
            {
              v.x = i;
              v.y = j;
              v.z = k;
              
              cluster[clusterIndex] = getCubeIndexAtXYZ(v);
              
              //debugging statement
             if (cluster[clusterIndex] > -1)
             {
               //println("cube index: " + clusterIndex + " added to cluster at: " + (int)v.x + ", " + (int)v.y + ", " + (int)v.z);
             } 
            }
          }
        }
    }

/*    
    print("cluster contents: ");
    for (int i = 0; i < 100; i++)
    {
     print(cluster[i] + " ");
    }
    println("");
*/    
    
    return cluster;
  }
    
  
}
