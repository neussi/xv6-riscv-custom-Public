// procstat.h
#ifndef PROCSTAT_H
#define PROCSTAT_H
#include "spinlock.h"  // Pour struct spinlock
#include "types.h"     // Pour pagetable_t
#include "param.h"  


struct proc_stat {
    int pid;                  // ID du processus
    int state;               // État du processus (utilisons int au lieu de enum pour l'espace utilisateur)
    char name[16];           // Nom du processus
    uint64 cpu_usage;        // Utilisation CPU
    uint64 runtime;          // Temps d'exécution total
    uint64 memory;           // Utilisation mémoire
};

#endif
