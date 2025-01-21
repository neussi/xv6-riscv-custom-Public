#include "user.h"
#include "kernel/syscall.h"
#include "kernel/fcntl.h"

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

int main() {
    int fd;
    char buffer[20];

    // Créer un fichier et écrire des données dedans
    fd = open("testfile", O_CREATE | O_RDWR);
    if (fd < 0) {
        printf("Erreur : impossible de créer le fichier\n");
        exit(1);
    }

    write(fd, "Hello, xv6!", 11);  // Écrire "Hello, xv6!" dans le fichier

    // Utiliser lseek pour revenir au début du fichier
    lseek(fd, 0, SEEK_SET);

    // Lire les données du fichier
    read(fd, buffer, 11);
    buffer[11] = '\0';  // Terminer la chaîne
    printf("Contenu du fichier : %s\n", buffer);

    // Utiliser lseek pour aller à la fin du fichier et écrire plus de données
    lseek(fd, 0, SEEK_END);
    write(fd, " Goodbye!", 9);

    // Revenir au début et lire à nouveau
    lseek(fd, 0, SEEK_SET);
    read(fd, buffer, 20);
    buffer[20] = '\0';  // Terminer la chaîne
    printf("Nouveau contenu : %s\n", buffer);

    // Fermer le fichier
    close(fd);

    exit(0);
}
