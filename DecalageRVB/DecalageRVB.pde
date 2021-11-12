String nomDuFichier = "../images/A";
String extensionDuFichier = "jpg";

int decalageHorizontal = 12; 
int decalageVertical = 12;    
boolean decalageAleatoire = true;

boolean decalerCanalRouge = true;
boolean decalerCanalVert = false;
boolean decalerCanalBleu = false;
// ###############################################

PImage imageEntree;
PImage imageSortie;

// Fonction appellée une fois, au début de l'execution du script
void setup() 
{
  // Charge l'image d'entrée
  imageEntree = loadImage(nomDuFichier+"."+extensionDuFichier);
  
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imageEntree.width, imageEntree.height);
  
  DecalageRVB();
}

void mouseClicked() 
{
  DecalageRVB();
}

// Fonction appellée de manière repetée quand le script s'execute
void draw() 
{ 
  // Affiche l'image en sortie dans la fenêtre
  image(imageSortie, 0, 0);
  
  // Repeter
  //mouseClicked();
}

void DecalageRVB()
{
    // Crée l'image de sortie
    imageSortie = createImage(imageEntree.width, imageEntree.height, RGB);

    if(decalageAleatoire)
    {
      int decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
      int decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
      
      if( decalerCanalRouge)
      {
        CopierCanal(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 0, 0);
      }
      else
      {
        CopierCanal(imageEntree.pixels, imageSortie.pixels, 0, 0, 0, 0);
      }
      
      if( decalerCanalVert)
      {
        decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
        decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
        CopierCanal(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 1, 1);
      }
      else
      {
        CopierCanal(imageEntree.pixels, imageSortie.pixels, 0, 0, 1, 1);
      }
      
      if( decalerCanalBleu)
      {
        decalageHorizontalAleatoire = int( random(-decalageHorizontal, decalageHorizontal) );
        decalageVerticalAleatoire = int( random(-decalageVertical, decalageVertical) );
        CopierCanal(imageEntree.pixels, imageSortie.pixels, decalageVerticalAleatoire, decalageHorizontalAleatoire, 2, 2);
      }
      else
      {
        CopierCanal(imageEntree.pixels, imageSortie.pixels, 0, 0, 2, 2);
      }
      
    }
    else
    {
      CopierCanal(imageEntree.pixels, imageSortie.pixels, decalageVertical, decalageHorizontal, 0, 0);
    }    
    
    String fichierSortie = nomDuFichier + "_decalageRVB_" + decalageHorizontal + "_" + decalageVertical + "." + extensionDuFichier;
    //imageSortie.save(fichierSortie);
    println(fichierSortie);
}

void CopierCanal(color[] sourcePixels, color[] targetPixels, int sourceY, int sourceX, int sourceChannel, int targetChannel)
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
