#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define MAXLINES 1000  // Nombre maximal de lignes
#define MAXLEN   100   // Longueur maximale d'une ligne

char content[MAXLINES][MAXLEN];
int nlines = 0;

void
readlines(int fd)
{
  char buf;
  int i = 0, j = 0;

  while(read(fd, &buf, 1) == 1) {
    if(buf == '\n') {
      content[i][j] = '\0';
      i++;
      if(i >= MAXLINES) break;
      j = 0;
    } else {
      if(j < MAXLEN-1)
        content[i][j++] = buf;
    }
  }

  // Gérer la dernière ligne si elle n'a pas de \n
  if(j > 0) {
    content[i][j] = '\0';
    i++;
  }

  nlines = i;
}

void
printtail(int n)
{
  int start;
  int i;

  if(n > nlines)
    start = 0;
  else
    start = nlines - n;

  for(i = start; i < nlines; i++)
    printf("%s\n", content[i]);
}

int
main(int argc, char *argv[])
{
  int fd;
  int n = 10;  // Par défaut : 10 dernières lignes

  if(argc < 2) {
    fprintf(2, "Usage: tail [-n] file\n");
    exit(1);
  }

  if(argv[1][0] == '-') {
    n = atoi(&argv[1][1]);
    if(argc < 3) {
      fprintf(2, "tail: missing file operand\n");
      exit(1);
    }
    fd = open(argv[2], 0);
  } else {
    fd = open(argv[1], 0);
  }

  if(fd < 0) {
    fprintf(2, "tail: cannot open %s\n", argv[1]);
    exit(1);
  }

  readlines(fd);
  printtail(n);

  close(fd);
  exit(0);
}
