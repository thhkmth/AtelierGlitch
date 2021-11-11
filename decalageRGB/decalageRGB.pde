PImage imageEntree;
PImage imageSortie;

boolean glitchComplete = false;
boolean glitchSaved = false;

// ###############################################
String nomDuFichier = "A";
String extensionDuFichier = "jpg";

int decalageHorizontal = 8; 
int decalageVertical = 8;    
boolean decalageAleatoire = true;

boolean decalerCanalRouge = true;
boolean decalerCanalVert = false;
boolean decalerCanalBleu = false;
// ###############################################

void setup() 
{
  imageEntree = loadImage(nomDuFichier+"."+extensionDuFichier);
  imageSortie = loadImage(nomDuFichier+"."+extensionDuFichier);
  
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imageSortie.width, imageSortie.height);
  image(imageEntree, 0, 0);
  
  mouseClicked();
}


void mouseClicked() 
{
  imageSortie = createImage(imageEntree.width, imageEntree.height, RGB);

  DecalageRVB();
}

void draw() 
{ 
  image(imageSortie, 0, 0);
  
  // Repeter
  //mouseClicked();
}

void DecalageRVB()
{

    imageEntree.loadPixels();
    //imageSortie.loadPixels();

    if(decalageAleatoire)
    {
      int decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
      int decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
      
      //copyChannel(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, canalEntree, canalSortie);
      
      if( decalerCanalRouge)
      {
        copyChannel(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 0, 0);
      }
      else
      {
        copyChannel(imageEntree.pixels, imageSortie.pixels, 0, 0, 0, 0);
      }
      
      if( decalerCanalVert)
      {
        decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
        decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
        copyChannel(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 1, 1);
      }
      else
      {
        copyChannel(imageEntree.pixels, imageSortie.pixels, 0, 0, 1, 1);
      }
      
      if( decalerCanalBleu)
      {
        decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
        decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
        copyChannel(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 2, 2);
      }
      else
      {
        copyChannel(imageEntree.pixels, imageSortie.pixels, 0, 0, 2, 2);
      }
      
    }
    else
    {
      copyChannel(imageEntree.pixels, imageSortie.pixels, decalageVertical, decalageHorizontal, 0, 0);
    }    
      
    imageSortie.updatePixels();

    image(imageSortie, 0, 0, imageSortie.width, imageSortie.height);
}

void copyChannel(color[] sourcePixels, color[] targetPixels, int sourceY, int sourceX, int sourceChannel, int targetChannel)
{
    // starting at the sourceY and pointerY loop through the rows
    for(int y = 0; y < imageSortie.height; y++)
    {   
        // add y counter to sourceY
        int sourceYOffset = sourceY + y;
        
        // wrap around the top of the image if we've hit the bottom
        if(sourceYOffset >= imageSortie.height)
          sourceYOffset -= imageSortie.height;
              
        // starting at the sourceX and pointerX loop through the pixels in this row
        for(int x = 0; x < imageSortie.width; x++)
        {
            // add x counter to sourceX
            int sourceXOffset = sourceX + x;
            
            // wrap around the left side of the image if we've hit the right side
            if(sourceXOffset >= imageSortie.width)
              sourceXOffset -= imageSortie.width;

            // get the color of the source pixel
            color sourcePixel = color(0, 0, 0);
            int sourcePixelIndex = sourceYOffset * imageSortie.width + sourceXOffset;
            if(sourcePixelIndex >= 0)
            {
              sourcePixel = sourcePixels[sourcePixelIndex];
            }
            
            // get the RGB values of the source pixel
            float sourceRed = red(sourcePixel);
            float sourceGreen = green(sourcePixel);
            float sourceBlue = blue(sourcePixel);
   
            // get the color of the target pixel
            color targetPixel = targetPixels[y * imageSortie.width + x]; 

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
                targetPixels[y * imageSortie.width + x] =  color(sourceChannelValue, targetGreen, targetBlue);
                break;
              case 1:
              // assign source channel value to target green channel
                targetPixels[y * imageSortie.width + x] =  color(targetRed, sourceChannelValue, targetBlue);
                break;
              case 2:
                // assign source channel value to target blue channel
                targetPixels[y * imageSortie.width + x] =  color(targetRed, targetGreen, sourceChannelValue);
                break;
            }

        }
    }
}
