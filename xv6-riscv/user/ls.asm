
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
  10:	31a000ef          	jal	ra,32a <strlen>
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
  38:	2f2000ef          	jal	ra,32a <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[DIRSIZ] = 0;
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
  56:	2d4000ef          	jal	ra,32a <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	424000ef          	jal	ra,48e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	2ba000ef          	jal	ra,32a <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	2b0000ef          	jal	ra,32a <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	2c4000ef          	jal	ra,354 <memset>
  buf[DIRSIZ] = 0;
  94:	00098723          	sb	zero,14(s3)
  return buf;
  98:	84ce                	mv	s1,s3
  9a:	b76d                	j	44 <fmtname+0x44>

000000000000009c <ls>:

void
ls(char *path, int long_listing)
{
  9c:	d8010113          	addi	sp,sp,-640
  a0:	26113c23          	sd	ra,632(sp)
  a4:	26813823          	sd	s0,624(sp)
  a8:	26913423          	sd	s1,616(sp)
  ac:	27213023          	sd	s2,608(sp)
  b0:	25313c23          	sd	s3,600(sp)
  b4:	25413823          	sd	s4,592(sp)
  b8:	25513423          	sd	s5,584(sp)
  bc:	25613023          	sd	s6,576(sp)
  c0:	23713c23          	sd	s7,568(sp)
  c4:	0500                	addi	s0,sp,640
  c6:	892a                	mv	s2,a0
  c8:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ca:	4581                	li	a1,0
  cc:	4b0000ef          	jal	ra,57c <open>
  d0:	06054d63          	bltz	a0,14a <ls+0xae>
  d4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  d6:	d8040593          	addi	a1,s0,-640
  da:	4ba000ef          	jal	ra,594 <fstat>
  de:	06054f63          	bltz	a0,15c <ls+0xc0>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  e2:	d8841783          	lh	a5,-632(s0)
  e6:	0007869b          	sext.w	a3,a5
  ea:	4705                	li	a4,1
  ec:	08e68f63          	beq	a3,a4,18a <ls+0xee>
  f0:	4709                	li	a4,2
  f2:	02e69463          	bne	a3,a4,11a <ls+0x7e>
  case T_FILE:
    if(long_listing)
  f6:	06098f63          	beqz	s3,174 <ls+0xd8>
      printf("%s %d %d %ld\n", fmtname(path), st.type, st.ino, st.size);
  fa:	854a                	mv	a0,s2
  fc:	f05ff0ef          	jal	ra,0 <fmtname>
 100:	85aa                	mv	a1,a0
 102:	d9043703          	ld	a4,-624(s0)
 106:	d8442683          	lw	a3,-636(s0)
 10a:	d8841603          	lh	a2,-632(s0)
 10e:	00001517          	auipc	a0,0x1
 112:	a2250513          	addi	a0,a0,-1502 # b30 <malloc+0x110>
 116:	051000ef          	jal	ra,966 <printf>
      else
        printf("%s\n", fmtname(buf));
    }
    break;
  }
  close(fd);
 11a:	8526                	mv	a0,s1
 11c:	448000ef          	jal	ra,564 <close>
}
 120:	27813083          	ld	ra,632(sp)
 124:	27013403          	ld	s0,624(sp)
 128:	26813483          	ld	s1,616(sp)
 12c:	26013903          	ld	s2,608(sp)
 130:	25813983          	ld	s3,600(sp)
 134:	25013a03          	ld	s4,592(sp)
 138:	24813a83          	ld	s5,584(sp)
 13c:	24013b03          	ld	s6,576(sp)
 140:	23813b83          	ld	s7,568(sp)
 144:	28010113          	addi	sp,sp,640
 148:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 14a:	864a                	mv	a2,s2
 14c:	00001597          	auipc	a1,0x1
 150:	9b458593          	addi	a1,a1,-1612 # b00 <malloc+0xe0>
 154:	4509                	li	a0,2
 156:	7e6000ef          	jal	ra,93c <fprintf>
    return;
 15a:	b7d9                	j	120 <ls+0x84>
    fprintf(2, "ls: cannot stat %s\n", path);
 15c:	864a                	mv	a2,s2
 15e:	00001597          	auipc	a1,0x1
 162:	9ba58593          	addi	a1,a1,-1606 # b18 <malloc+0xf8>
 166:	4509                	li	a0,2
 168:	7d4000ef          	jal	ra,93c <fprintf>
    close(fd);
 16c:	8526                	mv	a0,s1
 16e:	3f6000ef          	jal	ra,564 <close>
    return;
 172:	b77d                	j	120 <ls+0x84>
      printf("%s\n", fmtname(path));
 174:	854a                	mv	a0,s2
 176:	e8bff0ef          	jal	ra,0 <fmtname>
 17a:	85aa                	mv	a1,a0
 17c:	00001517          	auipc	a0,0x1
 180:	99450513          	addi	a0,a0,-1644 # b10 <malloc+0xf0>
 184:	7e2000ef          	jal	ra,966 <printf>
 188:	bf49                	j	11a <ls+0x7e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18a:	854a                	mv	a0,s2
 18c:	19e000ef          	jal	ra,32a <strlen>
 190:	2541                	addiw	a0,a0,16
 192:	20000793          	li	a5,512
 196:	00a7f963          	bgeu	a5,a0,1a8 <ls+0x10c>
      printf("ls: path too long\n");
 19a:	00001517          	auipc	a0,0x1
 19e:	9a650513          	addi	a0,a0,-1626 # b40 <malloc+0x120>
 1a2:	7c4000ef          	jal	ra,966 <printf>
      break;
 1a6:	bf95                	j	11a <ls+0x7e>
    strcpy(buf, path);
 1a8:	85ca                	mv	a1,s2
 1aa:	db040513          	addi	a0,s0,-592
 1ae:	134000ef          	jal	ra,2e2 <strcpy>
    p = buf+strlen(buf);
 1b2:	db040513          	addi	a0,s0,-592
 1b6:	174000ef          	jal	ra,32a <strlen>
 1ba:	02051913          	slli	s2,a0,0x20
 1be:	02095913          	srli	s2,s2,0x20
 1c2:	db040793          	addi	a5,s0,-592
 1c6:	993e                	add	s2,s2,a5
    *p++ = '/';
 1c8:	00190a13          	addi	s4,s2,1
 1cc:	02f00793          	li	a5,47
 1d0:	00f90023          	sb	a5,0(s2)
        printf("%s\n", fmtname(buf));
 1d4:	00001b17          	auipc	s6,0x1
 1d8:	93cb0b13          	addi	s6,s6,-1732 # b10 <malloc+0xf0>
        printf("%s %d %d %ld\n", fmtname(buf), st.type, st.ino, st.size);
 1dc:	00001a97          	auipc	s5,0x1
 1e0:	954a8a93          	addi	s5,s5,-1708 # b30 <malloc+0x110>
        printf("ls: cannot stat %s\n", buf);
 1e4:	00001b97          	auipc	s7,0x1
 1e8:	934b8b93          	addi	s7,s7,-1740 # b18 <malloc+0xf8>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ec:	a839                	j	20a <ls+0x16e>
        printf("ls: cannot stat %s\n", buf);
 1ee:	db040593          	addi	a1,s0,-592
 1f2:	855e                	mv	a0,s7
 1f4:	772000ef          	jal	ra,966 <printf>
        continue;
 1f8:	a809                	j	20a <ls+0x16e>
        printf("%s\n", fmtname(buf));
 1fa:	db040513          	addi	a0,s0,-592
 1fe:	e03ff0ef          	jal	ra,0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	855a                	mv	a0,s6
 206:	760000ef          	jal	ra,966 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20a:	4641                	li	a2,16
 20c:	da040593          	addi	a1,s0,-608
 210:	8526                	mv	a0,s1
 212:	342000ef          	jal	ra,554 <read>
 216:	47c1                	li	a5,16
 218:	f0f511e3          	bne	a0,a5,11a <ls+0x7e>
      if(de.inum == 0)
 21c:	da045783          	lhu	a5,-608(s0)
 220:	d7ed                	beqz	a5,20a <ls+0x16e>
      memmove(p, de.name, DIRSIZ);
 222:	4639                	li	a2,14
 224:	da240593          	addi	a1,s0,-606
 228:	8552                	mv	a0,s4
 22a:	264000ef          	jal	ra,48e <memmove>
      p[DIRSIZ] = 0;
 22e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 232:	d8040593          	addi	a1,s0,-640
 236:	db040513          	addi	a0,s0,-592
 23a:	1d0000ef          	jal	ra,40a <stat>
 23e:	fa0548e3          	bltz	a0,1ee <ls+0x152>
      if(long_listing)
 242:	fa098ce3          	beqz	s3,1fa <ls+0x15e>
        printf("%s %d %d %ld\n", fmtname(buf), st.type, st.ino, st.size);
 246:	db040513          	addi	a0,s0,-592
 24a:	db7ff0ef          	jal	ra,0 <fmtname>
 24e:	85aa                	mv	a1,a0
 250:	d9043703          	ld	a4,-624(s0)
 254:	d8442683          	lw	a3,-636(s0)
 258:	d8841603          	lh	a2,-632(s0)
 25c:	8556                	mv	a0,s5
 25e:	708000ef          	jal	ra,966 <printf>
 262:	b765                	j	20a <ls+0x16e>

0000000000000264 <main>:

int
main(int argc, char *argv[])
{
 264:	7179                	addi	sp,sp,-48
 266:	f406                	sd	ra,40(sp)
 268:	f022                	sd	s0,32(sp)
 26a:	ec26                	sd	s1,24(sp)
 26c:	e84a                	sd	s2,16(sp)
 26e:	e44e                	sd	s3,8(sp)
 270:	e052                	sd	s4,0(sp)
 272:	1800                	addi	s0,sp,48
  int i;
  int long_listing = 0;

  if(argc > 1 && strcmp(argv[1], "-l") == 0){
 274:	4785                	li	a5,1
 276:	04a7d163          	bge	a5,a0,2b8 <main+0x54>
 27a:	89aa                	mv	s3,a0
 27c:	84ae                	mv	s1,a1
 27e:	00001597          	auipc	a1,0x1
 282:	8da58593          	addi	a1,a1,-1830 # b58 <malloc+0x138>
 286:	6488                	ld	a0,8(s1)
 288:	076000ef          	jal	ra,2fe <strcmp>
 28c:	e505                	bnez	a0,2b4 <main+0x50>
    long_listing = 1;
    argc--;
 28e:	39fd                	addiw	s3,s3,-1
    argv++;
 290:	04a1                	addi	s1,s1,8
  }

  if(argc < 2){
 292:	4785                	li	a5,1
 294:	0337dc63          	bge	a5,s3,2cc <main+0x68>
    long_listing = 1;
 298:	4a05                	li	s4,1
    ls(".", long_listing);
    exit(0);
  }
  for(i=1; i<argc; i++)
 29a:	04a1                	addi	s1,s1,8
 29c:	4905                	li	s2,1
    ls(argv[i], long_listing);
 29e:	85d2                	mv	a1,s4
 2a0:	6088                	ld	a0,0(s1)
 2a2:	dfbff0ef          	jal	ra,9c <ls>
  for(i=1; i<argc; i++)
 2a6:	2905                	addiw	s2,s2,1
 2a8:	04a1                	addi	s1,s1,8
 2aa:	ff394ae3          	blt	s2,s3,29e <main+0x3a>
  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	28c000ef          	jal	ra,53c <exit>
  int long_listing = 0;
 2b4:	4a01                	li	s4,0
 2b6:	b7d5                	j	29a <main+0x36>
 2b8:	4581                	li	a1,0
    ls(".", long_listing);
 2ba:	00001517          	auipc	a0,0x1
 2be:	8a650513          	addi	a0,a0,-1882 # b60 <malloc+0x140>
 2c2:	ddbff0ef          	jal	ra,9c <ls>
    exit(0);
 2c6:	4501                	li	a0,0
 2c8:	274000ef          	jal	ra,53c <exit>
    long_listing = 1;
 2cc:	4585                	li	a1,1
 2ce:	b7f5                	j	2ba <main+0x56>

00000000000002d0 <start>:
//


void
start()
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2d8:	f8dff0ef          	jal	ra,264 <main>
  exit(0);
 2dc:	4501                	li	a0,0
 2de:	25e000ef          	jal	ra,53c <exit>

00000000000002e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e8:	87aa                	mv	a5,a0
 2ea:	0585                	addi	a1,a1,1
 2ec:	0785                	addi	a5,a5,1
 2ee:	fff5c703          	lbu	a4,-1(a1)
 2f2:	fee78fa3          	sb	a4,-1(a5)
 2f6:	fb75                	bnez	a4,2ea <strcpy+0x8>
    ;
  return os;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 304:	00054783          	lbu	a5,0(a0)
 308:	cb91                	beqz	a5,31c <strcmp+0x1e>
 30a:	0005c703          	lbu	a4,0(a1)
 30e:	00f71763          	bne	a4,a5,31c <strcmp+0x1e>
    p++, q++;
 312:	0505                	addi	a0,a0,1
 314:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 316:	00054783          	lbu	a5,0(a0)
 31a:	fbe5                	bnez	a5,30a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 31c:	0005c503          	lbu	a0,0(a1)
}
 320:	40a7853b          	subw	a0,a5,a0
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <strlen>:

uint
strlen(const char *s)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 330:	00054783          	lbu	a5,0(a0)
 334:	cf91                	beqz	a5,350 <strlen+0x26>
 336:	0505                	addi	a0,a0,1
 338:	87aa                	mv	a5,a0
 33a:	4685                	li	a3,1
 33c:	9e89                	subw	a3,a3,a0
 33e:	00f6853b          	addw	a0,a3,a5
 342:	0785                	addi	a5,a5,1
 344:	fff7c703          	lbu	a4,-1(a5)
 348:	fb7d                	bnez	a4,33e <strlen+0x14>
    ;
  return n;
}
 34a:	6422                	ld	s0,8(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  for(n = 0; s[n]; n++)
 350:	4501                	li	a0,0
 352:	bfe5                	j	34a <strlen+0x20>

0000000000000354 <memset>:

void*
memset(void *dst, int c, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 35a:	ca19                	beqz	a2,370 <memset+0x1c>
 35c:	87aa                	mv	a5,a0
 35e:	1602                	slli	a2,a2,0x20
 360:	9201                	srli	a2,a2,0x20
 362:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 366:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 36a:	0785                	addi	a5,a5,1
 36c:	fee79de3          	bne	a5,a4,366 <memset+0x12>
  }
  return dst;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <strchr>:

char*
strchr(const char *s, char c)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 37c:	00054783          	lbu	a5,0(a0)
 380:	cb99                	beqz	a5,396 <strchr+0x20>
    if(*s == c)
 382:	00f58763          	beq	a1,a5,390 <strchr+0x1a>
  for(; *s; s++)
 386:	0505                	addi	a0,a0,1
 388:	00054783          	lbu	a5,0(a0)
 38c:	fbfd                	bnez	a5,382 <strchr+0xc>
      return (char*)s;
  return 0;
 38e:	4501                	li	a0,0
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
  return 0;
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <strchr+0x1a>

000000000000039a <gets>:

char*
gets(char *buf, int max)
{
 39a:	711d                	addi	sp,sp,-96
 39c:	ec86                	sd	ra,88(sp)
 39e:	e8a2                	sd	s0,80(sp)
 3a0:	e4a6                	sd	s1,72(sp)
 3a2:	e0ca                	sd	s2,64(sp)
 3a4:	fc4e                	sd	s3,56(sp)
 3a6:	f852                	sd	s4,48(sp)
 3a8:	f456                	sd	s5,40(sp)
 3aa:	f05a                	sd	s6,32(sp)
 3ac:	ec5e                	sd	s7,24(sp)
 3ae:	1080                	addi	s0,sp,96
 3b0:	8baa                	mv	s7,a0
 3b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b4:	892a                	mv	s2,a0
 3b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b8:	4aa9                	li	s5,10
 3ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3bc:	89a6                	mv	s3,s1
 3be:	2485                	addiw	s1,s1,1
 3c0:	0344d663          	bge	s1,s4,3ec <gets+0x52>
    cc = read(0, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	faf40593          	addi	a1,s0,-81
 3ca:	4501                	li	a0,0
 3cc:	188000ef          	jal	ra,554 <read>
    if(cc < 1)
 3d0:	00a05e63          	blez	a0,3ec <gets+0x52>
    buf[i++] = c;
 3d4:	faf44783          	lbu	a5,-81(s0)
 3d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3dc:	01578763          	beq	a5,s5,3ea <gets+0x50>
 3e0:	0905                	addi	s2,s2,1
 3e2:	fd679de3          	bne	a5,s6,3bc <gets+0x22>
  for(i=0; i+1 < max; ){
 3e6:	89a6                	mv	s3,s1
 3e8:	a011                	j	3ec <gets+0x52>
 3ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ec:	99de                	add	s3,s3,s7
 3ee:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f2:	855e                	mv	a0,s7
 3f4:	60e6                	ld	ra,88(sp)
 3f6:	6446                	ld	s0,80(sp)
 3f8:	64a6                	ld	s1,72(sp)
 3fa:	6906                	ld	s2,64(sp)
 3fc:	79e2                	ld	s3,56(sp)
 3fe:	7a42                	ld	s4,48(sp)
 400:	7aa2                	ld	s5,40(sp)
 402:	7b02                	ld	s6,32(sp)
 404:	6be2                	ld	s7,24(sp)
 406:	6125                	addi	sp,sp,96
 408:	8082                	ret

000000000000040a <stat>:

int
stat(const char *n, struct stat *st)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	e426                	sd	s1,8(sp)
 412:	e04a                	sd	s2,0(sp)
 414:	1000                	addi	s0,sp,32
 416:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 418:	4581                	li	a1,0
 41a:	162000ef          	jal	ra,57c <open>
  if(fd < 0)
 41e:	02054163          	bltz	a0,440 <stat+0x36>
 422:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 424:	85ca                	mv	a1,s2
 426:	16e000ef          	jal	ra,594 <fstat>
 42a:	892a                	mv	s2,a0
  close(fd);
 42c:	8526                	mv	a0,s1
 42e:	136000ef          	jal	ra,564 <close>
  return r;
}
 432:	854a                	mv	a0,s2
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	64a2                	ld	s1,8(sp)
 43a:	6902                	ld	s2,0(sp)
 43c:	6105                	addi	sp,sp,32
 43e:	8082                	ret
    return -1;
 440:	597d                	li	s2,-1
 442:	bfc5                	j	432 <stat+0x28>

0000000000000444 <atoi>:

int
atoi(const char *s)
{
 444:	1141                	addi	sp,sp,-16
 446:	e422                	sd	s0,8(sp)
 448:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44a:	00054603          	lbu	a2,0(a0)
 44e:	fd06079b          	addiw	a5,a2,-48
 452:	0ff7f793          	andi	a5,a5,255
 456:	4725                	li	a4,9
 458:	02f76963          	bltu	a4,a5,48a <atoi+0x46>
 45c:	86aa                	mv	a3,a0
  n = 0;
 45e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 460:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 462:	0685                	addi	a3,a3,1
 464:	0025179b          	slliw	a5,a0,0x2
 468:	9fa9                	addw	a5,a5,a0
 46a:	0017979b          	slliw	a5,a5,0x1
 46e:	9fb1                	addw	a5,a5,a2
 470:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 474:	0006c603          	lbu	a2,0(a3)
 478:	fd06071b          	addiw	a4,a2,-48
 47c:	0ff77713          	andi	a4,a4,255
 480:	fee5f1e3          	bgeu	a1,a4,462 <atoi+0x1e>
  return n;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
  n = 0;
 48a:	4501                	li	a0,0
 48c:	bfe5                	j	484 <atoi+0x40>

000000000000048e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 494:	02b57463          	bgeu	a0,a1,4bc <memmove+0x2e>
    while(n-- > 0)
 498:	00c05f63          	blez	a2,4b6 <memmove+0x28>
 49c:	1602                	slli	a2,a2,0x20
 49e:	9201                	srli	a2,a2,0x20
 4a0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a6:	0585                	addi	a1,a1,1
 4a8:	0705                	addi	a4,a4,1
 4aa:	fff5c683          	lbu	a3,-1(a1)
 4ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b2:	fee79ae3          	bne	a5,a4,4a6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
    dst += n;
 4bc:	00c50733          	add	a4,a0,a2
    src += n;
 4c0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c2:	fec05ae3          	blez	a2,4b6 <memmove+0x28>
 4c6:	fff6079b          	addiw	a5,a2,-1
 4ca:	1782                	slli	a5,a5,0x20
 4cc:	9381                	srli	a5,a5,0x20
 4ce:	fff7c793          	not	a5,a5
 4d2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d4:	15fd                	addi	a1,a1,-1
 4d6:	177d                	addi	a4,a4,-1
 4d8:	0005c683          	lbu	a3,0(a1)
 4dc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e0:	fee79ae3          	bne	a5,a4,4d4 <memmove+0x46>
 4e4:	bfc9                	j	4b6 <memmove+0x28>

00000000000004e6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ec:	ca05                	beqz	a2,51c <memcmp+0x36>
 4ee:	fff6069b          	addiw	a3,a2,-1
 4f2:	1682                	slli	a3,a3,0x20
 4f4:	9281                	srli	a3,a3,0x20
 4f6:	0685                	addi	a3,a3,1
 4f8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4fa:	00054783          	lbu	a5,0(a0)
 4fe:	0005c703          	lbu	a4,0(a1)
 502:	00e79863          	bne	a5,a4,512 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 506:	0505                	addi	a0,a0,1
    p2++;
 508:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50a:	fed518e3          	bne	a0,a3,4fa <memcmp+0x14>
  }
  return 0;
 50e:	4501                	li	a0,0
 510:	a019                	j	516 <memcmp+0x30>
      return *p1 - *p2;
 512:	40e7853b          	subw	a0,a5,a4
}
 516:	6422                	ld	s0,8(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret
  return 0;
 51c:	4501                	li	a0,0
 51e:	bfe5                	j	516 <memcmp+0x30>

0000000000000520 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 520:	1141                	addi	sp,sp,-16
 522:	e406                	sd	ra,8(sp)
 524:	e022                	sd	s0,0(sp)
 526:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 528:	f67ff0ef          	jal	ra,48e <memmove>
}
 52c:	60a2                	ld	ra,8(sp)
 52e:	6402                	ld	s0,0(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret

0000000000000534 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 534:	4885                	li	a7,1
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <exit>:
.global exit
exit:
 li a7, SYS_exit
 53c:	4889                	li	a7,2
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <wait>:
.global wait
wait:
 li a7, SYS_wait
 544:	488d                	li	a7,3
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54c:	4891                	li	a7,4
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <read>:
.global read
read:
 li a7, SYS_read
 554:	4895                	li	a7,5
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <write>:
.global write
write:
 li a7, SYS_write
 55c:	48c1                	li	a7,16
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <close>:
.global close
close:
 li a7, SYS_close
 564:	48d5                	li	a7,21
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <kill>:
.global kill
kill:
 li a7, SYS_kill
 56c:	4899                	li	a7,6
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <exec>:
.global exec
exec:
 li a7, SYS_exec
 574:	489d                	li	a7,7
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <open>:
.global open
open:
 li a7, SYS_open
 57c:	48bd                	li	a7,15
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 584:	48c5                	li	a7,17
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58c:	48c9                	li	a7,18
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 594:	48a1                	li	a7,8
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <link>:
.global link
link:
 li a7, SYS_link
 59c:	48cd                	li	a7,19
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a4:	48d1                	li	a7,20
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ac:	48a5                	li	a7,9
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b4:	48a9                	li	a7,10
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5bc:	48ad                	li	a7,11
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c4:	48b1                	li	a7,12
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5cc:	48b5                	li	a7,13
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d4:	48b9                	li	a7,14
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 5dc:	48d9                	li	a7,22
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 5e4:	48dd                	li	a7,23
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 5ec:	48e1                	li	a7,24
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 5f4:	48e5                	li	a7,25
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5fc:	1101                	addi	sp,sp,-32
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	addi	s0,sp,32
 604:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 608:	4605                	li	a2,1
 60a:	fef40593          	addi	a1,s0,-17
 60e:	f4fff0ef          	jal	ra,55c <write>
}
 612:	60e2                	ld	ra,24(sp)
 614:	6442                	ld	s0,16(sp)
 616:	6105                	addi	sp,sp,32
 618:	8082                	ret

000000000000061a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61a:	7139                	addi	sp,sp,-64
 61c:	fc06                	sd	ra,56(sp)
 61e:	f822                	sd	s0,48(sp)
 620:	f426                	sd	s1,40(sp)
 622:	f04a                	sd	s2,32(sp)
 624:	ec4e                	sd	s3,24(sp)
 626:	0080                	addi	s0,sp,64
 628:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 62a:	c299                	beqz	a3,630 <printint+0x16>
 62c:	0805c663          	bltz	a1,6b8 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 630:	2581                	sext.w	a1,a1
  neg = 0;
 632:	4881                	li	a7,0
 634:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 638:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 63a:	2601                	sext.w	a2,a2
 63c:	00000517          	auipc	a0,0x0
 640:	53450513          	addi	a0,a0,1332 # b70 <digits>
 644:	883a                	mv	a6,a4
 646:	2705                	addiw	a4,a4,1
 648:	02c5f7bb          	remuw	a5,a1,a2
 64c:	1782                	slli	a5,a5,0x20
 64e:	9381                	srli	a5,a5,0x20
 650:	97aa                	add	a5,a5,a0
 652:	0007c783          	lbu	a5,0(a5)
 656:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 65a:	0005879b          	sext.w	a5,a1
 65e:	02c5d5bb          	divuw	a1,a1,a2
 662:	0685                	addi	a3,a3,1
 664:	fec7f0e3          	bgeu	a5,a2,644 <printint+0x2a>
  if(neg)
 668:	00088b63          	beqz	a7,67e <printint+0x64>
    buf[i++] = '-';
 66c:	fd040793          	addi	a5,s0,-48
 670:	973e                	add	a4,a4,a5
 672:	02d00793          	li	a5,45
 676:	fef70823          	sb	a5,-16(a4)
 67a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 67e:	02e05663          	blez	a4,6aa <printint+0x90>
 682:	fc040793          	addi	a5,s0,-64
 686:	00e78933          	add	s2,a5,a4
 68a:	fff78993          	addi	s3,a5,-1
 68e:	99ba                	add	s3,s3,a4
 690:	377d                	addiw	a4,a4,-1
 692:	1702                	slli	a4,a4,0x20
 694:	9301                	srli	a4,a4,0x20
 696:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 69a:	fff94583          	lbu	a1,-1(s2)
 69e:	8526                	mv	a0,s1
 6a0:	f5dff0ef          	jal	ra,5fc <putc>
  while(--i >= 0)
 6a4:	197d                	addi	s2,s2,-1
 6a6:	ff391ae3          	bne	s2,s3,69a <printint+0x80>
}
 6aa:	70e2                	ld	ra,56(sp)
 6ac:	7442                	ld	s0,48(sp)
 6ae:	74a2                	ld	s1,40(sp)
 6b0:	7902                	ld	s2,32(sp)
 6b2:	69e2                	ld	s3,24(sp)
 6b4:	6121                	addi	sp,sp,64
 6b6:	8082                	ret
    x = -xx;
 6b8:	40b005bb          	negw	a1,a1
    neg = 1;
 6bc:	4885                	li	a7,1
    x = -xx;
 6be:	bf9d                	j	634 <printint+0x1a>

00000000000006c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c0:	7119                	addi	sp,sp,-128
 6c2:	fc86                	sd	ra,120(sp)
 6c4:	f8a2                	sd	s0,112(sp)
 6c6:	f4a6                	sd	s1,104(sp)
 6c8:	f0ca                	sd	s2,96(sp)
 6ca:	ecce                	sd	s3,88(sp)
 6cc:	e8d2                	sd	s4,80(sp)
 6ce:	e4d6                	sd	s5,72(sp)
 6d0:	e0da                	sd	s6,64(sp)
 6d2:	fc5e                	sd	s7,56(sp)
 6d4:	f862                	sd	s8,48(sp)
 6d6:	f466                	sd	s9,40(sp)
 6d8:	f06a                	sd	s10,32(sp)
 6da:	ec6e                	sd	s11,24(sp)
 6dc:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6de:	0005c903          	lbu	s2,0(a1)
 6e2:	22090e63          	beqz	s2,91e <vprintf+0x25e>
 6e6:	8b2a                	mv	s6,a0
 6e8:	8a2e                	mv	s4,a1
 6ea:	8bb2                	mv	s7,a2
  state = 0;
 6ec:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ee:	4481                	li	s1,0
 6f0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6f2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6f6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6fa:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6fe:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 702:	00000c97          	auipc	s9,0x0
 706:	46ec8c93          	addi	s9,s9,1134 # b70 <digits>
 70a:	a005                	j	72a <vprintf+0x6a>
        putc(fd, c0);
 70c:	85ca                	mv	a1,s2
 70e:	855a                	mv	a0,s6
 710:	eedff0ef          	jal	ra,5fc <putc>
 714:	a019                	j	71a <vprintf+0x5a>
    } else if(state == '%'){
 716:	03598263          	beq	s3,s5,73a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 71a:	2485                	addiw	s1,s1,1
 71c:	8726                	mv	a4,s1
 71e:	009a07b3          	add	a5,s4,s1
 722:	0007c903          	lbu	s2,0(a5)
 726:	1e090c63          	beqz	s2,91e <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 72a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 72e:	fe0994e3          	bnez	s3,716 <vprintf+0x56>
      if(c0 == '%'){
 732:	fd579de3          	bne	a5,s5,70c <vprintf+0x4c>
        state = '%';
 736:	89be                	mv	s3,a5
 738:	b7cd                	j	71a <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 73a:	cfa5                	beqz	a5,7b2 <vprintf+0xf2>
 73c:	00ea06b3          	add	a3,s4,a4
 740:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 744:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 746:	c681                	beqz	a3,74e <vprintf+0x8e>
 748:	9752                	add	a4,a4,s4
 74a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 74e:	03878a63          	beq	a5,s8,782 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 752:	05a78463          	beq	a5,s10,79a <vprintf+0xda>
      } else if(c0 == 'u'){
 756:	0db78763          	beq	a5,s11,824 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 75a:	07800713          	li	a4,120
 75e:	10e78963          	beq	a5,a4,870 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 762:	07000713          	li	a4,112
 766:	12e78e63          	beq	a5,a4,8a2 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 76a:	07300713          	li	a4,115
 76e:	16e78b63          	beq	a5,a4,8e4 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 772:	05579063          	bne	a5,s5,7b2 <vprintf+0xf2>
        putc(fd, '%');
 776:	85d6                	mv	a1,s5
 778:	855a                	mv	a0,s6
 77a:	e83ff0ef          	jal	ra,5fc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 77e:	4981                	li	s3,0
 780:	bf69                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 782:	008b8913          	addi	s2,s7,8
 786:	4685                	li	a3,1
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	e8bff0ef          	jal	ra,61a <printint>
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	b749                	j	71a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 79a:	03868663          	beq	a3,s8,7c6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 79e:	05a68163          	beq	a3,s10,7e0 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 7a2:	09b68d63          	beq	a3,s11,83c <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a6:	03a68f63          	beq	a3,s10,7e4 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 7aa:	07800793          	li	a5,120
 7ae:	0cf68d63          	beq	a3,a5,888 <vprintf+0x1c8>
        putc(fd, '%');
 7b2:	85d6                	mv	a1,s5
 7b4:	855a                	mv	a0,s6
 7b6:	e47ff0ef          	jal	ra,5fc <putc>
        putc(fd, c0);
 7ba:	85ca                	mv	a1,s2
 7bc:	855a                	mv	a0,s6
 7be:	e3fff0ef          	jal	ra,5fc <putc>
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bf99                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	4685                	li	a3,1
 7cc:	4629                	li	a2,10
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	e47ff0ef          	jal	ra,61a <printint>
        i += 1;
 7d8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7da:	8bca                	mv	s7,s2
      state = 0;
 7dc:	4981                	li	s3,0
        i += 1;
 7de:	bf35                	j	71a <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7e0:	03860563          	beq	a2,s8,80a <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e4:	07b60963          	beq	a2,s11,856 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7e8:	07800793          	li	a5,120
 7ec:	fcf613e3          	bne	a2,a5,7b2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4641                	li	a2,16
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	e1dff0ef          	jal	ra,61a <printint>
        i += 2;
 802:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 2;
 808:	bf09                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4685                	li	a3,1
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	e03ff0ef          	jal	ra,61a <printint>
        i += 2;
 81c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 2;
 822:	bde5                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 824:	008b8913          	addi	s2,s7,8
 828:	4681                	li	a3,0
 82a:	4629                	li	a2,10
 82c:	000ba583          	lw	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	de9ff0ef          	jal	ra,61a <printint>
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	b5c5                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83c:	008b8913          	addi	s2,s7,8
 840:	4681                	li	a3,0
 842:	4629                	li	a2,10
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	dd1ff0ef          	jal	ra,61a <printint>
        i += 1;
 84e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
        i += 1;
 854:	b5d9                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 856:	008b8913          	addi	s2,s7,8
 85a:	4681                	li	a3,0
 85c:	4629                	li	a2,10
 85e:	000ba583          	lw	a1,0(s7)
 862:	855a                	mv	a0,s6
 864:	db7ff0ef          	jal	ra,61a <printint>
        i += 2;
 868:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 86a:	8bca                	mv	s7,s2
      state = 0;
 86c:	4981                	li	s3,0
        i += 2;
 86e:	b575                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 870:	008b8913          	addi	s2,s7,8
 874:	4681                	li	a3,0
 876:	4641                	li	a2,16
 878:	000ba583          	lw	a1,0(s7)
 87c:	855a                	mv	a0,s6
 87e:	d9dff0ef          	jal	ra,61a <printint>
 882:	8bca                	mv	s7,s2
      state = 0;
 884:	4981                	li	s3,0
 886:	bd51                	j	71a <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 888:	008b8913          	addi	s2,s7,8
 88c:	4681                	li	a3,0
 88e:	4641                	li	a2,16
 890:	000ba583          	lw	a1,0(s7)
 894:	855a                	mv	a0,s6
 896:	d85ff0ef          	jal	ra,61a <printint>
        i += 1;
 89a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 89c:	8bca                	mv	s7,s2
      state = 0;
 89e:	4981                	li	s3,0
        i += 1;
 8a0:	bdad                	j	71a <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 8a2:	008b8793          	addi	a5,s7,8
 8a6:	f8f43423          	sd	a5,-120(s0)
 8aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ae:	03000593          	li	a1,48
 8b2:	855a                	mv	a0,s6
 8b4:	d49ff0ef          	jal	ra,5fc <putc>
  putc(fd, 'x');
 8b8:	07800593          	li	a1,120
 8bc:	855a                	mv	a0,s6
 8be:	d3fff0ef          	jal	ra,5fc <putc>
 8c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c4:	03c9d793          	srli	a5,s3,0x3c
 8c8:	97e6                	add	a5,a5,s9
 8ca:	0007c583          	lbu	a1,0(a5)
 8ce:	855a                	mv	a0,s6
 8d0:	d2dff0ef          	jal	ra,5fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d4:	0992                	slli	s3,s3,0x4
 8d6:	397d                	addiw	s2,s2,-1
 8d8:	fe0916e3          	bnez	s2,8c4 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 8dc:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	bd25                	j	71a <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 8e4:	008b8993          	addi	s3,s7,8
 8e8:	000bb903          	ld	s2,0(s7)
 8ec:	00090f63          	beqz	s2,90a <vprintf+0x24a>
        for(; *s; s++)
 8f0:	00094583          	lbu	a1,0(s2)
 8f4:	c195                	beqz	a1,918 <vprintf+0x258>
          putc(fd, *s);
 8f6:	855a                	mv	a0,s6
 8f8:	d05ff0ef          	jal	ra,5fc <putc>
        for(; *s; s++)
 8fc:	0905                	addi	s2,s2,1
 8fe:	00094583          	lbu	a1,0(s2)
 902:	f9f5                	bnez	a1,8f6 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 904:	8bce                	mv	s7,s3
      state = 0;
 906:	4981                	li	s3,0
 908:	bd09                	j	71a <vprintf+0x5a>
          s = "(null)";
 90a:	00000917          	auipc	s2,0x0
 90e:	25e90913          	addi	s2,s2,606 # b68 <malloc+0x148>
        for(; *s; s++)
 912:	02800593          	li	a1,40
 916:	b7c5                	j	8f6 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 918:	8bce                	mv	s7,s3
      state = 0;
 91a:	4981                	li	s3,0
 91c:	bbfd                	j	71a <vprintf+0x5a>
    }
  }
}
 91e:	70e6                	ld	ra,120(sp)
 920:	7446                	ld	s0,112(sp)
 922:	74a6                	ld	s1,104(sp)
 924:	7906                	ld	s2,96(sp)
 926:	69e6                	ld	s3,88(sp)
 928:	6a46                	ld	s4,80(sp)
 92a:	6aa6                	ld	s5,72(sp)
 92c:	6b06                	ld	s6,64(sp)
 92e:	7be2                	ld	s7,56(sp)
 930:	7c42                	ld	s8,48(sp)
 932:	7ca2                	ld	s9,40(sp)
 934:	7d02                	ld	s10,32(sp)
 936:	6de2                	ld	s11,24(sp)
 938:	6109                	addi	sp,sp,128
 93a:	8082                	ret

000000000000093c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 93c:	715d                	addi	sp,sp,-80
 93e:	ec06                	sd	ra,24(sp)
 940:	e822                	sd	s0,16(sp)
 942:	1000                	addi	s0,sp,32
 944:	e010                	sd	a2,0(s0)
 946:	e414                	sd	a3,8(s0)
 948:	e818                	sd	a4,16(s0)
 94a:	ec1c                	sd	a5,24(s0)
 94c:	03043023          	sd	a6,32(s0)
 950:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 954:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 958:	8622                	mv	a2,s0
 95a:	d67ff0ef          	jal	ra,6c0 <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6161                	addi	sp,sp,80
 964:	8082                	ret

0000000000000966 <printf>:

void
printf(const char *fmt, ...)
{
 966:	711d                	addi	sp,sp,-96
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e40c                	sd	a1,8(s0)
 970:	e810                	sd	a2,16(s0)
 972:	ec14                	sd	a3,24(s0)
 974:	f018                	sd	a4,32(s0)
 976:	f41c                	sd	a5,40(s0)
 978:	03043823          	sd	a6,48(s0)
 97c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 980:	00840613          	addi	a2,s0,8
 984:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 988:	85aa                	mv	a1,a0
 98a:	4505                	li	a0,1
 98c:	d35ff0ef          	jal	ra,6c0 <vprintf>
}
 990:	60e2                	ld	ra,24(sp)
 992:	6442                	ld	s0,16(sp)
 994:	6125                	addi	sp,sp,96
 996:	8082                	ret

0000000000000998 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 998:	1141                	addi	sp,sp,-16
 99a:	e422                	sd	s0,8(sp)
 99c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	00000797          	auipc	a5,0x0
 9a6:	65e7b783          	ld	a5,1630(a5) # 1000 <freep>
 9aa:	a805                	j	9da <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ac:	4618                	lw	a4,8(a2)
 9ae:	9db9                	addw	a1,a1,a4
 9b0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	6398                	ld	a4,0(a5)
 9b6:	6318                	ld	a4,0(a4)
 9b8:	fee53823          	sd	a4,-16(a0)
 9bc:	a091                	j	a00 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9be:	ff852703          	lw	a4,-8(a0)
 9c2:	9e39                	addw	a2,a2,a4
 9c4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9c6:	ff053703          	ld	a4,-16(a0)
 9ca:	e398                	sd	a4,0(a5)
 9cc:	a099                	j	a12 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ce:	6398                	ld	a4,0(a5)
 9d0:	00e7e463          	bltu	a5,a4,9d8 <free+0x40>
 9d4:	00e6ea63          	bltu	a3,a4,9e8 <free+0x50>
{
 9d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9da:	fed7fae3          	bgeu	a5,a3,9ce <free+0x36>
 9de:	6398                	ld	a4,0(a5)
 9e0:	00e6e463          	bltu	a3,a4,9e8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e4:	fee7eae3          	bltu	a5,a4,9d8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9e8:	ff852583          	lw	a1,-8(a0)
 9ec:	6390                	ld	a2,0(a5)
 9ee:	02059713          	slli	a4,a1,0x20
 9f2:	9301                	srli	a4,a4,0x20
 9f4:	0712                	slli	a4,a4,0x4
 9f6:	9736                	add	a4,a4,a3
 9f8:	fae60ae3          	beq	a2,a4,9ac <free+0x14>
    bp->s.ptr = p->s.ptr;
 9fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a00:	4790                	lw	a2,8(a5)
 a02:	02061713          	slli	a4,a2,0x20
 a06:	9301                	srli	a4,a4,0x20
 a08:	0712                	slli	a4,a4,0x4
 a0a:	973e                	add	a4,a4,a5
 a0c:	fae689e3          	beq	a3,a4,9be <free+0x26>
  } else
    p->s.ptr = bp;
 a10:	e394                	sd	a3,0(a5)
  freep = p;
 a12:	00000717          	auipc	a4,0x0
 a16:	5ef73723          	sd	a5,1518(a4) # 1000 <freep>
}
 a1a:	6422                	ld	s0,8(sp)
 a1c:	0141                	addi	sp,sp,16
 a1e:	8082                	ret

0000000000000a20 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a20:	7139                	addi	sp,sp,-64
 a22:	fc06                	sd	ra,56(sp)
 a24:	f822                	sd	s0,48(sp)
 a26:	f426                	sd	s1,40(sp)
 a28:	f04a                	sd	s2,32(sp)
 a2a:	ec4e                	sd	s3,24(sp)
 a2c:	e852                	sd	s4,16(sp)
 a2e:	e456                	sd	s5,8(sp)
 a30:	e05a                	sd	s6,0(sp)
 a32:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a34:	02051493          	slli	s1,a0,0x20
 a38:	9081                	srli	s1,s1,0x20
 a3a:	04bd                	addi	s1,s1,15
 a3c:	8091                	srli	s1,s1,0x4
 a3e:	0014899b          	addiw	s3,s1,1
 a42:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a44:	00000517          	auipc	a0,0x0
 a48:	5bc53503          	ld	a0,1468(a0) # 1000 <freep>
 a4c:	c515                	beqz	a0,a78 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a50:	4798                	lw	a4,8(a5)
 a52:	02977f63          	bgeu	a4,s1,a90 <malloc+0x70>
 a56:	8a4e                	mv	s4,s3
 a58:	0009871b          	sext.w	a4,s3
 a5c:	6685                	lui	a3,0x1
 a5e:	00d77363          	bgeu	a4,a3,a64 <malloc+0x44>
 a62:	6a05                	lui	s4,0x1
 a64:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a68:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a6c:	00000917          	auipc	s2,0x0
 a70:	59490913          	addi	s2,s2,1428 # 1000 <freep>
  if(p == (char*)-1)
 a74:	5afd                	li	s5,-1
 a76:	a0bd                	j	ae4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 a78:	00000797          	auipc	a5,0x0
 a7c:	5a878793          	addi	a5,a5,1448 # 1020 <base>
 a80:	00000717          	auipc	a4,0x0
 a84:	58f73023          	sd	a5,1408(a4) # 1000 <freep>
 a88:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a8a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a8e:	b7e1                	j	a56 <malloc+0x36>
      if(p->s.size == nunits)
 a90:	02e48b63          	beq	s1,a4,ac6 <malloc+0xa6>
        p->s.size -= nunits;
 a94:	4137073b          	subw	a4,a4,s3
 a98:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a9a:	1702                	slli	a4,a4,0x20
 a9c:	9301                	srli	a4,a4,0x20
 a9e:	0712                	slli	a4,a4,0x4
 aa0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa6:	00000717          	auipc	a4,0x0
 aaa:	54a73d23          	sd	a0,1370(a4) # 1000 <freep>
      return (void*)(p + 1);
 aae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ab2:	70e2                	ld	ra,56(sp)
 ab4:	7442                	ld	s0,48(sp)
 ab6:	74a2                	ld	s1,40(sp)
 ab8:	7902                	ld	s2,32(sp)
 aba:	69e2                	ld	s3,24(sp)
 abc:	6a42                	ld	s4,16(sp)
 abe:	6aa2                	ld	s5,8(sp)
 ac0:	6b02                	ld	s6,0(sp)
 ac2:	6121                	addi	sp,sp,64
 ac4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ac6:	6398                	ld	a4,0(a5)
 ac8:	e118                	sd	a4,0(a0)
 aca:	bff1                	j	aa6 <malloc+0x86>
  hp->s.size = nu;
 acc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ad0:	0541                	addi	a0,a0,16
 ad2:	ec7ff0ef          	jal	ra,998 <free>
  return freep;
 ad6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ada:	dd61                	beqz	a0,ab2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 adc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ade:	4798                	lw	a4,8(a5)
 ae0:	fa9778e3          	bgeu	a4,s1,a90 <malloc+0x70>
    if(p == freep)
 ae4:	00093703          	ld	a4,0(s2)
 ae8:	853e                	mv	a0,a5
 aea:	fef719e3          	bne	a4,a5,adc <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 aee:	8552                	mv	a0,s4
 af0:	ad5ff0ef          	jal	ra,5c4 <sbrk>
  if(p == (char*)-1)
 af4:	fd551ce3          	bne	a0,s5,acc <malloc+0xac>
        return 0;
 af8:	4501                	li	a0,0
 afa:	bf65                	j	ab2 <malloc+0x92>
