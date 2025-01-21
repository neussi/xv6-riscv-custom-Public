
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

0000000000000326 <getprocstat>:
.global getprocstat
getprocstat:
 li a7, SYS_getprocstat
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

0000000000000336 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 336:	1101                	addi	sp,sp,-32
 338:	ec06                	sd	ra,24(sp)
 33a:	e822                	sd	s0,16(sp)
 33c:	1000                	addi	s0,sp,32
 33e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 342:	4605                	li	a2,1
 344:	fef40593          	addi	a1,s0,-17
 348:	f57ff0ef          	jal	ra,29e <write>
}
 34c:	60e2                	ld	ra,24(sp)
 34e:	6442                	ld	s0,16(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret

0000000000000354 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	7139                	addi	sp,sp,-64
 356:	fc06                	sd	ra,56(sp)
 358:	f822                	sd	s0,48(sp)
 35a:	f426                	sd	s1,40(sp)
 35c:	f04a                	sd	s2,32(sp)
 35e:	ec4e                	sd	s3,24(sp)
 360:	0080                	addi	s0,sp,64
 362:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 364:	c299                	beqz	a3,36a <printint+0x16>
 366:	0805c663          	bltz	a1,3f2 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36a:	2581                	sext.w	a1,a1
  neg = 0;
 36c:	4881                	li	a7,0
 36e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 372:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 374:	2601                	sext.w	a2,a2
 376:	00000517          	auipc	a0,0x0
 37a:	4d250513          	addi	a0,a0,1234 # 848 <digits>
 37e:	883a                	mv	a6,a4
 380:	2705                	addiw	a4,a4,1
 382:	02c5f7bb          	remuw	a5,a1,a2
 386:	1782                	slli	a5,a5,0x20
 388:	9381                	srli	a5,a5,0x20
 38a:	97aa                	add	a5,a5,a0
 38c:	0007c783          	lbu	a5,0(a5)
 390:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 394:	0005879b          	sext.w	a5,a1
 398:	02c5d5bb          	divuw	a1,a1,a2
 39c:	0685                	addi	a3,a3,1
 39e:	fec7f0e3          	bgeu	a5,a2,37e <printint+0x2a>
  if(neg)
 3a2:	00088b63          	beqz	a7,3b8 <printint+0x64>
    buf[i++] = '-';
 3a6:	fd040793          	addi	a5,s0,-48
 3aa:	973e                	add	a4,a4,a5
 3ac:	02d00793          	li	a5,45
 3b0:	fef70823          	sb	a5,-16(a4)
 3b4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3b8:	02e05663          	blez	a4,3e4 <printint+0x90>
 3bc:	fc040793          	addi	a5,s0,-64
 3c0:	00e78933          	add	s2,a5,a4
 3c4:	fff78993          	addi	s3,a5,-1
 3c8:	99ba                	add	s3,s3,a4
 3ca:	377d                	addiw	a4,a4,-1
 3cc:	1702                	slli	a4,a4,0x20
 3ce:	9301                	srli	a4,a4,0x20
 3d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3d4:	fff94583          	lbu	a1,-1(s2)
 3d8:	8526                	mv	a0,s1
 3da:	f5dff0ef          	jal	ra,336 <putc>
  while(--i >= 0)
 3de:	197d                	addi	s2,s2,-1
 3e0:	ff391ae3          	bne	s2,s3,3d4 <printint+0x80>
}
 3e4:	70e2                	ld	ra,56(sp)
 3e6:	7442                	ld	s0,48(sp)
 3e8:	74a2                	ld	s1,40(sp)
 3ea:	7902                	ld	s2,32(sp)
 3ec:	69e2                	ld	s3,24(sp)
 3ee:	6121                	addi	sp,sp,64
 3f0:	8082                	ret
    x = -xx;
 3f2:	40b005bb          	negw	a1,a1
    neg = 1;
 3f6:	4885                	li	a7,1
    x = -xx;
 3f8:	bf9d                	j	36e <printint+0x1a>

00000000000003fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3fa:	7119                	addi	sp,sp,-128
 3fc:	fc86                	sd	ra,120(sp)
 3fe:	f8a2                	sd	s0,112(sp)
 400:	f4a6                	sd	s1,104(sp)
 402:	f0ca                	sd	s2,96(sp)
 404:	ecce                	sd	s3,88(sp)
 406:	e8d2                	sd	s4,80(sp)
 408:	e4d6                	sd	s5,72(sp)
 40a:	e0da                	sd	s6,64(sp)
 40c:	fc5e                	sd	s7,56(sp)
 40e:	f862                	sd	s8,48(sp)
 410:	f466                	sd	s9,40(sp)
 412:	f06a                	sd	s10,32(sp)
 414:	ec6e                	sd	s11,24(sp)
 416:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 418:	0005c903          	lbu	s2,0(a1)
 41c:	22090e63          	beqz	s2,658 <vprintf+0x25e>
 420:	8b2a                	mv	s6,a0
 422:	8a2e                	mv	s4,a1
 424:	8bb2                	mv	s7,a2
  state = 0;
 426:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 428:	4481                	li	s1,0
 42a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 42c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 430:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 434:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 438:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 43c:	00000c97          	auipc	s9,0x0
 440:	40cc8c93          	addi	s9,s9,1036 # 848 <digits>
 444:	a005                	j	464 <vprintf+0x6a>
        putc(fd, c0);
 446:	85ca                	mv	a1,s2
 448:	855a                	mv	a0,s6
 44a:	eedff0ef          	jal	ra,336 <putc>
 44e:	a019                	j	454 <vprintf+0x5a>
    } else if(state == '%'){
 450:	03598263          	beq	s3,s5,474 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 454:	2485                	addiw	s1,s1,1
 456:	8726                	mv	a4,s1
 458:	009a07b3          	add	a5,s4,s1
 45c:	0007c903          	lbu	s2,0(a5)
 460:	1e090c63          	beqz	s2,658 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 464:	0009079b          	sext.w	a5,s2
    if(state == 0){
 468:	fe0994e3          	bnez	s3,450 <vprintf+0x56>
      if(c0 == '%'){
 46c:	fd579de3          	bne	a5,s5,446 <vprintf+0x4c>
        state = '%';
 470:	89be                	mv	s3,a5
 472:	b7cd                	j	454 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 474:	cfa5                	beqz	a5,4ec <vprintf+0xf2>
 476:	00ea06b3          	add	a3,s4,a4
 47a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 47e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 480:	c681                	beqz	a3,488 <vprintf+0x8e>
 482:	9752                	add	a4,a4,s4
 484:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 488:	03878a63          	beq	a5,s8,4bc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 48c:	05a78463          	beq	a5,s10,4d4 <vprintf+0xda>
      } else if(c0 == 'u'){
 490:	0db78763          	beq	a5,s11,55e <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 494:	07800713          	li	a4,120
 498:	10e78963          	beq	a5,a4,5aa <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 49c:	07000713          	li	a4,112
 4a0:	12e78e63          	beq	a5,a4,5dc <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4a4:	07300713          	li	a4,115
 4a8:	16e78b63          	beq	a5,a4,61e <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ac:	05579063          	bne	a5,s5,4ec <vprintf+0xf2>
        putc(fd, '%');
 4b0:	85d6                	mv	a1,s5
 4b2:	855a                	mv	a0,s6
 4b4:	e83ff0ef          	jal	ra,336 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b8:	4981                	li	s3,0
 4ba:	bf69                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4bc:	008b8913          	addi	s2,s7,8
 4c0:	4685                	li	a3,1
 4c2:	4629                	li	a2,10
 4c4:	000ba583          	lw	a1,0(s7)
 4c8:	855a                	mv	a0,s6
 4ca:	e8bff0ef          	jal	ra,354 <printint>
 4ce:	8bca                	mv	s7,s2
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	b749                	j	454 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d4:	03868663          	beq	a3,s8,500 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4d8:	05a68163          	beq	a3,s10,51a <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4dc:	09b68d63          	beq	a3,s11,576 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4e0:	03a68f63          	beq	a3,s10,51e <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4e4:	07800793          	li	a5,120
 4e8:	0cf68d63          	beq	a3,a5,5c2 <vprintf+0x1c8>
        putc(fd, '%');
 4ec:	85d6                	mv	a1,s5
 4ee:	855a                	mv	a0,s6
 4f0:	e47ff0ef          	jal	ra,336 <putc>
        putc(fd, c0);
 4f4:	85ca                	mv	a1,s2
 4f6:	855a                	mv	a0,s6
 4f8:	e3fff0ef          	jal	ra,336 <putc>
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	bf99                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 500:	008b8913          	addi	s2,s7,8
 504:	4685                	li	a3,1
 506:	4629                	li	a2,10
 508:	000ba583          	lw	a1,0(s7)
 50c:	855a                	mv	a0,s6
 50e:	e47ff0ef          	jal	ra,354 <printint>
        i += 1;
 512:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	8bca                	mv	s7,s2
      state = 0;
 516:	4981                	li	s3,0
        i += 1;
 518:	bf35                	j	454 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51a:	03860563          	beq	a2,s8,544 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 51e:	07b60963          	beq	a2,s11,590 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 522:	07800793          	li	a5,120
 526:	fcf613e3          	bne	a2,a5,4ec <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4681                	li	a3,0
 530:	4641                	li	a2,16
 532:	000ba583          	lw	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e1dff0ef          	jal	ra,354 <printint>
        i += 2;
 53c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
        i += 2;
 542:	bf09                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e03ff0ef          	jal	ra,354 <printint>
        i += 2;
 556:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	bde5                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 55e:	008b8913          	addi	s2,s7,8
 562:	4681                	li	a3,0
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	de9ff0ef          	jal	ra,354 <printint>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	b5c5                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8913          	addi	s2,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	dd1ff0ef          	jal	ra,354 <printint>
        i += 1;
 588:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
        i += 1;
 58e:	b5d9                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	db7ff0ef          	jal	ra,354 <printint>
        i += 2;
 5a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	b575                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	d9dff0ef          	jal	ra,354 <printint>
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bd51                	j	454 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	d85ff0ef          	jal	ra,354 <printint>
        i += 1;
 5d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 1;
 5da:	bdad                	j	454 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5dc:	008b8793          	addi	a5,s7,8
 5e0:	f8f43423          	sd	a5,-120(s0)
 5e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e8:	03000593          	li	a1,48
 5ec:	855a                	mv	a0,s6
 5ee:	d49ff0ef          	jal	ra,336 <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	855a                	mv	a0,s6
 5f8:	d3fff0ef          	jal	ra,336 <putc>
 5fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fe:	03c9d793          	srli	a5,s3,0x3c
 602:	97e6                	add	a5,a5,s9
 604:	0007c583          	lbu	a1,0(a5)
 608:	855a                	mv	a0,s6
 60a:	d2dff0ef          	jal	ra,336 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60e:	0992                	slli	s3,s3,0x4
 610:	397d                	addiw	s2,s2,-1
 612:	fe0916e3          	bnez	s2,5fe <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 616:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd25                	j	454 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 61e:	008b8993          	addi	s3,s7,8
 622:	000bb903          	ld	s2,0(s7)
 626:	00090f63          	beqz	s2,644 <vprintf+0x24a>
        for(; *s; s++)
 62a:	00094583          	lbu	a1,0(s2)
 62e:	c195                	beqz	a1,652 <vprintf+0x258>
          putc(fd, *s);
 630:	855a                	mv	a0,s6
 632:	d05ff0ef          	jal	ra,336 <putc>
        for(; *s; s++)
 636:	0905                	addi	s2,s2,1
 638:	00094583          	lbu	a1,0(s2)
 63c:	f9f5                	bnez	a1,630 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 63e:	8bce                	mv	s7,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	bd09                	j	454 <vprintf+0x5a>
          s = "(null)";
 644:	00000917          	auipc	s2,0x0
 648:	1fc90913          	addi	s2,s2,508 # 840 <malloc+0xe6>
        for(; *s; s++)
 64c:	02800593          	li	a1,40
 650:	b7c5                	j	630 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	bbfd                	j	454 <vprintf+0x5a>
    }
  }
}
 658:	70e6                	ld	ra,120(sp)
 65a:	7446                	ld	s0,112(sp)
 65c:	74a6                	ld	s1,104(sp)
 65e:	7906                	ld	s2,96(sp)
 660:	69e6                	ld	s3,88(sp)
 662:	6a46                	ld	s4,80(sp)
 664:	6aa6                	ld	s5,72(sp)
 666:	6b06                	ld	s6,64(sp)
 668:	7be2                	ld	s7,56(sp)
 66a:	7c42                	ld	s8,48(sp)
 66c:	7ca2                	ld	s9,40(sp)
 66e:	7d02                	ld	s10,32(sp)
 670:	6de2                	ld	s11,24(sp)
 672:	6109                	addi	sp,sp,128
 674:	8082                	ret

0000000000000676 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 676:	715d                	addi	sp,sp,-80
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	addi	s0,sp,32
 67e:	e010                	sd	a2,0(s0)
 680:	e414                	sd	a3,8(s0)
 682:	e818                	sd	a4,16(s0)
 684:	ec1c                	sd	a5,24(s0)
 686:	03043023          	sd	a6,32(s0)
 68a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 692:	8622                	mv	a2,s0
 694:	d67ff0ef          	jal	ra,3fa <vprintf>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret

00000000000006a0 <printf>:

void
printf(const char *fmt, ...)
{
 6a0:	711d                	addi	sp,sp,-96
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e40c                	sd	a1,8(s0)
 6aa:	e810                	sd	a2,16(s0)
 6ac:	ec14                	sd	a3,24(s0)
 6ae:	f018                	sd	a4,32(s0)
 6b0:	f41c                	sd	a5,40(s0)
 6b2:	03043823          	sd	a6,48(s0)
 6b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ba:	00840613          	addi	a2,s0,8
 6be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c2:	85aa                	mv	a1,a0
 6c4:	4505                	li	a0,1
 6c6:	d35ff0ef          	jal	ra,3fa <vprintf>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret

00000000000006d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e422                	sd	s0,8(sp)
 6d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	00001797          	auipc	a5,0x1
 6e0:	9247b783          	ld	a5,-1756(a5) # 1000 <freep>
 6e4:	a805                	j	714 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e6:	4618                	lw	a4,8(a2)
 6e8:	9db9                	addw	a1,a1,a4
 6ea:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ee:	6398                	ld	a4,0(a5)
 6f0:	6318                	ld	a4,0(a4)
 6f2:	fee53823          	sd	a4,-16(a0)
 6f6:	a091                	j	73a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9e39                	addw	a2,a2,a4
 6fe:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053703          	ld	a4,-16(a0)
 704:	e398                	sd	a4,0(a5)
 706:	a099                	j	74c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	6398                	ld	a4,0(a5)
 70a:	00e7e463          	bltu	a5,a4,712 <free+0x40>
 70e:	00e6ea63          	bltu	a3,a4,722 <free+0x50>
{
 712:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	fed7fae3          	bgeu	a5,a3,708 <free+0x36>
 718:	6398                	ld	a4,0(a5)
 71a:	00e6e463          	bltu	a3,a4,722 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	fee7eae3          	bltu	a5,a4,712 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 722:	ff852583          	lw	a1,-8(a0)
 726:	6390                	ld	a2,0(a5)
 728:	02059713          	slli	a4,a1,0x20
 72c:	9301                	srli	a4,a4,0x20
 72e:	0712                	slli	a4,a4,0x4
 730:	9736                	add	a4,a4,a3
 732:	fae60ae3          	beq	a2,a4,6e6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 736:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73a:	4790                	lw	a2,8(a5)
 73c:	02061713          	slli	a4,a2,0x20
 740:	9301                	srli	a4,a4,0x20
 742:	0712                	slli	a4,a4,0x4
 744:	973e                	add	a4,a4,a5
 746:	fae689e3          	beq	a3,a4,6f8 <free+0x26>
  } else
    p->s.ptr = bp;
 74a:	e394                	sd	a3,0(a5)
  freep = p;
 74c:	00001717          	auipc	a4,0x1
 750:	8af73a23          	sd	a5,-1868(a4) # 1000 <freep>
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	addi	sp,sp,16
 758:	8082                	ret

000000000000075a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75a:	7139                	addi	sp,sp,-64
 75c:	fc06                	sd	ra,56(sp)
 75e:	f822                	sd	s0,48(sp)
 760:	f426                	sd	s1,40(sp)
 762:	f04a                	sd	s2,32(sp)
 764:	ec4e                	sd	s3,24(sp)
 766:	e852                	sd	s4,16(sp)
 768:	e456                	sd	s5,8(sp)
 76a:	e05a                	sd	s6,0(sp)
 76c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76e:	02051493          	slli	s1,a0,0x20
 772:	9081                	srli	s1,s1,0x20
 774:	04bd                	addi	s1,s1,15
 776:	8091                	srli	s1,s1,0x4
 778:	0014899b          	addiw	s3,s1,1
 77c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 77e:	00001517          	auipc	a0,0x1
 782:	88253503          	ld	a0,-1918(a0) # 1000 <freep>
 786:	c515                	beqz	a0,7b2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78a:	4798                	lw	a4,8(a5)
 78c:	02977f63          	bgeu	a4,s1,7ca <malloc+0x70>
 790:	8a4e                	mv	s4,s3
 792:	0009871b          	sext.w	a4,s3
 796:	6685                	lui	a3,0x1
 798:	00d77363          	bgeu	a4,a3,79e <malloc+0x44>
 79c:	6a05                	lui	s4,0x1
 79e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a6:	00001917          	auipc	s2,0x1
 7aa:	85a90913          	addi	s2,s2,-1958 # 1000 <freep>
  if(p == (char*)-1)
 7ae:	5afd                	li	s5,-1
 7b0:	a0bd                	j	81e <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7b2:	00001797          	auipc	a5,0x1
 7b6:	85e78793          	addi	a5,a5,-1954 # 1010 <base>
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
 7c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c8:	b7e1                	j	790 <malloc+0x36>
      if(p->s.size == nunits)
 7ca:	02e48b63          	beq	s1,a4,800 <malloc+0xa6>
        p->s.size -= nunits;
 7ce:	4137073b          	subw	a4,a4,s3
 7d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d4:	1702                	slli	a4,a4,0x20
 7d6:	9301                	srli	a4,a4,0x20
 7d8:	0712                	slli	a4,a4,0x4
 7da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82a73023          	sd	a0,-2016(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ec:	70e2                	ld	ra,56(sp)
 7ee:	7442                	ld	s0,48(sp)
 7f0:	74a2                	ld	s1,40(sp)
 7f2:	7902                	ld	s2,32(sp)
 7f4:	69e2                	ld	s3,24(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	6121                	addi	sp,sp,64
 7fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	bff1                	j	7e0 <malloc+0x86>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	ec7ff0ef          	jal	ra,6d2 <free>
  return freep;
 810:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 814:	dd61                	beqz	a0,7ec <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	fa9778e3          	bgeu	a4,s1,7ca <malloc+0x70>
    if(p == freep)
 81e:	00093703          	ld	a4,0(s2)
 822:	853e                	mv	a0,a5
 824:	fef719e3          	bne	a4,a5,816 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	addff0ef          	jal	ra,306 <sbrk>
  if(p == (char*)-1)
 82e:	fd551ce3          	bne	a0,s5,806 <malloc+0xac>
        return 0;
 832:	4501                	li	a0,0
 834:	bf65                	j	7ec <malloc+0x92>
