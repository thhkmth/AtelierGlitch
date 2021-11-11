PImage img;
PImage imgGlitchee;


// ###############################################
// Les paramètres du filtre
// ###############################################
String nomDuFichier = "A";
String extensionDuFichier = "jpg";
int nombredInversions = 20;

// taille des blocs, fixe ou aleatoire
int largeur = 60;  //= int(random(100));
int hauteur = 60;  //= int(random(100));
// ###############################################

void setup() 
{
  img = loadImage(nomDuFichier + "." + extensionDuFichier);
  imgGlitchee = loadImage(nomDuFichier + "." + extensionDuFichier);
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(img.width, img.height);

  InverserBlocs();
}

void InverserBlocs()
{
  for(int i = 0; i < nombredInversions; i++)
  {
    //POSITIONS DES BLOCS
    // 1. Aleatoire
    //int positionAX = int(random(img.width));
    //int positionAY = int(random(img.height));
    //int positionBX = int(random(img.width));
    //int positionBY = int(random(img.height));    
    
    // 2. Sur une grille
    int gridSizeX = int(img.width / largeur) + 1;
    int gridSizeY = int(img.height / largeur) + 1;    
    int positionAX = int(random(gridSizeX)) * largeur;
    int positionAY = int(random(gridSizeY)) * hauteur;
    int positionBX = int(random(gridSizeX)) * largeur;
    int positionBY = int(random(gridSizeY)) * hauteur;    
    // ###############################################
    
    //on inverse les 2 blocs :
    imgGlitchee.copy(img, positionAX, positionAY , largeur, hauteur, positionBX, positionBY, largeur, hauteur);
    imgGlitchee.copy(img, positionBX, positionBY , largeur, hauteur, positionAX, positionAY, largeur, hauteur);
  }

  img.updatePixels();
  
  imgGlitchee.save(nomDuFichier + "_" + nombredInversions + "." + extensionDuFichier);
}

void draw()
{
  surface.setLocation(0,0);
  image(imgGlitchee, 0, 0);
}

void mouseClicked() 
{
  InverserBlocs();
}
