
user/_sort:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <swap>:
char content[MAXLINES][MAXLEN];
int nlines = 0;

void
swap(int i, int j)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  char *temp = lines[i];
   6:	00019797          	auipc	a5,0x19
   a:	6aa78793          	addi	a5,a5,1706 # 196b0 <lines>
   e:	050e                	slli	a0,a0,0x3
  10:	953e                	add	a0,a0,a5
  12:	6118                	ld	a4,0(a0)
  lines[i] = lines[j];
  14:	058e                	slli	a1,a1,0x3
  16:	97ae                	add	a5,a5,a1
  18:	6394                	ld	a3,0(a5)
  1a:	e114                	sd	a3,0(a0)
  lines[j] = temp;
  1c:	e398                	sd	a4,0(a5)
}
  1e:	6422                	ld	s0,8(sp)
  20:	0141                	addi	sp,sp,16
  22:	8082                	ret

0000000000000024 <qsort>:
void
qsort(int left, int right)
{
  int i, last;

  if(left >= right)
  24:	00b54363          	blt	a0,a1,2a <qsort+0x6>
  28:	8082                	ret
{
  2a:	7139                	addi	sp,sp,-64
  2c:	fc06                	sd	ra,56(sp)
  2e:	f822                	sd	s0,48(sp)
  30:	f426                	sd	s1,40(sp)
  32:	f04a                	sd	s2,32(sp)
  34:	ec4e                	sd	s3,24(sp)
  36:	e852                	sd	s4,16(sp)
  38:	e456                	sd	s5,8(sp)
  3a:	e05a                	sd	s6,0(sp)
  3c:	0080                	addi	s0,sp,64
  3e:	8b2a                	mv	s6,a0
  40:	89ae                	mv	s3,a1
    return;

  swap(left, (left + right)/2);
  42:	00b507bb          	addw	a5,a0,a1
  46:	01f7d59b          	srliw	a1,a5,0x1f
  4a:	9dbd                	addw	a1,a1,a5
  4c:	4015d59b          	sraiw	a1,a1,0x1
  50:	fb1ff0ef          	jal	ra,0 <swap>
  last = left;

  for(i = left + 1; i <= right; i++)
  54:	001b091b          	addiw	s2,s6,1
  58:	0529c463          	blt	s3,s2,a0 <qsort+0x7c>
  5c:	001b0493          	addi	s1,s6,1
  60:	048e                	slli	s1,s1,0x3
  62:	00019797          	auipc	a5,0x19
  66:	64e78793          	addi	a5,a5,1614 # 196b0 <lines>
  6a:	94be                	add	s1,s1,a5
  last = left;
  6c:	8ada                	mv	s5,s6
    if(strcmp(lines[i], lines[left]) < 0)
  6e:	003b1793          	slli	a5,s6,0x3
  72:	00019a17          	auipc	s4,0x19
  76:	63ea0a13          	addi	s4,s4,1598 # 196b0 <lines>
  7a:	9a3e                	add	s4,s4,a5
  7c:	a029                	j	86 <qsort+0x62>
  for(i = left + 1; i <= right; i++)
  7e:	2905                	addiw	s2,s2,1
  80:	04a1                	addi	s1,s1,8
  82:	0329c063          	blt	s3,s2,a2 <qsort+0x7e>
    if(strcmp(lines[i], lines[left]) < 0)
  86:	000a3583          	ld	a1,0(s4)
  8a:	6088                	ld	a0,0(s1)
  8c:	1b6000ef          	jal	ra,242 <strcmp>
  90:	fe0557e3          	bgez	a0,7e <qsort+0x5a>
      swap(++last, i);
  94:	2a85                	addiw	s5,s5,1
  96:	85ca                	mv	a1,s2
  98:	8556                	mv	a0,s5
  9a:	f67ff0ef          	jal	ra,0 <swap>
  9e:	b7c5                	j	7e <qsort+0x5a>
  last = left;
  a0:	8ada                	mv	s5,s6

  swap(left, last);
  a2:	85d6                	mv	a1,s5
  a4:	855a                	mv	a0,s6
  a6:	f5bff0ef          	jal	ra,0 <swap>
  qsort(left, last-1);
  aa:	fffa859b          	addiw	a1,s5,-1
  ae:	855a                	mv	a0,s6
  b0:	f75ff0ef          	jal	ra,24 <qsort>
  qsort(last+1, right);
  b4:	85ce                	mv	a1,s3
  b6:	001a851b          	addiw	a0,s5,1
  ba:	f6bff0ef          	jal	ra,24 <qsort>
}
  be:	70e2                	ld	ra,56(sp)
  c0:	7442                	ld	s0,48(sp)
  c2:	74a2                	ld	s1,40(sp)
  c4:	7902                	ld	s2,32(sp)
  c6:	69e2                	ld	s3,24(sp)
  c8:	6a42                	ld	s4,16(sp)
  ca:	6aa2                	ld	s5,8(sp)
  cc:	6b02                	ld	s6,0(sp)
  ce:	6121                	addi	sp,sp,64
  d0:	8082                	ret

00000000000000d2 <main>:

int
main(int argc, char *argv[])
{
  d2:	7159                	addi	sp,sp,-112
  d4:	f486                	sd	ra,104(sp)
  d6:	f0a2                	sd	s0,96(sp)
  d8:	eca6                	sd	s1,88(sp)
  da:	e8ca                	sd	s2,80(sp)
  dc:	e4ce                	sd	s3,72(sp)
  de:	e0d2                	sd	s4,64(sp)
  e0:	fc56                	sd	s5,56(sp)
  e2:	f85a                	sd	s6,48(sp)
  e4:	f45e                	sd	s7,40(sp)
  e6:	f062                	sd	s8,32(sp)
  e8:	ec66                	sd	s9,24(sp)
  ea:	e86a                	sd	s10,16(sp)
  ec:	1880                	addi	s0,sp,112
  char buf;
  int i = 0, j = 0;
  int fd = 0;

  if(argc > 1) {
  ee:	4785                	li	a5,1
  int fd = 0;
  f0:	4981                	li	s3,0
  if(argc > 1) {
  f2:	02a7ca63          	blt	a5,a0,126 <main+0x54>
      exit(1);
    }
  }

  // Initialiser la première ligne
  lines[0] = content[0];
  f6:	00001797          	auipc	a5,0x1
  fa:	f1a78793          	addi	a5,a5,-230 # 1010 <content>
  fe:	00019717          	auipc	a4,0x19
 102:	5af73923          	sd	a5,1458(a4) # 196b0 <lines>
  int i = 0, j = 0;
 106:	4901                	li	s2,0
 108:	4481                	li	s1,0
  
  // Lire le fichier caractère par caractère
  while(read(fd, &buf, 1) == 1) {
    if(buf == '\n') {
 10a:	4a29                	li	s4,10
      i++;
      if(i >= MAXLINES) break;
      lines[i] = content[i];
      j = 0;
    } else {
      if(j < MAXLEN-1)
 10c:	06200b93          	li	s7,98
        content[i][j++] = buf;
 110:	8b3e                	mv	s6,a5
 112:	06400a93          	li	s5,100
      if(i >= MAXLINES) break;
 116:	3e700c13          	li	s8,999
      lines[i] = content[i];
 11a:	00019d17          	auipc	s10,0x19
 11e:	596d0d13          	addi	s10,s10,1430 # 196b0 <lines>
      j = 0;
 122:	4c81                	li	s9,0
  while(read(fd, &buf, 1) == 1) {
 124:	a0a9                	j	16e <main+0x9c>
 126:	84ae                	mv	s1,a1
    if((fd = open(argv[1], 0)) < 0) {
 128:	4581                	li	a1,0
 12a:	6488                	ld	a0,8(s1)
 12c:	394000ef          	jal	ra,4c0 <open>
 130:	89aa                	mv	s3,a0
 132:	fc0552e3          	bgez	a0,f6 <main+0x24>
      fprintf(2, "sort: cannot open %s\n", argv[1]);
 136:	6490                	ld	a2,8(s1)
 138:	00001597          	auipc	a1,0x1
 13c:	90858593          	addi	a1,a1,-1784 # a40 <malloc+0xe4>
 140:	4509                	li	a0,2
 142:	736000ef          	jal	ra,878 <fprintf>
      exit(1);
 146:	4505                	li	a0,1
 148:	338000ef          	jal	ra,480 <exit>
      content[i][j] = '\0';
 14c:	035487b3          	mul	a5,s1,s5
 150:	97da                	add	a5,a5,s6
 152:	97ca                	add	a5,a5,s2
 154:	00078023          	sb	zero,0(a5)
      i++;
 158:	2485                	addiw	s1,s1,1
      if(i >= MAXLINES) break;
 15a:	049c4163          	blt	s8,s1,19c <main+0xca>
      lines[i] = content[i];
 15e:	00349793          	slli	a5,s1,0x3
 162:	97ea                	add	a5,a5,s10
 164:	03548733          	mul	a4,s1,s5
 168:	975a                	add	a4,a4,s6
 16a:	e398                	sd	a4,0(a5)
      j = 0;
 16c:	8966                	mv	s2,s9
  while(read(fd, &buf, 1) == 1) {
 16e:	4605                	li	a2,1
 170:	f9f40593          	addi	a1,s0,-97
 174:	854e                	mv	a0,s3
 176:	322000ef          	jal	ra,498 <read>
 17a:	4785                	li	a5,1
 17c:	02f51063          	bne	a0,a5,19c <main+0xca>
    if(buf == '\n') {
 180:	f9f44783          	lbu	a5,-97(s0)
 184:	fd4784e3          	beq	a5,s4,14c <main+0x7a>
      if(j < MAXLEN-1)
 188:	ff2bc3e3          	blt	s7,s2,16e <main+0x9c>
        content[i][j++] = buf;
 18c:	03548733          	mul	a4,s1,s5
 190:	975a                	add	a4,a4,s6
 192:	974a                	add	a4,a4,s2
 194:	00f70023          	sb	a5,0(a4)
 198:	2905                	addiw	s2,s2,1
 19a:	bfd1                	j	16e <main+0x9c>
    }
  }
  
  // Gérer la dernière ligne si elle n'a pas de \n
  if(j > 0) {
 19c:	01205f63          	blez	s2,1ba <main+0xe8>
    content[i][j] = '\0';
 1a0:	06400793          	li	a5,100
 1a4:	02f48733          	mul	a4,s1,a5
 1a8:	00001797          	auipc	a5,0x1
 1ac:	e6878793          	addi	a5,a5,-408 # 1010 <content>
 1b0:	97ba                	add	a5,a5,a4
 1b2:	993e                	add	s2,s2,a5
 1b4:	00090023          	sb	zero,0(s2)
    i++;
 1b8:	2485                	addiw	s1,s1,1
  }

  nlines = i;
 1ba:	00001917          	auipc	s2,0x1
 1be:	e4690913          	addi	s2,s2,-442 # 1000 <nlines>
 1c2:	00992023          	sw	s1,0(s2)

  // Trier et afficher
  qsort(0, nlines-1);
 1c6:	fff4859b          	addiw	a1,s1,-1
 1ca:	4501                	li	a0,0
 1cc:	e59ff0ef          	jal	ra,24 <qsort>
  for(i = 0; i < nlines; i++)
 1d0:	00092783          	lw	a5,0(s2)
 1d4:	02f05a63          	blez	a5,208 <main+0x136>
 1d8:	00019917          	auipc	s2,0x19
 1dc:	4d890913          	addi	s2,s2,1240 # 196b0 <lines>
 1e0:	4481                	li	s1,0
    printf("%s\n", lines[i]);
 1e2:	00001a97          	auipc	s5,0x1
 1e6:	876a8a93          	addi	s5,s5,-1930 # a58 <malloc+0xfc>
  for(i = 0; i < nlines; i++)
 1ea:	00001a17          	auipc	s4,0x1
 1ee:	e16a0a13          	addi	s4,s4,-490 # 1000 <nlines>
    printf("%s\n", lines[i]);
 1f2:	00093583          	ld	a1,0(s2)
 1f6:	8556                	mv	a0,s5
 1f8:	6aa000ef          	jal	ra,8a2 <printf>
  for(i = 0; i < nlines; i++)
 1fc:	2485                	addiw	s1,s1,1
 1fe:	0921                	addi	s2,s2,8
 200:	000a2783          	lw	a5,0(s4)
 204:	fef4c7e3          	blt	s1,a5,1f2 <main+0x120>

  close(fd);
 208:	854e                	mv	a0,s3
 20a:	29e000ef          	jal	ra,4a8 <close>
  exit(0);
 20e:	4501                	li	a0,0
 210:	270000ef          	jal	ra,480 <exit>

0000000000000214 <start>:
//


void
start()
{
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 21c:	eb7ff0ef          	jal	ra,d2 <main>
  exit(0);
 220:	4501                	li	a0,0
 222:	25e000ef          	jal	ra,480 <exit>

0000000000000226 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22c:	87aa                	mv	a5,a0
 22e:	0585                	addi	a1,a1,1
 230:	0785                	addi	a5,a5,1
 232:	fff5c703          	lbu	a4,-1(a1)
 236:	fee78fa3          	sb	a4,-1(a5)
 23a:	fb75                	bnez	a4,22e <strcpy+0x8>
    ;
  return os;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb91                	beqz	a5,260 <strcmp+0x1e>
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00f71763          	bne	a4,a5,260 <strcmp+0x1e>
    p++, q++;
 256:	0505                	addi	a0,a0,1
 258:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbe5                	bnez	a5,24e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 260:	0005c503          	lbu	a0,0(a1)
}
 264:	40a7853b          	subw	a0,a5,a0
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strlen>:

uint
strlen(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 274:	00054783          	lbu	a5,0(a0)
 278:	cf91                	beqz	a5,294 <strlen+0x26>
 27a:	0505                	addi	a0,a0,1
 27c:	87aa                	mv	a5,a0
 27e:	4685                	li	a3,1
 280:	9e89                	subw	a3,a3,a0
 282:	00f6853b          	addw	a0,a3,a5
 286:	0785                	addi	a5,a5,1
 288:	fff7c703          	lbu	a4,-1(a5)
 28c:	fb7d                	bnez	a4,282 <strlen+0x14>
    ;
  return n;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  for(n = 0; s[n]; n++)
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strlen+0x20>

0000000000000298 <memset>:

void*
memset(void *dst, int c, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 29e:	ca19                	beqz	a2,2b4 <memset+0x1c>
 2a0:	87aa                	mv	a5,a0
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ae:	0785                	addi	a5,a5,1
 2b0:	fee79de3          	bne	a5,a4,2aa <memset+0x12>
  }
  return dst;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strchr>:

char*
strchr(const char *s, char c)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb99                	beqz	a5,2da <strchr+0x20>
    if(*s == c)
 2c6:	00f58763          	beq	a1,a5,2d4 <strchr+0x1a>
  for(; *s; s++)
 2ca:	0505                	addi	a0,a0,1
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbfd                	bnez	a5,2c6 <strchr+0xc>
      return (char*)s;
  return 0;
 2d2:	4501                	li	a0,0
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strchr+0x1a>

00000000000002de <gets>:

char*
gets(char *buf, int max)
{
 2de:	711d                	addi	sp,sp,-96
 2e0:	ec86                	sd	ra,88(sp)
 2e2:	e8a2                	sd	s0,80(sp)
 2e4:	e4a6                	sd	s1,72(sp)
 2e6:	e0ca                	sd	s2,64(sp)
 2e8:	fc4e                	sd	s3,56(sp)
 2ea:	f852                	sd	s4,48(sp)
 2ec:	f456                	sd	s5,40(sp)
 2ee:	f05a                	sd	s6,32(sp)
 2f0:	ec5e                	sd	s7,24(sp)
 2f2:	1080                	addi	s0,sp,96
 2f4:	8baa                	mv	s7,a0
 2f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f8:	892a                	mv	s2,a0
 2fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fc:	4aa9                	li	s5,10
 2fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 300:	89a6                	mv	s3,s1
 302:	2485                	addiw	s1,s1,1
 304:	0344d663          	bge	s1,s4,330 <gets+0x52>
    cc = read(0, &c, 1);
 308:	4605                	li	a2,1
 30a:	faf40593          	addi	a1,s0,-81
 30e:	4501                	li	a0,0
 310:	188000ef          	jal	ra,498 <read>
    if(cc < 1)
 314:	00a05e63          	blez	a0,330 <gets+0x52>
    buf[i++] = c;
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 320:	01578763          	beq	a5,s5,32e <gets+0x50>
 324:	0905                	addi	s2,s2,1
 326:	fd679de3          	bne	a5,s6,300 <gets+0x22>
  for(i=0; i+1 < max; ){
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x52>
 32e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
  return buf;
}
 336:	855e                	mv	a0,s7
 338:	60e6                	ld	ra,88(sp)
 33a:	6446                	ld	s0,80(sp)
 33c:	64a6                	ld	s1,72(sp)
 33e:	6906                	ld	s2,64(sp)
 340:	79e2                	ld	s3,56(sp)
 342:	7a42                	ld	s4,48(sp)
 344:	7aa2                	ld	s5,40(sp)
 346:	7b02                	ld	s6,32(sp)
 348:	6be2                	ld	s7,24(sp)
 34a:	6125                	addi	sp,sp,96
 34c:	8082                	ret

000000000000034e <stat>:

int
stat(const char *n, struct stat *st)
{
 34e:	1101                	addi	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	e426                	sd	s1,8(sp)
 356:	e04a                	sd	s2,0(sp)
 358:	1000                	addi	s0,sp,32
 35a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35c:	4581                	li	a1,0
 35e:	162000ef          	jal	ra,4c0 <open>
  if(fd < 0)
 362:	02054163          	bltz	a0,384 <stat+0x36>
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	16e000ef          	jal	ra,4d8 <fstat>
 36e:	892a                	mv	s2,a0
  close(fd);
 370:	8526                	mv	a0,s1
 372:	136000ef          	jal	ra,4a8 <close>
  return r;
}
 376:	854a                	mv	a0,s2
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	64a2                	ld	s1,8(sp)
 37e:	6902                	ld	s2,0(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret
    return -1;
 384:	597d                	li	s2,-1
 386:	bfc5                	j	376 <stat+0x28>

0000000000000388 <atoi>:

int
atoi(const char *s)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 38e:	00054603          	lbu	a2,0(a0)
 392:	fd06079b          	addiw	a5,a2,-48
 396:	0ff7f793          	andi	a5,a5,255
 39a:	4725                	li	a4,9
 39c:	02f76963          	bltu	a4,a5,3ce <atoi+0x46>
 3a0:	86aa                	mv	a3,a0
  n = 0;
 3a2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3a4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3a6:	0685                	addi	a3,a3,1
 3a8:	0025179b          	slliw	a5,a0,0x2
 3ac:	9fa9                	addw	a5,a5,a0
 3ae:	0017979b          	slliw	a5,a5,0x1
 3b2:	9fb1                	addw	a5,a5,a2
 3b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3b8:	0006c603          	lbu	a2,0(a3)
 3bc:	fd06071b          	addiw	a4,a2,-48
 3c0:	0ff77713          	andi	a4,a4,255
 3c4:	fee5f1e3          	bgeu	a1,a4,3a6 <atoi+0x1e>
  return n;
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret
  n = 0;
 3ce:	4501                	li	a0,0
 3d0:	bfe5                	j	3c8 <atoi+0x40>

00000000000003d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3d8:	02b57463          	bgeu	a0,a1,400 <memmove+0x2e>
    while(n-- > 0)
 3dc:	00c05f63          	blez	a2,3fa <memmove+0x28>
 3e0:	1602                	slli	a2,a2,0x20
 3e2:	9201                	srli	a2,a2,0x20
 3e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ea:	0585                	addi	a1,a1,1
 3ec:	0705                	addi	a4,a4,1
 3ee:	fff5c683          	lbu	a3,-1(a1)
 3f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret
    dst += n;
 400:	00c50733          	add	a4,a0,a2
    src += n;
 404:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 406:	fec05ae3          	blez	a2,3fa <memmove+0x28>
 40a:	fff6079b          	addiw	a5,a2,-1
 40e:	1782                	slli	a5,a5,0x20
 410:	9381                	srli	a5,a5,0x20
 412:	fff7c793          	not	a5,a5
 416:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 418:	15fd                	addi	a1,a1,-1
 41a:	177d                	addi	a4,a4,-1
 41c:	0005c683          	lbu	a3,0(a1)
 420:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 424:	fee79ae3          	bne	a5,a4,418 <memmove+0x46>
 428:	bfc9                	j	3fa <memmove+0x28>

000000000000042a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 430:	ca05                	beqz	a2,460 <memcmp+0x36>
 432:	fff6069b          	addiw	a3,a2,-1
 436:	1682                	slli	a3,a3,0x20
 438:	9281                	srli	a3,a3,0x20
 43a:	0685                	addi	a3,a3,1
 43c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 43e:	00054783          	lbu	a5,0(a0)
 442:	0005c703          	lbu	a4,0(a1)
 446:	00e79863          	bne	a5,a4,456 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 44a:	0505                	addi	a0,a0,1
    p2++;
 44c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 44e:	fed518e3          	bne	a0,a3,43e <memcmp+0x14>
  }
  return 0;
 452:	4501                	li	a0,0
 454:	a019                	j	45a <memcmp+0x30>
      return *p1 - *p2;
 456:	40e7853b          	subw	a0,a5,a4
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
  return 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <memcmp+0x30>

0000000000000464 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 464:	1141                	addi	sp,sp,-16
 466:	e406                	sd	ra,8(sp)
 468:	e022                	sd	s0,0(sp)
 46a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 46c:	f67ff0ef          	jal	ra,3d2 <memmove>
}
 470:	60a2                	ld	ra,8(sp)
 472:	6402                	ld	s0,0(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 478:	4885                	li	a7,1
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <exit>:
.global exit
exit:
 li a7, SYS_exit
 480:	4889                	li	a7,2
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <wait>:
.global wait
wait:
 li a7, SYS_wait
 488:	488d                	li	a7,3
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 490:	4891                	li	a7,4
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <read>:
.global read
read:
 li a7, SYS_read
 498:	4895                	li	a7,5
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <write>:
.global write
write:
 li a7, SYS_write
 4a0:	48c1                	li	a7,16
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <close>:
.global close
close:
 li a7, SYS_close
 4a8:	48d5                	li	a7,21
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b0:	4899                	li	a7,6
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b8:	489d                	li	a7,7
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <open>:
.global open
open:
 li a7, SYS_open
 4c0:	48bd                	li	a7,15
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c8:	48c5                	li	a7,17
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d0:	48c9                	li	a7,18
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d8:	48a1                	li	a7,8
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <link>:
.global link
link:
 li a7, SYS_link
 4e0:	48cd                	li	a7,19
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e8:	48d1                	li	a7,20
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f0:	48a5                	li	a7,9
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f8:	48a9                	li	a7,10
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 500:	48ad                	li	a7,11
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 508:	48b1                	li	a7,12
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 510:	48b5                	li	a7,13
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 518:	48b9                	li	a7,14
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 520:	48d9                	li	a7,22
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 528:	48dd                	li	a7,23
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 530:	48e1                	li	a7,24
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 538:	1101                	addi	sp,sp,-32
 53a:	ec06                	sd	ra,24(sp)
 53c:	e822                	sd	s0,16(sp)
 53e:	1000                	addi	s0,sp,32
 540:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 544:	4605                	li	a2,1
 546:	fef40593          	addi	a1,s0,-17
 54a:	f57ff0ef          	jal	ra,4a0 <write>
}
 54e:	60e2                	ld	ra,24(sp)
 550:	6442                	ld	s0,16(sp)
 552:	6105                	addi	sp,sp,32
 554:	8082                	ret

0000000000000556 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 556:	7139                	addi	sp,sp,-64
 558:	fc06                	sd	ra,56(sp)
 55a:	f822                	sd	s0,48(sp)
 55c:	f426                	sd	s1,40(sp)
 55e:	f04a                	sd	s2,32(sp)
 560:	ec4e                	sd	s3,24(sp)
 562:	0080                	addi	s0,sp,64
 564:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 566:	c299                	beqz	a3,56c <printint+0x16>
 568:	0805c663          	bltz	a1,5f4 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56c:	2581                	sext.w	a1,a1
  neg = 0;
 56e:	4881                	li	a7,0
 570:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 574:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 576:	2601                	sext.w	a2,a2
 578:	00000517          	auipc	a0,0x0
 57c:	4f050513          	addi	a0,a0,1264 # a68 <digits>
 580:	883a                	mv	a6,a4
 582:	2705                	addiw	a4,a4,1
 584:	02c5f7bb          	remuw	a5,a1,a2
 588:	1782                	slli	a5,a5,0x20
 58a:	9381                	srli	a5,a5,0x20
 58c:	97aa                	add	a5,a5,a0
 58e:	0007c783          	lbu	a5,0(a5)
 592:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 596:	0005879b          	sext.w	a5,a1
 59a:	02c5d5bb          	divuw	a1,a1,a2
 59e:	0685                	addi	a3,a3,1
 5a0:	fec7f0e3          	bgeu	a5,a2,580 <printint+0x2a>
  if(neg)
 5a4:	00088b63          	beqz	a7,5ba <printint+0x64>
    buf[i++] = '-';
 5a8:	fd040793          	addi	a5,s0,-48
 5ac:	973e                	add	a4,a4,a5
 5ae:	02d00793          	li	a5,45
 5b2:	fef70823          	sb	a5,-16(a4)
 5b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ba:	02e05663          	blez	a4,5e6 <printint+0x90>
 5be:	fc040793          	addi	a5,s0,-64
 5c2:	00e78933          	add	s2,a5,a4
 5c6:	fff78993          	addi	s3,a5,-1
 5ca:	99ba                	add	s3,s3,a4
 5cc:	377d                	addiw	a4,a4,-1
 5ce:	1702                	slli	a4,a4,0x20
 5d0:	9301                	srli	a4,a4,0x20
 5d2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d6:	fff94583          	lbu	a1,-1(s2)
 5da:	8526                	mv	a0,s1
 5dc:	f5dff0ef          	jal	ra,538 <putc>
  while(--i >= 0)
 5e0:	197d                	addi	s2,s2,-1
 5e2:	ff391ae3          	bne	s2,s3,5d6 <printint+0x80>
}
 5e6:	70e2                	ld	ra,56(sp)
 5e8:	7442                	ld	s0,48(sp)
 5ea:	74a2                	ld	s1,40(sp)
 5ec:	7902                	ld	s2,32(sp)
 5ee:	69e2                	ld	s3,24(sp)
 5f0:	6121                	addi	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4885                	li	a7,1
    x = -xx;
 5fa:	bf9d                	j	570 <printint+0x1a>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	7119                	addi	sp,sp,-128
 5fe:	fc86                	sd	ra,120(sp)
 600:	f8a2                	sd	s0,112(sp)
 602:	f4a6                	sd	s1,104(sp)
 604:	f0ca                	sd	s2,96(sp)
 606:	ecce                	sd	s3,88(sp)
 608:	e8d2                	sd	s4,80(sp)
 60a:	e4d6                	sd	s5,72(sp)
 60c:	e0da                	sd	s6,64(sp)
 60e:	fc5e                	sd	s7,56(sp)
 610:	f862                	sd	s8,48(sp)
 612:	f466                	sd	s9,40(sp)
 614:	f06a                	sd	s10,32(sp)
 616:	ec6e                	sd	s11,24(sp)
 618:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 61a:	0005c903          	lbu	s2,0(a1)
 61e:	22090e63          	beqz	s2,85a <vprintf+0x25e>
 622:	8b2a                	mv	s6,a0
 624:	8a2e                	mv	s4,a1
 626:	8bb2                	mv	s7,a2
  state = 0;
 628:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 62a:	4481                	li	s1,0
 62c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 632:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 636:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 63a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000c97          	auipc	s9,0x0
 642:	42ac8c93          	addi	s9,s9,1066 # a68 <digits>
 646:	a005                	j	666 <vprintf+0x6a>
        putc(fd, c0);
 648:	85ca                	mv	a1,s2
 64a:	855a                	mv	a0,s6
 64c:	eedff0ef          	jal	ra,538 <putc>
 650:	a019                	j	656 <vprintf+0x5a>
    } else if(state == '%'){
 652:	03598263          	beq	s3,s5,676 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 656:	2485                	addiw	s1,s1,1
 658:	8726                	mv	a4,s1
 65a:	009a07b3          	add	a5,s4,s1
 65e:	0007c903          	lbu	s2,0(a5)
 662:	1e090c63          	beqz	s2,85a <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 666:	0009079b          	sext.w	a5,s2
    if(state == 0){
 66a:	fe0994e3          	bnez	s3,652 <vprintf+0x56>
      if(c0 == '%'){
 66e:	fd579de3          	bne	a5,s5,648 <vprintf+0x4c>
        state = '%';
 672:	89be                	mv	s3,a5
 674:	b7cd                	j	656 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 676:	cfa5                	beqz	a5,6ee <vprintf+0xf2>
 678:	00ea06b3          	add	a3,s4,a4
 67c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 680:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 682:	c681                	beqz	a3,68a <vprintf+0x8e>
 684:	9752                	add	a4,a4,s4
 686:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 68a:	03878a63          	beq	a5,s8,6be <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 68e:	05a78463          	beq	a5,s10,6d6 <vprintf+0xda>
      } else if(c0 == 'u'){
 692:	0db78763          	beq	a5,s11,760 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 696:	07800713          	li	a4,120
 69a:	10e78963          	beq	a5,a4,7ac <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 69e:	07000713          	li	a4,112
 6a2:	12e78e63          	beq	a5,a4,7de <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6a6:	07300713          	li	a4,115
 6aa:	16e78b63          	beq	a5,a4,820 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ae:	05579063          	bne	a5,s5,6ee <vprintf+0xf2>
        putc(fd, '%');
 6b2:	85d6                	mv	a1,s5
 6b4:	855a                	mv	a0,s6
 6b6:	e83ff0ef          	jal	ra,538 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bf69                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4685                	li	a3,1
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e8bff0ef          	jal	ra,556 <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b749                	j	656 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 6d6:	03868663          	beq	a3,s8,702 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6da:	05a68163          	beq	a3,s10,71c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 6de:	09b68d63          	beq	a3,s11,778 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e2:	03a68f63          	beq	a3,s10,720 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6e6:	07800793          	li	a5,120
 6ea:	0cf68d63          	beq	a3,a5,7c4 <vprintf+0x1c8>
        putc(fd, '%');
 6ee:	85d6                	mv	a1,s5
 6f0:	855a                	mv	a0,s6
 6f2:	e47ff0ef          	jal	ra,538 <putc>
        putc(fd, c0);
 6f6:	85ca                	mv	a1,s2
 6f8:	855a                	mv	a0,s6
 6fa:	e3fff0ef          	jal	ra,538 <putc>
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bf99                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 702:	008b8913          	addi	s2,s7,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	e47ff0ef          	jal	ra,556 <printint>
        i += 1;
 714:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
        i += 1;
 71a:	bf35                	j	656 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71c:	03860563          	beq	a2,s8,746 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 720:	07b60963          	beq	a2,s11,792 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 724:	07800793          	li	a5,120
 728:	fcf613e3          	bne	a2,a5,6ee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e1dff0ef          	jal	ra,556 <printint>
        i += 2;
 73e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
        i += 2;
 744:	bf09                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	008b8913          	addi	s2,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e03ff0ef          	jal	ra,556 <printint>
        i += 2;
 758:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	bde5                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 760:	008b8913          	addi	s2,s7,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	de9ff0ef          	jal	ra,556 <printint>
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	b5c5                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	008b8913          	addi	s2,s7,8
 77c:	4681                	li	a3,0
 77e:	4629                	li	a2,10
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	dd1ff0ef          	jal	ra,556 <printint>
        i += 1;
 78a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
        i += 1;
 790:	b5d9                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8913          	addi	s2,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	db7ff0ef          	jal	ra,556 <printint>
        i += 2;
 7a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	b575                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4641                	li	a2,16
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	d9dff0ef          	jal	ra,556 <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bd51                	j	656 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4641                	li	a2,16
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	d85ff0ef          	jal	ra,556 <printint>
        i += 1;
 7d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 1;
 7dc:	bdad                	j	656 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 7de:	008b8793          	addi	a5,s7,8
 7e2:	f8f43423          	sd	a5,-120(s0)
 7e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ea:	03000593          	li	a1,48
 7ee:	855a                	mv	a0,s6
 7f0:	d49ff0ef          	jal	ra,538 <putc>
  putc(fd, 'x');
 7f4:	07800593          	li	a1,120
 7f8:	855a                	mv	a0,s6
 7fa:	d3fff0ef          	jal	ra,538 <putc>
 7fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 800:	03c9d793          	srli	a5,s3,0x3c
 804:	97e6                	add	a5,a5,s9
 806:	0007c583          	lbu	a1,0(a5)
 80a:	855a                	mv	a0,s6
 80c:	d2dff0ef          	jal	ra,538 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 810:	0992                	slli	s3,s3,0x4
 812:	397d                	addiw	s2,s2,-1
 814:	fe0916e3          	bnez	s2,800 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 818:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bd25                	j	656 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 820:	008b8993          	addi	s3,s7,8
 824:	000bb903          	ld	s2,0(s7)
 828:	00090f63          	beqz	s2,846 <vprintf+0x24a>
        for(; *s; s++)
 82c:	00094583          	lbu	a1,0(s2)
 830:	c195                	beqz	a1,854 <vprintf+0x258>
          putc(fd, *s);
 832:	855a                	mv	a0,s6
 834:	d05ff0ef          	jal	ra,538 <putc>
        for(; *s; s++)
 838:	0905                	addi	s2,s2,1
 83a:	00094583          	lbu	a1,0(s2)
 83e:	f9f5                	bnez	a1,832 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 840:	8bce                	mv	s7,s3
      state = 0;
 842:	4981                	li	s3,0
 844:	bd09                	j	656 <vprintf+0x5a>
          s = "(null)";
 846:	00000917          	auipc	s2,0x0
 84a:	21a90913          	addi	s2,s2,538 # a60 <malloc+0x104>
        for(; *s; s++)
 84e:	02800593          	li	a1,40
 852:	b7c5                	j	832 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	bbfd                	j	656 <vprintf+0x5a>
    }
  }
}
 85a:	70e6                	ld	ra,120(sp)
 85c:	7446                	ld	s0,112(sp)
 85e:	74a6                	ld	s1,104(sp)
 860:	7906                	ld	s2,96(sp)
 862:	69e6                	ld	s3,88(sp)
 864:	6a46                	ld	s4,80(sp)
 866:	6aa6                	ld	s5,72(sp)
 868:	6b06                	ld	s6,64(sp)
 86a:	7be2                	ld	s7,56(sp)
 86c:	7c42                	ld	s8,48(sp)
 86e:	7ca2                	ld	s9,40(sp)
 870:	7d02                	ld	s10,32(sp)
 872:	6de2                	ld	s11,24(sp)
 874:	6109                	addi	sp,sp,128
 876:	8082                	ret

0000000000000878 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 878:	715d                	addi	sp,sp,-80
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e010                	sd	a2,0(s0)
 882:	e414                	sd	a3,8(s0)
 884:	e818                	sd	a4,16(s0)
 886:	ec1c                	sd	a5,24(s0)
 888:	03043023          	sd	a6,32(s0)
 88c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 894:	8622                	mv	a2,s0
 896:	d67ff0ef          	jal	ra,5fc <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6161                	addi	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <printf>:

void
printf(const char *fmt, ...)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	addi	s0,sp,32
 8aa:	e40c                	sd	a1,8(s0)
 8ac:	e810                	sd	a2,16(s0)
 8ae:	ec14                	sd	a3,24(s0)
 8b0:	f018                	sd	a4,32(s0)
 8b2:	f41c                	sd	a5,40(s0)
 8b4:	03043823          	sd	a6,48(s0)
 8b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	00840613          	addi	a2,s0,8
 8c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c4:	85aa                	mv	a1,a0
 8c6:	4505                	li	a0,1
 8c8:	d35ff0ef          	jal	ra,5fc <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e422                	sd	s0,8(sp)
 8d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	00000797          	auipc	a5,0x0
 8e2:	72a7b783          	ld	a5,1834(a5) # 1008 <freep>
 8e6:	a805                	j	916 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e8:	4618                	lw	a4,8(a2)
 8ea:	9db9                	addw	a1,a1,a4
 8ec:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	6398                	ld	a4,0(a5)
 8f2:	6318                	ld	a4,0(a4)
 8f4:	fee53823          	sd	a4,-16(a0)
 8f8:	a091                	j	93c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8fa:	ff852703          	lw	a4,-8(a0)
 8fe:	9e39                	addw	a2,a2,a4
 900:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 902:	ff053703          	ld	a4,-16(a0)
 906:	e398                	sd	a4,0(a5)
 908:	a099                	j	94e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90a:	6398                	ld	a4,0(a5)
 90c:	00e7e463          	bltu	a5,a4,914 <free+0x40>
 910:	00e6ea63          	bltu	a3,a4,924 <free+0x50>
{
 914:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	fed7fae3          	bgeu	a5,a3,90a <free+0x36>
 91a:	6398                	ld	a4,0(a5)
 91c:	00e6e463          	bltu	a3,a4,924 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	fee7eae3          	bltu	a5,a4,914 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 924:	ff852583          	lw	a1,-8(a0)
 928:	6390                	ld	a2,0(a5)
 92a:	02059713          	slli	a4,a1,0x20
 92e:	9301                	srli	a4,a4,0x20
 930:	0712                	slli	a4,a4,0x4
 932:	9736                	add	a4,a4,a3
 934:	fae60ae3          	beq	a2,a4,8e8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 938:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 93c:	4790                	lw	a2,8(a5)
 93e:	02061713          	slli	a4,a2,0x20
 942:	9301                	srli	a4,a4,0x20
 944:	0712                	slli	a4,a4,0x4
 946:	973e                	add	a4,a4,a5
 948:	fae689e3          	beq	a3,a4,8fa <free+0x26>
  } else
    p->s.ptr = bp;
 94c:	e394                	sd	a3,0(a5)
  freep = p;
 94e:	00000717          	auipc	a4,0x0
 952:	6af73d23          	sd	a5,1722(a4) # 1008 <freep>
}
 956:	6422                	ld	s0,8(sp)
 958:	0141                	addi	sp,sp,16
 95a:	8082                	ret

000000000000095c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 95c:	7139                	addi	sp,sp,-64
 95e:	fc06                	sd	ra,56(sp)
 960:	f822                	sd	s0,48(sp)
 962:	f426                	sd	s1,40(sp)
 964:	f04a                	sd	s2,32(sp)
 966:	ec4e                	sd	s3,24(sp)
 968:	e852                	sd	s4,16(sp)
 96a:	e456                	sd	s5,8(sp)
 96c:	e05a                	sd	s6,0(sp)
 96e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 970:	02051493          	slli	s1,a0,0x20
 974:	9081                	srli	s1,s1,0x20
 976:	04bd                	addi	s1,s1,15
 978:	8091                	srli	s1,s1,0x4
 97a:	0014899b          	addiw	s3,s1,1
 97e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 980:	00000517          	auipc	a0,0x0
 984:	68853503          	ld	a0,1672(a0) # 1008 <freep>
 988:	c515                	beqz	a0,9b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	02977f63          	bgeu	a4,s1,9cc <malloc+0x70>
 992:	8a4e                	mv	s4,s3
 994:	0009871b          	sext.w	a4,s3
 998:	6685                	lui	a3,0x1
 99a:	00d77363          	bgeu	a4,a3,9a0 <malloc+0x44>
 99e:	6a05                	lui	s4,0x1
 9a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a8:	00000917          	auipc	s2,0x0
 9ac:	66090913          	addi	s2,s2,1632 # 1008 <freep>
  if(p == (char*)-1)
 9b0:	5afd                	li	s5,-1
 9b2:	a0bd                	j	a20 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 9b4:	0001b797          	auipc	a5,0x1b
 9b8:	c3c78793          	addi	a5,a5,-964 # 1b5f0 <base>
 9bc:	00000717          	auipc	a4,0x0
 9c0:	64f73623          	sd	a5,1612(a4) # 1008 <freep>
 9c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ca:	b7e1                	j	992 <malloc+0x36>
      if(p->s.size == nunits)
 9cc:	02e48b63          	beq	s1,a4,a02 <malloc+0xa6>
        p->s.size -= nunits;
 9d0:	4137073b          	subw	a4,a4,s3
 9d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d6:	1702                	slli	a4,a4,0x20
 9d8:	9301                	srli	a4,a4,0x20
 9da:	0712                	slli	a4,a4,0x4
 9dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e2:	00000717          	auipc	a4,0x0
 9e6:	62a73323          	sd	a0,1574(a4) # 1008 <freep>
      return (void*)(p + 1);
 9ea:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ee:	70e2                	ld	ra,56(sp)
 9f0:	7442                	ld	s0,48(sp)
 9f2:	74a2                	ld	s1,40(sp)
 9f4:	7902                	ld	s2,32(sp)
 9f6:	69e2                	ld	s3,24(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	6121                	addi	sp,sp,64
 a00:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a02:	6398                	ld	a4,0(a5)
 a04:	e118                	sd	a4,0(a0)
 a06:	bff1                	j	9e2 <malloc+0x86>
  hp->s.size = nu;
 a08:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a0c:	0541                	addi	a0,a0,16
 a0e:	ec7ff0ef          	jal	ra,8d4 <free>
  return freep;
 a12:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a16:	dd61                	beqz	a0,9ee <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1a:	4798                	lw	a4,8(a5)
 a1c:	fa9778e3          	bgeu	a4,s1,9cc <malloc+0x70>
    if(p == freep)
 a20:	00093703          	ld	a4,0(s2)
 a24:	853e                	mv	a0,a5
 a26:	fef719e3          	bne	a4,a5,a18 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a2a:	8552                	mv	a0,s4
 a2c:	addff0ef          	jal	ra,508 <sbrk>
  if(p == (char*)-1)
 a30:	fd551ce3          	bne	a0,s5,a08 <malloc+0xac>
        return 0;
 a34:	4501                	li	a0,0
 a36:	bf65                	j	9ee <malloc+0x92>
