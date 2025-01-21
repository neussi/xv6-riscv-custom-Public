#include "user.h"
#include "fcntl.h"

int main() {
  int fd;
  struct stat st;

  // Ouvrir un fichier
  fd = open("testfile", O_RDONLY);
  if (fd < 0) {
    printf("Erreur : impossible d'ouvrir le fichier\n");
    exit(1);
  }

  // Obtenir les métadonnées du fichier
  if (fstat(fd, &st) < 0) {
    printf("Erreur : impossible d'obtenir les métadonnées du fichier\n");
    close(fd);
    exit(1);
  }

  // Afficher les permissions
  printf("Permissions du fichier : %x\n", st.mode);

  close(fd);
  exit(0);
}
