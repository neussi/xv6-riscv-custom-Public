
user/_clear:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(void) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // Envoie le caractère spécial pour effacer l'écran
  write(1, "\033[2J\033[H", 7);  // Séquence ANSI pour effacer l'écran
   8:	461d                	li	a2,7
   a:	00001597          	auipc	a1,0x1
   e:	84658593          	addi	a1,a1,-1978 # 850 <malloc+0xe2>
  12:	4505                	li	a0,1
  14:	296000ef          	jal	ra,2aa <write>
  exit(0);
  18:	4501                	li	a0,0
  1a:	270000ef          	jal	ra,28a <exit>

000000000000001e <start>:
//


void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	ra,0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25e000ef          	jal	ra,28a <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	4685                	li	a3,1
  8a:	9e89                	subw	a3,a3,a0
  8c:	00f6853b          	addw	a0,a3,a5
  90:	0785                	addi	a5,a5,1
  92:	fff7c703          	lbu	a4,-1(a5)
  96:	fb7d                	bnez	a4,8c <strlen+0x14>
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	188000ef          	jal	ra,2a2 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	162000ef          	jal	ra,2ca <open>
  if(fd < 0)
 16c:	02054163          	bltz	a0,18e <stat+0x36>
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16e000ef          	jal	ra,2e2 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	136000ef          	jal	ra,2b2 <close>
  return r;
}
 180:	854a                	mv	a0,s2
 182:	60e2                	ld	ra,24(sp)
 184:	6442                	ld	s0,16(sp)
 186:	64a2                	ld	s1,8(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfc5                	j	180 <stat+0x28>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054603          	lbu	a2,0(a0)
 19c:	fd06079b          	addiw	a5,a2,-48
 1a0:	0ff7f793          	andi	a5,a5,255
 1a4:	4725                	li	a4,9
 1a6:	02f76963          	bltu	a4,a5,1d8 <atoi+0x46>
 1aa:	86aa                	mv	a3,a0
  n = 0;
 1ac:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ae:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1b0:	0685                	addi	a3,a3,1
 1b2:	0025179b          	slliw	a5,a0,0x2
 1b6:	9fa9                	addw	a5,a5,a0
 1b8:	0017979b          	slliw	a5,a5,0x1
 1bc:	9fb1                	addw	a5,a5,a2
 1be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c2:	0006c603          	lbu	a2,0(a3)
 1c6:	fd06071b          	addiw	a4,a2,-48
 1ca:	0ff77713          	andi	a4,a4,255
 1ce:	fee5f1e3          	bgeu	a1,a4,1b0 <atoi+0x1e>
  return n;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  n = 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <atoi+0x40>

00000000000001dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e2:	02b57463          	bgeu	a0,a1,20a <memmove+0x2e>
    while(n-- > 0)
 1e6:	00c05f63          	blez	a2,204 <memmove+0x28>
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f4:	0585                	addi	a1,a1,1
 1f6:	0705                	addi	a4,a4,1
 1f8:	fff5c683          	lbu	a3,-1(a1)
 1fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 200:	fee79ae3          	bne	a5,a4,1f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
    dst += n;
 20a:	00c50733          	add	a4,a0,a2
    src += n;
 20e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 210:	fec05ae3          	blez	a2,204 <memmove+0x28>
 214:	fff6079b          	addiw	a5,a2,-1
 218:	1782                	slli	a5,a5,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	fff7c793          	not	a5,a5
 220:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 222:	15fd                	addi	a1,a1,-1
 224:	177d                	addi	a4,a4,-1
 226:	0005c683          	lbu	a3,0(a1)
 22a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x46>
 232:	bfc9                	j	204 <memmove+0x28>

0000000000000234 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 23a:	ca05                	beqz	a2,26a <memcmp+0x36>
 23c:	fff6069b          	addiw	a3,a2,-1
 240:	1682                	slli	a3,a3,0x20
 242:	9281                	srli	a3,a3,0x20
 244:	0685                	addi	a3,a3,1
 246:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 248:	00054783          	lbu	a5,0(a0)
 24c:	0005c703          	lbu	a4,0(a1)
 250:	00e79863          	bne	a5,a4,260 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 254:	0505                	addi	a0,a0,1
    p2++;
 256:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 258:	fed518e3          	bne	a0,a3,248 <memcmp+0x14>
  }
  return 0;
 25c:	4501                	li	a0,0
 25e:	a019                	j	264 <memcmp+0x30>
      return *p1 - *p2;
 260:	40e7853b          	subw	a0,a5,a4
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  return 0;
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <memcmp+0x30>

000000000000026e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 276:	f67ff0ef          	jal	ra,1dc <memmove>
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 282:	4885                	li	a7,1
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <exit>:
.global exit
exit:
 li a7, SYS_exit
 28a:	4889                	li	a7,2
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <wait>:
.global wait
wait:
 li a7, SYS_wait
 292:	488d                	li	a7,3
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29a:	4891                	li	a7,4
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <read>:
.global read
read:
 li a7, SYS_read
 2a2:	4895                	li	a7,5
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <write>:
.global write
write:
 li a7, SYS_write
 2aa:	48c1                	li	a7,16
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <close>:
.global close
close:
 li a7, SYS_close
 2b2:	48d5                	li	a7,21
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ba:	4899                	li	a7,6
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c2:	489d                	li	a7,7
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <open>:
.global open
open:
 li a7, SYS_open
 2ca:	48bd                	li	a7,15
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d2:	48c5                	li	a7,17
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2da:	48c9                	li	a7,18
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e2:	48a1                	li	a7,8
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <link>:
.global link
link:
 li a7, SYS_link
 2ea:	48cd                	li	a7,19
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f2:	48d1                	li	a7,20
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fa:	48a5                	li	a7,9
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <dup>:
.global dup
dup:
 li a7, SYS_dup
 302:	48a9                	li	a7,10
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30a:	48ad                	li	a7,11
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 312:	48b1                	li	a7,12
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31a:	48b5                	li	a7,13
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 322:	48b9                	li	a7,14
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 32a:	48d9                	li	a7,22
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 332:	48dd                	li	a7,23
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 33a:	48e1                	li	a7,24
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 342:	48e5                	li	a7,25
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 34a:	1101                	addi	sp,sp,-32
 34c:	ec06                	sd	ra,24(sp)
 34e:	e822                	sd	s0,16(sp)
 350:	1000                	addi	s0,sp,32
 352:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 356:	4605                	li	a2,1
 358:	fef40593          	addi	a1,s0,-17
 35c:	f4fff0ef          	jal	ra,2aa <write>
}
 360:	60e2                	ld	ra,24(sp)
 362:	6442                	ld	s0,16(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret

0000000000000368 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	7139                	addi	sp,sp,-64
 36a:	fc06                	sd	ra,56(sp)
 36c:	f822                	sd	s0,48(sp)
 36e:	f426                	sd	s1,40(sp)
 370:	f04a                	sd	s2,32(sp)
 372:	ec4e                	sd	s3,24(sp)
 374:	0080                	addi	s0,sp,64
 376:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 378:	c299                	beqz	a3,37e <printint+0x16>
 37a:	0805c663          	bltz	a1,406 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37e:	2581                	sext.w	a1,a1
  neg = 0;
 380:	4881                	li	a7,0
 382:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 386:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 388:	2601                	sext.w	a2,a2
 38a:	00000517          	auipc	a0,0x0
 38e:	4d650513          	addi	a0,a0,1238 # 860 <digits>
 392:	883a                	mv	a6,a4
 394:	2705                	addiw	a4,a4,1
 396:	02c5f7bb          	remuw	a5,a1,a2
 39a:	1782                	slli	a5,a5,0x20
 39c:	9381                	srli	a5,a5,0x20
 39e:	97aa                	add	a5,a5,a0
 3a0:	0007c783          	lbu	a5,0(a5)
 3a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a8:	0005879b          	sext.w	a5,a1
 3ac:	02c5d5bb          	divuw	a1,a1,a2
 3b0:	0685                	addi	a3,a3,1
 3b2:	fec7f0e3          	bgeu	a5,a2,392 <printint+0x2a>
  if(neg)
 3b6:	00088b63          	beqz	a7,3cc <printint+0x64>
    buf[i++] = '-';
 3ba:	fd040793          	addi	a5,s0,-48
 3be:	973e                	add	a4,a4,a5
 3c0:	02d00793          	li	a5,45
 3c4:	fef70823          	sb	a5,-16(a4)
 3c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3cc:	02e05663          	blez	a4,3f8 <printint+0x90>
 3d0:	fc040793          	addi	a5,s0,-64
 3d4:	00e78933          	add	s2,a5,a4
 3d8:	fff78993          	addi	s3,a5,-1
 3dc:	99ba                	add	s3,s3,a4
 3de:	377d                	addiw	a4,a4,-1
 3e0:	1702                	slli	a4,a4,0x20
 3e2:	9301                	srli	a4,a4,0x20
 3e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e8:	fff94583          	lbu	a1,-1(s2)
 3ec:	8526                	mv	a0,s1
 3ee:	f5dff0ef          	jal	ra,34a <putc>
  while(--i >= 0)
 3f2:	197d                	addi	s2,s2,-1
 3f4:	ff391ae3          	bne	s2,s3,3e8 <printint+0x80>
}
 3f8:	70e2                	ld	ra,56(sp)
 3fa:	7442                	ld	s0,48(sp)
 3fc:	74a2                	ld	s1,40(sp)
 3fe:	7902                	ld	s2,32(sp)
 400:	69e2                	ld	s3,24(sp)
 402:	6121                	addi	sp,sp,64
 404:	8082                	ret
    x = -xx;
 406:	40b005bb          	negw	a1,a1
    neg = 1;
 40a:	4885                	li	a7,1
    x = -xx;
 40c:	bf9d                	j	382 <printint+0x1a>

000000000000040e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40e:	7119                	addi	sp,sp,-128
 410:	fc86                	sd	ra,120(sp)
 412:	f8a2                	sd	s0,112(sp)
 414:	f4a6                	sd	s1,104(sp)
 416:	f0ca                	sd	s2,96(sp)
 418:	ecce                	sd	s3,88(sp)
 41a:	e8d2                	sd	s4,80(sp)
 41c:	e4d6                	sd	s5,72(sp)
 41e:	e0da                	sd	s6,64(sp)
 420:	fc5e                	sd	s7,56(sp)
 422:	f862                	sd	s8,48(sp)
 424:	f466                	sd	s9,40(sp)
 426:	f06a                	sd	s10,32(sp)
 428:	ec6e                	sd	s11,24(sp)
 42a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42c:	0005c903          	lbu	s2,0(a1)
 430:	22090e63          	beqz	s2,66c <vprintf+0x25e>
 434:	8b2a                	mv	s6,a0
 436:	8a2e                	mv	s4,a1
 438:	8bb2                	mv	s7,a2
  state = 0;
 43a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 43c:	4481                	li	s1,0
 43e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 440:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 444:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 448:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 44c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 450:	00000c97          	auipc	s9,0x0
 454:	410c8c93          	addi	s9,s9,1040 # 860 <digits>
 458:	a005                	j	478 <vprintf+0x6a>
        putc(fd, c0);
 45a:	85ca                	mv	a1,s2
 45c:	855a                	mv	a0,s6
 45e:	eedff0ef          	jal	ra,34a <putc>
 462:	a019                	j	468 <vprintf+0x5a>
    } else if(state == '%'){
 464:	03598263          	beq	s3,s5,488 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 468:	2485                	addiw	s1,s1,1
 46a:	8726                	mv	a4,s1
 46c:	009a07b3          	add	a5,s4,s1
 470:	0007c903          	lbu	s2,0(a5)
 474:	1e090c63          	beqz	s2,66c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 478:	0009079b          	sext.w	a5,s2
    if(state == 0){
 47c:	fe0994e3          	bnez	s3,464 <vprintf+0x56>
      if(c0 == '%'){
 480:	fd579de3          	bne	a5,s5,45a <vprintf+0x4c>
        state = '%';
 484:	89be                	mv	s3,a5
 486:	b7cd                	j	468 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 488:	cfa5                	beqz	a5,500 <vprintf+0xf2>
 48a:	00ea06b3          	add	a3,s4,a4
 48e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 492:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 494:	c681                	beqz	a3,49c <vprintf+0x8e>
 496:	9752                	add	a4,a4,s4
 498:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49c:	03878a63          	beq	a5,s8,4d0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4a0:	05a78463          	beq	a5,s10,4e8 <vprintf+0xda>
      } else if(c0 == 'u'){
 4a4:	0db78763          	beq	a5,s11,572 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a8:	07800713          	li	a4,120
 4ac:	10e78963          	beq	a5,a4,5be <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4b0:	07000713          	li	a4,112
 4b4:	12e78e63          	beq	a5,a4,5f0 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b8:	07300713          	li	a4,115
 4bc:	16e78b63          	beq	a5,a4,632 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c0:	05579063          	bne	a5,s5,500 <vprintf+0xf2>
        putc(fd, '%');
 4c4:	85d6                	mv	a1,s5
 4c6:	855a                	mv	a0,s6
 4c8:	e83ff0ef          	jal	ra,34a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4cc:	4981                	li	s3,0
 4ce:	bf69                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d0:	008b8913          	addi	s2,s7,8
 4d4:	4685                	li	a3,1
 4d6:	4629                	li	a2,10
 4d8:	000ba583          	lw	a1,0(s7)
 4dc:	855a                	mv	a0,s6
 4de:	e8bff0ef          	jal	ra,368 <printint>
 4e2:	8bca                	mv	s7,s2
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b749                	j	468 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	03868663          	beq	a3,s8,514 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ec:	05a68163          	beq	a3,s10,52e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4f0:	09b68d63          	beq	a3,s11,58a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4f4:	03a68f63          	beq	a3,s10,532 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4f8:	07800793          	li	a5,120
 4fc:	0cf68d63          	beq	a3,a5,5d6 <vprintf+0x1c8>
        putc(fd, '%');
 500:	85d6                	mv	a1,s5
 502:	855a                	mv	a0,s6
 504:	e47ff0ef          	jal	ra,34a <putc>
        putc(fd, c0);
 508:	85ca                	mv	a1,s2
 50a:	855a                	mv	a0,s6
 50c:	e3fff0ef          	jal	ra,34a <putc>
      state = 0;
 510:	4981                	li	s3,0
 512:	bf99                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	008b8913          	addi	s2,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	e47ff0ef          	jal	ra,368 <printint>
        i += 1;
 526:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
        i += 1;
 52c:	bf35                	j	468 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52e:	03860563          	beq	a2,s8,558 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 532:	07b60963          	beq	a2,s11,5a4 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 536:	07800793          	li	a5,120
 53a:	fcf613e3          	bne	a2,a5,500 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 53e:	008b8913          	addi	s2,s7,8
 542:	4681                	li	a3,0
 544:	4641                	li	a2,16
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e1dff0ef          	jal	ra,368 <printint>
        i += 2;
 550:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
        i += 2;
 556:	bf09                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 558:	008b8913          	addi	s2,s7,8
 55c:	4685                	li	a3,1
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e03ff0ef          	jal	ra,368 <printint>
        i += 2;
 56a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56c:	8bca                	mv	s7,s2
      state = 0;
 56e:	4981                	li	s3,0
        i += 2;
 570:	bde5                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 572:	008b8913          	addi	s2,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	de9ff0ef          	jal	ra,368 <printint>
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	b5c5                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	dd1ff0ef          	jal	ra,368 <printint>
        i += 1;
 59c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 1;
 5a2:	b5d9                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	db7ff0ef          	jal	ra,368 <printint>
        i += 2;
 5b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
        i += 2;
 5bc:	b575                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	d9dff0ef          	jal	ra,368 <printint>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bd51                	j	468 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	d85ff0ef          	jal	ra,368 <printint>
        i += 1;
 5e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 1;
 5ee:	bdad                	j	468 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5f0:	008b8793          	addi	a5,s7,8
 5f4:	f8f43423          	sd	a5,-120(s0)
 5f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fc:	03000593          	li	a1,48
 600:	855a                	mv	a0,s6
 602:	d49ff0ef          	jal	ra,34a <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	855a                	mv	a0,s6
 60c:	d3fff0ef          	jal	ra,34a <putc>
 610:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 612:	03c9d793          	srli	a5,s3,0x3c
 616:	97e6                	add	a5,a5,s9
 618:	0007c583          	lbu	a1,0(a5)
 61c:	855a                	mv	a0,s6
 61e:	d2dff0ef          	jal	ra,34a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 622:	0992                	slli	s3,s3,0x4
 624:	397d                	addiw	s2,s2,-1
 626:	fe0916e3          	bnez	s2,612 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 62a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd25                	j	468 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 632:	008b8993          	addi	s3,s7,8
 636:	000bb903          	ld	s2,0(s7)
 63a:	00090f63          	beqz	s2,658 <vprintf+0x24a>
        for(; *s; s++)
 63e:	00094583          	lbu	a1,0(s2)
 642:	c195                	beqz	a1,666 <vprintf+0x258>
          putc(fd, *s);
 644:	855a                	mv	a0,s6
 646:	d05ff0ef          	jal	ra,34a <putc>
        for(; *s; s++)
 64a:	0905                	addi	s2,s2,1
 64c:	00094583          	lbu	a1,0(s2)
 650:	f9f5                	bnez	a1,644 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	bd09                	j	468 <vprintf+0x5a>
          s = "(null)";
 658:	00000917          	auipc	s2,0x0
 65c:	20090913          	addi	s2,s2,512 # 858 <malloc+0xea>
        for(; *s; s++)
 660:	02800593          	li	a1,40
 664:	b7c5                	j	644 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	bbfd                	j	468 <vprintf+0x5a>
    }
  }
}
 66c:	70e6                	ld	ra,120(sp)
 66e:	7446                	ld	s0,112(sp)
 670:	74a6                	ld	s1,104(sp)
 672:	7906                	ld	s2,96(sp)
 674:	69e6                	ld	s3,88(sp)
 676:	6a46                	ld	s4,80(sp)
 678:	6aa6                	ld	s5,72(sp)
 67a:	6b06                	ld	s6,64(sp)
 67c:	7be2                	ld	s7,56(sp)
 67e:	7c42                	ld	s8,48(sp)
 680:	7ca2                	ld	s9,40(sp)
 682:	7d02                	ld	s10,32(sp)
 684:	6de2                	ld	s11,24(sp)
 686:	6109                	addi	sp,sp,128
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	d67ff0ef          	jal	ra,40e <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	addi	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	addi	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	d35ff0ef          	jal	ra,40e <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6125                	addi	sp,sp,96
 6e4:	8082                	ret

00000000000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e422                	sd	s0,8(sp)
 6ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f0:	00001797          	auipc	a5,0x1
 6f4:	9107b783          	ld	a5,-1776(a5) # 1000 <freep>
 6f8:	a805                	j	728 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fa:	4618                	lw	a4,8(a2)
 6fc:	9db9                	addw	a1,a1,a4
 6fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	6398                	ld	a4,0(a5)
 704:	6318                	ld	a4,0(a4)
 706:	fee53823          	sd	a4,-16(a0)
 70a:	a091                	j	74e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70c:	ff852703          	lw	a4,-8(a0)
 710:	9e39                	addw	a2,a2,a4
 712:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 714:	ff053703          	ld	a4,-16(a0)
 718:	e398                	sd	a4,0(a5)
 71a:	a099                	j	760 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	6398                	ld	a4,0(a5)
 71e:	00e7e463          	bltu	a5,a4,726 <free+0x40>
 722:	00e6ea63          	bltu	a3,a4,736 <free+0x50>
{
 726:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	fed7fae3          	bgeu	a5,a3,71c <free+0x36>
 72c:	6398                	ld	a4,0(a5)
 72e:	00e6e463          	bltu	a3,a4,736 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	fee7eae3          	bltu	a5,a4,726 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 736:	ff852583          	lw	a1,-8(a0)
 73a:	6390                	ld	a2,0(a5)
 73c:	02059713          	slli	a4,a1,0x20
 740:	9301                	srli	a4,a4,0x20
 742:	0712                	slli	a4,a4,0x4
 744:	9736                	add	a4,a4,a3
 746:	fae60ae3          	beq	a2,a4,6fa <free+0x14>
    bp->s.ptr = p->s.ptr;
 74a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74e:	4790                	lw	a2,8(a5)
 750:	02061713          	slli	a4,a2,0x20
 754:	9301                	srli	a4,a4,0x20
 756:	0712                	slli	a4,a4,0x4
 758:	973e                	add	a4,a4,a5
 75a:	fae689e3          	beq	a3,a4,70c <free+0x26>
  } else
    p->s.ptr = bp;
 75e:	e394                	sd	a3,0(a5)
  freep = p;
 760:	00001717          	auipc	a4,0x1
 764:	8af73023          	sd	a5,-1888(a4) # 1000 <freep>
}
 768:	6422                	ld	s0,8(sp)
 76a:	0141                	addi	sp,sp,16
 76c:	8082                	ret

000000000000076e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76e:	7139                	addi	sp,sp,-64
 770:	fc06                	sd	ra,56(sp)
 772:	f822                	sd	s0,48(sp)
 774:	f426                	sd	s1,40(sp)
 776:	f04a                	sd	s2,32(sp)
 778:	ec4e                	sd	s3,24(sp)
 77a:	e852                	sd	s4,16(sp)
 77c:	e456                	sd	s5,8(sp)
 77e:	e05a                	sd	s6,0(sp)
 780:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	02051493          	slli	s1,a0,0x20
 786:	9081                	srli	s1,s1,0x20
 788:	04bd                	addi	s1,s1,15
 78a:	8091                	srli	s1,s1,0x4
 78c:	0014899b          	addiw	s3,s1,1
 790:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 792:	00001517          	auipc	a0,0x1
 796:	86e53503          	ld	a0,-1938(a0) # 1000 <freep>
 79a:	c515                	beqz	a0,7c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79e:	4798                	lw	a4,8(a5)
 7a0:	02977f63          	bgeu	a4,s1,7de <malloc+0x70>
 7a4:	8a4e                	mv	s4,s3
 7a6:	0009871b          	sext.w	a4,s3
 7aa:	6685                	lui	a3,0x1
 7ac:	00d77363          	bgeu	a4,a3,7b2 <malloc+0x44>
 7b0:	6a05                	lui	s4,0x1
 7b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ba:	00001917          	auipc	s2,0x1
 7be:	84690913          	addi	s2,s2,-1978 # 1000 <freep>
  if(p == (char*)-1)
 7c2:	5afd                	li	s5,-1
 7c4:	a0bd                	j	832 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7c6:	00001797          	auipc	a5,0x1
 7ca:	84a78793          	addi	a5,a5,-1974 # 1010 <base>
 7ce:	00001717          	auipc	a4,0x1
 7d2:	82f73923          	sd	a5,-1998(a4) # 1000 <freep>
 7d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7dc:	b7e1                	j	7a4 <malloc+0x36>
      if(p->s.size == nunits)
 7de:	02e48b63          	beq	s1,a4,814 <malloc+0xa6>
        p->s.size -= nunits;
 7e2:	4137073b          	subw	a4,a4,s3
 7e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e8:	1702                	slli	a4,a4,0x20
 7ea:	9301                	srli	a4,a4,0x20
 7ec:	0712                	slli	a4,a4,0x4
 7ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f4:	00001717          	auipc	a4,0x1
 7f8:	80a73623          	sd	a0,-2036(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 800:	70e2                	ld	ra,56(sp)
 802:	7442                	ld	s0,48(sp)
 804:	74a2                	ld	s1,40(sp)
 806:	7902                	ld	s2,32(sp)
 808:	69e2                	ld	s3,24(sp)
 80a:	6a42                	ld	s4,16(sp)
 80c:	6aa2                	ld	s5,8(sp)
 80e:	6b02                	ld	s6,0(sp)
 810:	6121                	addi	sp,sp,64
 812:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	e118                	sd	a4,0(a0)
 818:	bff1                	j	7f4 <malloc+0x86>
  hp->s.size = nu;
 81a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81e:	0541                	addi	a0,a0,16
 820:	ec7ff0ef          	jal	ra,6e6 <free>
  return freep;
 824:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 828:	dd61                	beqz	a0,800 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	fa9778e3          	bgeu	a4,s1,7de <malloc+0x70>
    if(p == freep)
 832:	00093703          	ld	a4,0(s2)
 836:	853e                	mv	a0,a5
 838:	fef719e3          	bne	a4,a5,82a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 83c:	8552                	mv	a0,s4
 83e:	ad5ff0ef          	jal	ra,312 <sbrk>
  if(p == (char*)-1)
 842:	fd551ce3          	bne	a0,s5,81a <malloc+0xac>
        return 0;
 846:	4501                	li	a0,0
 848:	bf65                	j	800 <malloc+0x92>
