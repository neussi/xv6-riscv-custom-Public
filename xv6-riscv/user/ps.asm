
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/proc.h"

#define NPROC 64  // Nombre maximal de processus

int main(int argc, char *argv[]) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	81010113          	addi	sp,sp,-2032
  struct proc_stat pstat[NPROC];
  int count;

  // Appeler la syscall pour obtenir les informations des processus
  count = getprocstat(pstat, NPROC);
  12:	04000593          	li	a1,64
  16:	77fd                	lui	a5,0xfffff
  18:	7d078793          	addi	a5,a5,2000 # fffffffffffff7d0 <base+0xffffffffffffe7c0>
  1c:	00f40533          	add	a0,s0,a5
  20:	392000ef          	jal	ra,3b2 <getprocstat>
  24:	892a                	mv	s2,a0
  printf("getprocstat returned: %d\n", count);  // Afficher la valeur de retour
  26:	85aa                	mv	a1,a0
  28:	00001517          	auipc	a0,0x1
  2c:	8a850513          	addi	a0,a0,-1880 # 8d0 <malloc+0xea>
  30:	6fc000ef          	jal	ra,72c <printf>
  if (count < 0) {
  34:	04094c63          	bltz	s2,8c <main+0x8c>
    printf("ps: erreur lors de la récupération des informations des processus\n");
    exit(1);
  }

  // Afficher les informations des processus
  printf("PID\tÉtat\tTemps CPU\tNom\n");
  38:	00001517          	auipc	a0,0x1
  3c:	90050513          	addi	a0,a0,-1792 # 938 <malloc+0x152>
  40:	6ec000ef          	jal	ra,72c <printf>
  for (int i = 0; i < count; i++) {
  44:	05205163          	blez	s2,86 <main+0x86>
  48:	77fd                	lui	a5,0xfffff
  4a:	7e078793          	addi	a5,a5,2016 # fffffffffffff7e0 <base+0xffffffffffffe7d0>
  4e:	00f404b3          	add	s1,s0,a5
  52:	397d                	addiw	s2,s2,-1
  54:	1902                	slli	s2,s2,0x20
  56:	02095913          	srli	s2,s2,0x20
  5a:	0916                	slli	s2,s2,0x5
  5c:	80040793          	addi	a5,s0,-2048
  60:	993e                	add	s2,s2,a5
    printf("%d\t%d\t%ld\t\t%s\n", pstat[i].pid, pstat[i].state, pstat[i].cputicks, pstat[i].name);
  62:	00001997          	auipc	s3,0x1
  66:	8f698993          	addi	s3,s3,-1802 # 958 <malloc+0x172>
  6a:	8726                	mv	a4,s1
  6c:	ff84b683          	ld	a3,-8(s1)
  70:	ff44a603          	lw	a2,-12(s1)
  74:	ff04a583          	lw	a1,-16(s1)
  78:	854e                	mv	a0,s3
  7a:	6b2000ef          	jal	ra,72c <printf>
  for (int i = 0; i < count; i++) {
  7e:	02048493          	addi	s1,s1,32
  82:	ff2494e3          	bne	s1,s2,6a <main+0x6a>
  }

  exit(0);
  86:	4501                	li	a0,0
  88:	282000ef          	jal	ra,30a <exit>
    printf("ps: erreur lors de la récupération des informations des processus\n");
  8c:	00001517          	auipc	a0,0x1
  90:	86450513          	addi	a0,a0,-1948 # 8f0 <malloc+0x10a>
  94:	698000ef          	jal	ra,72c <printf>
    exit(1);
  98:	4505                	li	a0,1
  9a:	270000ef          	jal	ra,30a <exit>

000000000000009e <start>:
//


void
start()
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  a6:	f5bff0ef          	jal	ra,0 <main>
  exit(0);
  aa:	4501                	li	a0,0
  ac:	25e000ef          	jal	ra,30a <exit>

00000000000000b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b6:	87aa                	mv	a5,a0
  b8:	0585                	addi	a1,a1,1
  ba:	0785                	addi	a5,a5,1
  bc:	fff5c703          	lbu	a4,-1(a1)
  c0:	fee78fa3          	sb	a4,-1(a5)
  c4:	fb75                	bnez	a4,b8 <strcpy+0x8>
    ;
  return os;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x1e>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x1e>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strlen>:

uint
strlen(const char *s)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cf91                	beqz	a5,11e <strlen+0x26>
 104:	0505                	addi	a0,a0,1
 106:	87aa                	mv	a5,a0
 108:	4685                	li	a3,1
 10a:	9e89                	subw	a3,a3,a0
 10c:	00f6853b          	addw	a0,a3,a5
 110:	0785                	addi	a5,a5,1
 112:	fff7c703          	lbu	a4,-1(a5)
 116:	fb7d                	bnez	a4,10c <strlen+0x14>
    ;
  return n;
}
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret
  for(n = 0; s[n]; n++)
 11e:	4501                	li	a0,0
 120:	bfe5                	j	118 <strlen+0x20>

0000000000000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 128:	ca19                	beqz	a2,13e <memset+0x1c>
 12a:	87aa                	mv	a5,a0
 12c:	1602                	slli	a2,a2,0x20
 12e:	9201                	srli	a2,a2,0x20
 130:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 134:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 138:	0785                	addi	a5,a5,1
 13a:	fee79de3          	bne	a5,a4,134 <memset+0x12>
  }
  return dst;
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strchr>:

char*
strchr(const char *s, char c)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  for(; *s; s++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cb99                	beqz	a5,164 <strchr+0x20>
    if(*s == c)
 150:	00f58763          	beq	a1,a5,15e <strchr+0x1a>
  for(; *s; s++)
 154:	0505                	addi	a0,a0,1
 156:	00054783          	lbu	a5,0(a0)
 15a:	fbfd                	bnez	a5,150 <strchr+0xc>
      return (char*)s;
  return 0;
 15c:	4501                	li	a0,0
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  return 0;
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strchr+0x1a>

0000000000000168 <gets>:

char*
gets(char *buf, int max)
{
 168:	711d                	addi	sp,sp,-96
 16a:	ec86                	sd	ra,88(sp)
 16c:	e8a2                	sd	s0,80(sp)
 16e:	e4a6                	sd	s1,72(sp)
 170:	e0ca                	sd	s2,64(sp)
 172:	fc4e                	sd	s3,56(sp)
 174:	f852                	sd	s4,48(sp)
 176:	f456                	sd	s5,40(sp)
 178:	f05a                	sd	s6,32(sp)
 17a:	ec5e                	sd	s7,24(sp)
 17c:	1080                	addi	s0,sp,96
 17e:	8baa                	mv	s7,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 186:	4aa9                	li	s5,10
 188:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 18a:	89a6                	mv	s3,s1
 18c:	2485                	addiw	s1,s1,1
 18e:	0344d663          	bge	s1,s4,1ba <gets+0x52>
    cc = read(0, &c, 1);
 192:	4605                	li	a2,1
 194:	faf40593          	addi	a1,s0,-81
 198:	4501                	li	a0,0
 19a:	188000ef          	jal	ra,322 <read>
    if(cc < 1)
 19e:	00a05e63          	blez	a0,1ba <gets+0x52>
    buf[i++] = c;
 1a2:	faf44783          	lbu	a5,-81(s0)
 1a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1aa:	01578763          	beq	a5,s5,1b8 <gets+0x50>
 1ae:	0905                	addi	s2,s2,1
 1b0:	fd679de3          	bne	a5,s6,18a <gets+0x22>
  for(i=0; i+1 < max; ){
 1b4:	89a6                	mv	s3,s1
 1b6:	a011                	j	1ba <gets+0x52>
 1b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ba:	99de                	add	s3,s3,s7
 1bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c0:	855e                	mv	a0,s7
 1c2:	60e6                	ld	ra,88(sp)
 1c4:	6446                	ld	s0,80(sp)
 1c6:	64a6                	ld	s1,72(sp)
 1c8:	6906                	ld	s2,64(sp)
 1ca:	79e2                	ld	s3,56(sp)
 1cc:	7a42                	ld	s4,48(sp)
 1ce:	7aa2                	ld	s5,40(sp)
 1d0:	7b02                	ld	s6,32(sp)
 1d2:	6be2                	ld	s7,24(sp)
 1d4:	6125                	addi	sp,sp,96
 1d6:	8082                	ret

00000000000001d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d8:	1101                	addi	sp,sp,-32
 1da:	ec06                	sd	ra,24(sp)
 1dc:	e822                	sd	s0,16(sp)
 1de:	e426                	sd	s1,8(sp)
 1e0:	e04a                	sd	s2,0(sp)
 1e2:	1000                	addi	s0,sp,32
 1e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	4581                	li	a1,0
 1e8:	162000ef          	jal	ra,34a <open>
  if(fd < 0)
 1ec:	02054163          	bltz	a0,20e <stat+0x36>
 1f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f2:	85ca                	mv	a1,s2
 1f4:	16e000ef          	jal	ra,362 <fstat>
 1f8:	892a                	mv	s2,a0
  close(fd);
 1fa:	8526                	mv	a0,s1
 1fc:	136000ef          	jal	ra,332 <close>
  return r;
}
 200:	854a                	mv	a0,s2
 202:	60e2                	ld	ra,24(sp)
 204:	6442                	ld	s0,16(sp)
 206:	64a2                	ld	s1,8(sp)
 208:	6902                	ld	s2,0(sp)
 20a:	6105                	addi	sp,sp,32
 20c:	8082                	ret
    return -1;
 20e:	597d                	li	s2,-1
 210:	bfc5                	j	200 <stat+0x28>

0000000000000212 <atoi>:

int
atoi(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 218:	00054603          	lbu	a2,0(a0)
 21c:	fd06079b          	addiw	a5,a2,-48
 220:	0ff7f793          	andi	a5,a5,255
 224:	4725                	li	a4,9
 226:	02f76963          	bltu	a4,a5,258 <atoi+0x46>
 22a:	86aa                	mv	a3,a0
  n = 0;
 22c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 22e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 230:	0685                	addi	a3,a3,1
 232:	0025179b          	slliw	a5,a0,0x2
 236:	9fa9                	addw	a5,a5,a0
 238:	0017979b          	slliw	a5,a5,0x1
 23c:	9fb1                	addw	a5,a5,a2
 23e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 242:	0006c603          	lbu	a2,0(a3)
 246:	fd06071b          	addiw	a4,a2,-48
 24a:	0ff77713          	andi	a4,a4,255
 24e:	fee5f1e3          	bgeu	a1,a4,230 <atoi+0x1e>
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  n = 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <atoi+0x40>

000000000000025c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 262:	02b57463          	bgeu	a0,a1,28a <memmove+0x2e>
    while(n-- > 0)
 266:	00c05f63          	blez	a2,284 <memmove+0x28>
 26a:	1602                	slli	a2,a2,0x20
 26c:	9201                	srli	a2,a2,0x20
 26e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 272:	872a                	mv	a4,a0
      *dst++ = *src++;
 274:	0585                	addi	a1,a1,1
 276:	0705                	addi	a4,a4,1
 278:	fff5c683          	lbu	a3,-1(a1)
 27c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 290:	fec05ae3          	blez	a2,284 <memmove+0x28>
 294:	fff6079b          	addiw	a5,a2,-1
 298:	1782                	slli	a5,a5,0x20
 29a:	9381                	srli	a5,a5,0x20
 29c:	fff7c793          	not	a5,a5
 2a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a2:	15fd                	addi	a1,a1,-1
 2a4:	177d                	addi	a4,a4,-1
 2a6:	0005c683          	lbu	a3,0(a1)
 2aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ae:	fee79ae3          	bne	a5,a4,2a2 <memmove+0x46>
 2b2:	bfc9                	j	284 <memmove+0x28>

00000000000002b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ba:	ca05                	beqz	a2,2ea <memcmp+0x36>
 2bc:	fff6069b          	addiw	a3,a2,-1
 2c0:	1682                	slli	a3,a3,0x20
 2c2:	9281                	srli	a3,a3,0x20
 2c4:	0685                	addi	a3,a3,1
 2c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00e79863          	bne	a5,a4,2e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d4:	0505                	addi	a0,a0,1
    p2++;
 2d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d8:	fed518e3          	bne	a0,a3,2c8 <memcmp+0x14>
  }
  return 0;
 2dc:	4501                	li	a0,0
 2de:	a019                	j	2e4 <memcmp+0x30>
      return *p1 - *p2;
 2e0:	40e7853b          	subw	a0,a5,a4
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <memcmp+0x30>

00000000000002ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f6:	f67ff0ef          	jal	ra,25c <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getprocstat>:
.global getprocstat
getprocstat:
 li a7, SYS_getprocstat
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 3ba:	48e1                	li	a7,24
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	1000                	addi	s0,sp,32
 3ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ce:	4605                	li	a2,1
 3d0:	fef40593          	addi	a1,s0,-17
 3d4:	f57ff0ef          	jal	ra,32a <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f426                	sd	s1,40(sp)
 3e8:	f04a                	sd	s2,32(sp)
 3ea:	ec4e                	sd	s3,24(sp)
 3ec:	0080                	addi	s0,sp,64
 3ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f0:	c299                	beqz	a3,3f6 <printint+0x16>
 3f2:	0805c663          	bltz	a1,47e <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f6:	2581                	sext.w	a1,a1
  neg = 0;
 3f8:	4881                	li	a7,0
 3fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 400:	2601                	sext.w	a2,a2
 402:	00000517          	auipc	a0,0x0
 406:	56e50513          	addi	a0,a0,1390 # 970 <digits>
 40a:	883a                	mv	a6,a4
 40c:	2705                	addiw	a4,a4,1
 40e:	02c5f7bb          	remuw	a5,a1,a2
 412:	1782                	slli	a5,a5,0x20
 414:	9381                	srli	a5,a5,0x20
 416:	97aa                	add	a5,a5,a0
 418:	0007c783          	lbu	a5,0(a5)
 41c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 420:	0005879b          	sext.w	a5,a1
 424:	02c5d5bb          	divuw	a1,a1,a2
 428:	0685                	addi	a3,a3,1
 42a:	fec7f0e3          	bgeu	a5,a2,40a <printint+0x2a>
  if(neg)
 42e:	00088b63          	beqz	a7,444 <printint+0x64>
    buf[i++] = '-';
 432:	fd040793          	addi	a5,s0,-48
 436:	973e                	add	a4,a4,a5
 438:	02d00793          	li	a5,45
 43c:	fef70823          	sb	a5,-16(a4)
 440:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 444:	02e05663          	blez	a4,470 <printint+0x90>
 448:	fc040793          	addi	a5,s0,-64
 44c:	00e78933          	add	s2,a5,a4
 450:	fff78993          	addi	s3,a5,-1
 454:	99ba                	add	s3,s3,a4
 456:	377d                	addiw	a4,a4,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 460:	fff94583          	lbu	a1,-1(s2)
 464:	8526                	mv	a0,s1
 466:	f5dff0ef          	jal	ra,3c2 <putc>
  while(--i >= 0)
 46a:	197d                	addi	s2,s2,-1
 46c:	ff391ae3          	bne	s2,s3,460 <printint+0x80>
}
 470:	70e2                	ld	ra,56(sp)
 472:	7442                	ld	s0,48(sp)
 474:	74a2                	ld	s1,40(sp)
 476:	7902                	ld	s2,32(sp)
 478:	69e2                	ld	s3,24(sp)
 47a:	6121                	addi	sp,sp,64
 47c:	8082                	ret
    x = -xx;
 47e:	40b005bb          	negw	a1,a1
    neg = 1;
 482:	4885                	li	a7,1
    x = -xx;
 484:	bf9d                	j	3fa <printint+0x1a>

0000000000000486 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 486:	7119                	addi	sp,sp,-128
 488:	fc86                	sd	ra,120(sp)
 48a:	f8a2                	sd	s0,112(sp)
 48c:	f4a6                	sd	s1,104(sp)
 48e:	f0ca                	sd	s2,96(sp)
 490:	ecce                	sd	s3,88(sp)
 492:	e8d2                	sd	s4,80(sp)
 494:	e4d6                	sd	s5,72(sp)
 496:	e0da                	sd	s6,64(sp)
 498:	fc5e                	sd	s7,56(sp)
 49a:	f862                	sd	s8,48(sp)
 49c:	f466                	sd	s9,40(sp)
 49e:	f06a                	sd	s10,32(sp)
 4a0:	ec6e                	sd	s11,24(sp)
 4a2:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a4:	0005c903          	lbu	s2,0(a1)
 4a8:	22090e63          	beqz	s2,6e4 <vprintf+0x25e>
 4ac:	8b2a                	mv	s6,a0
 4ae:	8a2e                	mv	s4,a1
 4b0:	8bb2                	mv	s7,a2
  state = 0;
 4b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b4:	4481                	li	s1,0
 4b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c0:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c4:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c8:	00000c97          	auipc	s9,0x0
 4cc:	4a8c8c93          	addi	s9,s9,1192 # 970 <digits>
 4d0:	a005                	j	4f0 <vprintf+0x6a>
        putc(fd, c0);
 4d2:	85ca                	mv	a1,s2
 4d4:	855a                	mv	a0,s6
 4d6:	eedff0ef          	jal	ra,3c2 <putc>
 4da:	a019                	j	4e0 <vprintf+0x5a>
    } else if(state == '%'){
 4dc:	03598263          	beq	s3,s5,500 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e0:	2485                	addiw	s1,s1,1
 4e2:	8726                	mv	a4,s1
 4e4:	009a07b3          	add	a5,s4,s1
 4e8:	0007c903          	lbu	s2,0(a5)
 4ec:	1e090c63          	beqz	s2,6e4 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 4f0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f4:	fe0994e3          	bnez	s3,4dc <vprintf+0x56>
      if(c0 == '%'){
 4f8:	fd579de3          	bne	a5,s5,4d2 <vprintf+0x4c>
        state = '%';
 4fc:	89be                	mv	s3,a5
 4fe:	b7cd                	j	4e0 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 500:	cfa5                	beqz	a5,578 <vprintf+0xf2>
 502:	00ea06b3          	add	a3,s4,a4
 506:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 50a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50c:	c681                	beqz	a3,514 <vprintf+0x8e>
 50e:	9752                	add	a4,a4,s4
 510:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 514:	03878a63          	beq	a5,s8,548 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 518:	05a78463          	beq	a5,s10,560 <vprintf+0xda>
      } else if(c0 == 'u'){
 51c:	0db78763          	beq	a5,s11,5ea <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 520:	07800713          	li	a4,120
 524:	10e78963          	beq	a5,a4,636 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 528:	07000713          	li	a4,112
 52c:	12e78e63          	beq	a5,a4,668 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 530:	07300713          	li	a4,115
 534:	16e78b63          	beq	a5,a4,6aa <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 538:	05579063          	bne	a5,s5,578 <vprintf+0xf2>
        putc(fd, '%');
 53c:	85d6                	mv	a1,s5
 53e:	855a                	mv	a0,s6
 540:	e83ff0ef          	jal	ra,3c2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 544:	4981                	li	s3,0
 546:	bf69                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 548:	008b8913          	addi	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e8bff0ef          	jal	ra,3e0 <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b749                	j	4e0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 560:	03868663          	beq	a3,s8,58c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	05a68163          	beq	a3,s10,5a6 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 568:	09b68d63          	beq	a3,s11,602 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56c:	03a68f63          	beq	a3,s10,5aa <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 570:	07800793          	li	a5,120
 574:	0cf68d63          	beq	a3,a5,64e <vprintf+0x1c8>
        putc(fd, '%');
 578:	85d6                	mv	a1,s5
 57a:	855a                	mv	a0,s6
 57c:	e47ff0ef          	jal	ra,3c2 <putc>
        putc(fd, c0);
 580:	85ca                	mv	a1,s2
 582:	855a                	mv	a0,s6
 584:	e3fff0ef          	jal	ra,3c2 <putc>
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf99                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e47ff0ef          	jal	ra,3e0 <printint>
        i += 1;
 59e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
        i += 1;
 5a4:	bf35                	j	4e0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a6:	03860563          	beq	a2,s8,5d0 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5aa:	07b60963          	beq	a2,s11,61c <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ae:	07800793          	li	a5,120
 5b2:	fcf613e3          	bne	a2,a5,578 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4641                	li	a2,16
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e1dff0ef          	jal	ra,3e0 <printint>
        i += 2;
 5c8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bf09                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4685                	li	a3,1
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e03ff0ef          	jal	ra,3e0 <printint>
        i += 2;
 5e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	bde5                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	de9ff0ef          	jal	ra,3e0 <printint>
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b5c5                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8913          	addi	s2,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	dd1ff0ef          	jal	ra,3e0 <printint>
        i += 1;
 614:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 1;
 61a:	b5d9                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	db7ff0ef          	jal	ra,3e0 <printint>
        i += 2;
 62e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	b575                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	d9dff0ef          	jal	ra,3e0 <printint>
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bd51                	j	4e0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	008b8913          	addi	s2,s7,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	d85ff0ef          	jal	ra,3e0 <printint>
        i += 1;
 660:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
        i += 1;
 666:	bdad                	j	4e0 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 668:	008b8793          	addi	a5,s7,8
 66c:	f8f43423          	sd	a5,-120(s0)
 670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	855a                	mv	a0,s6
 67a:	d49ff0ef          	jal	ra,3c2 <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	855a                	mv	a0,s6
 684:	d3fff0ef          	jal	ra,3c2 <putc>
 688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	03c9d793          	srli	a5,s3,0x3c
 68e:	97e6                	add	a5,a5,s9
 690:	0007c583          	lbu	a1,0(a5)
 694:	855a                	mv	a0,s6
 696:	d2dff0ef          	jal	ra,3c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69a:	0992                	slli	s3,s3,0x4
 69c:	397d                	addiw	s2,s2,-1
 69e:	fe0916e3          	bnez	s2,68a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6a2:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd25                	j	4e0 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6aa:	008b8993          	addi	s3,s7,8
 6ae:	000bb903          	ld	s2,0(s7)
 6b2:	00090f63          	beqz	s2,6d0 <vprintf+0x24a>
        for(; *s; s++)
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	c195                	beqz	a1,6de <vprintf+0x258>
          putc(fd, *s);
 6bc:	855a                	mv	a0,s6
 6be:	d05ff0ef          	jal	ra,3c2 <putc>
        for(; *s; s++)
 6c2:	0905                	addi	s2,s2,1
 6c4:	00094583          	lbu	a1,0(s2)
 6c8:	f9f5                	bnez	a1,6bc <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd09                	j	4e0 <vprintf+0x5a>
          s = "(null)";
 6d0:	00000917          	auipc	s2,0x0
 6d4:	29890913          	addi	s2,s2,664 # 968 <malloc+0x182>
        for(; *s; s++)
 6d8:	02800593          	li	a1,40
 6dc:	b7c5                	j	6bc <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bbfd                	j	4e0 <vprintf+0x5a>
    }
  }
}
 6e4:	70e6                	ld	ra,120(sp)
 6e6:	7446                	ld	s0,112(sp)
 6e8:	74a6                	ld	s1,104(sp)
 6ea:	7906                	ld	s2,96(sp)
 6ec:	69e6                	ld	s3,88(sp)
 6ee:	6a46                	ld	s4,80(sp)
 6f0:	6aa6                	ld	s5,72(sp)
 6f2:	6b06                	ld	s6,64(sp)
 6f4:	7be2                	ld	s7,56(sp)
 6f6:	7c42                	ld	s8,48(sp)
 6f8:	7ca2                	ld	s9,40(sp)
 6fa:	7d02                	ld	s10,32(sp)
 6fc:	6de2                	ld	s11,24(sp)
 6fe:	6109                	addi	sp,sp,128
 700:	8082                	ret

0000000000000702 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 702:	715d                	addi	sp,sp,-80
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	e010                	sd	a2,0(s0)
 70c:	e414                	sd	a3,8(s0)
 70e:	e818                	sd	a4,16(s0)
 710:	ec1c                	sd	a5,24(s0)
 712:	03043023          	sd	a6,32(s0)
 716:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71e:	8622                	mv	a2,s0
 720:	d67ff0ef          	jal	ra,486 <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6161                	addi	sp,sp,80
 72a:	8082                	ret

000000000000072c <printf>:

void
printf(const char *fmt, ...)
{
 72c:	711d                	addi	sp,sp,-96
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e40c                	sd	a1,8(s0)
 736:	e810                	sd	a2,16(s0)
 738:	ec14                	sd	a3,24(s0)
 73a:	f018                	sd	a4,32(s0)
 73c:	f41c                	sd	a5,40(s0)
 73e:	03043823          	sd	a6,48(s0)
 742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	00840613          	addi	a2,s0,8
 74a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74e:	85aa                	mv	a1,a0
 750:	4505                	li	a0,1
 752:	d35ff0ef          	jal	ra,486 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e422                	sd	s0,8(sp)
 762:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 764:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	00001797          	auipc	a5,0x1
 76c:	8987b783          	ld	a5,-1896(a5) # 1000 <freep>
 770:	a805                	j	7a0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 772:	4618                	lw	a4,8(a2)
 774:	9db9                	addw	a1,a1,a4
 776:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	6398                	ld	a4,0(a5)
 77c:	6318                	ld	a4,0(a4)
 77e:	fee53823          	sd	a4,-16(a0)
 782:	a091                	j	7c6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 784:	ff852703          	lw	a4,-8(a0)
 788:	9e39                	addw	a2,a2,a4
 78a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 78c:	ff053703          	ld	a4,-16(a0)
 790:	e398                	sd	a4,0(a5)
 792:	a099                	j	7d8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	6398                	ld	a4,0(a5)
 796:	00e7e463          	bltu	a5,a4,79e <free+0x40>
 79a:	00e6ea63          	bltu	a3,a4,7ae <free+0x50>
{
 79e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	fed7fae3          	bgeu	a5,a3,794 <free+0x36>
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e6e463          	bltu	a3,a4,7ae <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7aa:	fee7eae3          	bltu	a5,a4,79e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ae:	ff852583          	lw	a1,-8(a0)
 7b2:	6390                	ld	a2,0(a5)
 7b4:	02059713          	slli	a4,a1,0x20
 7b8:	9301                	srli	a4,a4,0x20
 7ba:	0712                	slli	a4,a4,0x4
 7bc:	9736                	add	a4,a4,a3
 7be:	fae60ae3          	beq	a2,a4,772 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c6:	4790                	lw	a2,8(a5)
 7c8:	02061713          	slli	a4,a2,0x20
 7cc:	9301                	srli	a4,a4,0x20
 7ce:	0712                	slli	a4,a4,0x4
 7d0:	973e                	add	a4,a4,a5
 7d2:	fae689e3          	beq	a3,a4,784 <free+0x26>
  } else
    p->s.ptr = bp;
 7d6:	e394                	sd	a3,0(a5)
  freep = p;
 7d8:	00001717          	auipc	a4,0x1
 7dc:	82f73423          	sd	a5,-2008(a4) # 1000 <freep>
}
 7e0:	6422                	ld	s0,8(sp)
 7e2:	0141                	addi	sp,sp,16
 7e4:	8082                	ret

00000000000007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e6:	7139                	addi	sp,sp,-64
 7e8:	fc06                	sd	ra,56(sp)
 7ea:	f822                	sd	s0,48(sp)
 7ec:	f426                	sd	s1,40(sp)
 7ee:	f04a                	sd	s2,32(sp)
 7f0:	ec4e                	sd	s3,24(sp)
 7f2:	e852                	sd	s4,16(sp)
 7f4:	e456                	sd	s5,8(sp)
 7f6:	e05a                	sd	s6,0(sp)
 7f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	02051493          	slli	s1,a0,0x20
 7fe:	9081                	srli	s1,s1,0x20
 800:	04bd                	addi	s1,s1,15
 802:	8091                	srli	s1,s1,0x4
 804:	0014899b          	addiw	s3,s1,1
 808:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80a:	00000517          	auipc	a0,0x0
 80e:	7f653503          	ld	a0,2038(a0) # 1000 <freep>
 812:	c515                	beqz	a0,83e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 816:	4798                	lw	a4,8(a5)
 818:	02977f63          	bgeu	a4,s1,856 <malloc+0x70>
 81c:	8a4e                	mv	s4,s3
 81e:	0009871b          	sext.w	a4,s3
 822:	6685                	lui	a3,0x1
 824:	00d77363          	bgeu	a4,a3,82a <malloc+0x44>
 828:	6a05                	lui	s4,0x1
 82a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 832:	00000917          	auipc	s2,0x0
 836:	7ce90913          	addi	s2,s2,1998 # 1000 <freep>
  if(p == (char*)-1)
 83a:	5afd                	li	s5,-1
 83c:	a0bd                	j	8aa <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 83e:	00000797          	auipc	a5,0x0
 842:	7d278793          	addi	a5,a5,2002 # 1010 <base>
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
 84e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 850:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 854:	b7e1                	j	81c <malloc+0x36>
      if(p->s.size == nunits)
 856:	02e48b63          	beq	s1,a4,88c <malloc+0xa6>
        p->s.size -= nunits;
 85a:	4137073b          	subw	a4,a4,s3
 85e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 860:	1702                	slli	a4,a4,0x20
 862:	9301                	srli	a4,a4,0x20
 864:	0712                	slli	a4,a4,0x4
 866:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 868:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86c:	00000717          	auipc	a4,0x0
 870:	78a73a23          	sd	a0,1940(a4) # 1000 <freep>
      return (void*)(p + 1);
 874:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 878:	70e2                	ld	ra,56(sp)
 87a:	7442                	ld	s0,48(sp)
 87c:	74a2                	ld	s1,40(sp)
 87e:	7902                	ld	s2,32(sp)
 880:	69e2                	ld	s3,24(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	6121                	addi	sp,sp,64
 88a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	e118                	sd	a4,0(a0)
 890:	bff1                	j	86c <malloc+0x86>
  hp->s.size = nu;
 892:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 896:	0541                	addi	a0,a0,16
 898:	ec7ff0ef          	jal	ra,75e <free>
  return freep;
 89c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a0:	dd61                	beqz	a0,878 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	fa9778e3          	bgeu	a4,s1,856 <malloc+0x70>
    if(p == freep)
 8aa:	00093703          	ld	a4,0(s2)
 8ae:	853e                	mv	a0,a5
 8b0:	fef719e3          	bne	a4,a5,8a2 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8b4:	8552                	mv	a0,s4
 8b6:	addff0ef          	jal	ra,392 <sbrk>
  if(p == (char*)-1)
 8ba:	fd551ce3          	bne	a0,s5,892 <malloc+0xac>
        return 0;
 8be:	4501                	li	a0,0
 8c0:	bf65                	j	878 <malloc+0x92>
