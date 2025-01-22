
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	958a0a13          	addi	s4,s4,-1704 # 990 <malloc+0xde>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1c2000ef          	jal	ra,208 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01248d63          	beq	s1,s2,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2b85                	addiw	s7,s7,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0997e3          	bnez	s3,4e <wc+0x4e>
        w++;
  64:	2c05                	addiw	s8,s8,1
        inword = 1;
  66:	4985                	li	s3,1
  68:	b7dd                	j	4e <wc+0x4e>
      c++;
  6a:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	00001597          	auipc	a1,0x1
  76:	f9e58593          	addi	a1,a1,-98 # 1010 <buf>
  7a:	f8843503          	ld	a0,-120(s0)
  7e:	368000ef          	jal	ra,3e6 <read>
  82:	00a05f63          	blez	a0,a0 <wc+0xa0>
    for(i=0; i<n; i++){
  86:	00001497          	auipc	s1,0x1
  8a:	f8a48493          	addi	s1,s1,-118 # 1010 <buf>
  8e:	00050d1b          	sext.w	s10,a0
  92:	fff5091b          	addiw	s2,a0,-1
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	996e                	add	s2,s2,s11
  9e:	bf5d                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  a0:	02054c63          	bltz	a0,d8 <wc+0xd8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  a4:	f8043703          	ld	a4,-128(s0)
  a8:	86e6                	mv	a3,s9
  aa:	8662                	mv	a2,s8
  ac:	85de                	mv	a1,s7
  ae:	00001517          	auipc	a0,0x1
  b2:	8fa50513          	addi	a0,a0,-1798 # 9a8 <malloc+0xf6>
  b6:	742000ef          	jal	ra,7f8 <printf>
}
  ba:	70e6                	ld	ra,120(sp)
  bc:	7446                	ld	s0,112(sp)
  be:	74a6                	ld	s1,104(sp)
  c0:	7906                	ld	s2,96(sp)
  c2:	69e6                	ld	s3,88(sp)
  c4:	6a46                	ld	s4,80(sp)
  c6:	6aa6                	ld	s5,72(sp)
  c8:	6b06                	ld	s6,64(sp)
  ca:	7be2                	ld	s7,56(sp)
  cc:	7c42                	ld	s8,48(sp)
  ce:	7ca2                	ld	s9,40(sp)
  d0:	7d02                	ld	s10,32(sp)
  d2:	6de2                	ld	s11,24(sp)
  d4:	6109                	addi	sp,sp,128
  d6:	8082                	ret
    printf("wc: read error\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	8c050513          	addi	a0,a0,-1856 # 998 <malloc+0xe6>
  e0:	718000ef          	jal	ra,7f8 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	2e8000ef          	jal	ra,3ce <exit>

00000000000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	7179                	addi	sp,sp,-48
  ec:	f406                	sd	ra,40(sp)
  ee:	f022                	sd	s0,32(sp)
  f0:	ec26                	sd	s1,24(sp)
  f2:	e84a                	sd	s2,16(sp)
  f4:	e44e                	sd	s3,8(sp)
  f6:	e052                	sd	s4,0(sp)
  f8:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fa:	4785                	li	a5,1
  fc:	02a7df63          	bge	a5,a0,13a <main+0x50>
 100:	00858493          	addi	s1,a1,8
 104:	ffe5099b          	addiw	s3,a0,-2
 108:	1982                	slli	s3,s3,0x20
 10a:	0209d993          	srli	s3,s3,0x20
 10e:	098e                	slli	s3,s3,0x3
 110:	05c1                	addi	a1,a1,16
 112:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 114:	4581                	li	a1,0
 116:	6088                	ld	a0,0(s1)
 118:	2f6000ef          	jal	ra,40e <open>
 11c:	892a                	mv	s2,a0
 11e:	02054863          	bltz	a0,14e <main+0x64>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 122:	608c                	ld	a1,0(s1)
 124:	eddff0ef          	jal	ra,0 <wc>
    close(fd);
 128:	854a                	mv	a0,s2
 12a:	2cc000ef          	jal	ra,3f6 <close>
  for(i = 1; i < argc; i++){
 12e:	04a1                	addi	s1,s1,8
 130:	ff3492e3          	bne	s1,s3,114 <main+0x2a>
  }
  exit(0);
 134:	4501                	li	a0,0
 136:	298000ef          	jal	ra,3ce <exit>
    wc(0, "");
 13a:	00001597          	auipc	a1,0x1
 13e:	87e58593          	addi	a1,a1,-1922 # 9b8 <malloc+0x106>
 142:	4501                	li	a0,0
 144:	ebdff0ef          	jal	ra,0 <wc>
    exit(0);
 148:	4501                	li	a0,0
 14a:	284000ef          	jal	ra,3ce <exit>
      printf("wc: cannot open %s\n", argv[i]);
 14e:	608c                	ld	a1,0(s1)
 150:	00001517          	auipc	a0,0x1
 154:	87050513          	addi	a0,a0,-1936 # 9c0 <malloc+0x10e>
 158:	6a0000ef          	jal	ra,7f8 <printf>
      exit(1);
 15c:	4505                	li	a0,1
 15e:	270000ef          	jal	ra,3ce <exit>

0000000000000162 <start>:
//


void
start()
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16a:	f81ff0ef          	jal	ra,ea <main>
  exit(0);
 16e:	4501                	li	a0,0
 170:	25e000ef          	jal	ra,3ce <exit>

0000000000000174 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17a:	87aa                	mv	a5,a0
 17c:	0585                	addi	a1,a1,1
 17e:	0785                	addi	a5,a5,1
 180:	fff5c703          	lbu	a4,-1(a1)
 184:	fee78fa3          	sb	a4,-1(a5)
 188:	fb75                	bnez	a4,17c <strcpy+0x8>
    ;
  return os;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x1e>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x1e>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cf91                	beqz	a5,1e2 <strlen+0x26>
 1c8:	0505                	addi	a0,a0,1
 1ca:	87aa                	mv	a5,a0
 1cc:	4685                	li	a3,1
 1ce:	9e89                	subw	a3,a3,a0
 1d0:	00f6853b          	addw	a0,a3,a5
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff7c703          	lbu	a4,-1(a5)
 1da:	fb7d                	bnez	a4,1d0 <strlen+0x14>
    ;
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  for(n = 0; s[n]; n++)
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <strlen+0x20>

00000000000001e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ec:	ca19                	beqz	a2,202 <memset+0x1c>
 1ee:	87aa                	mv	a5,a0
 1f0:	1602                	slli	a2,a2,0x20
 1f2:	9201                	srli	a2,a2,0x20
 1f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fc:	0785                	addi	a5,a5,1
 1fe:	fee79de3          	bne	a5,a4,1f8 <memset+0x12>
  }
  return dst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <strchr>:

char*
strchr(const char *s, char c)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20e:	00054783          	lbu	a5,0(a0)
 212:	cb99                	beqz	a5,228 <strchr+0x20>
    if(*s == c)
 214:	00f58763          	beq	a1,a5,222 <strchr+0x1a>
  for(; *s; s++)
 218:	0505                	addi	a0,a0,1
 21a:	00054783          	lbu	a5,0(a0)
 21e:	fbfd                	bnez	a5,214 <strchr+0xc>
      return (char*)s;
  return 0;
 220:	4501                	li	a0,0
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  return 0;
 228:	4501                	li	a0,0
 22a:	bfe5                	j	222 <strchr+0x1a>

000000000000022c <gets>:

char*
gets(char *buf, int max)
{
 22c:	711d                	addi	sp,sp,-96
 22e:	ec86                	sd	ra,88(sp)
 230:	e8a2                	sd	s0,80(sp)
 232:	e4a6                	sd	s1,72(sp)
 234:	e0ca                	sd	s2,64(sp)
 236:	fc4e                	sd	s3,56(sp)
 238:	f852                	sd	s4,48(sp)
 23a:	f456                	sd	s5,40(sp)
 23c:	f05a                	sd	s6,32(sp)
 23e:	ec5e                	sd	s7,24(sp)
 240:	1080                	addi	s0,sp,96
 242:	8baa                	mv	s7,a0
 244:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	892a                	mv	s2,a0
 248:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24a:	4aa9                	li	s5,10
 24c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24e:	89a6                	mv	s3,s1
 250:	2485                	addiw	s1,s1,1
 252:	0344d663          	bge	s1,s4,27e <gets+0x52>
    cc = read(0, &c, 1);
 256:	4605                	li	a2,1
 258:	faf40593          	addi	a1,s0,-81
 25c:	4501                	li	a0,0
 25e:	188000ef          	jal	ra,3e6 <read>
    if(cc < 1)
 262:	00a05e63          	blez	a0,27e <gets+0x52>
    buf[i++] = c;
 266:	faf44783          	lbu	a5,-81(s0)
 26a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26e:	01578763          	beq	a5,s5,27c <gets+0x50>
 272:	0905                	addi	s2,s2,1
 274:	fd679de3          	bne	a5,s6,24e <gets+0x22>
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	a011                	j	27e <gets+0x52>
 27c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27e:	99de                	add	s3,s3,s7
 280:	00098023          	sb	zero,0(s3)
  return buf;
}
 284:	855e                	mv	a0,s7
 286:	60e6                	ld	ra,88(sp)
 288:	6446                	ld	s0,80(sp)
 28a:	64a6                	ld	s1,72(sp)
 28c:	6906                	ld	s2,64(sp)
 28e:	79e2                	ld	s3,56(sp)
 290:	7a42                	ld	s4,48(sp)
 292:	7aa2                	ld	s5,40(sp)
 294:	7b02                	ld	s6,32(sp)
 296:	6be2                	ld	s7,24(sp)
 298:	6125                	addi	sp,sp,96
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e426                	sd	s1,8(sp)
 2a4:	e04a                	sd	s2,0(sp)
 2a6:	1000                	addi	s0,sp,32
 2a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	4581                	li	a1,0
 2ac:	162000ef          	jal	ra,40e <open>
  if(fd < 0)
 2b0:	02054163          	bltz	a0,2d2 <stat+0x36>
 2b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b6:	85ca                	mv	a1,s2
 2b8:	16e000ef          	jal	ra,426 <fstat>
 2bc:	892a                	mv	s2,a0
  close(fd);
 2be:	8526                	mv	a0,s1
 2c0:	136000ef          	jal	ra,3f6 <close>
  return r;
}
 2c4:	854a                	mv	a0,s2
 2c6:	60e2                	ld	ra,24(sp)
 2c8:	6442                	ld	s0,16(sp)
 2ca:	64a2                	ld	s1,8(sp)
 2cc:	6902                	ld	s2,0(sp)
 2ce:	6105                	addi	sp,sp,32
 2d0:	8082                	ret
    return -1;
 2d2:	597d                	li	s2,-1
 2d4:	bfc5                	j	2c4 <stat+0x28>

00000000000002d6 <atoi>:

int
atoi(const char *s)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	00054603          	lbu	a2,0(a0)
 2e0:	fd06079b          	addiw	a5,a2,-48
 2e4:	0ff7f793          	andi	a5,a5,255
 2e8:	4725                	li	a4,9
 2ea:	02f76963          	bltu	a4,a5,31c <atoi+0x46>
 2ee:	86aa                	mv	a3,a0
  n = 0;
 2f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f4:	0685                	addi	a3,a3,1
 2f6:	0025179b          	slliw	a5,a0,0x2
 2fa:	9fa9                	addw	a5,a5,a0
 2fc:	0017979b          	slliw	a5,a5,0x1
 300:	9fb1                	addw	a5,a5,a2
 302:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 306:	0006c603          	lbu	a2,0(a3)
 30a:	fd06071b          	addiw	a4,a2,-48
 30e:	0ff77713          	andi	a4,a4,255
 312:	fee5f1e3          	bgeu	a1,a4,2f4 <atoi+0x1e>
  return n;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfe5                	j	316 <atoi+0x40>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 326:	02b57463          	bgeu	a0,a1,34e <memmove+0x2e>
    while(n-- > 0)
 32a:	00c05f63          	blez	a2,348 <memmove+0x28>
 32e:	1602                	slli	a2,a2,0x20
 330:	9201                	srli	a2,a2,0x20
 332:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 336:	872a                	mv	a4,a0
      *dst++ = *src++;
 338:	0585                	addi	a1,a1,1
 33a:	0705                	addi	a4,a4,1
 33c:	fff5c683          	lbu	a3,-1(a1)
 340:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
    dst += n;
 34e:	00c50733          	add	a4,a0,a2
    src += n;
 352:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 354:	fec05ae3          	blez	a2,348 <memmove+0x28>
 358:	fff6079b          	addiw	a5,a2,-1
 35c:	1782                	slli	a5,a5,0x20
 35e:	9381                	srli	a5,a5,0x20
 360:	fff7c793          	not	a5,a5
 364:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 366:	15fd                	addi	a1,a1,-1
 368:	177d                	addi	a4,a4,-1
 36a:	0005c683          	lbu	a3,0(a1)
 36e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 372:	fee79ae3          	bne	a5,a4,366 <memmove+0x46>
 376:	bfc9                	j	348 <memmove+0x28>

0000000000000378 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37e:	ca05                	beqz	a2,3ae <memcmp+0x36>
 380:	fff6069b          	addiw	a3,a2,-1
 384:	1682                	slli	a3,a3,0x20
 386:	9281                	srli	a3,a3,0x20
 388:	0685                	addi	a3,a3,1
 38a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38c:	00054783          	lbu	a5,0(a0)
 390:	0005c703          	lbu	a4,0(a1)
 394:	00e79863          	bne	a5,a4,3a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 398:	0505                	addi	a0,a0,1
    p2++;
 39a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39c:	fed518e3          	bne	a0,a3,38c <memcmp+0x14>
  }
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	a019                	j	3a8 <memcmp+0x30>
      return *p1 - *p2;
 3a4:	40e7853b          	subw	a0,a5,a4
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <memcmp+0x30>

00000000000003b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ba:	f67ff0ef          	jal	ra,320 <memmove>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c6:	4885                	li	a7,1
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ce:	4889                	li	a7,2
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d6:	488d                	li	a7,3
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3de:	4891                	li	a7,4
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <read>:
.global read
read:
 li a7, SYS_read
 3e6:	4895                	li	a7,5
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <write>:
.global write
write:
 li a7, SYS_write
 3ee:	48c1                	li	a7,16
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <close>:
.global close
close:
 li a7, SYS_close
 3f6:	48d5                	li	a7,21
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fe:	4899                	li	a7,6
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <exec>:
.global exec
exec:
 li a7, SYS_exec
 406:	489d                	li	a7,7
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <open>:
.global open
open:
 li a7, SYS_open
 40e:	48bd                	li	a7,15
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 416:	48c5                	li	a7,17
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41e:	48c9                	li	a7,18
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 426:	48a1                	li	a7,8
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <link>:
.global link
link:
 li a7, SYS_link
 42e:	48cd                	li	a7,19
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 436:	48d1                	li	a7,20
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43e:	48a5                	li	a7,9
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <dup>:
.global dup
dup:
 li a7, SYS_dup
 446:	48a9                	li	a7,10
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44e:	48ad                	li	a7,11
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 456:	48b1                	li	a7,12
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45e:	48b5                	li	a7,13
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 466:	48b9                	li	a7,14
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 46e:	48d9                	li	a7,22
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 476:	48dd                	li	a7,23
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 47e:	48e1                	li	a7,24
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 486:	48e5                	li	a7,25
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48e:	1101                	addi	sp,sp,-32
 490:	ec06                	sd	ra,24(sp)
 492:	e822                	sd	s0,16(sp)
 494:	1000                	addi	s0,sp,32
 496:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49a:	4605                	li	a2,1
 49c:	fef40593          	addi	a1,s0,-17
 4a0:	f4fff0ef          	jal	ra,3ee <write>
}
 4a4:	60e2                	ld	ra,24(sp)
 4a6:	6442                	ld	s0,16(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret

00000000000004ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ac:	7139                	addi	sp,sp,-64
 4ae:	fc06                	sd	ra,56(sp)
 4b0:	f822                	sd	s0,48(sp)
 4b2:	f426                	sd	s1,40(sp)
 4b4:	f04a                	sd	s2,32(sp)
 4b6:	ec4e                	sd	s3,24(sp)
 4b8:	0080                	addi	s0,sp,64
 4ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4bc:	c299                	beqz	a3,4c2 <printint+0x16>
 4be:	0805c663          	bltz	a1,54a <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c2:	2581                	sext.w	a1,a1
  neg = 0;
 4c4:	4881                	li	a7,0
 4c6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4cc:	2601                	sext.w	a2,a2
 4ce:	00000517          	auipc	a0,0x0
 4d2:	51250513          	addi	a0,a0,1298 # 9e0 <digits>
 4d6:	883a                	mv	a6,a4
 4d8:	2705                	addiw	a4,a4,1
 4da:	02c5f7bb          	remuw	a5,a1,a2
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	97aa                	add	a5,a5,a0
 4e4:	0007c783          	lbu	a5,0(a5)
 4e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ec:	0005879b          	sext.w	a5,a1
 4f0:	02c5d5bb          	divuw	a1,a1,a2
 4f4:	0685                	addi	a3,a3,1
 4f6:	fec7f0e3          	bgeu	a5,a2,4d6 <printint+0x2a>
  if(neg)
 4fa:	00088b63          	beqz	a7,510 <printint+0x64>
    buf[i++] = '-';
 4fe:	fd040793          	addi	a5,s0,-48
 502:	973e                	add	a4,a4,a5
 504:	02d00793          	li	a5,45
 508:	fef70823          	sb	a5,-16(a4)
 50c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 510:	02e05663          	blez	a4,53c <printint+0x90>
 514:	fc040793          	addi	a5,s0,-64
 518:	00e78933          	add	s2,a5,a4
 51c:	fff78993          	addi	s3,a5,-1
 520:	99ba                	add	s3,s3,a4
 522:	377d                	addiw	a4,a4,-1
 524:	1702                	slli	a4,a4,0x20
 526:	9301                	srli	a4,a4,0x20
 528:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52c:	fff94583          	lbu	a1,-1(s2)
 530:	8526                	mv	a0,s1
 532:	f5dff0ef          	jal	ra,48e <putc>
  while(--i >= 0)
 536:	197d                	addi	s2,s2,-1
 538:	ff391ae3          	bne	s2,s3,52c <printint+0x80>
}
 53c:	70e2                	ld	ra,56(sp)
 53e:	7442                	ld	s0,48(sp)
 540:	74a2                	ld	s1,40(sp)
 542:	7902                	ld	s2,32(sp)
 544:	69e2                	ld	s3,24(sp)
 546:	6121                	addi	sp,sp,64
 548:	8082                	ret
    x = -xx;
 54a:	40b005bb          	negw	a1,a1
    neg = 1;
 54e:	4885                	li	a7,1
    x = -xx;
 550:	bf9d                	j	4c6 <printint+0x1a>

0000000000000552 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 552:	7119                	addi	sp,sp,-128
 554:	fc86                	sd	ra,120(sp)
 556:	f8a2                	sd	s0,112(sp)
 558:	f4a6                	sd	s1,104(sp)
 55a:	f0ca                	sd	s2,96(sp)
 55c:	ecce                	sd	s3,88(sp)
 55e:	e8d2                	sd	s4,80(sp)
 560:	e4d6                	sd	s5,72(sp)
 562:	e0da                	sd	s6,64(sp)
 564:	fc5e                	sd	s7,56(sp)
 566:	f862                	sd	s8,48(sp)
 568:	f466                	sd	s9,40(sp)
 56a:	f06a                	sd	s10,32(sp)
 56c:	ec6e                	sd	s11,24(sp)
 56e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 570:	0005c903          	lbu	s2,0(a1)
 574:	22090e63          	beqz	s2,7b0 <vprintf+0x25e>
 578:	8b2a                	mv	s6,a0
 57a:	8a2e                	mv	s4,a1
 57c:	8bb2                	mv	s7,a2
  state = 0;
 57e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 580:	4481                	li	s1,0
 582:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 584:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 588:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 590:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 594:	00000c97          	auipc	s9,0x0
 598:	44cc8c93          	addi	s9,s9,1100 # 9e0 <digits>
 59c:	a005                	j	5bc <vprintf+0x6a>
        putc(fd, c0);
 59e:	85ca                	mv	a1,s2
 5a0:	855a                	mv	a0,s6
 5a2:	eedff0ef          	jal	ra,48e <putc>
 5a6:	a019                	j	5ac <vprintf+0x5a>
    } else if(state == '%'){
 5a8:	03598263          	beq	s3,s5,5cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ac:	2485                	addiw	s1,s1,1
 5ae:	8726                	mv	a4,s1
 5b0:	009a07b3          	add	a5,s4,s1
 5b4:	0007c903          	lbu	s2,0(a5)
 5b8:	1e090c63          	beqz	s2,7b0 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c0:	fe0994e3          	bnez	s3,5a8 <vprintf+0x56>
      if(c0 == '%'){
 5c4:	fd579de3          	bne	a5,s5,59e <vprintf+0x4c>
        state = '%';
 5c8:	89be                	mv	s3,a5
 5ca:	b7cd                	j	5ac <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5cc:	cfa5                	beqz	a5,644 <vprintf+0xf2>
 5ce:	00ea06b3          	add	a3,s4,a4
 5d2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5d8:	c681                	beqz	a3,5e0 <vprintf+0x8e>
 5da:	9752                	add	a4,a4,s4
 5dc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5e0:	03878a63          	beq	a5,s8,614 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5e4:	05a78463          	beq	a5,s10,62c <vprintf+0xda>
      } else if(c0 == 'u'){
 5e8:	0db78763          	beq	a5,s11,6b6 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ec:	07800713          	li	a4,120
 5f0:	10e78963          	beq	a5,a4,702 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5f4:	07000713          	li	a4,112
 5f8:	12e78e63          	beq	a5,a4,734 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5fc:	07300713          	li	a4,115
 600:	16e78b63          	beq	a5,a4,776 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 604:	05579063          	bne	a5,s5,644 <vprintf+0xf2>
        putc(fd, '%');
 608:	85d6                	mv	a1,s5
 60a:	855a                	mv	a0,s6
 60c:	e83ff0ef          	jal	ra,48e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 610:	4981                	li	s3,0
 612:	bf69                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 614:	008b8913          	addi	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e8bff0ef          	jal	ra,4ac <printint>
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	b749                	j	5ac <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 62c:	03868663          	beq	a3,s8,658 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 630:	05a68163          	beq	a3,s10,672 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 634:	09b68d63          	beq	a3,s11,6ce <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 638:	03a68f63          	beq	a3,s10,676 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 63c:	07800793          	li	a5,120
 640:	0cf68d63          	beq	a3,a5,71a <vprintf+0x1c8>
        putc(fd, '%');
 644:	85d6                	mv	a1,s5
 646:	855a                	mv	a0,s6
 648:	e47ff0ef          	jal	ra,48e <putc>
        putc(fd, c0);
 64c:	85ca                	mv	a1,s2
 64e:	855a                	mv	a0,s6
 650:	e3fff0ef          	jal	ra,48e <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	bf99                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	e47ff0ef          	jal	ra,4ac <printint>
        i += 1;
 66a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 1;
 670:	bf35                	j	5ac <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 672:	03860563          	beq	a2,s8,69c <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 676:	07b60963          	beq	a2,s11,6e8 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 67a:	07800793          	li	a5,120
 67e:	fcf613e3          	bne	a2,a5,644 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e1dff0ef          	jal	ra,4ac <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bf09                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e03ff0ef          	jal	ra,4ac <printint>
        i += 2;
 6ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	bde5                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	de9ff0ef          	jal	ra,4ac <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b5c5                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	dd1ff0ef          	jal	ra,4ac <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	b5d9                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	db7ff0ef          	jal	ra,4ac <printint>
        i += 2;
 6fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	b575                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4641                	li	a2,16
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d9dff0ef          	jal	ra,4ac <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bd51                	j	5ac <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d85ff0ef          	jal	ra,4ac <printint>
        i += 1;
 72c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	bdad                	j	5ac <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 734:	008b8793          	addi	a5,s7,8
 738:	f8f43423          	sd	a5,-120(s0)
 73c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 740:	03000593          	li	a1,48
 744:	855a                	mv	a0,s6
 746:	d49ff0ef          	jal	ra,48e <putc>
  putc(fd, 'x');
 74a:	07800593          	li	a1,120
 74e:	855a                	mv	a0,s6
 750:	d3fff0ef          	jal	ra,48e <putc>
 754:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 756:	03c9d793          	srli	a5,s3,0x3c
 75a:	97e6                	add	a5,a5,s9
 75c:	0007c583          	lbu	a1,0(a5)
 760:	855a                	mv	a0,s6
 762:	d2dff0ef          	jal	ra,48e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 766:	0992                	slli	s3,s3,0x4
 768:	397d                	addiw	s2,s2,-1
 76a:	fe0916e3          	bnez	s2,756 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 76e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 772:	4981                	li	s3,0
 774:	bd25                	j	5ac <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 776:	008b8993          	addi	s3,s7,8
 77a:	000bb903          	ld	s2,0(s7)
 77e:	00090f63          	beqz	s2,79c <vprintf+0x24a>
        for(; *s; s++)
 782:	00094583          	lbu	a1,0(s2)
 786:	c195                	beqz	a1,7aa <vprintf+0x258>
          putc(fd, *s);
 788:	855a                	mv	a0,s6
 78a:	d05ff0ef          	jal	ra,48e <putc>
        for(; *s; s++)
 78e:	0905                	addi	s2,s2,1
 790:	00094583          	lbu	a1,0(s2)
 794:	f9f5                	bnez	a1,788 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	bd09                	j	5ac <vprintf+0x5a>
          s = "(null)";
 79c:	00000917          	auipc	s2,0x0
 7a0:	23c90913          	addi	s2,s2,572 # 9d8 <malloc+0x126>
        for(; *s; s++)
 7a4:	02800593          	li	a1,40
 7a8:	b7c5                	j	788 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bbfd                	j	5ac <vprintf+0x5a>
    }
  }
}
 7b0:	70e6                	ld	ra,120(sp)
 7b2:	7446                	ld	s0,112(sp)
 7b4:	74a6                	ld	s1,104(sp)
 7b6:	7906                	ld	s2,96(sp)
 7b8:	69e6                	ld	s3,88(sp)
 7ba:	6a46                	ld	s4,80(sp)
 7bc:	6aa6                	ld	s5,72(sp)
 7be:	6b06                	ld	s6,64(sp)
 7c0:	7be2                	ld	s7,56(sp)
 7c2:	7c42                	ld	s8,48(sp)
 7c4:	7ca2                	ld	s9,40(sp)
 7c6:	7d02                	ld	s10,32(sp)
 7c8:	6de2                	ld	s11,24(sp)
 7ca:	6109                	addi	sp,sp,128
 7cc:	8082                	ret

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	addi	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	8622                	mv	a2,s0
 7ec:	d67ff0ef          	jal	ra,552 <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6161                	addi	sp,sp,80
 7f6:	8082                	ret

00000000000007f8 <printf>:

void
printf(const char *fmt, ...)
{
 7f8:	711d                	addi	sp,sp,-96
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e40c                	sd	a1,8(s0)
 802:	e810                	sd	a2,16(s0)
 804:	ec14                	sd	a3,24(s0)
 806:	f018                	sd	a4,32(s0)
 808:	f41c                	sd	a5,40(s0)
 80a:	03043823          	sd	a6,48(s0)
 80e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	00840613          	addi	a2,s0,8
 816:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81a:	85aa                	mv	a1,a0
 81c:	4505                	li	a0,1
 81e:	d35ff0ef          	jal	ra,552 <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82a:	1141                	addi	sp,sp,-16
 82c:	e422                	sd	s0,8(sp)
 82e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 830:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	00000797          	auipc	a5,0x0
 838:	7cc7b783          	ld	a5,1996(a5) # 1000 <freep>
 83c:	a805                	j	86c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83e:	4618                	lw	a4,8(a2)
 840:	9db9                	addw	a1,a1,a4
 842:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	6318                	ld	a4,0(a4)
 84a:	fee53823          	sd	a4,-16(a0)
 84e:	a091                	j	892 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 850:	ff852703          	lw	a4,-8(a0)
 854:	9e39                	addw	a2,a2,a4
 856:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 858:	ff053703          	ld	a4,-16(a0)
 85c:	e398                	sd	a4,0(a5)
 85e:	a099                	j	8a4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	6398                	ld	a4,0(a5)
 862:	00e7e463          	bltu	a5,a4,86a <free+0x40>
 866:	00e6ea63          	bltu	a3,a4,87a <free+0x50>
{
 86a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	fed7fae3          	bgeu	a5,a3,860 <free+0x36>
 870:	6398                	ld	a4,0(a5)
 872:	00e6e463          	bltu	a3,a4,87a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	fee7eae3          	bltu	a5,a4,86a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 87a:	ff852583          	lw	a1,-8(a0)
 87e:	6390                	ld	a2,0(a5)
 880:	02059713          	slli	a4,a1,0x20
 884:	9301                	srli	a4,a4,0x20
 886:	0712                	slli	a4,a4,0x4
 888:	9736                	add	a4,a4,a3
 88a:	fae60ae3          	beq	a2,a4,83e <free+0x14>
    bp->s.ptr = p->s.ptr;
 88e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 892:	4790                	lw	a2,8(a5)
 894:	02061713          	slli	a4,a2,0x20
 898:	9301                	srli	a4,a4,0x20
 89a:	0712                	slli	a4,a4,0x4
 89c:	973e                	add	a4,a4,a5
 89e:	fae689e3          	beq	a3,a4,850 <free+0x26>
  } else
    p->s.ptr = bp;
 8a2:	e394                	sd	a3,0(a5)
  freep = p;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
}
 8ac:	6422                	ld	s0,8(sp)
 8ae:	0141                	addi	sp,sp,16
 8b0:	8082                	ret

00000000000008b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b2:	7139                	addi	sp,sp,-64
 8b4:	fc06                	sd	ra,56(sp)
 8b6:	f822                	sd	s0,48(sp)
 8b8:	f426                	sd	s1,40(sp)
 8ba:	f04a                	sd	s2,32(sp)
 8bc:	ec4e                	sd	s3,24(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
 8c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	02051493          	slli	s1,a0,0x20
 8ca:	9081                	srli	s1,s1,0x20
 8cc:	04bd                	addi	s1,s1,15
 8ce:	8091                	srli	s1,s1,0x4
 8d0:	0014899b          	addiw	s3,s1,1
 8d4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8d6:	00000517          	auipc	a0,0x0
 8da:	72a53503          	ld	a0,1834(a0) # 1000 <freep>
 8de:	c515                	beqz	a0,90a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	02977f63          	bgeu	a4,s1,922 <malloc+0x70>
 8e8:	8a4e                	mv	s4,s3
 8ea:	0009871b          	sext.w	a4,s3
 8ee:	6685                	lui	a3,0x1
 8f0:	00d77363          	bgeu	a4,a3,8f6 <malloc+0x44>
 8f4:	6a05                	lui	s4,0x1
 8f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fe:	00000917          	auipc	s2,0x0
 902:	70290913          	addi	s2,s2,1794 # 1000 <freep>
  if(p == (char*)-1)
 906:	5afd                	li	s5,-1
 908:	a0bd                	j	976 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 90a:	00001797          	auipc	a5,0x1
 90e:	90678793          	addi	a5,a5,-1786 # 1210 <base>
 912:	00000717          	auipc	a4,0x0
 916:	6ef73723          	sd	a5,1774(a4) # 1000 <freep>
 91a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 920:	b7e1                	j	8e8 <malloc+0x36>
      if(p->s.size == nunits)
 922:	02e48b63          	beq	s1,a4,958 <malloc+0xa6>
        p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	1702                	slli	a4,a4,0x20
 92e:	9301                	srli	a4,a4,0x20
 930:	0712                	slli	a4,a4,0x4
 932:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 934:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 938:	00000717          	auipc	a4,0x0
 93c:	6ca73423          	sd	a0,1736(a4) # 1000 <freep>
      return (void*)(p + 1);
 940:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 944:	70e2                	ld	ra,56(sp)
 946:	7442                	ld	s0,48(sp)
 948:	74a2                	ld	s1,40(sp)
 94a:	7902                	ld	s2,32(sp)
 94c:	69e2                	ld	s3,24(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	e118                	sd	a4,0(a0)
 95c:	bff1                	j	938 <malloc+0x86>
  hp->s.size = nu;
 95e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 962:	0541                	addi	a0,a0,16
 964:	ec7ff0ef          	jal	ra,82a <free>
  return freep;
 968:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 96c:	dd61                	beqz	a0,944 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	fa9778e3          	bgeu	a4,s1,922 <malloc+0x70>
    if(p == freep)
 976:	00093703          	ld	a4,0(s2)
 97a:	853e                	mv	a0,a5
 97c:	fef719e3          	bne	a4,a5,96e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 980:	8552                	mv	a0,s4
 982:	ad5ff0ef          	jal	ra,456 <sbrk>
  if(p == (char*)-1)
 986:	fd551ce3          	bne	a0,s5,95e <malloc+0xac>
        return 0;
 98a:	4501                	li	a0,0
 98c:	bf65                	j	944 <malloc+0x92>
