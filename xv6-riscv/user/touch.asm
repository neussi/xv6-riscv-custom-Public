
user/_touch:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
    int fd;
    
    if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7db63          	bge	a5,a0,46 <main+0x46>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
        fprintf(2, "Usage: touch file...\n");
        exit(1);
    }
    
    for(int i = 1; i < argc; i++){
        if((fd = open(argv[i], O_CREATE | O_RDWR)) < 0){
  28:	20200593          	li	a1,514
  2c:	6088                	ld	a0,0(s1)
  2e:	2ee000ef          	jal	ra,31c <open>
  32:	02054463          	bltz	a0,5a <main+0x5a>
            fprintf(2, "touch: cannot create %s\n", argv[i]);
            exit(1);
        }
        close(fd);
  36:	2ce000ef          	jal	ra,304 <close>
    for(int i = 1; i < argc; i++){
  3a:	04a1                	addi	s1,s1,8
  3c:	ff2496e3          	bne	s1,s2,28 <main+0x28>
    }
    exit(0);
  40:	4501                	li	a0,0
  42:	29a000ef          	jal	ra,2dc <exit>
        fprintf(2, "Usage: touch file...\n");
  46:	00001597          	auipc	a1,0x1
  4a:	85a58593          	addi	a1,a1,-1958 # 8a0 <malloc+0xe0>
  4e:	4509                	li	a0,2
  50:	68c000ef          	jal	ra,6dc <fprintf>
        exit(1);
  54:	4505                	li	a0,1
  56:	286000ef          	jal	ra,2dc <exit>
            fprintf(2, "touch: cannot create %s\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	85c58593          	addi	a1,a1,-1956 # 8b8 <malloc+0xf8>
  64:	4509                	li	a0,2
  66:	676000ef          	jal	ra,6dc <fprintf>
            exit(1);
  6a:	4505                	li	a0,1
  6c:	270000ef          	jal	ra,2dc <exit>

0000000000000070 <start>:
//


void
start()
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  extern int main();
  main();
  78:	f89ff0ef          	jal	ra,0 <main>
  exit(0);
  7c:	4501                	li	a0,0
  7e:	25e000ef          	jal	ra,2dc <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	4685                	li	a3,1
  dc:	9e89                	subw	a3,a3,a0
  de:	00f6853b          	addw	a0,a3,a5
  e2:	0785                	addi	a5,a5,1
  e4:	fff7c703          	lbu	a4,-1(a5)
  e8:	fb7d                	bnez	a4,de <strlen+0x14>
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for(; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	711d                	addi	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addiw	s1,s1,1
 160:	0344d663          	bge	s1,s4,18c <gets+0x52>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	addi	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	188000ef          	jal	ra,2f4 <read>
    if(cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x52>
    buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	01578763          	beq	a5,s5,18a <gets+0x50>
 180:	0905                	addi	s2,s2,1
 182:	fd679de3          	bne	a5,s6,15c <gets+0x22>
  for(i=0; i+1 < max; ){
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x52>
 18a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
  return buf;
}
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int
stat(const char *n, struct stat *st)
{
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	addi	s0,sp,32
 1b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	4581                	li	a1,0
 1ba:	162000ef          	jal	ra,31c <open>
  if(fd < 0)
 1be:	02054163          	bltz	a0,1e0 <stat+0x36>
 1c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c4:	85ca                	mv	a1,s2
 1c6:	16e000ef          	jal	ra,334 <fstat>
 1ca:	892a                	mv	s2,a0
  close(fd);
 1cc:	8526                	mv	a0,s1
 1ce:	136000ef          	jal	ra,304 <close>
  return r;
}
 1d2:	854a                	mv	a0,s2
 1d4:	60e2                	ld	ra,24(sp)
 1d6:	6442                	ld	s0,16(sp)
 1d8:	64a2                	ld	s1,8(sp)
 1da:	6902                	ld	s2,0(sp)
 1dc:	6105                	addi	sp,sp,32
 1de:	8082                	ret
    return -1;
 1e0:	597d                	li	s2,-1
 1e2:	bfc5                	j	1d2 <stat+0x28>

00000000000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ea:	00054603          	lbu	a2,0(a0)
 1ee:	fd06079b          	addiw	a5,a2,-48
 1f2:	0ff7f793          	andi	a5,a5,255
 1f6:	4725                	li	a4,9
 1f8:	02f76963          	bltu	a4,a5,22a <atoi+0x46>
 1fc:	86aa                	mv	a3,a0
  n = 0;
 1fe:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 200:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 202:	0685                	addi	a3,a3,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb1                	addw	a5,a5,a2
 210:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 214:	0006c603          	lbu	a2,0(a3)
 218:	fd06071b          	addiw	a4,a2,-48
 21c:	0ff77713          	andi	a4,a4,255
 220:	fee5f1e3          	bgeu	a1,a4,202 <atoi+0x1e>
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  n = 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <atoi+0x40>

000000000000022e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 234:	02b57463          	bgeu	a0,a1,25c <memmove+0x2e>
    while(n-- > 0)
 238:	00c05f63          	blez	a2,256 <memmove+0x28>
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 244:	872a                	mv	a4,a0
      *dst++ = *src++;
 246:	0585                	addi	a1,a1,1
 248:	0705                	addi	a4,a4,1
 24a:	fff5c683          	lbu	a3,-1(a1)
 24e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 262:	fec05ae3          	blez	a2,256 <memmove+0x28>
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x46>
 284:	bfc9                	j	256 <memmove+0x28>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28c:	ca05                	beqz	a2,2bc <memcmp+0x36>
 28e:	fff6069b          	addiw	a3,a2,-1
 292:	1682                	slli	a3,a3,0x20
 294:	9281                	srli	a3,a3,0x20
 296:	0685                	addi	a3,a3,1
 298:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29a:	00054783          	lbu	a5,0(a0)
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00e79863          	bne	a5,a4,2b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a6:	0505                	addi	a0,a0,1
    p2++;
 2a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2aa:	fed518e3          	bne	a0,a3,29a <memcmp+0x14>
  }
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	a019                	j	2b6 <memcmp+0x30>
      return *p1 - *p2;
 2b2:	40e7853b          	subw	a0,a5,a4
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  return 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <memcmp+0x30>

00000000000002c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c8:	f67ff0ef          	jal	ra,22e <memmove>
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d4:	4885                	li	a7,1
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2dc:	4889                	li	a7,2
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e4:	488d                	li	a7,3
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ec:	4891                	li	a7,4
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <read>:
.global read
read:
 li a7, SYS_read
 2f4:	4895                	li	a7,5
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <write>:
.global write
write:
 li a7, SYS_write
 2fc:	48c1                	li	a7,16
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <close>:
.global close
close:
 li a7, SYS_close
 304:	48d5                	li	a7,21
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <kill>:
.global kill
kill:
 li a7, SYS_kill
 30c:	4899                	li	a7,6
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exec>:
.global exec
exec:
 li a7, SYS_exec
 314:	489d                	li	a7,7
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <open>:
.global open
open:
 li a7, SYS_open
 31c:	48bd                	li	a7,15
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 324:	48c5                	li	a7,17
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32c:	48c9                	li	a7,18
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 334:	48a1                	li	a7,8
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <link>:
.global link
link:
 li a7, SYS_link
 33c:	48cd                	li	a7,19
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 344:	48d1                	li	a7,20
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34c:	48a5                	li	a7,9
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <dup>:
.global dup
dup:
 li a7, SYS_dup
 354:	48a9                	li	a7,10
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35c:	48ad                	li	a7,11
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 364:	48b1                	li	a7,12
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 36c:	48b5                	li	a7,13
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 374:	48b9                	li	a7,14
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 37c:	48d9                	li	a7,22
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 384:	48dd                	li	a7,23
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 38c:	48e1                	li	a7,24
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 394:	48e5                	li	a7,25
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	1000                	addi	s0,sp,32
 3a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a8:	4605                	li	a2,1
 3aa:	fef40593          	addi	a1,s0,-17
 3ae:	f4fff0ef          	jal	ra,2fc <write>
}
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	6105                	addi	sp,sp,32
 3b8:	8082                	ret

00000000000003ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ba:	7139                	addi	sp,sp,-64
 3bc:	fc06                	sd	ra,56(sp)
 3be:	f822                	sd	s0,48(sp)
 3c0:	f426                	sd	s1,40(sp)
 3c2:	f04a                	sd	s2,32(sp)
 3c4:	ec4e                	sd	s3,24(sp)
 3c6:	0080                	addi	s0,sp,64
 3c8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ca:	c299                	beqz	a3,3d0 <printint+0x16>
 3cc:	0805c663          	bltz	a1,458 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d0:	2581                	sext.w	a1,a1
  neg = 0;
 3d2:	4881                	li	a7,0
 3d4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3da:	2601                	sext.w	a2,a2
 3dc:	00000517          	auipc	a0,0x0
 3e0:	50450513          	addi	a0,a0,1284 # 8e0 <digits>
 3e4:	883a                	mv	a6,a4
 3e6:	2705                	addiw	a4,a4,1
 3e8:	02c5f7bb          	remuw	a5,a1,a2
 3ec:	1782                	slli	a5,a5,0x20
 3ee:	9381                	srli	a5,a5,0x20
 3f0:	97aa                	add	a5,a5,a0
 3f2:	0007c783          	lbu	a5,0(a5)
 3f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fa:	0005879b          	sext.w	a5,a1
 3fe:	02c5d5bb          	divuw	a1,a1,a2
 402:	0685                	addi	a3,a3,1
 404:	fec7f0e3          	bgeu	a5,a2,3e4 <printint+0x2a>
  if(neg)
 408:	00088b63          	beqz	a7,41e <printint+0x64>
    buf[i++] = '-';
 40c:	fd040793          	addi	a5,s0,-48
 410:	973e                	add	a4,a4,a5
 412:	02d00793          	li	a5,45
 416:	fef70823          	sb	a5,-16(a4)
 41a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41e:	02e05663          	blez	a4,44a <printint+0x90>
 422:	fc040793          	addi	a5,s0,-64
 426:	00e78933          	add	s2,a5,a4
 42a:	fff78993          	addi	s3,a5,-1
 42e:	99ba                	add	s3,s3,a4
 430:	377d                	addiw	a4,a4,-1
 432:	1702                	slli	a4,a4,0x20
 434:	9301                	srli	a4,a4,0x20
 436:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43a:	fff94583          	lbu	a1,-1(s2)
 43e:	8526                	mv	a0,s1
 440:	f5dff0ef          	jal	ra,39c <putc>
  while(--i >= 0)
 444:	197d                	addi	s2,s2,-1
 446:	ff391ae3          	bne	s2,s3,43a <printint+0x80>
}
 44a:	70e2                	ld	ra,56(sp)
 44c:	7442                	ld	s0,48(sp)
 44e:	74a2                	ld	s1,40(sp)
 450:	7902                	ld	s2,32(sp)
 452:	69e2                	ld	s3,24(sp)
 454:	6121                	addi	sp,sp,64
 456:	8082                	ret
    x = -xx;
 458:	40b005bb          	negw	a1,a1
    neg = 1;
 45c:	4885                	li	a7,1
    x = -xx;
 45e:	bf9d                	j	3d4 <printint+0x1a>

0000000000000460 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 460:	7119                	addi	sp,sp,-128
 462:	fc86                	sd	ra,120(sp)
 464:	f8a2                	sd	s0,112(sp)
 466:	f4a6                	sd	s1,104(sp)
 468:	f0ca                	sd	s2,96(sp)
 46a:	ecce                	sd	s3,88(sp)
 46c:	e8d2                	sd	s4,80(sp)
 46e:	e4d6                	sd	s5,72(sp)
 470:	e0da                	sd	s6,64(sp)
 472:	fc5e                	sd	s7,56(sp)
 474:	f862                	sd	s8,48(sp)
 476:	f466                	sd	s9,40(sp)
 478:	f06a                	sd	s10,32(sp)
 47a:	ec6e                	sd	s11,24(sp)
 47c:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c903          	lbu	s2,0(a1)
 482:	22090e63          	beqz	s2,6be <vprintf+0x25e>
 486:	8b2a                	mv	s6,a0
 488:	8a2e                	mv	s4,a1
 48a:	8bb2                	mv	s7,a2
  state = 0;
 48c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 48e:	4481                	li	s1,0
 490:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 492:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 496:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 49a:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 49e:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a2:	00000c97          	auipc	s9,0x0
 4a6:	43ec8c93          	addi	s9,s9,1086 # 8e0 <digits>
 4aa:	a005                	j	4ca <vprintf+0x6a>
        putc(fd, c0);
 4ac:	85ca                	mv	a1,s2
 4ae:	855a                	mv	a0,s6
 4b0:	eedff0ef          	jal	ra,39c <putc>
 4b4:	a019                	j	4ba <vprintf+0x5a>
    } else if(state == '%'){
 4b6:	03598263          	beq	s3,s5,4da <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ba:	2485                	addiw	s1,s1,1
 4bc:	8726                	mv	a4,s1
 4be:	009a07b3          	add	a5,s4,s1
 4c2:	0007c903          	lbu	s2,0(a5)
 4c6:	1e090c63          	beqz	s2,6be <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 4ca:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4ce:	fe0994e3          	bnez	s3,4b6 <vprintf+0x56>
      if(c0 == '%'){
 4d2:	fd579de3          	bne	a5,s5,4ac <vprintf+0x4c>
        state = '%';
 4d6:	89be                	mv	s3,a5
 4d8:	b7cd                	j	4ba <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4da:	cfa5                	beqz	a5,552 <vprintf+0xf2>
 4dc:	00ea06b3          	add	a3,s4,a4
 4e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4e4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4e6:	c681                	beqz	a3,4ee <vprintf+0x8e>
 4e8:	9752                	add	a4,a4,s4
 4ea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ee:	03878a63          	beq	a5,s8,522 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4f2:	05a78463          	beq	a5,s10,53a <vprintf+0xda>
      } else if(c0 == 'u'){
 4f6:	0db78763          	beq	a5,s11,5c4 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4fa:	07800713          	li	a4,120
 4fe:	10e78963          	beq	a5,a4,610 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 502:	07000713          	li	a4,112
 506:	12e78e63          	beq	a5,a4,642 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 50a:	07300713          	li	a4,115
 50e:	16e78b63          	beq	a5,a4,684 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 512:	05579063          	bne	a5,s5,552 <vprintf+0xf2>
        putc(fd, '%');
 516:	85d6                	mv	a1,s5
 518:	855a                	mv	a0,s6
 51a:	e83ff0ef          	jal	ra,39c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 51e:	4981                	li	s3,0
 520:	bf69                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 522:	008b8913          	addi	s2,s7,8
 526:	4685                	li	a3,1
 528:	4629                	li	a2,10
 52a:	000ba583          	lw	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	e8bff0ef          	jal	ra,3ba <printint>
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
 538:	b749                	j	4ba <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	03868663          	beq	a3,s8,566 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53e:	05a68163          	beq	a3,s10,580 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 542:	09b68d63          	beq	a3,s11,5dc <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 546:	03a68f63          	beq	a3,s10,584 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 54a:	07800793          	li	a5,120
 54e:	0cf68d63          	beq	a3,a5,628 <vprintf+0x1c8>
        putc(fd, '%');
 552:	85d6                	mv	a1,s5
 554:	855a                	mv	a0,s6
 556:	e47ff0ef          	jal	ra,39c <putc>
        putc(fd, c0);
 55a:	85ca                	mv	a1,s2
 55c:	855a                	mv	a0,s6
 55e:	e3fff0ef          	jal	ra,39c <putc>
      state = 0;
 562:	4981                	li	s3,0
 564:	bf99                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	008b8913          	addi	s2,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e47ff0ef          	jal	ra,3ba <printint>
        i += 1;
 578:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
        i += 1;
 57e:	bf35                	j	4ba <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 580:	03860563          	beq	a2,s8,5aa <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 584:	07b60963          	beq	a2,s11,5f6 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 588:	07800793          	li	a5,120
 58c:	fcf613e3          	bne	a2,a5,552 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e1dff0ef          	jal	ra,3ba <printint>
        i += 2;
 5a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	bf09                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e03ff0ef          	jal	ra,3ba <printint>
        i += 2;
 5bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bde5                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	de9ff0ef          	jal	ra,3ba <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b5c5                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	dd1ff0ef          	jal	ra,3ba <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b5d9                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	db7ff0ef          	jal	ra,3ba <printint>
        i += 2;
 608:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	b575                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	d9dff0ef          	jal	ra,3ba <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bd51                	j	4ba <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d85ff0ef          	jal	ra,3ba <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	bdad                	j	4ba <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 642:	008b8793          	addi	a5,s7,8
 646:	f8f43423          	sd	a5,-120(s0)
 64a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64e:	03000593          	li	a1,48
 652:	855a                	mv	a0,s6
 654:	d49ff0ef          	jal	ra,39c <putc>
  putc(fd, 'x');
 658:	07800593          	li	a1,120
 65c:	855a                	mv	a0,s6
 65e:	d3fff0ef          	jal	ra,39c <putc>
 662:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 664:	03c9d793          	srli	a5,s3,0x3c
 668:	97e6                	add	a5,a5,s9
 66a:	0007c583          	lbu	a1,0(a5)
 66e:	855a                	mv	a0,s6
 670:	d2dff0ef          	jal	ra,39c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 674:	0992                	slli	s3,s3,0x4
 676:	397d                	addiw	s2,s2,-1
 678:	fe0916e3          	bnez	s2,664 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 67c:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 680:	4981                	li	s3,0
 682:	bd25                	j	4ba <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 684:	008b8993          	addi	s3,s7,8
 688:	000bb903          	ld	s2,0(s7)
 68c:	00090f63          	beqz	s2,6aa <vprintf+0x24a>
        for(; *s; s++)
 690:	00094583          	lbu	a1,0(s2)
 694:	c195                	beqz	a1,6b8 <vprintf+0x258>
          putc(fd, *s);
 696:	855a                	mv	a0,s6
 698:	d05ff0ef          	jal	ra,39c <putc>
        for(; *s; s++)
 69c:	0905                	addi	s2,s2,1
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	f9f5                	bnez	a1,696 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6a4:	8bce                	mv	s7,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd09                	j	4ba <vprintf+0x5a>
          s = "(null)";
 6aa:	00000917          	auipc	s2,0x0
 6ae:	22e90913          	addi	s2,s2,558 # 8d8 <malloc+0x118>
        for(; *s; s++)
 6b2:	02800593          	li	a1,40
 6b6:	b7c5                	j	696 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	8bce                	mv	s7,s3
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bbfd                	j	4ba <vprintf+0x5a>
    }
  }
}
 6be:	70e6                	ld	ra,120(sp)
 6c0:	7446                	ld	s0,112(sp)
 6c2:	74a6                	ld	s1,104(sp)
 6c4:	7906                	ld	s2,96(sp)
 6c6:	69e6                	ld	s3,88(sp)
 6c8:	6a46                	ld	s4,80(sp)
 6ca:	6aa6                	ld	s5,72(sp)
 6cc:	6b06                	ld	s6,64(sp)
 6ce:	7be2                	ld	s7,56(sp)
 6d0:	7c42                	ld	s8,48(sp)
 6d2:	7ca2                	ld	s9,40(sp)
 6d4:	7d02                	ld	s10,32(sp)
 6d6:	6de2                	ld	s11,24(sp)
 6d8:	6109                	addi	sp,sp,128
 6da:	8082                	ret

00000000000006dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6dc:	715d                	addi	sp,sp,-80
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e010                	sd	a2,0(s0)
 6e6:	e414                	sd	a3,8(s0)
 6e8:	e818                	sd	a4,16(s0)
 6ea:	ec1c                	sd	a5,24(s0)
 6ec:	03043023          	sd	a6,32(s0)
 6f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f8:	8622                	mv	a2,s0
 6fa:	d67ff0ef          	jal	ra,460 <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6161                	addi	sp,sp,80
 704:	8082                	ret

0000000000000706 <printf>:

void
printf(const char *fmt, ...)
{
 706:	711d                	addi	sp,sp,-96
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e40c                	sd	a1,8(s0)
 710:	e810                	sd	a2,16(s0)
 712:	ec14                	sd	a3,24(s0)
 714:	f018                	sd	a4,32(s0)
 716:	f41c                	sd	a5,40(s0)
 718:	03043823          	sd	a6,48(s0)
 71c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	00840613          	addi	a2,s0,8
 724:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 728:	85aa                	mv	a1,a0
 72a:	4505                	li	a0,1
 72c:	d35ff0ef          	jal	ra,460 <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6125                	addi	sp,sp,96
 736:	8082                	ret

0000000000000738 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 738:	1141                	addi	sp,sp,-16
 73a:	e422                	sd	s0,8(sp)
 73c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	00001797          	auipc	a5,0x1
 746:	8be7b783          	ld	a5,-1858(a5) # 1000 <freep>
 74a:	a805                	j	77a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74c:	4618                	lw	a4,8(a2)
 74e:	9db9                	addw	a1,a1,a4
 750:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	6318                	ld	a4,0(a4)
 758:	fee53823          	sd	a4,-16(a0)
 75c:	a091                	j	7a0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75e:	ff852703          	lw	a4,-8(a0)
 762:	9e39                	addw	a2,a2,a4
 764:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 766:	ff053703          	ld	a4,-16(a0)
 76a:	e398                	sd	a4,0(a5)
 76c:	a099                	j	7b2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	6398                	ld	a4,0(a5)
 770:	00e7e463          	bltu	a5,a4,778 <free+0x40>
 774:	00e6ea63          	bltu	a3,a4,788 <free+0x50>
{
 778:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	fed7fae3          	bgeu	a5,a3,76e <free+0x36>
 77e:	6398                	ld	a4,0(a5)
 780:	00e6e463          	bltu	a3,a4,788 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	fee7eae3          	bltu	a5,a4,778 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 788:	ff852583          	lw	a1,-8(a0)
 78c:	6390                	ld	a2,0(a5)
 78e:	02059713          	slli	a4,a1,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	0712                	slli	a4,a4,0x4
 796:	9736                	add	a4,a4,a3
 798:	fae60ae3          	beq	a2,a4,74c <free+0x14>
    bp->s.ptr = p->s.ptr;
 79c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a0:	4790                	lw	a2,8(a5)
 7a2:	02061713          	slli	a4,a2,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	0712                	slli	a4,a4,0x4
 7aa:	973e                	add	a4,a4,a5
 7ac:	fae689e3          	beq	a3,a4,75e <free+0x26>
  } else
    p->s.ptr = bp;
 7b0:	e394                	sd	a3,0(a5)
  freep = p;
 7b2:	00001717          	auipc	a4,0x1
 7b6:	84f73723          	sd	a5,-1970(a4) # 1000 <freep>
}
 7ba:	6422                	ld	s0,8(sp)
 7bc:	0141                	addi	sp,sp,16
 7be:	8082                	ret

00000000000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	7139                	addi	sp,sp,-64
 7c2:	fc06                	sd	ra,56(sp)
 7c4:	f822                	sd	s0,48(sp)
 7c6:	f426                	sd	s1,40(sp)
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	ec4e                	sd	s3,24(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051493          	slli	s1,a0,0x20
 7d8:	9081                	srli	s1,s1,0x20
 7da:	04bd                	addi	s1,s1,15
 7dc:	8091                	srli	s1,s1,0x4
 7de:	0014899b          	addiw	s3,s1,1
 7e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e4:	00001517          	auipc	a0,0x1
 7e8:	81c53503          	ld	a0,-2020(a0) # 1000 <freep>
 7ec:	c515                	beqz	a0,818 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f0:	4798                	lw	a4,8(a5)
 7f2:	02977f63          	bgeu	a4,s1,830 <malloc+0x70>
 7f6:	8a4e                	mv	s4,s3
 7f8:	0009871b          	sext.w	a4,s3
 7fc:	6685                	lui	a3,0x1
 7fe:	00d77363          	bgeu	a4,a3,804 <malloc+0x44>
 802:	6a05                	lui	s4,0x1
 804:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 808:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 80c:	00000917          	auipc	s2,0x0
 810:	7f490913          	addi	s2,s2,2036 # 1000 <freep>
  if(p == (char*)-1)
 814:	5afd                	li	s5,-1
 816:	a0bd                	j	884 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 818:	00000797          	auipc	a5,0x0
 81c:	7f878793          	addi	a5,a5,2040 # 1010 <base>
 820:	00000717          	auipc	a4,0x0
 824:	7ef73023          	sd	a5,2016(a4) # 1000 <freep>
 828:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82e:	b7e1                	j	7f6 <malloc+0x36>
      if(p->s.size == nunits)
 830:	02e48b63          	beq	s1,a4,866 <malloc+0xa6>
        p->s.size -= nunits;
 834:	4137073b          	subw	a4,a4,s3
 838:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83a:	1702                	slli	a4,a4,0x20
 83c:	9301                	srli	a4,a4,0x20
 83e:	0712                	slli	a4,a4,0x4
 840:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 842:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 846:	00000717          	auipc	a4,0x0
 84a:	7aa73d23          	sd	a0,1978(a4) # 1000 <freep>
      return (void*)(p + 1);
 84e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 852:	70e2                	ld	ra,56(sp)
 854:	7442                	ld	s0,48(sp)
 856:	74a2                	ld	s1,40(sp)
 858:	7902                	ld	s2,32(sp)
 85a:	69e2                	ld	s3,24(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
 862:	6121                	addi	sp,sp,64
 864:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	e118                	sd	a4,0(a0)
 86a:	bff1                	j	846 <malloc+0x86>
  hp->s.size = nu;
 86c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 870:	0541                	addi	a0,a0,16
 872:	ec7ff0ef          	jal	ra,738 <free>
  return freep;
 876:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87a:	dd61                	beqz	a0,852 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	fa9778e3          	bgeu	a4,s1,830 <malloc+0x70>
    if(p == freep)
 884:	00093703          	ld	a4,0(s2)
 888:	853e                	mv	a0,a5
 88a:	fef719e3          	bne	a4,a5,87c <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	ad5ff0ef          	jal	ra,364 <sbrk>
  if(p == (char*)-1)
 894:	fd551ce3          	bne	a0,s5,86c <malloc+0xac>
        return 0;
 898:	4501                	li	a0,0
 89a:	bf65                	j	852 <malloc+0x92>
