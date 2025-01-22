
user/_exit:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(void) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  exit_qemu();  // Appelle la syscall pour fermer QEMU
   8:	326000ef          	jal	ra,32e <exit_qemu>
  exit(0);
   c:	4501                	li	a0,0
   e:	270000ef          	jal	ra,27e <exit>

0000000000000012 <start>:
//


void
start()
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  extern int main();
  main();
  1a:	fe7ff0ef          	jal	ra,0 <main>
  exit(0);
  1e:	4501                	li	a0,0
  20:	25e000ef          	jal	ra,27e <exit>

0000000000000024 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  24:	1141                	addi	sp,sp,-16
  26:	e422                	sd	s0,8(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0x8>
    ;
  return os;
}
  3a:	6422                	ld	s0,8(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret

0000000000000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	1141                	addi	sp,sp,-16
  42:	e422                	sd	s0,8(sp)
  44:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  46:	00054783          	lbu	a5,0(a0)
  4a:	cb91                	beqz	a5,5e <strcmp+0x1e>
  4c:	0005c703          	lbu	a4,0(a1)
  50:	00f71763          	bne	a4,a5,5e <strcmp+0x1e>
    p++, q++;
  54:	0505                	addi	a0,a0,1
  56:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	fbe5                	bnez	a5,4c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5e:	0005c503          	lbu	a0,0(a1)
}
  62:	40a7853b          	subw	a0,a5,a0
  66:	6422                	ld	s0,8(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <strlen>:

uint
strlen(const char *s)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  72:	00054783          	lbu	a5,0(a0)
  76:	cf91                	beqz	a5,92 <strlen+0x26>
  78:	0505                	addi	a0,a0,1
  7a:	87aa                	mv	a5,a0
  7c:	4685                	li	a3,1
  7e:	9e89                	subw	a3,a3,a0
  80:	00f6853b          	addw	a0,a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	fb7d                	bnez	a4,80 <strlen+0x14>
    ;
  return n;
}
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret
  for(n = 0; s[n]; n++)
  92:	4501                	li	a0,0
  94:	bfe5                	j	8c <strlen+0x20>

0000000000000096 <memset>:

void*
memset(void *dst, int c, uint n)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  9c:	ca19                	beqz	a2,b2 <memset+0x1c>
  9e:	87aa                	mv	a5,a0
  a0:	1602                	slli	a2,a2,0x20
  a2:	9201                	srli	a2,a2,0x20
  a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ac:	0785                	addi	a5,a5,1
  ae:	fee79de3          	bne	a5,a4,a8 <memset+0x12>
  }
  return dst;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strchr>:

char*
strchr(const char *s, char c)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb99                	beqz	a5,d8 <strchr+0x20>
    if(*s == c)
  c4:	00f58763          	beq	a1,a5,d2 <strchr+0x1a>
  for(; *s; s++)
  c8:	0505                	addi	a0,a0,1
  ca:	00054783          	lbu	a5,0(a0)
  ce:	fbfd                	bnez	a5,c4 <strchr+0xc>
      return (char*)s;
  return 0;
  d0:	4501                	li	a0,0
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  return 0;
  d8:	4501                	li	a0,0
  da:	bfe5                	j	d2 <strchr+0x1a>

00000000000000dc <gets>:

char*
gets(char *buf, int max)
{
  dc:	711d                	addi	sp,sp,-96
  de:	ec86                	sd	ra,88(sp)
  e0:	e8a2                	sd	s0,80(sp)
  e2:	e4a6                	sd	s1,72(sp)
  e4:	e0ca                	sd	s2,64(sp)
  e6:	fc4e                	sd	s3,56(sp)
  e8:	f852                	sd	s4,48(sp)
  ea:	f456                	sd	s5,40(sp)
  ec:	f05a                	sd	s6,32(sp)
  ee:	ec5e                	sd	s7,24(sp)
  f0:	1080                	addi	s0,sp,96
  f2:	8baa                	mv	s7,a0
  f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f6:	892a                	mv	s2,a0
  f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  fa:	4aa9                	li	s5,10
  fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fe:	89a6                	mv	s3,s1
 100:	2485                	addiw	s1,s1,1
 102:	0344d663          	bge	s1,s4,12e <gets+0x52>
    cc = read(0, &c, 1);
 106:	4605                	li	a2,1
 108:	faf40593          	addi	a1,s0,-81
 10c:	4501                	li	a0,0
 10e:	188000ef          	jal	ra,296 <read>
    if(cc < 1)
 112:	00a05e63          	blez	a0,12e <gets+0x52>
    buf[i++] = c;
 116:	faf44783          	lbu	a5,-81(s0)
 11a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11e:	01578763          	beq	a5,s5,12c <gets+0x50>
 122:	0905                	addi	s2,s2,1
 124:	fd679de3          	bne	a5,s6,fe <gets+0x22>
  for(i=0; i+1 < max; ){
 128:	89a6                	mv	s3,s1
 12a:	a011                	j	12e <gets+0x52>
 12c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12e:	99de                	add	s3,s3,s7
 130:	00098023          	sb	zero,0(s3)
  return buf;
}
 134:	855e                	mv	a0,s7
 136:	60e6                	ld	ra,88(sp)
 138:	6446                	ld	s0,80(sp)
 13a:	64a6                	ld	s1,72(sp)
 13c:	6906                	ld	s2,64(sp)
 13e:	79e2                	ld	s3,56(sp)
 140:	7a42                	ld	s4,48(sp)
 142:	7aa2                	ld	s5,40(sp)
 144:	7b02                	ld	s6,32(sp)
 146:	6be2                	ld	s7,24(sp)
 148:	6125                	addi	sp,sp,96
 14a:	8082                	ret

000000000000014c <stat>:

int
stat(const char *n, struct stat *st)
{
 14c:	1101                	addi	sp,sp,-32
 14e:	ec06                	sd	ra,24(sp)
 150:	e822                	sd	s0,16(sp)
 152:	e426                	sd	s1,8(sp)
 154:	e04a                	sd	s2,0(sp)
 156:	1000                	addi	s0,sp,32
 158:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15a:	4581                	li	a1,0
 15c:	162000ef          	jal	ra,2be <open>
  if(fd < 0)
 160:	02054163          	bltz	a0,182 <stat+0x36>
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	16e000ef          	jal	ra,2d6 <fstat>
 16c:	892a                	mv	s2,a0
  close(fd);
 16e:	8526                	mv	a0,s1
 170:	136000ef          	jal	ra,2a6 <close>
  return r;
}
 174:	854a                	mv	a0,s2
 176:	60e2                	ld	ra,24(sp)
 178:	6442                	ld	s0,16(sp)
 17a:	64a2                	ld	s1,8(sp)
 17c:	6902                	ld	s2,0(sp)
 17e:	6105                	addi	sp,sp,32
 180:	8082                	ret
    return -1;
 182:	597d                	li	s2,-1
 184:	bfc5                	j	174 <stat+0x28>

0000000000000186 <atoi>:

int
atoi(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18c:	00054603          	lbu	a2,0(a0)
 190:	fd06079b          	addiw	a5,a2,-48
 194:	0ff7f793          	andi	a5,a5,255
 198:	4725                	li	a4,9
 19a:	02f76963          	bltu	a4,a5,1cc <atoi+0x46>
 19e:	86aa                	mv	a3,a0
  n = 0;
 1a0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1a2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1a4:	0685                	addi	a3,a3,1
 1a6:	0025179b          	slliw	a5,a0,0x2
 1aa:	9fa9                	addw	a5,a5,a0
 1ac:	0017979b          	slliw	a5,a5,0x1
 1b0:	9fb1                	addw	a5,a5,a2
 1b2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b6:	0006c603          	lbu	a2,0(a3)
 1ba:	fd06071b          	addiw	a4,a2,-48
 1be:	0ff77713          	andi	a4,a4,255
 1c2:	fee5f1e3          	bgeu	a1,a4,1a4 <atoi+0x1e>
  return n;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  n = 0;
 1cc:	4501                	li	a0,0
 1ce:	bfe5                	j	1c6 <atoi+0x40>

00000000000001d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d6:	02b57463          	bgeu	a0,a1,1fe <memmove+0x2e>
    while(n-- > 0)
 1da:	00c05f63          	blez	a2,1f8 <memmove+0x28>
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 1e8:	0585                	addi	a1,a1,1
 1ea:	0705                	addi	a4,a4,1
 1ec:	fff5c683          	lbu	a3,-1(a1)
 1f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1f4:	fee79ae3          	bne	a5,a4,1e8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
    dst += n;
 1fe:	00c50733          	add	a4,a0,a2
    src += n;
 202:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 204:	fec05ae3          	blez	a2,1f8 <memmove+0x28>
 208:	fff6079b          	addiw	a5,a2,-1
 20c:	1782                	slli	a5,a5,0x20
 20e:	9381                	srli	a5,a5,0x20
 210:	fff7c793          	not	a5,a5
 214:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 216:	15fd                	addi	a1,a1,-1
 218:	177d                	addi	a4,a4,-1
 21a:	0005c683          	lbu	a3,0(a1)
 21e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x46>
 226:	bfc9                	j	1f8 <memmove+0x28>

0000000000000228 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 22e:	ca05                	beqz	a2,25e <memcmp+0x36>
 230:	fff6069b          	addiw	a3,a2,-1
 234:	1682                	slli	a3,a3,0x20
 236:	9281                	srli	a3,a3,0x20
 238:	0685                	addi	a3,a3,1
 23a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 23c:	00054783          	lbu	a5,0(a0)
 240:	0005c703          	lbu	a4,0(a1)
 244:	00e79863          	bne	a5,a4,254 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 248:	0505                	addi	a0,a0,1
    p2++;
 24a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 24c:	fed518e3          	bne	a0,a3,23c <memcmp+0x14>
  }
  return 0;
 250:	4501                	li	a0,0
 252:	a019                	j	258 <memcmp+0x30>
      return *p1 - *p2;
 254:	40e7853b          	subw	a0,a5,a4
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <memcmp+0x30>

0000000000000262 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 26a:	f67ff0ef          	jal	ra,1d0 <memmove>
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret

0000000000000276 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 276:	4885                	li	a7,1
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <exit>:
.global exit
exit:
 li a7, SYS_exit
 27e:	4889                	li	a7,2
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <wait>:
.global wait
wait:
 li a7, SYS_wait
 286:	488d                	li	a7,3
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 28e:	4891                	li	a7,4
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <read>:
.global read
read:
 li a7, SYS_read
 296:	4895                	li	a7,5
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <write>:
.global write
write:
 li a7, SYS_write
 29e:	48c1                	li	a7,16
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <close>:
.global close
close:
 li a7, SYS_close
 2a6:	48d5                	li	a7,21
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ae:	4899                	li	a7,6
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2b6:	489d                	li	a7,7
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <open>:
.global open
open:
 li a7, SYS_open
 2be:	48bd                	li	a7,15
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2c6:	48c5                	li	a7,17
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ce:	48c9                	li	a7,18
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2d6:	48a1                	li	a7,8
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <link>:
.global link
link:
 li a7, SYS_link
 2de:	48cd                	li	a7,19
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2e6:	48d1                	li	a7,20
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2ee:	48a5                	li	a7,9
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2f6:	48a9                	li	a7,10
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2fe:	48ad                	li	a7,11
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 306:	48b1                	li	a7,12
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 30e:	48b5                	li	a7,13
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 316:	48b9                	li	a7,14
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 31e:	48d9                	li	a7,22
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 326:	48dd                	li	a7,23
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 32e:	48e1                	li	a7,24
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 336:	48e5                	li	a7,25
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33e:	1101                	addi	sp,sp,-32
 340:	ec06                	sd	ra,24(sp)
 342:	e822                	sd	s0,16(sp)
 344:	1000                	addi	s0,sp,32
 346:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 34a:	4605                	li	a2,1
 34c:	fef40593          	addi	a1,s0,-17
 350:	f4fff0ef          	jal	ra,29e <write>
}
 354:	60e2                	ld	ra,24(sp)
 356:	6442                	ld	s0,16(sp)
 358:	6105                	addi	sp,sp,32
 35a:	8082                	ret

000000000000035c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	7139                	addi	sp,sp,-64
 35e:	fc06                	sd	ra,56(sp)
 360:	f822                	sd	s0,48(sp)
 362:	f426                	sd	s1,40(sp)
 364:	f04a                	sd	s2,32(sp)
 366:	ec4e                	sd	s3,24(sp)
 368:	0080                	addi	s0,sp,64
 36a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36c:	c299                	beqz	a3,372 <printint+0x16>
 36e:	0805c663          	bltz	a1,3fa <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 372:	2581                	sext.w	a1,a1
  neg = 0;
 374:	4881                	li	a7,0
 376:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37c:	2601                	sext.w	a2,a2
 37e:	00000517          	auipc	a0,0x0
 382:	4ca50513          	addi	a0,a0,1226 # 848 <digits>
 386:	883a                	mv	a6,a4
 388:	2705                	addiw	a4,a4,1
 38a:	02c5f7bb          	remuw	a5,a1,a2
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	97aa                	add	a5,a5,a0
 394:	0007c783          	lbu	a5,0(a5)
 398:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39c:	0005879b          	sext.w	a5,a1
 3a0:	02c5d5bb          	divuw	a1,a1,a2
 3a4:	0685                	addi	a3,a3,1
 3a6:	fec7f0e3          	bgeu	a5,a2,386 <printint+0x2a>
  if(neg)
 3aa:	00088b63          	beqz	a7,3c0 <printint+0x64>
    buf[i++] = '-';
 3ae:	fd040793          	addi	a5,s0,-48
 3b2:	973e                	add	a4,a4,a5
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05663          	blez	a4,3ec <printint+0x90>
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	f5dff0ef          	jal	ra,33e <putc>
  while(--i >= 0)
 3e6:	197d                	addi	s2,s2,-1
 3e8:	ff391ae3          	bne	s2,s3,3dc <printint+0x80>
}
 3ec:	70e2                	ld	ra,56(sp)
 3ee:	7442                	ld	s0,48(sp)
 3f0:	74a2                	ld	s1,40(sp)
 3f2:	7902                	ld	s2,32(sp)
 3f4:	69e2                	ld	s3,24(sp)
 3f6:	6121                	addi	sp,sp,64
 3f8:	8082                	ret
    x = -xx;
 3fa:	40b005bb          	negw	a1,a1
    neg = 1;
 3fe:	4885                	li	a7,1
    x = -xx;
 400:	bf9d                	j	376 <printint+0x1a>

0000000000000402 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 402:	7119                	addi	sp,sp,-128
 404:	fc86                	sd	ra,120(sp)
 406:	f8a2                	sd	s0,112(sp)
 408:	f4a6                	sd	s1,104(sp)
 40a:	f0ca                	sd	s2,96(sp)
 40c:	ecce                	sd	s3,88(sp)
 40e:	e8d2                	sd	s4,80(sp)
 410:	e4d6                	sd	s5,72(sp)
 412:	e0da                	sd	s6,64(sp)
 414:	fc5e                	sd	s7,56(sp)
 416:	f862                	sd	s8,48(sp)
 418:	f466                	sd	s9,40(sp)
 41a:	f06a                	sd	s10,32(sp)
 41c:	ec6e                	sd	s11,24(sp)
 41e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 420:	0005c903          	lbu	s2,0(a1)
 424:	22090e63          	beqz	s2,660 <vprintf+0x25e>
 428:	8b2a                	mv	s6,a0
 42a:	8a2e                	mv	s4,a1
 42c:	8bb2                	mv	s7,a2
  state = 0;
 42e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 430:	4481                	li	s1,0
 432:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 434:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 438:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 43c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 440:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 444:	00000c97          	auipc	s9,0x0
 448:	404c8c93          	addi	s9,s9,1028 # 848 <digits>
 44c:	a005                	j	46c <vprintf+0x6a>
        putc(fd, c0);
 44e:	85ca                	mv	a1,s2
 450:	855a                	mv	a0,s6
 452:	eedff0ef          	jal	ra,33e <putc>
 456:	a019                	j	45c <vprintf+0x5a>
    } else if(state == '%'){
 458:	03598263          	beq	s3,s5,47c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 45c:	2485                	addiw	s1,s1,1
 45e:	8726                	mv	a4,s1
 460:	009a07b3          	add	a5,s4,s1
 464:	0007c903          	lbu	s2,0(a5)
 468:	1e090c63          	beqz	s2,660 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 46c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 470:	fe0994e3          	bnez	s3,458 <vprintf+0x56>
      if(c0 == '%'){
 474:	fd579de3          	bne	a5,s5,44e <vprintf+0x4c>
        state = '%';
 478:	89be                	mv	s3,a5
 47a:	b7cd                	j	45c <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 47c:	cfa5                	beqz	a5,4f4 <vprintf+0xf2>
 47e:	00ea06b3          	add	a3,s4,a4
 482:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 486:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 488:	c681                	beqz	a3,490 <vprintf+0x8e>
 48a:	9752                	add	a4,a4,s4
 48c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 490:	03878a63          	beq	a5,s8,4c4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 494:	05a78463          	beq	a5,s10,4dc <vprintf+0xda>
      } else if(c0 == 'u'){
 498:	0db78763          	beq	a5,s11,566 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 49c:	07800713          	li	a4,120
 4a0:	10e78963          	beq	a5,a4,5b2 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4a4:	07000713          	li	a4,112
 4a8:	12e78e63          	beq	a5,a4,5e4 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4ac:	07300713          	li	a4,115
 4b0:	16e78b63          	beq	a5,a4,626 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4b4:	05579063          	bne	a5,s5,4f4 <vprintf+0xf2>
        putc(fd, '%');
 4b8:	85d6                	mv	a1,s5
 4ba:	855a                	mv	a0,s6
 4bc:	e83ff0ef          	jal	ra,33e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	bf69                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4685                	li	a3,1
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	855a                	mv	a0,s6
 4d2:	e8bff0ef          	jal	ra,35c <printint>
 4d6:	8bca                	mv	s7,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b749                	j	45c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4dc:	03868663          	beq	a3,s8,508 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e0:	05a68163          	beq	a3,s10,522 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4e4:	09b68d63          	beq	a3,s11,57e <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4e8:	03a68f63          	beq	a3,s10,526 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4ec:	07800793          	li	a5,120
 4f0:	0cf68d63          	beq	a3,a5,5ca <vprintf+0x1c8>
        putc(fd, '%');
 4f4:	85d6                	mv	a1,s5
 4f6:	855a                	mv	a0,s6
 4f8:	e47ff0ef          	jal	ra,33e <putc>
        putc(fd, c0);
 4fc:	85ca                	mv	a1,s2
 4fe:	855a                	mv	a0,s6
 500:	e3fff0ef          	jal	ra,33e <putc>
      state = 0;
 504:	4981                	li	s3,0
 506:	bf99                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	008b8913          	addi	s2,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	e47ff0ef          	jal	ra,35c <printint>
        i += 1;
 51a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	8bca                	mv	s7,s2
      state = 0;
 51e:	4981                	li	s3,0
        i += 1;
 520:	bf35                	j	45c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 522:	03860563          	beq	a2,s8,54c <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 526:	07b60963          	beq	a2,s11,598 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 52a:	07800793          	li	a5,120
 52e:	fcf613e3          	bne	a2,a5,4f4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 532:	008b8913          	addi	s2,s7,8
 536:	4681                	li	a3,0
 538:	4641                	li	a2,16
 53a:	000ba583          	lw	a1,0(s7)
 53e:	855a                	mv	a0,s6
 540:	e1dff0ef          	jal	ra,35c <printint>
        i += 2;
 544:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
        i += 2;
 54a:	bf09                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	008b8913          	addi	s2,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	e03ff0ef          	jal	ra,35c <printint>
        i += 2;
 55e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
        i += 2;
 564:	bde5                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 566:	008b8913          	addi	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	de9ff0ef          	jal	ra,35c <printint>
 578:	8bca                	mv	s7,s2
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b5c5                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57e:	008b8913          	addi	s2,s7,8
 582:	4681                	li	a3,0
 584:	4629                	li	a2,10
 586:	000ba583          	lw	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	dd1ff0ef          	jal	ra,35c <printint>
        i += 1;
 590:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 1;
 596:	b5d9                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	db7ff0ef          	jal	ra,35c <printint>
        i += 2;
 5aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	b575                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4641                	li	a2,16
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	d9dff0ef          	jal	ra,35c <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bd51                	j	45c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4641                	li	a2,16
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	d85ff0ef          	jal	ra,35c <printint>
        i += 1;
 5dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 1;
 5e2:	bdad                	j	45c <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5e4:	008b8793          	addi	a5,s7,8
 5e8:	f8f43423          	sd	a5,-120(s0)
 5ec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f0:	03000593          	li	a1,48
 5f4:	855a                	mv	a0,s6
 5f6:	d49ff0ef          	jal	ra,33e <putc>
  putc(fd, 'x');
 5fa:	07800593          	li	a1,120
 5fe:	855a                	mv	a0,s6
 600:	d3fff0ef          	jal	ra,33e <putc>
 604:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 606:	03c9d793          	srli	a5,s3,0x3c
 60a:	97e6                	add	a5,a5,s9
 60c:	0007c583          	lbu	a1,0(a5)
 610:	855a                	mv	a0,s6
 612:	d2dff0ef          	jal	ra,33e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	397d                	addiw	s2,s2,-1
 61a:	fe0916e3          	bnez	s2,606 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 61e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 622:	4981                	li	s3,0
 624:	bd25                	j	45c <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 626:	008b8993          	addi	s3,s7,8
 62a:	000bb903          	ld	s2,0(s7)
 62e:	00090f63          	beqz	s2,64c <vprintf+0x24a>
        for(; *s; s++)
 632:	00094583          	lbu	a1,0(s2)
 636:	c195                	beqz	a1,65a <vprintf+0x258>
          putc(fd, *s);
 638:	855a                	mv	a0,s6
 63a:	d05ff0ef          	jal	ra,33e <putc>
        for(; *s; s++)
 63e:	0905                	addi	s2,s2,1
 640:	00094583          	lbu	a1,0(s2)
 644:	f9f5                	bnez	a1,638 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 646:	8bce                	mv	s7,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd09                	j	45c <vprintf+0x5a>
          s = "(null)";
 64c:	00000917          	auipc	s2,0x0
 650:	1f490913          	addi	s2,s2,500 # 840 <malloc+0xde>
        for(; *s; s++)
 654:	02800593          	li	a1,40
 658:	b7c5                	j	638 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 65a:	8bce                	mv	s7,s3
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bbfd                	j	45c <vprintf+0x5a>
    }
  }
}
 660:	70e6                	ld	ra,120(sp)
 662:	7446                	ld	s0,112(sp)
 664:	74a6                	ld	s1,104(sp)
 666:	7906                	ld	s2,96(sp)
 668:	69e6                	ld	s3,88(sp)
 66a:	6a46                	ld	s4,80(sp)
 66c:	6aa6                	ld	s5,72(sp)
 66e:	6b06                	ld	s6,64(sp)
 670:	7be2                	ld	s7,56(sp)
 672:	7c42                	ld	s8,48(sp)
 674:	7ca2                	ld	s9,40(sp)
 676:	7d02                	ld	s10,32(sp)
 678:	6de2                	ld	s11,24(sp)
 67a:	6109                	addi	sp,sp,128
 67c:	8082                	ret

000000000000067e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67e:	715d                	addi	sp,sp,-80
 680:	ec06                	sd	ra,24(sp)
 682:	e822                	sd	s0,16(sp)
 684:	1000                	addi	s0,sp,32
 686:	e010                	sd	a2,0(s0)
 688:	e414                	sd	a3,8(s0)
 68a:	e818                	sd	a4,16(s0)
 68c:	ec1c                	sd	a5,24(s0)
 68e:	03043023          	sd	a6,32(s0)
 692:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 696:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69a:	8622                	mv	a2,s0
 69c:	d67ff0ef          	jal	ra,402 <vprintf>
}
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	6161                	addi	sp,sp,80
 6a6:	8082                	ret

00000000000006a8 <printf>:

void
printf(const char *fmt, ...)
{
 6a8:	711d                	addi	sp,sp,-96
 6aa:	ec06                	sd	ra,24(sp)
 6ac:	e822                	sd	s0,16(sp)
 6ae:	1000                	addi	s0,sp,32
 6b0:	e40c                	sd	a1,8(s0)
 6b2:	e810                	sd	a2,16(s0)
 6b4:	ec14                	sd	a3,24(s0)
 6b6:	f018                	sd	a4,32(s0)
 6b8:	f41c                	sd	a5,40(s0)
 6ba:	03043823          	sd	a6,48(s0)
 6be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	00840613          	addi	a2,s0,8
 6c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ca:	85aa                	mv	a1,a0
 6cc:	4505                	li	a0,1
 6ce:	d35ff0ef          	jal	ra,402 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	addi	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00001797          	auipc	a5,0x1
 6e8:	91c7b783          	ld	a5,-1764(a5) # 1000 <freep>
 6ec:	a805                	j	71c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ee:	4618                	lw	a4,8(a2)
 6f0:	9db9                	addw	a1,a1,a4
 6f2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	6398                	ld	a4,0(a5)
 6f8:	6318                	ld	a4,0(a4)
 6fa:	fee53823          	sd	a4,-16(a0)
 6fe:	a091                	j	742 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 700:	ff852703          	lw	a4,-8(a0)
 704:	9e39                	addw	a2,a2,a4
 706:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 708:	ff053703          	ld	a4,-16(a0)
 70c:	e398                	sd	a4,0(a5)
 70e:	a099                	j	754 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	6398                	ld	a4,0(a5)
 712:	00e7e463          	bltu	a5,a4,71a <free+0x40>
 716:	00e6ea63          	bltu	a3,a4,72a <free+0x50>
{
 71a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	fed7fae3          	bgeu	a5,a3,710 <free+0x36>
 720:	6398                	ld	a4,0(a5)
 722:	00e6e463          	bltu	a3,a4,72a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 726:	fee7eae3          	bltu	a5,a4,71a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 72a:	ff852583          	lw	a1,-8(a0)
 72e:	6390                	ld	a2,0(a5)
 730:	02059713          	slli	a4,a1,0x20
 734:	9301                	srli	a4,a4,0x20
 736:	0712                	slli	a4,a4,0x4
 738:	9736                	add	a4,a4,a3
 73a:	fae60ae3          	beq	a2,a4,6ee <free+0x14>
    bp->s.ptr = p->s.ptr;
 73e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 742:	4790                	lw	a2,8(a5)
 744:	02061713          	slli	a4,a2,0x20
 748:	9301                	srli	a4,a4,0x20
 74a:	0712                	slli	a4,a4,0x4
 74c:	973e                	add	a4,a4,a5
 74e:	fae689e3          	beq	a3,a4,700 <free+0x26>
  } else
    p->s.ptr = bp;
 752:	e394                	sd	a3,0(a5)
  freep = p;
 754:	00001717          	auipc	a4,0x1
 758:	8af73623          	sd	a5,-1876(a4) # 1000 <freep>
}
 75c:	6422                	ld	s0,8(sp)
 75e:	0141                	addi	sp,sp,16
 760:	8082                	ret

0000000000000762 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 762:	7139                	addi	sp,sp,-64
 764:	fc06                	sd	ra,56(sp)
 766:	f822                	sd	s0,48(sp)
 768:	f426                	sd	s1,40(sp)
 76a:	f04a                	sd	s2,32(sp)
 76c:	ec4e                	sd	s3,24(sp)
 76e:	e852                	sd	s4,16(sp)
 770:	e456                	sd	s5,8(sp)
 772:	e05a                	sd	s6,0(sp)
 774:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 776:	02051493          	slli	s1,a0,0x20
 77a:	9081                	srli	s1,s1,0x20
 77c:	04bd                	addi	s1,s1,15
 77e:	8091                	srli	s1,s1,0x4
 780:	0014899b          	addiw	s3,s1,1
 784:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 786:	00001517          	auipc	a0,0x1
 78a:	87a53503          	ld	a0,-1926(a0) # 1000 <freep>
 78e:	c515                	beqz	a0,7ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 792:	4798                	lw	a4,8(a5)
 794:	02977f63          	bgeu	a4,s1,7d2 <malloc+0x70>
 798:	8a4e                	mv	s4,s3
 79a:	0009871b          	sext.w	a4,s3
 79e:	6685                	lui	a3,0x1
 7a0:	00d77363          	bgeu	a4,a3,7a6 <malloc+0x44>
 7a4:	6a05                	lui	s4,0x1
 7a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ae:	00001917          	auipc	s2,0x1
 7b2:	85290913          	addi	s2,s2,-1966 # 1000 <freep>
  if(p == (char*)-1)
 7b6:	5afd                	li	s5,-1
 7b8:	a0bd                	j	826 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7ba:	00001797          	auipc	a5,0x1
 7be:	85678793          	addi	a5,a5,-1962 # 1010 <base>
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
 7ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d0:	b7e1                	j	798 <malloc+0x36>
      if(p->s.size == nunits)
 7d2:	02e48b63          	beq	s1,a4,808 <malloc+0xa6>
        p->s.size -= nunits;
 7d6:	4137073b          	subw	a4,a4,s3
 7da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7dc:	1702                	slli	a4,a4,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80a73c23          	sd	a0,-2024(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f4:	70e2                	ld	ra,56(sp)
 7f6:	7442                	ld	s0,48(sp)
 7f8:	74a2                	ld	s1,40(sp)
 7fa:	7902                	ld	s2,32(sp)
 7fc:	69e2                	ld	s3,24(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
 804:	6121                	addi	sp,sp,64
 806:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	e118                	sd	a4,0(a0)
 80c:	bff1                	j	7e8 <malloc+0x86>
  hp->s.size = nu;
 80e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 812:	0541                	addi	a0,a0,16
 814:	ec7ff0ef          	jal	ra,6da <free>
  return freep;
 818:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81c:	dd61                	beqz	a0,7f4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	fa9778e3          	bgeu	a4,s1,7d2 <malloc+0x70>
    if(p == freep)
 826:	00093703          	ld	a4,0(s2)
 82a:	853e                	mv	a0,a5
 82c:	fef719e3          	bne	a4,a5,81e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 830:	8552                	mv	a0,s4
 832:	ad5ff0ef          	jal	ra,306 <sbrk>
  if(p == (char*)-1)
 836:	fd551ce3          	bne	a0,s5,80e <malloc+0xac>
        return 0;
 83a:	4501                	li	a0,0
 83c:	bf65                	j	7f4 <malloc+0x92>
