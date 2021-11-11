PImage sourceImg;
PImage targetImg;

boolean glitchComplete = false;
boolean glitchSaved = false;

// ###############################################
String nomDuFichier = "A";
String extensionDuFichier = "jpg";
// ###############################################

void setup() 
{
  targetImg = loadImage(nomDuFichier+"."+extensionDuFichier);
  sourceImg = loadImage(nomDuFichier+"."+extensionDuFichier);
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(targetImg.width, targetImg.height);
  image(sourceImg, 0, 0);
}


void draw() 
{ 
  surface.setLocation(0,0);
  if (!glitchComplete)
  {
    sourceImg.loadPixels();
    targetImg.loadPixels();

    // ###############################################
    int decalageHorizontal = 8; 
    int decalageVertical = 3;    
    // 0: rouge, 1: vert, 2: bleu
    int canalEntree = 0;
    int canalSortie = 0;    
    // ###############################################
    
    copyChannel(sourceImg.pixels, targetImg.pixels, decalageVertical, decalageHorizontal, canalEntree, canalSortie);    
      
    targetImg.updatePixels();
    glitchComplete = true;
    image(targetImg, 0, 0, targetImg.width, targetImg.height);
  }

  if (glitchComplete && !glitchSaved) 
  {
    targetImg.save(nomDuFichier+"_glitched.png");
    glitchSaved = true;
    println("Glitched image saved");
    println("Click or press any key to exit...");
  }
}

void copyChannel(color[] sourcePixels, color[] targetPixels, int sourceY, int sourceX, int sourceChannel, int targetChannel)
{
    // starting at the sourceY and pointerY loop through the rows
    for(int y = 0; y < targetImg.height; y++)
    {   
        // add y counter to sourceY
        int sourceYOffset = sourceY + y;
        
        // wrap around the top of the image if we've hit the bottom
        if(sourceYOffset >= targetImg.height)
          sourceYOffset -= targetImg.height;
              
        // starting at the sourceX and pointerX loop through the pixels in this row
        for(int x = 0; x < targetImg.width; x++)
        {
            // add x counter to sourceX
            int sourceXOffset = sourceX + x;
            
            // wrap around the left side of the image if we've hit the right side
            if(sourceXOffset >= targetImg.width)
              sourceXOffset -= targetImg.width;

            // get the color of the source pixel
            color sourcePixel = sourcePixels[sourceYOffset * targetImg.width + sourceXOffset];
            
            // get the RGB values of the source pixel
            float sourceRed = red(sourcePixel);
            float sourceGreen = green(sourcePixel);
            float sourceBlue = blue(sourcePixel);
   
            // get the color of the target pixel
            color targetPixel = targetPixels[y * targetImg.width + x]; 

            // get the RGB of the target pixel
            // two of the RGB channel values are required to create the new target color
            // the new target color is two of the target RGB channel values and one RGB channel value from the source
            float targetRed = red(targetPixel);
            float targetGreen = green(targetPixel);
            float targetBlue = blue(targetPixel);
            
            // create a variable to hold the new source RGB channel value
            float sourceChannelValue = 0;
            
            // assigned the source channel value based on sourceChannel random number passed in
            switch(sourceChannel)
            {
              case 0:
                // use red channel from source
                sourceChannelValue = sourceRed;
                break;
              case 1:
              // use green channel from source
                sourceChannelValue = sourceGreen;
                break;
              case 2:
              // use blue channel from source
                sourceChannelValue = sourceBlue;
                break;
            }
            
            // assigned the source channel value to a target channel based on targetChannel random number passed in
            switch(targetChannel)
            {
              case 0:
                // assign source channel value to target red channel
                targetPixels[y * targetImg.width + x] =  color(sourceChannelValue, targetGreen, targetBlue);
                break;
              case 1:
              // assign source channel value to target green channel
                targetPixels[y * targetImg.width + x] =  color(targetRed, sourceChannelValue, targetBlue);
                break;
              case 2:
                // assign source channel value to target blue channel
                targetPixels[y * targetImg.width + x] =  color(targetRed, targetGreen, sourceChannelValue);
                break;
            }

        }
    }
}
