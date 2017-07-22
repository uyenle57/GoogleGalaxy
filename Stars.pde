/// STARS VARIABLES
int       depth = 8;
int       starsMax = 200;
Stars[]   tabStars = new Stars[starsMax];
int       maxSpeed = 8;

int       rotationMode = 3;
float     angle = 0;
float     delta = radians(0.5);
///

float rotax = 0; //variable for rotation on X axis
float rotaz = 0; //variable for rotation on Z axis

//Three variables for movements in 3D space
float bobA = 0;
float bobB = 0;
float bobC = 0;

class Stars {
  float x, y, z;
  float dZ;
  
  Stars(float coordX, float coordY, float coordZ, float speedZ) {
    x  = coordX;  
    y  = coordY;  
    z  = coordZ;  
    dZ = speedZ;
  }
  
  void aff() {
    stroke(250+z/depth,300);
    point(x,y,z);
  }
  
  void anim() {
    z = z + dZ;
    if(z>=0)
      z = -1023.0;
  }
}
