#ifndef PROC_STAT_H
#define PROC_STAT_H

#include "types.h"  // Pour uint64

// Définition de struct proc_stat
struct proc_stat {
  int pid;           // ID du processus
  int state;         // État du processus (UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE)
  uint64 cputicks;   // Temps CPU utilisé par le processus
  char name[16];     // Nom du processus
};

// Déclaration de la fonction getprocstat
int getprocstat(struct proc_stat *pstat, int count);

#endif // PROC_STAT_H
