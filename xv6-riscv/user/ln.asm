
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	00f50c63          	beq	a0,a5,24 <main+0x24>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	86058593          	addi	a1,a1,-1952 # 870 <malloc+0xdc>
  18:	4509                	li	a0,2
  1a:	696000ef          	jal	ra,6b0 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	298000ef          	jal	ra,2b8 <exit>
  24:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  26:	698c                	ld	a1,16(a1)
  28:	6488                	ld	a0,8(s1)
  2a:	2ee000ef          	jal	ra,318 <link>
  2e:	00054563          	bltz	a0,38 <main+0x38>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  32:	4501                	li	a0,0
  34:	284000ef          	jal	ra,2b8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  38:	6894                	ld	a3,16(s1)
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	84c58593          	addi	a1,a1,-1972 # 888 <malloc+0xf4>
  44:	4509                	li	a0,2
  46:	66a000ef          	jal	ra,6b0 <fprintf>
  4a:	b7e5                	j	32 <main+0x32>

000000000000004c <start>:
//


void
start()
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e406                	sd	ra,8(sp)
  50:	e022                	sd	s0,0(sp)
  52:	0800                	addi	s0,sp,16
  extern int main();
  main();
  54:	fadff0ef          	jal	ra,0 <main>
  exit(0);
  58:	4501                	li	a0,0
  5a:	25e000ef          	jal	ra,2b8 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	87aa                	mv	a5,a0
  66:	0585                	addi	a1,a1,1
  68:	0785                	addi	a5,a5,1
  6a:	fff5c703          	lbu	a4,-1(a1)
  6e:	fee78fa3          	sb	a4,-1(a5)
  72:	fb75                	bnez	a4,66 <strcpy+0x8>
    ;
  return os;
}
  74:	6422                	ld	s0,8(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	cb91                	beqz	a5,98 <strcmp+0x1e>
  86:	0005c703          	lbu	a4,0(a1)
  8a:	00f71763          	bne	a4,a5,98 <strcmp+0x1e>
    p++, q++;
  8e:	0505                	addi	a0,a0,1
  90:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	fbe5                	bnez	a5,86 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  98:	0005c503          	lbu	a0,0(a1)
}
  9c:	40a7853b          	subw	a0,a5,a0
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strlen>:

uint
strlen(const char *s)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cf91                	beqz	a5,cc <strlen+0x26>
  b2:	0505                	addi	a0,a0,1
  b4:	87aa                	mv	a5,a0
  b6:	4685                	li	a3,1
  b8:	9e89                	subw	a3,a3,a0
  ba:	00f6853b          	addw	a0,a3,a5
  be:	0785                	addi	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	fb7d                	bnez	a4,ba <strlen+0x14>
    ;
  return n;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret
  for(n = 0; s[n]; n++)
  cc:	4501                	li	a0,0
  ce:	bfe5                	j	c6 <strlen+0x20>

00000000000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d6:	ca19                	beqz	a2,ec <memset+0x1c>
  d8:	87aa                	mv	a5,a0
  da:	1602                	slli	a2,a2,0x20
  dc:	9201                	srli	a2,a2,0x20
  de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e6:	0785                	addi	a5,a5,1
  e8:	fee79de3          	bne	a5,a4,e2 <memset+0x12>
  }
  return dst;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strchr>:

char*
strchr(const char *s, char c)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb99                	beqz	a5,112 <strchr+0x20>
    if(*s == c)
  fe:	00f58763          	beq	a1,a5,10c <strchr+0x1a>
  for(; *s; s++)
 102:	0505                	addi	a0,a0,1
 104:	00054783          	lbu	a5,0(a0)
 108:	fbfd                	bnez	a5,fe <strchr+0xc>
      return (char*)s;
  return 0;
 10a:	4501                	li	a0,0
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret
  return 0;
 112:	4501                	li	a0,0
 114:	bfe5                	j	10c <strchr+0x1a>

0000000000000116 <gets>:

char*
gets(char *buf, int max)
{
 116:	711d                	addi	sp,sp,-96
 118:	ec86                	sd	ra,88(sp)
 11a:	e8a2                	sd	s0,80(sp)
 11c:	e4a6                	sd	s1,72(sp)
 11e:	e0ca                	sd	s2,64(sp)
 120:	fc4e                	sd	s3,56(sp)
 122:	f852                	sd	s4,48(sp)
 124:	f456                	sd	s5,40(sp)
 126:	f05a                	sd	s6,32(sp)
 128:	ec5e                	sd	s7,24(sp)
 12a:	1080                	addi	s0,sp,96
 12c:	8baa                	mv	s7,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 134:	4aa9                	li	s5,10
 136:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 138:	89a6                	mv	s3,s1
 13a:	2485                	addiw	s1,s1,1
 13c:	0344d663          	bge	s1,s4,168 <gets+0x52>
    cc = read(0, &c, 1);
 140:	4605                	li	a2,1
 142:	faf40593          	addi	a1,s0,-81
 146:	4501                	li	a0,0
 148:	188000ef          	jal	ra,2d0 <read>
    if(cc < 1)
 14c:	00a05e63          	blez	a0,168 <gets+0x52>
    buf[i++] = c;
 150:	faf44783          	lbu	a5,-81(s0)
 154:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 158:	01578763          	beq	a5,s5,166 <gets+0x50>
 15c:	0905                	addi	s2,s2,1
 15e:	fd679de3          	bne	a5,s6,138 <gets+0x22>
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	a011                	j	168 <gets+0x52>
 166:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 168:	99de                	add	s3,s3,s7
 16a:	00098023          	sb	zero,0(s3)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6125                	addi	sp,sp,96
 184:	8082                	ret

0000000000000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	1101                	addi	sp,sp,-32
 188:	ec06                	sd	ra,24(sp)
 18a:	e822                	sd	s0,16(sp)
 18c:	e426                	sd	s1,8(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	addi	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	162000ef          	jal	ra,2f8 <open>
  if(fd < 0)
 19a:	02054163          	bltz	a0,1bc <stat+0x36>
 19e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a0:	85ca                	mv	a1,s2
 1a2:	16e000ef          	jal	ra,310 <fstat>
 1a6:	892a                	mv	s2,a0
  close(fd);
 1a8:	8526                	mv	a0,s1
 1aa:	136000ef          	jal	ra,2e0 <close>
  return r;
}
 1ae:	854a                	mv	a0,s2
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6902                	ld	s2,0(sp)
 1b8:	6105                	addi	sp,sp,32
 1ba:	8082                	ret
    return -1;
 1bc:	597d                	li	s2,-1
 1be:	bfc5                	j	1ae <stat+0x28>

00000000000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c6:	00054603          	lbu	a2,0(a0)
 1ca:	fd06079b          	addiw	a5,a2,-48
 1ce:	0ff7f793          	andi	a5,a5,255
 1d2:	4725                	li	a4,9
 1d4:	02f76963          	bltu	a4,a5,206 <atoi+0x46>
 1d8:	86aa                	mv	a3,a0
  n = 0;
 1da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1de:	0685                	addi	a3,a3,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb1                	addw	a5,a5,a2
 1ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	0006c603          	lbu	a2,0(a3)
 1f4:	fd06071b          	addiw	a4,a2,-48
 1f8:	0ff77713          	andi	a4,a4,255
 1fc:	fee5f1e3          	bgeu	a1,a4,1de <atoi+0x1e>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x40>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	addi	a1,a1,1
 224:	0705                	addi	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	f67ff0ef          	jal	ra,20a <memmove>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b0:	4885                	li	a7,1
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b8:	4889                	li	a7,2
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c0:	488d                	li	a7,3
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c8:	4891                	li	a7,4
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <read>:
.global read
read:
 li a7, SYS_read
 2d0:	4895                	li	a7,5
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <write>:
.global write
write:
 li a7, SYS_write
 2d8:	48c1                	li	a7,16
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <close>:
.global close
close:
 li a7, SYS_close
 2e0:	48d5                	li	a7,21
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e8:	4899                	li	a7,6
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f0:	489d                	li	a7,7
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <open>:
.global open
open:
 li a7, SYS_open
 2f8:	48bd                	li	a7,15
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 300:	48c5                	li	a7,17
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 308:	48c9                	li	a7,18
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <link>:
.global link
link:
 li a7, SYS_link
 318:	48cd                	li	a7,19
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 320:	48d1                	li	a7,20
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 328:	48a5                	li	a7,9
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <dup>:
.global dup
dup:
 li a7, SYS_dup
 330:	48a9                	li	a7,10
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 338:	48ad                	li	a7,11
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 340:	48b1                	li	a7,12
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 348:	48b5                	li	a7,13
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 350:	48b9                	li	a7,14
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 358:	48d9                	li	a7,22
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <getprocstat>:
.global getprocstat
getprocstat:
 li a7, SYS_getprocstat
 360:	48dd                	li	a7,23
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 368:	48e1                	li	a7,24
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 370:	1101                	addi	sp,sp,-32
 372:	ec06                	sd	ra,24(sp)
 374:	e822                	sd	s0,16(sp)
 376:	1000                	addi	s0,sp,32
 378:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37c:	4605                	li	a2,1
 37e:	fef40593          	addi	a1,s0,-17
 382:	f57ff0ef          	jal	ra,2d8 <write>
}
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	6105                	addi	sp,sp,32
 38c:	8082                	ret

000000000000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	7139                	addi	sp,sp,-64
 390:	fc06                	sd	ra,56(sp)
 392:	f822                	sd	s0,48(sp)
 394:	f426                	sd	s1,40(sp)
 396:	f04a                	sd	s2,32(sp)
 398:	ec4e                	sd	s3,24(sp)
 39a:	0080                	addi	s0,sp,64
 39c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	c299                	beqz	a3,3a4 <printint+0x16>
 3a0:	0805c663          	bltz	a1,42c <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a4:	2581                	sext.w	a1,a1
  neg = 0;
 3a6:	4881                	li	a7,0
 3a8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ae:	2601                	sext.w	a2,a2
 3b0:	00000517          	auipc	a0,0x0
 3b4:	4f850513          	addi	a0,a0,1272 # 8a8 <digits>
 3b8:	883a                	mv	a6,a4
 3ba:	2705                	addiw	a4,a4,1
 3bc:	02c5f7bb          	remuw	a5,a1,a2
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	97aa                	add	a5,a5,a0
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ce:	0005879b          	sext.w	a5,a1
 3d2:	02c5d5bb          	divuw	a1,a1,a2
 3d6:	0685                	addi	a3,a3,1
 3d8:	fec7f0e3          	bgeu	a5,a2,3b8 <printint+0x2a>
  if(neg)
 3dc:	00088b63          	beqz	a7,3f2 <printint+0x64>
    buf[i++] = '-';
 3e0:	fd040793          	addi	a5,s0,-48
 3e4:	973e                	add	a4,a4,a5
 3e6:	02d00793          	li	a5,45
 3ea:	fef70823          	sb	a5,-16(a4)
 3ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f2:	02e05663          	blez	a4,41e <printint+0x90>
 3f6:	fc040793          	addi	a5,s0,-64
 3fa:	00e78933          	add	s2,a5,a4
 3fe:	fff78993          	addi	s3,a5,-1
 402:	99ba                	add	s3,s3,a4
 404:	377d                	addiw	a4,a4,-1
 406:	1702                	slli	a4,a4,0x20
 408:	9301                	srli	a4,a4,0x20
 40a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40e:	fff94583          	lbu	a1,-1(s2)
 412:	8526                	mv	a0,s1
 414:	f5dff0ef          	jal	ra,370 <putc>
  while(--i >= 0)
 418:	197d                	addi	s2,s2,-1
 41a:	ff391ae3          	bne	s2,s3,40e <printint+0x80>
}
 41e:	70e2                	ld	ra,56(sp)
 420:	7442                	ld	s0,48(sp)
 422:	74a2                	ld	s1,40(sp)
 424:	7902                	ld	s2,32(sp)
 426:	69e2                	ld	s3,24(sp)
 428:	6121                	addi	sp,sp,64
 42a:	8082                	ret
    x = -xx;
 42c:	40b005bb          	negw	a1,a1
    neg = 1;
 430:	4885                	li	a7,1
    x = -xx;
 432:	bf9d                	j	3a8 <printint+0x1a>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	7119                	addi	sp,sp,-128
 436:	fc86                	sd	ra,120(sp)
 438:	f8a2                	sd	s0,112(sp)
 43a:	f4a6                	sd	s1,104(sp)
 43c:	f0ca                	sd	s2,96(sp)
 43e:	ecce                	sd	s3,88(sp)
 440:	e8d2                	sd	s4,80(sp)
 442:	e4d6                	sd	s5,72(sp)
 444:	e0da                	sd	s6,64(sp)
 446:	fc5e                	sd	s7,56(sp)
 448:	f862                	sd	s8,48(sp)
 44a:	f466                	sd	s9,40(sp)
 44c:	f06a                	sd	s10,32(sp)
 44e:	ec6e                	sd	s11,24(sp)
 450:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 452:	0005c903          	lbu	s2,0(a1)
 456:	22090e63          	beqz	s2,692 <vprintf+0x25e>
 45a:	8b2a                	mv	s6,a0
 45c:	8a2e                	mv	s4,a1
 45e:	8bb2                	mv	s7,a2
  state = 0;
 460:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 462:	4481                	li	s1,0
 464:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 466:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 46a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 46e:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 472:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 476:	00000c97          	auipc	s9,0x0
 47a:	432c8c93          	addi	s9,s9,1074 # 8a8 <digits>
 47e:	a005                	j	49e <vprintf+0x6a>
        putc(fd, c0);
 480:	85ca                	mv	a1,s2
 482:	855a                	mv	a0,s6
 484:	eedff0ef          	jal	ra,370 <putc>
 488:	a019                	j	48e <vprintf+0x5a>
    } else if(state == '%'){
 48a:	03598263          	beq	s3,s5,4ae <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 48e:	2485                	addiw	s1,s1,1
 490:	8726                	mv	a4,s1
 492:	009a07b3          	add	a5,s4,s1
 496:	0007c903          	lbu	s2,0(a5)
 49a:	1e090c63          	beqz	s2,692 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 49e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a2:	fe0994e3          	bnez	s3,48a <vprintf+0x56>
      if(c0 == '%'){
 4a6:	fd579de3          	bne	a5,s5,480 <vprintf+0x4c>
        state = '%';
 4aa:	89be                	mv	s3,a5
 4ac:	b7cd                	j	48e <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ae:	cfa5                	beqz	a5,526 <vprintf+0xf2>
 4b0:	00ea06b3          	add	a3,s4,a4
 4b4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ba:	c681                	beqz	a3,4c2 <vprintf+0x8e>
 4bc:	9752                	add	a4,a4,s4
 4be:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c2:	03878a63          	beq	a5,s8,4f6 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4c6:	05a78463          	beq	a5,s10,50e <vprintf+0xda>
      } else if(c0 == 'u'){
 4ca:	0db78763          	beq	a5,s11,598 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ce:	07800713          	li	a4,120
 4d2:	10e78963          	beq	a5,a4,5e4 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d6:	07000713          	li	a4,112
 4da:	12e78e63          	beq	a5,a4,616 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4de:	07300713          	li	a4,115
 4e2:	16e78b63          	beq	a5,a4,658 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e6:	05579063          	bne	a5,s5,526 <vprintf+0xf2>
        putc(fd, '%');
 4ea:	85d6                	mv	a1,s5
 4ec:	855a                	mv	a0,s6
 4ee:	e83ff0ef          	jal	ra,370 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	bf69                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f6:	008b8913          	addi	s2,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	855a                	mv	a0,s6
 504:	e8bff0ef          	jal	ra,38e <printint>
 508:	8bca                	mv	s7,s2
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b749                	j	48e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 50e:	03868663          	beq	a3,s8,53a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 512:	05a68163          	beq	a3,s10,554 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 516:	09b68d63          	beq	a3,s11,5b0 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 51a:	03a68f63          	beq	a3,s10,558 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 51e:	07800793          	li	a5,120
 522:	0cf68d63          	beq	a3,a5,5fc <vprintf+0x1c8>
        putc(fd, '%');
 526:	85d6                	mv	a1,s5
 528:	855a                	mv	a0,s6
 52a:	e47ff0ef          	jal	ra,370 <putc>
        putc(fd, c0);
 52e:	85ca                	mv	a1,s2
 530:	855a                	mv	a0,s6
 532:	e3fff0ef          	jal	ra,370 <putc>
      state = 0;
 536:	4981                	li	s3,0
 538:	bf99                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e47ff0ef          	jal	ra,38e <printint>
        i += 1;
 54c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	8bca                	mv	s7,s2
      state = 0;
 550:	4981                	li	s3,0
        i += 1;
 552:	bf35                	j	48e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 554:	03860563          	beq	a2,s8,57e <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 558:	07b60963          	beq	a2,s11,5ca <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55c:	07800793          	li	a5,120
 560:	fcf613e3          	bne	a2,a5,526 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 564:	008b8913          	addi	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4641                	li	a2,16
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	e1dff0ef          	jal	ra,38e <printint>
        i += 2;
 576:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 578:	8bca                	mv	s7,s2
      state = 0;
 57a:	4981                	li	s3,0
        i += 2;
 57c:	bf09                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	008b8913          	addi	s2,s7,8
 582:	4685                	li	a3,1
 584:	4629                	li	a2,10
 586:	000ba583          	lw	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	e03ff0ef          	jal	ra,38e <printint>
        i += 2;
 590:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 2;
 596:	bde5                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	de9ff0ef          	jal	ra,38e <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5c5                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	dd1ff0ef          	jal	ra,38e <printint>
        i += 1;
 5c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
        i += 1;
 5c8:	b5d9                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	db7ff0ef          	jal	ra,38e <printint>
        i += 2;
 5dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 2;
 5e2:	b575                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	d9dff0ef          	jal	ra,38e <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bd51                	j	48e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	d85ff0ef          	jal	ra,38e <printint>
        i += 1;
 60e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
        i += 1;
 614:	bdad                	j	48e <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 616:	008b8793          	addi	a5,s7,8
 61a:	f8f43423          	sd	a5,-120(s0)
 61e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 622:	03000593          	li	a1,48
 626:	855a                	mv	a0,s6
 628:	d49ff0ef          	jal	ra,370 <putc>
  putc(fd, 'x');
 62c:	07800593          	li	a1,120
 630:	855a                	mv	a0,s6
 632:	d3fff0ef          	jal	ra,370 <putc>
 636:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 638:	03c9d793          	srli	a5,s3,0x3c
 63c:	97e6                	add	a5,a5,s9
 63e:	0007c583          	lbu	a1,0(a5)
 642:	855a                	mv	a0,s6
 644:	d2dff0ef          	jal	ra,370 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 648:	0992                	slli	s3,s3,0x4
 64a:	397d                	addiw	s2,s2,-1
 64c:	fe0916e3          	bnez	s2,638 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 650:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 654:	4981                	li	s3,0
 656:	bd25                	j	48e <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 658:	008b8993          	addi	s3,s7,8
 65c:	000bb903          	ld	s2,0(s7)
 660:	00090f63          	beqz	s2,67e <vprintf+0x24a>
        for(; *s; s++)
 664:	00094583          	lbu	a1,0(s2)
 668:	c195                	beqz	a1,68c <vprintf+0x258>
          putc(fd, *s);
 66a:	855a                	mv	a0,s6
 66c:	d05ff0ef          	jal	ra,370 <putc>
        for(; *s; s++)
 670:	0905                	addi	s2,s2,1
 672:	00094583          	lbu	a1,0(s2)
 676:	f9f5                	bnez	a1,66a <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd09                	j	48e <vprintf+0x5a>
          s = "(null)";
 67e:	00000917          	auipc	s2,0x0
 682:	22290913          	addi	s2,s2,546 # 8a0 <malloc+0x10c>
        for(; *s; s++)
 686:	02800593          	li	a1,40
 68a:	b7c5                	j	66a <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	bbfd                	j	48e <vprintf+0x5a>
    }
  }
}
 692:	70e6                	ld	ra,120(sp)
 694:	7446                	ld	s0,112(sp)
 696:	74a6                	ld	s1,104(sp)
 698:	7906                	ld	s2,96(sp)
 69a:	69e6                	ld	s3,88(sp)
 69c:	6a46                	ld	s4,80(sp)
 69e:	6aa6                	ld	s5,72(sp)
 6a0:	6b06                	ld	s6,64(sp)
 6a2:	7be2                	ld	s7,56(sp)
 6a4:	7c42                	ld	s8,48(sp)
 6a6:	7ca2                	ld	s9,40(sp)
 6a8:	7d02                	ld	s10,32(sp)
 6aa:	6de2                	ld	s11,24(sp)
 6ac:	6109                	addi	sp,sp,128
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	addi	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	8622                	mv	a2,s0
 6ce:	d67ff0ef          	jal	ra,434 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6161                	addi	sp,sp,80
 6d8:	8082                	ret

00000000000006da <printf>:

void
printf(const char *fmt, ...)
{
 6da:	711d                	addi	sp,sp,-96
 6dc:	ec06                	sd	ra,24(sp)
 6de:	e822                	sd	s0,16(sp)
 6e0:	1000                	addi	s0,sp,32
 6e2:	e40c                	sd	a1,8(s0)
 6e4:	e810                	sd	a2,16(s0)
 6e6:	ec14                	sd	a3,24(s0)
 6e8:	f018                	sd	a4,32(s0)
 6ea:	f41c                	sd	a5,40(s0)
 6ec:	03043823          	sd	a6,48(s0)
 6f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	00840613          	addi	a2,s0,8
 6f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fc:	85aa                	mv	a1,a0
 6fe:	4505                	li	a0,1
 700:	d35ff0ef          	jal	ra,434 <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6125                	addi	sp,sp,96
 70a:	8082                	ret

000000000000070c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 712:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	00001797          	auipc	a5,0x1
 71a:	8ea7b783          	ld	a5,-1814(a5) # 1000 <freep>
 71e:	a805                	j	74e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 720:	4618                	lw	a4,8(a2)
 722:	9db9                	addw	a1,a1,a4
 724:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	6398                	ld	a4,0(a5)
 72a:	6318                	ld	a4,0(a4)
 72c:	fee53823          	sd	a4,-16(a0)
 730:	a091                	j	774 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 732:	ff852703          	lw	a4,-8(a0)
 736:	9e39                	addw	a2,a2,a4
 738:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 73a:	ff053703          	ld	a4,-16(a0)
 73e:	e398                	sd	a4,0(a5)
 740:	a099                	j	786 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	6398                	ld	a4,0(a5)
 744:	00e7e463          	bltu	a5,a4,74c <free+0x40>
 748:	00e6ea63          	bltu	a3,a4,75c <free+0x50>
{
 74c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	fed7fae3          	bgeu	a5,a3,742 <free+0x36>
 752:	6398                	ld	a4,0(a5)
 754:	00e6e463          	bltu	a3,a4,75c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	fee7eae3          	bltu	a5,a4,74c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 75c:	ff852583          	lw	a1,-8(a0)
 760:	6390                	ld	a2,0(a5)
 762:	02059713          	slli	a4,a1,0x20
 766:	9301                	srli	a4,a4,0x20
 768:	0712                	slli	a4,a4,0x4
 76a:	9736                	add	a4,a4,a3
 76c:	fae60ae3          	beq	a2,a4,720 <free+0x14>
    bp->s.ptr = p->s.ptr;
 770:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 774:	4790                	lw	a2,8(a5)
 776:	02061713          	slli	a4,a2,0x20
 77a:	9301                	srli	a4,a4,0x20
 77c:	0712                	slli	a4,a4,0x4
 77e:	973e                	add	a4,a4,a5
 780:	fae689e3          	beq	a3,a4,732 <free+0x26>
  } else
    p->s.ptr = bp;
 784:	e394                	sd	a3,0(a5)
  freep = p;
 786:	00001717          	auipc	a4,0x1
 78a:	86f73d23          	sd	a5,-1926(a4) # 1000 <freep>
}
 78e:	6422                	ld	s0,8(sp)
 790:	0141                	addi	sp,sp,16
 792:	8082                	ret

0000000000000794 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 794:	7139                	addi	sp,sp,-64
 796:	fc06                	sd	ra,56(sp)
 798:	f822                	sd	s0,48(sp)
 79a:	f426                	sd	s1,40(sp)
 79c:	f04a                	sd	s2,32(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	e852                	sd	s4,16(sp)
 7a2:	e456                	sd	s5,8(sp)
 7a4:	e05a                	sd	s6,0(sp)
 7a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a8:	02051493          	slli	s1,a0,0x20
 7ac:	9081                	srli	s1,s1,0x20
 7ae:	04bd                	addi	s1,s1,15
 7b0:	8091                	srli	s1,s1,0x4
 7b2:	0014899b          	addiw	s3,s1,1
 7b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7b8:	00001517          	auipc	a0,0x1
 7bc:	84853503          	ld	a0,-1976(a0) # 1000 <freep>
 7c0:	c515                	beqz	a0,7ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	02977f63          	bgeu	a4,s1,804 <malloc+0x70>
 7ca:	8a4e                	mv	s4,s3
 7cc:	0009871b          	sext.w	a4,s3
 7d0:	6685                	lui	a3,0x1
 7d2:	00d77363          	bgeu	a4,a3,7d8 <malloc+0x44>
 7d6:	6a05                	lui	s4,0x1
 7d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e0:	00001917          	auipc	s2,0x1
 7e4:	82090913          	addi	s2,s2,-2016 # 1000 <freep>
  if(p == (char*)-1)
 7e8:	5afd                	li	s5,-1
 7ea:	a0bd                	j	858 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7ec:	00001797          	auipc	a5,0x1
 7f0:	82478793          	addi	a5,a5,-2012 # 1010 <base>
 7f4:	00001717          	auipc	a4,0x1
 7f8:	80f73623          	sd	a5,-2036(a4) # 1000 <freep>
 7fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 802:	b7e1                	j	7ca <malloc+0x36>
      if(p->s.size == nunits)
 804:	02e48b63          	beq	s1,a4,83a <malloc+0xa6>
        p->s.size -= nunits;
 808:	4137073b          	subw	a4,a4,s3
 80c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 80e:	1702                	slli	a4,a4,0x20
 810:	9301                	srli	a4,a4,0x20
 812:	0712                	slli	a4,a4,0x4
 814:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 816:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81a:	00000717          	auipc	a4,0x0
 81e:	7ea73323          	sd	a0,2022(a4) # 1000 <freep>
      return (void*)(p + 1);
 822:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 826:	70e2                	ld	ra,56(sp)
 828:	7442                	ld	s0,48(sp)
 82a:	74a2                	ld	s1,40(sp)
 82c:	7902                	ld	s2,32(sp)
 82e:	69e2                	ld	s3,24(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6b02                	ld	s6,0(sp)
 836:	6121                	addi	sp,sp,64
 838:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 83a:	6398                	ld	a4,0(a5)
 83c:	e118                	sd	a4,0(a0)
 83e:	bff1                	j	81a <malloc+0x86>
  hp->s.size = nu;
 840:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 844:	0541                	addi	a0,a0,16
 846:	ec7ff0ef          	jal	ra,70c <free>
  return freep;
 84a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 84e:	dd61                	beqz	a0,826 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	fa9778e3          	bgeu	a4,s1,804 <malloc+0x70>
    if(p == freep)
 858:	00093703          	ld	a4,0(s2)
 85c:	853e                	mv	a0,a5
 85e:	fef719e3          	bne	a4,a5,850 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 862:	8552                	mv	a0,s4
 864:	addff0ef          	jal	ra,340 <sbrk>
  if(p == (char*)-1)
 868:	fd551ce3          	bne	a0,s5,840 <malloc+0xac>
        return 0;
 86c:	4501                	li	a0,0
 86e:	bf65                	j	826 <malloc+0x92>
