//GO FUNCTION: gets a new searchterm, searches randomly for as many compatible images it can find, then creates a new solar system using those images.

void go()
{
  links = img_urls(numofResults/4); //initialises the search
  
  println("-Initalising search: " + searchTerm);
  
  for(int i=0; i<usedlinks.length; i++) //just resets the 'usedlinks' array
  {
    usedlinks[i]=-1;
  }
  
  //THE SUN
  img[0]=loadImage("olympia_yellow.jpg");
  sizer[0]=random(18,23);

  randX[0]=(int)position[0];
  randY[0]=(int)position[1];
  randZ[0]=(int)(position[2]-10000);
  //
  
  for(int i=1;i<img.length;i++) //runs through every planet other than the sun
  {
    sizer[i]=random(0.8,4); //random size of planet
    
    //img[i]=loadImage("http://previewcf.turbosquid.com/Preview/2014/08/01__23_05_13/1024x1024_red.jpgc5e979dc-eac8-4748-9a12-fa09b4265739Large.jpg");
    ok1=false;
    ok2=false;
    int counter=0; //to count while loop runs
    while((ok1==false)||(ok2==false))
    {
      counter++;
      rlink = (int)random(0,numofResults); //chooses a random link out of the search results
      
      ////checks if image has already been used
      ok1 = true;
      if(i>0)
      {
        for(int v=0;v<i;v++)
          {
            if(rlink==usedlinks[v])
            {
              ok1 = false;
            }
          }
      }
      
      ////checks if image size is within boundaries
      ok2 = false;
      if((wide[rlink]>=550)&&(high[rlink]>=450)&&(wide[rlink]<=3800)&&(high[rlink]<=3600))
        {
          ok2 = true;
        }
        
      if(counter==60000) //exit while loop
        {
          println("i give up");
          sizer[i]=0; //planets with size 0 will not be drawn
          break;
        }
        
     }
     if(sizer[i]==0)
     {
       img[i]=loadImage("Red_Sand_Texture.jpg"); //just a placeholder image for empty planets
     }
     else
     {
       img[i]=loadImage(links[rlink]); //load selected image
       println("all ok, loading image "+rlink);
       println("while loop run " + counter + " times.");
     }
     usedlinks[i]=rlink; //places link in usedlinks, so it isnt used twice
     if(img[i]==null) //incompatible images will return null
     {
       img[i]=loadImage("Red_Sand_Texture.jpg"); //placeholder
       sizer[i]=0; //will not appear
     }

    ///RANDOM COORDINATES
    randX[i]=(int)(random(randX[0]-10000,randX[0]+10000));
    randY[i]=(int)(random(randY[0]-2000,randY[0]+2000));
    randZ[i]=(int)(random(randZ[0]+15000,randZ[0]+25000));
    
    ////////check for overlapping planets///
    ///for each planet in the for loop, it will run through each planet which precedes it and check if they are too close
    if(checkPos)
    {
      boolean ok=false;
      if(i>0)
      {
        while(ok==false)
        {
          for(int j=0;j<i;j++)
          {
            if((randX[i]>randX[j]-(400*sizer[j]))&&(randX[i]<randX[j]+(400*sizer[j]))&&(randY[i]>randY[j]-(400*sizer[j]))&&(randY[i]<randY[j]+(400*sizer[j]))&&(randZ[i]>randZ[j]-(400*sizer[j]))&&(randZ[i]<randZ[j]+(400*sizer[j])))
            {
              ok=false; ////re-randomize the position of the planet
              randX[i]=(int)(random(randX[0]-10000,randX[0]+10000));
              randY[i]=(int)(random(randY[0]-2000,randY[0]+2000));
              randZ[i]=(int)(random(randZ[0]+15000,randZ[0]+25000));
              println("Uh oh! found overlapping planet. re-randomizing...");
              break;
            }
            else
            {
              ok=true;
            }
          }
        }
      }
    }
    //////
    
    if(moons==true)
    {
      if(sizer[i-1]>sizer[i]+0.6) //if smaller than previous planet, make into a moon (currently disabled)
      {
        moon[i]=true;
        randX[i]=(int)(random(randX[i-1]-100,randX[i-1]+100));
        randY[i]=(int)(random(randY[i-1]-20,randY[i-1]+20));
        randZ[i]=(int)(random(randZ[i-1]-40,randZ[i-1]+40));
      }
      else
        moon[i]=false;
    }
      
    orbitvar[i]=random(0.2,2.4); //random orbit speed
    ////////////
  }
  textvar = 0; //resets text status
  
  if((bgm.isPlaying()==false)&&(frameCount>2))
  {
    bgm.rewind();
  }
}
