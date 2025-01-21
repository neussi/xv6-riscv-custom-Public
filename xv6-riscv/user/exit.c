#include "user/user.h"

int main(void) {
  exit_qemu();  // Appelle la syscall pour fermer QEMU
  exit(0);
}
