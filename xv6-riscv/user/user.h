#ifndef USER_H
#define USER_H

#include "kernel/types.h"
#include "kernel/procstat.h"

// ... reste du code ...

struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
int atoi(const char*);

unsigned int strlen(const char*);
void* memset(void*, int, unsigned int);
int memcmp(const void *, const void *, unsigned int);
void *memcpy(void *, const void *, unsigned int);
void* malloc(unsigned int);

// umalloc.c
void free(void*);
int lseek(int fd, int offset, int whence);

// Ajoutez cette ligne avec les autres déclarations de fonctions système
int getprocs(struct proc_stat*, int);

// Dans user/user.h
int exit_qemu(void);


#endif // USER_H
