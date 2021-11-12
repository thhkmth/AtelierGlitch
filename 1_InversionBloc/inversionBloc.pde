// ###############################################
// Les paramètres du filtre :
String nomDuFichier = "../images/A";
String extensionDuFichier = "jpg";
int nombredInversions = 2;

// taille des zones inversées en piexl (fixe ou aleatoire)
int largeur = 80;
int hauteur = 80;
boolean tailleAleatoire = false;
// ###############################################

PImage imageEntree;
PImage imageSortie;

// Fonction appellée une fois, au début de l'execution du script
void setup()
{
  // Charge l'image d'entrée
  imageEntree = loadImage(nomDuFichier + "." + extensionDuFichier);
  
  size(1, 1);
  surface.setResizable(false);
  surface.setSize(imageEntree.width, imageEntree.height);
  
  InverserBlocs();
}

void mouseClicked()
{
  InverserBlocs();
}

// Fonction appellée de manière repetée quand le script s'execute
void draw()
{
  // Affiche l'image en sortie dans la fenêtre
  image(imageSortie, 0, 0);
  
  // Repeter
  //mouseClicked();
}

void InverserBlocs()
{
  // Crée l'image de sortie
  imageSortie = loadImage(nomDuFichier + "." + extensionDuFichier);
  
  for (int i = 0; i < nombredInversions; i++)
  {
    // Taille des blocs inversés
    int largeurBloc = largeur;
    int hauteurBloc = hauteur;
    
    if (tailleAleatoire == true)
    {
      largeurBloc = int( random(1, largeur) + 1);
      hauteurBloc = int( random(1, hauteur) + 1);
    }

    // Les blocs sont lus et placés sur grille
    int nombreDeCaseX = int(imageEntree.width / largeurBloc);
    int nombreDeCaseY = int(imageEntree.height / hauteurBloc);
    
    // Position du premier bloc
    int positionPremierBlocX = int( random( nombreDeCaseX ) ) * largeurBloc;
    int positionPremierBlocY = int( random( nombreDeCaseY ) ) * hauteurBloc;
    
    // Position du second bloc
    int positionDeuxiemeBlocX = int( random( nombreDeCaseX ) ) * largeurBloc;
    int positionDeuxiemeBlocY = int( random( nombreDeCaseY ) ) * hauteurBloc;

    // On lit le premier bloc dans l'image d'entrée et on le copy sur la sortie
    imageSortie.copy( imageEntree, positionPremierBlocX, positionPremierBlocY, largeurBloc, hauteurBloc, positionDeuxiemeBlocX, positionDeuxiemeBlocY, largeurBloc, hauteurBloc);
    
    // On lit le premier bloc dans l'image d'entrée et on le copy sur la sortie
    imageSortie.copy( imageEntree, positionDeuxiemeBlocX, positionDeuxiemeBlocY, largeurBloc, hauteurBloc, positionPremierBlocX, positionPremierBlocY, largeurBloc, hauteurBloc);
  }

  imageSortie.updatePixels();

  String fichierSortie = nomDuFichier + "_inversions_" + nombredInversions + "." + extensionDuFichier;
  imageSortie.save(fichierSortie);
  println(fichierSortie);
}
