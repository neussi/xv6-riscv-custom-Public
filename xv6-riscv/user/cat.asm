
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	34a000ef          	jal	ra,36a <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	342000ef          	jal	ra,372 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	8e858593          	addi	a1,a1,-1816 # 920 <malloc+0xea>
  40:	4509                	li	a0,2
  42:	710000ef          	jal	ra,752 <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	30a000ef          	jal	ra,352 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8da58593          	addi	a1,a1,-1830 # 938 <malloc+0x102>
  66:	4509                	li	a0,2
  68:	6ea000ef          	jal	ra,752 <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	2e4000ef          	jal	ra,352 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	e052                	sd	s4,0(sp)
  80:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  82:	4785                	li	a5,1
  84:	02a7df63          	bge	a5,a0,c2 <main+0x50>
  88:	00858913          	addi	s2,a1,8
  8c:	ffe5099b          	addiw	s3,a0,-2
  90:	1982                	slli	s3,s3,0x20
  92:	0209d993          	srli	s3,s3,0x20
  96:	098e                	slli	s3,s3,0x3
  98:	05c1                	addi	a1,a1,16
  9a:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9c:	4581                	li	a1,0
  9e:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a2:	2f0000ef          	jal	ra,392 <open>
  a6:	84aa                	mv	s1,a0
  a8:	02054363          	bltz	a0,ce <main+0x5c>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  ac:	f55ff0ef          	jal	ra,0 <cat>
    close(fd);
  b0:	8526                	mv	a0,s1
  b2:	2c8000ef          	jal	ra,37a <close>
  for(i = 1; i < argc; i++){
  b6:	0921                	addi	s2,s2,8
  b8:	ff3912e3          	bne	s2,s3,9c <main+0x2a>
  }
  exit(0);
  bc:	4501                	li	a0,0
  be:	294000ef          	jal	ra,352 <exit>
    cat(0);
  c2:	4501                	li	a0,0
  c4:	f3dff0ef          	jal	ra,0 <cat>
    exit(0);
  c8:	4501                	li	a0,0
  ca:	288000ef          	jal	ra,352 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  ce:	00093603          	ld	a2,0(s2)
  d2:	00001597          	auipc	a1,0x1
  d6:	87e58593          	addi	a1,a1,-1922 # 950 <malloc+0x11a>
  da:	4509                	li	a0,2
  dc:	676000ef          	jal	ra,752 <fprintf>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	270000ef          	jal	ra,352 <exit>

00000000000000e6 <start>:
//


void
start()
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ee:	f85ff0ef          	jal	ra,72 <main>
  exit(0);
  f2:	4501                	li	a0,0
  f4:	25e000ef          	jal	ra,352 <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d663          	bge	s1,s4,202 <gets+0x52>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	188000ef          	jal	ra,36a <read>
    if(cc < 1)
 1e6:	00a05e63          	blez	a0,202 <gets+0x52>
    buf[i++] = c;
 1ea:	faf44783          	lbu	a5,-81(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f2:	01578763          	beq	a5,s5,200 <gets+0x50>
 1f6:	0905                	addi	s2,s2,1
 1f8:	fd679de3          	bne	a5,s6,1d2 <gets+0x22>
  for(i=0; i+1 < max; ){
 1fc:	89a6                	mv	s3,s1
 1fe:	a011                	j	202 <gets+0x52>
 200:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 202:	99de                	add	s3,s3,s7
 204:	00098023          	sb	zero,0(s3)
  return buf;
}
 208:	855e                	mv	a0,s7
 20a:	60e6                	ld	ra,88(sp)
 20c:	6446                	ld	s0,80(sp)
 20e:	64a6                	ld	s1,72(sp)
 210:	6906                	ld	s2,64(sp)
 212:	79e2                	ld	s3,56(sp)
 214:	7a42                	ld	s4,48(sp)
 216:	7aa2                	ld	s5,40(sp)
 218:	7b02                	ld	s6,32(sp)
 21a:	6be2                	ld	s7,24(sp)
 21c:	6125                	addi	sp,sp,96
 21e:	8082                	ret

0000000000000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	1101                	addi	sp,sp,-32
 222:	ec06                	sd	ra,24(sp)
 224:	e822                	sd	s0,16(sp)
 226:	e426                	sd	s1,8(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	162000ef          	jal	ra,392 <open>
  if(fd < 0)
 234:	02054163          	bltz	a0,256 <stat+0x36>
 238:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23a:	85ca                	mv	a1,s2
 23c:	16e000ef          	jal	ra,3aa <fstat>
 240:	892a                	mv	s2,a0
  close(fd);
 242:	8526                	mv	a0,s1
 244:	136000ef          	jal	ra,37a <close>
  return r;
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	64a2                	ld	s1,8(sp)
 250:	6902                	ld	s2,0(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret
    return -1;
 256:	597d                	li	s2,-1
 258:	bfc5                	j	248 <stat+0x28>

000000000000025a <atoi>:

int
atoi(const char *s)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054603          	lbu	a2,0(a0)
 264:	fd06079b          	addiw	a5,a2,-48
 268:	0ff7f793          	andi	a5,a5,255
 26c:	4725                	li	a4,9
 26e:	02f76963          	bltu	a4,a5,2a0 <atoi+0x46>
 272:	86aa                	mv	a3,a0
  n = 0;
 274:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 276:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 278:	0685                	addi	a3,a3,1
 27a:	0025179b          	slliw	a5,a0,0x2
 27e:	9fa9                	addw	a5,a5,a0
 280:	0017979b          	slliw	a5,a5,0x1
 284:	9fb1                	addw	a5,a5,a2
 286:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28a:	0006c603          	lbu	a2,0(a3)
 28e:	fd06071b          	addiw	a4,a2,-48
 292:	0ff77713          	andi	a4,a4,255
 296:	fee5f1e3          	bgeu	a1,a4,278 <atoi+0x1e>
  return n;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <atoi+0x40>

00000000000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57463          	bgeu	a0,a1,2d2 <memmove+0x2e>
    while(n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x28>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    dst += n;
 2d2:	00c50733          	add	a4,a0,a2
    src += n;
 2d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d8:	fec05ae3          	blez	a2,2cc <memmove+0x28>
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x46>
 2fa:	bfc9                	j	2cc <memmove+0x28>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 302:	ca05                	beqz	a2,332 <memcmp+0x36>
 304:	fff6069b          	addiw	a3,a2,-1
 308:	1682                	slli	a3,a3,0x20
 30a:	9281                	srli	a3,a3,0x20
 30c:	0685                	addi	a3,a3,1
 30e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79863          	bne	a5,a4,328 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x14>
  }
  return 0;
 324:	4501                	li	a0,0
 326:	a019                	j	32c <memcmp+0x30>
      return *p1 - *p2;
 328:	40e7853b          	subw	a0,a5,a4
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <memcmp+0x30>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	f67ff0ef          	jal	ra,2a4 <memmove>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34a:	4885                	li	a7,1
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <exit>:
.global exit
exit:
 li a7, SYS_exit
 352:	4889                	li	a7,2
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <wait>:
.global wait
wait:
 li a7, SYS_wait
 35a:	488d                	li	a7,3
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 362:	4891                	li	a7,4
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <read>:
.global read
read:
 li a7, SYS_read
 36a:	4895                	li	a7,5
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <write>:
.global write
write:
 li a7, SYS_write
 372:	48c1                	li	a7,16
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <close>:
.global close
close:
 li a7, SYS_close
 37a:	48d5                	li	a7,21
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <kill>:
.global kill
kill:
 li a7, SYS_kill
 382:	4899                	li	a7,6
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exec>:
.global exec
exec:
 li a7, SYS_exec
 38a:	489d                	li	a7,7
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <open>:
.global open
open:
 li a7, SYS_open
 392:	48bd                	li	a7,15
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39a:	48c5                	li	a7,17
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a2:	48c9                	li	a7,18
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3aa:	48a1                	li	a7,8
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <link>:
.global link
link:
 li a7, SYS_link
 3b2:	48cd                	li	a7,19
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ba:	48d1                	li	a7,20
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c2:	48a5                	li	a7,9
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ca:	48a9                	li	a7,10
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d2:	48ad                	li	a7,11
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3da:	48b1                	li	a7,12
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e2:	48b5                	li	a7,13
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ea:	48b9                	li	a7,14
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 3f2:	48d9                	li	a7,22
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 3fa:	48dd                	li	a7,23
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 402:	48e1                	li	a7,24
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 40a:	48e5                	li	a7,25
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41e:	4605                	li	a2,1
 420:	fef40593          	addi	a1,s0,-17
 424:	f4fff0ef          	jal	ra,372 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f426                	sd	s1,40(sp)
 438:	f04a                	sd	s2,32(sp)
 43a:	ec4e                	sd	s3,24(sp)
 43c:	0080                	addi	s0,sp,64
 43e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x16>
 442:	0805c663          	bltz	a1,4ce <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 446:	2581                	sext.w	a1,a1
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	2601                	sext.w	a2,a2
 452:	00000517          	auipc	a0,0x0
 456:	51e50513          	addi	a0,a0,1310 # 970 <digits>
 45a:	883a                	mv	a6,a4
 45c:	2705                	addiw	a4,a4,1
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97aa                	add	a5,a5,a0
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	0005879b          	sext.w	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f0e3          	bgeu	a5,a2,45a <printint+0x2a>
  if(neg)
 47e:	00088b63          	beqz	a7,494 <printint+0x64>
    buf[i++] = '-';
 482:	fd040793          	addi	a5,s0,-48
 486:	973e                	add	a4,a4,a5
 488:	02d00793          	li	a5,45
 48c:	fef70823          	sb	a5,-16(a4)
 490:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 494:	02e05663          	blez	a4,4c0 <printint+0x90>
 498:	fc040793          	addi	a5,s0,-64
 49c:	00e78933          	add	s2,a5,a4
 4a0:	fff78993          	addi	s3,a5,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	377d                	addiw	a4,a4,-1
 4a8:	1702                	slli	a4,a4,0x20
 4aa:	9301                	srli	a4,a4,0x20
 4ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b0:	fff94583          	lbu	a1,-1(s2)
 4b4:	8526                	mv	a0,s1
 4b6:	f5dff0ef          	jal	ra,412 <putc>
  while(--i >= 0)
 4ba:	197d                	addi	s2,s2,-1
 4bc:	ff391ae3          	bne	s2,s3,4b0 <printint+0x80>
}
 4c0:	70e2                	ld	ra,56(sp)
 4c2:	7442                	ld	s0,48(sp)
 4c4:	74a2                	ld	s1,40(sp)
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
    x = -xx;
 4ce:	40b005bb          	negw	a1,a1
    neg = 1;
 4d2:	4885                	li	a7,1
    x = -xx;
 4d4:	bf9d                	j	44a <printint+0x1a>

00000000000004d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d6:	7119                	addi	sp,sp,-128
 4d8:	fc86                	sd	ra,120(sp)
 4da:	f8a2                	sd	s0,112(sp)
 4dc:	f4a6                	sd	s1,104(sp)
 4de:	f0ca                	sd	s2,96(sp)
 4e0:	ecce                	sd	s3,88(sp)
 4e2:	e8d2                	sd	s4,80(sp)
 4e4:	e4d6                	sd	s5,72(sp)
 4e6:	e0da                	sd	s6,64(sp)
 4e8:	fc5e                	sd	s7,56(sp)
 4ea:	f862                	sd	s8,48(sp)
 4ec:	f466                	sd	s9,40(sp)
 4ee:	f06a                	sd	s10,32(sp)
 4f0:	ec6e                	sd	s11,24(sp)
 4f2:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f4:	0005c903          	lbu	s2,0(a1)
 4f8:	22090e63          	beqz	s2,734 <vprintf+0x25e>
 4fc:	8b2a                	mv	s6,a0
 4fe:	8a2e                	mv	s4,a1
 500:	8bb2                	mv	s7,a2
  state = 0;
 502:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 504:	4481                	li	s1,0
 506:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 508:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 50c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 510:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 514:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	00000c97          	auipc	s9,0x0
 51c:	458c8c93          	addi	s9,s9,1112 # 970 <digits>
 520:	a005                	j	540 <vprintf+0x6a>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	eedff0ef          	jal	ra,412 <putc>
 52a:	a019                	j	530 <vprintf+0x5a>
    } else if(state == '%'){
 52c:	03598263          	beq	s3,s5,550 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 530:	2485                	addiw	s1,s1,1
 532:	8726                	mv	a4,s1
 534:	009a07b3          	add	a5,s4,s1
 538:	0007c903          	lbu	s2,0(a5)
 53c:	1e090c63          	beqz	s2,734 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 540:	0009079b          	sext.w	a5,s2
    if(state == 0){
 544:	fe0994e3          	bnez	s3,52c <vprintf+0x56>
      if(c0 == '%'){
 548:	fd579de3          	bne	a5,s5,522 <vprintf+0x4c>
        state = '%';
 54c:	89be                	mv	s3,a5
 54e:	b7cd                	j	530 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 550:	cfa5                	beqz	a5,5c8 <vprintf+0xf2>
 552:	00ea06b3          	add	a3,s4,a4
 556:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 55a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 55c:	c681                	beqz	a3,564 <vprintf+0x8e>
 55e:	9752                	add	a4,a4,s4
 560:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 564:	03878a63          	beq	a5,s8,598 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 568:	05a78463          	beq	a5,s10,5b0 <vprintf+0xda>
      } else if(c0 == 'u'){
 56c:	0db78763          	beq	a5,s11,63a <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 570:	07800713          	li	a4,120
 574:	10e78963          	beq	a5,a4,686 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 578:	07000713          	li	a4,112
 57c:	12e78e63          	beq	a5,a4,6b8 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 580:	07300713          	li	a4,115
 584:	16e78b63          	beq	a5,a4,6fa <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 588:	05579063          	bne	a5,s5,5c8 <vprintf+0xf2>
        putc(fd, '%');
 58c:	85d6                	mv	a1,s5
 58e:	855a                	mv	a0,s6
 590:	e83ff0ef          	jal	ra,412 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 594:	4981                	li	s3,0
 596:	bf69                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 598:	008b8913          	addi	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e8bff0ef          	jal	ra,430 <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b749                	j	530 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5b0:	03868663          	beq	a3,s8,5dc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b4:	05a68163          	beq	a3,s10,5f6 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 5b8:	09b68d63          	beq	a3,s11,652 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5bc:	03a68f63          	beq	a3,s10,5fa <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 5c0:	07800793          	li	a5,120
 5c4:	0cf68d63          	beq	a3,a5,69e <vprintf+0x1c8>
        putc(fd, '%');
 5c8:	85d6                	mv	a1,s5
 5ca:	855a                	mv	a0,s6
 5cc:	e47ff0ef          	jal	ra,412 <putc>
        putc(fd, c0);
 5d0:	85ca                	mv	a1,s2
 5d2:	855a                	mv	a0,s6
 5d4:	e3fff0ef          	jal	ra,412 <putc>
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf99                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e47ff0ef          	jal	ra,430 <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	bf35                	j	530 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f6:	03860563          	beq	a2,s8,620 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5fa:	07b60963          	beq	a2,s11,66c <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5fe:	07800793          	li	a5,120
 602:	fcf613e3          	bne	a2,a5,5c8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e1dff0ef          	jal	ra,430 <printint>
        i += 2;
 618:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bf09                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e03ff0ef          	jal	ra,430 <printint>
        i += 2;
 632:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bde5                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	de9ff0ef          	jal	ra,430 <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	b5c5                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	dd1ff0ef          	jal	ra,430 <printint>
        i += 1;
 664:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 1;
 66a:	b5d9                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	db7ff0ef          	jal	ra,430 <printint>
        i += 2;
 67e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	b575                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4641                	li	a2,16
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d9dff0ef          	jal	ra,430 <printint>
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bd51                	j	530 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	d85ff0ef          	jal	ra,430 <printint>
        i += 1;
 6b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	bdad                	j	530 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6b8:	008b8793          	addi	a5,s7,8
 6bc:	f8f43423          	sd	a5,-120(s0)
 6c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c4:	03000593          	li	a1,48
 6c8:	855a                	mv	a0,s6
 6ca:	d49ff0ef          	jal	ra,412 <putc>
  putc(fd, 'x');
 6ce:	07800593          	li	a1,120
 6d2:	855a                	mv	a0,s6
 6d4:	d3fff0ef          	jal	ra,412 <putc>
 6d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	03c9d793          	srli	a5,s3,0x3c
 6de:	97e6                	add	a5,a5,s9
 6e0:	0007c583          	lbu	a1,0(a5)
 6e4:	855a                	mv	a0,s6
 6e6:	d2dff0ef          	jal	ra,412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ea:	0992                	slli	s3,s3,0x4
 6ec:	397d                	addiw	s2,s2,-1
 6ee:	fe0916e3          	bnez	s2,6da <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6f2:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	bd25                	j	530 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	008b8993          	addi	s3,s7,8
 6fe:	000bb903          	ld	s2,0(s7)
 702:	00090f63          	beqz	s2,720 <vprintf+0x24a>
        for(; *s; s++)
 706:	00094583          	lbu	a1,0(s2)
 70a:	c195                	beqz	a1,72e <vprintf+0x258>
          putc(fd, *s);
 70c:	855a                	mv	a0,s6
 70e:	d05ff0ef          	jal	ra,412 <putc>
        for(; *s; s++)
 712:	0905                	addi	s2,s2,1
 714:	00094583          	lbu	a1,0(s2)
 718:	f9f5                	bnez	a1,70c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bd09                	j	530 <vprintf+0x5a>
          s = "(null)";
 720:	00000917          	auipc	s2,0x0
 724:	24890913          	addi	s2,s2,584 # 968 <malloc+0x132>
        for(; *s; s++)
 728:	02800593          	li	a1,40
 72c:	b7c5                	j	70c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	bbfd                	j	530 <vprintf+0x5a>
    }
  }
}
 734:	70e6                	ld	ra,120(sp)
 736:	7446                	ld	s0,112(sp)
 738:	74a6                	ld	s1,104(sp)
 73a:	7906                	ld	s2,96(sp)
 73c:	69e6                	ld	s3,88(sp)
 73e:	6a46                	ld	s4,80(sp)
 740:	6aa6                	ld	s5,72(sp)
 742:	6b06                	ld	s6,64(sp)
 744:	7be2                	ld	s7,56(sp)
 746:	7c42                	ld	s8,48(sp)
 748:	7ca2                	ld	s9,40(sp)
 74a:	7d02                	ld	s10,32(sp)
 74c:	6de2                	ld	s11,24(sp)
 74e:	6109                	addi	sp,sp,128
 750:	8082                	ret

0000000000000752 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 752:	715d                	addi	sp,sp,-80
 754:	ec06                	sd	ra,24(sp)
 756:	e822                	sd	s0,16(sp)
 758:	1000                	addi	s0,sp,32
 75a:	e010                	sd	a2,0(s0)
 75c:	e414                	sd	a3,8(s0)
 75e:	e818                	sd	a4,16(s0)
 760:	ec1c                	sd	a5,24(s0)
 762:	03043023          	sd	a6,32(s0)
 766:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76e:	8622                	mv	a2,s0
 770:	d67ff0ef          	jal	ra,4d6 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void
printf(const char *fmt, ...)
{
 77c:	711d                	addi	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	addi	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	d35ff0ef          	jal	ra,4d6 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6125                	addi	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ae:	1141                	addi	sp,sp,-16
 7b0:	e422                	sd	s0,8(sp)
 7b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	00001797          	auipc	a5,0x1
 7bc:	8487b783          	ld	a5,-1976(a5) # 1000 <freep>
 7c0:	a805                	j	7f0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c2:	4618                	lw	a4,8(a2)
 7c4:	9db9                	addw	a1,a1,a4
 7c6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	6318                	ld	a4,0(a4)
 7ce:	fee53823          	sd	a4,-16(a0)
 7d2:	a091                	j	816 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9e39                	addw	a2,a2,a4
 7da:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053703          	ld	a4,-16(a0)
 7e0:	e398                	sd	a4,0(a5)
 7e2:	a099                	j	828 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e7e463          	bltu	a5,a4,7ee <free+0x40>
 7ea:	00e6ea63          	bltu	a3,a4,7fe <free+0x50>
{
 7ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fed7fae3          	bgeu	a5,a3,7e4 <free+0x36>
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e6e463          	bltu	a3,a4,7fe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	fee7eae3          	bltu	a5,a4,7ee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7fe:	ff852583          	lw	a1,-8(a0)
 802:	6390                	ld	a2,0(a5)
 804:	02059713          	slli	a4,a1,0x20
 808:	9301                	srli	a4,a4,0x20
 80a:	0712                	slli	a4,a4,0x4
 80c:	9736                	add	a4,a4,a3
 80e:	fae60ae3          	beq	a2,a4,7c2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 812:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 816:	4790                	lw	a2,8(a5)
 818:	02061713          	slli	a4,a2,0x20
 81c:	9301                	srli	a4,a4,0x20
 81e:	0712                	slli	a4,a4,0x4
 820:	973e                	add	a4,a4,a5
 822:	fae689e3          	beq	a3,a4,7d4 <free+0x26>
  } else
    p->s.ptr = bp;
 826:	e394                	sd	a3,0(a5)
  freep = p;
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
}
 830:	6422                	ld	s0,8(sp)
 832:	0141                	addi	sp,sp,16
 834:	8082                	ret

0000000000000836 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 836:	7139                	addi	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f426                	sd	s1,40(sp)
 83e:	f04a                	sd	s2,32(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
 848:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84a:	02051493          	slli	s1,a0,0x20
 84e:	9081                	srli	s1,s1,0x20
 850:	04bd                	addi	s1,s1,15
 852:	8091                	srli	s1,s1,0x4
 854:	0014899b          	addiw	s3,s1,1
 858:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 85a:	00000517          	auipc	a0,0x0
 85e:	7a653503          	ld	a0,1958(a0) # 1000 <freep>
 862:	c515                	beqz	a0,88e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	02977f63          	bgeu	a4,s1,8a6 <malloc+0x70>
 86c:	8a4e                	mv	s4,s3
 86e:	0009871b          	sext.w	a4,s3
 872:	6685                	lui	a3,0x1
 874:	00d77363          	bgeu	a4,a3,87a <malloc+0x44>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 882:	00000917          	auipc	s2,0x0
 886:	77e90913          	addi	s2,s2,1918 # 1000 <freep>
  if(p == (char*)-1)
 88a:	5afd                	li	s5,-1
 88c:	a0bd                	j	8fa <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 88e:	00001797          	auipc	a5,0x1
 892:	98278793          	addi	a5,a5,-1662 # 1210 <base>
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
 89e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a4:	b7e1                	j	86c <malloc+0x36>
      if(p->s.size == nunits)
 8a6:	02e48b63          	beq	s1,a4,8dc <malloc+0xa6>
        p->s.size -= nunits;
 8aa:	4137073b          	subw	a4,a4,s3
 8ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b0:	1702                	slli	a4,a4,0x20
 8b2:	9301                	srli	a4,a4,0x20
 8b4:	0712                	slli	a4,a4,0x4
 8b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74a73223          	sd	a0,1860(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c8:	70e2                	ld	ra,56(sp)
 8ca:	7442                	ld	s0,48(sp)
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	7902                	ld	s2,32(sp)
 8d0:	69e2                	ld	s3,24(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	6121                	addi	sp,sp,64
 8da:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	bff1                	j	8bc <malloc+0x86>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	ec7ff0ef          	jal	ra,7ae <free>
  return freep;
 8ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f0:	dd61                	beqz	a0,8c8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	fa9778e3          	bgeu	a4,s1,8a6 <malloc+0x70>
    if(p == freep)
 8fa:	00093703          	ld	a4,0(s2)
 8fe:	853e                	mv	a0,a5
 900:	fef719e3          	bne	a4,a5,8f2 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	ad5ff0ef          	jal	ra,3da <sbrk>
  if(p == (char*)-1)
 90a:	fd551ce3          	bne	a0,s5,8e2 <malloc+0xac>
        return 0;
 90e:	4501                	li	a0,0
 910:	bf65                	j	8c8 <malloc+0x92>
