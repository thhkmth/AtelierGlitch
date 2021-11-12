// ###############################################
// Les paramètres du filtre :
String nomDuFichier = "../images/A";
String extensionDuFichier = "jpg";
int indexPremiereColonneTriee = 0;
boolean inverserTri = true;

// Mode de fonctionnement : 
String mode = "ColonneEntiere";
// - "ColonneEntiere", tri les colones entières, utilise la luminosité des pixels

// - "TailleFixe", chaque colonne de l'image est séparé en un nombre fixe de sous colonnes triéed
int nombreDeSousColonnes = 10;

// - "Luminosite", on segmente la colonne quand la difference de luminosité entre 2 pixels voisins est superieure au seuil
int valeurSeuilDifference = 40;

// - "Aleatoire", colonnes de taille aleatoire
int tailleMinimale = 10;
int tailleMaximale = 150;

// - TailleCroissante, taille des sous colonnes en fonction de la position de la colonne (avancement colonne)
//0.0 premiere colonne (0% de la largeur)
//0.5 colonne du milieu (50% de la largeur)
//1.0 derniere colonne (100% de la largeur)
int hauteurMaxColonneDebut = 1;
int hauteurMaxColonneFin = 150;
float decalageDebut = 0.15;
float decalageFin = 0.8;  
// ###############################################

PImage imageEntree;
PImage imageSortie;
boolean dejaFait = false;

// Fonction appellée une fois, au début de l'execution du script
void setup() 
{
  // Charge l'image d'entrée
  imageEntree = loadImage(nomDuFichier+"."+extensionDuFichier);
  
  // Crée l'image de sortie
  imageSortie =  loadImage(nomDuFichier+"."+extensionDuFichier);
  
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imageSortie.width, imageSortie.height);
  //image(imageSortie, 0, 0, width, height);
  
  TrierLesColonnes();
}

void mouseClicked() 
{
  TrierLesColonnes();
}

void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();  
  valeurSeuilDifference -= e;
  valeurSeuilDifference = constrain(valeurSeuilDifference, 0, 255);
  
    println(valeurSeuilDifference);
    
    TrierLesColonnes();
}

// Fonction appellée de manière repetée quand le script s'execute
void draw() 
{ 
  // Affiche l'image en sortie dans la fenêtre
  image(imageSortie, 0, 0);
  
  // Repeter
  //mouseClicked();
}

void TrierLesColonnes()
{  
  indexPremiereColonneTriee = 0;
  
  while (indexPremiereColonneTriee < imageEntree.width) 
  {
    TrierLaColonne();
    indexPremiereColonneTriee++;
  }
  
  imageSortie.updatePixels();
  
  String fichierSortie = nomDuFichier + "_tridepixel_" + mode + "." + extensionDuFichier;
  imageSortie.save(fichierSortie);
  println(fichierSortie);
}

void TrierLaColonne() 
{
  int x = indexPremiereColonneTriee;
  int y = 0;
  int yend = 0;

  
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
        float avancementColonne = float(x) / float(imageEntree.width - 1);
        avancementColonne -= decalageDebut;        
        if (avancementColonne < 0.0)
        {
          avancementColonne = 0.0;
        }        
        avancementColonne /= decalageFin;
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
