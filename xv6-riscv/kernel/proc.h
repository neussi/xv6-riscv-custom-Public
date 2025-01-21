#ifndef PROC_H
#define PROC_H

#include "spinlock.h"  // Pour struct spinlock
#include "types.h"     // Pour pagetable_t
#include "param.h"     // Pour NPROC

// Définition de struct context
struct context {
  uint64 ra;
  uint64 sp;
  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// Définition de struct cpu
struct cpu {
  struct proc *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

// Définition de struct trapframe
struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};

// Définition de enum procstate
enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Structure pour les statistiques de processus
struct proc {
   struct spinlock lock;
   enum procstate state;        
   void *chan;                  
   int killed;                  
   int xstate;                  
   int pid;                     
   struct proc *parent;         
   uint64 kstack;               
   uint64 sz;                   
   pagetable_t pagetable;       
   struct trapframe *trapframe; 
   struct context context;      
   struct file *ofile[NOFILE];  
   struct inode *cwd;           
   char name[16];               
   
   // Nouveaux champs pour les statistiques
   uint64 creation_time;        // Temps de création du processus
   uint64 cpu_usage;           // Temps CPU utilisé
   uint64 total_runtime;       // Temps total depuis la création
};

// Déclarations des fonctions pour ps
#endif
