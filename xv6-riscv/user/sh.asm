
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	2fe58593          	addi	a1,a1,766 # 1310 <malloc+0xe8>
      1a:	4509                	li	a0,2
      1c:	549000ef          	jal	ra,d64 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	337000ef          	jal	ra,b5c <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	375000ef          	jal	ra,ba2 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	2c458593          	addi	a1,a1,708 # 1318 <malloc+0xf0>
      5c:	4509                	li	a0,2
      5e:	0e6010ef          	jal	ra,1144 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	4e1000ef          	jal	ra,d44 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	4cd000ef          	jal	ra,d3c <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	29e50513          	addi	a0,a0,670 # 1320 <malloc+0xf8>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <execcmd>:

struct cmd*
execcmd(void)
{
      8e:	1101                	addi	sp,sp,-32
      90:	ec06                	sd	ra,24(sp)
      92:	e822                	sd	s0,16(sp)
      94:	e426                	sd	s1,8(sp)
      96:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
      98:	0a800513          	li	a0,168
      9c:	18c010ef          	jal	ra,1228 <malloc>
      a0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
      a2:	0a800613          	li	a2,168
      a6:	4581                	li	a1,0
      a8:	2b5000ef          	jal	ra,b5c <memset>
  cmd->type = EXEC;
      ac:	4785                	li	a5,1
      ae:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
      b0:	8526                	mv	a0,s1
      b2:	60e2                	ld	ra,24(sp)
      b4:	6442                	ld	s0,16(sp)
      b6:	64a2                	ld	s1,8(sp)
      b8:	6105                	addi	sp,sp,32
      ba:	8082                	ret

00000000000000bc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
      bc:	7139                	addi	sp,sp,-64
      be:	fc06                	sd	ra,56(sp)
      c0:	f822                	sd	s0,48(sp)
      c2:	f426                	sd	s1,40(sp)
      c4:	f04a                	sd	s2,32(sp)
      c6:	ec4e                	sd	s3,24(sp)
      c8:	e852                	sd	s4,16(sp)
      ca:	e456                	sd	s5,8(sp)
      cc:	e05a                	sd	s6,0(sp)
      ce:	0080                	addi	s0,sp,64
      d0:	8b2a                	mv	s6,a0
      d2:	8aae                	mv	s5,a1
      d4:	8a32                	mv	s4,a2
      d6:	89b6                	mv	s3,a3
      d8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
      da:	02800513          	li	a0,40
      de:	14a010ef          	jal	ra,1228 <malloc>
      e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
      e4:	02800613          	li	a2,40
      e8:	4581                	li	a1,0
      ea:	273000ef          	jal	ra,b5c <memset>
  cmd->type = REDIR;
      ee:	4789                	li	a5,2
      f0:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
      f2:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
      f6:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
      fa:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
      fe:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     102:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     106:	8526                	mv	a0,s1
     108:	70e2                	ld	ra,56(sp)
     10a:	7442                	ld	s0,48(sp)
     10c:	74a2                	ld	s1,40(sp)
     10e:	7902                	ld	s2,32(sp)
     110:	69e2                	ld	s3,24(sp)
     112:	6a42                	ld	s4,16(sp)
     114:	6aa2                	ld	s5,8(sp)
     116:	6b02                	ld	s6,0(sp)
     118:	6121                	addi	sp,sp,64
     11a:	8082                	ret

000000000000011c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
     12c:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     12e:	4561                	li	a0,24
     130:	0f8010ef          	jal	ra,1228 <malloc>
     134:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     136:	4661                	li	a2,24
     138:	4581                	li	a1,0
     13a:	223000ef          	jal	ra,b5c <memset>
  cmd->type = PIPE;
     13e:	478d                	li	a5,3
     140:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     142:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     146:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     14a:	8526                	mv	a0,s1
     14c:	70a2                	ld	ra,40(sp)
     14e:	7402                	ld	s0,32(sp)
     150:	64e2                	ld	s1,24(sp)
     152:	6942                	ld	s2,16(sp)
     154:	69a2                	ld	s3,8(sp)
     156:	6145                	addi	sp,sp,48
     158:	8082                	ret

000000000000015a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     15a:	7179                	addi	sp,sp,-48
     15c:	f406                	sd	ra,40(sp)
     15e:	f022                	sd	s0,32(sp)
     160:	ec26                	sd	s1,24(sp)
     162:	e84a                	sd	s2,16(sp)
     164:	e44e                	sd	s3,8(sp)
     166:	1800                	addi	s0,sp,48
     168:	89aa                	mv	s3,a0
     16a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     16c:	4561                	li	a0,24
     16e:	0ba010ef          	jal	ra,1228 <malloc>
     172:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     174:	4661                	li	a2,24
     176:	4581                	li	a1,0
     178:	1e5000ef          	jal	ra,b5c <memset>
  cmd->type = LIST;
     17c:	4791                	li	a5,4
     17e:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     180:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     184:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     188:	8526                	mv	a0,s1
     18a:	70a2                	ld	ra,40(sp)
     18c:	7402                	ld	s0,32(sp)
     18e:	64e2                	ld	s1,24(sp)
     190:	6942                	ld	s2,16(sp)
     192:	69a2                	ld	s3,8(sp)
     194:	6145                	addi	sp,sp,48
     196:	8082                	ret

0000000000000198 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     198:	1101                	addi	sp,sp,-32
     19a:	ec06                	sd	ra,24(sp)
     19c:	e822                	sd	s0,16(sp)
     19e:	e426                	sd	s1,8(sp)
     1a0:	e04a                	sd	s2,0(sp)
     1a2:	1000                	addi	s0,sp,32
     1a4:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1a6:	4541                	li	a0,16
     1a8:	080010ef          	jal	ra,1228 <malloc>
     1ac:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1ae:	4641                	li	a2,16
     1b0:	4581                	li	a1,0
     1b2:	1ab000ef          	jal	ra,b5c <memset>
  cmd->type = BACK;
     1b6:	4795                	li	a5,5
     1b8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     1ba:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     1be:	8526                	mv	a0,s1
     1c0:	60e2                	ld	ra,24(sp)
     1c2:	6442                	ld	s0,16(sp)
     1c4:	64a2                	ld	s1,8(sp)
     1c6:	6902                	ld	s2,0(sp)
     1c8:	6105                	addi	sp,sp,32
     1ca:	8082                	ret

00000000000001cc <scriptcmd>:

struct cmd*
scriptcmd(char *filename)
{
     1cc:	1101                	addi	sp,sp,-32
     1ce:	ec06                	sd	ra,24(sp)
     1d0:	e822                	sd	s0,16(sp)
     1d2:	e426                	sd	s1,8(sp)
     1d4:	e04a                	sd	s2,0(sp)
     1d6:	1000                	addi	s0,sp,32
     1d8:	892a                	mv	s2,a0
  struct scriptcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	4541                	li	a0,16
     1dc:	04c010ef          	jal	ra,1228 <malloc>
     1e0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e2:	4641                	li	a2,16
     1e4:	4581                	li	a1,0
     1e6:	177000ef          	jal	ra,b5c <memset>
  cmd->type = SCRIPT;
     1ea:	4799                	li	a5,6
     1ec:	c09c                	sw	a5,0(s1)
  cmd->filename = filename;
     1ee:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6902                	ld	s2,0(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8a2a                	mv	s4,a0
     216:	892e                	mv	s2,a1
     218:	8ab2                	mv	s5,a2
     21a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     21c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     21e:	00002997          	auipc	s3,0x2
     222:	dea98993          	addi	s3,s3,-534 # 2008 <whitespace>
     226:	00b4fb63          	bgeu	s1,a1,23c <gettoken+0x3c>
     22a:	0004c583          	lbu	a1,0(s1)
     22e:	854e                	mv	a0,s3
     230:	14f000ef          	jal	ra,b7e <strchr>
     234:	c501                	beqz	a0,23c <gettoken+0x3c>
    s++;
     236:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     238:	fe9919e3          	bne	s2,s1,22a <gettoken+0x2a>
  if(q)
     23c:	000a8463          	beqz	s5,244 <gettoken+0x44>
    *q = s;
     240:	009ab023          	sd	s1,0(s5)
  ret = *s;
     244:	0004c783          	lbu	a5,0(s1)
     248:	00078a9b          	sext.w	s5,a5
  switch(*s){
     24c:	03c00713          	li	a4,60
     250:	06f76363          	bltu	a4,a5,2b6 <gettoken+0xb6>
     254:	03a00713          	li	a4,58
     258:	00f76e63          	bltu	a4,a5,274 <gettoken+0x74>
     25c:	cf89                	beqz	a5,276 <gettoken+0x76>
     25e:	02600713          	li	a4,38
     262:	00e78963          	beq	a5,a4,274 <gettoken+0x74>
     266:	fd87879b          	addiw	a5,a5,-40
     26a:	0ff7f793          	andi	a5,a5,255
     26e:	4705                	li	a4,1
     270:	06f76a63          	bltu	a4,a5,2e4 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     274:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     276:	000b0463          	beqz	s6,27e <gettoken+0x7e>
    *eq = s;
     27a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     27e:	00002997          	auipc	s3,0x2
     282:	d8a98993          	addi	s3,s3,-630 # 2008 <whitespace>
     286:	0124fb63          	bgeu	s1,s2,29c <gettoken+0x9c>
     28a:	0004c583          	lbu	a1,0(s1)
     28e:	854e                	mv	a0,s3
     290:	0ef000ef          	jal	ra,b7e <strchr>
     294:	c501                	beqz	a0,29c <gettoken+0x9c>
    s++;
     296:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     298:	fe9919e3          	bne	s2,s1,28a <gettoken+0x8a>
  *ps = s;
     29c:	009a3023          	sd	s1,0(s4)
  return ret;
}
     2a0:	8556                	mv	a0,s5
     2a2:	70e2                	ld	ra,56(sp)
     2a4:	7442                	ld	s0,48(sp)
     2a6:	74a2                	ld	s1,40(sp)
     2a8:	7902                	ld	s2,32(sp)
     2aa:	69e2                	ld	s3,24(sp)
     2ac:	6a42                	ld	s4,16(sp)
     2ae:	6aa2                	ld	s5,8(sp)
     2b0:	6b02                	ld	s6,0(sp)
     2b2:	6121                	addi	sp,sp,64
     2b4:	8082                	ret
  switch(*s){
     2b6:	03e00713          	li	a4,62
     2ba:	02e79163          	bne	a5,a4,2dc <gettoken+0xdc>
    s++;
     2be:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     2c2:	0014c703          	lbu	a4,1(s1)
     2c6:	03e00793          	li	a5,62
      s++;
     2ca:	0489                	addi	s1,s1,2
      ret = '+';
     2cc:	02b00a93          	li	s5,43
    if(*s == '>'){
     2d0:	faf703e3          	beq	a4,a5,276 <gettoken+0x76>
    s++;
     2d4:	84b6                	mv	s1,a3
  ret = *s;
     2d6:	03e00a93          	li	s5,62
     2da:	bf71                	j	276 <gettoken+0x76>
  switch(*s){
     2dc:	07c00713          	li	a4,124
     2e0:	f8e78ae3          	beq	a5,a4,274 <gettoken+0x74>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     2e4:	00002997          	auipc	s3,0x2
     2e8:	d2498993          	addi	s3,s3,-732 # 2008 <whitespace>
     2ec:	00002a97          	auipc	s5,0x2
     2f0:	d14a8a93          	addi	s5,s5,-748 # 2000 <symbols>
     2f4:	0324f163          	bgeu	s1,s2,316 <gettoken+0x116>
     2f8:	0004c583          	lbu	a1,0(s1)
     2fc:	854e                	mv	a0,s3
     2fe:	081000ef          	jal	ra,b7e <strchr>
     302:	e115                	bnez	a0,326 <gettoken+0x126>
     304:	0004c583          	lbu	a1,0(s1)
     308:	8556                	mv	a0,s5
     30a:	075000ef          	jal	ra,b7e <strchr>
     30e:	e909                	bnez	a0,320 <gettoken+0x120>
      s++;
     310:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     312:	fe9913e3          	bne	s2,s1,2f8 <gettoken+0xf8>
  if(eq)
     316:	06100a93          	li	s5,97
     31a:	f60b10e3          	bnez	s6,27a <gettoken+0x7a>
     31e:	bfbd                	j	29c <gettoken+0x9c>
    ret = 'a';
     320:	06100a93          	li	s5,97
     324:	bf89                	j	276 <gettoken+0x76>
     326:	06100a93          	li	s5,97
     32a:	b7b1                	j	276 <gettoken+0x76>

000000000000032c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     32c:	7139                	addi	sp,sp,-64
     32e:	fc06                	sd	ra,56(sp)
     330:	f822                	sd	s0,48(sp)
     332:	f426                	sd	s1,40(sp)
     334:	f04a                	sd	s2,32(sp)
     336:	ec4e                	sd	s3,24(sp)
     338:	e852                	sd	s4,16(sp)
     33a:	e456                	sd	s5,8(sp)
     33c:	0080                	addi	s0,sp,64
     33e:	8a2a                	mv	s4,a0
     340:	892e                	mv	s2,a1
     342:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     344:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     346:	00002997          	auipc	s3,0x2
     34a:	cc298993          	addi	s3,s3,-830 # 2008 <whitespace>
     34e:	00b4fb63          	bgeu	s1,a1,364 <peek+0x38>
     352:	0004c583          	lbu	a1,0(s1)
     356:	854e                	mv	a0,s3
     358:	027000ef          	jal	ra,b7e <strchr>
     35c:	c501                	beqz	a0,364 <peek+0x38>
    s++;
     35e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     360:	fe9919e3          	bne	s2,s1,352 <peek+0x26>
  *ps = s;
     364:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     368:	0004c583          	lbu	a1,0(s1)
     36c:	4501                	li	a0,0
     36e:	e991                	bnez	a1,382 <peek+0x56>
}
     370:	70e2                	ld	ra,56(sp)
     372:	7442                	ld	s0,48(sp)
     374:	74a2                	ld	s1,40(sp)
     376:	7902                	ld	s2,32(sp)
     378:	69e2                	ld	s3,24(sp)
     37a:	6a42                	ld	s4,16(sp)
     37c:	6aa2                	ld	s5,8(sp)
     37e:	6121                	addi	sp,sp,64
     380:	8082                	ret
  return *s && strchr(toks, *s);
     382:	8556                	mv	a0,s5
     384:	7fa000ef          	jal	ra,b7e <strchr>
     388:	00a03533          	snez	a0,a0
     38c:	b7d5                	j	370 <peek+0x44>

000000000000038e <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     38e:	7159                	addi	sp,sp,-112
     390:	f486                	sd	ra,104(sp)
     392:	f0a2                	sd	s0,96(sp)
     394:	eca6                	sd	s1,88(sp)
     396:	e8ca                	sd	s2,80(sp)
     398:	e4ce                	sd	s3,72(sp)
     39a:	e0d2                	sd	s4,64(sp)
     39c:	fc56                	sd	s5,56(sp)
     39e:	f85a                	sd	s6,48(sp)
     3a0:	f45e                	sd	s7,40(sp)
     3a2:	f062                	sd	s8,32(sp)
     3a4:	ec66                	sd	s9,24(sp)
     3a6:	1880                	addi	s0,sp,112
     3a8:	8a2a                	mv	s4,a0
     3aa:	89ae                	mv	s3,a1
     3ac:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     3ae:	00001b97          	auipc	s7,0x1
     3b2:	f9ab8b93          	addi	s7,s7,-102 # 1348 <malloc+0x120>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     3b6:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     3ba:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     3be:	a00d                	j	3e0 <parseredirs+0x52>
      panic("missing file for redirection");
     3c0:	00001517          	auipc	a0,0x1
     3c4:	f6850513          	addi	a0,a0,-152 # 1328 <malloc+0x100>
     3c8:	c83ff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     3cc:	4701                	li	a4,0
     3ce:	4681                	li	a3,0
     3d0:	f9043603          	ld	a2,-112(s0)
     3d4:	f9843583          	ld	a1,-104(s0)
     3d8:	8552                	mv	a0,s4
     3da:	ce3ff0ef          	jal	ra,bc <redircmd>
     3de:	8a2a                	mv	s4,a0
    switch(tok){
     3e0:	03e00b13          	li	s6,62
     3e4:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     3e8:	865e                	mv	a2,s7
     3ea:	85ca                	mv	a1,s2
     3ec:	854e                	mv	a0,s3
     3ee:	f3fff0ef          	jal	ra,32c <peek>
     3f2:	c125                	beqz	a0,452 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     3f4:	4681                	li	a3,0
     3f6:	4601                	li	a2,0
     3f8:	85ca                	mv	a1,s2
     3fa:	854e                	mv	a0,s3
     3fc:	e05ff0ef          	jal	ra,200 <gettoken>
     400:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     402:	f9040693          	addi	a3,s0,-112
     406:	f9840613          	addi	a2,s0,-104
     40a:	85ca                	mv	a1,s2
     40c:	854e                	mv	a0,s3
     40e:	df3ff0ef          	jal	ra,200 <gettoken>
     412:	fb8517e3          	bne	a0,s8,3c0 <parseredirs+0x32>
    switch(tok){
     416:	fb948be3          	beq	s1,s9,3cc <parseredirs+0x3e>
     41a:	03648063          	beq	s1,s6,43a <parseredirs+0xac>
     41e:	fd5495e3          	bne	s1,s5,3e8 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     422:	4705                	li	a4,1
     424:	20100693          	li	a3,513
     428:	f9043603          	ld	a2,-112(s0)
     42c:	f9843583          	ld	a1,-104(s0)
     430:	8552                	mv	a0,s4
     432:	c8bff0ef          	jal	ra,bc <redircmd>
     436:	8a2a                	mv	s4,a0
      break;
     438:	b765                	j	3e0 <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     43a:	4705                	li	a4,1
     43c:	60100693          	li	a3,1537
     440:	f9043603          	ld	a2,-112(s0)
     444:	f9843583          	ld	a1,-104(s0)
     448:	8552                	mv	a0,s4
     44a:	c73ff0ef          	jal	ra,bc <redircmd>
     44e:	8a2a                	mv	s4,a0
      break;
     450:	bf41                	j	3e0 <parseredirs+0x52>
    }
  }
  return cmd;
}
     452:	8552                	mv	a0,s4
     454:	70a6                	ld	ra,104(sp)
     456:	7406                	ld	s0,96(sp)
     458:	64e6                	ld	s1,88(sp)
     45a:	6946                	ld	s2,80(sp)
     45c:	69a6                	ld	s3,72(sp)
     45e:	6a06                	ld	s4,64(sp)
     460:	7ae2                	ld	s5,56(sp)
     462:	7b42                	ld	s6,48(sp)
     464:	7ba2                	ld	s7,40(sp)
     466:	7c02                	ld	s8,32(sp)
     468:	6ce2                	ld	s9,24(sp)
     46a:	6165                	addi	sp,sp,112
     46c:	8082                	ret

000000000000046e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     46e:	7159                	addi	sp,sp,-112
     470:	f486                	sd	ra,104(sp)
     472:	f0a2                	sd	s0,96(sp)
     474:	eca6                	sd	s1,88(sp)
     476:	e8ca                	sd	s2,80(sp)
     478:	e4ce                	sd	s3,72(sp)
     47a:	e0d2                	sd	s4,64(sp)
     47c:	fc56                	sd	s5,56(sp)
     47e:	f85a                	sd	s6,48(sp)
     480:	f45e                	sd	s7,40(sp)
     482:	f062                	sd	s8,32(sp)
     484:	ec66                	sd	s9,24(sp)
     486:	1880                	addi	s0,sp,112
     488:	8a2a                	mv	s4,a0
     48a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     48c:	00001617          	auipc	a2,0x1
     490:	ec460613          	addi	a2,a2,-316 # 1350 <malloc+0x128>
     494:	e99ff0ef          	jal	ra,32c <peek>
     498:	e505                	bnez	a0,4c0 <parseexec+0x52>
     49a:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     49c:	bf3ff0ef          	jal	ra,8e <execcmd>
     4a0:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     4a2:	8656                	mv	a2,s5
     4a4:	85d2                	mv	a1,s4
     4a6:	ee9ff0ef          	jal	ra,38e <parseredirs>
     4aa:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     4ac:	008c0913          	addi	s2,s8,8
     4b0:	00001b17          	auipc	s6,0x1
     4b4:	ec0b0b13          	addi	s6,s6,-320 # 1370 <malloc+0x148>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     4b8:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     4bc:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     4be:	a081                	j	4fe <parseexec+0x90>
    return parseblock(ps, es);
     4c0:	85d6                	mv	a1,s5
     4c2:	8552                	mv	a0,s4
     4c4:	170000ef          	jal	ra,634 <parseblock>
     4c8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     4ca:	8526                	mv	a0,s1
     4cc:	70a6                	ld	ra,104(sp)
     4ce:	7406                	ld	s0,96(sp)
     4d0:	64e6                	ld	s1,88(sp)
     4d2:	6946                	ld	s2,80(sp)
     4d4:	69a6                	ld	s3,72(sp)
     4d6:	6a06                	ld	s4,64(sp)
     4d8:	7ae2                	ld	s5,56(sp)
     4da:	7b42                	ld	s6,48(sp)
     4dc:	7ba2                	ld	s7,40(sp)
     4de:	7c02                	ld	s8,32(sp)
     4e0:	6ce2                	ld	s9,24(sp)
     4e2:	6165                	addi	sp,sp,112
     4e4:	8082                	ret
      panic("syntax");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	e7250513          	addi	a0,a0,-398 # 1358 <malloc+0x130>
     4ee:	b5dff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     4f2:	8656                	mv	a2,s5
     4f4:	85d2                	mv	a1,s4
     4f6:	8526                	mv	a0,s1
     4f8:	e97ff0ef          	jal	ra,38e <parseredirs>
     4fc:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     4fe:	865a                	mv	a2,s6
     500:	85d6                	mv	a1,s5
     502:	8552                	mv	a0,s4
     504:	e29ff0ef          	jal	ra,32c <peek>
     508:	ed15                	bnez	a0,544 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     50a:	f9040693          	addi	a3,s0,-112
     50e:	f9840613          	addi	a2,s0,-104
     512:	85d6                	mv	a1,s5
     514:	8552                	mv	a0,s4
     516:	cebff0ef          	jal	ra,200 <gettoken>
     51a:	c50d                	beqz	a0,544 <parseexec+0xd6>
    if(tok != 'a')
     51c:	fd9515e3          	bne	a0,s9,4e6 <parseexec+0x78>
    cmd->argv[argc] = q;
     520:	f9843783          	ld	a5,-104(s0)
     524:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     528:	f9043783          	ld	a5,-112(s0)
     52c:	04f93823          	sd	a5,80(s2)
    argc++;
     530:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     532:	0921                	addi	s2,s2,8
     534:	fb799fe3          	bne	s3,s7,4f2 <parseexec+0x84>
      panic("too many args");
     538:	00001517          	auipc	a0,0x1
     53c:	e2850513          	addi	a0,a0,-472 # 1360 <malloc+0x138>
     540:	b0bff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     544:	098e                	slli	s3,s3,0x3
     546:	99e2                	add	s3,s3,s8
     548:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     54c:	0409bc23          	sd	zero,88(s3)
  return ret;
     550:	bfad                	j	4ca <parseexec+0x5c>

0000000000000552 <parsepipe>:
{
     552:	7179                	addi	sp,sp,-48
     554:	f406                	sd	ra,40(sp)
     556:	f022                	sd	s0,32(sp)
     558:	ec26                	sd	s1,24(sp)
     55a:	e84a                	sd	s2,16(sp)
     55c:	e44e                	sd	s3,8(sp)
     55e:	1800                	addi	s0,sp,48
     560:	892a                	mv	s2,a0
     562:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     564:	f0bff0ef          	jal	ra,46e <parseexec>
     568:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     56a:	00001617          	auipc	a2,0x1
     56e:	e0e60613          	addi	a2,a2,-498 # 1378 <malloc+0x150>
     572:	85ce                	mv	a1,s3
     574:	854a                	mv	a0,s2
     576:	db7ff0ef          	jal	ra,32c <peek>
     57a:	e909                	bnez	a0,58c <parsepipe+0x3a>
}
     57c:	8526                	mv	a0,s1
     57e:	70a2                	ld	ra,40(sp)
     580:	7402                	ld	s0,32(sp)
     582:	64e2                	ld	s1,24(sp)
     584:	6942                	ld	s2,16(sp)
     586:	69a2                	ld	s3,8(sp)
     588:	6145                	addi	sp,sp,48
     58a:	8082                	ret
    gettoken(ps, es, 0, 0);
     58c:	4681                	li	a3,0
     58e:	4601                	li	a2,0
     590:	85ce                	mv	a1,s3
     592:	854a                	mv	a0,s2
     594:	c6dff0ef          	jal	ra,200 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     598:	85ce                	mv	a1,s3
     59a:	854a                	mv	a0,s2
     59c:	fb7ff0ef          	jal	ra,552 <parsepipe>
     5a0:	85aa                	mv	a1,a0
     5a2:	8526                	mv	a0,s1
     5a4:	b79ff0ef          	jal	ra,11c <pipecmd>
     5a8:	84aa                	mv	s1,a0
  return cmd;
     5aa:	bfc9                	j	57c <parsepipe+0x2a>

00000000000005ac <parseline>:
{
     5ac:	7179                	addi	sp,sp,-48
     5ae:	f406                	sd	ra,40(sp)
     5b0:	f022                	sd	s0,32(sp)
     5b2:	ec26                	sd	s1,24(sp)
     5b4:	e84a                	sd	s2,16(sp)
     5b6:	e44e                	sd	s3,8(sp)
     5b8:	e052                	sd	s4,0(sp)
     5ba:	1800                	addi	s0,sp,48
     5bc:	892a                	mv	s2,a0
     5be:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     5c0:	f93ff0ef          	jal	ra,552 <parsepipe>
     5c4:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     5c6:	00001a17          	auipc	s4,0x1
     5ca:	dbaa0a13          	addi	s4,s4,-582 # 1380 <malloc+0x158>
     5ce:	a819                	j	5e4 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     5d0:	4681                	li	a3,0
     5d2:	4601                	li	a2,0
     5d4:	85ce                	mv	a1,s3
     5d6:	854a                	mv	a0,s2
     5d8:	c29ff0ef          	jal	ra,200 <gettoken>
    cmd = backcmd(cmd);
     5dc:	8526                	mv	a0,s1
     5de:	bbbff0ef          	jal	ra,198 <backcmd>
     5e2:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     5e4:	8652                	mv	a2,s4
     5e6:	85ce                	mv	a1,s3
     5e8:	854a                	mv	a0,s2
     5ea:	d43ff0ef          	jal	ra,32c <peek>
     5ee:	f16d                	bnez	a0,5d0 <parseline+0x24>
  if(peek(ps, es, ";")){
     5f0:	00001617          	auipc	a2,0x1
     5f4:	d9860613          	addi	a2,a2,-616 # 1388 <malloc+0x160>
     5f8:	85ce                	mv	a1,s3
     5fa:	854a                	mv	a0,s2
     5fc:	d31ff0ef          	jal	ra,32c <peek>
     600:	e911                	bnez	a0,614 <parseline+0x68>
}
     602:	8526                	mv	a0,s1
     604:	70a2                	ld	ra,40(sp)
     606:	7402                	ld	s0,32(sp)
     608:	64e2                	ld	s1,24(sp)
     60a:	6942                	ld	s2,16(sp)
     60c:	69a2                	ld	s3,8(sp)
     60e:	6a02                	ld	s4,0(sp)
     610:	6145                	addi	sp,sp,48
     612:	8082                	ret
    gettoken(ps, es, 0, 0);
     614:	4681                	li	a3,0
     616:	4601                	li	a2,0
     618:	85ce                	mv	a1,s3
     61a:	854a                	mv	a0,s2
     61c:	be5ff0ef          	jal	ra,200 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     620:	85ce                	mv	a1,s3
     622:	854a                	mv	a0,s2
     624:	f89ff0ef          	jal	ra,5ac <parseline>
     628:	85aa                	mv	a1,a0
     62a:	8526                	mv	a0,s1
     62c:	b2fff0ef          	jal	ra,15a <listcmd>
     630:	84aa                	mv	s1,a0
  return cmd;
     632:	bfc1                	j	602 <parseline+0x56>

0000000000000634 <parseblock>:
{
     634:	7179                	addi	sp,sp,-48
     636:	f406                	sd	ra,40(sp)
     638:	f022                	sd	s0,32(sp)
     63a:	ec26                	sd	s1,24(sp)
     63c:	e84a                	sd	s2,16(sp)
     63e:	e44e                	sd	s3,8(sp)
     640:	1800                	addi	s0,sp,48
     642:	84aa                	mv	s1,a0
     644:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     646:	00001617          	auipc	a2,0x1
     64a:	d0a60613          	addi	a2,a2,-758 # 1350 <malloc+0x128>
     64e:	cdfff0ef          	jal	ra,32c <peek>
     652:	c539                	beqz	a0,6a0 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     654:	4681                	li	a3,0
     656:	4601                	li	a2,0
     658:	85ca                	mv	a1,s2
     65a:	8526                	mv	a0,s1
     65c:	ba5ff0ef          	jal	ra,200 <gettoken>
  cmd = parseline(ps, es);
     660:	85ca                	mv	a1,s2
     662:	8526                	mv	a0,s1
     664:	f49ff0ef          	jal	ra,5ac <parseline>
     668:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     66a:	00001617          	auipc	a2,0x1
     66e:	d3660613          	addi	a2,a2,-714 # 13a0 <malloc+0x178>
     672:	85ca                	mv	a1,s2
     674:	8526                	mv	a0,s1
     676:	cb7ff0ef          	jal	ra,32c <peek>
     67a:	c90d                	beqz	a0,6ac <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     67c:	4681                	li	a3,0
     67e:	4601                	li	a2,0
     680:	85ca                	mv	a1,s2
     682:	8526                	mv	a0,s1
     684:	b7dff0ef          	jal	ra,200 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     688:	864a                	mv	a2,s2
     68a:	85a6                	mv	a1,s1
     68c:	854e                	mv	a0,s3
     68e:	d01ff0ef          	jal	ra,38e <parseredirs>
}
     692:	70a2                	ld	ra,40(sp)
     694:	7402                	ld	s0,32(sp)
     696:	64e2                	ld	s1,24(sp)
     698:	6942                	ld	s2,16(sp)
     69a:	69a2                	ld	s3,8(sp)
     69c:	6145                	addi	sp,sp,48
     69e:	8082                	ret
    panic("parseblock");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	cf050513          	addi	a0,a0,-784 # 1390 <malloc+0x168>
     6a8:	9a3ff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     6ac:	00001517          	auipc	a0,0x1
     6b0:	cfc50513          	addi	a0,a0,-772 # 13a8 <malloc+0x180>
     6b4:	997ff0ef          	jal	ra,4a <panic>

00000000000006b8 <nulterminate>:

struct cmd*
nulterminate(struct cmd *cmd)
{
     6b8:	1101                	addi	sp,sp,-32
     6ba:	ec06                	sd	ra,24(sp)
     6bc:	e822                	sd	s0,16(sp)
     6be:	e426                	sd	s1,8(sp)
     6c0:	1000                	addi	s0,sp,32
     6c2:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     6c4:	c131                	beqz	a0,708 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     6c6:	4118                	lw	a4,0(a0)
     6c8:	4795                	li	a5,5
     6ca:	02e7ef63          	bltu	a5,a4,708 <nulterminate+0x50>
     6ce:	00056783          	lwu	a5,0(a0)
     6d2:	078a                	slli	a5,a5,0x2
     6d4:	00001717          	auipc	a4,0x1
     6d8:	d7470713          	addi	a4,a4,-652 # 1448 <malloc+0x220>
     6dc:	97ba                	add	a5,a5,a4
     6de:	439c                	lw	a5,0(a5)
     6e0:	97ba                	add	a5,a5,a4
     6e2:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     6e4:	651c                	ld	a5,8(a0)
     6e6:	c38d                	beqz	a5,708 <nulterminate+0x50>
     6e8:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     6ec:	67b8                	ld	a4,72(a5)
     6ee:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     6f2:	07a1                	addi	a5,a5,8
     6f4:	ff87b703          	ld	a4,-8(a5)
     6f8:	fb75                	bnez	a4,6ec <nulterminate+0x34>
     6fa:	a039                	j	708 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     6fc:	6508                	ld	a0,8(a0)
     6fe:	fbbff0ef          	jal	ra,6b8 <nulterminate>
    *rcmd->efile = 0;
     702:	6c9c                	ld	a5,24(s1)
     704:	00078023          	sb	zero,0(a5)

  case SCRIPT:
    break;
  }
  return cmd;
}
     708:	8526                	mv	a0,s1
     70a:	60e2                	ld	ra,24(sp)
     70c:	6442                	ld	s0,16(sp)
     70e:	64a2                	ld	s1,8(sp)
     710:	6105                	addi	sp,sp,32
     712:	8082                	ret
    nulterminate(pcmd->left);
     714:	6508                	ld	a0,8(a0)
     716:	fa3ff0ef          	jal	ra,6b8 <nulterminate>
    nulterminate(pcmd->right);
     71a:	6888                	ld	a0,16(s1)
     71c:	f9dff0ef          	jal	ra,6b8 <nulterminate>
    break;
     720:	b7e5                	j	708 <nulterminate+0x50>
    nulterminate(lcmd->left);
     722:	6508                	ld	a0,8(a0)
     724:	f95ff0ef          	jal	ra,6b8 <nulterminate>
    nulterminate(lcmd->right);
     728:	6888                	ld	a0,16(s1)
     72a:	f8fff0ef          	jal	ra,6b8 <nulterminate>
    break;
     72e:	bfe9                	j	708 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     730:	6508                	ld	a0,8(a0)
     732:	f87ff0ef          	jal	ra,6b8 <nulterminate>
    break;
     736:	bfc9                	j	708 <nulterminate+0x50>

0000000000000738 <parsecmd>:
{
     738:	7179                	addi	sp,sp,-48
     73a:	f406                	sd	ra,40(sp)
     73c:	f022                	sd	s0,32(sp)
     73e:	ec26                	sd	s1,24(sp)
     740:	e84a                	sd	s2,16(sp)
     742:	1800                	addi	s0,sp,48
     744:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     748:	84aa                	mv	s1,a0
     74a:	3e8000ef          	jal	ra,b32 <strlen>
     74e:	1502                	slli	a0,a0,0x20
     750:	9101                	srli	a0,a0,0x20
     752:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     754:	85a6                	mv	a1,s1
     756:	fd840513          	addi	a0,s0,-40
     75a:	e53ff0ef          	jal	ra,5ac <parseline>
     75e:	892a                	mv	s2,a0
  peek(&s, es, "");
     760:	00001617          	auipc	a2,0x1
     764:	c9860613          	addi	a2,a2,-872 # 13f8 <malloc+0x1d0>
     768:	85a6                	mv	a1,s1
     76a:	fd840513          	addi	a0,s0,-40
     76e:	bbfff0ef          	jal	ra,32c <peek>
  if(s != es){
     772:	fd843603          	ld	a2,-40(s0)
     776:	00961c63          	bne	a2,s1,78e <parsecmd+0x56>
  nulterminate(cmd);
     77a:	854a                	mv	a0,s2
     77c:	f3dff0ef          	jal	ra,6b8 <nulterminate>
}
     780:	854a                	mv	a0,s2
     782:	70a2                	ld	ra,40(sp)
     784:	7402                	ld	s0,32(sp)
     786:	64e2                	ld	s1,24(sp)
     788:	6942                	ld	s2,16(sp)
     78a:	6145                	addi	sp,sp,48
     78c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     78e:	00001597          	auipc	a1,0x1
     792:	c3258593          	addi	a1,a1,-974 # 13c0 <malloc+0x198>
     796:	4509                	li	a0,2
     798:	1ad000ef          	jal	ra,1144 <fprintf>
    panic("syntax");
     79c:	00001517          	auipc	a0,0x1
     7a0:	bbc50513          	addi	a0,a0,-1092 # 1358 <malloc+0x130>
     7a4:	8a7ff0ef          	jal	ra,4a <panic>

00000000000007a8 <execscript>:
void execscript(char *filename) {
     7a8:	bd010113          	addi	sp,sp,-1072
     7ac:	42113423          	sd	ra,1064(sp)
     7b0:	42813023          	sd	s0,1056(sp)
     7b4:	40913c23          	sd	s1,1048(sp)
     7b8:	41213823          	sd	s2,1040(sp)
     7bc:	41313423          	sd	s3,1032(sp)
     7c0:	41413023          	sd	s4,1024(sp)
     7c4:	43010413          	addi	s0,sp,1072
     7c8:	89aa                	mv	s3,a0
  fd = open(filename, O_RDONLY);
     7ca:	4581                	li	a1,0
     7cc:	5b8000ef          	jal	ra,d84 <open>
  if(fd < 0) {
     7d0:	00054963          	bltz	a0,7e2 <execscript+0x3a>
     7d4:	892a                	mv	s2,a0
     7d6:	bd040493          	addi	s1,s0,-1072
    if(*p == '\n') {
     7da:	49a9                	li	s3,10
      if(p >= &buf[MAXSCRIPT-1]) {
     7dc:	fcf40a13          	addi	s4,s0,-49
     7e0:	a035                	j	80c <execscript+0x64>
    fprintf(2, "cannot open script %s\n", filename);
     7e2:	864e                	mv	a2,s3
     7e4:	00001597          	auipc	a1,0x1
     7e8:	bec58593          	addi	a1,a1,-1044 # 13d0 <malloc+0x1a8>
     7ec:	4509                	li	a0,2
     7ee:	157000ef          	jal	ra,1144 <fprintf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	550000ef          	jal	ra,d44 <exit>
      *p = 0;
     7f8:	00048023          	sb	zero,0(s1)
      if(strlen(buf) > 0) {
     7fc:	bd040513          	addi	a0,s0,-1072
     800:	332000ef          	jal	ra,b32 <strlen>
     804:	2501                	sext.w	a0,a0
      p = buf;
     806:	bd040493          	addi	s1,s0,-1072
      if(strlen(buf) > 0) {
     80a:	e90d                	bnez	a0,83c <execscript+0x94>
  while((n = read(fd, p, 1)) > 0) {
     80c:	4605                	li	a2,1
     80e:	85a6                	mv	a1,s1
     810:	854a                	mv	a0,s2
     812:	54a000ef          	jal	ra,d5c <read>
     816:	04a05163          	blez	a0,858 <execscript+0xb0>
    if(*p == '\n') {
     81a:	0004c783          	lbu	a5,0(s1)
     81e:	fd378de3          	beq	a5,s3,7f8 <execscript+0x50>
      p++;
     822:	0485                	addi	s1,s1,1
      if(p >= &buf[MAXSCRIPT-1]) {
     824:	ff44e4e3          	bltu	s1,s4,80c <execscript+0x64>
        fprintf(2, "script too long\n");
     828:	00001597          	auipc	a1,0x1
     82c:	bc058593          	addi	a1,a1,-1088 # 13e8 <malloc+0x1c0>
     830:	4509                	li	a0,2
     832:	113000ef          	jal	ra,1144 <fprintf>
        exit(1);
     836:	4505                	li	a0,1
     838:	50c000ef          	jal	ra,d44 <exit>
        if(fork1() == 0) {
     83c:	82dff0ef          	jal	ra,68 <fork1>
     840:	c519                	beqz	a0,84e <execscript+0xa6>
        wait(0);
     842:	4501                	li	a0,0
     844:	508000ef          	jal	ra,d4c <wait>
      p = buf;
     848:	bd040493          	addi	s1,s0,-1072
     84c:	b7c1                	j	80c <execscript+0x64>
          runcmd(parsecmd(buf));
     84e:	8526                	mv	a0,s1
     850:	ee9ff0ef          	jal	ra,738 <parsecmd>
     854:	028000ef          	jal	ra,87c <runcmd>
  close(fd);
     858:	854a                	mv	a0,s2
     85a:	512000ef          	jal	ra,d6c <close>
}
     85e:	42813083          	ld	ra,1064(sp)
     862:	42013403          	ld	s0,1056(sp)
     866:	41813483          	ld	s1,1048(sp)
     86a:	41013903          	ld	s2,1040(sp)
     86e:	40813983          	ld	s3,1032(sp)
     872:	40013a03          	ld	s4,1024(sp)
     876:	43010113          	addi	sp,sp,1072
     87a:	8082                	ret

000000000000087c <runcmd>:
{
     87c:	7179                	addi	sp,sp,-48
     87e:	f406                	sd	ra,40(sp)
     880:	f022                	sd	s0,32(sp)
     882:	ec26                	sd	s1,24(sp)
     884:	1800                	addi	s0,sp,48
  if(cmd == 0)
     886:	c10d                	beqz	a0,8a8 <runcmd+0x2c>
     888:	84aa                	mv	s1,a0
  switch(cmd->type){
     88a:	4118                	lw	a4,0(a0)
     88c:	4799                	li	a5,6
     88e:	02e7e063          	bltu	a5,a4,8ae <runcmd+0x32>
     892:	00056783          	lwu	a5,0(a0)
     896:	078a                	slli	a5,a5,0x2
     898:	00001717          	auipc	a4,0x1
     89c:	bc870713          	addi	a4,a4,-1080 # 1460 <malloc+0x238>
     8a0:	97ba                	add	a5,a5,a4
     8a2:	439c                	lw	a5,0(a5)
     8a4:	97ba                	add	a5,a5,a4
     8a6:	8782                	jr	a5
    exit(1);
     8a8:	4505                	li	a0,1
     8aa:	49a000ef          	jal	ra,d44 <exit>
    panic("runcmd");
     8ae:	00001517          	auipc	a0,0x1
     8b2:	b5250513          	addi	a0,a0,-1198 # 1400 <malloc+0x1d8>
     8b6:	f94ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
     8ba:	6508                	ld	a0,8(a0)
     8bc:	cd11                	beqz	a0,8d8 <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
     8be:	00848593          	addi	a1,s1,8
     8c2:	4ba000ef          	jal	ra,d7c <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     8c6:	6490                	ld	a2,8(s1)
     8c8:	00001597          	auipc	a1,0x1
     8cc:	b4058593          	addi	a1,a1,-1216 # 1408 <malloc+0x1e0>
     8d0:	4509                	li	a0,2
     8d2:	073000ef          	jal	ra,1144 <fprintf>
    break;
     8d6:	a0e5                	j	9be <runcmd+0x142>
      exit(1);
     8d8:	4505                	li	a0,1
     8da:	46a000ef          	jal	ra,d44 <exit>
    close(rcmd->fd);
     8de:	5148                	lw	a0,36(a0)
     8e0:	48c000ef          	jal	ra,d6c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     8e4:	508c                	lw	a1,32(s1)
     8e6:	6888                	ld	a0,16(s1)
     8e8:	49c000ef          	jal	ra,d84 <open>
     8ec:	00054563          	bltz	a0,8f6 <runcmd+0x7a>
    runcmd(rcmd->cmd);
     8f0:	6488                	ld	a0,8(s1)
     8f2:	f8bff0ef          	jal	ra,87c <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     8f6:	6890                	ld	a2,16(s1)
     8f8:	00001597          	auipc	a1,0x1
     8fc:	b2058593          	addi	a1,a1,-1248 # 1418 <malloc+0x1f0>
     900:	4509                	li	a0,2
     902:	043000ef          	jal	ra,1144 <fprintf>
      exit(1);
     906:	4505                	li	a0,1
     908:	43c000ef          	jal	ra,d44 <exit>
    if(fork1() == 0)
     90c:	f5cff0ef          	jal	ra,68 <fork1>
     910:	e501                	bnez	a0,918 <runcmd+0x9c>
      runcmd(lcmd->left);
     912:	6488                	ld	a0,8(s1)
     914:	f69ff0ef          	jal	ra,87c <runcmd>
    wait(0);
     918:	4501                	li	a0,0
     91a:	432000ef          	jal	ra,d4c <wait>
    runcmd(lcmd->right);
     91e:	6888                	ld	a0,16(s1)
     920:	f5dff0ef          	jal	ra,87c <runcmd>
    if(pipe(p) < 0)
     924:	fd840513          	addi	a0,s0,-40
     928:	42c000ef          	jal	ra,d54 <pipe>
     92c:	02054763          	bltz	a0,95a <runcmd+0xde>
    if(fork1() == 0){
     930:	f38ff0ef          	jal	ra,68 <fork1>
     934:	e90d                	bnez	a0,966 <runcmd+0xea>
      close(1);
     936:	4505                	li	a0,1
     938:	434000ef          	jal	ra,d6c <close>
      dup(p[1]);
     93c:	fdc42503          	lw	a0,-36(s0)
     940:	47c000ef          	jal	ra,dbc <dup>
      close(p[0]);
     944:	fd842503          	lw	a0,-40(s0)
     948:	424000ef          	jal	ra,d6c <close>
      close(p[1]);
     94c:	fdc42503          	lw	a0,-36(s0)
     950:	41c000ef          	jal	ra,d6c <close>
      runcmd(pcmd->left);
     954:	6488                	ld	a0,8(s1)
     956:	f27ff0ef          	jal	ra,87c <runcmd>
      panic("pipe");
     95a:	00001517          	auipc	a0,0x1
     95e:	ace50513          	addi	a0,a0,-1330 # 1428 <malloc+0x200>
     962:	ee8ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     966:	f02ff0ef          	jal	ra,68 <fork1>
     96a:	e115                	bnez	a0,98e <runcmd+0x112>
      close(0);
     96c:	400000ef          	jal	ra,d6c <close>
      dup(p[0]);
     970:	fd842503          	lw	a0,-40(s0)
     974:	448000ef          	jal	ra,dbc <dup>
      close(p[0]);
     978:	fd842503          	lw	a0,-40(s0)
     97c:	3f0000ef          	jal	ra,d6c <close>
      close(p[1]);
     980:	fdc42503          	lw	a0,-36(s0)
     984:	3e8000ef          	jal	ra,d6c <close>
      runcmd(pcmd->right);
     988:	6888                	ld	a0,16(s1)
     98a:	ef3ff0ef          	jal	ra,87c <runcmd>
    close(p[0]);
     98e:	fd842503          	lw	a0,-40(s0)
     992:	3da000ef          	jal	ra,d6c <close>
    close(p[1]);
     996:	fdc42503          	lw	a0,-36(s0)
     99a:	3d2000ef          	jal	ra,d6c <close>
    wait(0);
     99e:	4501                	li	a0,0
     9a0:	3ac000ef          	jal	ra,d4c <wait>
    wait(0);
     9a4:	4501                	li	a0,0
     9a6:	3a6000ef          	jal	ra,d4c <wait>
    break;
     9aa:	a811                	j	9be <runcmd+0x142>
    if(fork1() == 0)
     9ac:	ebcff0ef          	jal	ra,68 <fork1>
     9b0:	e519                	bnez	a0,9be <runcmd+0x142>
      runcmd(bcmd->cmd);
     9b2:	6488                	ld	a0,8(s1)
     9b4:	ec9ff0ef          	jal	ra,87c <runcmd>
    execscript(scmd->filename);
     9b8:	6508                	ld	a0,8(a0)
     9ba:	defff0ef          	jal	ra,7a8 <execscript>
  exit(0);
     9be:	4501                	li	a0,0
     9c0:	384000ef          	jal	ra,d44 <exit>

00000000000009c4 <main>:
{
     9c4:	715d                	addi	sp,sp,-80
     9c6:	e486                	sd	ra,72(sp)
     9c8:	e0a2                	sd	s0,64(sp)
     9ca:	fc26                	sd	s1,56(sp)
     9cc:	f84a                	sd	s2,48(sp)
     9ce:	f44e                	sd	s3,40(sp)
     9d0:	f052                	sd	s4,32(sp)
     9d2:	ec56                	sd	s5,24(sp)
     9d4:	e85a                	sd	s6,16(sp)
     9d6:	e45e                	sd	s7,8(sp)
     9d8:	0880                	addi	s0,sp,80
  while((fd = open("console", O_RDWR)) >= 0){
     9da:	00001497          	auipc	s1,0x1
     9de:	a5648493          	addi	s1,s1,-1450 # 1430 <malloc+0x208>
     9e2:	4589                	li	a1,2
     9e4:	8526                	mv	a0,s1
     9e6:	39e000ef          	jal	ra,d84 <open>
     9ea:	00054763          	bltz	a0,9f8 <main+0x34>
    if(fd >= 3){
     9ee:	4789                	li	a5,2
     9f0:	fea7d9e3          	bge	a5,a0,9e2 <main+0x1e>
      close(fd);
     9f4:	378000ef          	jal	ra,d6c <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     9f8:	00001497          	auipc	s1,0x1
     9fc:	62848493          	addi	s1,s1,1576 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a00:	06300913          	li	s2,99
    if(buf[0] == '.' && buf[1] == '/') {
     a04:	02e00993          	li	s3,46
     a08:	02f00a13          	li	s4,47
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a0c:	02000a93          	li	s5,32
      if(chdir(buf+3) < 0)
     a10:	00001b17          	auipc	s6,0x1
     a14:	613b0b13          	addi	s6,s6,1555 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     a18:	00001b97          	auipc	s7,0x1
     a1c:	a20b8b93          	addi	s7,s7,-1504 # 1438 <malloc+0x210>
     a20:	a829                	j	a3a <main+0x76>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a22:	0014c703          	lbu	a4,1(s1)
     a26:	06400793          	li	a5,100
     a2a:	04f70f63          	beq	a4,a5,a88 <main+0xc4>
    if(fork1() == 0)
     a2e:	e3aff0ef          	jal	ra,68 <fork1>
     a32:	c941                	beqz	a0,ac2 <main+0xfe>
    wait(0);
     a34:	4501                	li	a0,0
     a36:	316000ef          	jal	ra,d4c <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a3a:	06400593          	li	a1,100
     a3e:	8526                	mv	a0,s1
     a40:	dc0ff0ef          	jal	ra,0 <getcmd>
     a44:	08054763          	bltz	a0,ad2 <main+0x10e>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a48:	0004c783          	lbu	a5,0(s1)
     a4c:	fd278be3          	beq	a5,s2,a22 <main+0x5e>
    if(buf[0] == '.' && buf[1] == '/') {
     a50:	fd379fe3          	bne	a5,s3,a2e <main+0x6a>
     a54:	0014c783          	lbu	a5,1(s1)
     a58:	fd479be3          	bne	a5,s4,a2e <main+0x6a>
      buf[strlen(buf)-1] = 0;
     a5c:	8526                	mv	a0,s1
     a5e:	0d4000ef          	jal	ra,b32 <strlen>
     a62:	fff5079b          	addiw	a5,a0,-1
     a66:	1782                	slli	a5,a5,0x20
     a68:	9381                	srli	a5,a5,0x20
     a6a:	97a6                	add	a5,a5,s1
     a6c:	00078023          	sb	zero,0(a5)
      if(fork1() == 0) {
     a70:	df8ff0ef          	jal	ra,68 <fork1>
     a74:	e139                	bnez	a0,aba <main+0xf6>
        execscript(buf + 2);
     a76:	00001517          	auipc	a0,0x1
     a7a:	5ac50513          	addi	a0,a0,1452 # 2022 <buf.0+0x2>
     a7e:	d2bff0ef          	jal	ra,7a8 <execscript>
        exit(1);
     a82:	4505                	li	a0,1
     a84:	2c0000ef          	jal	ra,d44 <exit>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a88:	0024c783          	lbu	a5,2(s1)
     a8c:	fb5791e3          	bne	a5,s5,a2e <main+0x6a>
      buf[strlen(buf)-1] = 0;
     a90:	8526                	mv	a0,s1
     a92:	0a0000ef          	jal	ra,b32 <strlen>
     a96:	fff5079b          	addiw	a5,a0,-1
     a9a:	1782                	slli	a5,a5,0x20
     a9c:	9381                	srli	a5,a5,0x20
     a9e:	97a6                	add	a5,a5,s1
     aa0:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     aa4:	855a                	mv	a0,s6
     aa6:	30e000ef          	jal	ra,db4 <chdir>
     aaa:	f80558e3          	bgez	a0,a3a <main+0x76>
        fprintf(2, "cannot cd %s\n", buf+3);
     aae:	865a                	mv	a2,s6
     ab0:	85de                	mv	a1,s7
     ab2:	4509                	li	a0,2
     ab4:	690000ef          	jal	ra,1144 <fprintf>
     ab8:	b749                	j	a3a <main+0x76>
      wait(0);
     aba:	4501                	li	a0,0
     abc:	290000ef          	jal	ra,d4c <wait>
      continue;
     ac0:	bfad                	j	a3a <main+0x76>
      runcmd(parsecmd(buf));
     ac2:	00001517          	auipc	a0,0x1
     ac6:	55e50513          	addi	a0,a0,1374 # 2020 <buf.0>
     aca:	c6fff0ef          	jal	ra,738 <parsecmd>
     ace:	dafff0ef          	jal	ra,87c <runcmd>
  exit(0);
     ad2:	4501                	li	a0,0
     ad4:	270000ef          	jal	ra,d44 <exit>

0000000000000ad8 <start>:
//


void
start()
{
     ad8:	1141                	addi	sp,sp,-16
     ada:	e406                	sd	ra,8(sp)
     adc:	e022                	sd	s0,0(sp)
     ade:	0800                	addi	s0,sp,16
  extern int main();
  main();
     ae0:	ee5ff0ef          	jal	ra,9c4 <main>
  exit(0);
     ae4:	4501                	li	a0,0
     ae6:	25e000ef          	jal	ra,d44 <exit>

0000000000000aea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     aea:	1141                	addi	sp,sp,-16
     aec:	e422                	sd	s0,8(sp)
     aee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     af0:	87aa                	mv	a5,a0
     af2:	0585                	addi	a1,a1,1
     af4:	0785                	addi	a5,a5,1
     af6:	fff5c703          	lbu	a4,-1(a1)
     afa:	fee78fa3          	sb	a4,-1(a5)
     afe:	fb75                	bnez	a4,af2 <strcpy+0x8>
    ;
  return os;
}
     b00:	6422                	ld	s0,8(sp)
     b02:	0141                	addi	sp,sp,16
     b04:	8082                	ret

0000000000000b06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b06:	1141                	addi	sp,sp,-16
     b08:	e422                	sd	s0,8(sp)
     b0a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b0c:	00054783          	lbu	a5,0(a0)
     b10:	cb91                	beqz	a5,b24 <strcmp+0x1e>
     b12:	0005c703          	lbu	a4,0(a1)
     b16:	00f71763          	bne	a4,a5,b24 <strcmp+0x1e>
    p++, q++;
     b1a:	0505                	addi	a0,a0,1
     b1c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b1e:	00054783          	lbu	a5,0(a0)
     b22:	fbe5                	bnez	a5,b12 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b24:	0005c503          	lbu	a0,0(a1)
}
     b28:	40a7853b          	subw	a0,a5,a0
     b2c:	6422                	ld	s0,8(sp)
     b2e:	0141                	addi	sp,sp,16
     b30:	8082                	ret

0000000000000b32 <strlen>:

uint
strlen(const char *s)
{
     b32:	1141                	addi	sp,sp,-16
     b34:	e422                	sd	s0,8(sp)
     b36:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b38:	00054783          	lbu	a5,0(a0)
     b3c:	cf91                	beqz	a5,b58 <strlen+0x26>
     b3e:	0505                	addi	a0,a0,1
     b40:	87aa                	mv	a5,a0
     b42:	4685                	li	a3,1
     b44:	9e89                	subw	a3,a3,a0
     b46:	00f6853b          	addw	a0,a3,a5
     b4a:	0785                	addi	a5,a5,1
     b4c:	fff7c703          	lbu	a4,-1(a5)
     b50:	fb7d                	bnez	a4,b46 <strlen+0x14>
    ;
  return n;
}
     b52:	6422                	ld	s0,8(sp)
     b54:	0141                	addi	sp,sp,16
     b56:	8082                	ret
  for(n = 0; s[n]; n++)
     b58:	4501                	li	a0,0
     b5a:	bfe5                	j	b52 <strlen+0x20>

0000000000000b5c <memset>:

void*
memset(void *dst, int c, uint n)
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e422                	sd	s0,8(sp)
     b60:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b62:	ca19                	beqz	a2,b78 <memset+0x1c>
     b64:	87aa                	mv	a5,a0
     b66:	1602                	slli	a2,a2,0x20
     b68:	9201                	srli	a2,a2,0x20
     b6a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     b6e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b72:	0785                	addi	a5,a5,1
     b74:	fee79de3          	bne	a5,a4,b6e <memset+0x12>
  }
  return dst;
}
     b78:	6422                	ld	s0,8(sp)
     b7a:	0141                	addi	sp,sp,16
     b7c:	8082                	ret

0000000000000b7e <strchr>:

char*
strchr(const char *s, char c)
{
     b7e:	1141                	addi	sp,sp,-16
     b80:	e422                	sd	s0,8(sp)
     b82:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b84:	00054783          	lbu	a5,0(a0)
     b88:	cb99                	beqz	a5,b9e <strchr+0x20>
    if(*s == c)
     b8a:	00f58763          	beq	a1,a5,b98 <strchr+0x1a>
  for(; *s; s++)
     b8e:	0505                	addi	a0,a0,1
     b90:	00054783          	lbu	a5,0(a0)
     b94:	fbfd                	bnez	a5,b8a <strchr+0xc>
      return (char*)s;
  return 0;
     b96:	4501                	li	a0,0
}
     b98:	6422                	ld	s0,8(sp)
     b9a:	0141                	addi	sp,sp,16
     b9c:	8082                	ret
  return 0;
     b9e:	4501                	li	a0,0
     ba0:	bfe5                	j	b98 <strchr+0x1a>

0000000000000ba2 <gets>:

char*
gets(char *buf, int max)
{
     ba2:	711d                	addi	sp,sp,-96
     ba4:	ec86                	sd	ra,88(sp)
     ba6:	e8a2                	sd	s0,80(sp)
     ba8:	e4a6                	sd	s1,72(sp)
     baa:	e0ca                	sd	s2,64(sp)
     bac:	fc4e                	sd	s3,56(sp)
     bae:	f852                	sd	s4,48(sp)
     bb0:	f456                	sd	s5,40(sp)
     bb2:	f05a                	sd	s6,32(sp)
     bb4:	ec5e                	sd	s7,24(sp)
     bb6:	1080                	addi	s0,sp,96
     bb8:	8baa                	mv	s7,a0
     bba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bbc:	892a                	mv	s2,a0
     bbe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     bc0:	4aa9                	li	s5,10
     bc2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     bc4:	89a6                	mv	s3,s1
     bc6:	2485                	addiw	s1,s1,1
     bc8:	0344d663          	bge	s1,s4,bf4 <gets+0x52>
    cc = read(0, &c, 1);
     bcc:	4605                	li	a2,1
     bce:	faf40593          	addi	a1,s0,-81
     bd2:	4501                	li	a0,0
     bd4:	188000ef          	jal	ra,d5c <read>
    if(cc < 1)
     bd8:	00a05e63          	blez	a0,bf4 <gets+0x52>
    buf[i++] = c;
     bdc:	faf44783          	lbu	a5,-81(s0)
     be0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     be4:	01578763          	beq	a5,s5,bf2 <gets+0x50>
     be8:	0905                	addi	s2,s2,1
     bea:	fd679de3          	bne	a5,s6,bc4 <gets+0x22>
  for(i=0; i+1 < max; ){
     bee:	89a6                	mv	s3,s1
     bf0:	a011                	j	bf4 <gets+0x52>
     bf2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     bf4:	99de                	add	s3,s3,s7
     bf6:	00098023          	sb	zero,0(s3)
  return buf;
}
     bfa:	855e                	mv	a0,s7
     bfc:	60e6                	ld	ra,88(sp)
     bfe:	6446                	ld	s0,80(sp)
     c00:	64a6                	ld	s1,72(sp)
     c02:	6906                	ld	s2,64(sp)
     c04:	79e2                	ld	s3,56(sp)
     c06:	7a42                	ld	s4,48(sp)
     c08:	7aa2                	ld	s5,40(sp)
     c0a:	7b02                	ld	s6,32(sp)
     c0c:	6be2                	ld	s7,24(sp)
     c0e:	6125                	addi	sp,sp,96
     c10:	8082                	ret

0000000000000c12 <stat>:

int
stat(const char *n, struct stat *st)
{
     c12:	1101                	addi	sp,sp,-32
     c14:	ec06                	sd	ra,24(sp)
     c16:	e822                	sd	s0,16(sp)
     c18:	e426                	sd	s1,8(sp)
     c1a:	e04a                	sd	s2,0(sp)
     c1c:	1000                	addi	s0,sp,32
     c1e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c20:	4581                	li	a1,0
     c22:	162000ef          	jal	ra,d84 <open>
  if(fd < 0)
     c26:	02054163          	bltz	a0,c48 <stat+0x36>
     c2a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c2c:	85ca                	mv	a1,s2
     c2e:	16e000ef          	jal	ra,d9c <fstat>
     c32:	892a                	mv	s2,a0
  close(fd);
     c34:	8526                	mv	a0,s1
     c36:	136000ef          	jal	ra,d6c <close>
  return r;
}
     c3a:	854a                	mv	a0,s2
     c3c:	60e2                	ld	ra,24(sp)
     c3e:	6442                	ld	s0,16(sp)
     c40:	64a2                	ld	s1,8(sp)
     c42:	6902                	ld	s2,0(sp)
     c44:	6105                	addi	sp,sp,32
     c46:	8082                	ret
    return -1;
     c48:	597d                	li	s2,-1
     c4a:	bfc5                	j	c3a <stat+0x28>

0000000000000c4c <atoi>:

int
atoi(const char *s)
{
     c4c:	1141                	addi	sp,sp,-16
     c4e:	e422                	sd	s0,8(sp)
     c50:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c52:	00054603          	lbu	a2,0(a0)
     c56:	fd06079b          	addiw	a5,a2,-48
     c5a:	0ff7f793          	andi	a5,a5,255
     c5e:	4725                	li	a4,9
     c60:	02f76963          	bltu	a4,a5,c92 <atoi+0x46>
     c64:	86aa                	mv	a3,a0
  n = 0;
     c66:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     c68:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     c6a:	0685                	addi	a3,a3,1
     c6c:	0025179b          	slliw	a5,a0,0x2
     c70:	9fa9                	addw	a5,a5,a0
     c72:	0017979b          	slliw	a5,a5,0x1
     c76:	9fb1                	addw	a5,a5,a2
     c78:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c7c:	0006c603          	lbu	a2,0(a3)
     c80:	fd06071b          	addiw	a4,a2,-48
     c84:	0ff77713          	andi	a4,a4,255
     c88:	fee5f1e3          	bgeu	a1,a4,c6a <atoi+0x1e>
  return n;
}
     c8c:	6422                	ld	s0,8(sp)
     c8e:	0141                	addi	sp,sp,16
     c90:	8082                	ret
  n = 0;
     c92:	4501                	li	a0,0
     c94:	bfe5                	j	c8c <atoi+0x40>

0000000000000c96 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c96:	1141                	addi	sp,sp,-16
     c98:	e422                	sd	s0,8(sp)
     c9a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     c9c:	02b57463          	bgeu	a0,a1,cc4 <memmove+0x2e>
    while(n-- > 0)
     ca0:	00c05f63          	blez	a2,cbe <memmove+0x28>
     ca4:	1602                	slli	a2,a2,0x20
     ca6:	9201                	srli	a2,a2,0x20
     ca8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     cac:	872a                	mv	a4,a0
      *dst++ = *src++;
     cae:	0585                	addi	a1,a1,1
     cb0:	0705                	addi	a4,a4,1
     cb2:	fff5c683          	lbu	a3,-1(a1)
     cb6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     cba:	fee79ae3          	bne	a5,a4,cae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     cbe:	6422                	ld	s0,8(sp)
     cc0:	0141                	addi	sp,sp,16
     cc2:	8082                	ret
    dst += n;
     cc4:	00c50733          	add	a4,a0,a2
    src += n;
     cc8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     cca:	fec05ae3          	blez	a2,cbe <memmove+0x28>
     cce:	fff6079b          	addiw	a5,a2,-1
     cd2:	1782                	slli	a5,a5,0x20
     cd4:	9381                	srli	a5,a5,0x20
     cd6:	fff7c793          	not	a5,a5
     cda:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     cdc:	15fd                	addi	a1,a1,-1
     cde:	177d                	addi	a4,a4,-1
     ce0:	0005c683          	lbu	a3,0(a1)
     ce4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ce8:	fee79ae3          	bne	a5,a4,cdc <memmove+0x46>
     cec:	bfc9                	j	cbe <memmove+0x28>

0000000000000cee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     cee:	1141                	addi	sp,sp,-16
     cf0:	e422                	sd	s0,8(sp)
     cf2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     cf4:	ca05                	beqz	a2,d24 <memcmp+0x36>
     cf6:	fff6069b          	addiw	a3,a2,-1
     cfa:	1682                	slli	a3,a3,0x20
     cfc:	9281                	srli	a3,a3,0x20
     cfe:	0685                	addi	a3,a3,1
     d00:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d02:	00054783          	lbu	a5,0(a0)
     d06:	0005c703          	lbu	a4,0(a1)
     d0a:	00e79863          	bne	a5,a4,d1a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d0e:	0505                	addi	a0,a0,1
    p2++;
     d10:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d12:	fed518e3          	bne	a0,a3,d02 <memcmp+0x14>
  }
  return 0;
     d16:	4501                	li	a0,0
     d18:	a019                	j	d1e <memcmp+0x30>
      return *p1 - *p2;
     d1a:	40e7853b          	subw	a0,a5,a4
}
     d1e:	6422                	ld	s0,8(sp)
     d20:	0141                	addi	sp,sp,16
     d22:	8082                	ret
  return 0;
     d24:	4501                	li	a0,0
     d26:	bfe5                	j	d1e <memcmp+0x30>

0000000000000d28 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d28:	1141                	addi	sp,sp,-16
     d2a:	e406                	sd	ra,8(sp)
     d2c:	e022                	sd	s0,0(sp)
     d2e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     d30:	f67ff0ef          	jal	ra,c96 <memmove>
}
     d34:	60a2                	ld	ra,8(sp)
     d36:	6402                	ld	s0,0(sp)
     d38:	0141                	addi	sp,sp,16
     d3a:	8082                	ret

0000000000000d3c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d3c:	4885                	li	a7,1
 ecall
     d3e:	00000073          	ecall
 ret
     d42:	8082                	ret

0000000000000d44 <exit>:
.global exit
exit:
 li a7, SYS_exit
     d44:	4889                	li	a7,2
 ecall
     d46:	00000073          	ecall
 ret
     d4a:	8082                	ret

0000000000000d4c <wait>:
.global wait
wait:
 li a7, SYS_wait
     d4c:	488d                	li	a7,3
 ecall
     d4e:	00000073          	ecall
 ret
     d52:	8082                	ret

0000000000000d54 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d54:	4891                	li	a7,4
 ecall
     d56:	00000073          	ecall
 ret
     d5a:	8082                	ret

0000000000000d5c <read>:
.global read
read:
 li a7, SYS_read
     d5c:	4895                	li	a7,5
 ecall
     d5e:	00000073          	ecall
 ret
     d62:	8082                	ret

0000000000000d64 <write>:
.global write
write:
 li a7, SYS_write
     d64:	48c1                	li	a7,16
 ecall
     d66:	00000073          	ecall
 ret
     d6a:	8082                	ret

0000000000000d6c <close>:
.global close
close:
 li a7, SYS_close
     d6c:	48d5                	li	a7,21
 ecall
     d6e:	00000073          	ecall
 ret
     d72:	8082                	ret

0000000000000d74 <kill>:
.global kill
kill:
 li a7, SYS_kill
     d74:	4899                	li	a7,6
 ecall
     d76:	00000073          	ecall
 ret
     d7a:	8082                	ret

0000000000000d7c <exec>:
.global exec
exec:
 li a7, SYS_exec
     d7c:	489d                	li	a7,7
 ecall
     d7e:	00000073          	ecall
 ret
     d82:	8082                	ret

0000000000000d84 <open>:
.global open
open:
 li a7, SYS_open
     d84:	48bd                	li	a7,15
 ecall
     d86:	00000073          	ecall
 ret
     d8a:	8082                	ret

0000000000000d8c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d8c:	48c5                	li	a7,17
 ecall
     d8e:	00000073          	ecall
 ret
     d92:	8082                	ret

0000000000000d94 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d94:	48c9                	li	a7,18
 ecall
     d96:	00000073          	ecall
 ret
     d9a:	8082                	ret

0000000000000d9c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d9c:	48a1                	li	a7,8
 ecall
     d9e:	00000073          	ecall
 ret
     da2:	8082                	ret

0000000000000da4 <link>:
.global link
link:
 li a7, SYS_link
     da4:	48cd                	li	a7,19
 ecall
     da6:	00000073          	ecall
 ret
     daa:	8082                	ret

0000000000000dac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     dac:	48d1                	li	a7,20
 ecall
     dae:	00000073          	ecall
 ret
     db2:	8082                	ret

0000000000000db4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     db4:	48a5                	li	a7,9
 ecall
     db6:	00000073          	ecall
 ret
     dba:	8082                	ret

0000000000000dbc <dup>:
.global dup
dup:
 li a7, SYS_dup
     dbc:	48a9                	li	a7,10
 ecall
     dbe:	00000073          	ecall
 ret
     dc2:	8082                	ret

0000000000000dc4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     dc4:	48ad                	li	a7,11
 ecall
     dc6:	00000073          	ecall
 ret
     dca:	8082                	ret

0000000000000dcc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     dcc:	48b1                	li	a7,12
 ecall
     dce:	00000073          	ecall
 ret
     dd2:	8082                	ret

0000000000000dd4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dd4:	48b5                	li	a7,13
 ecall
     dd6:	00000073          	ecall
 ret
     dda:	8082                	ret

0000000000000ddc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ddc:	48b9                	li	a7,14
 ecall
     dde:	00000073          	ecall
 ret
     de2:	8082                	ret

0000000000000de4 <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
     de4:	48d9                	li	a7,22
 ecall
     de6:	00000073          	ecall
 ret
     dea:	8082                	ret

0000000000000dec <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
     dec:	48dd                	li	a7,23
 ecall
     dee:	00000073          	ecall
 ret
     df2:	8082                	ret

0000000000000df4 <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
     df4:	48e1                	li	a7,24
 ecall
     df6:	00000073          	ecall
 ret
     dfa:	8082                	ret

0000000000000dfc <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
     dfc:	48e5                	li	a7,25
 ecall
     dfe:	00000073          	ecall
 ret
     e02:	8082                	ret

0000000000000e04 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e04:	1101                	addi	sp,sp,-32
     e06:	ec06                	sd	ra,24(sp)
     e08:	e822                	sd	s0,16(sp)
     e0a:	1000                	addi	s0,sp,32
     e0c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e10:	4605                	li	a2,1
     e12:	fef40593          	addi	a1,s0,-17
     e16:	f4fff0ef          	jal	ra,d64 <write>
}
     e1a:	60e2                	ld	ra,24(sp)
     e1c:	6442                	ld	s0,16(sp)
     e1e:	6105                	addi	sp,sp,32
     e20:	8082                	ret

0000000000000e22 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e22:	7139                	addi	sp,sp,-64
     e24:	fc06                	sd	ra,56(sp)
     e26:	f822                	sd	s0,48(sp)
     e28:	f426                	sd	s1,40(sp)
     e2a:	f04a                	sd	s2,32(sp)
     e2c:	ec4e                	sd	s3,24(sp)
     e2e:	0080                	addi	s0,sp,64
     e30:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e32:	c299                	beqz	a3,e38 <printint+0x16>
     e34:	0805c663          	bltz	a1,ec0 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e38:	2581                	sext.w	a1,a1
  neg = 0;
     e3a:	4881                	li	a7,0
     e3c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e40:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e42:	2601                	sext.w	a2,a2
     e44:	00000517          	auipc	a0,0x0
     e48:	64450513          	addi	a0,a0,1604 # 1488 <digits>
     e4c:	883a                	mv	a6,a4
     e4e:	2705                	addiw	a4,a4,1
     e50:	02c5f7bb          	remuw	a5,a1,a2
     e54:	1782                	slli	a5,a5,0x20
     e56:	9381                	srli	a5,a5,0x20
     e58:	97aa                	add	a5,a5,a0
     e5a:	0007c783          	lbu	a5,0(a5)
     e5e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e62:	0005879b          	sext.w	a5,a1
     e66:	02c5d5bb          	divuw	a1,a1,a2
     e6a:	0685                	addi	a3,a3,1
     e6c:	fec7f0e3          	bgeu	a5,a2,e4c <printint+0x2a>
  if(neg)
     e70:	00088b63          	beqz	a7,e86 <printint+0x64>
    buf[i++] = '-';
     e74:	fd040793          	addi	a5,s0,-48
     e78:	973e                	add	a4,a4,a5
     e7a:	02d00793          	li	a5,45
     e7e:	fef70823          	sb	a5,-16(a4)
     e82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e86:	02e05663          	blez	a4,eb2 <printint+0x90>
     e8a:	fc040793          	addi	a5,s0,-64
     e8e:	00e78933          	add	s2,a5,a4
     e92:	fff78993          	addi	s3,a5,-1
     e96:	99ba                	add	s3,s3,a4
     e98:	377d                	addiw	a4,a4,-1
     e9a:	1702                	slli	a4,a4,0x20
     e9c:	9301                	srli	a4,a4,0x20
     e9e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ea2:	fff94583          	lbu	a1,-1(s2)
     ea6:	8526                	mv	a0,s1
     ea8:	f5dff0ef          	jal	ra,e04 <putc>
  while(--i >= 0)
     eac:	197d                	addi	s2,s2,-1
     eae:	ff391ae3          	bne	s2,s3,ea2 <printint+0x80>
}
     eb2:	70e2                	ld	ra,56(sp)
     eb4:	7442                	ld	s0,48(sp)
     eb6:	74a2                	ld	s1,40(sp)
     eb8:	7902                	ld	s2,32(sp)
     eba:	69e2                	ld	s3,24(sp)
     ebc:	6121                	addi	sp,sp,64
     ebe:	8082                	ret
    x = -xx;
     ec0:	40b005bb          	negw	a1,a1
    neg = 1;
     ec4:	4885                	li	a7,1
    x = -xx;
     ec6:	bf9d                	j	e3c <printint+0x1a>

0000000000000ec8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ec8:	7119                	addi	sp,sp,-128
     eca:	fc86                	sd	ra,120(sp)
     ecc:	f8a2                	sd	s0,112(sp)
     ece:	f4a6                	sd	s1,104(sp)
     ed0:	f0ca                	sd	s2,96(sp)
     ed2:	ecce                	sd	s3,88(sp)
     ed4:	e8d2                	sd	s4,80(sp)
     ed6:	e4d6                	sd	s5,72(sp)
     ed8:	e0da                	sd	s6,64(sp)
     eda:	fc5e                	sd	s7,56(sp)
     edc:	f862                	sd	s8,48(sp)
     ede:	f466                	sd	s9,40(sp)
     ee0:	f06a                	sd	s10,32(sp)
     ee2:	ec6e                	sd	s11,24(sp)
     ee4:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ee6:	0005c903          	lbu	s2,0(a1)
     eea:	22090e63          	beqz	s2,1126 <vprintf+0x25e>
     eee:	8b2a                	mv	s6,a0
     ef0:	8a2e                	mv	s4,a1
     ef2:	8bb2                	mv	s7,a2
  state = 0;
     ef4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     ef6:	4481                	li	s1,0
     ef8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     efa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     efe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f02:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     f06:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f0a:	00000c97          	auipc	s9,0x0
     f0e:	57ec8c93          	addi	s9,s9,1406 # 1488 <digits>
     f12:	a005                	j	f32 <vprintf+0x6a>
        putc(fd, c0);
     f14:	85ca                	mv	a1,s2
     f16:	855a                	mv	a0,s6
     f18:	eedff0ef          	jal	ra,e04 <putc>
     f1c:	a019                	j	f22 <vprintf+0x5a>
    } else if(state == '%'){
     f1e:	03598263          	beq	s3,s5,f42 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     f22:	2485                	addiw	s1,s1,1
     f24:	8726                	mv	a4,s1
     f26:	009a07b3          	add	a5,s4,s1
     f2a:	0007c903          	lbu	s2,0(a5)
     f2e:	1e090c63          	beqz	s2,1126 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
     f32:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f36:	fe0994e3          	bnez	s3,f1e <vprintf+0x56>
      if(c0 == '%'){
     f3a:	fd579de3          	bne	a5,s5,f14 <vprintf+0x4c>
        state = '%';
     f3e:	89be                	mv	s3,a5
     f40:	b7cd                	j	f22 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     f42:	cfa5                	beqz	a5,fba <vprintf+0xf2>
     f44:	00ea06b3          	add	a3,s4,a4
     f48:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     f4c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     f4e:	c681                	beqz	a3,f56 <vprintf+0x8e>
     f50:	9752                	add	a4,a4,s4
     f52:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     f56:	03878a63          	beq	a5,s8,f8a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     f5a:	05a78463          	beq	a5,s10,fa2 <vprintf+0xda>
      } else if(c0 == 'u'){
     f5e:	0db78763          	beq	a5,s11,102c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     f62:	07800713          	li	a4,120
     f66:	10e78963          	beq	a5,a4,1078 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     f6a:	07000713          	li	a4,112
     f6e:	12e78e63          	beq	a5,a4,10aa <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     f72:	07300713          	li	a4,115
     f76:	16e78b63          	beq	a5,a4,10ec <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     f7a:	05579063          	bne	a5,s5,fba <vprintf+0xf2>
        putc(fd, '%');
     f7e:	85d6                	mv	a1,s5
     f80:	855a                	mv	a0,s6
     f82:	e83ff0ef          	jal	ra,e04 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     f86:	4981                	li	s3,0
     f88:	bf69                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     f8a:	008b8913          	addi	s2,s7,8
     f8e:	4685                	li	a3,1
     f90:	4629                	li	a2,10
     f92:	000ba583          	lw	a1,0(s7)
     f96:	855a                	mv	a0,s6
     f98:	e8bff0ef          	jal	ra,e22 <printint>
     f9c:	8bca                	mv	s7,s2
      state = 0;
     f9e:	4981                	li	s3,0
     fa0:	b749                	j	f22 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     fa2:	03868663          	beq	a3,s8,fce <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fa6:	05a68163          	beq	a3,s10,fe8 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
     faa:	09b68d63          	beq	a3,s11,1044 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fae:	03a68f63          	beq	a3,s10,fec <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
     fb2:	07800793          	li	a5,120
     fb6:	0cf68d63          	beq	a3,a5,1090 <vprintf+0x1c8>
        putc(fd, '%');
     fba:	85d6                	mv	a1,s5
     fbc:	855a                	mv	a0,s6
     fbe:	e47ff0ef          	jal	ra,e04 <putc>
        putc(fd, c0);
     fc2:	85ca                	mv	a1,s2
     fc4:	855a                	mv	a0,s6
     fc6:	e3fff0ef          	jal	ra,e04 <putc>
      state = 0;
     fca:	4981                	li	s3,0
     fcc:	bf99                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     fce:	008b8913          	addi	s2,s7,8
     fd2:	4685                	li	a3,1
     fd4:	4629                	li	a2,10
     fd6:	000ba583          	lw	a1,0(s7)
     fda:	855a                	mv	a0,s6
     fdc:	e47ff0ef          	jal	ra,e22 <printint>
        i += 1;
     fe0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     fe2:	8bca                	mv	s7,s2
      state = 0;
     fe4:	4981                	li	s3,0
        i += 1;
     fe6:	bf35                	j	f22 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fe8:	03860563          	beq	a2,s8,1012 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fec:	07b60963          	beq	a2,s11,105e <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ff0:	07800793          	li	a5,120
     ff4:	fcf613e3          	bne	a2,a5,fba <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ff8:	008b8913          	addi	s2,s7,8
     ffc:	4681                	li	a3,0
     ffe:	4641                	li	a2,16
    1000:	000ba583          	lw	a1,0(s7)
    1004:	855a                	mv	a0,s6
    1006:	e1dff0ef          	jal	ra,e22 <printint>
        i += 2;
    100a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    100c:	8bca                	mv	s7,s2
      state = 0;
    100e:	4981                	li	s3,0
        i += 2;
    1010:	bf09                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1012:	008b8913          	addi	s2,s7,8
    1016:	4685                	li	a3,1
    1018:	4629                	li	a2,10
    101a:	000ba583          	lw	a1,0(s7)
    101e:	855a                	mv	a0,s6
    1020:	e03ff0ef          	jal	ra,e22 <printint>
        i += 2;
    1024:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1026:	8bca                	mv	s7,s2
      state = 0;
    1028:	4981                	li	s3,0
        i += 2;
    102a:	bde5                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
    102c:	008b8913          	addi	s2,s7,8
    1030:	4681                	li	a3,0
    1032:	4629                	li	a2,10
    1034:	000ba583          	lw	a1,0(s7)
    1038:	855a                	mv	a0,s6
    103a:	de9ff0ef          	jal	ra,e22 <printint>
    103e:	8bca                	mv	s7,s2
      state = 0;
    1040:	4981                	li	s3,0
    1042:	b5c5                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1044:	008b8913          	addi	s2,s7,8
    1048:	4681                	li	a3,0
    104a:	4629                	li	a2,10
    104c:	000ba583          	lw	a1,0(s7)
    1050:	855a                	mv	a0,s6
    1052:	dd1ff0ef          	jal	ra,e22 <printint>
        i += 1;
    1056:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1058:	8bca                	mv	s7,s2
      state = 0;
    105a:	4981                	li	s3,0
        i += 1;
    105c:	b5d9                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    105e:	008b8913          	addi	s2,s7,8
    1062:	4681                	li	a3,0
    1064:	4629                	li	a2,10
    1066:	000ba583          	lw	a1,0(s7)
    106a:	855a                	mv	a0,s6
    106c:	db7ff0ef          	jal	ra,e22 <printint>
        i += 2;
    1070:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1072:	8bca                	mv	s7,s2
      state = 0;
    1074:	4981                	li	s3,0
        i += 2;
    1076:	b575                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
    1078:	008b8913          	addi	s2,s7,8
    107c:	4681                	li	a3,0
    107e:	4641                	li	a2,16
    1080:	000ba583          	lw	a1,0(s7)
    1084:	855a                	mv	a0,s6
    1086:	d9dff0ef          	jal	ra,e22 <printint>
    108a:	8bca                	mv	s7,s2
      state = 0;
    108c:	4981                	li	s3,0
    108e:	bd51                	j	f22 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1090:	008b8913          	addi	s2,s7,8
    1094:	4681                	li	a3,0
    1096:	4641                	li	a2,16
    1098:	000ba583          	lw	a1,0(s7)
    109c:	855a                	mv	a0,s6
    109e:	d85ff0ef          	jal	ra,e22 <printint>
        i += 1;
    10a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    10a4:	8bca                	mv	s7,s2
      state = 0;
    10a6:	4981                	li	s3,0
        i += 1;
    10a8:	bdad                	j	f22 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
    10aa:	008b8793          	addi	a5,s7,8
    10ae:	f8f43423          	sd	a5,-120(s0)
    10b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10b6:	03000593          	li	a1,48
    10ba:	855a                	mv	a0,s6
    10bc:	d49ff0ef          	jal	ra,e04 <putc>
  putc(fd, 'x');
    10c0:	07800593          	li	a1,120
    10c4:	855a                	mv	a0,s6
    10c6:	d3fff0ef          	jal	ra,e04 <putc>
    10ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10cc:	03c9d793          	srli	a5,s3,0x3c
    10d0:	97e6                	add	a5,a5,s9
    10d2:	0007c583          	lbu	a1,0(a5)
    10d6:	855a                	mv	a0,s6
    10d8:	d2dff0ef          	jal	ra,e04 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10dc:	0992                	slli	s3,s3,0x4
    10de:	397d                	addiw	s2,s2,-1
    10e0:	fe0916e3          	bnez	s2,10cc <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
    10e4:	f8843b83          	ld	s7,-120(s0)
      state = 0;
    10e8:	4981                	li	s3,0
    10ea:	bd25                	j	f22 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
    10ec:	008b8993          	addi	s3,s7,8
    10f0:	000bb903          	ld	s2,0(s7)
    10f4:	00090f63          	beqz	s2,1112 <vprintf+0x24a>
        for(; *s; s++)
    10f8:	00094583          	lbu	a1,0(s2)
    10fc:	c195                	beqz	a1,1120 <vprintf+0x258>
          putc(fd, *s);
    10fe:	855a                	mv	a0,s6
    1100:	d05ff0ef          	jal	ra,e04 <putc>
        for(; *s; s++)
    1104:	0905                	addi	s2,s2,1
    1106:	00094583          	lbu	a1,0(s2)
    110a:	f9f5                	bnez	a1,10fe <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    110c:	8bce                	mv	s7,s3
      state = 0;
    110e:	4981                	li	s3,0
    1110:	bd09                	j	f22 <vprintf+0x5a>
          s = "(null)";
    1112:	00000917          	auipc	s2,0x0
    1116:	36e90913          	addi	s2,s2,878 # 1480 <malloc+0x258>
        for(; *s; s++)
    111a:	02800593          	li	a1,40
    111e:	b7c5                	j	10fe <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    1120:	8bce                	mv	s7,s3
      state = 0;
    1122:	4981                	li	s3,0
    1124:	bbfd                	j	f22 <vprintf+0x5a>
    }
  }
}
    1126:	70e6                	ld	ra,120(sp)
    1128:	7446                	ld	s0,112(sp)
    112a:	74a6                	ld	s1,104(sp)
    112c:	7906                	ld	s2,96(sp)
    112e:	69e6                	ld	s3,88(sp)
    1130:	6a46                	ld	s4,80(sp)
    1132:	6aa6                	ld	s5,72(sp)
    1134:	6b06                	ld	s6,64(sp)
    1136:	7be2                	ld	s7,56(sp)
    1138:	7c42                	ld	s8,48(sp)
    113a:	7ca2                	ld	s9,40(sp)
    113c:	7d02                	ld	s10,32(sp)
    113e:	6de2                	ld	s11,24(sp)
    1140:	6109                	addi	sp,sp,128
    1142:	8082                	ret

0000000000001144 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1144:	715d                	addi	sp,sp,-80
    1146:	ec06                	sd	ra,24(sp)
    1148:	e822                	sd	s0,16(sp)
    114a:	1000                	addi	s0,sp,32
    114c:	e010                	sd	a2,0(s0)
    114e:	e414                	sd	a3,8(s0)
    1150:	e818                	sd	a4,16(s0)
    1152:	ec1c                	sd	a5,24(s0)
    1154:	03043023          	sd	a6,32(s0)
    1158:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    115c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1160:	8622                	mv	a2,s0
    1162:	d67ff0ef          	jal	ra,ec8 <vprintf>
}
    1166:	60e2                	ld	ra,24(sp)
    1168:	6442                	ld	s0,16(sp)
    116a:	6161                	addi	sp,sp,80
    116c:	8082                	ret

000000000000116e <printf>:

void
printf(const char *fmt, ...)
{
    116e:	711d                	addi	sp,sp,-96
    1170:	ec06                	sd	ra,24(sp)
    1172:	e822                	sd	s0,16(sp)
    1174:	1000                	addi	s0,sp,32
    1176:	e40c                	sd	a1,8(s0)
    1178:	e810                	sd	a2,16(s0)
    117a:	ec14                	sd	a3,24(s0)
    117c:	f018                	sd	a4,32(s0)
    117e:	f41c                	sd	a5,40(s0)
    1180:	03043823          	sd	a6,48(s0)
    1184:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1188:	00840613          	addi	a2,s0,8
    118c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1190:	85aa                	mv	a1,a0
    1192:	4505                	li	a0,1
    1194:	d35ff0ef          	jal	ra,ec8 <vprintf>
}
    1198:	60e2                	ld	ra,24(sp)
    119a:	6442                	ld	s0,16(sp)
    119c:	6125                	addi	sp,sp,96
    119e:	8082                	ret

00000000000011a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11a0:	1141                	addi	sp,sp,-16
    11a2:	e422                	sd	s0,8(sp)
    11a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11aa:	00001797          	auipc	a5,0x1
    11ae:	e667b783          	ld	a5,-410(a5) # 2010 <freep>
    11b2:	a805                	j	11e2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11b4:	4618                	lw	a4,8(a2)
    11b6:	9db9                	addw	a1,a1,a4
    11b8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11bc:	6398                	ld	a4,0(a5)
    11be:	6318                	ld	a4,0(a4)
    11c0:	fee53823          	sd	a4,-16(a0)
    11c4:	a091                	j	1208 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11c6:	ff852703          	lw	a4,-8(a0)
    11ca:	9e39                	addw	a2,a2,a4
    11cc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    11ce:	ff053703          	ld	a4,-16(a0)
    11d2:	e398                	sd	a4,0(a5)
    11d4:	a099                	j	121a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d6:	6398                	ld	a4,0(a5)
    11d8:	00e7e463          	bltu	a5,a4,11e0 <free+0x40>
    11dc:	00e6ea63          	bltu	a3,a4,11f0 <free+0x50>
{
    11e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e2:	fed7fae3          	bgeu	a5,a3,11d6 <free+0x36>
    11e6:	6398                	ld	a4,0(a5)
    11e8:	00e6e463          	bltu	a3,a4,11f0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ec:	fee7eae3          	bltu	a5,a4,11e0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    11f0:	ff852583          	lw	a1,-8(a0)
    11f4:	6390                	ld	a2,0(a5)
    11f6:	02059713          	slli	a4,a1,0x20
    11fa:	9301                	srli	a4,a4,0x20
    11fc:	0712                	slli	a4,a4,0x4
    11fe:	9736                	add	a4,a4,a3
    1200:	fae60ae3          	beq	a2,a4,11b4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1204:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1208:	4790                	lw	a2,8(a5)
    120a:	02061713          	slli	a4,a2,0x20
    120e:	9301                	srli	a4,a4,0x20
    1210:	0712                	slli	a4,a4,0x4
    1212:	973e                	add	a4,a4,a5
    1214:	fae689e3          	beq	a3,a4,11c6 <free+0x26>
  } else
    p->s.ptr = bp;
    1218:	e394                	sd	a3,0(a5)
  freep = p;
    121a:	00001717          	auipc	a4,0x1
    121e:	def73b23          	sd	a5,-522(a4) # 2010 <freep>
}
    1222:	6422                	ld	s0,8(sp)
    1224:	0141                	addi	sp,sp,16
    1226:	8082                	ret

0000000000001228 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1228:	7139                	addi	sp,sp,-64
    122a:	fc06                	sd	ra,56(sp)
    122c:	f822                	sd	s0,48(sp)
    122e:	f426                	sd	s1,40(sp)
    1230:	f04a                	sd	s2,32(sp)
    1232:	ec4e                	sd	s3,24(sp)
    1234:	e852                	sd	s4,16(sp)
    1236:	e456                	sd	s5,8(sp)
    1238:	e05a                	sd	s6,0(sp)
    123a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    123c:	02051493          	slli	s1,a0,0x20
    1240:	9081                	srli	s1,s1,0x20
    1242:	04bd                	addi	s1,s1,15
    1244:	8091                	srli	s1,s1,0x4
    1246:	0014899b          	addiw	s3,s1,1
    124a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    124c:	00001517          	auipc	a0,0x1
    1250:	dc453503          	ld	a0,-572(a0) # 2010 <freep>
    1254:	c515                	beqz	a0,1280 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1256:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1258:	4798                	lw	a4,8(a5)
    125a:	02977f63          	bgeu	a4,s1,1298 <malloc+0x70>
    125e:	8a4e                	mv	s4,s3
    1260:	0009871b          	sext.w	a4,s3
    1264:	6685                	lui	a3,0x1
    1266:	00d77363          	bgeu	a4,a3,126c <malloc+0x44>
    126a:	6a05                	lui	s4,0x1
    126c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1270:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1274:	00001917          	auipc	s2,0x1
    1278:	d9c90913          	addi	s2,s2,-612 # 2010 <freep>
  if(p == (char*)-1)
    127c:	5afd                	li	s5,-1
    127e:	a0bd                	j	12ec <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    1280:	00001797          	auipc	a5,0x1
    1284:	e0878793          	addi	a5,a5,-504 # 2088 <base>
    1288:	00001717          	auipc	a4,0x1
    128c:	d8f73423          	sd	a5,-632(a4) # 2010 <freep>
    1290:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1292:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1296:	b7e1                	j	125e <malloc+0x36>
      if(p->s.size == nunits)
    1298:	02e48b63          	beq	s1,a4,12ce <malloc+0xa6>
        p->s.size -= nunits;
    129c:	4137073b          	subw	a4,a4,s3
    12a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12a2:	1702                	slli	a4,a4,0x20
    12a4:	9301                	srli	a4,a4,0x20
    12a6:	0712                	slli	a4,a4,0x4
    12a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ae:	00001717          	auipc	a4,0x1
    12b2:	d6a73123          	sd	a0,-670(a4) # 2010 <freep>
      return (void*)(p + 1);
    12b6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12ba:	70e2                	ld	ra,56(sp)
    12bc:	7442                	ld	s0,48(sp)
    12be:	74a2                	ld	s1,40(sp)
    12c0:	7902                	ld	s2,32(sp)
    12c2:	69e2                	ld	s3,24(sp)
    12c4:	6a42                	ld	s4,16(sp)
    12c6:	6aa2                	ld	s5,8(sp)
    12c8:	6b02                	ld	s6,0(sp)
    12ca:	6121                	addi	sp,sp,64
    12cc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12ce:	6398                	ld	a4,0(a5)
    12d0:	e118                	sd	a4,0(a0)
    12d2:	bff1                	j	12ae <malloc+0x86>
  hp->s.size = nu;
    12d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12d8:	0541                	addi	a0,a0,16
    12da:	ec7ff0ef          	jal	ra,11a0 <free>
  return freep;
    12de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12e2:	dd61                	beqz	a0,12ba <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12e6:	4798                	lw	a4,8(a5)
    12e8:	fa9778e3          	bgeu	a4,s1,1298 <malloc+0x70>
    if(p == freep)
    12ec:	00093703          	ld	a4,0(s2)
    12f0:	853e                	mv	a0,a5
    12f2:	fef719e3          	bne	a4,a5,12e4 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    12f6:	8552                	mv	a0,s4
    12f8:	ad5ff0ef          	jal	ra,dcc <sbrk>
  if(p == (char*)-1)
    12fc:	fd551ce3          	bne	a0,s5,12d4 <malloc+0xac>
        return 0;
    1300:	4501                	li	a0,0
    1302:	bf65                	j	12ba <malloc+0x92>
