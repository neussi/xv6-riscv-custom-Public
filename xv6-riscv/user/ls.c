#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[DIRSIZ] = 0;
  return buf;
}

void
ls(char *path, int long_listing)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_FILE:
    if(long_listing)
      printf("%s %d %d %ld\n", fmtname(path), st.type, st.ino, st.size);
    else
      printf("%s\n", fmtname(path));
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      if(long_listing)
        printf("%s %d %d %ld\n", fmtname(buf), st.type, st.ino, st.size);
      else
        printf("%s\n", fmtname(buf));
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int i;
  int long_listing = 0;

  if(argc > 1 && strcmp(argv[1], "-l") == 0){
    long_listing = 1;
    argc--;
    argv++;
  }

  if(argc < 2){
    ls(".", long_listing);
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i], long_listing);
  exit(0);
}
