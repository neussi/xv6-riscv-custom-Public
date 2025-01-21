// Mutual exclusion lock.
#ifndef SPINLOCK_H
#define SPINLOCK_H

#include "types.h"

// Définition de struct spinlock
struct spinlock {
  uint locked;       // Est-ce que le verrou est acquis ?
  char *name;        // Nom du verrou (pour le débogage)
  struct cpu *cpu;   // Le CPU qui détient le verrou
};

#endif // SPINLOCK_H
