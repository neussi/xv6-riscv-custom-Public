#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "proc_stat.h"
#include "port.h"  

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


uint64
sys_getprocstat(void)
{
  struct proc_stat *pstat;
  int count;

  // Récupérer les arguments passés par l'utilisateur
  argaddr(0, (uint64*)&pstat);  // Récupère l'adresse de pstat
  argint(1, &count);            // Récupère la valeur de count

  // Vérifier si les arguments sont valides
  if (pstat == 0 || count < 0) {
    return -1;  // Retourner une erreur si les arguments sont invalides
  }

  // Remplir le tableau pstat avec les informations des processus
  return getprocstat(pstat, count);
}


uint64
sys_exit_qemu(void)
{
  // Adresse mémoire spéciale pour fermer QEMU
  volatile uint32 *exit_address = (volatile uint32 *)0x100000;
  *exit_address = 0x5555;  // Valeur magique pour fermer QEMU
  return 0;
}
