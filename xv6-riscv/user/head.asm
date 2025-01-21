
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
 10c:	8f898993          	addi	s3,s3,-1800 # a00 <malloc+0xe0>
 110:	85a6                	mv	a1,s1
 112:	854e                	mv	a0,s3
 114:	752000ef          	jal	ra,866 <printf>
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
 180:	88c58593          	addi	a1,a1,-1908 # a08 <malloc+0xe8>
 184:	4509                	li	a0,2
 186:	6b6000ef          	jal	ra,83c <fprintf>
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
 1a2:	88258593          	addi	a1,a1,-1918 # a20 <malloc+0x100>
 1a6:	4509                	li	a0,2
 1a8:	694000ef          	jal	ra,83c <fprintf>
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
 1c8:	87c58593          	addi	a1,a1,-1924 # a40 <malloc+0x120>
 1cc:	4509                	li	a0,2
 1ce:	66e000ef          	jal	ra,83c <fprintf>
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

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	f57ff0ef          	jal	ra,464 <write>
}
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret

000000000000051a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51a:	7139                	addi	sp,sp,-64
 51c:	fc06                	sd	ra,56(sp)
 51e:	f822                	sd	s0,48(sp)
 520:	f426                	sd	s1,40(sp)
 522:	f04a                	sd	s2,32(sp)
 524:	ec4e                	sd	s3,24(sp)
 526:	0080                	addi	s0,sp,64
 528:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52a:	c299                	beqz	a3,530 <printint+0x16>
 52c:	0805c663          	bltz	a1,5b8 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 530:	2581                	sext.w	a1,a1
  neg = 0;
 532:	4881                	li	a7,0
 534:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 538:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53a:	2601                	sext.w	a2,a2
 53c:	00000517          	auipc	a0,0x0
 540:	52450513          	addi	a0,a0,1316 # a60 <digits>
 544:	883a                	mv	a6,a4
 546:	2705                	addiw	a4,a4,1
 548:	02c5f7bb          	remuw	a5,a1,a2
 54c:	1782                	slli	a5,a5,0x20
 54e:	9381                	srli	a5,a5,0x20
 550:	97aa                	add	a5,a5,a0
 552:	0007c783          	lbu	a5,0(a5)
 556:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55a:	0005879b          	sext.w	a5,a1
 55e:	02c5d5bb          	divuw	a1,a1,a2
 562:	0685                	addi	a3,a3,1
 564:	fec7f0e3          	bgeu	a5,a2,544 <printint+0x2a>
  if(neg)
 568:	00088b63          	beqz	a7,57e <printint+0x64>
    buf[i++] = '-';
 56c:	fd040793          	addi	a5,s0,-48
 570:	973e                	add	a4,a4,a5
 572:	02d00793          	li	a5,45
 576:	fef70823          	sb	a5,-16(a4)
 57a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 57e:	02e05663          	blez	a4,5aa <printint+0x90>
 582:	fc040793          	addi	a5,s0,-64
 586:	00e78933          	add	s2,a5,a4
 58a:	fff78993          	addi	s3,a5,-1
 58e:	99ba                	add	s3,s3,a4
 590:	377d                	addiw	a4,a4,-1
 592:	1702                	slli	a4,a4,0x20
 594:	9301                	srli	a4,a4,0x20
 596:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59a:	fff94583          	lbu	a1,-1(s2)
 59e:	8526                	mv	a0,s1
 5a0:	f5dff0ef          	jal	ra,4fc <putc>
  while(--i >= 0)
 5a4:	197d                	addi	s2,s2,-1
 5a6:	ff391ae3          	bne	s2,s3,59a <printint+0x80>
}
 5aa:	70e2                	ld	ra,56(sp)
 5ac:	7442                	ld	s0,48(sp)
 5ae:	74a2                	ld	s1,40(sp)
 5b0:	7902                	ld	s2,32(sp)
 5b2:	69e2                	ld	s3,24(sp)
 5b4:	6121                	addi	sp,sp,64
 5b6:	8082                	ret
    x = -xx;
 5b8:	40b005bb          	negw	a1,a1
    neg = 1;
 5bc:	4885                	li	a7,1
    x = -xx;
 5be:	bf9d                	j	534 <printint+0x1a>

00000000000005c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c0:	7119                	addi	sp,sp,-128
 5c2:	fc86                	sd	ra,120(sp)
 5c4:	f8a2                	sd	s0,112(sp)
 5c6:	f4a6                	sd	s1,104(sp)
 5c8:	f0ca                	sd	s2,96(sp)
 5ca:	ecce                	sd	s3,88(sp)
 5cc:	e8d2                	sd	s4,80(sp)
 5ce:	e4d6                	sd	s5,72(sp)
 5d0:	e0da                	sd	s6,64(sp)
 5d2:	fc5e                	sd	s7,56(sp)
 5d4:	f862                	sd	s8,48(sp)
 5d6:	f466                	sd	s9,40(sp)
 5d8:	f06a                	sd	s10,32(sp)
 5da:	ec6e                	sd	s11,24(sp)
 5dc:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5de:	0005c903          	lbu	s2,0(a1)
 5e2:	22090e63          	beqz	s2,81e <vprintf+0x25e>
 5e6:	8b2a                	mv	s6,a0
 5e8:	8a2e                	mv	s4,a1
 5ea:	8bb2                	mv	s7,a2
  state = 0;
 5ec:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5ee:	4481                	li	s1,0
 5f0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5fa:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5fe:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000c97          	auipc	s9,0x0
 606:	45ec8c93          	addi	s9,s9,1118 # a60 <digits>
 60a:	a005                	j	62a <vprintf+0x6a>
        putc(fd, c0);
 60c:	85ca                	mv	a1,s2
 60e:	855a                	mv	a0,s6
 610:	eedff0ef          	jal	ra,4fc <putc>
 614:	a019                	j	61a <vprintf+0x5a>
    } else if(state == '%'){
 616:	03598263          	beq	s3,s5,63a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 61a:	2485                	addiw	s1,s1,1
 61c:	8726                	mv	a4,s1
 61e:	009a07b3          	add	a5,s4,s1
 622:	0007c903          	lbu	s2,0(a5)
 626:	1e090c63          	beqz	s2,81e <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 62a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62e:	fe0994e3          	bnez	s3,616 <vprintf+0x56>
      if(c0 == '%'){
 632:	fd579de3          	bne	a5,s5,60c <vprintf+0x4c>
        state = '%';
 636:	89be                	mv	s3,a5
 638:	b7cd                	j	61a <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 63a:	cfa5                	beqz	a5,6b2 <vprintf+0xf2>
 63c:	00ea06b3          	add	a3,s4,a4
 640:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 644:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 646:	c681                	beqz	a3,64e <vprintf+0x8e>
 648:	9752                	add	a4,a4,s4
 64a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 64e:	03878a63          	beq	a5,s8,682 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 652:	05a78463          	beq	a5,s10,69a <vprintf+0xda>
      } else if(c0 == 'u'){
 656:	0db78763          	beq	a5,s11,724 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 65a:	07800713          	li	a4,120
 65e:	10e78963          	beq	a5,a4,770 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 662:	07000713          	li	a4,112
 666:	12e78e63          	beq	a5,a4,7a2 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 66a:	07300713          	li	a4,115
 66e:	16e78b63          	beq	a5,a4,7e4 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 672:	05579063          	bne	a5,s5,6b2 <vprintf+0xf2>
        putc(fd, '%');
 676:	85d6                	mv	a1,s5
 678:	855a                	mv	a0,s6
 67a:	e83ff0ef          	jal	ra,4fc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 67e:	4981                	li	s3,0
 680:	bf69                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e8bff0ef          	jal	ra,51a <printint>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	b749                	j	61a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 69a:	03868663          	beq	a3,s8,6c6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69e:	05a68163          	beq	a3,s10,6e0 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 6a2:	09b68d63          	beq	a3,s11,73c <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a6:	03a68f63          	beq	a3,s10,6e4 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6aa:	07800793          	li	a5,120
 6ae:	0cf68d63          	beq	a3,a5,788 <vprintf+0x1c8>
        putc(fd, '%');
 6b2:	85d6                	mv	a1,s5
 6b4:	855a                	mv	a0,s6
 6b6:	e47ff0ef          	jal	ra,4fc <putc>
        putc(fd, c0);
 6ba:	85ca                	mv	a1,s2
 6bc:	855a                	mv	a0,s6
 6be:	e3fff0ef          	jal	ra,4fc <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf99                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e47ff0ef          	jal	ra,51a <printint>
        i += 1;
 6d8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
        i += 1;
 6de:	bf35                	j	61a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e0:	03860563          	beq	a2,s8,70a <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e4:	07b60963          	beq	a2,s11,756 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e8:	07800793          	li	a5,120
 6ec:	fcf613e3          	bne	a2,a5,6b2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4641                	li	a2,16
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	e1dff0ef          	jal	ra,51a <printint>
        i += 2;
 702:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
        i += 2;
 708:	bf09                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4685                	li	a3,1
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	e03ff0ef          	jal	ra,51a <printint>
        i += 2;
 71c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 2;
 722:	bde5                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	de9ff0ef          	jal	ra,51a <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	b5c5                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	008b8913          	addi	s2,s7,8
 740:	4681                	li	a3,0
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	dd1ff0ef          	jal	ra,51a <printint>
        i += 1;
 74e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
        i += 1;
 754:	b5d9                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	db7ff0ef          	jal	ra,51a <printint>
        i += 2;
 768:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
        i += 2;
 76e:	b575                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4641                	li	a2,16
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	d9dff0ef          	jal	ra,51a <printint>
 782:	8bca                	mv	s7,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bd51                	j	61a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 788:	008b8913          	addi	s2,s7,8
 78c:	4681                	li	a3,0
 78e:	4641                	li	a2,16
 790:	000ba583          	lw	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	d85ff0ef          	jal	ra,51a <printint>
        i += 1;
 79a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
        i += 1;
 7a0:	bdad                	j	61a <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 7a2:	008b8793          	addi	a5,s7,8
 7a6:	f8f43423          	sd	a5,-120(s0)
 7aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ae:	03000593          	li	a1,48
 7b2:	855a                	mv	a0,s6
 7b4:	d49ff0ef          	jal	ra,4fc <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	855a                	mv	a0,s6
 7be:	d3fff0ef          	jal	ra,4fc <putc>
 7c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97e6                	add	a5,a5,s9
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d2dff0ef          	jal	ra,4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	397d                	addiw	s2,s2,-1
 7d8:	fe0916e3          	bnez	s2,7c4 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 7dc:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bd25                	j	61a <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7e4:	008b8993          	addi	s3,s7,8
 7e8:	000bb903          	ld	s2,0(s7)
 7ec:	00090f63          	beqz	s2,80a <vprintf+0x24a>
        for(; *s; s++)
 7f0:	00094583          	lbu	a1,0(s2)
 7f4:	c195                	beqz	a1,818 <vprintf+0x258>
          putc(fd, *s);
 7f6:	855a                	mv	a0,s6
 7f8:	d05ff0ef          	jal	ra,4fc <putc>
        for(; *s; s++)
 7fc:	0905                	addi	s2,s2,1
 7fe:	00094583          	lbu	a1,0(s2)
 802:	f9f5                	bnez	a1,7f6 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	bd09                	j	61a <vprintf+0x5a>
          s = "(null)";
 80a:	00000917          	auipc	s2,0x0
 80e:	24e90913          	addi	s2,s2,590 # a58 <malloc+0x138>
        for(; *s; s++)
 812:	02800593          	li	a1,40
 816:	b7c5                	j	7f6 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbfd                	j	61a <vprintf+0x5a>
    }
  }
}
 81e:	70e6                	ld	ra,120(sp)
 820:	7446                	ld	s0,112(sp)
 822:	74a6                	ld	s1,104(sp)
 824:	7906                	ld	s2,96(sp)
 826:	69e6                	ld	s3,88(sp)
 828:	6a46                	ld	s4,80(sp)
 82a:	6aa6                	ld	s5,72(sp)
 82c:	6b06                	ld	s6,64(sp)
 82e:	7be2                	ld	s7,56(sp)
 830:	7c42                	ld	s8,48(sp)
 832:	7ca2                	ld	s9,40(sp)
 834:	7d02                	ld	s10,32(sp)
 836:	6de2                	ld	s11,24(sp)
 838:	6109                	addi	sp,sp,128
 83a:	8082                	ret

000000000000083c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83c:	715d                	addi	sp,sp,-80
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e010                	sd	a2,0(s0)
 846:	e414                	sd	a3,8(s0)
 848:	e818                	sd	a4,16(s0)
 84a:	ec1c                	sd	a5,24(s0)
 84c:	03043023          	sd	a6,32(s0)
 850:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 858:	8622                	mv	a2,s0
 85a:	d67ff0ef          	jal	ra,5c0 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6161                	addi	sp,sp,80
 864:	8082                	ret

0000000000000866 <printf>:

void
printf(const char *fmt, ...)
{
 866:	711d                	addi	sp,sp,-96
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e40c                	sd	a1,8(s0)
 870:	e810                	sd	a2,16(s0)
 872:	ec14                	sd	a3,24(s0)
 874:	f018                	sd	a4,32(s0)
 876:	f41c                	sd	a5,40(s0)
 878:	03043823          	sd	a6,48(s0)
 87c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 880:	00840613          	addi	a2,s0,8
 884:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 888:	85aa                	mv	a1,a0
 88a:	4505                	li	a0,1
 88c:	d35ff0ef          	jal	ra,5c0 <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6125                	addi	sp,sp,96
 896:	8082                	ret

0000000000000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	1141                	addi	sp,sp,-16
 89a:	e422                	sd	s0,8(sp)
 89c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	00000797          	auipc	a5,0x0
 8a6:	7667b783          	ld	a5,1894(a5) # 1008 <freep>
 8aa:	a805                	j	8da <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ac:	4618                	lw	a4,8(a2)
 8ae:	9db9                	addw	a1,a1,a4
 8b0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	6318                	ld	a4,0(a4)
 8b8:	fee53823          	sd	a4,-16(a0)
 8bc:	a091                	j	900 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8be:	ff852703          	lw	a4,-8(a0)
 8c2:	9e39                	addw	a2,a2,a4
 8c4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8c6:	ff053703          	ld	a4,-16(a0)
 8ca:	e398                	sd	a4,0(a5)
 8cc:	a099                	j	912 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e7e463          	bltu	a5,a4,8d8 <free+0x40>
 8d4:	00e6ea63          	bltu	a3,a4,8e8 <free+0x50>
{
 8d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	fed7fae3          	bgeu	a5,a3,8ce <free+0x36>
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e6e463          	bltu	a3,a4,8e8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	fee7eae3          	bltu	a5,a4,8d8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8e8:	ff852583          	lw	a1,-8(a0)
 8ec:	6390                	ld	a2,0(a5)
 8ee:	02059713          	slli	a4,a1,0x20
 8f2:	9301                	srli	a4,a4,0x20
 8f4:	0712                	slli	a4,a4,0x4
 8f6:	9736                	add	a4,a4,a3
 8f8:	fae60ae3          	beq	a2,a4,8ac <free+0x14>
    bp->s.ptr = p->s.ptr;
 8fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 900:	4790                	lw	a2,8(a5)
 902:	02061713          	slli	a4,a2,0x20
 906:	9301                	srli	a4,a4,0x20
 908:	0712                	slli	a4,a4,0x4
 90a:	973e                	add	a4,a4,a5
 90c:	fae689e3          	beq	a3,a4,8be <free+0x26>
  } else
    p->s.ptr = bp;
 910:	e394                	sd	a3,0(a5)
  freep = p;
 912:	00000717          	auipc	a4,0x0
 916:	6ef73b23          	sd	a5,1782(a4) # 1008 <freep>
}
 91a:	6422                	ld	s0,8(sp)
 91c:	0141                	addi	sp,sp,16
 91e:	8082                	ret

0000000000000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	7139                	addi	sp,sp,-64
 922:	fc06                	sd	ra,56(sp)
 924:	f822                	sd	s0,48(sp)
 926:	f426                	sd	s1,40(sp)
 928:	f04a                	sd	s2,32(sp)
 92a:	ec4e                	sd	s3,24(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	e05a                	sd	s6,0(sp)
 932:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 934:	02051493          	slli	s1,a0,0x20
 938:	9081                	srli	s1,s1,0x20
 93a:	04bd                	addi	s1,s1,15
 93c:	8091                	srli	s1,s1,0x4
 93e:	0014899b          	addiw	s3,s1,1
 942:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 944:	00000517          	auipc	a0,0x0
 948:	6c453503          	ld	a0,1732(a0) # 1008 <freep>
 94c:	c515                	beqz	a0,978 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	02977f63          	bgeu	a4,s1,990 <malloc+0x70>
 956:	8a4e                	mv	s4,s3
 958:	0009871b          	sext.w	a4,s3
 95c:	6685                	lui	a3,0x1
 95e:	00d77363          	bgeu	a4,a3,964 <malloc+0x44>
 962:	6a05                	lui	s4,0x1
 964:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 968:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96c:	00000917          	auipc	s2,0x0
 970:	69c90913          	addi	s2,s2,1692 # 1008 <freep>
  if(p == (char*)-1)
 974:	5afd                	li	s5,-1
 976:	a0bd                	j	9e4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 978:	00019797          	auipc	a5,0x19
 97c:	d3878793          	addi	a5,a5,-712 # 196b0 <base>
 980:	00000717          	auipc	a4,0x0
 984:	68f73423          	sd	a5,1672(a4) # 1008 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98e:	b7e1                	j	956 <malloc+0x36>
      if(p->s.size == nunits)
 990:	02e48b63          	beq	s1,a4,9c6 <malloc+0xa6>
        p->s.size -= nunits;
 994:	4137073b          	subw	a4,a4,s3
 998:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99a:	1702                	slli	a4,a4,0x20
 99c:	9301                	srli	a4,a4,0x20
 99e:	0712                	slli	a4,a4,0x4
 9a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a6:	00000717          	auipc	a4,0x0
 9aa:	66a73123          	sd	a0,1634(a4) # 1008 <freep>
      return (void*)(p + 1);
 9ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9b2:	70e2                	ld	ra,56(sp)
 9b4:	7442                	ld	s0,48(sp)
 9b6:	74a2                	ld	s1,40(sp)
 9b8:	7902                	ld	s2,32(sp)
 9ba:	69e2                	ld	s3,24(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	6121                	addi	sp,sp,64
 9c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c6:	6398                	ld	a4,0(a5)
 9c8:	e118                	sd	a4,0(a0)
 9ca:	bff1                	j	9a6 <malloc+0x86>
  hp->s.size = nu;
 9cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d0:	0541                	addi	a0,a0,16
 9d2:	ec7ff0ef          	jal	ra,898 <free>
  return freep;
 9d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9da:	dd61                	beqz	a0,9b2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9de:	4798                	lw	a4,8(a5)
 9e0:	fa9778e3          	bgeu	a4,s1,990 <malloc+0x70>
    if(p == freep)
 9e4:	00093703          	ld	a4,0(s2)
 9e8:	853e                	mv	a0,a5
 9ea:	fef719e3          	bne	a4,a5,9dc <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9ee:	8552                	mv	a0,s4
 9f0:	addff0ef          	jal	ra,4cc <sbrk>
  if(p == (char*)-1)
 9f4:	fd551ce3          	bne	a0,s5,9cc <malloc+0xac>
        return 0;
 9f8:	4501                	li	a0,0
 9fa:	bf65                	j	9b2 <malloc+0x92>
