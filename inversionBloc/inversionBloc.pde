PImage img;
PImage imgGlitchee;


// ###############################################
// Les paramètres du filtre
// ###############################################
String nomDuFichier = "../images/A";
String extensionDuFichier = "jpg";
int nombredInversions = 130;

// taille des blocs (fixe ou aleatoire)
int largeur = 40;
int hauteur = 40;
boolean tailleAleatoire = false;
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
  for (int i = 0; i < nombredInversions; i++)
  {
    int largeurBloc = largeur;
    int hauteurBloc = hauteur;
    
    // TAILLE DU BLOC
    if (tailleAleatoire == true)
    {
      largeurBloc = int( random(1, largeur) + 1);
      hauteurBloc = int( random(1, hauteur) + 1);
    }

    //POSITIONS DU BLOC
    // 1. Aleatoire
    //int positionAX = int(random(img.width));
    //int positionAY = int(random(img.height));
    //int positionBX = int(random(img.width));
    //int positionBY = int(random(img.height));

    // 2. Sur une grille
    int gridSizeX = int(img.width / largeurBloc) + 1;
    int gridSizeY = int(img.height / hauteurBloc) + 1;
    int positionAX = int( random( gridSizeX ) ) * largeurBloc;
    int positionAY = int( random( gridSizeY ) ) * hauteurBloc;
    int positionBX = int( random( gridSizeX ) ) * largeurBloc;
    int positionBY = int( random( gridSizeY ) ) * hauteurBloc;
    // ###############################################

    //on inverse les 2 blocs :
    imgGlitchee.copy( img, positionAX, positionAY, largeurBloc, hauteurBloc, positionBX, positionBY, largeurBloc, hauteurBloc);
    imgGlitchee.copy( img, positionBX, positionBY, largeurBloc, hauteurBloc, positionAX, positionAY, largeurBloc, hauteurBloc);
  }

  img.updatePixels();

  imgGlitchee.save(nomDuFichier + "_" + nombredInversions + "." + extensionDuFichier);
}

void draw()
{
  //surface.setLocation(0,0);
  image(imgGlitchee, 0, 0);

  // Repeter l'inversion
  //mouseClicked();
}

void mouseClicked()
{
  imgGlitchee = loadImage(nomDuFichier + "." + extensionDuFichier);

  InverserBlocs();
}
