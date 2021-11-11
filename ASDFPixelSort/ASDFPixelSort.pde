PImage imageEntree;
PImage imageSortie;

// ###############################################
String nomDuFichier = "A";
String extensionDuFichier = "jpg";
int premiereColonneTriee = 0;
boolean inverserTri = true;
String mode = "TailleCroissante";
// Modes de fonctionnement : 
// - ColonneEntiere, tri les colones entières

// - TailleFixe, chaque colonne de pixel est séparé en plusieurs sous clonnes triée
int nombreDeSousColonnes = 20;

// - Luminosite, on segmente la colonne quand la difference de luminosité entre 2 pixels voisins est superieure au seuil
int valeurSeuilDifference = 40;

// - Aleatoire, colonnes de taille aleatoire
int tailleMinimale = 10;
int tailleMaximale = 150;

// - TailleCroissante, taille des sous colonnes en fonction de la position de la colonne (avancement colonne)
//0.0 premiere colonne (0% de la largeur)
//0.5 colonne du milieu (50% de la largeur)
//1.0 derniere colonne (100% de la largeur)
int hauteurMaxColonneDebut = 1;
int hauteurMaxColonneFin = 250;
float decalageDebut = 0.2;
float decalageFin = 0.8;  
// ###############################################

void setup() 
{
  imageEntree = loadImage(nomDuFichier+"."+extensionDuFichier);
  imageSortie = loadImage(nomDuFichier+"."+extensionDuFichier);
  
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imageSortie.width, imageSortie.height);
  //image(imageSortie, 0, 0, width, height);
  
  //pixelmsort();
}

void mouseClicked() 
{
  pixelmsort();
  //imageSortie = loadImage(nomDuFichier+"."+extensionDuFichier);
  
  println("done");
}

void draw() 
{ 
  image(imageSortie, 0, 0);
  
  // Repeter
  mouseClicked();
  
}

void pixelmsort()
{
  premiereColonneTriee = 0;
  while (premiereColonneTriee < imageEntree.width) 
  {
    trierLaColonne();
    premiereColonneTriee++;
  }
  
  imageSortie.updatePixels();
  //image(imageSortie, 0, 0, width, height);
  
  //imageSortie.save(nomDuFichier+"_glitched"+".png");
}

void trierLaColonne() 
{
  int x = premiereColonneTriee;
  int y = 0;
  int yend = 0;

  float avancementColonne = float(x) / float(imageEntree.width - 1);
  avancementColonne -= decalageDebut;
  
  if (avancementColonne < 0.0)
  {
    avancementColonne = 0.0;
  }
  
  avancementColonne /= decalageFin;
  
  while (yend < imageSortie.height-1) 
  {
    switch(mode)
    {
      case "ColonneEntiere":
        yend = imageEntree.height - 1;
      break;
      case "TailleFixe":
        yend = y + imageEntree.height / nombreDeSousColonnes;
      break;
      case "Luminosite":
        yend = getNextY(x,y);
      break;
      case "Aleatoire":
        yend = y + (int) random(tailleMinimale, tailleMaximale);
      break;
      case "TailleCroissante":
        yend = y + (int) random( avancementColonne * (float)hauteurMaxColonneFin + int((1.0 - avancementColonne) * (float)hauteurMaxColonneDebut));  
      break;
      default:
        println("mode peut etre ColonneEntiere/TailleFixe/Luminosite/Aleatoire/TailleCroissante");
      break;
      
    }

    if (yend > imageEntree.height)
    {
      yend = imageEntree.height-1;
    }

    if (y < 0) break;

    int sortLength = yend-y;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) 
    {
      unsorted[i] = imageEntree.pixels[x + (y+i) * imageEntree.width];
    }

    sorted = sort(unsorted);
    
    if(inverserTri)
    {
      sorted = reverse(sorted);
    }

    for (int i=0; i<sortLength; i++) 
    {
      imageSortie.pixels[x + (y+i) * imageSortie.width] = sorted[i];
    }

    y = yend+1;
  }
}

int getNextY(int x, int y) 
{
  y++;

  if (y < imageEntree.height) 
  {
    while ( abs( brightness( imageEntree.pixels[x + y * imageEntree.width ] ) -  brightness( imageEntree.pixels[x + ( y - 1 ) * imageEntree.width ] ) ) < random(valeurSeuilDifference - valeurSeuilDifference/2, valeurSeuilDifference + valeurSeuilDifference) ) 
    {
      y++;
      if (y >= imageEntree.height)
      {
        return imageEntree.height-1;
      }
    }
  }
  return y-1;
}
