
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2ae000ef          	jal	ra,2be <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	286000ef          	jal	ra,2be <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	268000ef          	jal	ra,2be <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3b8000ef          	jal	ra,422 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	24e000ef          	jal	ra,2be <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	244000ef          	jal	ra,2be <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	258000ef          	jal	ra,2e8 <memset>
  return buf;
  94:	84ce                	mv	s1,s3
  96:	b77d                	j	44 <fmtname+0x44>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	24913c23          	sd	s1,600(sp)
  a8:	25213823          	sd	s2,592(sp)
  ac:	25313423          	sd	s3,584(sp)
  b0:	25413023          	sd	s4,576(sp)
  b4:	23513c23          	sd	s5,568(sp)
  b8:	1c80                	addi	s0,sp,624
  ba:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  bc:	4581                	li	a1,0
  be:	452000ef          	jal	ra,510 <open>
  c2:	06054963          	bltz	a0,134 <ls+0x9c>
  c6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  c8:	d9840593          	addi	a1,s0,-616
  cc:	45c000ef          	jal	ra,528 <fstat>
  d0:	06054b63          	bltz	a0,146 <ls+0xae>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d4:	da041783          	lh	a5,-608(s0)
  d8:	0007869b          	sext.w	a3,a5
  dc:	4705                	li	a4,1
  de:	08e68063          	beq	a3,a4,15e <ls+0xc6>
  e2:	37f9                	addiw	a5,a5,-2
  e4:	17c2                	slli	a5,a5,0x30
  e6:	93c1                	srli	a5,a5,0x30
  e8:	02f76263          	bltu	a4,a5,10c <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  ec:	854a                	mv	a0,s2
  ee:	f13ff0ef          	jal	ra,0 <fmtname>
  f2:	85aa                	mv	a1,a0
  f4:	da842703          	lw	a4,-600(s0)
  f8:	d9c42683          	lw	a3,-612(s0)
  fc:	da041603          	lh	a2,-608(s0)
 100:	00001517          	auipc	a0,0x1
 104:	9c050513          	addi	a0,a0,-1600 # ac0 <malloc+0x114>
 108:	7ea000ef          	jal	ra,8f2 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 10c:	8526                	mv	a0,s1
 10e:	3ea000ef          	jal	ra,4f8 <close>
}
 112:	26813083          	ld	ra,616(sp)
 116:	26013403          	ld	s0,608(sp)
 11a:	25813483          	ld	s1,600(sp)
 11e:	25013903          	ld	s2,592(sp)
 122:	24813983          	ld	s3,584(sp)
 126:	24013a03          	ld	s4,576(sp)
 12a:	23813a83          	ld	s5,568(sp)
 12e:	27010113          	addi	sp,sp,624
 132:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 134:	864a                	mv	a2,s2
 136:	00001597          	auipc	a1,0x1
 13a:	95a58593          	addi	a1,a1,-1702 # a90 <malloc+0xe4>
 13e:	4509                	li	a0,2
 140:	788000ef          	jal	ra,8c8 <fprintf>
    return;
 144:	b7f9                	j	112 <ls+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 146:	864a                	mv	a2,s2
 148:	00001597          	auipc	a1,0x1
 14c:	96058593          	addi	a1,a1,-1696 # aa8 <malloc+0xfc>
 150:	4509                	li	a0,2
 152:	776000ef          	jal	ra,8c8 <fprintf>
    close(fd);
 156:	8526                	mv	a0,s1
 158:	3a0000ef          	jal	ra,4f8 <close>
    return;
 15c:	bf5d                	j	112 <ls+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 15e:	854a                	mv	a0,s2
 160:	15e000ef          	jal	ra,2be <strlen>
 164:	2541                	addiw	a0,a0,16
 166:	20000793          	li	a5,512
 16a:	00a7f963          	bgeu	a5,a0,17c <ls+0xe4>
      printf("ls: path too long\n");
 16e:	00001517          	auipc	a0,0x1
 172:	96250513          	addi	a0,a0,-1694 # ad0 <malloc+0x124>
 176:	77c000ef          	jal	ra,8f2 <printf>
      break;
 17a:	bf49                	j	10c <ls+0x74>
    strcpy(buf, path);
 17c:	85ca                	mv	a1,s2
 17e:	dc040513          	addi	a0,s0,-576
 182:	0f4000ef          	jal	ra,276 <strcpy>
    p = buf+strlen(buf);
 186:	dc040513          	addi	a0,s0,-576
 18a:	134000ef          	jal	ra,2be <strlen>
 18e:	02051913          	slli	s2,a0,0x20
 192:	02095913          	srli	s2,s2,0x20
 196:	dc040793          	addi	a5,s0,-576
 19a:	993e                	add	s2,s2,a5
    *p++ = '/';
 19c:	00190993          	addi	s3,s2,1
 1a0:	02f00793          	li	a5,47
 1a4:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1a8:	00001a17          	auipc	s4,0x1
 1ac:	918a0a13          	addi	s4,s4,-1768 # ac0 <malloc+0x114>
        printf("ls: cannot stat %s\n", buf);
 1b0:	00001a97          	auipc	s5,0x1
 1b4:	8f8a8a93          	addi	s5,s5,-1800 # aa8 <malloc+0xfc>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b8:	a031                	j	1c4 <ls+0x12c>
        printf("ls: cannot stat %s\n", buf);
 1ba:	dc040593          	addi	a1,s0,-576
 1be:	8556                	mv	a0,s5
 1c0:	732000ef          	jal	ra,8f2 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c4:	4641                	li	a2,16
 1c6:	db040593          	addi	a1,s0,-592
 1ca:	8526                	mv	a0,s1
 1cc:	31c000ef          	jal	ra,4e8 <read>
 1d0:	47c1                	li	a5,16
 1d2:	f2f51de3          	bne	a0,a5,10c <ls+0x74>
      if(de.inum == 0)
 1d6:	db045783          	lhu	a5,-592(s0)
 1da:	d7ed                	beqz	a5,1c4 <ls+0x12c>
      memmove(p, de.name, DIRSIZ);
 1dc:	4639                	li	a2,14
 1de:	db240593          	addi	a1,s0,-590
 1e2:	854e                	mv	a0,s3
 1e4:	23e000ef          	jal	ra,422 <memmove>
      p[DIRSIZ] = 0;
 1e8:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1ec:	d9840593          	addi	a1,s0,-616
 1f0:	dc040513          	addi	a0,s0,-576
 1f4:	1aa000ef          	jal	ra,39e <stat>
 1f8:	fc0541e3          	bltz	a0,1ba <ls+0x122>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	dc040513          	addi	a0,s0,-576
 200:	e01ff0ef          	jal	ra,0 <fmtname>
 204:	85aa                	mv	a1,a0
 206:	da842703          	lw	a4,-600(s0)
 20a:	d9c42683          	lw	a3,-612(s0)
 20e:	da041603          	lh	a2,-608(s0)
 212:	8552                	mv	a0,s4
 214:	6de000ef          	jal	ra,8f2 <printf>
 218:	b775                	j	1c4 <ls+0x12c>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e426                	sd	s1,8(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 226:	4785                	li	a5,1
 228:	02a7d563          	bge	a5,a0,252 <main+0x38>
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	1902                	slli	s2,s2,0x20
 236:	02095913          	srli	s2,s2,0x20
 23a:	090e                	slli	s2,s2,0x3
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	ra,98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	282000ef          	jal	ra,4d0 <exit>
    ls(".");
 252:	00001517          	auipc	a0,0x1
 256:	89650513          	addi	a0,a0,-1898 # ae8 <malloc+0x13c>
 25a:	e3fff0ef          	jal	ra,98 <ls>
    exit(0);
 25e:	4501                	li	a0,0
 260:	270000ef          	jal	ra,4d0 <exit>

0000000000000264 <start>:
//


void
start()
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 26c:	fafff0ef          	jal	ra,21a <main>
  exit(0);
 270:	4501                	li	a0,0
 272:	25e000ef          	jal	ra,4d0 <exit>

0000000000000276 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27c:	87aa                	mv	a5,a0
 27e:	0585                	addi	a1,a1,1
 280:	0785                	addi	a5,a5,1
 282:	fff5c703          	lbu	a4,-1(a1)
 286:	fee78fa3          	sb	a4,-1(a5)
 28a:	fb75                	bnez	a4,27e <strcpy+0x8>
    ;
  return os;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb91                	beqz	a5,2b0 <strcmp+0x1e>
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00f71763          	bne	a4,a5,2b0 <strcmp+0x1e>
    p++, q++;
 2a6:	0505                	addi	a0,a0,1
 2a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbe5                	bnez	a5,29e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b0:	0005c503          	lbu	a0,0(a1)
}
 2b4:	40a7853b          	subw	a0,a5,a0
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strlen>:

uint
strlen(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x26>
 2ca:	0505                	addi	a0,a0,1
 2cc:	87aa                	mv	a5,a0
 2ce:	4685                	li	a3,1
 2d0:	9e89                	subw	a3,a3,a0
 2d2:	00f6853b          	addw	a0,a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	fb7d                	bnez	a4,2d2 <strlen+0x14>
    ;
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ca19                	beqz	a2,304 <memset+0x1c>
 2f0:	87aa                	mv	a5,a0
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fe:	0785                	addi	a5,a5,1
 300:	fee79de3          	bne	a5,a4,2fa <memset+0x12>
  }
  return dst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char*
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cb99                	beqz	a5,32a <strchr+0x20>
    if(*s == c)
 316:	00f58763          	beq	a1,a5,324 <strchr+0x1a>
  for(; *s; s++)
 31a:	0505                	addi	a0,a0,1
 31c:	00054783          	lbu	a5,0(a0)
 320:	fbfd                	bnez	a5,316 <strchr+0xc>
      return (char*)s;
  return 0;
 322:	4501                	li	a0,0
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  return 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <strchr+0x1a>

000000000000032e <gets>:

char*
gets(char *buf, int max)
{
 32e:	711d                	addi	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	1080                	addi	s0,sp,96
 344:	8baa                	mv	s7,a0
 346:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 348:	892a                	mv	s2,a0
 34a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34c:	4aa9                	li	s5,10
 34e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 350:	89a6                	mv	s3,s1
 352:	2485                	addiw	s1,s1,1
 354:	0344d663          	bge	s1,s4,380 <gets+0x52>
    cc = read(0, &c, 1);
 358:	4605                	li	a2,1
 35a:	faf40593          	addi	a1,s0,-81
 35e:	4501                	li	a0,0
 360:	188000ef          	jal	ra,4e8 <read>
    if(cc < 1)
 364:	00a05e63          	blez	a0,380 <gets+0x52>
    buf[i++] = c;
 368:	faf44783          	lbu	a5,-81(s0)
 36c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 370:	01578763          	beq	a5,s5,37e <gets+0x50>
 374:	0905                	addi	s2,s2,1
 376:	fd679de3          	bne	a5,s6,350 <gets+0x22>
  for(i=0; i+1 < max; ){
 37a:	89a6                	mv	s3,s1
 37c:	a011                	j	380 <gets+0x52>
 37e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 380:	99de                	add	s3,s3,s7
 382:	00098023          	sb	zero,0(s3)
  return buf;
}
 386:	855e                	mv	a0,s7
 388:	60e6                	ld	ra,88(sp)
 38a:	6446                	ld	s0,80(sp)
 38c:	64a6                	ld	s1,72(sp)
 38e:	6906                	ld	s2,64(sp)
 390:	79e2                	ld	s3,56(sp)
 392:	7a42                	ld	s4,48(sp)
 394:	7aa2                	ld	s5,40(sp)
 396:	7b02                	ld	s6,32(sp)
 398:	6be2                	ld	s7,24(sp)
 39a:	6125                	addi	sp,sp,96
 39c:	8082                	ret

000000000000039e <stat>:

int
stat(const char *n, struct stat *st)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	e426                	sd	s1,8(sp)
 3a6:	e04a                	sd	s2,0(sp)
 3a8:	1000                	addi	s0,sp,32
 3aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ac:	4581                	li	a1,0
 3ae:	162000ef          	jal	ra,510 <open>
  if(fd < 0)
 3b2:	02054163          	bltz	a0,3d4 <stat+0x36>
 3b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b8:	85ca                	mv	a1,s2
 3ba:	16e000ef          	jal	ra,528 <fstat>
 3be:	892a                	mv	s2,a0
  close(fd);
 3c0:	8526                	mv	a0,s1
 3c2:	136000ef          	jal	ra,4f8 <close>
  return r;
}
 3c6:	854a                	mv	a0,s2
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	64a2                	ld	s1,8(sp)
 3ce:	6902                	ld	s2,0(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret
    return -1;
 3d4:	597d                	li	s2,-1
 3d6:	bfc5                	j	3c6 <stat+0x28>

00000000000003d8 <atoi>:

int
atoi(const char *s)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3de:	00054603          	lbu	a2,0(a0)
 3e2:	fd06079b          	addiw	a5,a2,-48
 3e6:	0ff7f793          	andi	a5,a5,255
 3ea:	4725                	li	a4,9
 3ec:	02f76963          	bltu	a4,a5,41e <atoi+0x46>
 3f0:	86aa                	mv	a3,a0
  n = 0;
 3f2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f6:	0685                	addi	a3,a3,1
 3f8:	0025179b          	slliw	a5,a0,0x2
 3fc:	9fa9                	addw	a5,a5,a0
 3fe:	0017979b          	slliw	a5,a5,0x1
 402:	9fb1                	addw	a5,a5,a2
 404:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 408:	0006c603          	lbu	a2,0(a3)
 40c:	fd06071b          	addiw	a4,a2,-48
 410:	0ff77713          	andi	a4,a4,255
 414:	fee5f1e3          	bgeu	a1,a4,3f6 <atoi+0x1e>
  return n;
}
 418:	6422                	ld	s0,8(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret
  n = 0;
 41e:	4501                	li	a0,0
 420:	bfe5                	j	418 <atoi+0x40>

0000000000000422 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 422:	1141                	addi	sp,sp,-16
 424:	e422                	sd	s0,8(sp)
 426:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 428:	02b57463          	bgeu	a0,a1,450 <memmove+0x2e>
    while(n-- > 0)
 42c:	00c05f63          	blez	a2,44a <memmove+0x28>
 430:	1602                	slli	a2,a2,0x20
 432:	9201                	srli	a2,a2,0x20
 434:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 438:	872a                	mv	a4,a0
      *dst++ = *src++;
 43a:	0585                	addi	a1,a1,1
 43c:	0705                	addi	a4,a4,1
 43e:	fff5c683          	lbu	a3,-1(a1)
 442:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 446:	fee79ae3          	bne	a5,a4,43a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret
    dst += n;
 450:	00c50733          	add	a4,a0,a2
    src += n;
 454:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 456:	fec05ae3          	blez	a2,44a <memmove+0x28>
 45a:	fff6079b          	addiw	a5,a2,-1
 45e:	1782                	slli	a5,a5,0x20
 460:	9381                	srli	a5,a5,0x20
 462:	fff7c793          	not	a5,a5
 466:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 468:	15fd                	addi	a1,a1,-1
 46a:	177d                	addi	a4,a4,-1
 46c:	0005c683          	lbu	a3,0(a1)
 470:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 474:	fee79ae3          	bne	a5,a4,468 <memmove+0x46>
 478:	bfc9                	j	44a <memmove+0x28>

000000000000047a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 480:	ca05                	beqz	a2,4b0 <memcmp+0x36>
 482:	fff6069b          	addiw	a3,a2,-1
 486:	1682                	slli	a3,a3,0x20
 488:	9281                	srli	a3,a3,0x20
 48a:	0685                	addi	a3,a3,1
 48c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48e:	00054783          	lbu	a5,0(a0)
 492:	0005c703          	lbu	a4,0(a1)
 496:	00e79863          	bne	a5,a4,4a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49a:	0505                	addi	a0,a0,1
    p2++;
 49c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49e:	fed518e3          	bne	a0,a3,48e <memcmp+0x14>
  }
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	a019                	j	4aa <memcmp+0x30>
      return *p1 - *p2;
 4a6:	40e7853b          	subw	a0,a5,a4
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret
  return 0;
 4b0:	4501                	li	a0,0
 4b2:	bfe5                	j	4aa <memcmp+0x30>

00000000000004b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e406                	sd	ra,8(sp)
 4b8:	e022                	sd	s0,0(sp)
 4ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4bc:	f67ff0ef          	jal	ra,422 <memmove>
}
 4c0:	60a2                	ld	ra,8(sp)
 4c2:	6402                	ld	s0,0(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret

00000000000004c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c8:	4885                	li	a7,1
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d0:	4889                	li	a7,2
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d8:	488d                	li	a7,3
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e0:	4891                	li	a7,4
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <read>:
.global read
read:
 li a7, SYS_read
 4e8:	4895                	li	a7,5
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <write>:
.global write
write:
 li a7, SYS_write
 4f0:	48c1                	li	a7,16
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <close>:
.global close
close:
 li a7, SYS_close
 4f8:	48d5                	li	a7,21
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <kill>:
.global kill
kill:
 li a7, SYS_kill
 500:	4899                	li	a7,6
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <exec>:
.global exec
exec:
 li a7, SYS_exec
 508:	489d                	li	a7,7
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <open>:
.global open
open:
 li a7, SYS_open
 510:	48bd                	li	a7,15
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 518:	48c5                	li	a7,17
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 520:	48c9                	li	a7,18
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 528:	48a1                	li	a7,8
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <link>:
.global link
link:
 li a7, SYS_link
 530:	48cd                	li	a7,19
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 538:	48d1                	li	a7,20
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 540:	48a5                	li	a7,9
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <dup>:
.global dup
dup:
 li a7, SYS_dup
 548:	48a9                	li	a7,10
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 550:	48ad                	li	a7,11
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 558:	48b1                	li	a7,12
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 560:	48b5                	li	a7,13
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 568:	48b9                	li	a7,14
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 570:	48d9                	li	a7,22
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <getprocstat>:
.global getprocstat
getprocstat:
 li a7, SYS_getprocstat
 578:	48dd                	li	a7,23
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 580:	48e1                	li	a7,24
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 588:	1101                	addi	sp,sp,-32
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	1000                	addi	s0,sp,32
 590:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 594:	4605                	li	a2,1
 596:	fef40593          	addi	a1,s0,-17
 59a:	f57ff0ef          	jal	ra,4f0 <write>
}
 59e:	60e2                	ld	ra,24(sp)
 5a0:	6442                	ld	s0,16(sp)
 5a2:	6105                	addi	sp,sp,32
 5a4:	8082                	ret

00000000000005a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a6:	7139                	addi	sp,sp,-64
 5a8:	fc06                	sd	ra,56(sp)
 5aa:	f822                	sd	s0,48(sp)
 5ac:	f426                	sd	s1,40(sp)
 5ae:	f04a                	sd	s2,32(sp)
 5b0:	ec4e                	sd	s3,24(sp)
 5b2:	0080                	addi	s0,sp,64
 5b4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b6:	c299                	beqz	a3,5bc <printint+0x16>
 5b8:	0805c663          	bltz	a1,644 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5bc:	2581                	sext.w	a1,a1
  neg = 0;
 5be:	4881                	li	a7,0
 5c0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c6:	2601                	sext.w	a2,a2
 5c8:	00000517          	auipc	a0,0x0
 5cc:	53050513          	addi	a0,a0,1328 # af8 <digits>
 5d0:	883a                	mv	a6,a4
 5d2:	2705                	addiw	a4,a4,1
 5d4:	02c5f7bb          	remuw	a5,a1,a2
 5d8:	1782                	slli	a5,a5,0x20
 5da:	9381                	srli	a5,a5,0x20
 5dc:	97aa                	add	a5,a5,a0
 5de:	0007c783          	lbu	a5,0(a5)
 5e2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e6:	0005879b          	sext.w	a5,a1
 5ea:	02c5d5bb          	divuw	a1,a1,a2
 5ee:	0685                	addi	a3,a3,1
 5f0:	fec7f0e3          	bgeu	a5,a2,5d0 <printint+0x2a>
  if(neg)
 5f4:	00088b63          	beqz	a7,60a <printint+0x64>
    buf[i++] = '-';
 5f8:	fd040793          	addi	a5,s0,-48
 5fc:	973e                	add	a4,a4,a5
 5fe:	02d00793          	li	a5,45
 602:	fef70823          	sb	a5,-16(a4)
 606:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 60a:	02e05663          	blez	a4,636 <printint+0x90>
 60e:	fc040793          	addi	a5,s0,-64
 612:	00e78933          	add	s2,a5,a4
 616:	fff78993          	addi	s3,a5,-1
 61a:	99ba                	add	s3,s3,a4
 61c:	377d                	addiw	a4,a4,-1
 61e:	1702                	slli	a4,a4,0x20
 620:	9301                	srli	a4,a4,0x20
 622:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 626:	fff94583          	lbu	a1,-1(s2)
 62a:	8526                	mv	a0,s1
 62c:	f5dff0ef          	jal	ra,588 <putc>
  while(--i >= 0)
 630:	197d                	addi	s2,s2,-1
 632:	ff391ae3          	bne	s2,s3,626 <printint+0x80>
}
 636:	70e2                	ld	ra,56(sp)
 638:	7442                	ld	s0,48(sp)
 63a:	74a2                	ld	s1,40(sp)
 63c:	7902                	ld	s2,32(sp)
 63e:	69e2                	ld	s3,24(sp)
 640:	6121                	addi	sp,sp,64
 642:	8082                	ret
    x = -xx;
 644:	40b005bb          	negw	a1,a1
    neg = 1;
 648:	4885                	li	a7,1
    x = -xx;
 64a:	bf9d                	j	5c0 <printint+0x1a>

000000000000064c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 64c:	7119                	addi	sp,sp,-128
 64e:	fc86                	sd	ra,120(sp)
 650:	f8a2                	sd	s0,112(sp)
 652:	f4a6                	sd	s1,104(sp)
 654:	f0ca                	sd	s2,96(sp)
 656:	ecce                	sd	s3,88(sp)
 658:	e8d2                	sd	s4,80(sp)
 65a:	e4d6                	sd	s5,72(sp)
 65c:	e0da                	sd	s6,64(sp)
 65e:	fc5e                	sd	s7,56(sp)
 660:	f862                	sd	s8,48(sp)
 662:	f466                	sd	s9,40(sp)
 664:	f06a                	sd	s10,32(sp)
 666:	ec6e                	sd	s11,24(sp)
 668:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66a:	0005c903          	lbu	s2,0(a1)
 66e:	22090e63          	beqz	s2,8aa <vprintf+0x25e>
 672:	8b2a                	mv	s6,a0
 674:	8a2e                	mv	s4,a1
 676:	8bb2                	mv	s7,a2
  state = 0;
 678:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 67a:	4481                	li	s1,0
 67c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 67e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 682:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 686:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 68a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	00000c97          	auipc	s9,0x0
 692:	46ac8c93          	addi	s9,s9,1130 # af8 <digits>
 696:	a005                	j	6b6 <vprintf+0x6a>
        putc(fd, c0);
 698:	85ca                	mv	a1,s2
 69a:	855a                	mv	a0,s6
 69c:	eedff0ef          	jal	ra,588 <putc>
 6a0:	a019                	j	6a6 <vprintf+0x5a>
    } else if(state == '%'){
 6a2:	03598263          	beq	s3,s5,6c6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a6:	2485                	addiw	s1,s1,1
 6a8:	8726                	mv	a4,s1
 6aa:	009a07b3          	add	a5,s4,s1
 6ae:	0007c903          	lbu	s2,0(a5)
 6b2:	1e090c63          	beqz	s2,8aa <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 6b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ba:	fe0994e3          	bnez	s3,6a2 <vprintf+0x56>
      if(c0 == '%'){
 6be:	fd579de3          	bne	a5,s5,698 <vprintf+0x4c>
        state = '%';
 6c2:	89be                	mv	s3,a5
 6c4:	b7cd                	j	6a6 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6c6:	cfa5                	beqz	a5,73e <vprintf+0xf2>
 6c8:	00ea06b3          	add	a3,s4,a4
 6cc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d2:	c681                	beqz	a3,6da <vprintf+0x8e>
 6d4:	9752                	add	a4,a4,s4
 6d6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6da:	03878a63          	beq	a5,s8,70e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	05a78463          	beq	a5,s10,726 <vprintf+0xda>
      } else if(c0 == 'u'){
 6e2:	0db78763          	beq	a5,s11,7b0 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6e6:	07800713          	li	a4,120
 6ea:	10e78963          	beq	a5,a4,7fc <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6ee:	07000713          	li	a4,112
 6f2:	12e78e63          	beq	a5,a4,82e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6f6:	07300713          	li	a4,115
 6fa:	16e78b63          	beq	a5,a4,870 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6fe:	05579063          	bne	a5,s5,73e <vprintf+0xf2>
        putc(fd, '%');
 702:	85d6                	mv	a1,s5
 704:	855a                	mv	a0,s6
 706:	e83ff0ef          	jal	ra,588 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bf69                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 70e:	008b8913          	addi	s2,s7,8
 712:	4685                	li	a3,1
 714:	4629                	li	a2,10
 716:	000ba583          	lw	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	e8bff0ef          	jal	ra,5a6 <printint>
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	b749                	j	6a6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 726:	03868663          	beq	a3,s8,752 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72a:	05a68163          	beq	a3,s10,76c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 72e:	09b68d63          	beq	a3,s11,7c8 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 732:	03a68f63          	beq	a3,s10,770 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 736:	07800793          	li	a5,120
 73a:	0cf68d63          	beq	a3,a5,814 <vprintf+0x1c8>
        putc(fd, '%');
 73e:	85d6                	mv	a1,s5
 740:	855a                	mv	a0,s6
 742:	e47ff0ef          	jal	ra,588 <putc>
        putc(fd, c0);
 746:	85ca                	mv	a1,s2
 748:	855a                	mv	a0,s6
 74a:	e3fff0ef          	jal	ra,588 <putc>
      state = 0;
 74e:	4981                	li	s3,0
 750:	bf99                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 752:	008b8913          	addi	s2,s7,8
 756:	4685                	li	a3,1
 758:	4629                	li	a2,10
 75a:	000ba583          	lw	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	e47ff0ef          	jal	ra,5a6 <printint>
        i += 1;
 764:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
        i += 1;
 76a:	bf35                	j	6a6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76c:	03860563          	beq	a2,s8,796 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 770:	07b60963          	beq	a2,s11,7e2 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 774:	07800793          	li	a5,120
 778:	fcf613e3          	bne	a2,a5,73e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 77c:	008b8913          	addi	s2,s7,8
 780:	4681                	li	a3,0
 782:	4641                	li	a2,16
 784:	000ba583          	lw	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e1dff0ef          	jal	ra,5a6 <printint>
        i += 2;
 78e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
        i += 2;
 794:	bf09                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 796:	008b8913          	addi	s2,s7,8
 79a:	4685                	li	a3,1
 79c:	4629                	li	a2,10
 79e:	000ba583          	lw	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e03ff0ef          	jal	ra,5a6 <printint>
        i += 2;
 7a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
        i += 2;
 7ae:	bde5                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4629                	li	a2,10
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	de9ff0ef          	jal	ra,5a6 <printint>
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b5c5                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4629                	li	a2,10
 7d0:	000ba583          	lw	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	dd1ff0ef          	jal	ra,5a6 <printint>
        i += 1;
 7da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
        i += 1;
 7e0:	b5d9                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	db7ff0ef          	jal	ra,5a6 <printint>
        i += 2;
 7f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 2;
 7fa:	b575                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	d9dff0ef          	jal	ra,5a6 <printint>
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	bd51                	j	6a6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 814:	008b8913          	addi	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4641                	li	a2,16
 81c:	000ba583          	lw	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	d85ff0ef          	jal	ra,5a6 <printint>
        i += 1;
 826:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
        i += 1;
 82c:	bdad                	j	6a6 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 82e:	008b8793          	addi	a5,s7,8
 832:	f8f43423          	sd	a5,-120(s0)
 836:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 83a:	03000593          	li	a1,48
 83e:	855a                	mv	a0,s6
 840:	d49ff0ef          	jal	ra,588 <putc>
  putc(fd, 'x');
 844:	07800593          	li	a1,120
 848:	855a                	mv	a0,s6
 84a:	d3fff0ef          	jal	ra,588 <putc>
 84e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 850:	03c9d793          	srli	a5,s3,0x3c
 854:	97e6                	add	a5,a5,s9
 856:	0007c583          	lbu	a1,0(a5)
 85a:	855a                	mv	a0,s6
 85c:	d2dff0ef          	jal	ra,588 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 860:	0992                	slli	s3,s3,0x4
 862:	397d                	addiw	s2,s2,-1
 864:	fe0916e3          	bnez	s2,850 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 868:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bd25                	j	6a6 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 870:	008b8993          	addi	s3,s7,8
 874:	000bb903          	ld	s2,0(s7)
 878:	00090f63          	beqz	s2,896 <vprintf+0x24a>
        for(; *s; s++)
 87c:	00094583          	lbu	a1,0(s2)
 880:	c195                	beqz	a1,8a4 <vprintf+0x258>
          putc(fd, *s);
 882:	855a                	mv	a0,s6
 884:	d05ff0ef          	jal	ra,588 <putc>
        for(; *s; s++)
 888:	0905                	addi	s2,s2,1
 88a:	00094583          	lbu	a1,0(s2)
 88e:	f9f5                	bnez	a1,882 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 890:	8bce                	mv	s7,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	bd09                	j	6a6 <vprintf+0x5a>
          s = "(null)";
 896:	00000917          	auipc	s2,0x0
 89a:	25a90913          	addi	s2,s2,602 # af0 <malloc+0x144>
        for(; *s; s++)
 89e:	02800593          	li	a1,40
 8a2:	b7c5                	j	882 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 8a4:	8bce                	mv	s7,s3
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bbfd                	j	6a6 <vprintf+0x5a>
    }
  }
}
 8aa:	70e6                	ld	ra,120(sp)
 8ac:	7446                	ld	s0,112(sp)
 8ae:	74a6                	ld	s1,104(sp)
 8b0:	7906                	ld	s2,96(sp)
 8b2:	69e6                	ld	s3,88(sp)
 8b4:	6a46                	ld	s4,80(sp)
 8b6:	6aa6                	ld	s5,72(sp)
 8b8:	6b06                	ld	s6,64(sp)
 8ba:	7be2                	ld	s7,56(sp)
 8bc:	7c42                	ld	s8,48(sp)
 8be:	7ca2                	ld	s9,40(sp)
 8c0:	7d02                	ld	s10,32(sp)
 8c2:	6de2                	ld	s11,24(sp)
 8c4:	6109                	addi	sp,sp,128
 8c6:	8082                	ret

00000000000008c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c8:	715d                	addi	sp,sp,-80
 8ca:	ec06                	sd	ra,24(sp)
 8cc:	e822                	sd	s0,16(sp)
 8ce:	1000                	addi	s0,sp,32
 8d0:	e010                	sd	a2,0(s0)
 8d2:	e414                	sd	a3,8(s0)
 8d4:	e818                	sd	a4,16(s0)
 8d6:	ec1c                	sd	a5,24(s0)
 8d8:	03043023          	sd	a6,32(s0)
 8dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e4:	8622                	mv	a2,s0
 8e6:	d67ff0ef          	jal	ra,64c <vprintf>
}
 8ea:	60e2                	ld	ra,24(sp)
 8ec:	6442                	ld	s0,16(sp)
 8ee:	6161                	addi	sp,sp,80
 8f0:	8082                	ret

00000000000008f2 <printf>:

void
printf(const char *fmt, ...)
{
 8f2:	711d                	addi	sp,sp,-96
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	1000                	addi	s0,sp,32
 8fa:	e40c                	sd	a1,8(s0)
 8fc:	e810                	sd	a2,16(s0)
 8fe:	ec14                	sd	a3,24(s0)
 900:	f018                	sd	a4,32(s0)
 902:	f41c                	sd	a5,40(s0)
 904:	03043823          	sd	a6,48(s0)
 908:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	00840613          	addi	a2,s0,8
 910:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 914:	85aa                	mv	a1,a0
 916:	4505                	li	a0,1
 918:	d35ff0ef          	jal	ra,64c <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6125                	addi	sp,sp,96
 922:	8082                	ret

0000000000000924 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 924:	1141                	addi	sp,sp,-16
 926:	e422                	sd	s0,8(sp)
 928:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92e:	00000797          	auipc	a5,0x0
 932:	6d27b783          	ld	a5,1746(a5) # 1000 <freep>
 936:	a805                	j	966 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 938:	4618                	lw	a4,8(a2)
 93a:	9db9                	addw	a1,a1,a4
 93c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 940:	6398                	ld	a4,0(a5)
 942:	6318                	ld	a4,0(a4)
 944:	fee53823          	sd	a4,-16(a0)
 948:	a091                	j	98c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94a:	ff852703          	lw	a4,-8(a0)
 94e:	9e39                	addw	a2,a2,a4
 950:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 952:	ff053703          	ld	a4,-16(a0)
 956:	e398                	sd	a4,0(a5)
 958:	a099                	j	99e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x40>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x50>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bgeu	a5,a3,95a <free+0x36>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059713          	slli	a4,a1,0x20
 97e:	9301                	srli	a4,a4,0x20
 980:	0712                	slli	a4,a4,0x4
 982:	9736                	add	a4,a4,a3
 984:	fae60ae3          	beq	a2,a4,938 <free+0x14>
    bp->s.ptr = p->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061713          	slli	a4,a2,0x20
 992:	9301                	srli	a4,a4,0x20
 994:	0712                	slli	a4,a4,0x4
 996:	973e                	add	a4,a4,a5
 998:	fae689e3          	beq	a3,a4,94a <free+0x26>
  } else
    p->s.ptr = bp;
 99c:	e394                	sd	a3,0(a5)
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
}
 9a6:	6422                	ld	s0,8(sp)
 9a8:	0141                	addi	sp,sp,16
 9aa:	8082                	ret

00000000000009ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ac:	7139                	addi	sp,sp,-64
 9ae:	fc06                	sd	ra,56(sp)
 9b0:	f822                	sd	s0,48(sp)
 9b2:	f426                	sd	s1,40(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
 9be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c0:	02051493          	slli	s1,a0,0x20
 9c4:	9081                	srli	s1,s1,0x20
 9c6:	04bd                	addi	s1,s1,15
 9c8:	8091                	srli	s1,s1,0x4
 9ca:	0014899b          	addiw	s3,s1,1
 9ce:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9d0:	00000517          	auipc	a0,0x0
 9d4:	63053503          	ld	a0,1584(a0) # 1000 <freep>
 9d8:	c515                	beqz	a0,a04 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9dc:	4798                	lw	a4,8(a5)
 9de:	02977f63          	bgeu	a4,s1,a1c <malloc+0x70>
 9e2:	8a4e                	mv	s4,s3
 9e4:	0009871b          	sext.w	a4,s3
 9e8:	6685                	lui	a3,0x1
 9ea:	00d77363          	bgeu	a4,a3,9f0 <malloc+0x44>
 9ee:	6a05                	lui	s4,0x1
 9f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f8:	00000917          	auipc	s2,0x0
 9fc:	60890913          	addi	s2,s2,1544 # 1000 <freep>
  if(p == (char*)-1)
 a00:	5afd                	li	s5,-1
 a02:	a0bd                	j	a70 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a04:	00000797          	auipc	a5,0x0
 a08:	61c78793          	addi	a5,a5,1564 # 1020 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	5ef73a23          	sd	a5,1524(a4) # 1000 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7e1                	j	9e2 <malloc+0x36>
      if(p->s.size == nunits)
 a1c:	02e48b63          	beq	s1,a4,a52 <malloc+0xa6>
        p->s.size -= nunits;
 a20:	4137073b          	subw	a4,a4,s3
 a24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a26:	1702                	slli	a4,a4,0x20
 a28:	9301                	srli	a4,a4,0x20
 a2a:	0712                	slli	a4,a4,0x4
 a2c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a2e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a32:	00000717          	auipc	a4,0x0
 a36:	5ca73723          	sd	a0,1486(a4) # 1000 <freep>
      return (void*)(p + 1);
 a3a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a3e:	70e2                	ld	ra,56(sp)
 a40:	7442                	ld	s0,48(sp)
 a42:	74a2                	ld	s1,40(sp)
 a44:	7902                	ld	s2,32(sp)
 a46:	69e2                	ld	s3,24(sp)
 a48:	6a42                	ld	s4,16(sp)
 a4a:	6aa2                	ld	s5,8(sp)
 a4c:	6b02                	ld	s6,0(sp)
 a4e:	6121                	addi	sp,sp,64
 a50:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a52:	6398                	ld	a4,0(a5)
 a54:	e118                	sd	a4,0(a0)
 a56:	bff1                	j	a32 <malloc+0x86>
  hp->s.size = nu;
 a58:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5c:	0541                	addi	a0,a0,16
 a5e:	ec7ff0ef          	jal	ra,924 <free>
  return freep;
 a62:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a66:	dd61                	beqz	a0,a3e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6a:	4798                	lw	a4,8(a5)
 a6c:	fa9778e3          	bgeu	a4,s1,a1c <malloc+0x70>
    if(p == freep)
 a70:	00093703          	ld	a4,0(s2)
 a74:	853e                	mv	a0,a5
 a76:	fef719e3          	bne	a4,a5,a68 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a7a:	8552                	mv	a0,s4
 a7c:	addff0ef          	jal	ra,558 <sbrk>
  if(p == (char*)-1)
 a80:	fd551ce3          	bne	a0,s5,a58 <malloc+0xac>
        return 0;
 a84:	4501                	li	a0,0
 a86:	bf65                	j	a3e <malloc+0x92>
