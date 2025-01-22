// user/chmod.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
  int mode;
  
  if(argc != 3){
    fprintf(2, "Usage: chmod mode file\n");
    exit(1);
  }
  
  // Convert mode from string to integer
  mode = 0;
  for(char *p = argv[1]; *p; p++){
    if(*p < '0' || *p > '7'){
      fprintf(2, "chmod: invalid mode\n");
      exit(1);
    }
    mode = mode * 8 + (*p - '0');
  }
  
  if(chmod(argv[2], mode) < 0){
    fprintf(2, "chmod: %s failed to change mode\n", argv[2]);
    exit(1);
  }
  exit(0);
}
