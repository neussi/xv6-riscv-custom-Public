#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
#include "kernel/proc.h"

int
main(int argc, char *argv[])
{
  struct proc_stat stats[64];
  int count = getprocs(stats, 64);
  
  if (count < 0) {
    fprintf(2, "ps: failed to retrieve process information\n");
    exit(1);
  }

  printf("PID\tSTATE\tCPU\tRUNTIME\tMEM\tNAME\n");
  
  for(int i = 0; i < count; i++) {
    char *state;
    switch(stats[i].state) {
      case UNUSED:   state = "unused  "; break;
      case USED:     state = "used    "; break;
      case SLEEPING: state = "sleep   "; break;
      case RUNNABLE: state = "runnable"; break;
      case RUNNING:  state = "running "; break;
      case ZOMBIE:   state = "zombie  "; break;
      default:       state = "???     "; break;
    }
    
    printf("%d\t%s\t%lu\t%lu\t%lu\t%s\n",  // Utilisez %lu pour uint64
           stats[i].pid,
           state,
           stats[i].cpu_usage,
           stats[i].runtime,
           stats[i].memory,
           stats[i].name);
  }
  exit(0);
}
