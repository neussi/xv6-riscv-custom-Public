#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
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
sys_exit_qemu(void)
{
  // Adresse mémoire spéciale pour fermer QEMU
  volatile uint32 *exit_address = (volatile uint32 *)0x100000;
  *exit_address = 0x5555;  // Valeur magique pour fermer QEMU
  return 0;
}


uint64
sys_getprocs(void)
{
    uint64 addr;
    int max;
    struct proc_stat *ps;

    // On ne peut pas vérifier le retour de ces fonctions car elles sont void
    argaddr(0, &addr);
    argint(1, &max);
    
    // Vérifications de base
    if(max <= 0 || max > NPROC)
        return -1;

    // Convertir l'adresse utilisateur en pointeur noyau
    ps = (struct proc_stat*)addr;
    
    // Vérifier que l'adresse est valide en essayant de copier une petite quantité de données
    char test;
    if(copyout(myproc()->pagetable, addr, &test, 1) < 0)
        return -1;

    // Appeler getprocs avec l'adresse validée
    return getprocs(ps, max);
}
