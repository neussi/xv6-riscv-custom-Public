
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8e250513          	addi	a0,a0,-1822 # 8f0 <malloc+0xe4>
  16:	352000ef          	jal	ra,368 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	380000ef          	jal	ra,3a0 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	37a000ef          	jal	ra,3a0 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8ce90913          	addi	s2,s2,-1842 # 8f8 <malloc+0xec>
  32:	854a                	mv	a0,s2
  34:	71e000ef          	jal	ra,752 <printf>
    pid = fork();
  38:	2e8000ef          	jal	ra,320 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	2ea000ef          	jal	ra,330 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	8f650513          	addi	a0,a0,-1802 # 948 <malloc+0x13c>
  5a:	6f8000ef          	jal	ra,752 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2c8000ef          	jal	ra,328 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	88850513          	addi	a0,a0,-1912 # 8f0 <malloc+0xe4>
  70:	300000ef          	jal	ra,370 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	87a50513          	addi	a0,a0,-1926 # 8f0 <malloc+0xe4>
  7e:	2ea000ef          	jal	ra,368 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	88c50513          	addi	a0,a0,-1908 # 910 <malloc+0x104>
  8c:	6c6000ef          	jal	ra,752 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	296000ef          	jal	ra,328 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	88a50513          	addi	a0,a0,-1910 # 928 <malloc+0x11c>
  a6:	2ba000ef          	jal	ra,360 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	88650513          	addi	a0,a0,-1914 # 930 <malloc+0x124>
  b2:	6a0000ef          	jal	ra,752 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	270000ef          	jal	ra,328 <exit>

00000000000000bc <start>:
//


void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	ra,0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	25e000ef          	jal	ra,328 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0x8>
    ;
  return os;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cb91                	beqz	a5,108 <strcmp+0x1e>
  f6:	0005c703          	lbu	a4,0(a1)
  fa:	00f71763          	bne	a4,a5,108 <strcmp+0x1e>
    p++, q++;
  fe:	0505                	addi	a0,a0,1
 100:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	fbe5                	bnez	a5,f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 108:	0005c503          	lbu	a0,0(a1)
}
 10c:	40a7853b          	subw	a0,a5,a0
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strlen>:

uint
strlen(const char *s)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cf91                	beqz	a5,13c <strlen+0x26>
 122:	0505                	addi	a0,a0,1
 124:	87aa                	mv	a5,a0
 126:	4685                	li	a3,1
 128:	9e89                	subw	a3,a3,a0
 12a:	00f6853b          	addw	a0,a3,a5
 12e:	0785                	addi	a5,a5,1
 130:	fff7c703          	lbu	a4,-1(a5)
 134:	fb7d                	bnez	a4,12a <strlen+0x14>
    ;
  return n;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  for(n = 0; s[n]; n++)
 13c:	4501                	li	a0,0
 13e:	bfe5                	j	136 <strlen+0x20>

0000000000000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 146:	ca19                	beqz	a2,15c <memset+0x1c>
 148:	87aa                	mv	a5,a0
 14a:	1602                	slli	a2,a2,0x20
 14c:	9201                	srli	a2,a2,0x20
 14e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 156:	0785                	addi	a5,a5,1
 158:	fee79de3          	bne	a5,a4,152 <memset+0x12>
  }
  return dst;
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strchr>:

char*
strchr(const char *s, char c)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  for(; *s; s++)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb99                	beqz	a5,182 <strchr+0x20>
    if(*s == c)
 16e:	00f58763          	beq	a1,a5,17c <strchr+0x1a>
  for(; *s; s++)
 172:	0505                	addi	a0,a0,1
 174:	00054783          	lbu	a5,0(a0)
 178:	fbfd                	bnez	a5,16e <strchr+0xc>
      return (char*)s;
  return 0;
 17a:	4501                	li	a0,0
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  return 0;
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strchr+0x1a>

0000000000000186 <gets>:

char*
gets(char *buf, int max)
{
 186:	711d                	addi	sp,sp,-96
 188:	ec86                	sd	ra,88(sp)
 18a:	e8a2                	sd	s0,80(sp)
 18c:	e4a6                	sd	s1,72(sp)
 18e:	e0ca                	sd	s2,64(sp)
 190:	fc4e                	sd	s3,56(sp)
 192:	f852                	sd	s4,48(sp)
 194:	f456                	sd	s5,40(sp)
 196:	f05a                	sd	s6,32(sp)
 198:	ec5e                	sd	s7,24(sp)
 19a:	1080                	addi	s0,sp,96
 19c:	8baa                	mv	s7,a0
 19e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	892a                	mv	s2,a0
 1a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a4:	4aa9                	li	s5,10
 1a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a8:	89a6                	mv	s3,s1
 1aa:	2485                	addiw	s1,s1,1
 1ac:	0344d663          	bge	s1,s4,1d8 <gets+0x52>
    cc = read(0, &c, 1);
 1b0:	4605                	li	a2,1
 1b2:	faf40593          	addi	a1,s0,-81
 1b6:	4501                	li	a0,0
 1b8:	188000ef          	jal	ra,340 <read>
    if(cc < 1)
 1bc:	00a05e63          	blez	a0,1d8 <gets+0x52>
    buf[i++] = c;
 1c0:	faf44783          	lbu	a5,-81(s0)
 1c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c8:	01578763          	beq	a5,s5,1d6 <gets+0x50>
 1cc:	0905                	addi	s2,s2,1
 1ce:	fd679de3          	bne	a5,s6,1a8 <gets+0x22>
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	a011                	j	1d8 <gets+0x52>
 1d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d8:	99de                	add	s3,s3,s7
 1da:	00098023          	sb	zero,0(s3)
  return buf;
}
 1de:	855e                	mv	a0,s7
 1e0:	60e6                	ld	ra,88(sp)
 1e2:	6446                	ld	s0,80(sp)
 1e4:	64a6                	ld	s1,72(sp)
 1e6:	6906                	ld	s2,64(sp)
 1e8:	79e2                	ld	s3,56(sp)
 1ea:	7a42                	ld	s4,48(sp)
 1ec:	7aa2                	ld	s5,40(sp)
 1ee:	7b02                	ld	s6,32(sp)
 1f0:	6be2                	ld	s7,24(sp)
 1f2:	6125                	addi	sp,sp,96
 1f4:	8082                	ret

00000000000001f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f6:	1101                	addi	sp,sp,-32
 1f8:	ec06                	sd	ra,24(sp)
 1fa:	e822                	sd	s0,16(sp)
 1fc:	e426                	sd	s1,8(sp)
 1fe:	e04a                	sd	s2,0(sp)
 200:	1000                	addi	s0,sp,32
 202:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 204:	4581                	li	a1,0
 206:	162000ef          	jal	ra,368 <open>
  if(fd < 0)
 20a:	02054163          	bltz	a0,22c <stat+0x36>
 20e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 210:	85ca                	mv	a1,s2
 212:	16e000ef          	jal	ra,380 <fstat>
 216:	892a                	mv	s2,a0
  close(fd);
 218:	8526                	mv	a0,s1
 21a:	136000ef          	jal	ra,350 <close>
  return r;
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	64a2                	ld	s1,8(sp)
 226:	6902                	ld	s2,0(sp)
 228:	6105                	addi	sp,sp,32
 22a:	8082                	ret
    return -1;
 22c:	597d                	li	s2,-1
 22e:	bfc5                	j	21e <stat+0x28>

0000000000000230 <atoi>:

int
atoi(const char *s)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054603          	lbu	a2,0(a0)
 23a:	fd06079b          	addiw	a5,a2,-48
 23e:	0ff7f793          	andi	a5,a5,255
 242:	4725                	li	a4,9
 244:	02f76963          	bltu	a4,a5,276 <atoi+0x46>
 248:	86aa                	mv	a3,a0
  n = 0;
 24a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 24c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 24e:	0685                	addi	a3,a3,1
 250:	0025179b          	slliw	a5,a0,0x2
 254:	9fa9                	addw	a5,a5,a0
 256:	0017979b          	slliw	a5,a5,0x1
 25a:	9fb1                	addw	a5,a5,a2
 25c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 260:	0006c603          	lbu	a2,0(a3)
 264:	fd06071b          	addiw	a4,a2,-48
 268:	0ff77713          	andi	a4,a4,255
 26c:	fee5f1e3          	bgeu	a1,a4,24e <atoi+0x1e>
  return n;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  n = 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <atoi+0x40>

000000000000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 280:	02b57463          	bgeu	a0,a1,2a8 <memmove+0x2e>
    while(n-- > 0)
 284:	00c05f63          	blez	a2,2a2 <memmove+0x28>
 288:	1602                	slli	a2,a2,0x20
 28a:	9201                	srli	a2,a2,0x20
 28c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 290:	872a                	mv	a4,a0
      *dst++ = *src++;
 292:	0585                	addi	a1,a1,1
 294:	0705                	addi	a4,a4,1
 296:	fff5c683          	lbu	a3,-1(a1)
 29a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ae:	fec05ae3          	blez	a2,2a2 <memmove+0x28>
 2b2:	fff6079b          	addiw	a5,a2,-1
 2b6:	1782                	slli	a5,a5,0x20
 2b8:	9381                	srli	a5,a5,0x20
 2ba:	fff7c793          	not	a5,a5
 2be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c0:	15fd                	addi	a1,a1,-1
 2c2:	177d                	addi	a4,a4,-1
 2c4:	0005c683          	lbu	a3,0(a1)
 2c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x46>
 2d0:	bfc9                	j	2a2 <memmove+0x28>

00000000000002d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d8:	ca05                	beqz	a2,308 <memcmp+0x36>
 2da:	fff6069b          	addiw	a3,a2,-1
 2de:	1682                	slli	a3,a3,0x20
 2e0:	9281                	srli	a3,a3,0x20
 2e2:	0685                	addi	a3,a3,1
 2e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00e79863          	bne	a5,a4,2fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f2:	0505                	addi	a0,a0,1
    p2++;
 2f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f6:	fed518e3          	bne	a0,a3,2e6 <memcmp+0x14>
  }
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	a019                	j	302 <memcmp+0x30>
      return *p1 - *p2;
 2fe:	40e7853b          	subw	a0,a5,a4
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <memcmp+0x30>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 314:	f67ff0ef          	jal	ra,27a <memmove>
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 320:	4885                	li	a7,1
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exit>:
.global exit
exit:
 li a7, SYS_exit
 328:	4889                	li	a7,2
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <wait>:
.global wait
wait:
 li a7, SYS_wait
 330:	488d                	li	a7,3
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 338:	4891                	li	a7,4
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <read>:
.global read
read:
 li a7, SYS_read
 340:	4895                	li	a7,5
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <write>:
.global write
write:
 li a7, SYS_write
 348:	48c1                	li	a7,16
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <close>:
.global close
close:
 li a7, SYS_close
 350:	48d5                	li	a7,21
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <kill>:
.global kill
kill:
 li a7, SYS_kill
 358:	4899                	li	a7,6
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exec>:
.global exec
exec:
 li a7, SYS_exec
 360:	489d                	li	a7,7
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <open>:
.global open
open:
 li a7, SYS_open
 368:	48bd                	li	a7,15
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 370:	48c5                	li	a7,17
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 378:	48c9                	li	a7,18
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 380:	48a1                	li	a7,8
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <link>:
.global link
link:
 li a7, SYS_link
 388:	48cd                	li	a7,19
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 390:	48d1                	li	a7,20
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 398:	48a5                	li	a7,9
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a0:	48a9                	li	a7,10
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a8:	48ad                	li	a7,11
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b0:	48b1                	li	a7,12
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b8:	48b5                	li	a7,13
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c0:	48b9                	li	a7,14
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 3c8:	48d9                	li	a7,22
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3d0:	48dd                	li	a7,23
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 3d8:	48e1                	li	a7,24
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 3e0:	48e5                	li	a7,25
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	fef40593          	addi	a1,s0,-17
 3fa:	f4fff0ef          	jal	ra,348 <write>
}
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 406:	7139                	addi	sp,sp,-64
 408:	fc06                	sd	ra,56(sp)
 40a:	f822                	sd	s0,48(sp)
 40c:	f426                	sd	s1,40(sp)
 40e:	f04a                	sd	s2,32(sp)
 410:	ec4e                	sd	s3,24(sp)
 412:	0080                	addi	s0,sp,64
 414:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 416:	c299                	beqz	a3,41c <printint+0x16>
 418:	0805c663          	bltz	a1,4a4 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41c:	2581                	sext.w	a1,a1
  neg = 0;
 41e:	4881                	li	a7,0
 420:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 424:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 426:	2601                	sext.w	a2,a2
 428:	00000517          	auipc	a0,0x0
 42c:	54850513          	addi	a0,a0,1352 # 970 <digits>
 430:	883a                	mv	a6,a4
 432:	2705                	addiw	a4,a4,1
 434:	02c5f7bb          	remuw	a5,a1,a2
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	97aa                	add	a5,a5,a0
 43e:	0007c783          	lbu	a5,0(a5)
 442:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 446:	0005879b          	sext.w	a5,a1
 44a:	02c5d5bb          	divuw	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec7f0e3          	bgeu	a5,a2,430 <printint+0x2a>
  if(neg)
 454:	00088b63          	beqz	a7,46a <printint+0x64>
    buf[i++] = '-';
 458:	fd040793          	addi	a5,s0,-48
 45c:	973e                	add	a4,a4,a5
 45e:	02d00793          	li	a5,45
 462:	fef70823          	sb	a5,-16(a4)
 466:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46a:	02e05663          	blez	a4,496 <printint+0x90>
 46e:	fc040793          	addi	a5,s0,-64
 472:	00e78933          	add	s2,a5,a4
 476:	fff78993          	addi	s3,a5,-1
 47a:	99ba                	add	s3,s3,a4
 47c:	377d                	addiw	a4,a4,-1
 47e:	1702                	slli	a4,a4,0x20
 480:	9301                	srli	a4,a4,0x20
 482:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 486:	fff94583          	lbu	a1,-1(s2)
 48a:	8526                	mv	a0,s1
 48c:	f5dff0ef          	jal	ra,3e8 <putc>
  while(--i >= 0)
 490:	197d                	addi	s2,s2,-1
 492:	ff391ae3          	bne	s2,s3,486 <printint+0x80>
}
 496:	70e2                	ld	ra,56(sp)
 498:	7442                	ld	s0,48(sp)
 49a:	74a2                	ld	s1,40(sp)
 49c:	7902                	ld	s2,32(sp)
 49e:	69e2                	ld	s3,24(sp)
 4a0:	6121                	addi	sp,sp,64
 4a2:	8082                	ret
    x = -xx;
 4a4:	40b005bb          	negw	a1,a1
    neg = 1;
 4a8:	4885                	li	a7,1
    x = -xx;
 4aa:	bf9d                	j	420 <printint+0x1a>

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	7119                	addi	sp,sp,-128
 4ae:	fc86                	sd	ra,120(sp)
 4b0:	f8a2                	sd	s0,112(sp)
 4b2:	f4a6                	sd	s1,104(sp)
 4b4:	f0ca                	sd	s2,96(sp)
 4b6:	ecce                	sd	s3,88(sp)
 4b8:	e8d2                	sd	s4,80(sp)
 4ba:	e4d6                	sd	s5,72(sp)
 4bc:	e0da                	sd	s6,64(sp)
 4be:	fc5e                	sd	s7,56(sp)
 4c0:	f862                	sd	s8,48(sp)
 4c2:	f466                	sd	s9,40(sp)
 4c4:	f06a                	sd	s10,32(sp)
 4c6:	ec6e                	sd	s11,24(sp)
 4c8:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c903          	lbu	s2,0(a1)
 4ce:	22090e63          	beqz	s2,70a <vprintf+0x25e>
 4d2:	8b2a                	mv	s6,a0
 4d4:	8a2e                	mv	s4,a1
 4d6:	8bb2                	mv	s7,a2
  state = 0;
 4d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4da:	4481                	li	s1,0
 4dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e6:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ea:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ee:	00000c97          	auipc	s9,0x0
 4f2:	482c8c93          	addi	s9,s9,1154 # 970 <digits>
 4f6:	a005                	j	516 <vprintf+0x6a>
        putc(fd, c0);
 4f8:	85ca                	mv	a1,s2
 4fa:	855a                	mv	a0,s6
 4fc:	eedff0ef          	jal	ra,3e8 <putc>
 500:	a019                	j	506 <vprintf+0x5a>
    } else if(state == '%'){
 502:	03598263          	beq	s3,s5,526 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 506:	2485                	addiw	s1,s1,1
 508:	8726                	mv	a4,s1
 50a:	009a07b3          	add	a5,s4,s1
 50e:	0007c903          	lbu	s2,0(a5)
 512:	1e090c63          	beqz	s2,70a <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 516:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51a:	fe0994e3          	bnez	s3,502 <vprintf+0x56>
      if(c0 == '%'){
 51e:	fd579de3          	bne	a5,s5,4f8 <vprintf+0x4c>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7cd                	j	506 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 526:	cfa5                	beqz	a5,59e <vprintf+0xf2>
 528:	00ea06b3          	add	a3,s4,a4
 52c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 530:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 532:	c681                	beqz	a3,53a <vprintf+0x8e>
 534:	9752                	add	a4,a4,s4
 536:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 53a:	03878a63          	beq	a5,s8,56e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 53e:	05a78463          	beq	a5,s10,586 <vprintf+0xda>
      } else if(c0 == 'u'){
 542:	0db78763          	beq	a5,s11,610 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 546:	07800713          	li	a4,120
 54a:	10e78963          	beq	a5,a4,65c <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 54e:	07000713          	li	a4,112
 552:	12e78e63          	beq	a5,a4,68e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 556:	07300713          	li	a4,115
 55a:	16e78b63          	beq	a5,a4,6d0 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55e:	05579063          	bne	a5,s5,59e <vprintf+0xf2>
        putc(fd, '%');
 562:	85d6                	mv	a1,s5
 564:	855a                	mv	a0,s6
 566:	e83ff0ef          	jal	ra,3e8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf69                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b8913          	addi	s2,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e8bff0ef          	jal	ra,406 <printint>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b749                	j	506 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 586:	03868663          	beq	a3,s8,5b2 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58a:	05a68163          	beq	a3,s10,5cc <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 58e:	09b68d63          	beq	a3,s11,628 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 592:	03a68f63          	beq	a3,s10,5d0 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 596:	07800793          	li	a5,120
 59a:	0cf68d63          	beq	a3,a5,674 <vprintf+0x1c8>
        putc(fd, '%');
 59e:	85d6                	mv	a1,s5
 5a0:	855a                	mv	a0,s6
 5a2:	e47ff0ef          	jal	ra,3e8 <putc>
        putc(fd, c0);
 5a6:	85ca                	mv	a1,s2
 5a8:	855a                	mv	a0,s6
 5aa:	e3fff0ef          	jal	ra,3e8 <putc>
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	bf99                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e47ff0ef          	jal	ra,406 <printint>
        i += 1;
 5c4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
        i += 1;
 5ca:	bf35                	j	506 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	03860563          	beq	a2,s8,5f6 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d0:	07b60963          	beq	a2,s11,642 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d4:	07800793          	li	a5,120
 5d8:	fcf613e3          	bne	a2,a5,59e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e1dff0ef          	jal	ra,406 <printint>
        i += 2;
 5ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	bf09                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e03ff0ef          	jal	ra,406 <printint>
        i += 2;
 608:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	bde5                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	de9ff0ef          	jal	ra,406 <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b5c5                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	dd1ff0ef          	jal	ra,406 <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	b5d9                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	db7ff0ef          	jal	ra,406 <printint>
        i += 2;
 654:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	b575                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d9dff0ef          	jal	ra,406 <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bd51                	j	506 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4641                	li	a2,16
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	d85ff0ef          	jal	ra,406 <printint>
        i += 1;
 686:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	bdad                	j	506 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 68e:	008b8793          	addi	a5,s7,8
 692:	f8f43423          	sd	a5,-120(s0)
 696:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69a:	03000593          	li	a1,48
 69e:	855a                	mv	a0,s6
 6a0:	d49ff0ef          	jal	ra,3e8 <putc>
  putc(fd, 'x');
 6a4:	07800593          	li	a1,120
 6a8:	855a                	mv	a0,s6
 6aa:	d3fff0ef          	jal	ra,3e8 <putc>
 6ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b0:	03c9d793          	srli	a5,s3,0x3c
 6b4:	97e6                	add	a5,a5,s9
 6b6:	0007c583          	lbu	a1,0(a5)
 6ba:	855a                	mv	a0,s6
 6bc:	d2dff0ef          	jal	ra,3e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c0:	0992                	slli	s3,s3,0x4
 6c2:	397d                	addiw	s2,s2,-1
 6c4:	fe0916e3          	bnez	s2,6b0 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6c8:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd25                	j	506 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	008b8993          	addi	s3,s7,8
 6d4:	000bb903          	ld	s2,0(s7)
 6d8:	00090f63          	beqz	s2,6f6 <vprintf+0x24a>
        for(; *s; s++)
 6dc:	00094583          	lbu	a1,0(s2)
 6e0:	c195                	beqz	a1,704 <vprintf+0x258>
          putc(fd, *s);
 6e2:	855a                	mv	a0,s6
 6e4:	d05ff0ef          	jal	ra,3e8 <putc>
        for(; *s; s++)
 6e8:	0905                	addi	s2,s2,1
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	f9f5                	bnez	a1,6e2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bd09                	j	506 <vprintf+0x5a>
          s = "(null)";
 6f6:	00000917          	auipc	s2,0x0
 6fa:	27290913          	addi	s2,s2,626 # 968 <malloc+0x15c>
        for(; *s; s++)
 6fe:	02800593          	li	a1,40
 702:	b7c5                	j	6e2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	bbfd                	j	506 <vprintf+0x5a>
    }
  }
}
 70a:	70e6                	ld	ra,120(sp)
 70c:	7446                	ld	s0,112(sp)
 70e:	74a6                	ld	s1,104(sp)
 710:	7906                	ld	s2,96(sp)
 712:	69e6                	ld	s3,88(sp)
 714:	6a46                	ld	s4,80(sp)
 716:	6aa6                	ld	s5,72(sp)
 718:	6b06                	ld	s6,64(sp)
 71a:	7be2                	ld	s7,56(sp)
 71c:	7c42                	ld	s8,48(sp)
 71e:	7ca2                	ld	s9,40(sp)
 720:	7d02                	ld	s10,32(sp)
 722:	6de2                	ld	s11,24(sp)
 724:	6109                	addi	sp,sp,128
 726:	8082                	ret

0000000000000728 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 728:	715d                	addi	sp,sp,-80
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	addi	s0,sp,32
 730:	e010                	sd	a2,0(s0)
 732:	e414                	sd	a3,8(s0)
 734:	e818                	sd	a4,16(s0)
 736:	ec1c                	sd	a5,24(s0)
 738:	03043023          	sd	a6,32(s0)
 73c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 744:	8622                	mv	a2,s0
 746:	d67ff0ef          	jal	ra,4ac <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6161                	addi	sp,sp,80
 750:	8082                	ret

0000000000000752 <printf>:

void
printf(const char *fmt, ...)
{
 752:	711d                	addi	sp,sp,-96
 754:	ec06                	sd	ra,24(sp)
 756:	e822                	sd	s0,16(sp)
 758:	1000                	addi	s0,sp,32
 75a:	e40c                	sd	a1,8(s0)
 75c:	e810                	sd	a2,16(s0)
 75e:	ec14                	sd	a3,24(s0)
 760:	f018                	sd	a4,32(s0)
 762:	f41c                	sd	a5,40(s0)
 764:	03043823          	sd	a6,48(s0)
 768:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	00840613          	addi	a2,s0,8
 770:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 774:	85aa                	mv	a1,a0
 776:	4505                	li	a0,1
 778:	d35ff0ef          	jal	ra,4ac <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 784:	1141                	addi	sp,sp,-16
 786:	e422                	sd	s0,8(sp)
 788:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	00001797          	auipc	a5,0x1
 792:	8827b783          	ld	a5,-1918(a5) # 1010 <freep>
 796:	a805                	j	7c6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 798:	4618                	lw	a4,8(a2)
 79a:	9db9                	addw	a1,a1,a4
 79c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	6318                	ld	a4,0(a4)
 7a4:	fee53823          	sd	a4,-16(a0)
 7a8:	a091                	j	7ec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9e39                	addw	a2,a2,a4
 7b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053703          	ld	a4,-16(a0)
 7b6:	e398                	sd	a4,0(a5)
 7b8:	a099                	j	7fe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x40>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x50>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x36>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059713          	slli	a4,a1,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60ae3          	beq	a2,a4,798 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061713          	slli	a4,a2,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	0712                	slli	a4,a4,0x4
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae689e3          	beq	a3,a4,7aa <free+0x26>
  } else
    p->s.ptr = bp;
 7fc:	e394                	sd	a3,0(a5)
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73923          	sd	a5,-2030(a4) # 1010 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051493          	slli	s1,a0,0x20
 824:	9081                	srli	s1,s1,0x20
 826:	04bd                	addi	s1,s1,15
 828:	8091                	srli	s1,s1,0x4
 82a:	0014899b          	addiw	s3,s1,1
 82e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 830:	00000517          	auipc	a0,0x0
 834:	7e053503          	ld	a0,2016(a0) # 1010 <freep>
 838:	c515                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	02977f63          	bgeu	a4,s1,87c <malloc+0x70>
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00000917          	auipc	s2,0x0
 85c:	7b890913          	addi	s2,s2,1976 # 1010 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a0bd                	j	8d0 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	7bc78793          	addi	a5,a5,1980 # 1020 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	7af73223          	sd	a5,1956(a4) # 1010 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7e1                	j	842 <malloc+0x36>
      if(p->s.size == nunits)
 87c:	02e48b63          	beq	s1,a4,8b2 <malloc+0xa6>
        p->s.size -= nunits;
 880:	4137073b          	subw	a4,a4,s3
 884:	c798                	sw	a4,8(a5)
        p += p->s.size;
 886:	1702                	slli	a4,a4,0x20
 888:	9301                	srli	a4,a4,0x20
 88a:	0712                	slli	a4,a4,0x4
 88c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 892:	00000717          	auipc	a4,0x0
 896:	76a73f23          	sd	a0,1918(a4) # 1010 <freep>
      return (void*)(p + 1);
 89a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	7902                	ld	s2,32(sp)
 8a6:	69e2                	ld	s3,24(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
 8ae:	6121                	addi	sp,sp,64
 8b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	e118                	sd	a4,0(a0)
 8b6:	bff1                	j	892 <malloc+0x86>
  hp->s.size = nu;
 8b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8bc:	0541                	addi	a0,a0,16
 8be:	ec7ff0ef          	jal	ra,784 <free>
  return freep;
 8c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c6:	dd61                	beqz	a0,89e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	fa9778e3          	bgeu	a4,s1,87c <malloc+0x70>
    if(p == freep)
 8d0:	00093703          	ld	a4,0(s2)
 8d4:	853e                	mv	a0,a5
 8d6:	fef719e3          	bne	a4,a5,8c8 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	ad5ff0ef          	jal	ra,3b0 <sbrk>
  if(p == (char*)-1)
 8e0:	fd551ce3          	bne	a0,s5,8b8 <malloc+0xac>
        return 0;
 8e4:	4501                	li	a0,0
 8e6:	bf65                	j	89e <malloc+0x92>
