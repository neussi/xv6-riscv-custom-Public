
user/_tail:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readlines>:
char content[MAXLINES][MAXLEN];
int nlines = 0;

void
readlines(int fd)
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	e8ca                	sd	s2,80(sp)
   a:	e4ce                	sd	s3,72(sp)
   c:	e0d2                	sd	s4,64(sp)
   e:	fc56                	sd	s5,56(sp)
  10:	f85a                	sd	s6,48(sp)
  12:	f45e                	sd	s7,40(sp)
  14:	f062                	sd	s8,32(sp)
  16:	ec66                	sd	s9,24(sp)
  18:	1880                	addi	s0,sp,112
  1a:	89aa                	mv	s3,a0
  char buf;
  int i = 0, j = 0;
  1c:	4481                	li	s1,0
  1e:	4901                	li	s2,0

  while(read(fd, &buf, 1) == 1) {
    if(buf == '\n') {
  20:	4a29                	li	s4,10
      content[i][j] = '\0';
      i++;
      if(i >= MAXLINES) break;
      j = 0;
    } else {
      if(j < MAXLEN-1)
  22:	06200b93          	li	s7,98
        content[i][j++] = buf;
  26:	00001b17          	auipc	s6,0x1
  2a:	feab0b13          	addi	s6,s6,-22 # 1010 <content>
  2e:	06400a93          	li	s5,100
      if(i >= MAXLINES) break;
  32:	3e700c13          	li	s8,999
      j = 0;
  36:	4c81                	li	s9,0
  while(read(fd, &buf, 1) == 1) {
  38:	a819                	j	4e <readlines+0x4e>
      content[i][j] = '\0';
  3a:	035907b3          	mul	a5,s2,s5
  3e:	97da                	add	a5,a5,s6
  40:	97a6                	add	a5,a5,s1
  42:	00078023          	sb	zero,0(a5)
      i++;
  46:	2905                	addiw	s2,s2,1
      if(i >= MAXLINES) break;
  48:	032c4a63          	blt	s8,s2,7c <readlines+0x7c>
      j = 0;
  4c:	84e6                	mv	s1,s9
  while(read(fd, &buf, 1) == 1) {
  4e:	4605                	li	a2,1
  50:	f9f40593          	addi	a1,s0,-97
  54:	854e                	mv	a0,s3
  56:	400000ef          	jal	ra,456 <read>
  5a:	4785                	li	a5,1
  5c:	02f51063          	bne	a0,a5,7c <readlines+0x7c>
    if(buf == '\n') {
  60:	f9f44783          	lbu	a5,-97(s0)
  64:	fd478be3          	beq	a5,s4,3a <readlines+0x3a>
      if(j < MAXLEN-1)
  68:	fe9bc3e3          	blt	s7,s1,4e <readlines+0x4e>
        content[i][j++] = buf;
  6c:	03590733          	mul	a4,s2,s5
  70:	975a                	add	a4,a4,s6
  72:	9726                	add	a4,a4,s1
  74:	00f70023          	sb	a5,0(a4)
  78:	2485                	addiw	s1,s1,1
  7a:	bfd1                	j	4e <readlines+0x4e>
    }
  }

  // Gérer la dernière ligne si elle n'a pas de \n
  if(j > 0) {
  7c:	00905f63          	blez	s1,9a <readlines+0x9a>
    content[i][j] = '\0';
  80:	06400793          	li	a5,100
  84:	02f90733          	mul	a4,s2,a5
  88:	00001797          	auipc	a5,0x1
  8c:	f8878793          	addi	a5,a5,-120 # 1010 <content>
  90:	97ba                	add	a5,a5,a4
  92:	94be                	add	s1,s1,a5
  94:	00048023          	sb	zero,0(s1)
    i++;
  98:	2905                	addiw	s2,s2,1
  }

  nlines = i;
  9a:	00001797          	auipc	a5,0x1
  9e:	f727a323          	sw	s2,-154(a5) # 1000 <nlines>
}
  a2:	70a6                	ld	ra,104(sp)
  a4:	7406                	ld	s0,96(sp)
  a6:	64e6                	ld	s1,88(sp)
  a8:	6946                	ld	s2,80(sp)
  aa:	69a6                	ld	s3,72(sp)
  ac:	6a06                	ld	s4,64(sp)
  ae:	7ae2                	ld	s5,56(sp)
  b0:	7b42                	ld	s6,48(sp)
  b2:	7ba2                	ld	s7,40(sp)
  b4:	7c02                	ld	s8,32(sp)
  b6:	6ce2                	ld	s9,24(sp)
  b8:	6165                	addi	sp,sp,112
  ba:	8082                	ret

00000000000000bc <printtail>:

void
printtail(int n)
{
  bc:	7179                	addi	sp,sp,-48
  be:	f406                	sd	ra,40(sp)
  c0:	f022                	sd	s0,32(sp)
  c2:	ec26                	sd	s1,24(sp)
  c4:	e84a                	sd	s2,16(sp)
  c6:	e44e                	sd	s3,8(sp)
  c8:	e052                	sd	s4,0(sp)
  ca:	1800                	addi	s0,sp,48
  int start;
  int i;

  if(n > nlines)
  cc:	00001797          	auipc	a5,0x1
  d0:	f347a783          	lw	a5,-204(a5) # 1000 <nlines>
    start = 0;
  d4:	4901                	li	s2,0
  if(n > nlines)
  d6:	00a7c463          	blt	a5,a0,de <printtail+0x22>
  else
    start = nlines - n;
  da:	40a7893b          	subw	s2,a5,a0

  for(i = start; i < nlines; i++)
  de:	02f95e63          	bge	s2,a5,11a <printtail+0x5e>
  e2:	06400493          	li	s1,100
  e6:	029904b3          	mul	s1,s2,s1
  ea:	00001797          	auipc	a5,0x1
  ee:	f2678793          	addi	a5,a5,-218 # 1010 <content>
  f2:	94be                	add	s1,s1,a5
    printf("%s\n", content[i]);
  f4:	00001a17          	auipc	s4,0x1
  f8:	90ca0a13          	addi	s4,s4,-1780 # a00 <malloc+0xe6>
  for(i = start; i < nlines; i++)
  fc:	00001997          	auipc	s3,0x1
 100:	f0498993          	addi	s3,s3,-252 # 1000 <nlines>
    printf("%s\n", content[i]);
 104:	85a6                	mv	a1,s1
 106:	8552                	mv	a0,s4
 108:	758000ef          	jal	ra,860 <printf>
  for(i = start; i < nlines; i++)
 10c:	2905                	addiw	s2,s2,1
 10e:	06448493          	addi	s1,s1,100
 112:	0009a783          	lw	a5,0(s3)
 116:	fef947e3          	blt	s2,a5,104 <printtail+0x48>
}
 11a:	70a2                	ld	ra,40(sp)
 11c:	7402                	ld	s0,32(sp)
 11e:	64e2                	ld	s1,24(sp)
 120:	6942                	ld	s2,16(sp)
 122:	69a2                	ld	s3,8(sp)
 124:	6a02                	ld	s4,0(sp)
 126:	6145                	addi	sp,sp,48
 128:	8082                	ret

000000000000012a <main>:

int
main(int argc, char *argv[])
{
 12a:	7179                	addi	sp,sp,-48
 12c:	f406                	sd	ra,40(sp)
 12e:	f022                	sd	s0,32(sp)
 130:	ec26                	sd	s1,24(sp)
 132:	e84a                	sd	s2,16(sp)
 134:	e44e                	sd	s3,8(sp)
 136:	1800                	addi	s0,sp,48
  int fd;
  int n = 10;  // Par défaut : 10 dernières lignes

  if(argc < 2) {
 138:	4785                	li	a5,1
 13a:	02a7de63          	bge	a5,a0,176 <main+0x4c>
 13e:	84aa                	mv	s1,a0
 140:	892e                	mv	s2,a1
    fprintf(2, "Usage: tail [-n] file\n");
    exit(1);
  }

  if(argv[1][0] == '-') {
 142:	6588                	ld	a0,8(a1)
 144:	00054703          	lbu	a4,0(a0)
 148:	02d00793          	li	a5,45
 14c:	02f70f63          	beq	a4,a5,18a <main+0x60>
      fprintf(2, "tail: missing file operand\n");
      exit(1);
    }
    fd = open(argv[2], 0);
  } else {
    fd = open(argv[1], 0);
 150:	4581                	li	a1,0
 152:	32c000ef          	jal	ra,47e <open>
 156:	84aa                	mv	s1,a0
  int n = 10;  // Par défaut : 10 dernières lignes
 158:	49a9                	li	s3,10
  }

  if(fd < 0) {
 15a:	0604c063          	bltz	s1,1ba <main+0x90>
    fprintf(2, "tail: cannot open %s\n", argv[1]);
    exit(1);
  }

  readlines(fd);
 15e:	8526                	mv	a0,s1
 160:	ea1ff0ef          	jal	ra,0 <readlines>
  printtail(n);
 164:	854e                	mv	a0,s3
 166:	f57ff0ef          	jal	ra,bc <printtail>

  close(fd);
 16a:	8526                	mv	a0,s1
 16c:	2fa000ef          	jal	ra,466 <close>
  exit(0);
 170:	4501                	li	a0,0
 172:	2cc000ef          	jal	ra,43e <exit>
    fprintf(2, "Usage: tail [-n] file\n");
 176:	00001597          	auipc	a1,0x1
 17a:	89258593          	addi	a1,a1,-1902 # a08 <malloc+0xee>
 17e:	4509                	li	a0,2
 180:	6b6000ef          	jal	ra,836 <fprintf>
    exit(1);
 184:	4505                	li	a0,1
 186:	2b8000ef          	jal	ra,43e <exit>
    n = atoi(&argv[1][1]);
 18a:	0505                	addi	a0,a0,1
 18c:	1ba000ef          	jal	ra,346 <atoi>
 190:	89aa                	mv	s3,a0
    if(argc < 3) {
 192:	4789                	li	a5,2
 194:	0097cc63          	blt	a5,s1,1ac <main+0x82>
      fprintf(2, "tail: missing file operand\n");
 198:	00001597          	auipc	a1,0x1
 19c:	88858593          	addi	a1,a1,-1912 # a20 <malloc+0x106>
 1a0:	4509                	li	a0,2
 1a2:	694000ef          	jal	ra,836 <fprintf>
      exit(1);
 1a6:	4505                	li	a0,1
 1a8:	296000ef          	jal	ra,43e <exit>
    fd = open(argv[2], 0);
 1ac:	4581                	li	a1,0
 1ae:	01093503          	ld	a0,16(s2)
 1b2:	2cc000ef          	jal	ra,47e <open>
 1b6:	84aa                	mv	s1,a0
 1b8:	b74d                	j	15a <main+0x30>
    fprintf(2, "tail: cannot open %s\n", argv[1]);
 1ba:	00893603          	ld	a2,8(s2)
 1be:	00001597          	auipc	a1,0x1
 1c2:	88258593          	addi	a1,a1,-1918 # a40 <malloc+0x126>
 1c6:	4509                	li	a0,2
 1c8:	66e000ef          	jal	ra,836 <fprintf>
    exit(1);
 1cc:	4505                	li	a0,1
 1ce:	270000ef          	jal	ra,43e <exit>

00000000000001d2 <start>:
//


void
start()
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1da:	f51ff0ef          	jal	ra,12a <main>
  exit(0);
 1de:	4501                	li	a0,0
 1e0:	25e000ef          	jal	ra,43e <exit>

00000000000001e4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ea:	87aa                	mv	a5,a0
 1ec:	0585                	addi	a1,a1,1
 1ee:	0785                	addi	a5,a5,1
 1f0:	fff5c703          	lbu	a4,-1(a1)
 1f4:	fee78fa3          	sb	a4,-1(a5)
 1f8:	fb75                	bnez	a4,1ec <strcpy+0x8>
    ;
  return os;
}
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret

0000000000000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cb91                	beqz	a5,21e <strcmp+0x1e>
 20c:	0005c703          	lbu	a4,0(a1)
 210:	00f71763          	bne	a4,a5,21e <strcmp+0x1e>
    p++, q++;
 214:	0505                	addi	a0,a0,1
 216:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	fbe5                	bnez	a5,20c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 21e:	0005c503          	lbu	a0,0(a1)
}
 222:	40a7853b          	subw	a0,a5,a0
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret

000000000000022c <strlen>:

uint
strlen(const char *s)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 232:	00054783          	lbu	a5,0(a0)
 236:	cf91                	beqz	a5,252 <strlen+0x26>
 238:	0505                	addi	a0,a0,1
 23a:	87aa                	mv	a5,a0
 23c:	4685                	li	a3,1
 23e:	9e89                	subw	a3,a3,a0
 240:	00f6853b          	addw	a0,a3,a5
 244:	0785                	addi	a5,a5,1
 246:	fff7c703          	lbu	a4,-1(a5)
 24a:	fb7d                	bnez	a4,240 <strlen+0x14>
    ;
  return n;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  for(n = 0; s[n]; n++)
 252:	4501                	li	a0,0
 254:	bfe5                	j	24c <strlen+0x20>

0000000000000256 <memset>:

void*
memset(void *dst, int c, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 25c:	ca19                	beqz	a2,272 <memset+0x1c>
 25e:	87aa                	mv	a5,a0
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 268:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 26c:	0785                	addi	a5,a5,1
 26e:	fee79de3          	bne	a5,a4,268 <memset+0x12>
  }
  return dst;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <strchr>:

char*
strchr(const char *s, char c)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 27e:	00054783          	lbu	a5,0(a0)
 282:	cb99                	beqz	a5,298 <strchr+0x20>
    if(*s == c)
 284:	00f58763          	beq	a1,a5,292 <strchr+0x1a>
  for(; *s; s++)
 288:	0505                	addi	a0,a0,1
 28a:	00054783          	lbu	a5,0(a0)
 28e:	fbfd                	bnez	a5,284 <strchr+0xc>
      return (char*)s;
  return 0;
 290:	4501                	li	a0,0
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <strchr+0x1a>

000000000000029c <gets>:

char*
gets(char *buf, int max)
{
 29c:	711d                	addi	sp,sp,-96
 29e:	ec86                	sd	ra,88(sp)
 2a0:	e8a2                	sd	s0,80(sp)
 2a2:	e4a6                	sd	s1,72(sp)
 2a4:	e0ca                	sd	s2,64(sp)
 2a6:	fc4e                	sd	s3,56(sp)
 2a8:	f852                	sd	s4,48(sp)
 2aa:	f456                	sd	s5,40(sp)
 2ac:	f05a                	sd	s6,32(sp)
 2ae:	ec5e                	sd	s7,24(sp)
 2b0:	1080                	addi	s0,sp,96
 2b2:	8baa                	mv	s7,a0
 2b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	892a                	mv	s2,a0
 2b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ba:	4aa9                	li	s5,10
 2bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2be:	89a6                	mv	s3,s1
 2c0:	2485                	addiw	s1,s1,1
 2c2:	0344d663          	bge	s1,s4,2ee <gets+0x52>
    cc = read(0, &c, 1);
 2c6:	4605                	li	a2,1
 2c8:	faf40593          	addi	a1,s0,-81
 2cc:	4501                	li	a0,0
 2ce:	188000ef          	jal	ra,456 <read>
    if(cc < 1)
 2d2:	00a05e63          	blez	a0,2ee <gets+0x52>
    buf[i++] = c;
 2d6:	faf44783          	lbu	a5,-81(s0)
 2da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2de:	01578763          	beq	a5,s5,2ec <gets+0x50>
 2e2:	0905                	addi	s2,s2,1
 2e4:	fd679de3          	bne	a5,s6,2be <gets+0x22>
  for(i=0; i+1 < max; ){
 2e8:	89a6                	mv	s3,s1
 2ea:	a011                	j	2ee <gets+0x52>
 2ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ee:	99de                	add	s3,s3,s7
 2f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2f4:	855e                	mv	a0,s7
 2f6:	60e6                	ld	ra,88(sp)
 2f8:	6446                	ld	s0,80(sp)
 2fa:	64a6                	ld	s1,72(sp)
 2fc:	6906                	ld	s2,64(sp)
 2fe:	79e2                	ld	s3,56(sp)
 300:	7a42                	ld	s4,48(sp)
 302:	7aa2                	ld	s5,40(sp)
 304:	7b02                	ld	s6,32(sp)
 306:	6be2                	ld	s7,24(sp)
 308:	6125                	addi	sp,sp,96
 30a:	8082                	ret

000000000000030c <stat>:

int
stat(const char *n, struct stat *st)
{
 30c:	1101                	addi	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	e426                	sd	s1,8(sp)
 314:	e04a                	sd	s2,0(sp)
 316:	1000                	addi	s0,sp,32
 318:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	162000ef          	jal	ra,47e <open>
  if(fd < 0)
 320:	02054163          	bltz	a0,342 <stat+0x36>
 324:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 326:	85ca                	mv	a1,s2
 328:	16e000ef          	jal	ra,496 <fstat>
 32c:	892a                	mv	s2,a0
  close(fd);
 32e:	8526                	mv	a0,s1
 330:	136000ef          	jal	ra,466 <close>
  return r;
}
 334:	854a                	mv	a0,s2
 336:	60e2                	ld	ra,24(sp)
 338:	6442                	ld	s0,16(sp)
 33a:	64a2                	ld	s1,8(sp)
 33c:	6902                	ld	s2,0(sp)
 33e:	6105                	addi	sp,sp,32
 340:	8082                	ret
    return -1;
 342:	597d                	li	s2,-1
 344:	bfc5                	j	334 <stat+0x28>

0000000000000346 <atoi>:

int
atoi(const char *s)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34c:	00054603          	lbu	a2,0(a0)
 350:	fd06079b          	addiw	a5,a2,-48
 354:	0ff7f793          	andi	a5,a5,255
 358:	4725                	li	a4,9
 35a:	02f76963          	bltu	a4,a5,38c <atoi+0x46>
 35e:	86aa                	mv	a3,a0
  n = 0;
 360:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 362:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 364:	0685                	addi	a3,a3,1
 366:	0025179b          	slliw	a5,a0,0x2
 36a:	9fa9                	addw	a5,a5,a0
 36c:	0017979b          	slliw	a5,a5,0x1
 370:	9fb1                	addw	a5,a5,a2
 372:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 376:	0006c603          	lbu	a2,0(a3)
 37a:	fd06071b          	addiw	a4,a2,-48
 37e:	0ff77713          	andi	a4,a4,255
 382:	fee5f1e3          	bgeu	a1,a4,364 <atoi+0x1e>
  return n;
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  n = 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <atoi+0x40>

0000000000000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 396:	02b57463          	bgeu	a0,a1,3be <memmove+0x2e>
    while(n-- > 0)
 39a:	00c05f63          	blez	a2,3b8 <memmove+0x28>
 39e:	1602                	slli	a2,a2,0x20
 3a0:	9201                	srli	a2,a2,0x20
 3a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3a8:	0585                	addi	a1,a1,1
 3aa:	0705                	addi	a4,a4,1
 3ac:	fff5c683          	lbu	a3,-1(a1)
 3b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b4:	fee79ae3          	bne	a5,a4,3a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
    dst += n;
 3be:	00c50733          	add	a4,a0,a2
    src += n;
 3c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c4:	fec05ae3          	blez	a2,3b8 <memmove+0x28>
 3c8:	fff6079b          	addiw	a5,a2,-1
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	fff7c793          	not	a5,a5
 3d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3d6:	15fd                	addi	a1,a1,-1
 3d8:	177d                	addi	a4,a4,-1
 3da:	0005c683          	lbu	a3,0(a1)
 3de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e2:	fee79ae3          	bne	a5,a4,3d6 <memmove+0x46>
 3e6:	bfc9                	j	3b8 <memmove+0x28>

00000000000003e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ee:	ca05                	beqz	a2,41e <memcmp+0x36>
 3f0:	fff6069b          	addiw	a3,a2,-1
 3f4:	1682                	slli	a3,a3,0x20
 3f6:	9281                	srli	a3,a3,0x20
 3f8:	0685                	addi	a3,a3,1
 3fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3fc:	00054783          	lbu	a5,0(a0)
 400:	0005c703          	lbu	a4,0(a1)
 404:	00e79863          	bne	a5,a4,414 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 408:	0505                	addi	a0,a0,1
    p2++;
 40a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 40c:	fed518e3          	bne	a0,a3,3fc <memcmp+0x14>
  }
  return 0;
 410:	4501                	li	a0,0
 412:	a019                	j	418 <memcmp+0x30>
      return *p1 - *p2;
 414:	40e7853b          	subw	a0,a5,a4
}
 418:	6422                	ld	s0,8(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret
  return 0;
 41e:	4501                	li	a0,0
 420:	bfe5                	j	418 <memcmp+0x30>

0000000000000422 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 422:	1141                	addi	sp,sp,-16
 424:	e406                	sd	ra,8(sp)
 426:	e022                	sd	s0,0(sp)
 428:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 42a:	f67ff0ef          	jal	ra,390 <memmove>
}
 42e:	60a2                	ld	ra,8(sp)
 430:	6402                	ld	s0,0(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret

0000000000000436 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 436:	4885                	li	a7,1
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <exit>:
.global exit
exit:
 li a7, SYS_exit
 43e:	4889                	li	a7,2
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <wait>:
.global wait
wait:
 li a7, SYS_wait
 446:	488d                	li	a7,3
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 44e:	4891                	li	a7,4
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <read>:
.global read
read:
 li a7, SYS_read
 456:	4895                	li	a7,5
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <write>:
.global write
write:
 li a7, SYS_write
 45e:	48c1                	li	a7,16
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <close>:
.global close
close:
 li a7, SYS_close
 466:	48d5                	li	a7,21
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <kill>:
.global kill
kill:
 li a7, SYS_kill
 46e:	4899                	li	a7,6
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <exec>:
.global exec
exec:
 li a7, SYS_exec
 476:	489d                	li	a7,7
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <open>:
.global open
open:
 li a7, SYS_open
 47e:	48bd                	li	a7,15
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 486:	48c5                	li	a7,17
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 48e:	48c9                	li	a7,18
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 496:	48a1                	li	a7,8
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <link>:
.global link
link:
 li a7, SYS_link
 49e:	48cd                	li	a7,19
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a6:	48d1                	li	a7,20
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ae:	48a5                	li	a7,9
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b6:	48a9                	li	a7,10
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4be:	48ad                	li	a7,11
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c6:	48b1                	li	a7,12
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ce:	48b5                	li	a7,13
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d6:	48b9                	li	a7,14
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 4de:	48d9                	li	a7,22
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 4e6:	48dd                	li	a7,23
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 4ee:	48e1                	li	a7,24
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f6:	1101                	addi	sp,sp,-32
 4f8:	ec06                	sd	ra,24(sp)
 4fa:	e822                	sd	s0,16(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 502:	4605                	li	a2,1
 504:	fef40593          	addi	a1,s0,-17
 508:	f57ff0ef          	jal	ra,45e <write>
}
 50c:	60e2                	ld	ra,24(sp)
 50e:	6442                	ld	s0,16(sp)
 510:	6105                	addi	sp,sp,32
 512:	8082                	ret

0000000000000514 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 514:	7139                	addi	sp,sp,-64
 516:	fc06                	sd	ra,56(sp)
 518:	f822                	sd	s0,48(sp)
 51a:	f426                	sd	s1,40(sp)
 51c:	f04a                	sd	s2,32(sp)
 51e:	ec4e                	sd	s3,24(sp)
 520:	0080                	addi	s0,sp,64
 522:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 524:	c299                	beqz	a3,52a <printint+0x16>
 526:	0805c663          	bltz	a1,5b2 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52a:	2581                	sext.w	a1,a1
  neg = 0;
 52c:	4881                	li	a7,0
 52e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 532:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 534:	2601                	sext.w	a2,a2
 536:	00000517          	auipc	a0,0x0
 53a:	52a50513          	addi	a0,a0,1322 # a60 <digits>
 53e:	883a                	mv	a6,a4
 540:	2705                	addiw	a4,a4,1
 542:	02c5f7bb          	remuw	a5,a1,a2
 546:	1782                	slli	a5,a5,0x20
 548:	9381                	srli	a5,a5,0x20
 54a:	97aa                	add	a5,a5,a0
 54c:	0007c783          	lbu	a5,0(a5)
 550:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 554:	0005879b          	sext.w	a5,a1
 558:	02c5d5bb          	divuw	a1,a1,a2
 55c:	0685                	addi	a3,a3,1
 55e:	fec7f0e3          	bgeu	a5,a2,53e <printint+0x2a>
  if(neg)
 562:	00088b63          	beqz	a7,578 <printint+0x64>
    buf[i++] = '-';
 566:	fd040793          	addi	a5,s0,-48
 56a:	973e                	add	a4,a4,a5
 56c:	02d00793          	li	a5,45
 570:	fef70823          	sb	a5,-16(a4)
 574:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 578:	02e05663          	blez	a4,5a4 <printint+0x90>
 57c:	fc040793          	addi	a5,s0,-64
 580:	00e78933          	add	s2,a5,a4
 584:	fff78993          	addi	s3,a5,-1
 588:	99ba                	add	s3,s3,a4
 58a:	377d                	addiw	a4,a4,-1
 58c:	1702                	slli	a4,a4,0x20
 58e:	9301                	srli	a4,a4,0x20
 590:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 594:	fff94583          	lbu	a1,-1(s2)
 598:	8526                	mv	a0,s1
 59a:	f5dff0ef          	jal	ra,4f6 <putc>
  while(--i >= 0)
 59e:	197d                	addi	s2,s2,-1
 5a0:	ff391ae3          	bne	s2,s3,594 <printint+0x80>
}
 5a4:	70e2                	ld	ra,56(sp)
 5a6:	7442                	ld	s0,48(sp)
 5a8:	74a2                	ld	s1,40(sp)
 5aa:	7902                	ld	s2,32(sp)
 5ac:	69e2                	ld	s3,24(sp)
 5ae:	6121                	addi	sp,sp,64
 5b0:	8082                	ret
    x = -xx;
 5b2:	40b005bb          	negw	a1,a1
    neg = 1;
 5b6:	4885                	li	a7,1
    x = -xx;
 5b8:	bf9d                	j	52e <printint+0x1a>

00000000000005ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ba:	7119                	addi	sp,sp,-128
 5bc:	fc86                	sd	ra,120(sp)
 5be:	f8a2                	sd	s0,112(sp)
 5c0:	f4a6                	sd	s1,104(sp)
 5c2:	f0ca                	sd	s2,96(sp)
 5c4:	ecce                	sd	s3,88(sp)
 5c6:	e8d2                	sd	s4,80(sp)
 5c8:	e4d6                	sd	s5,72(sp)
 5ca:	e0da                	sd	s6,64(sp)
 5cc:	fc5e                	sd	s7,56(sp)
 5ce:	f862                	sd	s8,48(sp)
 5d0:	f466                	sd	s9,40(sp)
 5d2:	f06a                	sd	s10,32(sp)
 5d4:	ec6e                	sd	s11,24(sp)
 5d6:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d8:	0005c903          	lbu	s2,0(a1)
 5dc:	22090e63          	beqz	s2,818 <vprintf+0x25e>
 5e0:	8b2a                	mv	s6,a0
 5e2:	8a2e                	mv	s4,a1
 5e4:	8bb2                	mv	s7,a2
  state = 0;
 5e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e8:	4481                	li	s1,0
 5ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5f8:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	00000c97          	auipc	s9,0x0
 600:	464c8c93          	addi	s9,s9,1124 # a60 <digits>
 604:	a005                	j	624 <vprintf+0x6a>
        putc(fd, c0);
 606:	85ca                	mv	a1,s2
 608:	855a                	mv	a0,s6
 60a:	eedff0ef          	jal	ra,4f6 <putc>
 60e:	a019                	j	614 <vprintf+0x5a>
    } else if(state == '%'){
 610:	03598263          	beq	s3,s5,634 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 614:	2485                	addiw	s1,s1,1
 616:	8726                	mv	a4,s1
 618:	009a07b3          	add	a5,s4,s1
 61c:	0007c903          	lbu	s2,0(a5)
 620:	1e090c63          	beqz	s2,818 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 624:	0009079b          	sext.w	a5,s2
    if(state == 0){
 628:	fe0994e3          	bnez	s3,610 <vprintf+0x56>
      if(c0 == '%'){
 62c:	fd579de3          	bne	a5,s5,606 <vprintf+0x4c>
        state = '%';
 630:	89be                	mv	s3,a5
 632:	b7cd                	j	614 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 634:	cfa5                	beqz	a5,6ac <vprintf+0xf2>
 636:	00ea06b3          	add	a3,s4,a4
 63a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 63e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 640:	c681                	beqz	a3,648 <vprintf+0x8e>
 642:	9752                	add	a4,a4,s4
 644:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 648:	03878a63          	beq	a5,s8,67c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 64c:	05a78463          	beq	a5,s10,694 <vprintf+0xda>
      } else if(c0 == 'u'){
 650:	0db78763          	beq	a5,s11,71e <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 654:	07800713          	li	a4,120
 658:	10e78963          	beq	a5,a4,76a <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 65c:	07000713          	li	a4,112
 660:	12e78e63          	beq	a5,a4,79c <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 664:	07300713          	li	a4,115
 668:	16e78b63          	beq	a5,a4,7de <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 66c:	05579063          	bne	a5,s5,6ac <vprintf+0xf2>
        putc(fd, '%');
 670:	85d6                	mv	a1,s5
 672:	855a                	mv	a0,s6
 674:	e83ff0ef          	jal	ra,4f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 678:	4981                	li	s3,0
 67a:	bf69                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 67c:	008b8913          	addi	s2,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e8bff0ef          	jal	ra,514 <printint>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b749                	j	614 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 694:	03868663          	beq	a3,s8,6c0 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 698:	05a68163          	beq	a3,s10,6da <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 69c:	09b68d63          	beq	a3,s11,736 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a0:	03a68f63          	beq	a3,s10,6de <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6a4:	07800793          	li	a5,120
 6a8:	0cf68d63          	beq	a3,a5,782 <vprintf+0x1c8>
        putc(fd, '%');
 6ac:	85d6                	mv	a1,s5
 6ae:	855a                	mv	a0,s6
 6b0:	e47ff0ef          	jal	ra,4f6 <putc>
        putc(fd, c0);
 6b4:	85ca                	mv	a1,s2
 6b6:	855a                	mv	a0,s6
 6b8:	e3fff0ef          	jal	ra,4f6 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bf99                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	e47ff0ef          	jal	ra,514 <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	bf35                	j	614 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6da:	03860563          	beq	a2,s8,704 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6de:	07b60963          	beq	a2,s11,750 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e2:	07800793          	li	a5,120
 6e6:	fcf613e3          	bne	a2,a5,6ac <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e1dff0ef          	jal	ra,514 <printint>
        i += 2;
 6fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bf09                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8913          	addi	s2,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e03ff0ef          	jal	ra,514 <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bde5                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000ba583          	lw	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	de9ff0ef          	jal	ra,514 <printint>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	b5c5                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	dd1ff0ef          	jal	ra,514 <printint>
        i += 1;
 748:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	b5d9                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	db7ff0ef          	jal	ra,514 <printint>
        i += 2;
 762:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	b575                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	d9dff0ef          	jal	ra,514 <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bd51                	j	614 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4641                	li	a2,16
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d85ff0ef          	jal	ra,514 <printint>
        i += 1;
 794:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	bdad                	j	614 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 79c:	008b8793          	addi	a5,s7,8
 7a0:	f8f43423          	sd	a5,-120(s0)
 7a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a8:	03000593          	li	a1,48
 7ac:	855a                	mv	a0,s6
 7ae:	d49ff0ef          	jal	ra,4f6 <putc>
  putc(fd, 'x');
 7b2:	07800593          	li	a1,120
 7b6:	855a                	mv	a0,s6
 7b8:	d3fff0ef          	jal	ra,4f6 <putc>
 7bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7be:	03c9d793          	srli	a5,s3,0x3c
 7c2:	97e6                	add	a5,a5,s9
 7c4:	0007c583          	lbu	a1,0(a5)
 7c8:	855a                	mv	a0,s6
 7ca:	d2dff0ef          	jal	ra,4f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ce:	0992                	slli	s3,s3,0x4
 7d0:	397d                	addiw	s2,s2,-1
 7d2:	fe0916e3          	bnez	s2,7be <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 7d6:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bd25                	j	614 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7de:	008b8993          	addi	s3,s7,8
 7e2:	000bb903          	ld	s2,0(s7)
 7e6:	00090f63          	beqz	s2,804 <vprintf+0x24a>
        for(; *s; s++)
 7ea:	00094583          	lbu	a1,0(s2)
 7ee:	c195                	beqz	a1,812 <vprintf+0x258>
          putc(fd, *s);
 7f0:	855a                	mv	a0,s6
 7f2:	d05ff0ef          	jal	ra,4f6 <putc>
        for(; *s; s++)
 7f6:	0905                	addi	s2,s2,1
 7f8:	00094583          	lbu	a1,0(s2)
 7fc:	f9f5                	bnez	a1,7f0 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7fe:	8bce                	mv	s7,s3
      state = 0;
 800:	4981                	li	s3,0
 802:	bd09                	j	614 <vprintf+0x5a>
          s = "(null)";
 804:	00000917          	auipc	s2,0x0
 808:	25490913          	addi	s2,s2,596 # a58 <malloc+0x13e>
        for(; *s; s++)
 80c:	02800593          	li	a1,40
 810:	b7c5                	j	7f0 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 812:	8bce                	mv	s7,s3
      state = 0;
 814:	4981                	li	s3,0
 816:	bbfd                	j	614 <vprintf+0x5a>
    }
  }
}
 818:	70e6                	ld	ra,120(sp)
 81a:	7446                	ld	s0,112(sp)
 81c:	74a6                	ld	s1,104(sp)
 81e:	7906                	ld	s2,96(sp)
 820:	69e6                	ld	s3,88(sp)
 822:	6a46                	ld	s4,80(sp)
 824:	6aa6                	ld	s5,72(sp)
 826:	6b06                	ld	s6,64(sp)
 828:	7be2                	ld	s7,56(sp)
 82a:	7c42                	ld	s8,48(sp)
 82c:	7ca2                	ld	s9,40(sp)
 82e:	7d02                	ld	s10,32(sp)
 830:	6de2                	ld	s11,24(sp)
 832:	6109                	addi	sp,sp,128
 834:	8082                	ret

0000000000000836 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 836:	715d                	addi	sp,sp,-80
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e010                	sd	a2,0(s0)
 840:	e414                	sd	a3,8(s0)
 842:	e818                	sd	a4,16(s0)
 844:	ec1c                	sd	a5,24(s0)
 846:	03043023          	sd	a6,32(s0)
 84a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 852:	8622                	mv	a2,s0
 854:	d67ff0ef          	jal	ra,5ba <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:

void
printf(const char *fmt, ...)
{
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	d35ff0ef          	jal	ra,5ba <vprintf>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6125                	addi	sp,sp,96
 890:	8082                	ret

0000000000000892 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 898:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	00000797          	auipc	a5,0x0
 8a0:	76c7b783          	ld	a5,1900(a5) # 1008 <freep>
 8a4:	a805                	j	8d4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a6:	4618                	lw	a4,8(a2)
 8a8:	9db9                	addw	a1,a1,a4
 8aa:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	6318                	ld	a4,0(a4)
 8b2:	fee53823          	sd	a4,-16(a0)
 8b6:	a091                	j	8fa <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b8:	ff852703          	lw	a4,-8(a0)
 8bc:	9e39                	addw	a2,a2,a4
 8be:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8c0:	ff053703          	ld	a4,-16(a0)
 8c4:	e398                	sd	a4,0(a5)
 8c6:	a099                	j	90c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	6398                	ld	a4,0(a5)
 8ca:	00e7e463          	bltu	a5,a4,8d2 <free+0x40>
 8ce:	00e6ea63          	bltu	a3,a4,8e2 <free+0x50>
{
 8d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	fed7fae3          	bgeu	a5,a3,8c8 <free+0x36>
 8d8:	6398                	ld	a4,0(a5)
 8da:	00e6e463          	bltu	a3,a4,8e2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	fee7eae3          	bltu	a5,a4,8d2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8e2:	ff852583          	lw	a1,-8(a0)
 8e6:	6390                	ld	a2,0(a5)
 8e8:	02059713          	slli	a4,a1,0x20
 8ec:	9301                	srli	a4,a4,0x20
 8ee:	0712                	slli	a4,a4,0x4
 8f0:	9736                	add	a4,a4,a3
 8f2:	fae60ae3          	beq	a2,a4,8a6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8fa:	4790                	lw	a2,8(a5)
 8fc:	02061713          	slli	a4,a2,0x20
 900:	9301                	srli	a4,a4,0x20
 902:	0712                	slli	a4,a4,0x4
 904:	973e                	add	a4,a4,a5
 906:	fae689e3          	beq	a3,a4,8b8 <free+0x26>
  } else
    p->s.ptr = bp;
 90a:	e394                	sd	a3,0(a5)
  freep = p;
 90c:	00000717          	auipc	a4,0x0
 910:	6ef73e23          	sd	a5,1788(a4) # 1008 <freep>
}
 914:	6422                	ld	s0,8(sp)
 916:	0141                	addi	sp,sp,16
 918:	8082                	ret

000000000000091a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 91a:	7139                	addi	sp,sp,-64
 91c:	fc06                	sd	ra,56(sp)
 91e:	f822                	sd	s0,48(sp)
 920:	f426                	sd	s1,40(sp)
 922:	f04a                	sd	s2,32(sp)
 924:	ec4e                	sd	s3,24(sp)
 926:	e852                	sd	s4,16(sp)
 928:	e456                	sd	s5,8(sp)
 92a:	e05a                	sd	s6,0(sp)
 92c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92e:	02051493          	slli	s1,a0,0x20
 932:	9081                	srli	s1,s1,0x20
 934:	04bd                	addi	s1,s1,15
 936:	8091                	srli	s1,s1,0x4
 938:	0014899b          	addiw	s3,s1,1
 93c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 93e:	00000517          	auipc	a0,0x0
 942:	6ca53503          	ld	a0,1738(a0) # 1008 <freep>
 946:	c515                	beqz	a0,972 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	02977f63          	bgeu	a4,s1,98a <malloc+0x70>
 950:	8a4e                	mv	s4,s3
 952:	0009871b          	sext.w	a4,s3
 956:	6685                	lui	a3,0x1
 958:	00d77363          	bgeu	a4,a3,95e <malloc+0x44>
 95c:	6a05                	lui	s4,0x1
 95e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 962:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 966:	00000917          	auipc	s2,0x0
 96a:	6a290913          	addi	s2,s2,1698 # 1008 <freep>
  if(p == (char*)-1)
 96e:	5afd                	li	s5,-1
 970:	a0bd                	j	9de <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 972:	00019797          	auipc	a5,0x19
 976:	d3e78793          	addi	a5,a5,-706 # 196b0 <base>
 97a:	00000717          	auipc	a4,0x0
 97e:	68f73723          	sd	a5,1678(a4) # 1008 <freep>
 982:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 984:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 988:	b7e1                	j	950 <malloc+0x36>
      if(p->s.size == nunits)
 98a:	02e48b63          	beq	s1,a4,9c0 <malloc+0xa6>
        p->s.size -= nunits;
 98e:	4137073b          	subw	a4,a4,s3
 992:	c798                	sw	a4,8(a5)
        p += p->s.size;
 994:	1702                	slli	a4,a4,0x20
 996:	9301                	srli	a4,a4,0x20
 998:	0712                	slli	a4,a4,0x4
 99a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a0:	00000717          	auipc	a4,0x0
 9a4:	66a73423          	sd	a0,1640(a4) # 1008 <freep>
      return (void*)(p + 1);
 9a8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ac:	70e2                	ld	ra,56(sp)
 9ae:	7442                	ld	s0,48(sp)
 9b0:	74a2                	ld	s1,40(sp)
 9b2:	7902                	ld	s2,32(sp)
 9b4:	69e2                	ld	s3,24(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	6121                	addi	sp,sp,64
 9be:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c0:	6398                	ld	a4,0(a5)
 9c2:	e118                	sd	a4,0(a0)
 9c4:	bff1                	j	9a0 <malloc+0x86>
  hp->s.size = nu;
 9c6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ca:	0541                	addi	a0,a0,16
 9cc:	ec7ff0ef          	jal	ra,892 <free>
  return freep;
 9d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d4:	dd61                	beqz	a0,9ac <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	fa9778e3          	bgeu	a4,s1,98a <malloc+0x70>
    if(p == freep)
 9de:	00093703          	ld	a4,0(s2)
 9e2:	853e                	mv	a0,a5
 9e4:	fef719e3          	bne	a4,a5,9d6 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	addff0ef          	jal	ra,4c6 <sbrk>
  if(p == (char*)-1)
 9ee:	fd551ce3          	bne	a0,s5,9c6 <malloc+0xac>
        return 0;
 9f2:	4501                	li	a0,0
 9f4:	bf65                	j	9ac <malloc+0x92>
