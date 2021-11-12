PImage imageEntree;
PImage blocDuplique;
PImage imageSortie;


// ###############################################
// Les paramètres du filtre
// ###############################################
String nomDuFichier = "../images/G";
String extensionDuFichier = "jpg";
int nombreDuplications = 1;

// taille de l'image dupliquée, en pourcentage de la hauteur/largeur de l'image d'entrée
int ratioLargeur = 90;
int ratioHauteur = 90;

int reductionLargeur = 60;
int reductionHauteur = 60;

boolean tailleAleatoire = false;
// ###############################################

void setup()
{
  imageEntree = loadImage(nomDuFichier + "." + extensionDuFichier);
  imageSortie = loadImage(nomDuFichier + "." + extensionDuFichier);
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imageEntree.width, imageEntree.height);

  dupliquerReduire();
}

void dupliquerReduire()
{
  imageSortie.copy( imageEntree, 0, 0, imageEntree.width, imageEntree.height, 0, 0, imageEntree.width, imageEntree.height);
  
  int largeurZoneCopiee = int(imageEntree.width * ratioLargeur / 100.0);
  int hauteurZoneCopiee = int(imageEntree.height * ratioHauteur / 100.0);
  
  int positionZoneCopieeX = int(imageEntree.width / 2.0 - largeurZoneCopiee / 2.0);
  int positionZoneCopieeY =int(imageEntree.height / 2.0 - hauteurZoneCopiee / 2.0);
  
  int largeurZoneDuplication = int(imageEntree.width * ratioLargeur / 100.0);
  int hauteurZoneDuplication = int(imageEntree.height * ratioHauteur / 100.0);

  for (int i = 0; i < nombreDuplications; i++)
  {    

    //largeurBlocDuplique = largeurBlocDuplique * ratioLargeur / 100;  
    //hauteurBlocDuplique = hauteurBlocDuplique * ratioHauteur / 100;
      
    largeurZoneDuplication -= reductionLargeur;
    hauteurZoneDuplication -= reductionHauteur;
    
    int positionDuplicationX = int(imageEntree.width / 2.0 - largeurZoneDuplication / 2.0);
    int positionDuplicationY = int(imageEntree.height / 2.0 - hauteurZoneDuplication / 2.0);
    
    //int positionBY =int(imageEntree.height / 2.0 - hauteurBlocDuplique / 2.0);

    //imageSortie.copy( imageEntree, 
    //                  positionDuplicationX, positionDuplicationY,
    //                  largeurZoneDuplication, hauteurZoneDuplication, 
    //                  positionBlocDupliqueX, positionBlocDupliqueY, 
    //                  largeurBlocDuplique, hauteurBlocDuplique);
        
    imageSortie.copy( imageEntree, 
                      positionZoneCopieeX, positionZoneCopieeY,
                      largeurZoneCopiee, hauteurZoneCopiee, 
                      positionDuplicationX, positionDuplicationY, 
                      largeurZoneDuplication, hauteurZoneDuplication);
  }

  //imageEntree.updatePixels();

  //imageSortie.save(nomDuFichier + "_" + nombreDuplications + "." + extensionDuFichier);
}

void draw()
{
  //surface.setLocation(0,0);
  image(imageSortie, 0, 0);

  // Repeter l'inversion
  //mouseClicked();
}

void mouseClicked()
{
  imageSortie = loadImage(nomDuFichier + "." + extensionDuFichier);

  nombreDuplications++;
  dupliquerReduire();
  
  println("done: " + nombreDuplications);
}
