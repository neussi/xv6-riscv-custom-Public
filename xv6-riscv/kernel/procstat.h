// Dans kernel/procstat.h
#ifndef _PROCSTAT_H_
#define _PROCSTAT_H_

struct proc_stat {
    int pid;           // Process ID
    int state;         // Process state
    uint ticks;        // Temps total d'exécution
    uint memory;       // Mémoire utilisée
    char name[16];     // Nom du processus
};

#endif // _PROCSTAT_H_
