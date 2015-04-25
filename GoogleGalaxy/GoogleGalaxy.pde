//GOOGLE GALAXY

//Creative Projects CC6: 27 April 2015

//Akira Fiorentino, Uyen Le, Takunda Karima, Shelby Malinski

//Please allow a moment for the program to load.

boolean fullscreen = true; //highly recommended!

//import ocd camera library
import damkjer.ocd.*;
Camera camera1;
Camera camera2;

//import minim
import ddf.minim.*;
Minim minim;
AudioPlayer bgm;

float position[]=new float[3]; //this array will store the x,y,and z of the player.

boolean rotatin = false; //orbiting around the sun, toggled by the 'U' key.
int textvar = 0; //current text status

boolean showIntro = true; //show the introduction image
PImage intro;

//Moving stats
float speed = 2;
float slowdown = 1.04;
float maxspeed = 100;

PFont f;
boolean input=false;
// Variable to store text currently being typed
String typing = "";

// Variable to store saved text when return is hit
String saved = "";
/////////////////////////

int indent; //text indentation

//example words, picked randonly at the start of the program
String [] terms = {"pattern","texture","color","rainbow","carpet","terrain","earth","gradient","colorful","pixels","abstractism","impressionist","cats",
"dogs","dolphins","sea","lava","surface","art","nature","sky","sunrise","sunset","tropical","exotic","landscape","liquid","flowers","redish",
"bluish","yellowish","turquoise","greenish","azure","purplish","pinkish","brownish","orangy","gold","steel","aquatic","clouds","effects",
"vegetation","jungle","forest","rainforest","view","beautiful","panorama","lime","fruit","vegetables","food","drinks","cocktails","code","happy","sad",
"hallucinating","hallucinations","illusion","optical","swirly","zigzag","polkadots","striped","cloth","color combinations","space",
"galaxy","nebula","stars","milkyway","andromeda","infinite","cosmic","microchip","8bit","retrogames","scene","scenery","photo","wallpaper", "swamp",
"sapphire","ruby","emerald","silver","ocean","painting","paint","watercolour","water","bronze","alien","checkered","beautiful color combinations",
"shades of color","color patterns","color gradients","mixed colors","colorful terrain","bookshelf","color reflections","artwork","dali","klimt",
"monet","manet","cezanne","kandinskij","album covers","malevich","abstract art","picasso","bolotowsky","gleizes","delaunay","matisse","kupka","schwitters",
"arthur dove","picabia","joseph csaky","mondrian","paul klee","barnett newman","fernand leger","van doesburg","forest game","kermit","mountains"};

String searchTerm = "pattern";
int numofResults = 64;   // choose a multiple of four

int high[]=new int[numofResults]; //height of img
int wide[]=new int[numofResults]; //width of img

String[] imgUrls = new String[0];
String[] links = new String[0];
JSONArray results; 
JSONObject response;
////////////////////////

PImage [] img = new PImage[16]; //dictates the maximum number of planets
int [] usedlinks = new int [img.length]; //for checking duplicates

/////PLANETS
int [] randX = new int[img.length]; //random X, Y and Z offsets
int [] randY = new int[img.length]; 
int [] randZ = new int[img.length];
float [] sizer = new float[img.length]; //size of planet
boolean [] moon = new boolean[img.length]; //if a planet is a moon or not (moons are currently disabled)
float []orbitvar = new float[img.length]; //orbiting speed of the planet
////


boolean moons = false;
//if true, some planets will become moons, meaning they are smaller and rotate around a bigger planet.

boolean checkPos = false;
//if true, program makes sure no planets are overlapping eachother (slightly slower loading time).


//booleans for checking image compatibility.
boolean ok1=false;
boolean ok2=false;

//link to be used
int rlink;

//Fun facts (currently not used)
String[] funfacts = new String[8];  //array of strings of 8 fun facts
int index = 0;  //variable to display first funfact

boolean sketchFullScreen() {
  return fullscreen;
}

void setup() {

  if(fullscreen)
    size(displayWidth,displayHeight, P3D);
  else
    size(900, 700, P3D);
  
  noCursor();
  
  f = createFont("Arial",12,true);
  
  intro = loadImage("intro.png"); //introduction image
  
  minim = new Minim(this);
  bgm = minim.loadFile("dome.mp3"); //background music
  //bgm.rewind();
  
  //2 cameras
  //camera1 is the main camera of the player.
  //camera2 is for the stars in the bacground, which move slower, giving the illusion of distance.
  camera1 = new Camera(this, width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0), PI/3, (width/1.2)/height, 1, 100000);
  camera2 = new Camera(this, width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0), PI/3, (width/1.2)/height, 1, 100000);
  
  for(int i=0; i<starsMax; i++)
  {    // Initialise array of stars
    tabStars[i] = new Stars(random(-7*width,7*width)/random(1,6),random(-7*height,7*height)/random(1,6),
                             -random(depth*255),random(1,maxSpeed));
  }
  ///
  
  //number of vertices around the width and height
  ptsW=30;
  ptsH=30;
  initializeSphere(ptsW, ptsH);
  
  //Fun facts WOOO
  //Doesn't work as the program freezes when loading/searching
  funfacts[0] = "Did you know that the Solar system's age is 4.6 billion years?";
  funfacts[1] = "There are approximately 200-400 billion stars in the Galaxy.";
  funfacts[2] = "All objects (planets, moons, asteroids,...) orbit around the Sun due to gravity.";
  funfacts[3] = "Stars have different colours: red, white, blue. Hot stars look blue and cool stars look white!";
  funfacts[4] = "Did you know that the Earth is the only planet not named after a God?";
  funfacts[5] = "Up to one million Earths could fit inside the Sun! Woah!";
  funfacts[6] = "One day on Mercury equals 58 days on Earth!";
  funfacts[7] = "The Sun takes up to 99% of the solar system's mass! No wonder why it's huge here!";
}

void draw() {
    
  background(8);
  if(frameCount==1) //loading display for first frame
  {
    if(fullscreen)
      indent = 200;
    else
      indent = 100;
    textFont(f);
    fill(200);
    text("LOADING...", width/2-33, height/2-2);
  }
  
  else if(frameCount==2) //run first search on second frame
  {
    searchTerm = terms[(int)random(0,terms.length)]; //pick random searchterm at start
    position = camera1.position(); //get player position
    go();
  }
  else
  {
      
    lights();
    smooth();
    
    bgm.play();  //play music
    
    /// STARS UPDATE
    pushMatrix();
    camera2.dolly(-bobA/8); //stars camera movement is slowed down to give illusion of distance
    camera2.truck(-bobB/8);
    camera2.boom(-bobC/8);
    camera2.feed();
    fill(255);
    strokeWeight(3);
    if(rotationMode==1) {
      angle += delta;
    }
    if(rotationMode==2) {
      angle -= delta;
    }
    rotateZ(angle);
    for(int i=0; i<starsMax; i++) {
      tabStars[i].aff();
      tabStars[i].anim();
    }
    popMatrix();
    ///
   
   ///PLANETS UPDATE
   if(true)
   {
    
    if(rotatin==true)
    {
      rotaz += 0.005; //orbit around the sun
    }
    
    rotax += 0.005; //rotation around self
    
    noFill();
    strokeWeight(0);
    
    //MOVEMENT CONTROLS
    if((keyPressed==true)&&(input==false))
      {
       if(key=='w')
       {
        bobA+=speed; //zoom in
       }
       else if(key=='s')
       {
        bobA-=speed; //zooooom out
       }
       else
       {
        bobA=bobA/slowdown;
       }
       if(key=='a')
       {
        bobB+=speed; //move left
       }
       else if(key=='d')
       {
        bobB-=speed; //move right
       }
       else
       {
        bobB=bobB/slowdown;
       }
       if(key=='r')
       {
        bobC+=speed; //move up
       }
       else if(key=='f')
       {
        bobC-=speed; //move down
       }
       else
       {
        bobC=bobC/slowdown;
       }
      }
     else ////slow down
      {
       bobA=bobA/slowdown;
       bobB=bobB/slowdown;
       bobC=bobC/slowdown;
      }
      
      ////limiting the speed to maximum of 40
     if(bobA>maxspeed)
      bobA=maxspeed;
     else if(bobA<-maxspeed)
      bobA=-maxspeed;
     if(bobB>maxspeed)
      bobB=maxspeed;
     else if(bobB<-maxspeed)
      bobB=-maxspeed;
     if(bobC>maxspeed)
      bobC=maxspeed;
     else if(bobC<-maxspeed)
      bobC=-maxspeed;
    
    pushMatrix();
    camera1.dolly(-bobA);
    camera1.truck(-bobB);
    camera1.boom(-bobC);
    camera1.feed();
    
    for(int i=0;i<img.length;i++)
    {   
      pushMatrix();
      
      //orbit around SUN
      if(i>0) //if not the sun
      {
        translate(randX[0],randY[0],randZ[0]);
        rotateY(rotaz/orbitvar[i]);
      }
  
      ///////MOONS UPDATE (disabled)
      if((i>0)&&(moons))
      {
        
        if(moon[i]==true) ///////if the planet is a moon.
        {
          if(i%3==0)
            rotateX(rotax*2);
          else if(i%3==1)
            rotateY(rotax*2);
          else
            rotateZ(rotax*2);
        }
      }
  
      translate(width/2+randX[i], height/2+randY[i], randZ[i]);
      rotateY(rotax);
      scale(sizer[i]);
      if(sizer[i] != 0) //if size is zero dont draw planet
        textureSphere(200, 200, 200, img[i]);
      popMatrix();
    }
    popMatrix();
   }
   
   ///TEXT UPDATE
   textFont(f);
   fill(200);
  
   if(textvar==0)
   {
     if(input==false)
       text("Press Enter to start typing.", indent, 40);
     else
       text("Typing enabled. \n Press Enter to start the search!", indent, 40);
   }
   else
   {
     text("Searching...", indent, 40);
   }
   
   text(typing,indent,90);
   text(saved,indent,130);
   
   if(textvar==1)
   {
     textvar = 2;
   }
   else if(textvar==2)
   {
     saved = typing;
     searchTerm = typing;
     typing = ""; //clear string
     go();
     input=false;
   }
   
   if(showIntro) //intro image
     //intro.resize(width, 450);
     image(intro,width/2-(intro.width/2),height/2-(intro.height/2));
  }
}
