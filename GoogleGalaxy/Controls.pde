
void mouseMoved() { //look around  
  camera1.look(radians(mouseX - pmouseX) / 8.0, radians(mouseY - pmouseY) / 8.0);
  camera2.look(radians(mouseX - pmouseX) / 16.0, radians(mouseY - pmouseY) / 16.0);
}

void mouseClicked() { //click to remove intro image
  showIntro = false;
}

void keyPressed()
{  
  if (key == '\n' ) { //ENTER
      if(input==true)
      {
        textvar = 1;
      }
      else
      {
        input=true;
      }
    }
  else if(input==true)
    {
      if((keyCode == BACKSPACE)&&(typing.length() != 0)) //DELETE
      {
        typing = typing.substring(0, typing.length() - 1);
      }
      else
      {
        // Otherwise, concatenate the String
        // Each character typed by the user is added to the end of the String variable.
        if (key != CODED) typing += key;
      }
    }
    
   if((key=='u')&&(input==false)) //toggle orbiting
     {
       rotatin = !rotatin;
     }
}
