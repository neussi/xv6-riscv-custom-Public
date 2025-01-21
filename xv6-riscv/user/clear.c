#include "user/user.h"

int main(void) {
  // Envoie le caractère spécial pour effacer l'écran
  write(1, "\033[2J\033[H", 7);  // Séquence ANSI pour effacer l'écran
  exit(0);
}
