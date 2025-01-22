
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
  f8:	90ca0a13          	addi	s4,s4,-1780 # a00 <malloc+0xde>
  for(i = start; i < nlines; i++)
  fc:	00001997          	auipc	s3,0x1
 100:	f0498993          	addi	s3,s3,-252 # 1000 <nlines>
    printf("%s\n", content[i]);
 104:	85a6                	mv	a1,s1
 106:	8552                	mv	a0,s4
 108:	760000ef          	jal	ra,868 <printf>
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
 17a:	89258593          	addi	a1,a1,-1902 # a08 <malloc+0xe6>
 17e:	4509                	li	a0,2
 180:	6be000ef          	jal	ra,83e <fprintf>
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
 19c:	88858593          	addi	a1,a1,-1912 # a20 <malloc+0xfe>
 1a0:	4509                	li	a0,2
 1a2:	69c000ef          	jal	ra,83e <fprintf>
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
 1c2:	88258593          	addi	a1,a1,-1918 # a40 <malloc+0x11e>
 1c6:	4509                	li	a0,2
 1c8:	676000ef          	jal	ra,83e <fprintf>
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

00000000000004f6 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 4f6:	48e5                	li	a7,25
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fe:	1101                	addi	sp,sp,-32
 500:	ec06                	sd	ra,24(sp)
 502:	e822                	sd	s0,16(sp)
 504:	1000                	addi	s0,sp,32
 506:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 50a:	4605                	li	a2,1
 50c:	fef40593          	addi	a1,s0,-17
 510:	f4fff0ef          	jal	ra,45e <write>
}
 514:	60e2                	ld	ra,24(sp)
 516:	6442                	ld	s0,16(sp)
 518:	6105                	addi	sp,sp,32
 51a:	8082                	ret

000000000000051c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51c:	7139                	addi	sp,sp,-64
 51e:	fc06                	sd	ra,56(sp)
 520:	f822                	sd	s0,48(sp)
 522:	f426                	sd	s1,40(sp)
 524:	f04a                	sd	s2,32(sp)
 526:	ec4e                	sd	s3,24(sp)
 528:	0080                	addi	s0,sp,64
 52a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52c:	c299                	beqz	a3,532 <printint+0x16>
 52e:	0805c663          	bltz	a1,5ba <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 532:	2581                	sext.w	a1,a1
  neg = 0;
 534:	4881                	li	a7,0
 536:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53c:	2601                	sext.w	a2,a2
 53e:	00000517          	auipc	a0,0x0
 542:	52250513          	addi	a0,a0,1314 # a60 <digits>
 546:	883a                	mv	a6,a4
 548:	2705                	addiw	a4,a4,1
 54a:	02c5f7bb          	remuw	a5,a1,a2
 54e:	1782                	slli	a5,a5,0x20
 550:	9381                	srli	a5,a5,0x20
 552:	97aa                	add	a5,a5,a0
 554:	0007c783          	lbu	a5,0(a5)
 558:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55c:	0005879b          	sext.w	a5,a1
 560:	02c5d5bb          	divuw	a1,a1,a2
 564:	0685                	addi	a3,a3,1
 566:	fec7f0e3          	bgeu	a5,a2,546 <printint+0x2a>
  if(neg)
 56a:	00088b63          	beqz	a7,580 <printint+0x64>
    buf[i++] = '-';
 56e:	fd040793          	addi	a5,s0,-48
 572:	973e                	add	a4,a4,a5
 574:	02d00793          	li	a5,45
 578:	fef70823          	sb	a5,-16(a4)
 57c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 580:	02e05663          	blez	a4,5ac <printint+0x90>
 584:	fc040793          	addi	a5,s0,-64
 588:	00e78933          	add	s2,a5,a4
 58c:	fff78993          	addi	s3,a5,-1
 590:	99ba                	add	s3,s3,a4
 592:	377d                	addiw	a4,a4,-1
 594:	1702                	slli	a4,a4,0x20
 596:	9301                	srli	a4,a4,0x20
 598:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59c:	fff94583          	lbu	a1,-1(s2)
 5a0:	8526                	mv	a0,s1
 5a2:	f5dff0ef          	jal	ra,4fe <putc>
  while(--i >= 0)
 5a6:	197d                	addi	s2,s2,-1
 5a8:	ff391ae3          	bne	s2,s3,59c <printint+0x80>
}
 5ac:	70e2                	ld	ra,56(sp)
 5ae:	7442                	ld	s0,48(sp)
 5b0:	74a2                	ld	s1,40(sp)
 5b2:	7902                	ld	s2,32(sp)
 5b4:	69e2                	ld	s3,24(sp)
 5b6:	6121                	addi	sp,sp,64
 5b8:	8082                	ret
    x = -xx;
 5ba:	40b005bb          	negw	a1,a1
    neg = 1;
 5be:	4885                	li	a7,1
    x = -xx;
 5c0:	bf9d                	j	536 <printint+0x1a>

00000000000005c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c2:	7119                	addi	sp,sp,-128
 5c4:	fc86                	sd	ra,120(sp)
 5c6:	f8a2                	sd	s0,112(sp)
 5c8:	f4a6                	sd	s1,104(sp)
 5ca:	f0ca                	sd	s2,96(sp)
 5cc:	ecce                	sd	s3,88(sp)
 5ce:	e8d2                	sd	s4,80(sp)
 5d0:	e4d6                	sd	s5,72(sp)
 5d2:	e0da                	sd	s6,64(sp)
 5d4:	fc5e                	sd	s7,56(sp)
 5d6:	f862                	sd	s8,48(sp)
 5d8:	f466                	sd	s9,40(sp)
 5da:	f06a                	sd	s10,32(sp)
 5dc:	ec6e                	sd	s11,24(sp)
 5de:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e0:	0005c903          	lbu	s2,0(a1)
 5e4:	22090e63          	beqz	s2,820 <vprintf+0x25e>
 5e8:	8b2a                	mv	s6,a0
 5ea:	8a2e                	mv	s4,a1
 5ec:	8bb2                	mv	s7,a2
  state = 0;
 5ee:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f0:	4481                	li	s1,0
 5f2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5fc:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 600:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	00000c97          	auipc	s9,0x0
 608:	45cc8c93          	addi	s9,s9,1116 # a60 <digits>
 60c:	a005                	j	62c <vprintf+0x6a>
        putc(fd, c0);
 60e:	85ca                	mv	a1,s2
 610:	855a                	mv	a0,s6
 612:	eedff0ef          	jal	ra,4fe <putc>
 616:	a019                	j	61c <vprintf+0x5a>
    } else if(state == '%'){
 618:	03598263          	beq	s3,s5,63c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 61c:	2485                	addiw	s1,s1,1
 61e:	8726                	mv	a4,s1
 620:	009a07b3          	add	a5,s4,s1
 624:	0007c903          	lbu	s2,0(a5)
 628:	1e090c63          	beqz	s2,820 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 62c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 630:	fe0994e3          	bnez	s3,618 <vprintf+0x56>
      if(c0 == '%'){
 634:	fd579de3          	bne	a5,s5,60e <vprintf+0x4c>
        state = '%';
 638:	89be                	mv	s3,a5
 63a:	b7cd                	j	61c <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 63c:	cfa5                	beqz	a5,6b4 <vprintf+0xf2>
 63e:	00ea06b3          	add	a3,s4,a4
 642:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 646:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 648:	c681                	beqz	a3,650 <vprintf+0x8e>
 64a:	9752                	add	a4,a4,s4
 64c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 650:	03878a63          	beq	a5,s8,684 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 654:	05a78463          	beq	a5,s10,69c <vprintf+0xda>
      } else if(c0 == 'u'){
 658:	0db78763          	beq	a5,s11,726 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 65c:	07800713          	li	a4,120
 660:	10e78963          	beq	a5,a4,772 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 664:	07000713          	li	a4,112
 668:	12e78e63          	beq	a5,a4,7a4 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 66c:	07300713          	li	a4,115
 670:	16e78b63          	beq	a5,a4,7e6 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 674:	05579063          	bne	a5,s5,6b4 <vprintf+0xf2>
        putc(fd, '%');
 678:	85d6                	mv	a1,s5
 67a:	855a                	mv	a0,s6
 67c:	e83ff0ef          	jal	ra,4fe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 680:	4981                	li	s3,0
 682:	bf69                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8913          	addi	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	e8bff0ef          	jal	ra,51c <printint>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b749                	j	61c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	03868663          	beq	a3,s8,6c8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a0:	05a68163          	beq	a3,s10,6e2 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 6a4:	09b68d63          	beq	a3,s11,73e <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a8:	03a68f63          	beq	a3,s10,6e6 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6ac:	07800793          	li	a5,120
 6b0:	0cf68d63          	beq	a3,a5,78a <vprintf+0x1c8>
        putc(fd, '%');
 6b4:	85d6                	mv	a1,s5
 6b6:	855a                	mv	a0,s6
 6b8:	e47ff0ef          	jal	ra,4fe <putc>
        putc(fd, c0);
 6bc:	85ca                	mv	a1,s2
 6be:	855a                	mv	a0,s6
 6c0:	e3fff0ef          	jal	ra,4fe <putc>
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bf99                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4685                	li	a3,1
 6ce:	4629                	li	a2,10
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	e47ff0ef          	jal	ra,51c <printint>
        i += 1;
 6da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	bf35                	j	61c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e2:	03860563          	beq	a2,s8,70c <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e6:	07b60963          	beq	a2,s11,758 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ea:	07800793          	li	a5,120
 6ee:	fcf613e3          	bne	a2,a5,6b4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e1dff0ef          	jal	ra,51c <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	bf09                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	008b8913          	addi	s2,s7,8
 710:	4685                	li	a3,1
 712:	4629                	li	a2,10
 714:	000ba583          	lw	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	e03ff0ef          	jal	ra,51c <printint>
        i += 2;
 71e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	bde5                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	de9ff0ef          	jal	ra,51c <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b5c5                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	dd1ff0ef          	jal	ra,51c <printint>
        i += 1;
 750:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 1;
 756:	b5d9                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	db7ff0ef          	jal	ra,51c <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	b575                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	d9dff0ef          	jal	ra,51c <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	bd51                	j	61c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d85ff0ef          	jal	ra,51c <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	bdad                	j	61c <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 7a4:	008b8793          	addi	a5,s7,8
 7a8:	f8f43423          	sd	a5,-120(s0)
 7ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b0:	03000593          	li	a1,48
 7b4:	855a                	mv	a0,s6
 7b6:	d49ff0ef          	jal	ra,4fe <putc>
  putc(fd, 'x');
 7ba:	07800593          	li	a1,120
 7be:	855a                	mv	a0,s6
 7c0:	d3fff0ef          	jal	ra,4fe <putc>
 7c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c6:	03c9d793          	srli	a5,s3,0x3c
 7ca:	97e6                	add	a5,a5,s9
 7cc:	0007c583          	lbu	a1,0(a5)
 7d0:	855a                	mv	a0,s6
 7d2:	d2dff0ef          	jal	ra,4fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d6:	0992                	slli	s3,s3,0x4
 7d8:	397d                	addiw	s2,s2,-1
 7da:	fe0916e3          	bnez	s2,7c6 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 7de:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bd25                	j	61c <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7e6:	008b8993          	addi	s3,s7,8
 7ea:	000bb903          	ld	s2,0(s7)
 7ee:	00090f63          	beqz	s2,80c <vprintf+0x24a>
        for(; *s; s++)
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	c195                	beqz	a1,81a <vprintf+0x258>
          putc(fd, *s);
 7f8:	855a                	mv	a0,s6
 7fa:	d05ff0ef          	jal	ra,4fe <putc>
        for(; *s; s++)
 7fe:	0905                	addi	s2,s2,1
 800:	00094583          	lbu	a1,0(s2)
 804:	f9f5                	bnez	a1,7f8 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 806:	8bce                	mv	s7,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	bd09                	j	61c <vprintf+0x5a>
          s = "(null)";
 80c:	00000917          	auipc	s2,0x0
 810:	24c90913          	addi	s2,s2,588 # a58 <malloc+0x136>
        for(; *s; s++)
 814:	02800593          	li	a1,40
 818:	b7c5                	j	7f8 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 81a:	8bce                	mv	s7,s3
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bbfd                	j	61c <vprintf+0x5a>
    }
  }
}
 820:	70e6                	ld	ra,120(sp)
 822:	7446                	ld	s0,112(sp)
 824:	74a6                	ld	s1,104(sp)
 826:	7906                	ld	s2,96(sp)
 828:	69e6                	ld	s3,88(sp)
 82a:	6a46                	ld	s4,80(sp)
 82c:	6aa6                	ld	s5,72(sp)
 82e:	6b06                	ld	s6,64(sp)
 830:	7be2                	ld	s7,56(sp)
 832:	7c42                	ld	s8,48(sp)
 834:	7ca2                	ld	s9,40(sp)
 836:	7d02                	ld	s10,32(sp)
 838:	6de2                	ld	s11,24(sp)
 83a:	6109                	addi	sp,sp,128
 83c:	8082                	ret

000000000000083e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83e:	715d                	addi	sp,sp,-80
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e010                	sd	a2,0(s0)
 848:	e414                	sd	a3,8(s0)
 84a:	e818                	sd	a4,16(s0)
 84c:	ec1c                	sd	a5,24(s0)
 84e:	03043023          	sd	a6,32(s0)
 852:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85a:	8622                	mv	a2,s0
 85c:	d67ff0ef          	jal	ra,5c2 <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6161                	addi	sp,sp,80
 866:	8082                	ret

0000000000000868 <printf>:

void
printf(const char *fmt, ...)
{
 868:	711d                	addi	sp,sp,-96
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	addi	s0,sp,32
 870:	e40c                	sd	a1,8(s0)
 872:	e810                	sd	a2,16(s0)
 874:	ec14                	sd	a3,24(s0)
 876:	f018                	sd	a4,32(s0)
 878:	f41c                	sd	a5,40(s0)
 87a:	03043823          	sd	a6,48(s0)
 87e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	00840613          	addi	a2,s0,8
 886:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88a:	85aa                	mv	a1,a0
 88c:	4505                	li	a0,1
 88e:	d35ff0ef          	jal	ra,5c2 <vprintf>
}
 892:	60e2                	ld	ra,24(sp)
 894:	6442                	ld	s0,16(sp)
 896:	6125                	addi	sp,sp,96
 898:	8082                	ret

000000000000089a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89a:	1141                	addi	sp,sp,-16
 89c:	e422                	sd	s0,8(sp)
 89e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	00000797          	auipc	a5,0x0
 8a8:	7647b783          	ld	a5,1892(a5) # 1008 <freep>
 8ac:	a805                	j	8dc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ae:	4618                	lw	a4,8(a2)
 8b0:	9db9                	addw	a1,a1,a4
 8b2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	6318                	ld	a4,0(a4)
 8ba:	fee53823          	sd	a4,-16(a0)
 8be:	a091                	j	902 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c0:	ff852703          	lw	a4,-8(a0)
 8c4:	9e39                	addw	a2,a2,a4
 8c6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8c8:	ff053703          	ld	a4,-16(a0)
 8cc:	e398                	sd	a4,0(a5)
 8ce:	a099                	j	914 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	6398                	ld	a4,0(a5)
 8d2:	00e7e463          	bltu	a5,a4,8da <free+0x40>
 8d6:	00e6ea63          	bltu	a3,a4,8ea <free+0x50>
{
 8da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	fed7fae3          	bgeu	a5,a3,8d0 <free+0x36>
 8e0:	6398                	ld	a4,0(a5)
 8e2:	00e6e463          	bltu	a3,a4,8ea <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e6:	fee7eae3          	bltu	a5,a4,8da <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ea:	ff852583          	lw	a1,-8(a0)
 8ee:	6390                	ld	a2,0(a5)
 8f0:	02059713          	slli	a4,a1,0x20
 8f4:	9301                	srli	a4,a4,0x20
 8f6:	0712                	slli	a4,a4,0x4
 8f8:	9736                	add	a4,a4,a3
 8fa:	fae60ae3          	beq	a2,a4,8ae <free+0x14>
    bp->s.ptr = p->s.ptr;
 8fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 902:	4790                	lw	a2,8(a5)
 904:	02061713          	slli	a4,a2,0x20
 908:	9301                	srli	a4,a4,0x20
 90a:	0712                	slli	a4,a4,0x4
 90c:	973e                	add	a4,a4,a5
 90e:	fae689e3          	beq	a3,a4,8c0 <free+0x26>
  } else
    p->s.ptr = bp;
 912:	e394                	sd	a3,0(a5)
  freep = p;
 914:	00000717          	auipc	a4,0x0
 918:	6ef73a23          	sd	a5,1780(a4) # 1008 <freep>
}
 91c:	6422                	ld	s0,8(sp)
 91e:	0141                	addi	sp,sp,16
 920:	8082                	ret

0000000000000922 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 922:	7139                	addi	sp,sp,-64
 924:	fc06                	sd	ra,56(sp)
 926:	f822                	sd	s0,48(sp)
 928:	f426                	sd	s1,40(sp)
 92a:	f04a                	sd	s2,32(sp)
 92c:	ec4e                	sd	s3,24(sp)
 92e:	e852                	sd	s4,16(sp)
 930:	e456                	sd	s5,8(sp)
 932:	e05a                	sd	s6,0(sp)
 934:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 936:	02051493          	slli	s1,a0,0x20
 93a:	9081                	srli	s1,s1,0x20
 93c:	04bd                	addi	s1,s1,15
 93e:	8091                	srli	s1,s1,0x4
 940:	0014899b          	addiw	s3,s1,1
 944:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 946:	00000517          	auipc	a0,0x0
 94a:	6c253503          	ld	a0,1730(a0) # 1008 <freep>
 94e:	c515                	beqz	a0,97a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	02977f63          	bgeu	a4,s1,992 <malloc+0x70>
 958:	8a4e                	mv	s4,s3
 95a:	0009871b          	sext.w	a4,s3
 95e:	6685                	lui	a3,0x1
 960:	00d77363          	bgeu	a4,a3,966 <malloc+0x44>
 964:	6a05                	lui	s4,0x1
 966:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 96a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96e:	00000917          	auipc	s2,0x0
 972:	69a90913          	addi	s2,s2,1690 # 1008 <freep>
  if(p == (char*)-1)
 976:	5afd                	li	s5,-1
 978:	a0bd                	j	9e6 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 97a:	00019797          	auipc	a5,0x19
 97e:	d3678793          	addi	a5,a5,-714 # 196b0 <base>
 982:	00000717          	auipc	a4,0x0
 986:	68f73323          	sd	a5,1670(a4) # 1008 <freep>
 98a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 990:	b7e1                	j	958 <malloc+0x36>
      if(p->s.size == nunits)
 992:	02e48b63          	beq	s1,a4,9c8 <malloc+0xa6>
        p->s.size -= nunits;
 996:	4137073b          	subw	a4,a4,s3
 99a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99c:	1702                	slli	a4,a4,0x20
 99e:	9301                	srli	a4,a4,0x20
 9a0:	0712                	slli	a4,a4,0x4
 9a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a8:	00000717          	auipc	a4,0x0
 9ac:	66a73023          	sd	a0,1632(a4) # 1008 <freep>
      return (void*)(p + 1);
 9b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9b4:	70e2                	ld	ra,56(sp)
 9b6:	7442                	ld	s0,48(sp)
 9b8:	74a2                	ld	s1,40(sp)
 9ba:	7902                	ld	s2,32(sp)
 9bc:	69e2                	ld	s3,24(sp)
 9be:	6a42                	ld	s4,16(sp)
 9c0:	6aa2                	ld	s5,8(sp)
 9c2:	6b02                	ld	s6,0(sp)
 9c4:	6121                	addi	sp,sp,64
 9c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c8:	6398                	ld	a4,0(a5)
 9ca:	e118                	sd	a4,0(a0)
 9cc:	bff1                	j	9a8 <malloc+0x86>
  hp->s.size = nu;
 9ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d2:	0541                	addi	a0,a0,16
 9d4:	ec7ff0ef          	jal	ra,89a <free>
  return freep;
 9d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9dc:	dd61                	beqz	a0,9b4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	fa9778e3          	bgeu	a4,s1,992 <malloc+0x70>
    if(p == freep)
 9e6:	00093703          	ld	a4,0(s2)
 9ea:	853e                	mv	a0,a5
 9ec:	fef719e3          	bne	a4,a5,9de <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9f0:	8552                	mv	a0,s4
 9f2:	ad5ff0ef          	jal	ra,4c6 <sbrk>
  if(p == (char*)-1)
 9f6:	fd551ce3          	bne	a0,s5,9ce <malloc+0xac>
        return 0;
 9fa:	4501                	li	a0,0
 9fc:	bf65                	j	9b4 <malloc+0x92>
