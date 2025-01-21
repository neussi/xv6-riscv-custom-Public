#include "types.h"
#include "port.h"

// Implémentation de la fonction outw
void outw(uint16 port, uint16 data) {
  asm volatile("outw %0, %1" : : "a"(data), "Nd"(port));
}
