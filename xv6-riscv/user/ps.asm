
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "kernel/procstat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(void) {
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
  18:	e86a                	sd	s10,16(sp)
  1a:	1880                	addi	s0,sp,112
  1c:	81010113          	addi	sp,sp,-2032
    struct proc_stat stats[NPROC];
    int count;

    count = getprocs(stats, NPROC);
  20:	04000593          	li	a1,64
  24:	77fd                	lui	a5,0xfffff
  26:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <base+0xffffffffffffe790>
  2a:	00f40533          	add	a0,s0,a5
  2e:	3ee000ef          	jal	ra,41c <getprocs>
    if(count < 0){
  32:	06054763          	bltz	a0,a0 <main+0xa0>
  36:	892a                	mv	s2,a0
        fprintf(2, "ps: impossible de récupérer les infos des processus\n");
        exit(1);
    }

    // En-tête avec un format fixe
    printf("PID\tSTATE\t\tMEM\tNAME\n");
  38:	00001517          	auipc	a0,0x1
  3c:	9a050513          	addi	a0,a0,-1632 # 9d8 <malloc+0x180>
  40:	75e000ef          	jal	ra,79e <printf>
    
    for(int i = 0; i < count; i++) {
  44:	0b205f63          	blez	s2,102 <main+0x102>
  48:	77fd                	lui	a5,0xfffff
  4a:	7b078713          	addi	a4,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffe7a0>
  4e:	00e404b3          	add	s1,s0,a4
  52:	397d                	addiw	s2,s2,-1
  54:	1902                	slli	s2,s2,0x20
  56:	02095913          	srli	s2,s2,0x20
  5a:	0916                	slli	s2,s2,0x5
  5c:	7d078793          	addi	a5,a5,2000
  60:	97a2                	add	a5,a5,s0
  62:	993e                	add	s2,s2,a5
  64:	4a11                	li	s4,4
            case 0: state = "UNUSED  "; break;
            case 1: state = "SLEEPING"; break;
            case 2: state = "RUNNABLE"; break;
            case 3: state = "RUNNING "; break;
            case 4: state = "ZOMBIE  "; break;
            default: state = "UNKNOWN "; break;
  66:	00001d17          	auipc	s10,0x1
  6a:	8dad0d13          	addi	s10,s10,-1830 # 940 <malloc+0xe8>
  6e:	00001997          	auipc	s3,0x1
  72:	99298993          	addi	s3,s3,-1646 # a00 <malloc+0x1a8>
            case 0: state = "UNUSED  "; break;
  76:	00001b17          	auipc	s6,0x1
  7a:	8dab0b13          	addi	s6,s6,-1830 # 950 <malloc+0xf8>
            case 4: state = "ZOMBIE  "; break;
  7e:	00001c97          	auipc	s9,0x1
  82:	902c8c93          	addi	s9,s9,-1790 # 980 <malloc+0x128>
            case 3: state = "RUNNING "; break;
  86:	00001c17          	auipc	s8,0x1
  8a:	8eac0c13          	addi	s8,s8,-1814 # 970 <malloc+0x118>
            case 2: state = "RUNNABLE"; break;
  8e:	00001b97          	auipc	s7,0x1
  92:	8d2b8b93          	addi	s7,s7,-1838 # 960 <malloc+0x108>
        switch(stats[i].state) {
  96:	00001a97          	auipc	s5,0x1
  9a:	8faa8a93          	addi	s5,s5,-1798 # 990 <malloc+0x138>
  9e:	a825                	j	d6 <main+0xd6>
        fprintf(2, "ps: impossible de récupérer les infos des processus\n");
  a0:	00001597          	auipc	a1,0x1
  a4:	90058593          	addi	a1,a1,-1792 # 9a0 <malloc+0x148>
  a8:	4509                	li	a0,2
  aa:	6ca000ef          	jal	ra,774 <fprintf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	2c4000ef          	jal	ra,374 <exit>
        switch(stats[i].state) {
  b4:	8656                	mv	a2,s5
        }

        // Affichage simple et robuste
        printf("%d\t%s\t%dK\t%s\n", 
  b6:	ffc72683          	lw	a3,-4(a4)
  ba:	00a6d69b          	srliw	a3,a3,0xa
  be:	ff072583          	lw	a1,-16(a4)
  c2:	00001517          	auipc	a0,0x1
  c6:	92e50513          	addi	a0,a0,-1746 # 9f0 <malloc+0x198>
  ca:	6d4000ef          	jal	ra,79e <printf>
    for(int i = 0; i < count; i++) {
  ce:	02048493          	addi	s1,s1,32
  d2:	03248863          	beq	s1,s2,102 <main+0x102>
        switch(stats[i].state) {
  d6:	8726                	mv	a4,s1
  d8:	ff44a783          	lw	a5,-12(s1)
  dc:	00fa6f63          	bltu	s4,a5,fa <main+0xfa>
  e0:	ff44e783          	lwu	a5,-12(s1)
  e4:	078a                	slli	a5,a5,0x2
  e6:	97ce                	add	a5,a5,s3
  e8:	439c                	lw	a5,0(a5)
  ea:	97ce                	add	a5,a5,s3
  ec:	8782                	jr	a5
            case 2: state = "RUNNABLE"; break;
  ee:	865e                	mv	a2,s7
  f0:	b7d9                	j	b6 <main+0xb6>
            case 3: state = "RUNNING "; break;
  f2:	8662                	mv	a2,s8
  f4:	b7c9                	j	b6 <main+0xb6>
            case 4: state = "ZOMBIE  "; break;
  f6:	8666                	mv	a2,s9
  f8:	bf7d                	j	b6 <main+0xb6>
            default: state = "UNKNOWN "; break;
  fa:	866a                	mv	a2,s10
  fc:	bf6d                	j	b6 <main+0xb6>
            case 0: state = "UNUSED  "; break;
  fe:	865a                	mv	a2,s6
 100:	bf5d                	j	b6 <main+0xb6>
               stats[i].pid,
               state,
               stats[i].memory / 1024,
               stats[i].name);
    }
    exit(0);
 102:	4501                	li	a0,0
 104:	270000ef          	jal	ra,374 <exit>

0000000000000108 <start>:
//


void
start()
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 110:	ef1ff0ef          	jal	ra,0 <main>
  exit(0);
 114:	4501                	li	a0,0
 116:	25e000ef          	jal	ra,374 <exit>

000000000000011a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	87aa                	mv	a5,a0
 122:	0585                	addi	a1,a1,1
 124:	0785                	addi	a5,a5,1
 126:	fff5c703          	lbu	a4,-1(a1)
 12a:	fee78fa3          	sb	a4,-1(a5)
 12e:	fb75                	bnez	a4,122 <strcpy+0x8>
    ;
  return os;
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 136:	1141                	addi	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cb91                	beqz	a5,154 <strcmp+0x1e>
 142:	0005c703          	lbu	a4,0(a1)
 146:	00f71763          	bne	a4,a5,154 <strcmp+0x1e>
    p++, q++;
 14a:	0505                	addi	a0,a0,1
 14c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbe5                	bnez	a5,142 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 154:	0005c503          	lbu	a0,0(a1)
}
 158:	40a7853b          	subw	a0,a5,a0
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cf91                	beqz	a5,188 <strlen+0x26>
 16e:	0505                	addi	a0,a0,1
 170:	87aa                	mv	a5,a0
 172:	4685                	li	a3,1
 174:	9e89                	subw	a3,a3,a0
 176:	00f6853b          	addw	a0,a3,a5
 17a:	0785                	addi	a5,a5,1
 17c:	fff7c703          	lbu	a4,-1(a5)
 180:	fb7d                	bnez	a4,176 <strlen+0x14>
    ;
  return n;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret
  for(n = 0; s[n]; n++)
 188:	4501                	li	a0,0
 18a:	bfe5                	j	182 <strlen+0x20>

000000000000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 192:	ca19                	beqz	a2,1a8 <memset+0x1c>
 194:	87aa                	mv	a5,a0
 196:	1602                	slli	a2,a2,0x20
 198:	9201                	srli	a2,a2,0x20
 19a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a2:	0785                	addi	a5,a5,1
 1a4:	fee79de3          	bne	a5,a4,19e <memset+0x12>
  }
  return dst;
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cb99                	beqz	a5,1ce <strchr+0x20>
    if(*s == c)
 1ba:	00f58763          	beq	a1,a5,1c8 <strchr+0x1a>
  for(; *s; s++)
 1be:	0505                	addi	a0,a0,1
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	fbfd                	bnez	a5,1ba <strchr+0xc>
      return (char*)s;
  return 0;
 1c6:	4501                	li	a0,0
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  return 0;
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <strchr+0x1a>

00000000000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	711d                	addi	sp,sp,-96
 1d4:	ec86                	sd	ra,88(sp)
 1d6:	e8a2                	sd	s0,80(sp)
 1d8:	e4a6                	sd	s1,72(sp)
 1da:	e0ca                	sd	s2,64(sp)
 1dc:	fc4e                	sd	s3,56(sp)
 1de:	f852                	sd	s4,48(sp)
 1e0:	f456                	sd	s5,40(sp)
 1e2:	f05a                	sd	s6,32(sp)
 1e4:	ec5e                	sd	s7,24(sp)
 1e6:	1080                	addi	s0,sp,96
 1e8:	8baa                	mv	s7,a0
 1ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	892a                	mv	s2,a0
 1ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f0:	4aa9                	li	s5,10
 1f2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f4:	89a6                	mv	s3,s1
 1f6:	2485                	addiw	s1,s1,1
 1f8:	0344d663          	bge	s1,s4,224 <gets+0x52>
    cc = read(0, &c, 1);
 1fc:	4605                	li	a2,1
 1fe:	faf40593          	addi	a1,s0,-81
 202:	4501                	li	a0,0
 204:	188000ef          	jal	ra,38c <read>
    if(cc < 1)
 208:	00a05e63          	blez	a0,224 <gets+0x52>
    buf[i++] = c;
 20c:	faf44783          	lbu	a5,-81(s0)
 210:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 214:	01578763          	beq	a5,s5,222 <gets+0x50>
 218:	0905                	addi	s2,s2,1
 21a:	fd679de3          	bne	a5,s6,1f4 <gets+0x22>
  for(i=0; i+1 < max; ){
 21e:	89a6                	mv	s3,s1
 220:	a011                	j	224 <gets+0x52>
 222:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 224:	99de                	add	s3,s3,s7
 226:	00098023          	sb	zero,0(s3)
  return buf;
}
 22a:	855e                	mv	a0,s7
 22c:	60e6                	ld	ra,88(sp)
 22e:	6446                	ld	s0,80(sp)
 230:	64a6                	ld	s1,72(sp)
 232:	6906                	ld	s2,64(sp)
 234:	79e2                	ld	s3,56(sp)
 236:	7a42                	ld	s4,48(sp)
 238:	7aa2                	ld	s5,40(sp)
 23a:	7b02                	ld	s6,32(sp)
 23c:	6be2                	ld	s7,24(sp)
 23e:	6125                	addi	sp,sp,96
 240:	8082                	ret

0000000000000242 <stat>:

int
stat(const char *n, struct stat *st)
{
 242:	1101                	addi	sp,sp,-32
 244:	ec06                	sd	ra,24(sp)
 246:	e822                	sd	s0,16(sp)
 248:	e426                	sd	s1,8(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	1000                	addi	s0,sp,32
 24e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 250:	4581                	li	a1,0
 252:	162000ef          	jal	ra,3b4 <open>
  if(fd < 0)
 256:	02054163          	bltz	a0,278 <stat+0x36>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	16e000ef          	jal	ra,3cc <fstat>
 262:	892a                	mv	s2,a0
  close(fd);
 264:	8526                	mv	a0,s1
 266:	136000ef          	jal	ra,39c <close>
  return r;
}
 26a:	854a                	mv	a0,s2
 26c:	60e2                	ld	ra,24(sp)
 26e:	6442                	ld	s0,16(sp)
 270:	64a2                	ld	s1,8(sp)
 272:	6902                	ld	s2,0(sp)
 274:	6105                	addi	sp,sp,32
 276:	8082                	ret
    return -1;
 278:	597d                	li	s2,-1
 27a:	bfc5                	j	26a <stat+0x28>

000000000000027c <atoi>:

int
atoi(const char *s)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 282:	00054603          	lbu	a2,0(a0)
 286:	fd06079b          	addiw	a5,a2,-48
 28a:	0ff7f793          	andi	a5,a5,255
 28e:	4725                	li	a4,9
 290:	02f76963          	bltu	a4,a5,2c2 <atoi+0x46>
 294:	86aa                	mv	a3,a0
  n = 0;
 296:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 298:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 29a:	0685                	addi	a3,a3,1
 29c:	0025179b          	slliw	a5,a0,0x2
 2a0:	9fa9                	addw	a5,a5,a0
 2a2:	0017979b          	slliw	a5,a5,0x1
 2a6:	9fb1                	addw	a5,a5,a2
 2a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ac:	0006c603          	lbu	a2,0(a3)
 2b0:	fd06071b          	addiw	a4,a2,-48
 2b4:	0ff77713          	andi	a4,a4,255
 2b8:	fee5f1e3          	bgeu	a1,a4,29a <atoi+0x1e>
  return n;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  n = 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <atoi+0x40>

00000000000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57463          	bgeu	a0,a1,2f4 <memmove+0x2e>
    while(n-- > 0)
 2d0:	00c05f63          	blez	a2,2ee <memmove+0x28>
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2de:	0585                	addi	a1,a1,1
 2e0:	0705                	addi	a4,a4,1
 2e2:	fff5c683          	lbu	a3,-1(a1)
 2e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ea:	fee79ae3          	bne	a5,a4,2de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
    dst += n;
 2f4:	00c50733          	add	a4,a0,a2
    src += n;
 2f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fa:	fec05ae3          	blez	a2,2ee <memmove+0x28>
 2fe:	fff6079b          	addiw	a5,a2,-1
 302:	1782                	slli	a5,a5,0x20
 304:	9381                	srli	a5,a5,0x20
 306:	fff7c793          	not	a5,a5
 30a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30c:	15fd                	addi	a1,a1,-1
 30e:	177d                	addi	a4,a4,-1
 310:	0005c683          	lbu	a3,0(a1)
 314:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 318:	fee79ae3          	bne	a5,a4,30c <memmove+0x46>
 31c:	bfc9                	j	2ee <memmove+0x28>

000000000000031e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	ca05                	beqz	a2,354 <memcmp+0x36>
 326:	fff6069b          	addiw	a3,a2,-1
 32a:	1682                	slli	a3,a3,0x20
 32c:	9281                	srli	a3,a3,0x20
 32e:	0685                	addi	a3,a3,1
 330:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 332:	00054783          	lbu	a5,0(a0)
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00e79863          	bne	a5,a4,34a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 33e:	0505                	addi	a0,a0,1
    p2++;
 340:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 342:	fed518e3          	bne	a0,a3,332 <memcmp+0x14>
  }
  return 0;
 346:	4501                	li	a0,0
 348:	a019                	j	34e <memcmp+0x30>
      return *p1 - *p2;
 34a:	40e7853b          	subw	a0,a5,a4
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  return 0;
 354:	4501                	li	a0,0
 356:	bfe5                	j	34e <memcmp+0x30>

0000000000000358 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 360:	f67ff0ef          	jal	ra,2c6 <memmove>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36c:	4885                	li	a7,1
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <exit>:
.global exit
exit:
 li a7, SYS_exit
 374:	4889                	li	a7,2
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <wait>:
.global wait
wait:
 li a7, SYS_wait
 37c:	488d                	li	a7,3
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 384:	4891                	li	a7,4
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <read>:
.global read
read:
 li a7, SYS_read
 38c:	4895                	li	a7,5
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <write>:
.global write
write:
 li a7, SYS_write
 394:	48c1                	li	a7,16
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <close>:
.global close
close:
 li a7, SYS_close
 39c:	48d5                	li	a7,21
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a4:	4899                	li	a7,6
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ac:	489d                	li	a7,7
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <open>:
.global open
open:
 li a7, SYS_open
 3b4:	48bd                	li	a7,15
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3bc:	48c5                	li	a7,17
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c4:	48c9                	li	a7,18
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3cc:	48a1                	li	a7,8
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <link>:
.global link
link:
 li a7, SYS_link
 3d4:	48cd                	li	a7,19
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3dc:	48d1                	li	a7,20
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e4:	48a5                	li	a7,9
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ec:	48a9                	li	a7,10
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f4:	48ad                	li	a7,11
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3fc:	48b1                	li	a7,12
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 404:	48b5                	li	a7,13
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40c:	48b9                	li	a7,14
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 414:	48d9                	li	a7,22
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 41c:	48dd                	li	a7,23
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 424:	48e1                	li	a7,24
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 42c:	48e5                	li	a7,25
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 434:	1101                	addi	sp,sp,-32
 436:	ec06                	sd	ra,24(sp)
 438:	e822                	sd	s0,16(sp)
 43a:	1000                	addi	s0,sp,32
 43c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 440:	4605                	li	a2,1
 442:	fef40593          	addi	a1,s0,-17
 446:	f4fff0ef          	jal	ra,394 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 452:	7139                	addi	sp,sp,-64
 454:	fc06                	sd	ra,56(sp)
 456:	f822                	sd	s0,48(sp)
 458:	f426                	sd	s1,40(sp)
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	0080                	addi	s0,sp,64
 460:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 462:	c299                	beqz	a3,468 <printint+0x16>
 464:	0805c663          	bltz	a1,4f0 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 468:	2581                	sext.w	a1,a1
  neg = 0;
 46a:	4881                	li	a7,0
 46c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 470:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 472:	2601                	sext.w	a2,a2
 474:	00000517          	auipc	a0,0x0
 478:	5ac50513          	addi	a0,a0,1452 # a20 <digits>
 47c:	883a                	mv	a6,a4
 47e:	2705                	addiw	a4,a4,1
 480:	02c5f7bb          	remuw	a5,a1,a2
 484:	1782                	slli	a5,a5,0x20
 486:	9381                	srli	a5,a5,0x20
 488:	97aa                	add	a5,a5,a0
 48a:	0007c783          	lbu	a5,0(a5)
 48e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 492:	0005879b          	sext.w	a5,a1
 496:	02c5d5bb          	divuw	a1,a1,a2
 49a:	0685                	addi	a3,a3,1
 49c:	fec7f0e3          	bgeu	a5,a2,47c <printint+0x2a>
  if(neg)
 4a0:	00088b63          	beqz	a7,4b6 <printint+0x64>
    buf[i++] = '-';
 4a4:	fd040793          	addi	a5,s0,-48
 4a8:	973e                	add	a4,a4,a5
 4aa:	02d00793          	li	a5,45
 4ae:	fef70823          	sb	a5,-16(a4)
 4b2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b6:	02e05663          	blez	a4,4e2 <printint+0x90>
 4ba:	fc040793          	addi	a5,s0,-64
 4be:	00e78933          	add	s2,a5,a4
 4c2:	fff78993          	addi	s3,a5,-1
 4c6:	99ba                	add	s3,s3,a4
 4c8:	377d                	addiw	a4,a4,-1
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	fff94583          	lbu	a1,-1(s2)
 4d6:	8526                	mv	a0,s1
 4d8:	f5dff0ef          	jal	ra,434 <putc>
  while(--i >= 0)
 4dc:	197d                	addi	s2,s2,-1
 4de:	ff391ae3          	bne	s2,s3,4d2 <printint+0x80>
}
 4e2:	70e2                	ld	ra,56(sp)
 4e4:	7442                	ld	s0,48(sp)
 4e6:	74a2                	ld	s1,40(sp)
 4e8:	7902                	ld	s2,32(sp)
 4ea:	69e2                	ld	s3,24(sp)
 4ec:	6121                	addi	sp,sp,64
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005bb          	negw	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	bf9d                	j	46c <printint+0x1a>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	7119                	addi	sp,sp,-128
 4fa:	fc86                	sd	ra,120(sp)
 4fc:	f8a2                	sd	s0,112(sp)
 4fe:	f4a6                	sd	s1,104(sp)
 500:	f0ca                	sd	s2,96(sp)
 502:	ecce                	sd	s3,88(sp)
 504:	e8d2                	sd	s4,80(sp)
 506:	e4d6                	sd	s5,72(sp)
 508:	e0da                	sd	s6,64(sp)
 50a:	fc5e                	sd	s7,56(sp)
 50c:	f862                	sd	s8,48(sp)
 50e:	f466                	sd	s9,40(sp)
 510:	f06a                	sd	s10,32(sp)
 512:	ec6e                	sd	s11,24(sp)
 514:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c903          	lbu	s2,0(a1)
 51a:	22090e63          	beqz	s2,756 <vprintf+0x25e>
 51e:	8b2a                	mv	s6,a0
 520:	8a2e                	mv	s4,a1
 522:	8bb2                	mv	s7,a2
  state = 0;
 524:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 526:	4481                	li	s1,0
 528:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 52a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 532:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 536:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53a:	00000c97          	auipc	s9,0x0
 53e:	4e6c8c93          	addi	s9,s9,1254 # a20 <digits>
 542:	a005                	j	562 <vprintf+0x6a>
        putc(fd, c0);
 544:	85ca                	mv	a1,s2
 546:	855a                	mv	a0,s6
 548:	eedff0ef          	jal	ra,434 <putc>
 54c:	a019                	j	552 <vprintf+0x5a>
    } else if(state == '%'){
 54e:	03598263          	beq	s3,s5,572 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 552:	2485                	addiw	s1,s1,1
 554:	8726                	mv	a4,s1
 556:	009a07b3          	add	a5,s4,s1
 55a:	0007c903          	lbu	s2,0(a5)
 55e:	1e090c63          	beqz	s2,756 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 562:	0009079b          	sext.w	a5,s2
    if(state == 0){
 566:	fe0994e3          	bnez	s3,54e <vprintf+0x56>
      if(c0 == '%'){
 56a:	fd579de3          	bne	a5,s5,544 <vprintf+0x4c>
        state = '%';
 56e:	89be                	mv	s3,a5
 570:	b7cd                	j	552 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 572:	cfa5                	beqz	a5,5ea <vprintf+0xf2>
 574:	00ea06b3          	add	a3,s4,a4
 578:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 57e:	c681                	beqz	a3,586 <vprintf+0x8e>
 580:	9752                	add	a4,a4,s4
 582:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 586:	03878a63          	beq	a5,s8,5ba <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 58a:	05a78463          	beq	a5,s10,5d2 <vprintf+0xda>
      } else if(c0 == 'u'){
 58e:	0db78763          	beq	a5,s11,65c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 592:	07800713          	li	a4,120
 596:	10e78963          	beq	a5,a4,6a8 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 59a:	07000713          	li	a4,112
 59e:	12e78e63          	beq	a5,a4,6da <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a2:	07300713          	li	a4,115
 5a6:	16e78b63          	beq	a5,a4,71c <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5aa:	05579063          	bne	a5,s5,5ea <vprintf+0xf2>
        putc(fd, '%');
 5ae:	85d6                	mv	a1,s5
 5b0:	855a                	mv	a0,s6
 5b2:	e83ff0ef          	jal	ra,434 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bf69                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e8bff0ef          	jal	ra,452 <printint>
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b749                	j	552 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d2:	03868663          	beq	a3,s8,5fe <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	05a68163          	beq	a3,s10,618 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 5da:	09b68d63          	beq	a3,s11,674 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5de:	03a68f63          	beq	a3,s10,61c <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 5e2:	07800793          	li	a5,120
 5e6:	0cf68d63          	beq	a3,a5,6c0 <vprintf+0x1c8>
        putc(fd, '%');
 5ea:	85d6                	mv	a1,s5
 5ec:	855a                	mv	a0,s6
 5ee:	e47ff0ef          	jal	ra,434 <putc>
        putc(fd, c0);
 5f2:	85ca                	mv	a1,s2
 5f4:	855a                	mv	a0,s6
 5f6:	e3fff0ef          	jal	ra,434 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bf99                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e47ff0ef          	jal	ra,452 <printint>
        i += 1;
 610:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	bf35                	j	552 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	03860563          	beq	a2,s8,642 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61c:	07b60963          	beq	a2,s11,68e <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 620:	07800793          	li	a5,120
 624:	fcf613e3          	bne	a2,a5,5ea <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e1dff0ef          	jal	ra,452 <printint>
        i += 2;
 63a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bf09                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 642:	008b8913          	addi	s2,s7,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	e03ff0ef          	jal	ra,452 <printint>
        i += 2;
 654:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	bde5                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	de9ff0ef          	jal	ra,452 <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b5c5                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dd1ff0ef          	jal	ra,452 <printint>
        i += 1;
 686:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	b5d9                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	db7ff0ef          	jal	ra,452 <printint>
        i += 2;
 6a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	b575                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d9dff0ef          	jal	ra,452 <printint>
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd51                	j	552 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d85ff0ef          	jal	ra,452 <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	bdad                	j	552 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6da:	008b8793          	addi	a5,s7,8
 6de:	f8f43423          	sd	a5,-120(s0)
 6e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e6:	03000593          	li	a1,48
 6ea:	855a                	mv	a0,s6
 6ec:	d49ff0ef          	jal	ra,434 <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	855a                	mv	a0,s6
 6f6:	d3fff0ef          	jal	ra,434 <putc>
 6fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	03c9d793          	srli	a5,s3,0x3c
 700:	97e6                	add	a5,a5,s9
 702:	0007c583          	lbu	a1,0(a5)
 706:	855a                	mv	a0,s6
 708:	d2dff0ef          	jal	ra,434 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70c:	0992                	slli	s3,s3,0x4
 70e:	397d                	addiw	s2,s2,-1
 710:	fe0916e3          	bnez	s2,6fc <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 714:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 718:	4981                	li	s3,0
 71a:	bd25                	j	552 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 71c:	008b8993          	addi	s3,s7,8
 720:	000bb903          	ld	s2,0(s7)
 724:	00090f63          	beqz	s2,742 <vprintf+0x24a>
        for(; *s; s++)
 728:	00094583          	lbu	a1,0(s2)
 72c:	c195                	beqz	a1,750 <vprintf+0x258>
          putc(fd, *s);
 72e:	855a                	mv	a0,s6
 730:	d05ff0ef          	jal	ra,434 <putc>
        for(; *s; s++)
 734:	0905                	addi	s2,s2,1
 736:	00094583          	lbu	a1,0(s2)
 73a:	f9f5                	bnez	a1,72e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	bd09                	j	552 <vprintf+0x5a>
          s = "(null)";
 742:	00000917          	auipc	s2,0x0
 746:	2d690913          	addi	s2,s2,726 # a18 <malloc+0x1c0>
        for(; *s; s++)
 74a:	02800593          	li	a1,40
 74e:	b7c5                	j	72e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bbfd                	j	552 <vprintf+0x5a>
    }
  }
}
 756:	70e6                	ld	ra,120(sp)
 758:	7446                	ld	s0,112(sp)
 75a:	74a6                	ld	s1,104(sp)
 75c:	7906                	ld	s2,96(sp)
 75e:	69e6                	ld	s3,88(sp)
 760:	6a46                	ld	s4,80(sp)
 762:	6aa6                	ld	s5,72(sp)
 764:	6b06                	ld	s6,64(sp)
 766:	7be2                	ld	s7,56(sp)
 768:	7c42                	ld	s8,48(sp)
 76a:	7ca2                	ld	s9,40(sp)
 76c:	7d02                	ld	s10,32(sp)
 76e:	6de2                	ld	s11,24(sp)
 770:	6109                	addi	sp,sp,128
 772:	8082                	ret

0000000000000774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 774:	715d                	addi	sp,sp,-80
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e010                	sd	a2,0(s0)
 77e:	e414                	sd	a3,8(s0)
 780:	e818                	sd	a4,16(s0)
 782:	ec1c                	sd	a5,24(s0)
 784:	03043023          	sd	a6,32(s0)
 788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 790:	8622                	mv	a2,s0
 792:	d67ff0ef          	jal	ra,4f8 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6161                	addi	sp,sp,80
 79c:	8082                	ret

000000000000079e <printf>:

void
printf(const char *fmt, ...)
{
 79e:	711d                	addi	sp,sp,-96
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e40c                	sd	a1,8(s0)
 7a8:	e810                	sd	a2,16(s0)
 7aa:	ec14                	sd	a3,24(s0)
 7ac:	f018                	sd	a4,32(s0)
 7ae:	f41c                	sd	a5,40(s0)
 7b0:	03043823          	sd	a6,48(s0)
 7b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	00840613          	addi	a2,s0,8
 7bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c0:	85aa                	mv	a1,a0
 7c2:	4505                	li	a0,1
 7c4:	d35ff0ef          	jal	ra,4f8 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	1141                	addi	sp,sp,-16
 7d2:	e422                	sd	s0,8(sp)
 7d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	00001797          	auipc	a5,0x1
 7de:	8267b783          	ld	a5,-2010(a5) # 1000 <freep>
 7e2:	a805                	j	812 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e4:	4618                	lw	a4,8(a2)
 7e6:	9db9                	addw	a1,a1,a4
 7e8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	6318                	ld	a4,0(a4)
 7f0:	fee53823          	sd	a4,-16(a0)
 7f4:	a091                	j	838 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f6:	ff852703          	lw	a4,-8(a0)
 7fa:	9e39                	addw	a2,a2,a4
 7fc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7fe:	ff053703          	ld	a4,-16(a0)
 802:	e398                	sd	a4,0(a5)
 804:	a099                	j	84a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	6398                	ld	a4,0(a5)
 808:	00e7e463          	bltu	a5,a4,810 <free+0x40>
 80c:	00e6ea63          	bltu	a3,a4,820 <free+0x50>
{
 810:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	fed7fae3          	bgeu	a5,a3,806 <free+0x36>
 816:	6398                	ld	a4,0(a5)
 818:	00e6e463          	bltu	a3,a4,820 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	fee7eae3          	bltu	a5,a4,810 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 820:	ff852583          	lw	a1,-8(a0)
 824:	6390                	ld	a2,0(a5)
 826:	02059713          	slli	a4,a1,0x20
 82a:	9301                	srli	a4,a4,0x20
 82c:	0712                	slli	a4,a4,0x4
 82e:	9736                	add	a4,a4,a3
 830:	fae60ae3          	beq	a2,a4,7e4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 834:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 838:	4790                	lw	a2,8(a5)
 83a:	02061713          	slli	a4,a2,0x20
 83e:	9301                	srli	a4,a4,0x20
 840:	0712                	slli	a4,a4,0x4
 842:	973e                	add	a4,a4,a5
 844:	fae689e3          	beq	a3,a4,7f6 <free+0x26>
  } else
    p->s.ptr = bp;
 848:	e394                	sd	a3,0(a5)
  freep = p;
 84a:	00000717          	auipc	a4,0x0
 84e:	7af73b23          	sd	a5,1974(a4) # 1000 <freep>
}
 852:	6422                	ld	s0,8(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret

0000000000000858 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 858:	7139                	addi	sp,sp,-64
 85a:	fc06                	sd	ra,56(sp)
 85c:	f822                	sd	s0,48(sp)
 85e:	f426                	sd	s1,40(sp)
 860:	f04a                	sd	s2,32(sp)
 862:	ec4e                	sd	s3,24(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
 86a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86c:	02051493          	slli	s1,a0,0x20
 870:	9081                	srli	s1,s1,0x20
 872:	04bd                	addi	s1,s1,15
 874:	8091                	srli	s1,s1,0x4
 876:	0014899b          	addiw	s3,s1,1
 87a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87c:	00000517          	auipc	a0,0x0
 880:	78453503          	ld	a0,1924(a0) # 1000 <freep>
 884:	c515                	beqz	a0,8b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 888:	4798                	lw	a4,8(a5)
 88a:	02977f63          	bgeu	a4,s1,8c8 <malloc+0x70>
 88e:	8a4e                	mv	s4,s3
 890:	0009871b          	sext.w	a4,s3
 894:	6685                	lui	a3,0x1
 896:	00d77363          	bgeu	a4,a3,89c <malloc+0x44>
 89a:	6a05                	lui	s4,0x1
 89c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a4:	00000917          	auipc	s2,0x0
 8a8:	75c90913          	addi	s2,s2,1884 # 1000 <freep>
  if(p == (char*)-1)
 8ac:	5afd                	li	s5,-1
 8ae:	a0bd                	j	91c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 8b0:	00000797          	auipc	a5,0x0
 8b4:	76078793          	addi	a5,a5,1888 # 1010 <base>
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74f73423          	sd	a5,1864(a4) # 1000 <freep>
 8c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c6:	b7e1                	j	88e <malloc+0x36>
      if(p->s.size == nunits)
 8c8:	02e48b63          	beq	s1,a4,8fe <malloc+0xa6>
        p->s.size -= nunits;
 8cc:	4137073b          	subw	a4,a4,s3
 8d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d2:	1702                	slli	a4,a4,0x20
 8d4:	9301                	srli	a4,a4,0x20
 8d6:	0712                	slli	a4,a4,0x4
 8d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8de:	00000717          	auipc	a4,0x0
 8e2:	72a73123          	sd	a0,1826(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	e118                	sd	a4,0(a0)
 902:	bff1                	j	8de <malloc+0x86>
  hp->s.size = nu;
 904:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 908:	0541                	addi	a0,a0,16
 90a:	ec7ff0ef          	jal	ra,7d0 <free>
  return freep;
 90e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 912:	dd61                	beqz	a0,8ea <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	fa9778e3          	bgeu	a4,s1,8c8 <malloc+0x70>
    if(p == freep)
 91c:	00093703          	ld	a4,0(s2)
 920:	853e                	mv	a0,a5
 922:	fef719e3          	bne	a4,a5,914 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 926:	8552                	mv	a0,s4
 928:	ad5ff0ef          	jal	ra,3fc <sbrk>
  if(p == (char*)-1)
 92c:	fd551ce3          	bne	a0,s5,904 <malloc+0xac>
        return 0;
 930:	4501                	li	a0,0
 932:	bf65                	j	8ea <malloc+0x92>
