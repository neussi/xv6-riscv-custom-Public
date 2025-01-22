// Dans user/ps.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/procstat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(void) {
    struct proc_stat stats[NPROC];
    int count;

    count = getprocs(stats, NPROC);
    if(count < 0){
        fprintf(2, "ps: impossible de récupérer les infos des processus\n");
        exit(1);
    }

    // En-tête avec un format fixe
    printf("PID\tSTATE\t\tMEM\tNAME\n");
    
    for(int i = 0; i < count; i++) {
        char *state;
        switch(stats[i].state) {
            case 0: state = "UNUSED  "; break;
            case 1: state = "SLEEPING"; break;
            case 2: state = "RUNNABLE"; break;
            case 3: state = "RUNNING "; break;
            case 4: state = "ZOMBIE  "; break;
            default: state = "UNKNOWN "; break;
        }

        // Affichage simple et robuste
        printf("%d\t%s\t%dK\t%s\n", 
               stats[i].pid,
               state,
               stats[i].memory / 1024,
               stats[i].name);
    }
    exit(0);
}
