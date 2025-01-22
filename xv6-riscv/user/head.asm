
user/_head:     file format elf64-littleriscv


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
  56:	406000ef          	jal	ra,45c <read>
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

00000000000000bc <printhead>:

void
printhead(int n)
{
  int i;
  int limit = (n < nlines) ? n : nlines;
  bc:	00001797          	auipc	a5,0x1
  c0:	f447a783          	lw	a5,-188(a5) # 1000 <nlines>
  c4:	0007871b          	sext.w	a4,a5
  c8:	00e55363          	bge	a0,a4,ce <printhead+0x12>
  cc:	87aa                	mv	a5,a0
  ce:	0007871b          	sext.w	a4,a5

  for(i = 0; i < limit; i++)
  d2:	04e05e63          	blez	a4,12e <printhead+0x72>
{
  d6:	7179                	addi	sp,sp,-48
  d8:	f406                	sd	ra,40(sp)
  da:	f022                	sd	s0,32(sp)
  dc:	ec26                	sd	s1,24(sp)
  de:	e84a                	sd	s2,16(sp)
  e0:	e44e                	sd	s3,8(sp)
  e2:	1800                	addi	s0,sp,48
  e4:	00001497          	auipc	s1,0x1
  e8:	f2c48493          	addi	s1,s1,-212 # 1010 <content>
  ec:	fff7891b          	addiw	s2,a5,-1
  f0:	1902                	slli	s2,s2,0x20
  f2:	02095913          	srli	s2,s2,0x20
  f6:	06400793          	li	a5,100
  fa:	02f90933          	mul	s2,s2,a5
  fe:	00001797          	auipc	a5,0x1
 102:	f7678793          	addi	a5,a5,-138 # 1074 <content+0x64>
 106:	993e                	add	s2,s2,a5
    printf("%s\n", content[i]);
 108:	00001997          	auipc	s3,0x1
 10c:	90898993          	addi	s3,s3,-1784 # a10 <malloc+0xe8>
 110:	85a6                	mv	a1,s1
 112:	854e                	mv	a0,s3
 114:	75a000ef          	jal	ra,86e <printf>
  for(i = 0; i < limit; i++)
 118:	06448493          	addi	s1,s1,100
 11c:	ff249ae3          	bne	s1,s2,110 <printhead+0x54>
}
 120:	70a2                	ld	ra,40(sp)
 122:	7402                	ld	s0,32(sp)
 124:	64e2                	ld	s1,24(sp)
 126:	6942                	ld	s2,16(sp)
 128:	69a2                	ld	s3,8(sp)
 12a:	6145                	addi	sp,sp,48
 12c:	8082                	ret
 12e:	8082                	ret

0000000000000130 <main>:

int
main(int argc, char *argv[])
{
 130:	7179                	addi	sp,sp,-48
 132:	f406                	sd	ra,40(sp)
 134:	f022                	sd	s0,32(sp)
 136:	ec26                	sd	s1,24(sp)
 138:	e84a                	sd	s2,16(sp)
 13a:	e44e                	sd	s3,8(sp)
 13c:	1800                	addi	s0,sp,48
  int fd;
  int n = 10;  // Par défaut : 10 premières lignes

  if(argc < 2) {
 13e:	4785                	li	a5,1
 140:	02a7de63          	bge	a5,a0,17c <main+0x4c>
 144:	84aa                	mv	s1,a0
 146:	892e                	mv	s2,a1
    fprintf(2, "Usage: head [-n] file\n");
    exit(1);
  }

  if(argv[1][0] == '-') {
 148:	6588                	ld	a0,8(a1)
 14a:	00054703          	lbu	a4,0(a0)
 14e:	02d00793          	li	a5,45
 152:	02f70f63          	beq	a4,a5,190 <main+0x60>
      fprintf(2, "head: missing file operand\n");
      exit(1);
    }
    fd = open(argv[2], 0);
  } else {
    fd = open(argv[1], 0);
 156:	4581                	li	a1,0
 158:	32c000ef          	jal	ra,484 <open>
 15c:	84aa                	mv	s1,a0
  int n = 10;  // Par défaut : 10 premières lignes
 15e:	49a9                	li	s3,10
  }

  if(fd < 0) {
 160:	0604c063          	bltz	s1,1c0 <main+0x90>
    fprintf(2, "head: cannot open %s\n", argv[1]);
    exit(1);
  }

  readlines(fd);
 164:	8526                	mv	a0,s1
 166:	e9bff0ef          	jal	ra,0 <readlines>
  printhead(n);
 16a:	854e                	mv	a0,s3
 16c:	f51ff0ef          	jal	ra,bc <printhead>

  close(fd);
 170:	8526                	mv	a0,s1
 172:	2fa000ef          	jal	ra,46c <close>
  exit(0);
 176:	4501                	li	a0,0
 178:	2cc000ef          	jal	ra,444 <exit>
    fprintf(2, "Usage: head [-n] file\n");
 17c:	00001597          	auipc	a1,0x1
 180:	89c58593          	addi	a1,a1,-1892 # a18 <malloc+0xf0>
 184:	4509                	li	a0,2
 186:	6be000ef          	jal	ra,844 <fprintf>
    exit(1);
 18a:	4505                	li	a0,1
 18c:	2b8000ef          	jal	ra,444 <exit>
    n = atoi(&argv[1][1]);
 190:	0505                	addi	a0,a0,1
 192:	1ba000ef          	jal	ra,34c <atoi>
 196:	89aa                	mv	s3,a0
    if(argc < 3) {
 198:	4789                	li	a5,2
 19a:	0097cc63          	blt	a5,s1,1b2 <main+0x82>
      fprintf(2, "head: missing file operand\n");
 19e:	00001597          	auipc	a1,0x1
 1a2:	89258593          	addi	a1,a1,-1902 # a30 <malloc+0x108>
 1a6:	4509                	li	a0,2
 1a8:	69c000ef          	jal	ra,844 <fprintf>
      exit(1);
 1ac:	4505                	li	a0,1
 1ae:	296000ef          	jal	ra,444 <exit>
    fd = open(argv[2], 0);
 1b2:	4581                	li	a1,0
 1b4:	01093503          	ld	a0,16(s2)
 1b8:	2cc000ef          	jal	ra,484 <open>
 1bc:	84aa                	mv	s1,a0
 1be:	b74d                	j	160 <main+0x30>
    fprintf(2, "head: cannot open %s\n", argv[1]);
 1c0:	00893603          	ld	a2,8(s2)
 1c4:	00001597          	auipc	a1,0x1
 1c8:	88c58593          	addi	a1,a1,-1908 # a50 <malloc+0x128>
 1cc:	4509                	li	a0,2
 1ce:	676000ef          	jal	ra,844 <fprintf>
    exit(1);
 1d2:	4505                	li	a0,1
 1d4:	270000ef          	jal	ra,444 <exit>

00000000000001d8 <start>:
//


void
start()
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e406                	sd	ra,8(sp)
 1dc:	e022                	sd	s0,0(sp)
 1de:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1e0:	f51ff0ef          	jal	ra,130 <main>
  exit(0);
 1e4:	4501                	li	a0,0
 1e6:	25e000ef          	jal	ra,444 <exit>

00000000000001ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f0:	87aa                	mv	a5,a0
 1f2:	0585                	addi	a1,a1,1
 1f4:	0785                	addi	a5,a5,1
 1f6:	fff5c703          	lbu	a4,-1(a1)
 1fa:	fee78fa3          	sb	a4,-1(a5)
 1fe:	fb75                	bnez	a4,1f2 <strcpy+0x8>
    ;
  return os;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cb91                	beqz	a5,224 <strcmp+0x1e>
 212:	0005c703          	lbu	a4,0(a1)
 216:	00f71763          	bne	a4,a5,224 <strcmp+0x1e>
    p++, q++;
 21a:	0505                	addi	a0,a0,1
 21c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbe5                	bnez	a5,212 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 224:	0005c503          	lbu	a0,0(a1)
}
 228:	40a7853b          	subw	a0,a5,a0
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strlen>:

uint
strlen(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cf91                	beqz	a5,258 <strlen+0x26>
 23e:	0505                	addi	a0,a0,1
 240:	87aa                	mv	a5,a0
 242:	4685                	li	a3,1
 244:	9e89                	subw	a3,a3,a0
 246:	00f6853b          	addw	a0,a3,a5
 24a:	0785                	addi	a5,a5,1
 24c:	fff7c703          	lbu	a4,-1(a5)
 250:	fb7d                	bnez	a4,246 <strlen+0x14>
    ;
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  for(n = 0; s[n]; n++)
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strlen+0x20>

000000000000025c <memset>:

void*
memset(void *dst, int c, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 262:	ca19                	beqz	a2,278 <memset+0x1c>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x12>
  }
  return dst;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <strchr>:

char*
strchr(const char *s, char c)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  for(; *s; s++)
 284:	00054783          	lbu	a5,0(a0)
 288:	cb99                	beqz	a5,29e <strchr+0x20>
    if(*s == c)
 28a:	00f58763          	beq	a1,a5,298 <strchr+0x1a>
  for(; *s; s++)
 28e:	0505                	addi	a0,a0,1
 290:	00054783          	lbu	a5,0(a0)
 294:	fbfd                	bnez	a5,28a <strchr+0xc>
      return (char*)s;
  return 0;
 296:	4501                	li	a0,0
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <strchr+0x1a>

00000000000002a2 <gets>:

char*
gets(char *buf, int max)
{
 2a2:	711d                	addi	sp,sp,-96
 2a4:	ec86                	sd	ra,88(sp)
 2a6:	e8a2                	sd	s0,80(sp)
 2a8:	e4a6                	sd	s1,72(sp)
 2aa:	e0ca                	sd	s2,64(sp)
 2ac:	fc4e                	sd	s3,56(sp)
 2ae:	f852                	sd	s4,48(sp)
 2b0:	f456                	sd	s5,40(sp)
 2b2:	f05a                	sd	s6,32(sp)
 2b4:	ec5e                	sd	s7,24(sp)
 2b6:	1080                	addi	s0,sp,96
 2b8:	8baa                	mv	s7,a0
 2ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bc:	892a                	mv	s2,a0
 2be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c0:	4aa9                	li	s5,10
 2c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2c4:	89a6                	mv	s3,s1
 2c6:	2485                	addiw	s1,s1,1
 2c8:	0344d663          	bge	s1,s4,2f4 <gets+0x52>
    cc = read(0, &c, 1);
 2cc:	4605                	li	a2,1
 2ce:	faf40593          	addi	a1,s0,-81
 2d2:	4501                	li	a0,0
 2d4:	188000ef          	jal	ra,45c <read>
    if(cc < 1)
 2d8:	00a05e63          	blez	a0,2f4 <gets+0x52>
    buf[i++] = c;
 2dc:	faf44783          	lbu	a5,-81(s0)
 2e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2e4:	01578763          	beq	a5,s5,2f2 <gets+0x50>
 2e8:	0905                	addi	s2,s2,1
 2ea:	fd679de3          	bne	a5,s6,2c4 <gets+0x22>
  for(i=0; i+1 < max; ){
 2ee:	89a6                	mv	s3,s1
 2f0:	a011                	j	2f4 <gets+0x52>
 2f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2f4:	99de                	add	s3,s3,s7
 2f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2fa:	855e                	mv	a0,s7
 2fc:	60e6                	ld	ra,88(sp)
 2fe:	6446                	ld	s0,80(sp)
 300:	64a6                	ld	s1,72(sp)
 302:	6906                	ld	s2,64(sp)
 304:	79e2                	ld	s3,56(sp)
 306:	7a42                	ld	s4,48(sp)
 308:	7aa2                	ld	s5,40(sp)
 30a:	7b02                	ld	s6,32(sp)
 30c:	6be2                	ld	s7,24(sp)
 30e:	6125                	addi	sp,sp,96
 310:	8082                	ret

0000000000000312 <stat>:

int
stat(const char *n, struct stat *st)
{
 312:	1101                	addi	sp,sp,-32
 314:	ec06                	sd	ra,24(sp)
 316:	e822                	sd	s0,16(sp)
 318:	e426                	sd	s1,8(sp)
 31a:	e04a                	sd	s2,0(sp)
 31c:	1000                	addi	s0,sp,32
 31e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 320:	4581                	li	a1,0
 322:	162000ef          	jal	ra,484 <open>
  if(fd < 0)
 326:	02054163          	bltz	a0,348 <stat+0x36>
 32a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32c:	85ca                	mv	a1,s2
 32e:	16e000ef          	jal	ra,49c <fstat>
 332:	892a                	mv	s2,a0
  close(fd);
 334:	8526                	mv	a0,s1
 336:	136000ef          	jal	ra,46c <close>
  return r;
}
 33a:	854a                	mv	a0,s2
 33c:	60e2                	ld	ra,24(sp)
 33e:	6442                	ld	s0,16(sp)
 340:	64a2                	ld	s1,8(sp)
 342:	6902                	ld	s2,0(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret
    return -1;
 348:	597d                	li	s2,-1
 34a:	bfc5                	j	33a <stat+0x28>

000000000000034c <atoi>:

int
atoi(const char *s)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 352:	00054603          	lbu	a2,0(a0)
 356:	fd06079b          	addiw	a5,a2,-48
 35a:	0ff7f793          	andi	a5,a5,255
 35e:	4725                	li	a4,9
 360:	02f76963          	bltu	a4,a5,392 <atoi+0x46>
 364:	86aa                	mv	a3,a0
  n = 0;
 366:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 368:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 36a:	0685                	addi	a3,a3,1
 36c:	0025179b          	slliw	a5,a0,0x2
 370:	9fa9                	addw	a5,a5,a0
 372:	0017979b          	slliw	a5,a5,0x1
 376:	9fb1                	addw	a5,a5,a2
 378:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37c:	0006c603          	lbu	a2,0(a3)
 380:	fd06071b          	addiw	a4,a2,-48
 384:	0ff77713          	andi	a4,a4,255
 388:	fee5f1e3          	bgeu	a1,a4,36a <atoi+0x1e>
  return n;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  n = 0;
 392:	4501                	li	a0,0
 394:	bfe5                	j	38c <atoi+0x40>

0000000000000396 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39c:	02b57463          	bgeu	a0,a1,3c4 <memmove+0x2e>
    while(n-- > 0)
 3a0:	00c05f63          	blez	a2,3be <memmove+0x28>
 3a4:	1602                	slli	a2,a2,0x20
 3a6:	9201                	srli	a2,a2,0x20
 3a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ae:	0585                	addi	a1,a1,1
 3b0:	0705                	addi	a4,a4,1
 3b2:	fff5c683          	lbu	a3,-1(a1)
 3b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ba:	fee79ae3          	bne	a5,a4,3ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
    dst += n;
 3c4:	00c50733          	add	a4,a0,a2
    src += n;
 3c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ca:	fec05ae3          	blez	a2,3be <memmove+0x28>
 3ce:	fff6079b          	addiw	a5,a2,-1
 3d2:	1782                	slli	a5,a5,0x20
 3d4:	9381                	srli	a5,a5,0x20
 3d6:	fff7c793          	not	a5,a5
 3da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3dc:	15fd                	addi	a1,a1,-1
 3de:	177d                	addi	a4,a4,-1
 3e0:	0005c683          	lbu	a3,0(a1)
 3e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e8:	fee79ae3          	bne	a5,a4,3dc <memmove+0x46>
 3ec:	bfc9                	j	3be <memmove+0x28>

00000000000003ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f4:	ca05                	beqz	a2,424 <memcmp+0x36>
 3f6:	fff6069b          	addiw	a3,a2,-1
 3fa:	1682                	slli	a3,a3,0x20
 3fc:	9281                	srli	a3,a3,0x20
 3fe:	0685                	addi	a3,a3,1
 400:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 402:	00054783          	lbu	a5,0(a0)
 406:	0005c703          	lbu	a4,0(a1)
 40a:	00e79863          	bne	a5,a4,41a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 40e:	0505                	addi	a0,a0,1
    p2++;
 410:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 412:	fed518e3          	bne	a0,a3,402 <memcmp+0x14>
  }
  return 0;
 416:	4501                	li	a0,0
 418:	a019                	j	41e <memcmp+0x30>
      return *p1 - *p2;
 41a:	40e7853b          	subw	a0,a5,a4
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
  return 0;
 424:	4501                	li	a0,0
 426:	bfe5                	j	41e <memcmp+0x30>

0000000000000428 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e406                	sd	ra,8(sp)
 42c:	e022                	sd	s0,0(sp)
 42e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 430:	f67ff0ef          	jal	ra,396 <memmove>
}
 434:	60a2                	ld	ra,8(sp)
 436:	6402                	ld	s0,0(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret

000000000000043c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43c:	4885                	li	a7,1
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exit>:
.global exit
exit:
 li a7, SYS_exit
 444:	4889                	li	a7,2
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <wait>:
.global wait
wait:
 li a7, SYS_wait
 44c:	488d                	li	a7,3
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 454:	4891                	li	a7,4
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <read>:
.global read
read:
 li a7, SYS_read
 45c:	4895                	li	a7,5
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <write>:
.global write
write:
 li a7, SYS_write
 464:	48c1                	li	a7,16
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <close>:
.global close
close:
 li a7, SYS_close
 46c:	48d5                	li	a7,21
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <kill>:
.global kill
kill:
 li a7, SYS_kill
 474:	4899                	li	a7,6
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <exec>:
.global exec
exec:
 li a7, SYS_exec
 47c:	489d                	li	a7,7
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <open>:
.global open
open:
 li a7, SYS_open
 484:	48bd                	li	a7,15
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48c:	48c5                	li	a7,17
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 494:	48c9                	li	a7,18
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49c:	48a1                	li	a7,8
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <link>:
.global link
link:
 li a7, SYS_link
 4a4:	48cd                	li	a7,19
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ac:	48d1                	li	a7,20
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b4:	48a5                	li	a7,9
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4bc:	48a9                	li	a7,10
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c4:	48ad                	li	a7,11
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4cc:	48b1                	li	a7,12
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d4:	48b5                	li	a7,13
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4dc:	48b9                	li	a7,14
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 4e4:	48d9                	li	a7,22
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 4ec:	48dd                	li	a7,23
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 4f4:	48e1                	li	a7,24
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 4fc:	48e5                	li	a7,25
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 504:	1101                	addi	sp,sp,-32
 506:	ec06                	sd	ra,24(sp)
 508:	e822                	sd	s0,16(sp)
 50a:	1000                	addi	s0,sp,32
 50c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 510:	4605                	li	a2,1
 512:	fef40593          	addi	a1,s0,-17
 516:	f4fff0ef          	jal	ra,464 <write>
}
 51a:	60e2                	ld	ra,24(sp)
 51c:	6442                	ld	s0,16(sp)
 51e:	6105                	addi	sp,sp,32
 520:	8082                	ret

0000000000000522 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 522:	7139                	addi	sp,sp,-64
 524:	fc06                	sd	ra,56(sp)
 526:	f822                	sd	s0,48(sp)
 528:	f426                	sd	s1,40(sp)
 52a:	f04a                	sd	s2,32(sp)
 52c:	ec4e                	sd	s3,24(sp)
 52e:	0080                	addi	s0,sp,64
 530:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 532:	c299                	beqz	a3,538 <printint+0x16>
 534:	0805c663          	bltz	a1,5c0 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 538:	2581                	sext.w	a1,a1
  neg = 0;
 53a:	4881                	li	a7,0
 53c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 540:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 542:	2601                	sext.w	a2,a2
 544:	00000517          	auipc	a0,0x0
 548:	52c50513          	addi	a0,a0,1324 # a70 <digits>
 54c:	883a                	mv	a6,a4
 54e:	2705                	addiw	a4,a4,1
 550:	02c5f7bb          	remuw	a5,a1,a2
 554:	1782                	slli	a5,a5,0x20
 556:	9381                	srli	a5,a5,0x20
 558:	97aa                	add	a5,a5,a0
 55a:	0007c783          	lbu	a5,0(a5)
 55e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 562:	0005879b          	sext.w	a5,a1
 566:	02c5d5bb          	divuw	a1,a1,a2
 56a:	0685                	addi	a3,a3,1
 56c:	fec7f0e3          	bgeu	a5,a2,54c <printint+0x2a>
  if(neg)
 570:	00088b63          	beqz	a7,586 <printint+0x64>
    buf[i++] = '-';
 574:	fd040793          	addi	a5,s0,-48
 578:	973e                	add	a4,a4,a5
 57a:	02d00793          	li	a5,45
 57e:	fef70823          	sb	a5,-16(a4)
 582:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 586:	02e05663          	blez	a4,5b2 <printint+0x90>
 58a:	fc040793          	addi	a5,s0,-64
 58e:	00e78933          	add	s2,a5,a4
 592:	fff78993          	addi	s3,a5,-1
 596:	99ba                	add	s3,s3,a4
 598:	377d                	addiw	a4,a4,-1
 59a:	1702                	slli	a4,a4,0x20
 59c:	9301                	srli	a4,a4,0x20
 59e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a2:	fff94583          	lbu	a1,-1(s2)
 5a6:	8526                	mv	a0,s1
 5a8:	f5dff0ef          	jal	ra,504 <putc>
  while(--i >= 0)
 5ac:	197d                	addi	s2,s2,-1
 5ae:	ff391ae3          	bne	s2,s3,5a2 <printint+0x80>
}
 5b2:	70e2                	ld	ra,56(sp)
 5b4:	7442                	ld	s0,48(sp)
 5b6:	74a2                	ld	s1,40(sp)
 5b8:	7902                	ld	s2,32(sp)
 5ba:	69e2                	ld	s3,24(sp)
 5bc:	6121                	addi	sp,sp,64
 5be:	8082                	ret
    x = -xx;
 5c0:	40b005bb          	negw	a1,a1
    neg = 1;
 5c4:	4885                	li	a7,1
    x = -xx;
 5c6:	bf9d                	j	53c <printint+0x1a>

00000000000005c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c8:	7119                	addi	sp,sp,-128
 5ca:	fc86                	sd	ra,120(sp)
 5cc:	f8a2                	sd	s0,112(sp)
 5ce:	f4a6                	sd	s1,104(sp)
 5d0:	f0ca                	sd	s2,96(sp)
 5d2:	ecce                	sd	s3,88(sp)
 5d4:	e8d2                	sd	s4,80(sp)
 5d6:	e4d6                	sd	s5,72(sp)
 5d8:	e0da                	sd	s6,64(sp)
 5da:	fc5e                	sd	s7,56(sp)
 5dc:	f862                	sd	s8,48(sp)
 5de:	f466                	sd	s9,40(sp)
 5e0:	f06a                	sd	s10,32(sp)
 5e2:	ec6e                	sd	s11,24(sp)
 5e4:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e6:	0005c903          	lbu	s2,0(a1)
 5ea:	22090e63          	beqz	s2,826 <vprintf+0x25e>
 5ee:	8b2a                	mv	s6,a0
 5f0:	8a2e                	mv	s4,a1
 5f2:	8bb2                	mv	s7,a2
  state = 0;
 5f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f6:	4481                	li	s1,0
 5f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 602:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 606:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60a:	00000c97          	auipc	s9,0x0
 60e:	466c8c93          	addi	s9,s9,1126 # a70 <digits>
 612:	a005                	j	632 <vprintf+0x6a>
        putc(fd, c0);
 614:	85ca                	mv	a1,s2
 616:	855a                	mv	a0,s6
 618:	eedff0ef          	jal	ra,504 <putc>
 61c:	a019                	j	622 <vprintf+0x5a>
    } else if(state == '%'){
 61e:	03598263          	beq	s3,s5,642 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 622:	2485                	addiw	s1,s1,1
 624:	8726                	mv	a4,s1
 626:	009a07b3          	add	a5,s4,s1
 62a:	0007c903          	lbu	s2,0(a5)
 62e:	1e090c63          	beqz	s2,826 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 632:	0009079b          	sext.w	a5,s2
    if(state == 0){
 636:	fe0994e3          	bnez	s3,61e <vprintf+0x56>
      if(c0 == '%'){
 63a:	fd579de3          	bne	a5,s5,614 <vprintf+0x4c>
        state = '%';
 63e:	89be                	mv	s3,a5
 640:	b7cd                	j	622 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 642:	cfa5                	beqz	a5,6ba <vprintf+0xf2>
 644:	00ea06b3          	add	a3,s4,a4
 648:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 64c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 64e:	c681                	beqz	a3,656 <vprintf+0x8e>
 650:	9752                	add	a4,a4,s4
 652:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 656:	03878a63          	beq	a5,s8,68a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 65a:	05a78463          	beq	a5,s10,6a2 <vprintf+0xda>
      } else if(c0 == 'u'){
 65e:	0db78763          	beq	a5,s11,72c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 662:	07800713          	li	a4,120
 666:	10e78963          	beq	a5,a4,778 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 66a:	07000713          	li	a4,112
 66e:	12e78e63          	beq	a5,a4,7aa <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 672:	07300713          	li	a4,115
 676:	16e78b63          	beq	a5,a4,7ec <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 67a:	05579063          	bne	a5,s5,6ba <vprintf+0xf2>
        putc(fd, '%');
 67e:	85d6                	mv	a1,s5
 680:	855a                	mv	a0,s6
 682:	e83ff0ef          	jal	ra,504 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 686:	4981                	li	s3,0
 688:	bf69                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e8bff0ef          	jal	ra,522 <printint>
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b749                	j	622 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	03868663          	beq	a3,s8,6ce <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a6:	05a68163          	beq	a3,s10,6e8 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 6aa:	09b68d63          	beq	a3,s11,744 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ae:	03a68f63          	beq	a3,s10,6ec <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6b2:	07800793          	li	a5,120
 6b6:	0cf68d63          	beq	a3,a5,790 <vprintf+0x1c8>
        putc(fd, '%');
 6ba:	85d6                	mv	a1,s5
 6bc:	855a                	mv	a0,s6
 6be:	e47ff0ef          	jal	ra,504 <putc>
        putc(fd, c0);
 6c2:	85ca                	mv	a1,s2
 6c4:	855a                	mv	a0,s6
 6c6:	e3fff0ef          	jal	ra,504 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bf99                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4685                	li	a3,1
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e47ff0ef          	jal	ra,522 <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	bf35                	j	622 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e8:	03860563          	beq	a2,s8,712 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ec:	07b60963          	beq	a2,s11,75e <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f0:	07800793          	li	a5,120
 6f4:	fcf613e3          	bne	a2,a5,6ba <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e1dff0ef          	jal	ra,522 <printint>
        i += 2;
 70a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	bf09                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 712:	008b8913          	addi	s2,s7,8
 716:	4685                	li	a3,1
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	e03ff0ef          	jal	ra,522 <printint>
        i += 2;
 724:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	bde5                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	de9ff0ef          	jal	ra,522 <printint>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	b5c5                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	008b8913          	addi	s2,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	dd1ff0ef          	jal	ra,522 <printint>
        i += 1;
 756:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
        i += 1;
 75c:	b5d9                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b8913          	addi	s2,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	db7ff0ef          	jal	ra,522 <printint>
        i += 2;
 770:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
        i += 2;
 776:	b575                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 778:	008b8913          	addi	s2,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	d9dff0ef          	jal	ra,522 <printint>
 78a:	8bca                	mv	s7,s2
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bd51                	j	622 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 790:	008b8913          	addi	s2,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	d85ff0ef          	jal	ra,522 <printint>
        i += 1;
 7a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	8bca                	mv	s7,s2
      state = 0;
 7a6:	4981                	li	s3,0
        i += 1;
 7a8:	bdad                	j	622 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 7aa:	008b8793          	addi	a5,s7,8
 7ae:	f8f43423          	sd	a5,-120(s0)
 7b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b6:	03000593          	li	a1,48
 7ba:	855a                	mv	a0,s6
 7bc:	d49ff0ef          	jal	ra,504 <putc>
  putc(fd, 'x');
 7c0:	07800593          	li	a1,120
 7c4:	855a                	mv	a0,s6
 7c6:	d3fff0ef          	jal	ra,504 <putc>
 7ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7cc:	03c9d793          	srli	a5,s3,0x3c
 7d0:	97e6                	add	a5,a5,s9
 7d2:	0007c583          	lbu	a1,0(a5)
 7d6:	855a                	mv	a0,s6
 7d8:	d2dff0ef          	jal	ra,504 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7dc:	0992                	slli	s3,s3,0x4
 7de:	397d                	addiw	s2,s2,-1
 7e0:	fe0916e3          	bnez	s2,7cc <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 7e4:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bd25                	j	622 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7ec:	008b8993          	addi	s3,s7,8
 7f0:	000bb903          	ld	s2,0(s7)
 7f4:	00090f63          	beqz	s2,812 <vprintf+0x24a>
        for(; *s; s++)
 7f8:	00094583          	lbu	a1,0(s2)
 7fc:	c195                	beqz	a1,820 <vprintf+0x258>
          putc(fd, *s);
 7fe:	855a                	mv	a0,s6
 800:	d05ff0ef          	jal	ra,504 <putc>
        for(; *s; s++)
 804:	0905                	addi	s2,s2,1
 806:	00094583          	lbu	a1,0(s2)
 80a:	f9f5                	bnez	a1,7fe <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 80c:	8bce                	mv	s7,s3
      state = 0;
 80e:	4981                	li	s3,0
 810:	bd09                	j	622 <vprintf+0x5a>
          s = "(null)";
 812:	00000917          	auipc	s2,0x0
 816:	25690913          	addi	s2,s2,598 # a68 <malloc+0x140>
        for(; *s; s++)
 81a:	02800593          	li	a1,40
 81e:	b7c5                	j	7fe <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 820:	8bce                	mv	s7,s3
      state = 0;
 822:	4981                	li	s3,0
 824:	bbfd                	j	622 <vprintf+0x5a>
    }
  }
}
 826:	70e6                	ld	ra,120(sp)
 828:	7446                	ld	s0,112(sp)
 82a:	74a6                	ld	s1,104(sp)
 82c:	7906                	ld	s2,96(sp)
 82e:	69e6                	ld	s3,88(sp)
 830:	6a46                	ld	s4,80(sp)
 832:	6aa6                	ld	s5,72(sp)
 834:	6b06                	ld	s6,64(sp)
 836:	7be2                	ld	s7,56(sp)
 838:	7c42                	ld	s8,48(sp)
 83a:	7ca2                	ld	s9,40(sp)
 83c:	7d02                	ld	s10,32(sp)
 83e:	6de2                	ld	s11,24(sp)
 840:	6109                	addi	sp,sp,128
 842:	8082                	ret

0000000000000844 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 844:	715d                	addi	sp,sp,-80
 846:	ec06                	sd	ra,24(sp)
 848:	e822                	sd	s0,16(sp)
 84a:	1000                	addi	s0,sp,32
 84c:	e010                	sd	a2,0(s0)
 84e:	e414                	sd	a3,8(s0)
 850:	e818                	sd	a4,16(s0)
 852:	ec1c                	sd	a5,24(s0)
 854:	03043023          	sd	a6,32(s0)
 858:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 85c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 860:	8622                	mv	a2,s0
 862:	d67ff0ef          	jal	ra,5c8 <vprintf>
}
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6161                	addi	sp,sp,80
 86c:	8082                	ret

000000000000086e <printf>:

void
printf(const char *fmt, ...)
{
 86e:	711d                	addi	sp,sp,-96
 870:	ec06                	sd	ra,24(sp)
 872:	e822                	sd	s0,16(sp)
 874:	1000                	addi	s0,sp,32
 876:	e40c                	sd	a1,8(s0)
 878:	e810                	sd	a2,16(s0)
 87a:	ec14                	sd	a3,24(s0)
 87c:	f018                	sd	a4,32(s0)
 87e:	f41c                	sd	a5,40(s0)
 880:	03043823          	sd	a6,48(s0)
 884:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 888:	00840613          	addi	a2,s0,8
 88c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 890:	85aa                	mv	a1,a0
 892:	4505                	li	a0,1
 894:	d35ff0ef          	jal	ra,5c8 <vprintf>
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	6125                	addi	sp,sp,96
 89e:	8082                	ret

00000000000008a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a0:	1141                	addi	sp,sp,-16
 8a2:	e422                	sd	s0,8(sp)
 8a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	00000797          	auipc	a5,0x0
 8ae:	75e7b783          	ld	a5,1886(a5) # 1008 <freep>
 8b2:	a805                	j	8e2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b4:	4618                	lw	a4,8(a2)
 8b6:	9db9                	addw	a1,a1,a4
 8b8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	6398                	ld	a4,0(a5)
 8be:	6318                	ld	a4,0(a4)
 8c0:	fee53823          	sd	a4,-16(a0)
 8c4:	a091                	j	908 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c6:	ff852703          	lw	a4,-8(a0)
 8ca:	9e39                	addw	a2,a2,a4
 8cc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ce:	ff053703          	ld	a4,-16(a0)
 8d2:	e398                	sd	a4,0(a5)
 8d4:	a099                	j	91a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e7e463          	bltu	a5,a4,8e0 <free+0x40>
 8dc:	00e6ea63          	bltu	a3,a4,8f0 <free+0x50>
{
 8e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	fed7fae3          	bgeu	a5,a3,8d6 <free+0x36>
 8e6:	6398                	ld	a4,0(a5)
 8e8:	00e6e463          	bltu	a3,a4,8f0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ec:	fee7eae3          	bltu	a5,a4,8e0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8f0:	ff852583          	lw	a1,-8(a0)
 8f4:	6390                	ld	a2,0(a5)
 8f6:	02059713          	slli	a4,a1,0x20
 8fa:	9301                	srli	a4,a4,0x20
 8fc:	0712                	slli	a4,a4,0x4
 8fe:	9736                	add	a4,a4,a3
 900:	fae60ae3          	beq	a2,a4,8b4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 904:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 908:	4790                	lw	a2,8(a5)
 90a:	02061713          	slli	a4,a2,0x20
 90e:	9301                	srli	a4,a4,0x20
 910:	0712                	slli	a4,a4,0x4
 912:	973e                	add	a4,a4,a5
 914:	fae689e3          	beq	a3,a4,8c6 <free+0x26>
  } else
    p->s.ptr = bp;
 918:	e394                	sd	a3,0(a5)
  freep = p;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ef73723          	sd	a5,1774(a4) # 1008 <freep>
}
 922:	6422                	ld	s0,8(sp)
 924:	0141                	addi	sp,sp,16
 926:	8082                	ret

0000000000000928 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 928:	7139                	addi	sp,sp,-64
 92a:	fc06                	sd	ra,56(sp)
 92c:	f822                	sd	s0,48(sp)
 92e:	f426                	sd	s1,40(sp)
 930:	f04a                	sd	s2,32(sp)
 932:	ec4e                	sd	s3,24(sp)
 934:	e852                	sd	s4,16(sp)
 936:	e456                	sd	s5,8(sp)
 938:	e05a                	sd	s6,0(sp)
 93a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93c:	02051493          	slli	s1,a0,0x20
 940:	9081                	srli	s1,s1,0x20
 942:	04bd                	addi	s1,s1,15
 944:	8091                	srli	s1,s1,0x4
 946:	0014899b          	addiw	s3,s1,1
 94a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 94c:	00000517          	auipc	a0,0x0
 950:	6bc53503          	ld	a0,1724(a0) # 1008 <freep>
 954:	c515                	beqz	a0,980 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 958:	4798                	lw	a4,8(a5)
 95a:	02977f63          	bgeu	a4,s1,998 <malloc+0x70>
 95e:	8a4e                	mv	s4,s3
 960:	0009871b          	sext.w	a4,s3
 964:	6685                	lui	a3,0x1
 966:	00d77363          	bgeu	a4,a3,96c <malloc+0x44>
 96a:	6a05                	lui	s4,0x1
 96c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 970:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 974:	00000917          	auipc	s2,0x0
 978:	69490913          	addi	s2,s2,1684 # 1008 <freep>
  if(p == (char*)-1)
 97c:	5afd                	li	s5,-1
 97e:	a0bd                	j	9ec <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 980:	00019797          	auipc	a5,0x19
 984:	d3078793          	addi	a5,a5,-720 # 196b0 <base>
 988:	00000717          	auipc	a4,0x0
 98c:	68f73023          	sd	a5,1664(a4) # 1008 <freep>
 990:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 992:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 996:	b7e1                	j	95e <malloc+0x36>
      if(p->s.size == nunits)
 998:	02e48b63          	beq	s1,a4,9ce <malloc+0xa6>
        p->s.size -= nunits;
 99c:	4137073b          	subw	a4,a4,s3
 9a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a2:	1702                	slli	a4,a4,0x20
 9a4:	9301                	srli	a4,a4,0x20
 9a6:	0712                	slli	a4,a4,0x4
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64a73d23          	sd	a0,1626(a4) # 1008 <freep>
      return (void*)(p + 1);
 9b6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	7902                	ld	s2,32(sp)
 9c2:	69e2                	ld	s3,24(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	6121                	addi	sp,sp,64
 9cc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	e118                	sd	a4,0(a0)
 9d2:	bff1                	j	9ae <malloc+0x86>
  hp->s.size = nu;
 9d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d8:	0541                	addi	a0,a0,16
 9da:	ec7ff0ef          	jal	ra,8a0 <free>
  return freep;
 9de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e2:	dd61                	beqz	a0,9ba <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	fa9778e3          	bgeu	a4,s1,998 <malloc+0x70>
    if(p == freep)
 9ec:	00093703          	ld	a4,0(s2)
 9f0:	853e                	mv	a0,a5
 9f2:	fef719e3          	bne	a4,a5,9e4 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9f6:	8552                	mv	a0,s4
 9f8:	ad5ff0ef          	jal	ra,4cc <sbrk>
  if(p == (char*)-1)
 9fc:	fd551ce3          	bne	a0,s5,9d4 <malloc+0xac>
        return 0;
 a00:	4501                	li	a0,0
 a02:	bf65                	j	9ba <malloc+0x92>
