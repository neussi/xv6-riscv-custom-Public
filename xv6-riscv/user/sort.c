#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define MAXLINES 1000  // Nombre maximal de lignes
#define MAXLEN   100   // Longueur maximale d'une ligne

char *lines[MAXLINES];
char content[MAXLINES][MAXLEN];
int nlines = 0;

void
swap(int i, int j)
{
  char *temp = lines[i];
  lines[i] = lines[j];
  lines[j] = temp;
}

void
qsort(int left, int right)
{
  int i, last;

  if(left >= right)
    return;

  swap(left, (left + right)/2);
  last = left;

  for(i = left + 1; i <= right; i++)
    if(strcmp(lines[i], lines[left]) < 0)
      swap(++last, i);

  swap(left, last);
  qsort(left, last-1);
  qsort(last+1, right);
}

int
main(int argc, char *argv[])
{
  char buf;
  int i = 0, j = 0;
  int fd = 0;

  if(argc > 1) {
    if((fd = open(argv[1], 0)) < 0) {
      fprintf(2, "sort: cannot open %s\n", argv[1]);
      exit(1);
    }
  }

  // Initialiser la première ligne
  lines[0] = content[0];
  
  // Lire le fichier caractère par caractère
  while(read(fd, &buf, 1) == 1) {
    if(buf == '\n') {
      content[i][j] = '\0';
      i++;
      if(i >= MAXLINES) break;
      lines[i] = content[i];
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

  // Trier et afficher
  qsort(0, nlines-1);
  for(i = 0; i < nlines; i++)
    printf("%s\n", lines[i]);

  close(fd);
  exit(0);
}
