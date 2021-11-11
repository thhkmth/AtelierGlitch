PImage img;

// ###############################################
String nomDuFichier = "A";
String extensionDuFichier = "jpg";
// ###############################################

int valeurSeuilDifference;
int column = 0;
boolean saved = false;

void setup() {
  img = loadImage(nomDuFichier+"."+extensionDuFichier);
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  image(img, 0, 0, width, height);
}

void draw() {
  surface.setLocation(0,0);
  while (column < img.width) 
  {
    trierLaColonne();
    column++;
  }
  img.updatePixels();
  image(img, 0, 0, width, height);
  if (!saved) {
    img.save(nomDuFichier+"_glitched"+".png");
    saved = true;
  }
}

void trierLaColonne() {
  int x = column;
  int y = 0;
  int yend = 0;

  // ###############################################
  // utilisé avec partie 4. pour que la taille des colonnes dépende de la position
  //0.0 premiere colonne (0% de la largeur)
  //0.5 colonne du milieu (50% de la largeur)
  //1.0 derniere colonne (100% de la largeur)
  int hauteurMaxColonneDebut = 1;
  int hauteurMaxColonneFin = 500;
  float decalageDebut = 0.2;
  float decalageFin = 0.8;  
  // ###############################################
  
  float avancementColonne = float(x) / float(img.width - 1);
  avancementColonne -= decalageDebut;
  if (avancementColonne < 0.0)
    avancementColonne = 0.0;
  avancementColonne /= decalageFin;
  
  while (yend < img.height-1) 
  {
    // ###############################################
    // 0: tri de la colonne entiere
    yend = img.height - 1;

    // 1: on segmente la colonne quand la difference de luminosité entre 2 pixels voisins est superieure au seuil
    //valeurSeuilDifference = 25;
    //yend = getNextY(x,y);
    
    // 2: colonne de taille fixe
    //int nombreDeSousColonnes = 70;
    //yend = y + img.height / nombreDeSousColonnes;

    // 3: colonnes de taille aleatoire entre 20 et 100 pixels
    //yend = y + (int)random(20, 100);

    // 4: taille des sous colonnes en fonction de la position de la colonne (avancement colonne)
    //yend = y + (int)random( avancementColonne * (float)hauteurMaxColonneFin + int((1.0 - avancementColonne) * (float)hauteurMaxColonneDebut));    
    // ###############################################

    if (yend > img.height)
      yend = img.height-1;

    if (y < 0) break;

    int sortLength = yend-y;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) 
    {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }

    sorted = sort(unsorted);
    
    // ###############################################
    //Inverse le resultat du tri
    //sorted = reverse(sorted);
    // ###############################################

    for (int i=0; i<sortLength; i++) 
    {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }

    y = yend+1;
  }
}

int getNextY(int x, int y) {
  y++;

  if (y < img.height) {
    while ( abs( brightness( img.pixels[x + y * img.width ] ) -  brightness( img.pixels[x + ( y - 1 ) * img.width ] ) ) < valeurSeuilDifference ) 
    {
      y++;
      if (y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}
