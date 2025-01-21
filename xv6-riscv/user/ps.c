#include "user/user.h"
#include "kernel/proc.h"

#define NPROC 64  // Nombre maximal de processus

int main(int argc, char *argv[]) {
  struct proc_stat pstat[NPROC];
  int count;

  // Appeler la syscall pour obtenir les informations des processus
  count = getprocstat(pstat, NPROC);
  printf("getprocstat returned: %d\n", count);  // Afficher la valeur de retour
  if (count < 0) {
    printf("ps: erreur lors de la récupération des informations des processus\n");
    exit(1);
  }

  // Afficher les informations des processus
  printf("PID\tÉtat\tTemps CPU\tNom\n");
  for (int i = 0; i < count; i++) {
    printf("%d\t%d\t%ld\t\t%s\n", pstat[i].pid, pstat[i].state, pstat[i].cputicks, pstat[i].name);
  }

  exit(0);
}
