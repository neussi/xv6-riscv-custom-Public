
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	93010113          	addi	sp,sp,-1744 # 80007930 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7f17>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d9078793          	addi	a5,a5,-624 # 80000e10 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05263          	blez	a2,80000126 <consolewrite+0x56>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	0a4020ef          	jal	ra,8000219e <either_copyin>
    800000fe:	01550a63          	beq	a0,s5,80000112 <consolewrite+0x42>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7da000ef          	jal	ra,800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
  }

  return i;
}
    80000112:	854a                	mv	a0,s2
    80000114:	60a6                	ld	ra,72(sp)
    80000116:	6406                	ld	s0,64(sp)
    80000118:	74e2                	ld	s1,56(sp)
    8000011a:	7942                	ld	s2,48(sp)
    8000011c:	79a2                	ld	s3,40(sp)
    8000011e:	7a02                	ld	s4,32(sp)
    80000120:	6ae2                	ld	s5,24(sp)
    80000122:	6161                	addi	sp,sp,80
    80000124:	8082                	ret
  for(i = 0; i < n; i++){
    80000126:	4901                	li	s2,0
    80000128:	b7ed                	j	80000112 <consolewrite+0x42>

000000008000012a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012a:	7159                	addi	sp,sp,-112
    8000012c:	f486                	sd	ra,104(sp)
    8000012e:	f0a2                	sd	s0,96(sp)
    80000130:	eca6                	sd	s1,88(sp)
    80000132:	e8ca                	sd	s2,80(sp)
    80000134:	e4ce                	sd	s3,72(sp)
    80000136:	e0d2                	sd	s4,64(sp)
    80000138:	fc56                	sd	s5,56(sp)
    8000013a:	f85a                	sd	s6,48(sp)
    8000013c:	f45e                	sd	s7,40(sp)
    8000013e:	f062                	sd	s8,32(sp)
    80000140:	ec66                	sd	s9,24(sp)
    80000142:	e86a                	sd	s10,16(sp)
    80000144:	1880                	addi	s0,sp,112
    80000146:	8aaa                	mv	s5,a0
    80000148:	8a2e                	mv	s4,a1
    8000014a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000014c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000150:	0000f517          	auipc	a0,0xf
    80000154:	7e050513          	addi	a0,a0,2016 # 8000f930 <cons>
    80000158:	243000ef          	jal	ra,80000b9a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000015c:	0000f497          	auipc	s1,0xf
    80000160:	7d448493          	addi	s1,s1,2004 # 8000f930 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000164:	00010917          	auipc	s2,0x10
    80000168:	86490913          	addi	s2,s2,-1948 # 8000f9c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000016c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000016e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000170:	4ca9                	li	s9,10
  while(n > 0){
    80000172:	07305363          	blez	s3,800001d8 <consoleread+0xae>
    while(cons.r == cons.w){
    80000176:	0984a783          	lw	a5,152(s1)
    8000017a:	09c4a703          	lw	a4,156(s1)
    8000017e:	02f71163          	bne	a4,a5,800001a0 <consoleread+0x76>
      if(killed(myproc())){
    80000182:	6aa010ef          	jal	ra,8000182c <myproc>
    80000186:	6ab010ef          	jal	ra,80002030 <killed>
    8000018a:	e125                	bnez	a0,800001ea <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000018c:	85a6                	mv	a1,s1
    8000018e:	854a                	mv	a0,s2
    80000190:	469010ef          	jal	ra,80001df8 <sleep>
    while(cons.r == cons.w){
    80000194:	0984a783          	lw	a5,152(s1)
    80000198:	09c4a703          	lw	a4,156(s1)
    8000019c:	fef703e3          	beq	a4,a5,80000182 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0017871b          	addiw	a4,a5,1
    800001a4:	08e4ac23          	sw	a4,152(s1)
    800001a8:	07f7f713          	andi	a4,a5,127
    800001ac:	9726                	add	a4,a4,s1
    800001ae:	01874703          	lbu	a4,24(a4)
    800001b2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001b6:	057d0f63          	beq	s10,s7,80000214 <consoleread+0xea>
    cbuf = c;
    800001ba:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	4685                	li	a3,1
    800001c0:	f9f40613          	addi	a2,s0,-97
    800001c4:	85d2                	mv	a1,s4
    800001c6:	8556                	mv	a0,s5
    800001c8:	78d010ef          	jal	ra,80002154 <either_copyout>
    800001cc:	01850663          	beq	a0,s8,800001d8 <consoleread+0xae>
    dst++;
    800001d0:	0a05                	addi	s4,s4,1
    --n;
    800001d2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001d4:	f99d1fe3          	bne	s10,s9,80000172 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001d8:	0000f517          	auipc	a0,0xf
    800001dc:	75850513          	addi	a0,a0,1880 # 8000f930 <cons>
    800001e0:	253000ef          	jal	ra,80000c32 <release>

  return target - n;
    800001e4:	413b053b          	subw	a0,s6,s3
    800001e8:	a801                	j	800001f8 <consoleread+0xce>
        release(&cons.lock);
    800001ea:	0000f517          	auipc	a0,0xf
    800001ee:	74650513          	addi	a0,a0,1862 # 8000f930 <cons>
    800001f2:	241000ef          	jal	ra,80000c32 <release>
        return -1;
    800001f6:	557d                	li	a0,-1
}
    800001f8:	70a6                	ld	ra,104(sp)
    800001fa:	7406                	ld	s0,96(sp)
    800001fc:	64e6                	ld	s1,88(sp)
    800001fe:	6946                	ld	s2,80(sp)
    80000200:	69a6                	ld	s3,72(sp)
    80000202:	6a06                	ld	s4,64(sp)
    80000204:	7ae2                	ld	s5,56(sp)
    80000206:	7b42                	ld	s6,48(sp)
    80000208:	7ba2                	ld	s7,40(sp)
    8000020a:	7c02                	ld	s8,32(sp)
    8000020c:	6ce2                	ld	s9,24(sp)
    8000020e:	6d42                	ld	s10,16(sp)
    80000210:	6165                	addi	sp,sp,112
    80000212:	8082                	ret
      if(n < target){
    80000214:	0009871b          	sext.w	a4,s3
    80000218:	fd6770e3          	bgeu	a4,s6,800001d8 <consoleread+0xae>
        cons.r--;
    8000021c:	0000f717          	auipc	a4,0xf
    80000220:	7af72623          	sw	a5,1964(a4) # 8000f9c8 <cons+0x98>
    80000224:	bf55                	j	800001d8 <consoleread+0xae>

0000000080000226 <consputc>:
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000022e:	10000793          	li	a5,256
    80000232:	00f50863          	beq	a0,a5,80000242 <consputc+0x1c>
    uartputc_sync(c);
    80000236:	5d4000ef          	jal	ra,8000080a <uartputc_sync>
}
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000242:	4521                	li	a0,8
    80000244:	5c6000ef          	jal	ra,8000080a <uartputc_sync>
    80000248:	02000513          	li	a0,32
    8000024c:	5be000ef          	jal	ra,8000080a <uartputc_sync>
    80000250:	4521                	li	a0,8
    80000252:	5b8000ef          	jal	ra,8000080a <uartputc_sync>
    80000256:	b7d5                	j	8000023a <consputc+0x14>

0000000080000258 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000258:	1101                	addi	sp,sp,-32
    8000025a:	ec06                	sd	ra,24(sp)
    8000025c:	e822                	sd	s0,16(sp)
    8000025e:	e426                	sd	s1,8(sp)
    80000260:	e04a                	sd	s2,0(sp)
    80000262:	1000                	addi	s0,sp,32
    80000264:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000266:	0000f517          	auipc	a0,0xf
    8000026a:	6ca50513          	addi	a0,a0,1738 # 8000f930 <cons>
    8000026e:	12d000ef          	jal	ra,80000b9a <acquire>

  switch(c){
    80000272:	47d5                	li	a5,21
    80000274:	0af48063          	beq	s1,a5,80000314 <consoleintr+0xbc>
    80000278:	0297c663          	blt	a5,s1,800002a4 <consoleintr+0x4c>
    8000027c:	47a1                	li	a5,8
    8000027e:	0cf48f63          	beq	s1,a5,8000035c <consoleintr+0x104>
    80000282:	47c1                	li	a5,16
    80000284:	10f49063          	bne	s1,a5,80000384 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80000288:	761010ef          	jal	ra,800021e8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028c:	0000f517          	auipc	a0,0xf
    80000290:	6a450513          	addi	a0,a0,1700 # 8000f930 <cons>
    80000294:	19f000ef          	jal	ra,80000c32 <release>
}
    80000298:	60e2                	ld	ra,24(sp)
    8000029a:	6442                	ld	s0,16(sp)
    8000029c:	64a2                	ld	s1,8(sp)
    8000029e:	6902                	ld	s2,0(sp)
    800002a0:	6105                	addi	sp,sp,32
    800002a2:	8082                	ret
  switch(c){
    800002a4:	07f00793          	li	a5,127
    800002a8:	0af48a63          	beq	s1,a5,8000035c <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002ac:	0000f717          	auipc	a4,0xf
    800002b0:	68470713          	addi	a4,a4,1668 # 8000f930 <cons>
    800002b4:	0a072783          	lw	a5,160(a4)
    800002b8:	09872703          	lw	a4,152(a4)
    800002bc:	9f99                	subw	a5,a5,a4
    800002be:	07f00713          	li	a4,127
    800002c2:	fcf765e3          	bltu	a4,a5,8000028c <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c6:	47b5                	li	a5,13
    800002c8:	0cf48163          	beq	s1,a5,8000038a <consoleintr+0x132>
      consputc(c);
    800002cc:	8526                	mv	a0,s1
    800002ce:	f59ff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d2:	0000f797          	auipc	a5,0xf
    800002d6:	65e78793          	addi	a5,a5,1630 # 8000f930 <cons>
    800002da:	0a07a683          	lw	a3,160(a5)
    800002de:	0016871b          	addiw	a4,a3,1
    800002e2:	0007061b          	sext.w	a2,a4
    800002e6:	0ae7a023          	sw	a4,160(a5)
    800002ea:	07f6f693          	andi	a3,a3,127
    800002ee:	97b6                	add	a5,a5,a3
    800002f0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f4:	47a9                	li	a5,10
    800002f6:	0af48f63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    800002fa:	4791                	li	a5,4
    800002fc:	0af48c63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    80000300:	0000f797          	auipc	a5,0xf
    80000304:	6c87a783          	lw	a5,1736(a5) # 8000f9c8 <cons+0x98>
    80000308:	9f1d                	subw	a4,a4,a5
    8000030a:	08000793          	li	a5,128
    8000030e:	f6f71fe3          	bne	a4,a5,8000028c <consoleintr+0x34>
    80000312:	a04d                	j	800003b4 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000314:	0000f717          	auipc	a4,0xf
    80000318:	61c70713          	addi	a4,a4,1564 # 8000f930 <cons>
    8000031c:	0a072783          	lw	a5,160(a4)
    80000320:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000324:	0000f497          	auipc	s1,0xf
    80000328:	60c48493          	addi	s1,s1,1548 # 8000f930 <cons>
    while(cons.e != cons.w &&
    8000032c:	4929                	li	s2,10
    8000032e:	f4f70fe3          	beq	a4,a5,8000028c <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000332:	37fd                	addiw	a5,a5,-1
    80000334:	07f7f713          	andi	a4,a5,127
    80000338:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000033a:	01874703          	lbu	a4,24(a4)
    8000033e:	f52707e3          	beq	a4,s2,8000028c <consoleintr+0x34>
      cons.e--;
    80000342:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000346:	10000513          	li	a0,256
    8000034a:	eddff0ef          	jal	ra,80000226 <consputc>
    while(cons.e != cons.w &&
    8000034e:	0a04a783          	lw	a5,160(s1)
    80000352:	09c4a703          	lw	a4,156(s1)
    80000356:	fcf71ee3          	bne	a4,a5,80000332 <consoleintr+0xda>
    8000035a:	bf0d                	j	8000028c <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035c:	0000f717          	auipc	a4,0xf
    80000360:	5d470713          	addi	a4,a4,1492 # 8000f930 <cons>
    80000364:	0a072783          	lw	a5,160(a4)
    80000368:	09c72703          	lw	a4,156(a4)
    8000036c:	f2f700e3          	beq	a4,a5,8000028c <consoleintr+0x34>
      cons.e--;
    80000370:	37fd                	addiw	a5,a5,-1
    80000372:	0000f717          	auipc	a4,0xf
    80000376:	64f72f23          	sw	a5,1630(a4) # 8000f9d0 <cons+0xa0>
      consputc(BACKSPACE);
    8000037a:	10000513          	li	a0,256
    8000037e:	ea9ff0ef          	jal	ra,80000226 <consputc>
    80000382:	b729                	j	8000028c <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000384:	f00484e3          	beqz	s1,8000028c <consoleintr+0x34>
    80000388:	b715                	j	800002ac <consoleintr+0x54>
      consputc(c);
    8000038a:	4529                	li	a0,10
    8000038c:	e9bff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000390:	0000f797          	auipc	a5,0xf
    80000394:	5a078793          	addi	a5,a5,1440 # 8000f930 <cons>
    80000398:	0a07a703          	lw	a4,160(a5)
    8000039c:	0017069b          	addiw	a3,a4,1
    800003a0:	0006861b          	sext.w	a2,a3
    800003a4:	0ad7a023          	sw	a3,160(a5)
    800003a8:	07f77713          	andi	a4,a4,127
    800003ac:	97ba                	add	a5,a5,a4
    800003ae:	4729                	li	a4,10
    800003b0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b4:	0000f797          	auipc	a5,0xf
    800003b8:	60c7ac23          	sw	a2,1560(a5) # 8000f9cc <cons+0x9c>
        wakeup(&cons.r);
    800003bc:	0000f517          	auipc	a0,0xf
    800003c0:	60c50513          	addi	a0,a0,1548 # 8000f9c8 <cons+0x98>
    800003c4:	281010ef          	jal	ra,80001e44 <wakeup>
    800003c8:	b5d1                	j	8000028c <consoleintr+0x34>

00000000800003ca <consoleinit>:

void
consoleinit(void)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e406                	sd	ra,8(sp)
    800003ce:	e022                	sd	s0,0(sp)
    800003d0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d2:	00007597          	auipc	a1,0x7
    800003d6:	c3e58593          	addi	a1,a1,-962 # 80007010 <etext+0x10>
    800003da:	0000f517          	auipc	a0,0xf
    800003de:	55650513          	addi	a0,a0,1366 # 8000f930 <cons>
    800003e2:	738000ef          	jal	ra,80000b1a <initlock>

  uartinit();
    800003e6:	3d8000ef          	jal	ra,800007be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003ea:	00025797          	auipc	a5,0x25
    800003ee:	36678793          	addi	a5,a5,870 # 80025750 <devsw>
    800003f2:	00000717          	auipc	a4,0x0
    800003f6:	d3870713          	addi	a4,a4,-712 # 8000012a <consoleread>
    800003fa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fc:	00000717          	auipc	a4,0x0
    80000400:	cd470713          	addi	a4,a4,-812 # 800000d0 <consolewrite>
    80000404:	ef98                	sd	a4,24(a5)
}
    80000406:	60a2                	ld	ra,8(sp)
    80000408:	6402                	ld	s0,0(sp)
    8000040a:	0141                	addi	sp,sp,16
    8000040c:	8082                	ret

000000008000040e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000040e:	7179                	addi	sp,sp,-48
    80000410:	f406                	sd	ra,40(sp)
    80000412:	f022                	sd	s0,32(sp)
    80000414:	ec26                	sd	s1,24(sp)
    80000416:	e84a                	sd	s2,16(sp)
    80000418:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000041a:	c219                	beqz	a2,80000420 <printint+0x12>
    8000041c:	06054f63          	bltz	a0,8000049a <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000420:	4881                	li	a7,0
    80000422:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000426:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000428:	00007617          	auipc	a2,0x7
    8000042c:	c1060613          	addi	a2,a2,-1008 # 80007038 <digits>
    80000430:	883e                	mv	a6,a5
    80000432:	2785                	addiw	a5,a5,1
    80000434:	02b57733          	remu	a4,a0,a1
    80000438:	9732                	add	a4,a4,a2
    8000043a:	00074703          	lbu	a4,0(a4)
    8000043e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000442:	872a                	mv	a4,a0
    80000444:	02b55533          	divu	a0,a0,a1
    80000448:	0685                	addi	a3,a3,1
    8000044a:	feb773e3          	bgeu	a4,a1,80000430 <printint+0x22>

  if(sign)
    8000044e:	00088b63          	beqz	a7,80000464 <printint+0x56>
    buf[i++] = '-';
    80000452:	fe040713          	addi	a4,s0,-32
    80000456:	97ba                	add	a5,a5,a4
    80000458:	02d00713          	li	a4,45
    8000045c:	fee78823          	sb	a4,-16(a5)
    80000460:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000464:	02f05563          	blez	a5,8000048e <printint+0x80>
    80000468:	fd040713          	addi	a4,s0,-48
    8000046c:	00f704b3          	add	s1,a4,a5
    80000470:	fff70913          	addi	s2,a4,-1
    80000474:	993e                	add	s2,s2,a5
    80000476:	37fd                	addiw	a5,a5,-1
    80000478:	1782                	slli	a5,a5,0x20
    8000047a:	9381                	srli	a5,a5,0x20
    8000047c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000480:	fff4c503          	lbu	a0,-1(s1)
    80000484:	da3ff0ef          	jal	ra,80000226 <consputc>
  while(--i >= 0)
    80000488:	14fd                	addi	s1,s1,-1
    8000048a:	ff249be3          	bne	s1,s2,80000480 <printint+0x72>
}
    8000048e:	70a2                	ld	ra,40(sp)
    80000490:	7402                	ld	s0,32(sp)
    80000492:	64e2                	ld	s1,24(sp)
    80000494:	6942                	ld	s2,16(sp)
    80000496:	6145                	addi	sp,sp,48
    80000498:	8082                	ret
    x = -xx;
    8000049a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049e:	4885                	li	a7,1
    x = -xx;
    800004a0:	b749                	j	80000422 <printint+0x14>

00000000800004a2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004a2:	7155                	addi	sp,sp,-208
    800004a4:	e506                	sd	ra,136(sp)
    800004a6:	e122                	sd	s0,128(sp)
    800004a8:	fca6                	sd	s1,120(sp)
    800004aa:	f8ca                	sd	s2,112(sp)
    800004ac:	f4ce                	sd	s3,104(sp)
    800004ae:	f0d2                	sd	s4,96(sp)
    800004b0:	ecd6                	sd	s5,88(sp)
    800004b2:	e8da                	sd	s6,80(sp)
    800004b4:	e4de                	sd	s7,72(sp)
    800004b6:	e0e2                	sd	s8,64(sp)
    800004b8:	fc66                	sd	s9,56(sp)
    800004ba:	f86a                	sd	s10,48(sp)
    800004bc:	f46e                	sd	s11,40(sp)
    800004be:	0900                	addi	s0,sp,144
    800004c0:	8a2a                	mv	s4,a0
    800004c2:	e40c                	sd	a1,8(s0)
    800004c4:	e810                	sd	a2,16(s0)
    800004c6:	ec14                	sd	a3,24(s0)
    800004c8:	f018                	sd	a4,32(s0)
    800004ca:	f41c                	sd	a5,40(s0)
    800004cc:	03043823          	sd	a6,48(s0)
    800004d0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d4:	0000f797          	auipc	a5,0xf
    800004d8:	51c7a783          	lw	a5,1308(a5) # 8000f9f0 <pr+0x18>
    800004dc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004e0:	eb9d                	bnez	a5,80000516 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004e2:	00840793          	addi	a5,s0,8
    800004e6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004ea:	00054503          	lbu	a0,0(a0)
    800004ee:	24050463          	beqz	a0,80000736 <printf+0x294>
    800004f2:	4981                	li	s3,0
    if(cx != '%'){
    800004f4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004fc:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000500:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000504:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000508:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000050c:	00007b97          	auipc	s7,0x7
    80000510:	b2cb8b93          	addi	s7,s7,-1236 # 80007038 <digits>
    80000514:	a081                	j	80000554 <printf+0xb2>
    acquire(&pr.lock);
    80000516:	0000f517          	auipc	a0,0xf
    8000051a:	4c250513          	addi	a0,a0,1218 # 8000f9d8 <pr>
    8000051e:	67c000ef          	jal	ra,80000b9a <acquire>
  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	f171                	bnez	a0,800004f2 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000530:	0000f517          	auipc	a0,0xf
    80000534:	4a850513          	addi	a0,a0,1192 # 8000f9d8 <pr>
    80000538:	6fa000ef          	jal	ra,80000c32 <release>
    8000053c:	aaed                	j	80000736 <printf+0x294>
      consputc(cx);
    8000053e:	ce9ff0ef          	jal	ra,80000226 <consputc>
      continue;
    80000542:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000544:	0014899b          	addiw	s3,s1,1
    80000548:	013a07b3          	add	a5,s4,s3
    8000054c:	0007c503          	lbu	a0,0(a5)
    80000550:	1c050f63          	beqz	a0,8000072e <printf+0x28c>
    if(cx != '%'){
    80000554:	ff5515e3          	bne	a0,s5,8000053e <printf+0x9c>
    i++;
    80000558:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000055c:	009a07b3          	add	a5,s4,s1
    80000560:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000564:	1c090563          	beqz	s2,8000072e <printf+0x28c>
    80000568:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000056c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000056e:	c789                	beqz	a5,80000578 <printf+0xd6>
    80000570:	009a0733          	add	a4,s4,s1
    80000574:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000578:	03690463          	beq	s2,s6,800005a0 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    8000057c:	03890e63          	beq	s2,s8,800005b8 <printf+0x116>
    } else if(c0 == 'u'){
    80000580:	0b990d63          	beq	s2,s9,8000063a <printf+0x198>
    } else if(c0 == 'x'){
    80000584:	11a90363          	beq	s2,s10,8000068a <printf+0x1e8>
    } else if(c0 == 'p'){
    80000588:	13b90b63          	beq	s2,s11,800006be <printf+0x21c>
    } else if(c0 == 's'){
    8000058c:	07300793          	li	a5,115
    80000590:	16f90363          	beq	s2,a5,800006f6 <printf+0x254>
    } else if(c0 == '%'){
    80000594:	03591c63          	bne	s2,s5,800005cc <printf+0x12a>
      consputc('%');
    80000598:	8556                	mv	a0,s5
    8000059a:	c8dff0ef          	jal	ra,80000226 <consputc>
    8000059e:	b75d                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800005a0:	f8843783          	ld	a5,-120(s0)
    800005a4:	00878713          	addi	a4,a5,8
    800005a8:	f8e43423          	sd	a4,-120(s0)
    800005ac:	4605                	li	a2,1
    800005ae:	45a9                	li	a1,10
    800005b0:	4388                	lw	a0,0(a5)
    800005b2:	e5dff0ef          	jal	ra,8000040e <printint>
    800005b6:	b779                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b8:	03678163          	beq	a5,s6,800005da <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005bc:	03878d63          	beq	a5,s8,800005f6 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005c0:	09978963          	beq	a5,s9,80000652 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005c4:	03878b63          	beq	a5,s8,800005fa <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005c8:	0da78d63          	beq	a5,s10,800006a2 <printf+0x200>
      consputc('%');
    800005cc:	8556                	mv	a0,s5
    800005ce:	c59ff0ef          	jal	ra,80000226 <consputc>
      consputc(c0);
    800005d2:	854a                	mv	a0,s2
    800005d4:	c53ff0ef          	jal	ra,80000226 <consputc>
    800005d8:	b7b5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	6388                	ld	a0,0(a5)
    800005ec:	e23ff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800005f0:	0029849b          	addiw	s1,s3,2
    800005f4:	bf81                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03668463          	beq	a3,s6,8000061e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005fa:	07968a63          	beq	a3,s9,8000066e <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800005fe:	fda697e3          	bne	a3,s10,800005cc <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4601                	li	a2,0
    80000610:	45c1                	li	a1,16
    80000612:	6388                	ld	a0,0(a5)
    80000614:	dfbff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000618:	0039849b          	addiw	s1,s3,3
    8000061c:	b725                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000061e:	f8843783          	ld	a5,-120(s0)
    80000622:	00878713          	addi	a4,a5,8
    80000626:	f8e43423          	sd	a4,-120(s0)
    8000062a:	4605                	li	a2,1
    8000062c:	45a9                	li	a1,10
    8000062e:	6388                	ld	a0,0(a5)
    80000630:	ddfff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000634:	0039849b          	addiw	s1,s3,3
    80000638:	b731                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000063a:	f8843783          	ld	a5,-120(s0)
    8000063e:	00878713          	addi	a4,a5,8
    80000642:	f8e43423          	sd	a4,-120(s0)
    80000646:	4601                	li	a2,0
    80000648:	45a9                	li	a1,10
    8000064a:	4388                	lw	a0,0(a5)
    8000064c:	dc3ff0ef          	jal	ra,8000040e <printint>
    80000650:	bdd5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	dabff0ef          	jal	ra,8000040e <printint>
      i += 1;
    80000668:	0029849b          	addiw	s1,s3,2
    8000066c:	bde1                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	6388                	ld	a0,0(a5)
    80000680:	d8fff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000684:	0039849b          	addiw	s1,s3,3
    80000688:	bd75                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45c1                	li	a1,16
    8000069a:	4388                	lw	a0,0(a5)
    8000069c:	d73ff0ef          	jal	ra,8000040e <printint>
    800006a0:	b555                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d5bff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800006b8:	0029849b          	addiw	s1,s3,2
    800006bc:	b561                	j	80000544 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ce:	03000513          	li	a0,48
    800006d2:	b55ff0ef          	jal	ra,80000226 <consputc>
  consputc('x');
    800006d6:	856a                	mv	a0,s10
    800006d8:	b4fff0ef          	jal	ra,80000226 <consputc>
    800006dc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006de:	03c9d793          	srli	a5,s3,0x3c
    800006e2:	97de                	add	a5,a5,s7
    800006e4:	0007c503          	lbu	a0,0(a5)
    800006e8:	b3fff0ef          	jal	ra,80000226 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ec:	0992                	slli	s3,s3,0x4
    800006ee:	397d                	addiw	s2,s2,-1
    800006f0:	fe0917e3          	bnez	s2,800006de <printf+0x23c>
    800006f4:	bd81                	j	80000544 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	0007b903          	ld	s2,0(a5)
    80000706:	00090d63          	beqz	s2,80000720 <printf+0x27e>
      for(; *s; s++)
    8000070a:	00094503          	lbu	a0,0(s2)
    8000070e:	e2050be3          	beqz	a0,80000544 <printf+0xa2>
        consputc(*s);
    80000712:	b15ff0ef          	jal	ra,80000226 <consputc>
      for(; *s; s++)
    80000716:	0905                	addi	s2,s2,1
    80000718:	00094503          	lbu	a0,0(s2)
    8000071c:	f97d                	bnez	a0,80000712 <printf+0x270>
    8000071e:	b51d                	j	80000544 <printf+0xa2>
        s = "(null)";
    80000720:	00007917          	auipc	s2,0x7
    80000724:	8f890913          	addi	s2,s2,-1800 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000728:	02800513          	li	a0,40
    8000072c:	b7dd                	j	80000712 <printf+0x270>
  if(locking)
    8000072e:	f7843783          	ld	a5,-136(s0)
    80000732:	de079fe3          	bnez	a5,80000530 <printf+0x8e>

  return 0;
}
    80000736:	4501                	li	a0,0
    80000738:	60aa                	ld	ra,136(sp)
    8000073a:	640a                	ld	s0,128(sp)
    8000073c:	74e6                	ld	s1,120(sp)
    8000073e:	7946                	ld	s2,112(sp)
    80000740:	79a6                	ld	s3,104(sp)
    80000742:	7a06                	ld	s4,96(sp)
    80000744:	6ae6                	ld	s5,88(sp)
    80000746:	6b46                	ld	s6,80(sp)
    80000748:	6ba6                	ld	s7,72(sp)
    8000074a:	6c06                	ld	s8,64(sp)
    8000074c:	7ce2                	ld	s9,56(sp)
    8000074e:	7d42                	ld	s10,48(sp)
    80000750:	7da2                	ld	s11,40(sp)
    80000752:	6169                	addi	sp,sp,208
    80000754:	8082                	ret

0000000080000756 <panic>:

void
panic(char *s)
{
    80000756:	1101                	addi	sp,sp,-32
    80000758:	ec06                	sd	ra,24(sp)
    8000075a:	e822                	sd	s0,16(sp)
    8000075c:	e426                	sd	s1,8(sp)
    8000075e:	1000                	addi	s0,sp,32
    80000760:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000762:	0000f797          	auipc	a5,0xf
    80000766:	2807a723          	sw	zero,654(a5) # 8000f9f0 <pr+0x18>
  printf("panic: ");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	8b650513          	addi	a0,a0,-1866 # 80007020 <etext+0x20>
    80000772:	d31ff0ef          	jal	ra,800004a2 <printf>
  printf("%s\n", s);
    80000776:	85a6                	mv	a1,s1
    80000778:	00007517          	auipc	a0,0x7
    8000077c:	8b050513          	addi	a0,a0,-1872 # 80007028 <etext+0x28>
    80000780:	d23ff0ef          	jal	ra,800004a2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000784:	4785                	li	a5,1
    80000786:	00007717          	auipc	a4,0x7
    8000078a:	16f72523          	sw	a5,362(a4) # 800078f0 <panicked>
  for(;;)
    8000078e:	a001                	j	8000078e <panic+0x38>

0000000080000790 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000079a:	0000f497          	auipc	s1,0xf
    8000079e:	23e48493          	addi	s1,s1,574 # 8000f9d8 <pr>
    800007a2:	00007597          	auipc	a1,0x7
    800007a6:	88e58593          	addi	a1,a1,-1906 # 80007030 <etext+0x30>
    800007aa:	8526                	mv	a0,s1
    800007ac:	36e000ef          	jal	ra,80000b1a <initlock>
  pr.locking = 1;
    800007b0:	4785                	li	a5,1
    800007b2:	cc9c                	sw	a5,24(s1)
}
    800007b4:	60e2                	ld	ra,24(sp)
    800007b6:	6442                	ld	s0,16(sp)
    800007b8:	64a2                	ld	s1,8(sp)
    800007ba:	6105                	addi	sp,sp,32
    800007bc:	8082                	ret

00000000800007be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007be:	1141                	addi	sp,sp,-16
    800007c0:	e406                	sd	ra,8(sp)
    800007c2:	e022                	sd	s0,0(sp)
    800007c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c6:	100007b7          	lui	a5,0x10000
    800007ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ce:	f8000713          	li	a4,-128
    800007d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d6:	470d                	li	a4,3
    800007d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007e4:	469d                	li	a3,7
    800007e6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ea:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	86258593          	addi	a1,a1,-1950 # 80007050 <digits+0x18>
    800007f6:	0000f517          	auipc	a0,0xf
    800007fa:	20250513          	addi	a0,a0,514 # 8000f9f8 <uart_tx_lock>
    800007fe:	31c000ef          	jal	ra,80000b1a <initlock>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000080a:	1101                	addi	sp,sp,-32
    8000080c:	ec06                	sd	ra,24(sp)
    8000080e:	e822                	sd	s0,16(sp)
    80000810:	e426                	sd	s1,8(sp)
    80000812:	1000                	addi	s0,sp,32
    80000814:	84aa                	mv	s1,a0
  push_off();
    80000816:	344000ef          	jal	ra,80000b5a <push_off>

  if(panicked){
    8000081a:	00007797          	auipc	a5,0x7
    8000081e:	0d67a783          	lw	a5,214(a5) # 800078f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000822:	10000737          	lui	a4,0x10000
  if(panicked){
    80000826:	c391                	beqz	a5,8000082a <uartputc_sync+0x20>
    for(;;)
    80000828:	a001                	j	80000828 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000082e:	0207f793          	andi	a5,a5,32
    80000832:	dfe5                	beqz	a5,8000082a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000834:	0ff4f513          	andi	a0,s1,255
    80000838:	100007b7          	lui	a5,0x10000
    8000083c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000840:	39e000ef          	jal	ra,80000bde <pop_off>
}
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084e:	00007797          	auipc	a5,0x7
    80000852:	0aa7b783          	ld	a5,170(a5) # 800078f8 <uart_tx_r>
    80000856:	00007717          	auipc	a4,0x7
    8000085a:	0aa73703          	ld	a4,170(a4) # 80007900 <uart_tx_w>
    8000085e:	06f70c63          	beq	a4,a5,800008d6 <uartstart+0x88>
{
    80000862:	7139                	addi	sp,sp,-64
    80000864:	fc06                	sd	ra,56(sp)
    80000866:	f822                	sd	s0,48(sp)
    80000868:	f426                	sd	s1,40(sp)
    8000086a:	f04a                	sd	s2,32(sp)
    8000086c:	ec4e                	sd	s3,24(sp)
    8000086e:	e852                	sd	s4,16(sp)
    80000870:	e456                	sd	s5,8(sp)
    80000872:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000878:	0000fa17          	auipc	s4,0xf
    8000087c:	180a0a13          	addi	s4,s4,384 # 8000f9f8 <uart_tx_lock>
    uart_tx_r += 1;
    80000880:	00007497          	auipc	s1,0x7
    80000884:	07848493          	addi	s1,s1,120 # 800078f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000888:	00007997          	auipc	s3,0x7
    8000088c:	07898993          	addi	s3,s3,120 # 80007900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000890:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000894:	02077713          	andi	a4,a4,32
    80000898:	c715                	beqz	a4,800008c4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000089a:	01f7f713          	andi	a4,a5,31
    8000089e:	9752                	add	a4,a4,s4
    800008a0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008a4:	0785                	addi	a5,a5,1
    800008a6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a8:	8526                	mv	a0,s1
    800008aa:	59a010ef          	jal	ra,80001e44 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	609c                	ld	a5,0(s1)
    800008b4:	0009b703          	ld	a4,0(s3)
    800008b8:	fcf71ce3          	bne	a4,a5,80000890 <uartstart+0x42>
      ReadReg(ISR);
    800008bc:	100007b7          	lui	a5,0x10000
    800008c0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008c4:	70e2                	ld	ra,56(sp)
    800008c6:	7442                	ld	s0,48(sp)
    800008c8:	74a2                	ld	s1,40(sp)
    800008ca:	7902                	ld	s2,32(sp)
    800008cc:	69e2                	ld	s3,24(sp)
    800008ce:	6a42                	ld	s4,16(sp)
    800008d0:	6aa2                	ld	s5,8(sp)
    800008d2:	6121                	addi	sp,sp,64
    800008d4:	8082                	ret
      ReadReg(ISR);
    800008d6:	100007b7          	lui	a5,0x10000
    800008da:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008f2:	0000f517          	auipc	a0,0xf
    800008f6:	10650513          	addi	a0,a0,262 # 8000f9f8 <uart_tx_lock>
    800008fa:	2a0000ef          	jal	ra,80000b9a <acquire>
  if(panicked){
    800008fe:	00007797          	auipc	a5,0x7
    80000902:	ff27a783          	lw	a5,-14(a5) # 800078f0 <panicked>
    80000906:	efbd                	bnez	a5,80000984 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000908:	00007717          	auipc	a4,0x7
    8000090c:	ff873703          	ld	a4,-8(a4) # 80007900 <uart_tx_w>
    80000910:	00007797          	auipc	a5,0x7
    80000914:	fe87b783          	ld	a5,-24(a5) # 800078f8 <uart_tx_r>
    80000918:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091c:	0000f997          	auipc	s3,0xf
    80000920:	0dc98993          	addi	s3,s3,220 # 8000f9f8 <uart_tx_lock>
    80000924:	00007497          	auipc	s1,0x7
    80000928:	fd448493          	addi	s1,s1,-44 # 800078f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000092c:	00007917          	auipc	s2,0x7
    80000930:	fd490913          	addi	s2,s2,-44 # 80007900 <uart_tx_w>
    80000934:	00e79d63          	bne	a5,a4,8000094e <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85ce                	mv	a1,s3
    8000093a:	8526                	mv	a0,s1
    8000093c:	4bc010ef          	jal	ra,80001df8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000940:	00093703          	ld	a4,0(s2)
    80000944:	609c                	ld	a5,0(s1)
    80000946:	02078793          	addi	a5,a5,32
    8000094a:	fee787e3          	beq	a5,a4,80000938 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000094e:	0000f497          	auipc	s1,0xf
    80000952:	0aa48493          	addi	s1,s1,170 # 8000f9f8 <uart_tx_lock>
    80000956:	01f77793          	andi	a5,a4,31
    8000095a:	97a6                	add	a5,a5,s1
    8000095c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000960:	0705                	addi	a4,a4,1
    80000962:	00007797          	auipc	a5,0x7
    80000966:	f8e7bf23          	sd	a4,-98(a5) # 80007900 <uart_tx_w>
  uartstart();
    8000096a:	ee5ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    8000096e:	8526                	mv	a0,s1
    80000970:	2c2000ef          	jal	ra,80000c32 <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xa4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb91                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009a0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009a4:	6422                	ld	s0,8(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfe5                	j	800009a4 <uartgetc+0x1e>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b8:	54fd                	li	s1,-1
    800009ba:	a019                	j	800009c0 <uartintr+0x12>
      break;
    consoleintr(c);
    800009bc:	89dff0ef          	jal	ra,80000258 <consoleintr>
    int c = uartgetc();
    800009c0:	fc7ff0ef          	jal	ra,80000986 <uartgetc>
    if(c == -1)
    800009c4:	fe951ce3          	bne	a0,s1,800009bc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009c8:	0000f497          	auipc	s1,0xf
    800009cc:	03048493          	addi	s1,s1,48 # 8000f9f8 <uart_tx_lock>
    800009d0:	8526                	mv	a0,s1
    800009d2:	1c8000ef          	jal	ra,80000b9a <acquire>
  uartstart();
    800009d6:	e79ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    800009da:	8526                	mv	a0,s1
    800009dc:	256000ef          	jal	ra,80000c32 <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	e7a9                	bnez	a5,80000a44 <kfree+0x5a>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00026797          	auipc	a5,0x26
    80000a02:	eea78793          	addi	a5,a5,-278 # 800268e8 <end>
    80000a06:	02f56f63          	bltu	a0,a5,80000a44 <kfree+0x5a>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	02f57b63          	bgeu	a0,a5,80000a44 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	258000ef          	jal	ra,80000c6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1a:	0000f917          	auipc	s2,0xf
    80000a1e:	01690913          	addi	s2,s2,22 # 8000fa30 <kmem>
    80000a22:	854a                	mv	a0,s2
    80000a24:	176000ef          	jal	ra,80000b9a <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	1fe000ef          	jal	ra,80000c32 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6902                	ld	s2,0(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    panic("kfree");
    80000a44:	00006517          	auipc	a0,0x6
    80000a48:	61450513          	addi	a0,a0,1556 # 80007058 <digits+0x20>
    80000a4c:	d0bff0ef          	jal	ra,80000756 <panic>

0000000080000a50 <freerange>:
{
    80000a50:	7179                	addi	sp,sp,-48
    80000a52:	f406                	sd	ra,40(sp)
    80000a54:	f022                	sd	s0,32(sp)
    80000a56:	ec26                	sd	s1,24(sp)
    80000a58:	e84a                	sd	s2,16(sp)
    80000a5a:	e44e                	sd	s3,8(sp)
    80000a5c:	e052                	sd	s4,0(sp)
    80000a5e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a60:	6785                	lui	a5,0x1
    80000a62:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a66:	94aa                	add	s1,s1,a0
    80000a68:	757d                	lui	a0,0xfffff
    80000a6a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a6c:	94be                	add	s1,s1,a5
    80000a6e:	0095ec63          	bltu	a1,s1,80000a86 <freerange+0x36>
    80000a72:	892e                	mv	s2,a1
    kfree(p);
    80000a74:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	6985                	lui	s3,0x1
    kfree(p);
    80000a78:	01448533          	add	a0,s1,s4
    80000a7c:	f6fff0ef          	jal	ra,800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe997be3          	bgeu	s2,s1,80000a78 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00006597          	auipc	a1,0x6
    80000aa2:	5c258593          	addi	a1,a1,1474 # 80007060 <digits+0x28>
    80000aa6:	0000f517          	auipc	a0,0xf
    80000aaa:	f8a50513          	addi	a0,a0,-118 # 8000fa30 <kmem>
    80000aae:	06c000ef          	jal	ra,80000b1a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab2:	45c5                	li	a1,17
    80000ab4:	05ee                	slli	a1,a1,0x1b
    80000ab6:	00026517          	auipc	a0,0x26
    80000aba:	e3250513          	addi	a0,a0,-462 # 800268e8 <end>
    80000abe:	f93ff0ef          	jal	ra,80000a50 <freerange>
}
    80000ac2:	60a2                	ld	ra,8(sp)
    80000ac4:	6402                	ld	s0,0(sp)
    80000ac6:	0141                	addi	sp,sp,16
    80000ac8:	8082                	ret

0000000080000aca <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000aca:	1101                	addi	sp,sp,-32
    80000acc:	ec06                	sd	ra,24(sp)
    80000ace:	e822                	sd	s0,16(sp)
    80000ad0:	e426                	sd	s1,8(sp)
    80000ad2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ad4:	0000f497          	auipc	s1,0xf
    80000ad8:	f5c48493          	addi	s1,s1,-164 # 8000fa30 <kmem>
    80000adc:	8526                	mv	a0,s1
    80000ade:	0bc000ef          	jal	ra,80000b9a <acquire>
  r = kmem.freelist;
    80000ae2:	6c84                	ld	s1,24(s1)
  if(r)
    80000ae4:	c485                	beqz	s1,80000b0c <kalloc+0x42>
    kmem.freelist = r->next;
    80000ae6:	609c                	ld	a5,0(s1)
    80000ae8:	0000f517          	auipc	a0,0xf
    80000aec:	f4850513          	addi	a0,a0,-184 # 8000fa30 <kmem>
    80000af0:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af2:	140000ef          	jal	ra,80000c32 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000af6:	6605                	lui	a2,0x1
    80000af8:	4595                	li	a1,5
    80000afa:	8526                	mv	a0,s1
    80000afc:	172000ef          	jal	ra,80000c6e <memset>
  return (void*)r;
}
    80000b00:	8526                	mv	a0,s1
    80000b02:	60e2                	ld	ra,24(sp)
    80000b04:	6442                	ld	s0,16(sp)
    80000b06:	64a2                	ld	s1,8(sp)
    80000b08:	6105                	addi	sp,sp,32
    80000b0a:	8082                	ret
  release(&kmem.lock);
    80000b0c:	0000f517          	auipc	a0,0xf
    80000b10:	f2450513          	addi	a0,a0,-220 # 8000fa30 <kmem>
    80000b14:	11e000ef          	jal	ra,80000c32 <release>
  if(r)
    80000b18:	b7e5                	j	80000b00 <kalloc+0x36>

0000000080000b1a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e422                	sd	s0,8(sp)
    80000b1e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b20:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b22:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b26:	00053823          	sd	zero,16(a0)
}
    80000b2a:	6422                	ld	s0,8(sp)
    80000b2c:	0141                	addi	sp,sp,16
    80000b2e:	8082                	ret

0000000080000b30 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b30:	411c                	lw	a5,0(a0)
    80000b32:	e399                	bnez	a5,80000b38 <holding+0x8>
    80000b34:	4501                	li	a0,0
  return r;
}
    80000b36:	8082                	ret
{
    80000b38:	1101                	addi	sp,sp,-32
    80000b3a:	ec06                	sd	ra,24(sp)
    80000b3c:	e822                	sd	s0,16(sp)
    80000b3e:	e426                	sd	s1,8(sp)
    80000b40:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b42:	6904                	ld	s1,16(a0)
    80000b44:	4cd000ef          	jal	ra,80001810 <mycpu>
    80000b48:	40a48533          	sub	a0,s1,a0
    80000b4c:	00153513          	seqz	a0,a0
}
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret

0000000080000b5a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b5a:	1101                	addi	sp,sp,-32
    80000b5c:	ec06                	sd	ra,24(sp)
    80000b5e:	e822                	sd	s0,16(sp)
    80000b60:	e426                	sd	s1,8(sp)
    80000b62:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b64:	100024f3          	csrr	s1,sstatus
    80000b68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b6e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b72:	49f000ef          	jal	ra,80001810 <mycpu>
    80000b76:	5d3c                	lw	a5,120(a0)
    80000b78:	cb99                	beqz	a5,80000b8e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b7a:	497000ef          	jal	ra,80001810 <mycpu>
    80000b7e:	5d3c                	lw	a5,120(a0)
    80000b80:	2785                	addiw	a5,a5,1
    80000b82:	dd3c                	sw	a5,120(a0)
}
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret
    mycpu()->intena = old;
    80000b8e:	483000ef          	jal	ra,80001810 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b92:	8085                	srli	s1,s1,0x1
    80000b94:	8885                	andi	s1,s1,1
    80000b96:	dd64                	sw	s1,124(a0)
    80000b98:	b7cd                	j	80000b7a <push_off+0x20>

0000000080000b9a <acquire>:
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
    80000ba4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ba6:	fb5ff0ef          	jal	ra,80000b5a <push_off>
  if(holding(lk))
    80000baa:	8526                	mv	a0,s1
    80000bac:	f85ff0ef          	jal	ra,80000b30 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb0:	4705                	li	a4,1
  if(holding(lk))
    80000bb2:	e105                	bnez	a0,80000bd2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb4:	87ba                	mv	a5,a4
    80000bb6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bba:	2781                	sext.w	a5,a5
    80000bbc:	ffe5                	bnez	a5,80000bb4 <acquire+0x1a>
  __sync_synchronize();
    80000bbe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc2:	44f000ef          	jal	ra,80001810 <mycpu>
    80000bc6:	e888                	sd	a0,16(s1)
}
    80000bc8:	60e2                	ld	ra,24(sp)
    80000bca:	6442                	ld	s0,16(sp)
    80000bcc:	64a2                	ld	s1,8(sp)
    80000bce:	6105                	addi	sp,sp,32
    80000bd0:	8082                	ret
    panic("acquire");
    80000bd2:	00006517          	auipc	a0,0x6
    80000bd6:	49650513          	addi	a0,a0,1174 # 80007068 <digits+0x30>
    80000bda:	b7dff0ef          	jal	ra,80000756 <panic>

0000000080000bde <pop_off>:

void
pop_off(void)
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e406                	sd	ra,8(sp)
    80000be2:	e022                	sd	s0,0(sp)
    80000be4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000be6:	42b000ef          	jal	ra,80001810 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bf0:	e78d                	bnez	a5,80000c1a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf2:	5d3c                	lw	a5,120(a0)
    80000bf4:	02f05963          	blez	a5,80000c26 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bf8:	37fd                	addiw	a5,a5,-1
    80000bfa:	0007871b          	sext.w	a4,a5
    80000bfe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c00:	eb09                	bnez	a4,80000c12 <pop_off+0x34>
    80000c02:	5d7c                	lw	a5,124(a0)
    80000c04:	c799                	beqz	a5,80000c12 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c0e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c12:	60a2                	ld	ra,8(sp)
    80000c14:	6402                	ld	s0,0(sp)
    80000c16:	0141                	addi	sp,sp,16
    80000c18:	8082                	ret
    panic("pop_off - interruptible");
    80000c1a:	00006517          	auipc	a0,0x6
    80000c1e:	45650513          	addi	a0,a0,1110 # 80007070 <digits+0x38>
    80000c22:	b35ff0ef          	jal	ra,80000756 <panic>
    panic("pop_off");
    80000c26:	00006517          	auipc	a0,0x6
    80000c2a:	46250513          	addi	a0,a0,1122 # 80007088 <digits+0x50>
    80000c2e:	b29ff0ef          	jal	ra,80000756 <panic>

0000000080000c32 <release>:
{
    80000c32:	1101                	addi	sp,sp,-32
    80000c34:	ec06                	sd	ra,24(sp)
    80000c36:	e822                	sd	s0,16(sp)
    80000c38:	e426                	sd	s1,8(sp)
    80000c3a:	1000                	addi	s0,sp,32
    80000c3c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c3e:	ef3ff0ef          	jal	ra,80000b30 <holding>
    80000c42:	c105                	beqz	a0,80000c62 <release+0x30>
  lk->cpu = 0;
    80000c44:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c48:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c4c:	0f50000f          	fence	iorw,ow
    80000c50:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c54:	f8bff0ef          	jal	ra,80000bde <pop_off>
}
    80000c58:	60e2                	ld	ra,24(sp)
    80000c5a:	6442                	ld	s0,16(sp)
    80000c5c:	64a2                	ld	s1,8(sp)
    80000c5e:	6105                	addi	sp,sp,32
    80000c60:	8082                	ret
    panic("release");
    80000c62:	00006517          	auipc	a0,0x6
    80000c66:	42e50513          	addi	a0,a0,1070 # 80007090 <digits+0x58>
    80000c6a:	aedff0ef          	jal	ra,80000756 <panic>

0000000080000c6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c6e:	1141                	addi	sp,sp,-16
    80000c70:	e422                	sd	s0,8(sp)
    80000c72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c74:	ca19                	beqz	a2,80000c8a <memset+0x1c>
    80000c76:	87aa                	mv	a5,a0
    80000c78:	1602                	slli	a2,a2,0x20
    80000c7a:	9201                	srli	a2,a2,0x20
    80000c7c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c80:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c84:	0785                	addi	a5,a5,1
    80000c86:	fee79de3          	bne	a5,a4,80000c80 <memset+0x12>
  }
  return dst;
}
    80000c8a:	6422                	ld	s0,8(sp)
    80000c8c:	0141                	addi	sp,sp,16
    80000c8e:	8082                	ret

0000000080000c90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c90:	1141                	addi	sp,sp,-16
    80000c92:	e422                	sd	s0,8(sp)
    80000c94:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c96:	ca05                	beqz	a2,80000cc6 <memcmp+0x36>
    80000c98:	fff6069b          	addiw	a3,a2,-1
    80000c9c:	1682                	slli	a3,a3,0x20
    80000c9e:	9281                	srli	a3,a3,0x20
    80000ca0:	0685                	addi	a3,a3,1
    80000ca2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ca4:	00054783          	lbu	a5,0(a0)
    80000ca8:	0005c703          	lbu	a4,0(a1)
    80000cac:	00e79863          	bne	a5,a4,80000cbc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cb0:	0505                	addi	a0,a0,1
    80000cb2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cb4:	fed518e3          	bne	a0,a3,80000ca4 <memcmp+0x14>
  }

  return 0;
    80000cb8:	4501                	li	a0,0
    80000cba:	a019                	j	80000cc0 <memcmp+0x30>
      return *s1 - *s2;
    80000cbc:	40e7853b          	subw	a0,a5,a4
}
    80000cc0:	6422                	ld	s0,8(sp)
    80000cc2:	0141                	addi	sp,sp,16
    80000cc4:	8082                	ret
  return 0;
    80000cc6:	4501                	li	a0,0
    80000cc8:	bfe5                	j	80000cc0 <memcmp+0x30>

0000000080000cca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cca:	1141                	addi	sp,sp,-16
    80000ccc:	e422                	sd	s0,8(sp)
    80000cce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cd0:	c205                	beqz	a2,80000cf0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd2:	02a5e263          	bltu	a1,a0,80000cf6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00c587b3          	add	a5,a1,a2
{
    80000cde:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ce0:	0585                	addi	a1,a1,1
    80000ce2:	0705                	addi	a4,a4,1
    80000ce4:	fff5c683          	lbu	a3,-1(a1)
    80000ce8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cec:	fef59ae3          	bne	a1,a5,80000ce0 <memmove+0x16>

  return dst;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
  if(s < d && s + n > d){
    80000cf6:	02061693          	slli	a3,a2,0x20
    80000cfa:	9281                	srli	a3,a3,0x20
    80000cfc:	00d58733          	add	a4,a1,a3
    80000d00:	fce57be3          	bgeu	a0,a4,80000cd6 <memmove+0xc>
    d += n;
    80000d04:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d06:	fff6079b          	addiw	a5,a2,-1
    80000d0a:	1782                	slli	a5,a5,0x20
    80000d0c:	9381                	srli	a5,a5,0x20
    80000d0e:	fff7c793          	not	a5,a5
    80000d12:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d14:	177d                	addi	a4,a4,-1
    80000d16:	16fd                	addi	a3,a3,-1
    80000d18:	00074603          	lbu	a2,0(a4)
    80000d1c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d20:	fee79ae3          	bne	a5,a4,80000d14 <memmove+0x4a>
    80000d24:	b7f1                	j	80000cf0 <memmove+0x26>

0000000080000d26 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e406                	sd	ra,8(sp)
    80000d2a:	e022                	sd	s0,0(sp)
    80000d2c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d2e:	f9dff0ef          	jal	ra,80000cca <memmove>
}
    80000d32:	60a2                	ld	ra,8(sp)
    80000d34:	6402                	ld	s0,0(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d40:	ce11                	beqz	a2,80000d5c <strncmp+0x22>
    80000d42:	00054783          	lbu	a5,0(a0)
    80000d46:	cf89                	beqz	a5,80000d60 <strncmp+0x26>
    80000d48:	0005c703          	lbu	a4,0(a1)
    80000d4c:	00f71a63          	bne	a4,a5,80000d60 <strncmp+0x26>
    n--, p++, q++;
    80000d50:	367d                	addiw	a2,a2,-1
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d56:	f675                	bnez	a2,80000d42 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d58:	4501                	li	a0,0
    80000d5a:	a809                	j	80000d6c <strncmp+0x32>
    80000d5c:	4501                	li	a0,0
    80000d5e:	a039                	j	80000d6c <strncmp+0x32>
  if(n == 0)
    80000d60:	ca09                	beqz	a2,80000d72 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d62:	00054503          	lbu	a0,0(a0)
    80000d66:	0005c783          	lbu	a5,0(a1)
    80000d6a:	9d1d                	subw	a0,a0,a5
}
    80000d6c:	6422                	ld	s0,8(sp)
    80000d6e:	0141                	addi	sp,sp,16
    80000d70:	8082                	ret
    return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	bfe5                	j	80000d6c <strncmp+0x32>

0000000080000d76 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d76:	1141                	addi	sp,sp,-16
    80000d78:	e422                	sd	s0,8(sp)
    80000d7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d7c:	872a                	mv	a4,a0
    80000d7e:	8832                	mv	a6,a2
    80000d80:	367d                	addiw	a2,a2,-1
    80000d82:	01005963          	blez	a6,80000d94 <strncpy+0x1e>
    80000d86:	0705                	addi	a4,a4,1
    80000d88:	0005c783          	lbu	a5,0(a1)
    80000d8c:	fef70fa3          	sb	a5,-1(a4)
    80000d90:	0585                	addi	a1,a1,1
    80000d92:	f7f5                	bnez	a5,80000d7e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d94:	86ba                	mv	a3,a4
    80000d96:	00c05c63          	blez	a2,80000dae <strncpy+0x38>
    *s++ = 0;
    80000d9a:	0685                	addi	a3,a3,1
    80000d9c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000da0:	fff6c793          	not	a5,a3
    80000da4:	9fb9                	addw	a5,a5,a4
    80000da6:	010787bb          	addw	a5,a5,a6
    80000daa:	fef048e3          	bgtz	a5,80000d9a <strncpy+0x24>
  return os;
}
    80000dae:	6422                	ld	s0,8(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret

0000000080000db4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e422                	sd	s0,8(sp)
    80000db8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dba:	02c05363          	blez	a2,80000de0 <safestrcpy+0x2c>
    80000dbe:	fff6069b          	addiw	a3,a2,-1
    80000dc2:	1682                	slli	a3,a3,0x20
    80000dc4:	9281                	srli	a3,a3,0x20
    80000dc6:	96ae                	add	a3,a3,a1
    80000dc8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dca:	00d58963          	beq	a1,a3,80000ddc <safestrcpy+0x28>
    80000dce:	0585                	addi	a1,a1,1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	fff5c703          	lbu	a4,-1(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	fb65                	bnez	a4,80000dca <safestrcpy+0x16>
    ;
  *s = 0;
    80000ddc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000de0:	6422                	ld	s0,8(sp)
    80000de2:	0141                	addi	sp,sp,16
    80000de4:	8082                	ret

0000000080000de6 <strlen>:

int
strlen(const char *s)
{
    80000de6:	1141                	addi	sp,sp,-16
    80000de8:	e422                	sd	s0,8(sp)
    80000dea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dec:	00054783          	lbu	a5,0(a0)
    80000df0:	cf91                	beqz	a5,80000e0c <strlen+0x26>
    80000df2:	0505                	addi	a0,a0,1
    80000df4:	87aa                	mv	a5,a0
    80000df6:	4685                	li	a3,1
    80000df8:	9e89                	subw	a3,a3,a0
    80000dfa:	00f6853b          	addw	a0,a3,a5
    80000dfe:	0785                	addi	a5,a5,1
    80000e00:	fff7c703          	lbu	a4,-1(a5)
    80000e04:	fb7d                	bnez	a4,80000dfa <strlen+0x14>
    ;
  return n;
}
    80000e06:	6422                	ld	s0,8(sp)
    80000e08:	0141                	addi	sp,sp,16
    80000e0a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e0c:	4501                	li	a0,0
    80000e0e:	bfe5                	j	80000e06 <strlen+0x20>

0000000080000e10 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e406                	sd	ra,8(sp)
    80000e14:	e022                	sd	s0,0(sp)
    80000e16:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e18:	1e9000ef          	jal	ra,80001800 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e1c:	00007717          	auipc	a4,0x7
    80000e20:	aec70713          	addi	a4,a4,-1300 # 80007908 <started>
  if(cpuid() == 0){
    80000e24:	c51d                	beqz	a0,80000e52 <main+0x42>
    while(started == 0)
    80000e26:	431c                	lw	a5,0(a4)
    80000e28:	2781                	sext.w	a5,a5
    80000e2a:	dff5                	beqz	a5,80000e26 <main+0x16>
      ;
    __sync_synchronize();
    80000e2c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e30:	1d1000ef          	jal	ra,80001800 <cpuid>
    80000e34:	85aa                	mv	a1,a0
    80000e36:	00006517          	auipc	a0,0x6
    80000e3a:	27a50513          	addi	a0,a0,634 # 800070b0 <digits+0x78>
    80000e3e:	e64ff0ef          	jal	ra,800004a2 <printf>
    kvminithart();    // turn on paging
    80000e42:	080000ef          	jal	ra,80000ec2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e46:	5b0010ef          	jal	ra,800023f6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e4a:	4da040ef          	jal	ra,80005324 <plicinithart>
  }

  scheduler();        
    80000e4e:	611000ef          	jal	ra,80001c5e <scheduler>
    consoleinit();
    80000e52:	d78ff0ef          	jal	ra,800003ca <consoleinit>
    printfinit();
    80000e56:	93bff0ef          	jal	ra,80000790 <printfinit>
    printf("\n");
    80000e5a:	00006517          	auipc	a0,0x6
    80000e5e:	26650513          	addi	a0,a0,614 # 800070c0 <digits+0x88>
    80000e62:	e40ff0ef          	jal	ra,800004a2 <printf>
    printf("xv6 kernel is booting\n");
    80000e66:	00006517          	auipc	a0,0x6
    80000e6a:	23250513          	addi	a0,a0,562 # 80007098 <digits+0x60>
    80000e6e:	e34ff0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80000e72:	00006517          	auipc	a0,0x6
    80000e76:	24e50513          	addi	a0,a0,590 # 800070c0 <digits+0x88>
    80000e7a:	e28ff0ef          	jal	ra,800004a2 <printf>
    kinit();         // physical page allocator
    80000e7e:	c19ff0ef          	jal	ra,80000a96 <kinit>
    kvminit();       // create kernel page table
    80000e82:	2ca000ef          	jal	ra,8000114c <kvminit>
    kvminithart();   // turn on paging
    80000e86:	03c000ef          	jal	ra,80000ec2 <kvminithart>
    procinit();      // process table
    80000e8a:	0cf000ef          	jal	ra,80001758 <procinit>
    trapinit();      // trap vectors
    80000e8e:	544010ef          	jal	ra,800023d2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e92:	564010ef          	jal	ra,800023f6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e96:	478040ef          	jal	ra,8000530e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e9a:	48a040ef          	jal	ra,80005324 <plicinithart>
    binit();         // buffer cache
    80000e9e:	3ff010ef          	jal	ra,80002a9c <binit>
    iinit();         // inode table
    80000ea2:	1de020ef          	jal	ra,80003080 <iinit>
    fileinit();      // file table
    80000ea6:	77b020ef          	jal	ra,80003e20 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eaa:	56a040ef          	jal	ra,80005414 <virtio_disk_init>
    userinit();      // first user process
    80000eae:	3e7000ef          	jal	ra,80001a94 <userinit>
    __sync_synchronize();
    80000eb2:	0ff0000f          	fence
    started = 1;
    80000eb6:	4785                	li	a5,1
    80000eb8:	00007717          	auipc	a4,0x7
    80000ebc:	a4f72823          	sw	a5,-1456(a4) # 80007908 <started>
    80000ec0:	b779                	j	80000e4e <main+0x3e>

0000000080000ec2 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e422                	sd	s0,8(sp)
    80000ec6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ec8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ecc:	00007797          	auipc	a5,0x7
    80000ed0:	a447b783          	ld	a5,-1468(a5) # 80007910 <kernel_pagetable>
    80000ed4:	83b1                	srli	a5,a5,0xc
    80000ed6:	577d                	li	a4,-1
    80000ed8:	177e                	slli	a4,a4,0x3f
    80000eda:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000edc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ee0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ee4:	6422                	ld	s0,8(sp)
    80000ee6:	0141                	addi	sp,sp,16
    80000ee8:	8082                	ret

0000000080000eea <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000eea:	7139                	addi	sp,sp,-64
    80000eec:	fc06                	sd	ra,56(sp)
    80000eee:	f822                	sd	s0,48(sp)
    80000ef0:	f426                	sd	s1,40(sp)
    80000ef2:	f04a                	sd	s2,32(sp)
    80000ef4:	ec4e                	sd	s3,24(sp)
    80000ef6:	e852                	sd	s4,16(sp)
    80000ef8:	e456                	sd	s5,8(sp)
    80000efa:	e05a                	sd	s6,0(sp)
    80000efc:	0080                	addi	s0,sp,64
    80000efe:	84aa                	mv	s1,a0
    80000f00:	89ae                	mv	s3,a1
    80000f02:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f04:	57fd                	li	a5,-1
    80000f06:	83e9                	srli	a5,a5,0x1a
    80000f08:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f0a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f0c:	02b7fc63          	bgeu	a5,a1,80000f44 <walk+0x5a>
    panic("walk");
    80000f10:	00006517          	auipc	a0,0x6
    80000f14:	1b850513          	addi	a0,a0,440 # 800070c8 <digits+0x90>
    80000f18:	83fff0ef          	jal	ra,80000756 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f1c:	060a8263          	beqz	s5,80000f80 <walk+0x96>
    80000f20:	babff0ef          	jal	ra,80000aca <kalloc>
    80000f24:	84aa                	mv	s1,a0
    80000f26:	c139                	beqz	a0,80000f6c <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f28:	6605                	lui	a2,0x1
    80000f2a:	4581                	li	a1,0
    80000f2c:	d43ff0ef          	jal	ra,80000c6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f30:	00c4d793          	srli	a5,s1,0xc
    80000f34:	07aa                	slli	a5,a5,0xa
    80000f36:	0017e793          	ori	a5,a5,1
    80000f3a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f3e:	3a5d                	addiw	s4,s4,-9
    80000f40:	036a0063          	beq	s4,s6,80000f60 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f44:	0149d933          	srl	s2,s3,s4
    80000f48:	1ff97913          	andi	s2,s2,511
    80000f4c:	090e                	slli	s2,s2,0x3
    80000f4e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f50:	00093483          	ld	s1,0(s2)
    80000f54:	0014f793          	andi	a5,s1,1
    80000f58:	d3f1                	beqz	a5,80000f1c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f5a:	80a9                	srli	s1,s1,0xa
    80000f5c:	04b2                	slli	s1,s1,0xc
    80000f5e:	b7c5                	j	80000f3e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f60:	00c9d513          	srli	a0,s3,0xc
    80000f64:	1ff57513          	andi	a0,a0,511
    80000f68:	050e                	slli	a0,a0,0x3
    80000f6a:	9526                	add	a0,a0,s1
}
    80000f6c:	70e2                	ld	ra,56(sp)
    80000f6e:	7442                	ld	s0,48(sp)
    80000f70:	74a2                	ld	s1,40(sp)
    80000f72:	7902                	ld	s2,32(sp)
    80000f74:	69e2                	ld	s3,24(sp)
    80000f76:	6a42                	ld	s4,16(sp)
    80000f78:	6aa2                	ld	s5,8(sp)
    80000f7a:	6b02                	ld	s6,0(sp)
    80000f7c:	6121                	addi	sp,sp,64
    80000f7e:	8082                	ret
        return 0;
    80000f80:	4501                	li	a0,0
    80000f82:	b7ed                	j	80000f6c <walk+0x82>

0000000080000f84 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f84:	57fd                	li	a5,-1
    80000f86:	83e9                	srli	a5,a5,0x1a
    80000f88:	00b7f463          	bgeu	a5,a1,80000f90 <walkaddr+0xc>
    return 0;
    80000f8c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f8e:	8082                	ret
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e406                	sd	ra,8(sp)
    80000f94:	e022                	sd	s0,0(sp)
    80000f96:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f98:	4601                	li	a2,0
    80000f9a:	f51ff0ef          	jal	ra,80000eea <walk>
  if(pte == 0)
    80000f9e:	c105                	beqz	a0,80000fbe <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fa0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fa2:	0117f693          	andi	a3,a5,17
    80000fa6:	4745                	li	a4,17
    return 0;
    80000fa8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000faa:	00e68663          	beq	a3,a4,80000fb6 <walkaddr+0x32>
}
    80000fae:	60a2                	ld	ra,8(sp)
    80000fb0:	6402                	ld	s0,0(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret
  pa = PTE2PA(*pte);
    80000fb6:	00a7d513          	srli	a0,a5,0xa
    80000fba:	0532                	slli	a0,a0,0xc
  return pa;
    80000fbc:	bfcd                	j	80000fae <walkaddr+0x2a>
    return 0;
    80000fbe:	4501                	li	a0,0
    80000fc0:	b7fd                	j	80000fae <walkaddr+0x2a>

0000000080000fc2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fc2:	715d                	addi	sp,sp,-80
    80000fc4:	e486                	sd	ra,72(sp)
    80000fc6:	e0a2                	sd	s0,64(sp)
    80000fc8:	fc26                	sd	s1,56(sp)
    80000fca:	f84a                	sd	s2,48(sp)
    80000fcc:	f44e                	sd	s3,40(sp)
    80000fce:	f052                	sd	s4,32(sp)
    80000fd0:	ec56                	sd	s5,24(sp)
    80000fd2:	e85a                	sd	s6,16(sp)
    80000fd4:	e45e                	sd	s7,8(sp)
    80000fd6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fd8:	03459793          	slli	a5,a1,0x34
    80000fdc:	e7a9                	bnez	a5,80001026 <mappages+0x64>
    80000fde:	8aaa                	mv	s5,a0
    80000fe0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fe2:	03461793          	slli	a5,a2,0x34
    80000fe6:	e7b1                	bnez	a5,80001032 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fe8:	ca39                	beqz	a2,8000103e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fea:	79fd                	lui	s3,0xfffff
    80000fec:	964e                	add	a2,a2,s3
    80000fee:	00b609b3          	add	s3,a2,a1
  a = va;
    80000ff2:	892e                	mv	s2,a1
    80000ff4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000ff8:	6b85                	lui	s7,0x1
    80000ffa:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000ffe:	4605                	li	a2,1
    80001000:	85ca                	mv	a1,s2
    80001002:	8556                	mv	a0,s5
    80001004:	ee7ff0ef          	jal	ra,80000eea <walk>
    80001008:	c539                	beqz	a0,80001056 <mappages+0x94>
    if(*pte & PTE_V)
    8000100a:	611c                	ld	a5,0(a0)
    8000100c:	8b85                	andi	a5,a5,1
    8000100e:	ef95                	bnez	a5,8000104a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001010:	80b1                	srli	s1,s1,0xc
    80001012:	04aa                	slli	s1,s1,0xa
    80001014:	0164e4b3          	or	s1,s1,s6
    80001018:	0014e493          	ori	s1,s1,1
    8000101c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000101e:	05390863          	beq	s2,s3,8000106e <mappages+0xac>
    a += PGSIZE;
    80001022:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001024:	bfd9                	j	80000ffa <mappages+0x38>
    panic("mappages: va not aligned");
    80001026:	00006517          	auipc	a0,0x6
    8000102a:	0aa50513          	addi	a0,a0,170 # 800070d0 <digits+0x98>
    8000102e:	f28ff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size not aligned");
    80001032:	00006517          	auipc	a0,0x6
    80001036:	0be50513          	addi	a0,a0,190 # 800070f0 <digits+0xb8>
    8000103a:	f1cff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size");
    8000103e:	00006517          	auipc	a0,0x6
    80001042:	0d250513          	addi	a0,a0,210 # 80007110 <digits+0xd8>
    80001046:	f10ff0ef          	jal	ra,80000756 <panic>
      panic("mappages: remap");
    8000104a:	00006517          	auipc	a0,0x6
    8000104e:	0d650513          	addi	a0,a0,214 # 80007120 <digits+0xe8>
    80001052:	f04ff0ef          	jal	ra,80000756 <panic>
      return -1;
    80001056:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001058:	60a6                	ld	ra,72(sp)
    8000105a:	6406                	ld	s0,64(sp)
    8000105c:	74e2                	ld	s1,56(sp)
    8000105e:	7942                	ld	s2,48(sp)
    80001060:	79a2                	ld	s3,40(sp)
    80001062:	7a02                	ld	s4,32(sp)
    80001064:	6ae2                	ld	s5,24(sp)
    80001066:	6b42                	ld	s6,16(sp)
    80001068:	6ba2                	ld	s7,8(sp)
    8000106a:	6161                	addi	sp,sp,80
    8000106c:	8082                	ret
  return 0;
    8000106e:	4501                	li	a0,0
    80001070:	b7e5                	j	80001058 <mappages+0x96>

0000000080001072 <kvmmap>:
{
    80001072:	1141                	addi	sp,sp,-16
    80001074:	e406                	sd	ra,8(sp)
    80001076:	e022                	sd	s0,0(sp)
    80001078:	0800                	addi	s0,sp,16
    8000107a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000107c:	86b2                	mv	a3,a2
    8000107e:	863e                	mv	a2,a5
    80001080:	f43ff0ef          	jal	ra,80000fc2 <mappages>
    80001084:	e509                	bnez	a0,8000108e <kvmmap+0x1c>
}
    80001086:	60a2                	ld	ra,8(sp)
    80001088:	6402                	ld	s0,0(sp)
    8000108a:	0141                	addi	sp,sp,16
    8000108c:	8082                	ret
    panic("kvmmap");
    8000108e:	00006517          	auipc	a0,0x6
    80001092:	0a250513          	addi	a0,a0,162 # 80007130 <digits+0xf8>
    80001096:	ec0ff0ef          	jal	ra,80000756 <panic>

000000008000109a <kvmmake>:
{
    8000109a:	1101                	addi	sp,sp,-32
    8000109c:	ec06                	sd	ra,24(sp)
    8000109e:	e822                	sd	s0,16(sp)
    800010a0:	e426                	sd	s1,8(sp)
    800010a2:	e04a                	sd	s2,0(sp)
    800010a4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010a6:	a25ff0ef          	jal	ra,80000aca <kalloc>
    800010aa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010ac:	6605                	lui	a2,0x1
    800010ae:	4581                	li	a1,0
    800010b0:	bbfff0ef          	jal	ra,80000c6e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010b4:	4719                	li	a4,6
    800010b6:	6685                	lui	a3,0x1
    800010b8:	10000637          	lui	a2,0x10000
    800010bc:	100005b7          	lui	a1,0x10000
    800010c0:	8526                	mv	a0,s1
    800010c2:	fb1ff0ef          	jal	ra,80001072 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010c6:	4719                	li	a4,6
    800010c8:	6685                	lui	a3,0x1
    800010ca:	10001637          	lui	a2,0x10001
    800010ce:	100015b7          	lui	a1,0x10001
    800010d2:	8526                	mv	a0,s1
    800010d4:	f9fff0ef          	jal	ra,80001072 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010d8:	4719                	li	a4,6
    800010da:	040006b7          	lui	a3,0x4000
    800010de:	0c000637          	lui	a2,0xc000
    800010e2:	0c0005b7          	lui	a1,0xc000
    800010e6:	8526                	mv	a0,s1
    800010e8:	f8bff0ef          	jal	ra,80001072 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010ec:	00006917          	auipc	s2,0x6
    800010f0:	f1490913          	addi	s2,s2,-236 # 80007000 <etext>
    800010f4:	4729                	li	a4,10
    800010f6:	80006697          	auipc	a3,0x80006
    800010fa:	f0a68693          	addi	a3,a3,-246 # 7000 <_entry-0x7fff9000>
    800010fe:	4605                	li	a2,1
    80001100:	067e                	slli	a2,a2,0x1f
    80001102:	85b2                	mv	a1,a2
    80001104:	8526                	mv	a0,s1
    80001106:	f6dff0ef          	jal	ra,80001072 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000110a:	4719                	li	a4,6
    8000110c:	46c5                	li	a3,17
    8000110e:	06ee                	slli	a3,a3,0x1b
    80001110:	412686b3          	sub	a3,a3,s2
    80001114:	864a                	mv	a2,s2
    80001116:	85ca                	mv	a1,s2
    80001118:	8526                	mv	a0,s1
    8000111a:	f59ff0ef          	jal	ra,80001072 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000111e:	4729                	li	a4,10
    80001120:	6685                	lui	a3,0x1
    80001122:	00005617          	auipc	a2,0x5
    80001126:	ede60613          	addi	a2,a2,-290 # 80006000 <_trampoline>
    8000112a:	040005b7          	lui	a1,0x4000
    8000112e:	15fd                	addi	a1,a1,-1
    80001130:	05b2                	slli	a1,a1,0xc
    80001132:	8526                	mv	a0,s1
    80001134:	f3fff0ef          	jal	ra,80001072 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001138:	8526                	mv	a0,s1
    8000113a:	594000ef          	jal	ra,800016ce <proc_mapstacks>
}
    8000113e:	8526                	mv	a0,s1
    80001140:	60e2                	ld	ra,24(sp)
    80001142:	6442                	ld	s0,16(sp)
    80001144:	64a2                	ld	s1,8(sp)
    80001146:	6902                	ld	s2,0(sp)
    80001148:	6105                	addi	sp,sp,32
    8000114a:	8082                	ret

000000008000114c <kvminit>:
{
    8000114c:	1141                	addi	sp,sp,-16
    8000114e:	e406                	sd	ra,8(sp)
    80001150:	e022                	sd	s0,0(sp)
    80001152:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001154:	f47ff0ef          	jal	ra,8000109a <kvmmake>
    80001158:	00006797          	auipc	a5,0x6
    8000115c:	7aa7bc23          	sd	a0,1976(a5) # 80007910 <kernel_pagetable>
}
    80001160:	60a2                	ld	ra,8(sp)
    80001162:	6402                	ld	s0,0(sp)
    80001164:	0141                	addi	sp,sp,16
    80001166:	8082                	ret

0000000080001168 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001168:	715d                	addi	sp,sp,-80
    8000116a:	e486                	sd	ra,72(sp)
    8000116c:	e0a2                	sd	s0,64(sp)
    8000116e:	fc26                	sd	s1,56(sp)
    80001170:	f84a                	sd	s2,48(sp)
    80001172:	f44e                	sd	s3,40(sp)
    80001174:	f052                	sd	s4,32(sp)
    80001176:	ec56                	sd	s5,24(sp)
    80001178:	e85a                	sd	s6,16(sp)
    8000117a:	e45e                	sd	s7,8(sp)
    8000117c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000117e:	03459793          	slli	a5,a1,0x34
    80001182:	e795                	bnez	a5,800011ae <uvmunmap+0x46>
    80001184:	8a2a                	mv	s4,a0
    80001186:	892e                	mv	s2,a1
    80001188:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000118a:	0632                	slli	a2,a2,0xc
    8000118c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001190:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001192:	6b05                	lui	s6,0x1
    80001194:	0535ea63          	bltu	a1,s3,800011e8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001198:	60a6                	ld	ra,72(sp)
    8000119a:	6406                	ld	s0,64(sp)
    8000119c:	74e2                	ld	s1,56(sp)
    8000119e:	7942                	ld	s2,48(sp)
    800011a0:	79a2                	ld	s3,40(sp)
    800011a2:	7a02                	ld	s4,32(sp)
    800011a4:	6ae2                	ld	s5,24(sp)
    800011a6:	6b42                	ld	s6,16(sp)
    800011a8:	6ba2                	ld	s7,8(sp)
    800011aa:	6161                	addi	sp,sp,80
    800011ac:	8082                	ret
    panic("uvmunmap: not aligned");
    800011ae:	00006517          	auipc	a0,0x6
    800011b2:	f8a50513          	addi	a0,a0,-118 # 80007138 <digits+0x100>
    800011b6:	da0ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: walk");
    800011ba:	00006517          	auipc	a0,0x6
    800011be:	f9650513          	addi	a0,a0,-106 # 80007150 <digits+0x118>
    800011c2:	d94ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not mapped");
    800011c6:	00006517          	auipc	a0,0x6
    800011ca:	f9a50513          	addi	a0,a0,-102 # 80007160 <digits+0x128>
    800011ce:	d88ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not a leaf");
    800011d2:	00006517          	auipc	a0,0x6
    800011d6:	fa650513          	addi	a0,a0,-90 # 80007178 <digits+0x140>
    800011da:	d7cff0ef          	jal	ra,80000756 <panic>
    *pte = 0;
    800011de:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	995a                	add	s2,s2,s6
    800011e4:	fb397ae3          	bgeu	s2,s3,80001198 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800011e8:	4601                	li	a2,0
    800011ea:	85ca                	mv	a1,s2
    800011ec:	8552                	mv	a0,s4
    800011ee:	cfdff0ef          	jal	ra,80000eea <walk>
    800011f2:	84aa                	mv	s1,a0
    800011f4:	d179                	beqz	a0,800011ba <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800011f6:	6108                	ld	a0,0(a0)
    800011f8:	00157793          	andi	a5,a0,1
    800011fc:	d7e9                	beqz	a5,800011c6 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800011fe:	3ff57793          	andi	a5,a0,1023
    80001202:	fd7788e3          	beq	a5,s7,800011d2 <uvmunmap+0x6a>
    if(do_free){
    80001206:	fc0a8ce3          	beqz	s5,800011de <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    8000120a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000120c:	0532                	slli	a0,a0,0xc
    8000120e:	fdcff0ef          	jal	ra,800009ea <kfree>
    80001212:	b7f1                	j	800011de <uvmunmap+0x76>

0000000080001214 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001214:	1101                	addi	sp,sp,-32
    80001216:	ec06                	sd	ra,24(sp)
    80001218:	e822                	sd	s0,16(sp)
    8000121a:	e426                	sd	s1,8(sp)
    8000121c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000121e:	8adff0ef          	jal	ra,80000aca <kalloc>
    80001222:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001224:	c509                	beqz	a0,8000122e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001226:	6605                	lui	a2,0x1
    80001228:	4581                	li	a1,0
    8000122a:	a45ff0ef          	jal	ra,80000c6e <memset>
  return pagetable;
}
    8000122e:	8526                	mv	a0,s1
    80001230:	60e2                	ld	ra,24(sp)
    80001232:	6442                	ld	s0,16(sp)
    80001234:	64a2                	ld	s1,8(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret

000000008000123a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000123a:	7179                	addi	sp,sp,-48
    8000123c:	f406                	sd	ra,40(sp)
    8000123e:	f022                	sd	s0,32(sp)
    80001240:	ec26                	sd	s1,24(sp)
    80001242:	e84a                	sd	s2,16(sp)
    80001244:	e44e                	sd	s3,8(sp)
    80001246:	e052                	sd	s4,0(sp)
    80001248:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000124a:	6785                	lui	a5,0x1
    8000124c:	04f67063          	bgeu	a2,a5,8000128c <uvmfirst+0x52>
    80001250:	8a2a                	mv	s4,a0
    80001252:	89ae                	mv	s3,a1
    80001254:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001256:	875ff0ef          	jal	ra,80000aca <kalloc>
    8000125a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000125c:	6605                	lui	a2,0x1
    8000125e:	4581                	li	a1,0
    80001260:	a0fff0ef          	jal	ra,80000c6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001264:	4779                	li	a4,30
    80001266:	86ca                	mv	a3,s2
    80001268:	6605                	lui	a2,0x1
    8000126a:	4581                	li	a1,0
    8000126c:	8552                	mv	a0,s4
    8000126e:	d55ff0ef          	jal	ra,80000fc2 <mappages>
  memmove(mem, src, sz);
    80001272:	8626                	mv	a2,s1
    80001274:	85ce                	mv	a1,s3
    80001276:	854a                	mv	a0,s2
    80001278:	a53ff0ef          	jal	ra,80000cca <memmove>
}
    8000127c:	70a2                	ld	ra,40(sp)
    8000127e:	7402                	ld	s0,32(sp)
    80001280:	64e2                	ld	s1,24(sp)
    80001282:	6942                	ld	s2,16(sp)
    80001284:	69a2                	ld	s3,8(sp)
    80001286:	6a02                	ld	s4,0(sp)
    80001288:	6145                	addi	sp,sp,48
    8000128a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000128c:	00006517          	auipc	a0,0x6
    80001290:	f0450513          	addi	a0,a0,-252 # 80007190 <digits+0x158>
    80001294:	cc2ff0ef          	jal	ra,80000756 <panic>

0000000080001298 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001298:	1101                	addi	sp,sp,-32
    8000129a:	ec06                	sd	ra,24(sp)
    8000129c:	e822                	sd	s0,16(sp)
    8000129e:	e426                	sd	s1,8(sp)
    800012a0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012a2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012a4:	00b67d63          	bgeu	a2,a1,800012be <uvmdealloc+0x26>
    800012a8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012aa:	6785                	lui	a5,0x1
    800012ac:	17fd                	addi	a5,a5,-1
    800012ae:	00f60733          	add	a4,a2,a5
    800012b2:	767d                	lui	a2,0xfffff
    800012b4:	8f71                	and	a4,a4,a2
    800012b6:	97ae                	add	a5,a5,a1
    800012b8:	8ff1                	and	a5,a5,a2
    800012ba:	00f76863          	bltu	a4,a5,800012ca <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012be:	8526                	mv	a0,s1
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ca:	8f99                	sub	a5,a5,a4
    800012cc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012ce:	4685                	li	a3,1
    800012d0:	0007861b          	sext.w	a2,a5
    800012d4:	85ba                	mv	a1,a4
    800012d6:	e93ff0ef          	jal	ra,80001168 <uvmunmap>
    800012da:	b7d5                	j	800012be <uvmdealloc+0x26>

00000000800012dc <uvmalloc>:
  if(newsz < oldsz)
    800012dc:	08b66963          	bltu	a2,a1,8000136e <uvmalloc+0x92>
{
    800012e0:	7139                	addi	sp,sp,-64
    800012e2:	fc06                	sd	ra,56(sp)
    800012e4:	f822                	sd	s0,48(sp)
    800012e6:	f426                	sd	s1,40(sp)
    800012e8:	f04a                	sd	s2,32(sp)
    800012ea:	ec4e                	sd	s3,24(sp)
    800012ec:	e852                	sd	s4,16(sp)
    800012ee:	e456                	sd	s5,8(sp)
    800012f0:	e05a                	sd	s6,0(sp)
    800012f2:	0080                	addi	s0,sp,64
    800012f4:	8aaa                	mv	s5,a0
    800012f6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012f8:	6985                	lui	s3,0x1
    800012fa:	19fd                	addi	s3,s3,-1
    800012fc:	95ce                	add	a1,a1,s3
    800012fe:	79fd                	lui	s3,0xfffff
    80001300:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001304:	06c9f763          	bgeu	s3,a2,80001372 <uvmalloc+0x96>
    80001308:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000130a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000130e:	fbcff0ef          	jal	ra,80000aca <kalloc>
    80001312:	84aa                	mv	s1,a0
    if(mem == 0){
    80001314:	c11d                	beqz	a0,8000133a <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    80001316:	6605                	lui	a2,0x1
    80001318:	4581                	li	a1,0
    8000131a:	955ff0ef          	jal	ra,80000c6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000131e:	875a                	mv	a4,s6
    80001320:	86a6                	mv	a3,s1
    80001322:	6605                	lui	a2,0x1
    80001324:	85ca                	mv	a1,s2
    80001326:	8556                	mv	a0,s5
    80001328:	c9bff0ef          	jal	ra,80000fc2 <mappages>
    8000132c:	e51d                	bnez	a0,8000135a <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000132e:	6785                	lui	a5,0x1
    80001330:	993e                	add	s2,s2,a5
    80001332:	fd496ee3          	bltu	s2,s4,8000130e <uvmalloc+0x32>
  return newsz;
    80001336:	8552                	mv	a0,s4
    80001338:	a039                	j	80001346 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    8000133a:	864e                	mv	a2,s3
    8000133c:	85ca                	mv	a1,s2
    8000133e:	8556                	mv	a0,s5
    80001340:	f59ff0ef          	jal	ra,80001298 <uvmdealloc>
      return 0;
    80001344:	4501                	li	a0,0
}
    80001346:	70e2                	ld	ra,56(sp)
    80001348:	7442                	ld	s0,48(sp)
    8000134a:	74a2                	ld	s1,40(sp)
    8000134c:	7902                	ld	s2,32(sp)
    8000134e:	69e2                	ld	s3,24(sp)
    80001350:	6a42                	ld	s4,16(sp)
    80001352:	6aa2                	ld	s5,8(sp)
    80001354:	6b02                	ld	s6,0(sp)
    80001356:	6121                	addi	sp,sp,64
    80001358:	8082                	ret
      kfree(mem);
    8000135a:	8526                	mv	a0,s1
    8000135c:	e8eff0ef          	jal	ra,800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001360:	864e                	mv	a2,s3
    80001362:	85ca                	mv	a1,s2
    80001364:	8556                	mv	a0,s5
    80001366:	f33ff0ef          	jal	ra,80001298 <uvmdealloc>
      return 0;
    8000136a:	4501                	li	a0,0
    8000136c:	bfe9                	j	80001346 <uvmalloc+0x6a>
    return oldsz;
    8000136e:	852e                	mv	a0,a1
}
    80001370:	8082                	ret
  return newsz;
    80001372:	8532                	mv	a0,a2
    80001374:	bfc9                	j	80001346 <uvmalloc+0x6a>

0000000080001376 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001376:	7179                	addi	sp,sp,-48
    80001378:	f406                	sd	ra,40(sp)
    8000137a:	f022                	sd	s0,32(sp)
    8000137c:	ec26                	sd	s1,24(sp)
    8000137e:	e84a                	sd	s2,16(sp)
    80001380:	e44e                	sd	s3,8(sp)
    80001382:	e052                	sd	s4,0(sp)
    80001384:	1800                	addi	s0,sp,48
    80001386:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001388:	84aa                	mv	s1,a0
    8000138a:	6905                	lui	s2,0x1
    8000138c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000138e:	4985                	li	s3,1
    80001390:	a811                	j	800013a4 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001392:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001394:	0532                	slli	a0,a0,0xc
    80001396:	fe1ff0ef          	jal	ra,80001376 <freewalk>
      pagetable[i] = 0;
    8000139a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000139e:	04a1                	addi	s1,s1,8
    800013a0:	01248f63          	beq	s1,s2,800013be <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013a4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013a6:	00f57793          	andi	a5,a0,15
    800013aa:	ff3784e3          	beq	a5,s3,80001392 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013ae:	8905                	andi	a0,a0,1
    800013b0:	d57d                	beqz	a0,8000139e <freewalk+0x28>
      panic("freewalk: leaf");
    800013b2:	00006517          	auipc	a0,0x6
    800013b6:	dfe50513          	addi	a0,a0,-514 # 800071b0 <digits+0x178>
    800013ba:	b9cff0ef          	jal	ra,80000756 <panic>
    }
  }
  kfree((void*)pagetable);
    800013be:	8552                	mv	a0,s4
    800013c0:	e2aff0ef          	jal	ra,800009ea <kfree>
}
    800013c4:	70a2                	ld	ra,40(sp)
    800013c6:	7402                	ld	s0,32(sp)
    800013c8:	64e2                	ld	s1,24(sp)
    800013ca:	6942                	ld	s2,16(sp)
    800013cc:	69a2                	ld	s3,8(sp)
    800013ce:	6a02                	ld	s4,0(sp)
    800013d0:	6145                	addi	sp,sp,48
    800013d2:	8082                	ret

00000000800013d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013d4:	1101                	addi	sp,sp,-32
    800013d6:	ec06                	sd	ra,24(sp)
    800013d8:	e822                	sd	s0,16(sp)
    800013da:	e426                	sd	s1,8(sp)
    800013dc:	1000                	addi	s0,sp,32
    800013de:	84aa                	mv	s1,a0
  if(sz > 0)
    800013e0:	e989                	bnez	a1,800013f2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013e2:	8526                	mv	a0,s1
    800013e4:	f93ff0ef          	jal	ra,80001376 <freewalk>
}
    800013e8:	60e2                	ld	ra,24(sp)
    800013ea:	6442                	ld	s0,16(sp)
    800013ec:	64a2                	ld	s1,8(sp)
    800013ee:	6105                	addi	sp,sp,32
    800013f0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013f2:	6605                	lui	a2,0x1
    800013f4:	167d                	addi	a2,a2,-1
    800013f6:	962e                	add	a2,a2,a1
    800013f8:	4685                	li	a3,1
    800013fa:	8231                	srli	a2,a2,0xc
    800013fc:	4581                	li	a1,0
    800013fe:	d6bff0ef          	jal	ra,80001168 <uvmunmap>
    80001402:	b7c5                	j	800013e2 <uvmfree+0xe>

0000000080001404 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001404:	c65d                	beqz	a2,800014b2 <uvmcopy+0xae>
{
    80001406:	715d                	addi	sp,sp,-80
    80001408:	e486                	sd	ra,72(sp)
    8000140a:	e0a2                	sd	s0,64(sp)
    8000140c:	fc26                	sd	s1,56(sp)
    8000140e:	f84a                	sd	s2,48(sp)
    80001410:	f44e                	sd	s3,40(sp)
    80001412:	f052                	sd	s4,32(sp)
    80001414:	ec56                	sd	s5,24(sp)
    80001416:	e85a                	sd	s6,16(sp)
    80001418:	e45e                	sd	s7,8(sp)
    8000141a:	0880                	addi	s0,sp,80
    8000141c:	8b2a                	mv	s6,a0
    8000141e:	8aae                	mv	s5,a1
    80001420:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001422:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001424:	4601                	li	a2,0
    80001426:	85ce                	mv	a1,s3
    80001428:	855a                	mv	a0,s6
    8000142a:	ac1ff0ef          	jal	ra,80000eea <walk>
    8000142e:	c121                	beqz	a0,8000146e <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001430:	6118                	ld	a4,0(a0)
    80001432:	00177793          	andi	a5,a4,1
    80001436:	c3b1                	beqz	a5,8000147a <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001438:	00a75593          	srli	a1,a4,0xa
    8000143c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001440:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001444:	e86ff0ef          	jal	ra,80000aca <kalloc>
    80001448:	892a                	mv	s2,a0
    8000144a:	c129                	beqz	a0,8000148c <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000144c:	6605                	lui	a2,0x1
    8000144e:	85de                	mv	a1,s7
    80001450:	87bff0ef          	jal	ra,80000cca <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001454:	8726                	mv	a4,s1
    80001456:	86ca                	mv	a3,s2
    80001458:	6605                	lui	a2,0x1
    8000145a:	85ce                	mv	a1,s3
    8000145c:	8556                	mv	a0,s5
    8000145e:	b65ff0ef          	jal	ra,80000fc2 <mappages>
    80001462:	e115                	bnez	a0,80001486 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001464:	6785                	lui	a5,0x1
    80001466:	99be                	add	s3,s3,a5
    80001468:	fb49eee3          	bltu	s3,s4,80001424 <uvmcopy+0x20>
    8000146c:	a805                	j	8000149c <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    8000146e:	00006517          	auipc	a0,0x6
    80001472:	d5250513          	addi	a0,a0,-686 # 800071c0 <digits+0x188>
    80001476:	ae0ff0ef          	jal	ra,80000756 <panic>
      panic("uvmcopy: page not present");
    8000147a:	00006517          	auipc	a0,0x6
    8000147e:	d6650513          	addi	a0,a0,-666 # 800071e0 <digits+0x1a8>
    80001482:	ad4ff0ef          	jal	ra,80000756 <panic>
      kfree(mem);
    80001486:	854a                	mv	a0,s2
    80001488:	d62ff0ef          	jal	ra,800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000148c:	4685                	li	a3,1
    8000148e:	00c9d613          	srli	a2,s3,0xc
    80001492:	4581                	li	a1,0
    80001494:	8556                	mv	a0,s5
    80001496:	cd3ff0ef          	jal	ra,80001168 <uvmunmap>
  return -1;
    8000149a:	557d                	li	a0,-1
}
    8000149c:	60a6                	ld	ra,72(sp)
    8000149e:	6406                	ld	s0,64(sp)
    800014a0:	74e2                	ld	s1,56(sp)
    800014a2:	7942                	ld	s2,48(sp)
    800014a4:	79a2                	ld	s3,40(sp)
    800014a6:	7a02                	ld	s4,32(sp)
    800014a8:	6ae2                	ld	s5,24(sp)
    800014aa:	6b42                	ld	s6,16(sp)
    800014ac:	6ba2                	ld	s7,8(sp)
    800014ae:	6161                	addi	sp,sp,80
    800014b0:	8082                	ret
  return 0;
    800014b2:	4501                	li	a0,0
}
    800014b4:	8082                	ret

00000000800014b6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014b6:	1141                	addi	sp,sp,-16
    800014b8:	e406                	sd	ra,8(sp)
    800014ba:	e022                	sd	s0,0(sp)
    800014bc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014be:	4601                	li	a2,0
    800014c0:	a2bff0ef          	jal	ra,80000eea <walk>
  if(pte == 0)
    800014c4:	c901                	beqz	a0,800014d4 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014c6:	611c                	ld	a5,0(a0)
    800014c8:	9bbd                	andi	a5,a5,-17
    800014ca:	e11c                	sd	a5,0(a0)
}
    800014cc:	60a2                	ld	ra,8(sp)
    800014ce:	6402                	ld	s0,0(sp)
    800014d0:	0141                	addi	sp,sp,16
    800014d2:	8082                	ret
    panic("uvmclear");
    800014d4:	00006517          	auipc	a0,0x6
    800014d8:	d2c50513          	addi	a0,a0,-724 # 80007200 <digits+0x1c8>
    800014dc:	a7aff0ef          	jal	ra,80000756 <panic>

00000000800014e0 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800014e0:	c6c9                	beqz	a3,8000156a <copyout+0x8a>
{
    800014e2:	711d                	addi	sp,sp,-96
    800014e4:	ec86                	sd	ra,88(sp)
    800014e6:	e8a2                	sd	s0,80(sp)
    800014e8:	e4a6                	sd	s1,72(sp)
    800014ea:	e0ca                	sd	s2,64(sp)
    800014ec:	fc4e                	sd	s3,56(sp)
    800014ee:	f852                	sd	s4,48(sp)
    800014f0:	f456                	sd	s5,40(sp)
    800014f2:	f05a                	sd	s6,32(sp)
    800014f4:	ec5e                	sd	s7,24(sp)
    800014f6:	e862                	sd	s8,16(sp)
    800014f8:	e466                	sd	s9,8(sp)
    800014fa:	e06a                	sd	s10,0(sp)
    800014fc:	1080                	addi	s0,sp,96
    800014fe:	8baa                	mv	s7,a0
    80001500:	8aae                	mv	s5,a1
    80001502:	8b32                	mv	s6,a2
    80001504:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001506:	74fd                	lui	s1,0xfffff
    80001508:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    8000150a:	57fd                	li	a5,-1
    8000150c:	83e9                	srli	a5,a5,0x1a
    8000150e:	0697e063          	bltu	a5,s1,8000156e <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001512:	4cd5                	li	s9,21
    80001514:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001516:	8c3e                	mv	s8,a5
    80001518:	a025                	j	80001540 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000151a:	83a9                	srli	a5,a5,0xa
    8000151c:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000151e:	409a8533          	sub	a0,s5,s1
    80001522:	0009061b          	sext.w	a2,s2
    80001526:	85da                	mv	a1,s6
    80001528:	953e                	add	a0,a0,a5
    8000152a:	fa0ff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    8000152e:	412989b3          	sub	s3,s3,s2
    src += n;
    80001532:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80001534:	02098963          	beqz	s3,80001566 <copyout+0x86>
    if(va0 >= MAXVA)
    80001538:	034c6d63          	bltu	s8,s4,80001572 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    8000153c:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    8000153e:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001540:	4601                	li	a2,0
    80001542:	85a6                	mv	a1,s1
    80001544:	855e                	mv	a0,s7
    80001546:	9a5ff0ef          	jal	ra,80000eea <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000154a:	c515                	beqz	a0,80001576 <copyout+0x96>
    8000154c:	611c                	ld	a5,0(a0)
    8000154e:	0157f713          	andi	a4,a5,21
    80001552:	05971163          	bne	a4,s9,80001594 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001556:	01a48a33          	add	s4,s1,s10
    8000155a:	415a0933          	sub	s2,s4,s5
    if(n > len)
    8000155e:	fb29fee3          	bgeu	s3,s2,8000151a <copyout+0x3a>
    80001562:	894e                	mv	s2,s3
    80001564:	bf5d                	j	8000151a <copyout+0x3a>
  }
  return 0;
    80001566:	4501                	li	a0,0
    80001568:	a801                	j	80001578 <copyout+0x98>
    8000156a:	4501                	li	a0,0
}
    8000156c:	8082                	ret
      return -1;
    8000156e:	557d                	li	a0,-1
    80001570:	a021                	j	80001578 <copyout+0x98>
    80001572:	557d                	li	a0,-1
    80001574:	a011                	j	80001578 <copyout+0x98>
      return -1;
    80001576:	557d                	li	a0,-1
}
    80001578:	60e6                	ld	ra,88(sp)
    8000157a:	6446                	ld	s0,80(sp)
    8000157c:	64a6                	ld	s1,72(sp)
    8000157e:	6906                	ld	s2,64(sp)
    80001580:	79e2                	ld	s3,56(sp)
    80001582:	7a42                	ld	s4,48(sp)
    80001584:	7aa2                	ld	s5,40(sp)
    80001586:	7b02                	ld	s6,32(sp)
    80001588:	6be2                	ld	s7,24(sp)
    8000158a:	6c42                	ld	s8,16(sp)
    8000158c:	6ca2                	ld	s9,8(sp)
    8000158e:	6d02                	ld	s10,0(sp)
    80001590:	6125                	addi	sp,sp,96
    80001592:	8082                	ret
      return -1;
    80001594:	557d                	li	a0,-1
    80001596:	b7cd                	j	80001578 <copyout+0x98>

0000000080001598 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001598:	c6a5                	beqz	a3,80001600 <copyin+0x68>
{
    8000159a:	715d                	addi	sp,sp,-80
    8000159c:	e486                	sd	ra,72(sp)
    8000159e:	e0a2                	sd	s0,64(sp)
    800015a0:	fc26                	sd	s1,56(sp)
    800015a2:	f84a                	sd	s2,48(sp)
    800015a4:	f44e                	sd	s3,40(sp)
    800015a6:	f052                	sd	s4,32(sp)
    800015a8:	ec56                	sd	s5,24(sp)
    800015aa:	e85a                	sd	s6,16(sp)
    800015ac:	e45e                	sd	s7,8(sp)
    800015ae:	e062                	sd	s8,0(sp)
    800015b0:	0880                	addi	s0,sp,80
    800015b2:	8b2a                	mv	s6,a0
    800015b4:	8a2e                	mv	s4,a1
    800015b6:	8c32                	mv	s8,a2
    800015b8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015ba:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015bc:	6a85                	lui	s5,0x1
    800015be:	a00d                	j	800015e0 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015c0:	018505b3          	add	a1,a0,s8
    800015c4:	0004861b          	sext.w	a2,s1
    800015c8:	412585b3          	sub	a1,a1,s2
    800015cc:	8552                	mv	a0,s4
    800015ce:	efcff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    800015d2:	409989b3          	sub	s3,s3,s1
    dst += n;
    800015d6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800015d8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015dc:	02098063          	beqz	s3,800015fc <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800015e0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015e4:	85ca                	mv	a1,s2
    800015e6:	855a                	mv	a0,s6
    800015e8:	99dff0ef          	jal	ra,80000f84 <walkaddr>
    if(pa0 == 0)
    800015ec:	cd01                	beqz	a0,80001604 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800015ee:	418904b3          	sub	s1,s2,s8
    800015f2:	94d6                	add	s1,s1,s5
    if(n > len)
    800015f4:	fc99f6e3          	bgeu	s3,s1,800015c0 <copyin+0x28>
    800015f8:	84ce                	mv	s1,s3
    800015fa:	b7d9                	j	800015c0 <copyin+0x28>
  }
  return 0;
    800015fc:	4501                	li	a0,0
    800015fe:	a021                	j	80001606 <copyin+0x6e>
    80001600:	4501                	li	a0,0
}
    80001602:	8082                	ret
      return -1;
    80001604:	557d                	li	a0,-1
}
    80001606:	60a6                	ld	ra,72(sp)
    80001608:	6406                	ld	s0,64(sp)
    8000160a:	74e2                	ld	s1,56(sp)
    8000160c:	7942                	ld	s2,48(sp)
    8000160e:	79a2                	ld	s3,40(sp)
    80001610:	7a02                	ld	s4,32(sp)
    80001612:	6ae2                	ld	s5,24(sp)
    80001614:	6b42                	ld	s6,16(sp)
    80001616:	6ba2                	ld	s7,8(sp)
    80001618:	6c02                	ld	s8,0(sp)
    8000161a:	6161                	addi	sp,sp,80
    8000161c:	8082                	ret

000000008000161e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000161e:	c2d5                	beqz	a3,800016c2 <copyinstr+0xa4>
{
    80001620:	715d                	addi	sp,sp,-80
    80001622:	e486                	sd	ra,72(sp)
    80001624:	e0a2                	sd	s0,64(sp)
    80001626:	fc26                	sd	s1,56(sp)
    80001628:	f84a                	sd	s2,48(sp)
    8000162a:	f44e                	sd	s3,40(sp)
    8000162c:	f052                	sd	s4,32(sp)
    8000162e:	ec56                	sd	s5,24(sp)
    80001630:	e85a                	sd	s6,16(sp)
    80001632:	e45e                	sd	s7,8(sp)
    80001634:	0880                	addi	s0,sp,80
    80001636:	8a2a                	mv	s4,a0
    80001638:	8b2e                	mv	s6,a1
    8000163a:	8bb2                	mv	s7,a2
    8000163c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000163e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001640:	6985                	lui	s3,0x1
    80001642:	a035                	j	8000166e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001644:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001648:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000164a:	0017b793          	seqz	a5,a5
    8000164e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001652:	60a6                	ld	ra,72(sp)
    80001654:	6406                	ld	s0,64(sp)
    80001656:	74e2                	ld	s1,56(sp)
    80001658:	7942                	ld	s2,48(sp)
    8000165a:	79a2                	ld	s3,40(sp)
    8000165c:	7a02                	ld	s4,32(sp)
    8000165e:	6ae2                	ld	s5,24(sp)
    80001660:	6b42                	ld	s6,16(sp)
    80001662:	6ba2                	ld	s7,8(sp)
    80001664:	6161                	addi	sp,sp,80
    80001666:	8082                	ret
    srcva = va0 + PGSIZE;
    80001668:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000166c:	c4b9                	beqz	s1,800016ba <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    8000166e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001672:	85ca                	mv	a1,s2
    80001674:	8552                	mv	a0,s4
    80001676:	90fff0ef          	jal	ra,80000f84 <walkaddr>
    if(pa0 == 0)
    8000167a:	c131                	beqz	a0,800016be <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    8000167c:	41790833          	sub	a6,s2,s7
    80001680:	984e                	add	a6,a6,s3
    if(n > max)
    80001682:	0104f363          	bgeu	s1,a6,80001688 <copyinstr+0x6a>
    80001686:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001688:	955e                	add	a0,a0,s7
    8000168a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000168e:	fc080de3          	beqz	a6,80001668 <copyinstr+0x4a>
    80001692:	985a                	add	a6,a6,s6
    80001694:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001696:	41650633          	sub	a2,a0,s6
    8000169a:	14fd                	addi	s1,s1,-1
    8000169c:	9b26                	add	s6,s6,s1
    8000169e:	00f60733          	add	a4,a2,a5
    800016a2:	00074703          	lbu	a4,0(a4)
    800016a6:	df59                	beqz	a4,80001644 <copyinstr+0x26>
        *dst = *p;
    800016a8:	00e78023          	sb	a4,0(a5)
      --max;
    800016ac:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016b0:	0785                	addi	a5,a5,1
    while(n > 0){
    800016b2:	ff0796e3          	bne	a5,a6,8000169e <copyinstr+0x80>
      dst++;
    800016b6:	8b42                	mv	s6,a6
    800016b8:	bf45                	j	80001668 <copyinstr+0x4a>
    800016ba:	4781                	li	a5,0
    800016bc:	b779                	j	8000164a <copyinstr+0x2c>
      return -1;
    800016be:	557d                	li	a0,-1
    800016c0:	bf49                	j	80001652 <copyinstr+0x34>
  int got_null = 0;
    800016c2:	4781                	li	a5,0
  if(got_null){
    800016c4:	0017b793          	seqz	a5,a5
    800016c8:	40f00533          	neg	a0,a5
}
    800016cc:	8082                	ret

00000000800016ce <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016ce:	7139                	addi	sp,sp,-64
    800016d0:	fc06                	sd	ra,56(sp)
    800016d2:	f822                	sd	s0,48(sp)
    800016d4:	f426                	sd	s1,40(sp)
    800016d6:	f04a                	sd	s2,32(sp)
    800016d8:	ec4e                	sd	s3,24(sp)
    800016da:	e852                	sd	s4,16(sp)
    800016dc:	e456                	sd	s5,8(sp)
    800016de:	e05a                	sd	s6,0(sp)
    800016e0:	0080                	addi	s0,sp,64
    800016e2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e4:	00014497          	auipc	s1,0x14
    800016e8:	3b448493          	addi	s1,s1,948 # 80015a98 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016ec:	8b26                	mv	s6,s1
    800016ee:	00006a97          	auipc	s5,0x6
    800016f2:	912a8a93          	addi	s5,s5,-1774 # 80007000 <etext>
    800016f6:	04000937          	lui	s2,0x4000
    800016fa:	197d                	addi	s2,s2,-1
    800016fc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	0001aa17          	auipc	s4,0x1a
    80001702:	f9aa0a13          	addi	s4,s4,-102 # 8001b698 <tickslock>
    char *pa = kalloc();
    80001706:	bc4ff0ef          	jal	ra,80000aca <kalloc>
    8000170a:	862a                	mv	a2,a0
    if(pa == 0)
    8000170c:	c121                	beqz	a0,8000174c <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    8000170e:	416485b3          	sub	a1,s1,s6
    80001712:	8591                	srai	a1,a1,0x4
    80001714:	000ab783          	ld	a5,0(s5)
    80001718:	02f585b3          	mul	a1,a1,a5
    8000171c:	2585                	addiw	a1,a1,1
    8000171e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001722:	4719                	li	a4,6
    80001724:	6685                	lui	a3,0x1
    80001726:	40b905b3          	sub	a1,s2,a1
    8000172a:	854e                	mv	a0,s3
    8000172c:	947ff0ef          	jal	ra,80001072 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001730:	17048493          	addi	s1,s1,368
    80001734:	fd4499e3          	bne	s1,s4,80001706 <proc_mapstacks+0x38>
  }
}
    80001738:	70e2                	ld	ra,56(sp)
    8000173a:	7442                	ld	s0,48(sp)
    8000173c:	74a2                	ld	s1,40(sp)
    8000173e:	7902                	ld	s2,32(sp)
    80001740:	69e2                	ld	s3,24(sp)
    80001742:	6a42                	ld	s4,16(sp)
    80001744:	6aa2                	ld	s5,8(sp)
    80001746:	6b02                	ld	s6,0(sp)
    80001748:	6121                	addi	sp,sp,64
    8000174a:	8082                	ret
      panic("kalloc");
    8000174c:	00006517          	auipc	a0,0x6
    80001750:	ac450513          	addi	a0,a0,-1340 # 80007210 <digits+0x1d8>
    80001754:	802ff0ef          	jal	ra,80000756 <panic>

0000000080001758 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001758:	7139                	addi	sp,sp,-64
    8000175a:	fc06                	sd	ra,56(sp)
    8000175c:	f822                	sd	s0,48(sp)
    8000175e:	f426                	sd	s1,40(sp)
    80001760:	f04a                	sd	s2,32(sp)
    80001762:	ec4e                	sd	s3,24(sp)
    80001764:	e852                	sd	s4,16(sp)
    80001766:	e456                	sd	s5,8(sp)
    80001768:	e05a                	sd	s6,0(sp)
    8000176a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000176c:	00006597          	auipc	a1,0x6
    80001770:	aac58593          	addi	a1,a1,-1364 # 80007218 <digits+0x1e0>
    80001774:	0000e517          	auipc	a0,0xe
    80001778:	2dc50513          	addi	a0,a0,732 # 8000fa50 <pid_lock>
    8000177c:	b9eff0ef          	jal	ra,80000b1a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001780:	00006597          	auipc	a1,0x6
    80001784:	aa058593          	addi	a1,a1,-1376 # 80007220 <digits+0x1e8>
    80001788:	0000e517          	auipc	a0,0xe
    8000178c:	2e050513          	addi	a0,a0,736 # 8000fa68 <wait_lock>
    80001790:	b8aff0ef          	jal	ra,80000b1a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001794:	00014497          	auipc	s1,0x14
    80001798:	30448493          	addi	s1,s1,772 # 80015a98 <proc>
      initlock(&p->lock, "proc");
    8000179c:	00006b17          	auipc	s6,0x6
    800017a0:	a94b0b13          	addi	s6,s6,-1388 # 80007230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017a4:	8aa6                	mv	s5,s1
    800017a6:	00006a17          	auipc	s4,0x6
    800017aa:	85aa0a13          	addi	s4,s4,-1958 # 80007000 <etext>
    800017ae:	04000937          	lui	s2,0x4000
    800017b2:	197d                	addi	s2,s2,-1
    800017b4:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b6:	0001a997          	auipc	s3,0x1a
    800017ba:	ee298993          	addi	s3,s3,-286 # 8001b698 <tickslock>
      initlock(&p->lock, "proc");
    800017be:	85da                	mv	a1,s6
    800017c0:	8526                	mv	a0,s1
    800017c2:	b58ff0ef          	jal	ra,80000b1a <initlock>
      p->state = UNUSED;
    800017c6:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017ca:	415487b3          	sub	a5,s1,s5
    800017ce:	8791                	srai	a5,a5,0x4
    800017d0:	000a3703          	ld	a4,0(s4)
    800017d4:	02e787b3          	mul	a5,a5,a4
    800017d8:	2785                	addiw	a5,a5,1
    800017da:	00d7979b          	slliw	a5,a5,0xd
    800017de:	40f907b3          	sub	a5,s2,a5
    800017e2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e4:	17048493          	addi	s1,s1,368
    800017e8:	fd349be3          	bne	s1,s3,800017be <procinit+0x66>
  }
}
    800017ec:	70e2                	ld	ra,56(sp)
    800017ee:	7442                	ld	s0,48(sp)
    800017f0:	74a2                	ld	s1,40(sp)
    800017f2:	7902                	ld	s2,32(sp)
    800017f4:	69e2                	ld	s3,24(sp)
    800017f6:	6a42                	ld	s4,16(sp)
    800017f8:	6aa2                	ld	s5,8(sp)
    800017fa:	6b02                	ld	s6,0(sp)
    800017fc:	6121                	addi	sp,sp,64
    800017fe:	8082                	ret

0000000080001800 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001800:	1141                	addi	sp,sp,-16
    80001802:	e422                	sd	s0,8(sp)
    80001804:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001806:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001808:	2501                	sext.w	a0,a0
    8000180a:	6422                	ld	s0,8(sp)
    8000180c:	0141                	addi	sp,sp,16
    8000180e:	8082                	ret

0000000080001810 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001810:	1141                	addi	sp,sp,-16
    80001812:	e422                	sd	s0,8(sp)
    80001814:	0800                	addi	s0,sp,16
    80001816:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001818:	2781                	sext.w	a5,a5
    8000181a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000181c:	0000e517          	auipc	a0,0xe
    80001820:	26450513          	addi	a0,a0,612 # 8000fa80 <cpus>
    80001824:	953e                	add	a0,a0,a5
    80001826:	6422                	ld	s0,8(sp)
    80001828:	0141                	addi	sp,sp,16
    8000182a:	8082                	ret

000000008000182c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000182c:	1101                	addi	sp,sp,-32
    8000182e:	ec06                	sd	ra,24(sp)
    80001830:	e822                	sd	s0,16(sp)
    80001832:	e426                	sd	s1,8(sp)
    80001834:	1000                	addi	s0,sp,32
  push_off();
    80001836:	b24ff0ef          	jal	ra,80000b5a <push_off>
    8000183a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000183c:	2781                	sext.w	a5,a5
    8000183e:	079e                	slli	a5,a5,0x7
    80001840:	0000e717          	auipc	a4,0xe
    80001844:	21070713          	addi	a4,a4,528 # 8000fa50 <pid_lock>
    80001848:	97ba                	add	a5,a5,a4
    8000184a:	7b84                	ld	s1,48(a5)
  pop_off();
    8000184c:	b92ff0ef          	jal	ra,80000bde <pop_off>
  return p;
}
    80001850:	8526                	mv	a0,s1
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6105                	addi	sp,sp,32
    8000185a:	8082                	ret

000000008000185c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000185c:	1141                	addi	sp,sp,-16
    8000185e:	e406                	sd	ra,8(sp)
    80001860:	e022                	sd	s0,0(sp)
    80001862:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001864:	fc9ff0ef          	jal	ra,8000182c <myproc>
    80001868:	bcaff0ef          	jal	ra,80000c32 <release>

  if (first) {
    8000186c:	00006797          	auipc	a5,0x6
    80001870:	0347a783          	lw	a5,52(a5) # 800078a0 <first.1>
    80001874:	e799                	bnez	a5,80001882 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001876:	399000ef          	jal	ra,8000240e <usertrapret>
}
    8000187a:	60a2                	ld	ra,8(sp)
    8000187c:	6402                	ld	s0,0(sp)
    8000187e:	0141                	addi	sp,sp,16
    80001880:	8082                	ret
    fsinit(ROOTDEV);
    80001882:	4505                	li	a0,1
    80001884:	790010ef          	jal	ra,80003014 <fsinit>
    first = 0;
    80001888:	00006797          	auipc	a5,0x6
    8000188c:	0007ac23          	sw	zero,24(a5) # 800078a0 <first.1>
    __sync_synchronize();
    80001890:	0ff0000f          	fence
    80001894:	b7cd                	j	80001876 <forkret+0x1a>

0000000080001896 <allocpid>:
{
    80001896:	1101                	addi	sp,sp,-32
    80001898:	ec06                	sd	ra,24(sp)
    8000189a:	e822                	sd	s0,16(sp)
    8000189c:	e426                	sd	s1,8(sp)
    8000189e:	e04a                	sd	s2,0(sp)
    800018a0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018a2:	0000e917          	auipc	s2,0xe
    800018a6:	1ae90913          	addi	s2,s2,430 # 8000fa50 <pid_lock>
    800018aa:	854a                	mv	a0,s2
    800018ac:	aeeff0ef          	jal	ra,80000b9a <acquire>
  pid = nextpid;
    800018b0:	00006797          	auipc	a5,0x6
    800018b4:	ff478793          	addi	a5,a5,-12 # 800078a4 <nextpid>
    800018b8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018ba:	0014871b          	addiw	a4,s1,1
    800018be:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018c0:	854a                	mv	a0,s2
    800018c2:	b70ff0ef          	jal	ra,80000c32 <release>
}
    800018c6:	8526                	mv	a0,s1
    800018c8:	60e2                	ld	ra,24(sp)
    800018ca:	6442                	ld	s0,16(sp)
    800018cc:	64a2                	ld	s1,8(sp)
    800018ce:	6902                	ld	s2,0(sp)
    800018d0:	6105                	addi	sp,sp,32
    800018d2:	8082                	ret

00000000800018d4 <proc_pagetable>:
{
    800018d4:	1101                	addi	sp,sp,-32
    800018d6:	ec06                	sd	ra,24(sp)
    800018d8:	e822                	sd	s0,16(sp)
    800018da:	e426                	sd	s1,8(sp)
    800018dc:	e04a                	sd	s2,0(sp)
    800018de:	1000                	addi	s0,sp,32
    800018e0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018e2:	933ff0ef          	jal	ra,80001214 <uvmcreate>
    800018e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018e8:	cd05                	beqz	a0,80001920 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018ea:	4729                	li	a4,10
    800018ec:	00004697          	auipc	a3,0x4
    800018f0:	71468693          	addi	a3,a3,1812 # 80006000 <_trampoline>
    800018f4:	6605                	lui	a2,0x1
    800018f6:	040005b7          	lui	a1,0x4000
    800018fa:	15fd                	addi	a1,a1,-1
    800018fc:	05b2                	slli	a1,a1,0xc
    800018fe:	ec4ff0ef          	jal	ra,80000fc2 <mappages>
    80001902:	02054663          	bltz	a0,8000192e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001906:	4719                	li	a4,6
    80001908:	05893683          	ld	a3,88(s2)
    8000190c:	6605                	lui	a2,0x1
    8000190e:	020005b7          	lui	a1,0x2000
    80001912:	15fd                	addi	a1,a1,-1
    80001914:	05b6                	slli	a1,a1,0xd
    80001916:	8526                	mv	a0,s1
    80001918:	eaaff0ef          	jal	ra,80000fc2 <mappages>
    8000191c:	00054f63          	bltz	a0,8000193a <proc_pagetable+0x66>
}
    80001920:	8526                	mv	a0,s1
    80001922:	60e2                	ld	ra,24(sp)
    80001924:	6442                	ld	s0,16(sp)
    80001926:	64a2                	ld	s1,8(sp)
    80001928:	6902                	ld	s2,0(sp)
    8000192a:	6105                	addi	sp,sp,32
    8000192c:	8082                	ret
    uvmfree(pagetable, 0);
    8000192e:	4581                	li	a1,0
    80001930:	8526                	mv	a0,s1
    80001932:	aa3ff0ef          	jal	ra,800013d4 <uvmfree>
    return 0;
    80001936:	4481                	li	s1,0
    80001938:	b7e5                	j	80001920 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000193a:	4681                	li	a3,0
    8000193c:	4605                	li	a2,1
    8000193e:	040005b7          	lui	a1,0x4000
    80001942:	15fd                	addi	a1,a1,-1
    80001944:	05b2                	slli	a1,a1,0xc
    80001946:	8526                	mv	a0,s1
    80001948:	821ff0ef          	jal	ra,80001168 <uvmunmap>
    uvmfree(pagetable, 0);
    8000194c:	4581                	li	a1,0
    8000194e:	8526                	mv	a0,s1
    80001950:	a85ff0ef          	jal	ra,800013d4 <uvmfree>
    return 0;
    80001954:	4481                	li	s1,0
    80001956:	b7e9                	j	80001920 <proc_pagetable+0x4c>

0000000080001958 <proc_freepagetable>:
{
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	e426                	sd	s1,8(sp)
    80001960:	e04a                	sd	s2,0(sp)
    80001962:	1000                	addi	s0,sp,32
    80001964:	84aa                	mv	s1,a0
    80001966:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001968:	4681                	li	a3,0
    8000196a:	4605                	li	a2,1
    8000196c:	040005b7          	lui	a1,0x4000
    80001970:	15fd                	addi	a1,a1,-1
    80001972:	05b2                	slli	a1,a1,0xc
    80001974:	ff4ff0ef          	jal	ra,80001168 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001978:	4681                	li	a3,0
    8000197a:	4605                	li	a2,1
    8000197c:	020005b7          	lui	a1,0x2000
    80001980:	15fd                	addi	a1,a1,-1
    80001982:	05b6                	slli	a1,a1,0xd
    80001984:	8526                	mv	a0,s1
    80001986:	fe2ff0ef          	jal	ra,80001168 <uvmunmap>
  uvmfree(pagetable, sz);
    8000198a:	85ca                	mv	a1,s2
    8000198c:	8526                	mv	a0,s1
    8000198e:	a47ff0ef          	jal	ra,800013d4 <uvmfree>
}
    80001992:	60e2                	ld	ra,24(sp)
    80001994:	6442                	ld	s0,16(sp)
    80001996:	64a2                	ld	s1,8(sp)
    80001998:	6902                	ld	s2,0(sp)
    8000199a:	6105                	addi	sp,sp,32
    8000199c:	8082                	ret

000000008000199e <freeproc>:
{
    8000199e:	1101                	addi	sp,sp,-32
    800019a0:	ec06                	sd	ra,24(sp)
    800019a2:	e822                	sd	s0,16(sp)
    800019a4:	e426                	sd	s1,8(sp)
    800019a6:	1000                	addi	s0,sp,32
    800019a8:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019aa:	6d28                	ld	a0,88(a0)
    800019ac:	c119                	beqz	a0,800019b2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019ae:	83cff0ef          	jal	ra,800009ea <kfree>
  p->trapframe = 0;
    800019b2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019b6:	68a8                	ld	a0,80(s1)
    800019b8:	c501                	beqz	a0,800019c0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019ba:	64ac                	ld	a1,72(s1)
    800019bc:	f9dff0ef          	jal	ra,80001958 <proc_freepagetable>
  p->pagetable = 0;
    800019c0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019c4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019c8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019cc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019d0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800019d4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019d8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019dc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019e0:	0004ac23          	sw	zero,24(s1)
}
    800019e4:	60e2                	ld	ra,24(sp)
    800019e6:	6442                	ld	s0,16(sp)
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	6105                	addi	sp,sp,32
    800019ec:	8082                	ret

00000000800019ee <allocproc>:
{
    800019ee:	1101                	addi	sp,sp,-32
    800019f0:	ec06                	sd	ra,24(sp)
    800019f2:	e822                	sd	s0,16(sp)
    800019f4:	e426                	sd	s1,8(sp)
    800019f6:	e04a                	sd	s2,0(sp)
    800019f8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019fa:	00014497          	auipc	s1,0x14
    800019fe:	09e48493          	addi	s1,s1,158 # 80015a98 <proc>
    80001a02:	0001a917          	auipc	s2,0x1a
    80001a06:	c9690913          	addi	s2,s2,-874 # 8001b698 <tickslock>
    acquire(&p->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	98eff0ef          	jal	ra,80000b9a <acquire>
    if(p->state == UNUSED) {
    80001a10:	4c9c                	lw	a5,24(s1)
    80001a12:	cb91                	beqz	a5,80001a26 <allocproc+0x38>
      release(&p->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	a1cff0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a1a:	17048493          	addi	s1,s1,368
    80001a1e:	ff2496e3          	bne	s1,s2,80001a0a <allocproc+0x1c>
  return 0;
    80001a22:	4481                	li	s1,0
    80001a24:	a089                	j	80001a66 <allocproc+0x78>
  p->pid = allocpid();
    80001a26:	e71ff0ef          	jal	ra,80001896 <allocpid>
    80001a2a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a2c:	4785                	li	a5,1
    80001a2e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a30:	89aff0ef          	jal	ra,80000aca <kalloc>
    80001a34:	892a                	mv	s2,a0
    80001a36:	eca8                	sd	a0,88(s1)
    80001a38:	cd15                	beqz	a0,80001a74 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	e99ff0ef          	jal	ra,800018d4 <proc_pagetable>
    80001a40:	892a                	mv	s2,a0
    80001a42:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a44:	c121                	beqz	a0,80001a84 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a46:	07000613          	li	a2,112
    80001a4a:	4581                	li	a1,0
    80001a4c:	06048513          	addi	a0,s1,96
    80001a50:	a1eff0ef          	jal	ra,80000c6e <memset>
  p->context.ra = (uint64)forkret;
    80001a54:	00000797          	auipc	a5,0x0
    80001a58:	e0878793          	addi	a5,a5,-504 # 8000185c <forkret>
    80001a5c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a5e:	60bc                	ld	a5,64(s1)
    80001a60:	6705                	lui	a4,0x1
    80001a62:	97ba                	add	a5,a5,a4
    80001a64:	f4bc                	sd	a5,104(s1)
}
    80001a66:	8526                	mv	a0,s1
    80001a68:	60e2                	ld	ra,24(sp)
    80001a6a:	6442                	ld	s0,16(sp)
    80001a6c:	64a2                	ld	s1,8(sp)
    80001a6e:	6902                	ld	s2,0(sp)
    80001a70:	6105                	addi	sp,sp,32
    80001a72:	8082                	ret
    freeproc(p);
    80001a74:	8526                	mv	a0,s1
    80001a76:	f29ff0ef          	jal	ra,8000199e <freeproc>
    release(&p->lock);
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	9b6ff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001a80:	84ca                	mv	s1,s2
    80001a82:	b7d5                	j	80001a66 <allocproc+0x78>
    freeproc(p);
    80001a84:	8526                	mv	a0,s1
    80001a86:	f19ff0ef          	jal	ra,8000199e <freeproc>
    release(&p->lock);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	9a6ff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001a90:	84ca                	mv	s1,s2
    80001a92:	bfd1                	j	80001a66 <allocproc+0x78>

0000000080001a94 <userinit>:
{
    80001a94:	1101                	addi	sp,sp,-32
    80001a96:	ec06                	sd	ra,24(sp)
    80001a98:	e822                	sd	s0,16(sp)
    80001a9a:	e426                	sd	s1,8(sp)
    80001a9c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001a9e:	f51ff0ef          	jal	ra,800019ee <allocproc>
    80001aa2:	84aa                	mv	s1,a0
  initproc = p;
    80001aa4:	00006797          	auipc	a5,0x6
    80001aa8:	e6a7ba23          	sd	a0,-396(a5) # 80007918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001aac:	03400613          	li	a2,52
    80001ab0:	00006597          	auipc	a1,0x6
    80001ab4:	e0058593          	addi	a1,a1,-512 # 800078b0 <initcode>
    80001ab8:	6928                	ld	a0,80(a0)
    80001aba:	f80ff0ef          	jal	ra,8000123a <uvmfirst>
  p->sz = PGSIZE;
    80001abe:	6785                	lui	a5,0x1
    80001ac0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ac2:	6cb8                	ld	a4,88(s1)
    80001ac4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ac8:	6cb8                	ld	a4,88(s1)
    80001aca:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001acc:	4641                	li	a2,16
    80001ace:	00005597          	auipc	a1,0x5
    80001ad2:	76a58593          	addi	a1,a1,1898 # 80007238 <digits+0x200>
    80001ad6:	15848513          	addi	a0,s1,344
    80001ada:	adaff0ef          	jal	ra,80000db4 <safestrcpy>
  p->cwd = namei("/");
    80001ade:	00005517          	auipc	a0,0x5
    80001ae2:	76a50513          	addi	a0,a0,1898 # 80007248 <digits+0x210>
    80001ae6:	60f010ef          	jal	ra,800038f4 <namei>
    80001aea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001aee:	478d                	li	a5,3
    80001af0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001af2:	8526                	mv	a0,s1
    80001af4:	93eff0ef          	jal	ra,80000c32 <release>
}
    80001af8:	60e2                	ld	ra,24(sp)
    80001afa:	6442                	ld	s0,16(sp)
    80001afc:	64a2                	ld	s1,8(sp)
    80001afe:	6105                	addi	sp,sp,32
    80001b00:	8082                	ret

0000000080001b02 <growproc>:
{
    80001b02:	1101                	addi	sp,sp,-32
    80001b04:	ec06                	sd	ra,24(sp)
    80001b06:	e822                	sd	s0,16(sp)
    80001b08:	e426                	sd	s1,8(sp)
    80001b0a:	e04a                	sd	s2,0(sp)
    80001b0c:	1000                	addi	s0,sp,32
    80001b0e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b10:	d1dff0ef          	jal	ra,8000182c <myproc>
    80001b14:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b16:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b18:	01204c63          	bgtz	s2,80001b30 <growproc+0x2e>
  } else if(n < 0){
    80001b1c:	02094463          	bltz	s2,80001b44 <growproc+0x42>
  p->sz = sz;
    80001b20:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b22:	4501                	li	a0,0
}
    80001b24:	60e2                	ld	ra,24(sp)
    80001b26:	6442                	ld	s0,16(sp)
    80001b28:	64a2                	ld	s1,8(sp)
    80001b2a:	6902                	ld	s2,0(sp)
    80001b2c:	6105                	addi	sp,sp,32
    80001b2e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b30:	4691                	li	a3,4
    80001b32:	00b90633          	add	a2,s2,a1
    80001b36:	6928                	ld	a0,80(a0)
    80001b38:	fa4ff0ef          	jal	ra,800012dc <uvmalloc>
    80001b3c:	85aa                	mv	a1,a0
    80001b3e:	f16d                	bnez	a0,80001b20 <growproc+0x1e>
      return -1;
    80001b40:	557d                	li	a0,-1
    80001b42:	b7cd                	j	80001b24 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b44:	00b90633          	add	a2,s2,a1
    80001b48:	6928                	ld	a0,80(a0)
    80001b4a:	f4eff0ef          	jal	ra,80001298 <uvmdealloc>
    80001b4e:	85aa                	mv	a1,a0
    80001b50:	bfc1                	j	80001b20 <growproc+0x1e>

0000000080001b52 <fork>:
{
    80001b52:	7139                	addi	sp,sp,-64
    80001b54:	fc06                	sd	ra,56(sp)
    80001b56:	f822                	sd	s0,48(sp)
    80001b58:	f426                	sd	s1,40(sp)
    80001b5a:	f04a                	sd	s2,32(sp)
    80001b5c:	ec4e                	sd	s3,24(sp)
    80001b5e:	e852                	sd	s4,16(sp)
    80001b60:	e456                	sd	s5,8(sp)
    80001b62:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b64:	cc9ff0ef          	jal	ra,8000182c <myproc>
    80001b68:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b6a:	e85ff0ef          	jal	ra,800019ee <allocproc>
    80001b6e:	0e050663          	beqz	a0,80001c5a <fork+0x108>
    80001b72:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b74:	048ab603          	ld	a2,72(s5)
    80001b78:	692c                	ld	a1,80(a0)
    80001b7a:	050ab503          	ld	a0,80(s5)
    80001b7e:	887ff0ef          	jal	ra,80001404 <uvmcopy>
    80001b82:	04054863          	bltz	a0,80001bd2 <fork+0x80>
  np->sz = p->sz;
    80001b86:	048ab783          	ld	a5,72(s5)
    80001b8a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001b8e:	058ab683          	ld	a3,88(s5)
    80001b92:	87b6                	mv	a5,a3
    80001b94:	058a3703          	ld	a4,88(s4)
    80001b98:	12068693          	addi	a3,a3,288
    80001b9c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ba0:	6788                	ld	a0,8(a5)
    80001ba2:	6b8c                	ld	a1,16(a5)
    80001ba4:	6f90                	ld	a2,24(a5)
    80001ba6:	01073023          	sd	a6,0(a4)
    80001baa:	e708                	sd	a0,8(a4)
    80001bac:	eb0c                	sd	a1,16(a4)
    80001bae:	ef10                	sd	a2,24(a4)
    80001bb0:	02078793          	addi	a5,a5,32
    80001bb4:	02070713          	addi	a4,a4,32
    80001bb8:	fed792e3          	bne	a5,a3,80001b9c <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bbc:	058a3783          	ld	a5,88(s4)
    80001bc0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bc4:	0d0a8493          	addi	s1,s5,208
    80001bc8:	0d0a0913          	addi	s2,s4,208
    80001bcc:	150a8993          	addi	s3,s5,336
    80001bd0:	a829                	j	80001bea <fork+0x98>
    freeproc(np);
    80001bd2:	8552                	mv	a0,s4
    80001bd4:	dcbff0ef          	jal	ra,8000199e <freeproc>
    release(&np->lock);
    80001bd8:	8552                	mv	a0,s4
    80001bda:	858ff0ef          	jal	ra,80000c32 <release>
    return -1;
    80001bde:	597d                	li	s2,-1
    80001be0:	a09d                	j	80001c46 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001be2:	04a1                	addi	s1,s1,8
    80001be4:	0921                	addi	s2,s2,8
    80001be6:	01348963          	beq	s1,s3,80001bf8 <fork+0xa6>
    if(p->ofile[i])
    80001bea:	6088                	ld	a0,0(s1)
    80001bec:	d97d                	beqz	a0,80001be2 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bee:	2b4020ef          	jal	ra,80003ea2 <filedup>
    80001bf2:	00a93023          	sd	a0,0(s2)
    80001bf6:	b7f5                	j	80001be2 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001bf8:	150ab503          	ld	a0,336(s5)
    80001bfc:	60e010ef          	jal	ra,8000320a <idup>
    80001c00:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c04:	4641                	li	a2,16
    80001c06:	158a8593          	addi	a1,s5,344
    80001c0a:	158a0513          	addi	a0,s4,344
    80001c0e:	9a6ff0ef          	jal	ra,80000db4 <safestrcpy>
  pid = np->pid;
    80001c12:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c16:	8552                	mv	a0,s4
    80001c18:	81aff0ef          	jal	ra,80000c32 <release>
  acquire(&wait_lock);
    80001c1c:	0000e497          	auipc	s1,0xe
    80001c20:	e4c48493          	addi	s1,s1,-436 # 8000fa68 <wait_lock>
    80001c24:	8526                	mv	a0,s1
    80001c26:	f75fe0ef          	jal	ra,80000b9a <acquire>
  np->parent = p;
    80001c2a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	802ff0ef          	jal	ra,80000c32 <release>
  acquire(&np->lock);
    80001c34:	8552                	mv	a0,s4
    80001c36:	f65fe0ef          	jal	ra,80000b9a <acquire>
  np->state = RUNNABLE;
    80001c3a:	478d                	li	a5,3
    80001c3c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c40:	8552                	mv	a0,s4
    80001c42:	ff1fe0ef          	jal	ra,80000c32 <release>
}
    80001c46:	854a                	mv	a0,s2
    80001c48:	70e2                	ld	ra,56(sp)
    80001c4a:	7442                	ld	s0,48(sp)
    80001c4c:	74a2                	ld	s1,40(sp)
    80001c4e:	7902                	ld	s2,32(sp)
    80001c50:	69e2                	ld	s3,24(sp)
    80001c52:	6a42                	ld	s4,16(sp)
    80001c54:	6aa2                	ld	s5,8(sp)
    80001c56:	6121                	addi	sp,sp,64
    80001c58:	8082                	ret
    return -1;
    80001c5a:	597d                	li	s2,-1
    80001c5c:	b7ed                	j	80001c46 <fork+0xf4>

0000000080001c5e <scheduler>:
{
    80001c5e:	715d                	addi	sp,sp,-80
    80001c60:	e486                	sd	ra,72(sp)
    80001c62:	e0a2                	sd	s0,64(sp)
    80001c64:	fc26                	sd	s1,56(sp)
    80001c66:	f84a                	sd	s2,48(sp)
    80001c68:	f44e                	sd	s3,40(sp)
    80001c6a:	f052                	sd	s4,32(sp)
    80001c6c:	ec56                	sd	s5,24(sp)
    80001c6e:	e85a                	sd	s6,16(sp)
    80001c70:	e45e                	sd	s7,8(sp)
    80001c72:	e062                	sd	s8,0(sp)
    80001c74:	0880                	addi	s0,sp,80
    80001c76:	8792                	mv	a5,tp
  int id = r_tp();
    80001c78:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c7a:	00779b13          	slli	s6,a5,0x7
    80001c7e:	0000e717          	auipc	a4,0xe
    80001c82:	dd270713          	addi	a4,a4,-558 # 8000fa50 <pid_lock>
    80001c86:	975a                	add	a4,a4,s6
    80001c88:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c8c:	0000e717          	auipc	a4,0xe
    80001c90:	dfc70713          	addi	a4,a4,-516 # 8000fa88 <cpus+0x8>
    80001c94:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001c96:	4c11                	li	s8,4
        c->proc = p;
    80001c98:	079e                	slli	a5,a5,0x7
    80001c9a:	0000ea17          	auipc	s4,0xe
    80001c9e:	db6a0a13          	addi	s4,s4,-586 # 8000fa50 <pid_lock>
    80001ca2:	9a3e                	add	s4,s4,a5
        found = 1;
    80001ca4:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ca6:	0001a997          	auipc	s3,0x1a
    80001caa:	9f298993          	addi	s3,s3,-1550 # 8001b698 <tickslock>
    80001cae:	a0a9                	j	80001cf8 <scheduler+0x9a>
      release(&p->lock);
    80001cb0:	8526                	mv	a0,s1
    80001cb2:	f81fe0ef          	jal	ra,80000c32 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cb6:	17048493          	addi	s1,s1,368
    80001cba:	03348563          	beq	s1,s3,80001ce4 <scheduler+0x86>
      acquire(&p->lock);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	edbfe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == RUNNABLE) {
    80001cc4:	4c9c                	lw	a5,24(s1)
    80001cc6:	ff2795e3          	bne	a5,s2,80001cb0 <scheduler+0x52>
        p->state = RUNNING;
    80001cca:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001cce:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001cd2:	06048593          	addi	a1,s1,96
    80001cd6:	855a                	mv	a0,s6
    80001cd8:	690000ef          	jal	ra,80002368 <swtch>
        c->proc = 0;
    80001cdc:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001ce0:	8ade                	mv	s5,s7
    80001ce2:	b7f9                	j	80001cb0 <scheduler+0x52>
    if(found == 0) {
    80001ce4:	000a9a63          	bnez	s5,80001cf8 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf0:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001cf4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cfc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d00:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d04:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d06:	00014497          	auipc	s1,0x14
    80001d0a:	d9248493          	addi	s1,s1,-622 # 80015a98 <proc>
      if(p->state == RUNNABLE) {
    80001d0e:	490d                	li	s2,3
    80001d10:	b77d                	j	80001cbe <scheduler+0x60>

0000000080001d12 <sched>:
{
    80001d12:	7179                	addi	sp,sp,-48
    80001d14:	f406                	sd	ra,40(sp)
    80001d16:	f022                	sd	s0,32(sp)
    80001d18:	ec26                	sd	s1,24(sp)
    80001d1a:	e84a                	sd	s2,16(sp)
    80001d1c:	e44e                	sd	s3,8(sp)
    80001d1e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d20:	b0dff0ef          	jal	ra,8000182c <myproc>
    80001d24:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d26:	e0bfe0ef          	jal	ra,80000b30 <holding>
    80001d2a:	c92d                	beqz	a0,80001d9c <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d2c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d2e:	2781                	sext.w	a5,a5
    80001d30:	079e                	slli	a5,a5,0x7
    80001d32:	0000e717          	auipc	a4,0xe
    80001d36:	d1e70713          	addi	a4,a4,-738 # 8000fa50 <pid_lock>
    80001d3a:	97ba                	add	a5,a5,a4
    80001d3c:	0a87a703          	lw	a4,168(a5)
    80001d40:	4785                	li	a5,1
    80001d42:	06f71363          	bne	a4,a5,80001da8 <sched+0x96>
  if(p->state == RUNNING)
    80001d46:	4c98                	lw	a4,24(s1)
    80001d48:	4791                	li	a5,4
    80001d4a:	06f70563          	beq	a4,a5,80001db4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d52:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d54:	e7b5                	bnez	a5,80001dc0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d56:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d58:	0000e917          	auipc	s2,0xe
    80001d5c:	cf890913          	addi	s2,s2,-776 # 8000fa50 <pid_lock>
    80001d60:	2781                	sext.w	a5,a5
    80001d62:	079e                	slli	a5,a5,0x7
    80001d64:	97ca                	add	a5,a5,s2
    80001d66:	0ac7a983          	lw	s3,172(a5)
    80001d6a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d6c:	2781                	sext.w	a5,a5
    80001d6e:	079e                	slli	a5,a5,0x7
    80001d70:	0000e597          	auipc	a1,0xe
    80001d74:	d1858593          	addi	a1,a1,-744 # 8000fa88 <cpus+0x8>
    80001d78:	95be                	add	a1,a1,a5
    80001d7a:	06048513          	addi	a0,s1,96
    80001d7e:	5ea000ef          	jal	ra,80002368 <swtch>
    80001d82:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d84:	2781                	sext.w	a5,a5
    80001d86:	079e                	slli	a5,a5,0x7
    80001d88:	97ca                	add	a5,a5,s2
    80001d8a:	0b37a623          	sw	s3,172(a5)
}
    80001d8e:	70a2                	ld	ra,40(sp)
    80001d90:	7402                	ld	s0,32(sp)
    80001d92:	64e2                	ld	s1,24(sp)
    80001d94:	6942                	ld	s2,16(sp)
    80001d96:	69a2                	ld	s3,8(sp)
    80001d98:	6145                	addi	sp,sp,48
    80001d9a:	8082                	ret
    panic("sched p->lock");
    80001d9c:	00005517          	auipc	a0,0x5
    80001da0:	4b450513          	addi	a0,a0,1204 # 80007250 <digits+0x218>
    80001da4:	9b3fe0ef          	jal	ra,80000756 <panic>
    panic("sched locks");
    80001da8:	00005517          	auipc	a0,0x5
    80001dac:	4b850513          	addi	a0,a0,1208 # 80007260 <digits+0x228>
    80001db0:	9a7fe0ef          	jal	ra,80000756 <panic>
    panic("sched running");
    80001db4:	00005517          	auipc	a0,0x5
    80001db8:	4bc50513          	addi	a0,a0,1212 # 80007270 <digits+0x238>
    80001dbc:	99bfe0ef          	jal	ra,80000756 <panic>
    panic("sched interruptible");
    80001dc0:	00005517          	auipc	a0,0x5
    80001dc4:	4c050513          	addi	a0,a0,1216 # 80007280 <digits+0x248>
    80001dc8:	98ffe0ef          	jal	ra,80000756 <panic>

0000000080001dcc <yield>:
{
    80001dcc:	1101                	addi	sp,sp,-32
    80001dce:	ec06                	sd	ra,24(sp)
    80001dd0:	e822                	sd	s0,16(sp)
    80001dd2:	e426                	sd	s1,8(sp)
    80001dd4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001dd6:	a57ff0ef          	jal	ra,8000182c <myproc>
    80001dda:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ddc:	dbffe0ef          	jal	ra,80000b9a <acquire>
  p->state = RUNNABLE;
    80001de0:	478d                	li	a5,3
    80001de2:	cc9c                	sw	a5,24(s1)
  sched();
    80001de4:	f2fff0ef          	jal	ra,80001d12 <sched>
  release(&p->lock);
    80001de8:	8526                	mv	a0,s1
    80001dea:	e49fe0ef          	jal	ra,80000c32 <release>
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6105                	addi	sp,sp,32
    80001df6:	8082                	ret

0000000080001df8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001df8:	7179                	addi	sp,sp,-48
    80001dfa:	f406                	sd	ra,40(sp)
    80001dfc:	f022                	sd	s0,32(sp)
    80001dfe:	ec26                	sd	s1,24(sp)
    80001e00:	e84a                	sd	s2,16(sp)
    80001e02:	e44e                	sd	s3,8(sp)
    80001e04:	1800                	addi	s0,sp,48
    80001e06:	89aa                	mv	s3,a0
    80001e08:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e0a:	a23ff0ef          	jal	ra,8000182c <myproc>
    80001e0e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e10:	d8bfe0ef          	jal	ra,80000b9a <acquire>
  release(lk);
    80001e14:	854a                	mv	a0,s2
    80001e16:	e1dfe0ef          	jal	ra,80000c32 <release>

  // Go to sleep.
  p->chan = chan;
    80001e1a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e1e:	4789                	li	a5,2
    80001e20:	cc9c                	sw	a5,24(s1)

  sched();
    80001e22:	ef1ff0ef          	jal	ra,80001d12 <sched>

  // Tidy up.
  p->chan = 0;
    80001e26:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	e07fe0ef          	jal	ra,80000c32 <release>
  acquire(lk);
    80001e30:	854a                	mv	a0,s2
    80001e32:	d69fe0ef          	jal	ra,80000b9a <acquire>
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6145                	addi	sp,sp,48
    80001e42:	8082                	ret

0000000080001e44 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e44:	7139                	addi	sp,sp,-64
    80001e46:	fc06                	sd	ra,56(sp)
    80001e48:	f822                	sd	s0,48(sp)
    80001e4a:	f426                	sd	s1,40(sp)
    80001e4c:	f04a                	sd	s2,32(sp)
    80001e4e:	ec4e                	sd	s3,24(sp)
    80001e50:	e852                	sd	s4,16(sp)
    80001e52:	e456                	sd	s5,8(sp)
    80001e54:	0080                	addi	s0,sp,64
    80001e56:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e58:	00014497          	auipc	s1,0x14
    80001e5c:	c4048493          	addi	s1,s1,-960 # 80015a98 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e60:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e62:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e64:	0001a917          	auipc	s2,0x1a
    80001e68:	83490913          	addi	s2,s2,-1996 # 8001b698 <tickslock>
    80001e6c:	a801                	j	80001e7c <wakeup+0x38>
      }
      release(&p->lock);
    80001e6e:	8526                	mv	a0,s1
    80001e70:	dc3fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e74:	17048493          	addi	s1,s1,368
    80001e78:	03248263          	beq	s1,s2,80001e9c <wakeup+0x58>
    if(p != myproc()){
    80001e7c:	9b1ff0ef          	jal	ra,8000182c <myproc>
    80001e80:	fea48ae3          	beq	s1,a0,80001e74 <wakeup+0x30>
      acquire(&p->lock);
    80001e84:	8526                	mv	a0,s1
    80001e86:	d15fe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e8a:	4c9c                	lw	a5,24(s1)
    80001e8c:	ff3791e3          	bne	a5,s3,80001e6e <wakeup+0x2a>
    80001e90:	709c                	ld	a5,32(s1)
    80001e92:	fd479ee3          	bne	a5,s4,80001e6e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001e96:	0154ac23          	sw	s5,24(s1)
    80001e9a:	bfd1                	j	80001e6e <wakeup+0x2a>
    }
  }
}
    80001e9c:	70e2                	ld	ra,56(sp)
    80001e9e:	7442                	ld	s0,48(sp)
    80001ea0:	74a2                	ld	s1,40(sp)
    80001ea2:	7902                	ld	s2,32(sp)
    80001ea4:	69e2                	ld	s3,24(sp)
    80001ea6:	6a42                	ld	s4,16(sp)
    80001ea8:	6aa2                	ld	s5,8(sp)
    80001eaa:	6121                	addi	sp,sp,64
    80001eac:	8082                	ret

0000000080001eae <reparent>:
{
    80001eae:	7179                	addi	sp,sp,-48
    80001eb0:	f406                	sd	ra,40(sp)
    80001eb2:	f022                	sd	s0,32(sp)
    80001eb4:	ec26                	sd	s1,24(sp)
    80001eb6:	e84a                	sd	s2,16(sp)
    80001eb8:	e44e                	sd	s3,8(sp)
    80001eba:	e052                	sd	s4,0(sp)
    80001ebc:	1800                	addi	s0,sp,48
    80001ebe:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ec0:	00014497          	auipc	s1,0x14
    80001ec4:	bd848493          	addi	s1,s1,-1064 # 80015a98 <proc>
      pp->parent = initproc;
    80001ec8:	00006a17          	auipc	s4,0x6
    80001ecc:	a50a0a13          	addi	s4,s4,-1456 # 80007918 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ed0:	00019997          	auipc	s3,0x19
    80001ed4:	7c898993          	addi	s3,s3,1992 # 8001b698 <tickslock>
    80001ed8:	a029                	j	80001ee2 <reparent+0x34>
    80001eda:	17048493          	addi	s1,s1,368
    80001ede:	01348b63          	beq	s1,s3,80001ef4 <reparent+0x46>
    if(pp->parent == p){
    80001ee2:	7c9c                	ld	a5,56(s1)
    80001ee4:	ff279be3          	bne	a5,s2,80001eda <reparent+0x2c>
      pp->parent = initproc;
    80001ee8:	000a3503          	ld	a0,0(s4)
    80001eec:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001eee:	f57ff0ef          	jal	ra,80001e44 <wakeup>
    80001ef2:	b7e5                	j	80001eda <reparent+0x2c>
}
    80001ef4:	70a2                	ld	ra,40(sp)
    80001ef6:	7402                	ld	s0,32(sp)
    80001ef8:	64e2                	ld	s1,24(sp)
    80001efa:	6942                	ld	s2,16(sp)
    80001efc:	69a2                	ld	s3,8(sp)
    80001efe:	6a02                	ld	s4,0(sp)
    80001f00:	6145                	addi	sp,sp,48
    80001f02:	8082                	ret

0000000080001f04 <exit>:
{
    80001f04:	7179                	addi	sp,sp,-48
    80001f06:	f406                	sd	ra,40(sp)
    80001f08:	f022                	sd	s0,32(sp)
    80001f0a:	ec26                	sd	s1,24(sp)
    80001f0c:	e84a                	sd	s2,16(sp)
    80001f0e:	e44e                	sd	s3,8(sp)
    80001f10:	e052                	sd	s4,0(sp)
    80001f12:	1800                	addi	s0,sp,48
    80001f14:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f16:	917ff0ef          	jal	ra,8000182c <myproc>
    80001f1a:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f1c:	00006797          	auipc	a5,0x6
    80001f20:	9fc7b783          	ld	a5,-1540(a5) # 80007918 <initproc>
    80001f24:	0d050493          	addi	s1,a0,208
    80001f28:	15050913          	addi	s2,a0,336
    80001f2c:	00a79f63          	bne	a5,a0,80001f4a <exit+0x46>
    panic("init exiting");
    80001f30:	00005517          	auipc	a0,0x5
    80001f34:	36850513          	addi	a0,a0,872 # 80007298 <digits+0x260>
    80001f38:	81ffe0ef          	jal	ra,80000756 <panic>
      fileclose(f);
    80001f3c:	7ad010ef          	jal	ra,80003ee8 <fileclose>
      p->ofile[fd] = 0;
    80001f40:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f44:	04a1                	addi	s1,s1,8
    80001f46:	01248563          	beq	s1,s2,80001f50 <exit+0x4c>
    if(p->ofile[fd]){
    80001f4a:	6088                	ld	a0,0(s1)
    80001f4c:	f965                	bnez	a0,80001f3c <exit+0x38>
    80001f4e:	bfdd                	j	80001f44 <exit+0x40>
  begin_op();
    80001f50:	37d010ef          	jal	ra,80003acc <begin_op>
  iput(p->cwd);
    80001f54:	1509b503          	ld	a0,336(s3)
    80001f58:	466010ef          	jal	ra,800033be <iput>
  end_op();
    80001f5c:	3e1010ef          	jal	ra,80003b3c <end_op>
  p->cwd = 0;
    80001f60:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f64:	0000e497          	auipc	s1,0xe
    80001f68:	b0448493          	addi	s1,s1,-1276 # 8000fa68 <wait_lock>
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	c2dfe0ef          	jal	ra,80000b9a <acquire>
  reparent(p);
    80001f72:	854e                	mv	a0,s3
    80001f74:	f3bff0ef          	jal	ra,80001eae <reparent>
  wakeup(p->parent);
    80001f78:	0389b503          	ld	a0,56(s3)
    80001f7c:	ec9ff0ef          	jal	ra,80001e44 <wakeup>
  acquire(&p->lock);
    80001f80:	854e                	mv	a0,s3
    80001f82:	c19fe0ef          	jal	ra,80000b9a <acquire>
  p->xstate = status;
    80001f86:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f8a:	4795                	li	a5,5
    80001f8c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001f90:	8526                	mv	a0,s1
    80001f92:	ca1fe0ef          	jal	ra,80000c32 <release>
  sched();
    80001f96:	d7dff0ef          	jal	ra,80001d12 <sched>
  panic("zombie exit");
    80001f9a:	00005517          	auipc	a0,0x5
    80001f9e:	30e50513          	addi	a0,a0,782 # 800072a8 <digits+0x270>
    80001fa2:	fb4fe0ef          	jal	ra,80000756 <panic>

0000000080001fa6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	e44e                	sd	s3,8(sp)
    80001fb2:	1800                	addi	s0,sp,48
    80001fb4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fb6:	00014497          	auipc	s1,0x14
    80001fba:	ae248493          	addi	s1,s1,-1310 # 80015a98 <proc>
    80001fbe:	00019997          	auipc	s3,0x19
    80001fc2:	6da98993          	addi	s3,s3,1754 # 8001b698 <tickslock>
    acquire(&p->lock);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	bd3fe0ef          	jal	ra,80000b9a <acquire>
    if(p->pid == pid){
    80001fcc:	589c                	lw	a5,48(s1)
    80001fce:	01278b63          	beq	a5,s2,80001fe4 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	c5ffe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fd8:	17048493          	addi	s1,s1,368
    80001fdc:	ff3495e3          	bne	s1,s3,80001fc6 <kill+0x20>
  }
  return -1;
    80001fe0:	557d                	li	a0,-1
    80001fe2:	a819                	j	80001ff8 <kill+0x52>
      p->killed = 1;
    80001fe4:	4785                	li	a5,1
    80001fe6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001fe8:	4c98                	lw	a4,24(s1)
    80001fea:	4789                	li	a5,2
    80001fec:	00f70d63          	beq	a4,a5,80002006 <kill+0x60>
      release(&p->lock);
    80001ff0:	8526                	mv	a0,s1
    80001ff2:	c41fe0ef          	jal	ra,80000c32 <release>
      return 0;
    80001ff6:	4501                	li	a0,0
}
    80001ff8:	70a2                	ld	ra,40(sp)
    80001ffa:	7402                	ld	s0,32(sp)
    80001ffc:	64e2                	ld	s1,24(sp)
    80001ffe:	6942                	ld	s2,16(sp)
    80002000:	69a2                	ld	s3,8(sp)
    80002002:	6145                	addi	sp,sp,48
    80002004:	8082                	ret
        p->state = RUNNABLE;
    80002006:	478d                	li	a5,3
    80002008:	cc9c                	sw	a5,24(s1)
    8000200a:	b7dd                	j	80001ff0 <kill+0x4a>

000000008000200c <setkilled>:

void
setkilled(struct proc *p)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002018:	b83fe0ef          	jal	ra,80000b9a <acquire>
  p->killed = 1;
    8000201c:	4785                	li	a5,1
    8000201e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002020:	8526                	mv	a0,s1
    80002022:	c11fe0ef          	jal	ra,80000c32 <release>
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <killed>:

int
killed(struct proc *p)
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	e04a                	sd	s2,0(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000203e:	b5dfe0ef          	jal	ra,80000b9a <acquire>
  k = p->killed;
    80002042:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002046:	8526                	mv	a0,s1
    80002048:	bebfe0ef          	jal	ra,80000c32 <release>
  return k;
}
    8000204c:	854a                	mv	a0,s2
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6902                	ld	s2,0(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret

000000008000205a <wait>:
{
    8000205a:	715d                	addi	sp,sp,-80
    8000205c:	e486                	sd	ra,72(sp)
    8000205e:	e0a2                	sd	s0,64(sp)
    80002060:	fc26                	sd	s1,56(sp)
    80002062:	f84a                	sd	s2,48(sp)
    80002064:	f44e                	sd	s3,40(sp)
    80002066:	f052                	sd	s4,32(sp)
    80002068:	ec56                	sd	s5,24(sp)
    8000206a:	e85a                	sd	s6,16(sp)
    8000206c:	e45e                	sd	s7,8(sp)
    8000206e:	e062                	sd	s8,0(sp)
    80002070:	0880                	addi	s0,sp,80
    80002072:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002074:	fb8ff0ef          	jal	ra,8000182c <myproc>
    80002078:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000207a:	0000e517          	auipc	a0,0xe
    8000207e:	9ee50513          	addi	a0,a0,-1554 # 8000fa68 <wait_lock>
    80002082:	b19fe0ef          	jal	ra,80000b9a <acquire>
    havekids = 0;
    80002086:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002088:	4a15                	li	s4,5
        havekids = 1;
    8000208a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000208c:	00019997          	auipc	s3,0x19
    80002090:	60c98993          	addi	s3,s3,1548 # 8001b698 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002094:	0000ec17          	auipc	s8,0xe
    80002098:	9d4c0c13          	addi	s8,s8,-1580 # 8000fa68 <wait_lock>
    havekids = 0;
    8000209c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209e:	00014497          	auipc	s1,0x14
    800020a2:	9fa48493          	addi	s1,s1,-1542 # 80015a98 <proc>
    800020a6:	a899                	j	800020fc <wait+0xa2>
          pid = pp->pid;
    800020a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020ac:	000b0c63          	beqz	s6,800020c4 <wait+0x6a>
    800020b0:	4691                	li	a3,4
    800020b2:	02c48613          	addi	a2,s1,44
    800020b6:	85da                	mv	a1,s6
    800020b8:	05093503          	ld	a0,80(s2)
    800020bc:	c24ff0ef          	jal	ra,800014e0 <copyout>
    800020c0:	00054f63          	bltz	a0,800020de <wait+0x84>
          freeproc(pp);
    800020c4:	8526                	mv	a0,s1
    800020c6:	8d9ff0ef          	jal	ra,8000199e <freeproc>
          release(&pp->lock);
    800020ca:	8526                	mv	a0,s1
    800020cc:	b67fe0ef          	jal	ra,80000c32 <release>
          release(&wait_lock);
    800020d0:	0000e517          	auipc	a0,0xe
    800020d4:	99850513          	addi	a0,a0,-1640 # 8000fa68 <wait_lock>
    800020d8:	b5bfe0ef          	jal	ra,80000c32 <release>
          return pid;
    800020dc:	a891                	j	80002130 <wait+0xd6>
            release(&pp->lock);
    800020de:	8526                	mv	a0,s1
    800020e0:	b53fe0ef          	jal	ra,80000c32 <release>
            release(&wait_lock);
    800020e4:	0000e517          	auipc	a0,0xe
    800020e8:	98450513          	addi	a0,a0,-1660 # 8000fa68 <wait_lock>
    800020ec:	b47fe0ef          	jal	ra,80000c32 <release>
            return -1;
    800020f0:	59fd                	li	s3,-1
    800020f2:	a83d                	j	80002130 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020f4:	17048493          	addi	s1,s1,368
    800020f8:	03348063          	beq	s1,s3,80002118 <wait+0xbe>
      if(pp->parent == p){
    800020fc:	7c9c                	ld	a5,56(s1)
    800020fe:	ff279be3          	bne	a5,s2,800020f4 <wait+0x9a>
        acquire(&pp->lock);
    80002102:	8526                	mv	a0,s1
    80002104:	a97fe0ef          	jal	ra,80000b9a <acquire>
        if(pp->state == ZOMBIE){
    80002108:	4c9c                	lw	a5,24(s1)
    8000210a:	f9478fe3          	beq	a5,s4,800020a8 <wait+0x4e>
        release(&pp->lock);
    8000210e:	8526                	mv	a0,s1
    80002110:	b23fe0ef          	jal	ra,80000c32 <release>
        havekids = 1;
    80002114:	8756                	mv	a4,s5
    80002116:	bff9                	j	800020f4 <wait+0x9a>
    if(!havekids || killed(p)){
    80002118:	c709                	beqz	a4,80002122 <wait+0xc8>
    8000211a:	854a                	mv	a0,s2
    8000211c:	f15ff0ef          	jal	ra,80002030 <killed>
    80002120:	c50d                	beqz	a0,8000214a <wait+0xf0>
      release(&wait_lock);
    80002122:	0000e517          	auipc	a0,0xe
    80002126:	94650513          	addi	a0,a0,-1722 # 8000fa68 <wait_lock>
    8000212a:	b09fe0ef          	jal	ra,80000c32 <release>
      return -1;
    8000212e:	59fd                	li	s3,-1
}
    80002130:	854e                	mv	a0,s3
    80002132:	60a6                	ld	ra,72(sp)
    80002134:	6406                	ld	s0,64(sp)
    80002136:	74e2                	ld	s1,56(sp)
    80002138:	7942                	ld	s2,48(sp)
    8000213a:	79a2                	ld	s3,40(sp)
    8000213c:	7a02                	ld	s4,32(sp)
    8000213e:	6ae2                	ld	s5,24(sp)
    80002140:	6b42                	ld	s6,16(sp)
    80002142:	6ba2                	ld	s7,8(sp)
    80002144:	6c02                	ld	s8,0(sp)
    80002146:	6161                	addi	sp,sp,80
    80002148:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000214a:	85e2                	mv	a1,s8
    8000214c:	854a                	mv	a0,s2
    8000214e:	cabff0ef          	jal	ra,80001df8 <sleep>
    havekids = 0;
    80002152:	b7a9                	j	8000209c <wait+0x42>

0000000080002154 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	e052                	sd	s4,0(sp)
    80002162:	1800                	addi	s0,sp,48
    80002164:	84aa                	mv	s1,a0
    80002166:	892e                	mv	s2,a1
    80002168:	89b2                	mv	s3,a2
    8000216a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000216c:	ec0ff0ef          	jal	ra,8000182c <myproc>
  if(user_dst){
    80002170:	cc99                	beqz	s1,8000218e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002172:	86d2                	mv	a3,s4
    80002174:	864e                	mv	a2,s3
    80002176:	85ca                	mv	a1,s2
    80002178:	6928                	ld	a0,80(a0)
    8000217a:	b66ff0ef          	jal	ra,800014e0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000217e:	70a2                	ld	ra,40(sp)
    80002180:	7402                	ld	s0,32(sp)
    80002182:	64e2                	ld	s1,24(sp)
    80002184:	6942                	ld	s2,16(sp)
    80002186:	69a2                	ld	s3,8(sp)
    80002188:	6a02                	ld	s4,0(sp)
    8000218a:	6145                	addi	sp,sp,48
    8000218c:	8082                	ret
    memmove((char *)dst, src, len);
    8000218e:	000a061b          	sext.w	a2,s4
    80002192:	85ce                	mv	a1,s3
    80002194:	854a                	mv	a0,s2
    80002196:	b35fe0ef          	jal	ra,80000cca <memmove>
    return 0;
    8000219a:	8526                	mv	a0,s1
    8000219c:	b7cd                	j	8000217e <either_copyout+0x2a>

000000008000219e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000219e:	7179                	addi	sp,sp,-48
    800021a0:	f406                	sd	ra,40(sp)
    800021a2:	f022                	sd	s0,32(sp)
    800021a4:	ec26                	sd	s1,24(sp)
    800021a6:	e84a                	sd	s2,16(sp)
    800021a8:	e44e                	sd	s3,8(sp)
    800021aa:	e052                	sd	s4,0(sp)
    800021ac:	1800                	addi	s0,sp,48
    800021ae:	892a                	mv	s2,a0
    800021b0:	84ae                	mv	s1,a1
    800021b2:	89b2                	mv	s3,a2
    800021b4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021b6:	e76ff0ef          	jal	ra,8000182c <myproc>
  if(user_src){
    800021ba:	cc99                	beqz	s1,800021d8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021bc:	86d2                	mv	a3,s4
    800021be:	864e                	mv	a2,s3
    800021c0:	85ca                	mv	a1,s2
    800021c2:	6928                	ld	a0,80(a0)
    800021c4:	bd4ff0ef          	jal	ra,80001598 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021c8:	70a2                	ld	ra,40(sp)
    800021ca:	7402                	ld	s0,32(sp)
    800021cc:	64e2                	ld	s1,24(sp)
    800021ce:	6942                	ld	s2,16(sp)
    800021d0:	69a2                	ld	s3,8(sp)
    800021d2:	6a02                	ld	s4,0(sp)
    800021d4:	6145                	addi	sp,sp,48
    800021d6:	8082                	ret
    memmove(dst, (char*)src, len);
    800021d8:	000a061b          	sext.w	a2,s4
    800021dc:	85ce                	mv	a1,s3
    800021de:	854a                	mv	a0,s2
    800021e0:	aebfe0ef          	jal	ra,80000cca <memmove>
    return 0;
    800021e4:	8526                	mv	a0,s1
    800021e6:	b7cd                	j	800021c8 <either_copyin+0x2a>

00000000800021e8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800021e8:	715d                	addi	sp,sp,-80
    800021ea:	e486                	sd	ra,72(sp)
    800021ec:	e0a2                	sd	s0,64(sp)
    800021ee:	fc26                	sd	s1,56(sp)
    800021f0:	f84a                	sd	s2,48(sp)
    800021f2:	f44e                	sd	s3,40(sp)
    800021f4:	f052                	sd	s4,32(sp)
    800021f6:	ec56                	sd	s5,24(sp)
    800021f8:	e85a                	sd	s6,16(sp)
    800021fa:	e45e                	sd	s7,8(sp)
    800021fc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800021fe:	00005517          	auipc	a0,0x5
    80002202:	ec250513          	addi	a0,a0,-318 # 800070c0 <digits+0x88>
    80002206:	a9cfe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000220a:	00014497          	auipc	s1,0x14
    8000220e:	9e648493          	addi	s1,s1,-1562 # 80015bf0 <proc+0x158>
    80002212:	00019917          	auipc	s2,0x19
    80002216:	5de90913          	addi	s2,s2,1502 # 8001b7f0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000221a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000221c:	00005997          	auipc	s3,0x5
    80002220:	09c98993          	addi	s3,s3,156 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002224:	00005a97          	auipc	s5,0x5
    80002228:	09ca8a93          	addi	s5,s5,156 # 800072c0 <digits+0x288>
    printf("\n");
    8000222c:	00005a17          	auipc	s4,0x5
    80002230:	e94a0a13          	addi	s4,s4,-364 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002234:	00005b97          	auipc	s7,0x5
    80002238:	0ccb8b93          	addi	s7,s7,204 # 80007300 <states.0>
    8000223c:	a829                	j	80002256 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000223e:	ed86a583          	lw	a1,-296(a3)
    80002242:	8556                	mv	a0,s5
    80002244:	a5efe0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80002248:	8552                	mv	a0,s4
    8000224a:	a58fe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000224e:	17048493          	addi	s1,s1,368
    80002252:	03248163          	beq	s1,s2,80002274 <procdump+0x8c>
    if(p->state == UNUSED)
    80002256:	86a6                	mv	a3,s1
    80002258:	ec04a783          	lw	a5,-320(s1)
    8000225c:	dbed                	beqz	a5,8000224e <procdump+0x66>
      state = "???";
    8000225e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002260:	fcfb6fe3          	bltu	s6,a5,8000223e <procdump+0x56>
    80002264:	1782                	slli	a5,a5,0x20
    80002266:	9381                	srli	a5,a5,0x20
    80002268:	078e                	slli	a5,a5,0x3
    8000226a:	97de                	add	a5,a5,s7
    8000226c:	6390                	ld	a2,0(a5)
    8000226e:	fa61                	bnez	a2,8000223e <procdump+0x56>
      state = "???";
    80002270:	864e                	mv	a2,s3
    80002272:	b7f1                	j	8000223e <procdump+0x56>
  }
}
    80002274:	60a6                	ld	ra,72(sp)
    80002276:	6406                	ld	s0,64(sp)
    80002278:	74e2                	ld	s1,56(sp)
    8000227a:	7942                	ld	s2,48(sp)
    8000227c:	79a2                	ld	s3,40(sp)
    8000227e:	7a02                	ld	s4,32(sp)
    80002280:	6ae2                	ld	s5,24(sp)
    80002282:	6b42                	ld	s6,16(sp)
    80002284:	6ba2                	ld	s7,8(sp)
    80002286:	6161                	addi	sp,sp,80
    80002288:	8082                	ret

000000008000228a <getprocs>:




int getprocs(struct proc_stat *ps, int max)
{
    8000228a:	715d                	addi	sp,sp,-80
    8000228c:	e486                	sd	ra,72(sp)
    8000228e:	e0a2                	sd	s0,64(sp)
    80002290:	fc26                	sd	s1,56(sp)
    80002292:	f84a                	sd	s2,48(sp)
    80002294:	f44e                	sd	s3,40(sp)
    80002296:	f052                	sd	s4,32(sp)
    80002298:	ec56                	sd	s5,24(sp)
    8000229a:	e85a                	sd	s6,16(sp)
    8000229c:	0880                	addi	s0,sp,80
    8000229e:	81010113          	addi	sp,sp,-2032
    struct proc *p;
    int n;
    struct proc_stat local_stats[NPROC];

    if(max <= 0 || max > NPROC)
    800022a2:	fff5871b          	addiw	a4,a1,-1
    800022a6:	03f00793          	li	a5,63
    800022aa:	0ae7ed63          	bltu	a5,a4,80002364 <getprocs+0xda>
    800022ae:	8b2a                	mv	s6,a0
    800022b0:	89ae                	mv	s3,a1
        return -1;

    n = 0;
    800022b2:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC] && n < max; p++) {
    800022b4:	00013497          	auipc	s1,0x13
    800022b8:	7e448493          	addi	s1,s1,2020 # 80015a98 <proc>
        acquire(&p->lock);
        if(p->state != UNUSED) {
            local_stats[n].pid = p->pid;
            local_stats[n].state = p->state;
            local_stats[n].ticks = ticks;
    800022bc:	00005a97          	auipc	s5,0x5
    800022c0:	664a8a93          	addi	s5,s5,1636 # 80007920 <ticks>
    for(p = proc; p < &proc[NPROC] && n < max; p++) {
    800022c4:	00019a17          	auipc	s4,0x19
    800022c8:	3d4a0a13          	addi	s4,s4,980 # 8001b698 <tickslock>
    800022cc:	a811                	j	800022e0 <getprocs+0x56>
            local_stats[n].memory = p->sz;
            safestrcpy(local_stats[n].name, p->name, sizeof(local_stats[n].name));
            n++;
        }
        release(&p->lock);
    800022ce:	8526                	mv	a0,s1
    800022d0:	963fe0ef          	jal	ra,80000c32 <release>
    for(p = proc; p < &proc[NPROC] && n < max; p++) {
    800022d4:	17048493          	addi	s1,s1,368
    800022d8:	05448863          	beq	s1,s4,80002328 <getprocs+0x9e>
    800022dc:	05395663          	bge	s2,s3,80002328 <getprocs+0x9e>
        acquire(&p->lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	8b9fe0ef          	jal	ra,80000b9a <acquire>
        if(p->state != UNUSED) {
    800022e6:	4c9c                	lw	a5,24(s1)
    800022e8:	d3fd                	beqz	a5,800022ce <getprocs+0x44>
            local_stats[n].pid = p->pid;
    800022ea:	00591713          	slli	a4,s2,0x5
    800022ee:	fc040693          	addi	a3,s0,-64
    800022f2:	96ba                	add	a3,a3,a4
    800022f4:	5890                	lw	a2,48(s1)
    800022f6:	80c6a023          	sw	a2,-2048(a3)
            local_stats[n].state = p->state;
    800022fa:	80f6a223          	sw	a5,-2044(a3)
            local_stats[n].ticks = ticks;
    800022fe:	000aa783          	lw	a5,0(s5)
    80002302:	80f6a423          	sw	a5,-2040(a3)
            local_stats[n].memory = p->sz;
    80002306:	64bc                	ld	a5,72(s1)
    80002308:	80f6a623          	sw	a5,-2036(a3)
            safestrcpy(local_stats[n].name, p->name, sizeof(local_stats[n].name));
    8000230c:	0741                	addi	a4,a4,16
    8000230e:	4641                	li	a2,16
    80002310:	15848593          	addi	a1,s1,344
    80002314:	77fd                	lui	a5,0xfffff
    80002316:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <end+0xffffffff7ffd8ed8>
    8000231a:	97a2                	add	a5,a5,s0
    8000231c:	00e78533          	add	a0,a5,a4
    80002320:	a95fe0ef          	jal	ra,80000db4 <safestrcpy>
            n++;
    80002324:	2905                	addiw	s2,s2,1
    80002326:	b765                	j	800022ce <getprocs+0x44>
    }

    if(copyout(myproc()->pagetable, (uint64)ps, (char*)local_stats, 
    80002328:	d04ff0ef          	jal	ra,8000182c <myproc>
    8000232c:	00591693          	slli	a3,s2,0x5
    80002330:	77fd                	lui	a5,0xfffff
    80002332:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <end+0xffffffff7ffd8ed8>
    80002336:	00f40633          	add	a2,s0,a5
    8000233a:	85da                	mv	a1,s6
    8000233c:	6928                	ld	a0,80(a0)
    8000233e:	9a2ff0ef          	jal	ra,800014e0 <copyout>
    80002342:	00054f63          	bltz	a0,80002360 <getprocs+0xd6>
               n * sizeof(struct proc_stat)) < 0) {
        return -1;
    }

    return n;
}
    80002346:	854a                	mv	a0,s2
    80002348:	7f010113          	addi	sp,sp,2032
    8000234c:	60a6                	ld	ra,72(sp)
    8000234e:	6406                	ld	s0,64(sp)
    80002350:	74e2                	ld	s1,56(sp)
    80002352:	7942                	ld	s2,48(sp)
    80002354:	79a2                	ld	s3,40(sp)
    80002356:	7a02                	ld	s4,32(sp)
    80002358:	6ae2                	ld	s5,24(sp)
    8000235a:	6b42                	ld	s6,16(sp)
    8000235c:	6161                	addi	sp,sp,80
    8000235e:	8082                	ret
        return -1;
    80002360:	597d                	li	s2,-1
    80002362:	b7d5                	j	80002346 <getprocs+0xbc>
        return -1;
    80002364:	597d                	li	s2,-1
    80002366:	b7c5                	j	80002346 <getprocs+0xbc>

0000000080002368 <swtch>:
    80002368:	00153023          	sd	ra,0(a0)
    8000236c:	00253423          	sd	sp,8(a0)
    80002370:	e900                	sd	s0,16(a0)
    80002372:	ed04                	sd	s1,24(a0)
    80002374:	03253023          	sd	s2,32(a0)
    80002378:	03353423          	sd	s3,40(a0)
    8000237c:	03453823          	sd	s4,48(a0)
    80002380:	03553c23          	sd	s5,56(a0)
    80002384:	05653023          	sd	s6,64(a0)
    80002388:	05753423          	sd	s7,72(a0)
    8000238c:	05853823          	sd	s8,80(a0)
    80002390:	05953c23          	sd	s9,88(a0)
    80002394:	07a53023          	sd	s10,96(a0)
    80002398:	07b53423          	sd	s11,104(a0)
    8000239c:	0005b083          	ld	ra,0(a1)
    800023a0:	0085b103          	ld	sp,8(a1)
    800023a4:	6980                	ld	s0,16(a1)
    800023a6:	6d84                	ld	s1,24(a1)
    800023a8:	0205b903          	ld	s2,32(a1)
    800023ac:	0285b983          	ld	s3,40(a1)
    800023b0:	0305ba03          	ld	s4,48(a1)
    800023b4:	0385ba83          	ld	s5,56(a1)
    800023b8:	0405bb03          	ld	s6,64(a1)
    800023bc:	0485bb83          	ld	s7,72(a1)
    800023c0:	0505bc03          	ld	s8,80(a1)
    800023c4:	0585bc83          	ld	s9,88(a1)
    800023c8:	0605bd03          	ld	s10,96(a1)
    800023cc:	0685bd83          	ld	s11,104(a1)
    800023d0:	8082                	ret

00000000800023d2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023d2:	1141                	addi	sp,sp,-16
    800023d4:	e406                	sd	ra,8(sp)
    800023d6:	e022                	sd	s0,0(sp)
    800023d8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023da:	00005597          	auipc	a1,0x5
    800023de:	f5658593          	addi	a1,a1,-170 # 80007330 <states.0+0x30>
    800023e2:	00019517          	auipc	a0,0x19
    800023e6:	2b650513          	addi	a0,a0,694 # 8001b698 <tickslock>
    800023ea:	f30fe0ef          	jal	ra,80000b1a <initlock>
}
    800023ee:	60a2                	ld	ra,8(sp)
    800023f0:	6402                	ld	s0,0(sp)
    800023f2:	0141                	addi	sp,sp,16
    800023f4:	8082                	ret

00000000800023f6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023f6:	1141                	addi	sp,sp,-16
    800023f8:	e422                	sd	s0,8(sp)
    800023fa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800023fc:	00003797          	auipc	a5,0x3
    80002400:	eb478793          	addi	a5,a5,-332 # 800052b0 <kernelvec>
    80002404:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002408:	6422                	ld	s0,8(sp)
    8000240a:	0141                	addi	sp,sp,16
    8000240c:	8082                	ret

000000008000240e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000240e:	1141                	addi	sp,sp,-16
    80002410:	e406                	sd	ra,8(sp)
    80002412:	e022                	sd	s0,0(sp)
    80002414:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002416:	c16ff0ef          	jal	ra,8000182c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000241a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000241e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002420:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002424:	00004617          	auipc	a2,0x4
    80002428:	bdc60613          	addi	a2,a2,-1060 # 80006000 <_trampoline>
    8000242c:	00004697          	auipc	a3,0x4
    80002430:	bd468693          	addi	a3,a3,-1068 # 80006000 <_trampoline>
    80002434:	8e91                	sub	a3,a3,a2
    80002436:	040007b7          	lui	a5,0x4000
    8000243a:	17fd                	addi	a5,a5,-1
    8000243c:	07b2                	slli	a5,a5,0xc
    8000243e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002440:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002444:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002446:	180026f3          	csrr	a3,satp
    8000244a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000244c:	6d38                	ld	a4,88(a0)
    8000244e:	6134                	ld	a3,64(a0)
    80002450:	6585                	lui	a1,0x1
    80002452:	96ae                	add	a3,a3,a1
    80002454:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002456:	6d38                	ld	a4,88(a0)
    80002458:	00000697          	auipc	a3,0x0
    8000245c:	10c68693          	addi	a3,a3,268 # 80002564 <usertrap>
    80002460:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002462:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002464:	8692                	mv	a3,tp
    80002466:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002468:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000246c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002470:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002474:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002478:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000247a:	6f18                	ld	a4,24(a4)
    8000247c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002480:	6928                	ld	a0,80(a0)
    80002482:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002484:	00004717          	auipc	a4,0x4
    80002488:	c1870713          	addi	a4,a4,-1000 # 8000609c <userret>
    8000248c:	8f11                	sub	a4,a4,a2
    8000248e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002490:	577d                	li	a4,-1
    80002492:	177e                	slli	a4,a4,0x3f
    80002494:	8d59                	or	a0,a0,a4
    80002496:	9782                	jalr	a5
}
    80002498:	60a2                	ld	ra,8(sp)
    8000249a:	6402                	ld	s0,0(sp)
    8000249c:	0141                	addi	sp,sp,16
    8000249e:	8082                	ret

00000000800024a0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024aa:	b56ff0ef          	jal	ra,80001800 <cpuid>
    800024ae:	cd19                	beqz	a0,800024cc <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024b0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024b4:	000f4737          	lui	a4,0xf4
    800024b8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024bc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024be:	14d79073          	csrw	0x14d,a5
}
    800024c2:	60e2                	ld	ra,24(sp)
    800024c4:	6442                	ld	s0,16(sp)
    800024c6:	64a2                	ld	s1,8(sp)
    800024c8:	6105                	addi	sp,sp,32
    800024ca:	8082                	ret
    acquire(&tickslock);
    800024cc:	00019497          	auipc	s1,0x19
    800024d0:	1cc48493          	addi	s1,s1,460 # 8001b698 <tickslock>
    800024d4:	8526                	mv	a0,s1
    800024d6:	ec4fe0ef          	jal	ra,80000b9a <acquire>
    ticks++;
    800024da:	00005517          	auipc	a0,0x5
    800024de:	44650513          	addi	a0,a0,1094 # 80007920 <ticks>
    800024e2:	411c                	lw	a5,0(a0)
    800024e4:	2785                	addiw	a5,a5,1
    800024e6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024e8:	95dff0ef          	jal	ra,80001e44 <wakeup>
    release(&tickslock);
    800024ec:	8526                	mv	a0,s1
    800024ee:	f44fe0ef          	jal	ra,80000c32 <release>
    800024f2:	bf7d                	j	800024b0 <clockintr+0x10>

00000000800024f4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024f4:	1101                	addi	sp,sp,-32
    800024f6:	ec06                	sd	ra,24(sp)
    800024f8:	e822                	sd	s0,16(sp)
    800024fa:	e426                	sd	s1,8(sp)
    800024fc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024fe:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002502:	57fd                	li	a5,-1
    80002504:	17fe                	slli	a5,a5,0x3f
    80002506:	07a5                	addi	a5,a5,9
    80002508:	00f70d63          	beq	a4,a5,80002522 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000250c:	57fd                	li	a5,-1
    8000250e:	17fe                	slli	a5,a5,0x3f
    80002510:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002512:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002514:	04f70463          	beq	a4,a5,8000255c <devintr+0x68>
  }
}
    80002518:	60e2                	ld	ra,24(sp)
    8000251a:	6442                	ld	s0,16(sp)
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret
    int irq = plic_claim();
    80002522:	637020ef          	jal	ra,80005358 <plic_claim>
    80002526:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002528:	47a9                	li	a5,10
    8000252a:	02f50363          	beq	a0,a5,80002550 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000252e:	4785                	li	a5,1
    80002530:	02f50363          	beq	a0,a5,80002556 <devintr+0x62>
    return 1;
    80002534:	4505                	li	a0,1
    } else if(irq){
    80002536:	d0ed                	beqz	s1,80002518 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002538:	85a6                	mv	a1,s1
    8000253a:	00005517          	auipc	a0,0x5
    8000253e:	dfe50513          	addi	a0,a0,-514 # 80007338 <states.0+0x38>
    80002542:	f61fd0ef          	jal	ra,800004a2 <printf>
      plic_complete(irq);
    80002546:	8526                	mv	a0,s1
    80002548:	631020ef          	jal	ra,80005378 <plic_complete>
    return 1;
    8000254c:	4505                	li	a0,1
    8000254e:	b7e9                	j	80002518 <devintr+0x24>
      uartintr();
    80002550:	c5efe0ef          	jal	ra,800009ae <uartintr>
    80002554:	bfcd                	j	80002546 <devintr+0x52>
      virtio_disk_intr();
    80002556:	292030ef          	jal	ra,800057e8 <virtio_disk_intr>
    8000255a:	b7f5                	j	80002546 <devintr+0x52>
    clockintr();
    8000255c:	f45ff0ef          	jal	ra,800024a0 <clockintr>
    return 2;
    80002560:	4509                	li	a0,2
    80002562:	bf5d                	j	80002518 <devintr+0x24>

0000000080002564 <usertrap>:
{
    80002564:	1101                	addi	sp,sp,-32
    80002566:	ec06                	sd	ra,24(sp)
    80002568:	e822                	sd	s0,16(sp)
    8000256a:	e426                	sd	s1,8(sp)
    8000256c:	e04a                	sd	s2,0(sp)
    8000256e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002570:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002574:	1007f793          	andi	a5,a5,256
    80002578:	ef85                	bnez	a5,800025b0 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000257a:	00003797          	auipc	a5,0x3
    8000257e:	d3678793          	addi	a5,a5,-714 # 800052b0 <kernelvec>
    80002582:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002586:	aa6ff0ef          	jal	ra,8000182c <myproc>
    8000258a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000258c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000258e:	14102773          	csrr	a4,sepc
    80002592:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002594:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002598:	47a1                	li	a5,8
    8000259a:	02f70163          	beq	a4,a5,800025bc <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000259e:	f57ff0ef          	jal	ra,800024f4 <devintr>
    800025a2:	892a                	mv	s2,a0
    800025a4:	c135                	beqz	a0,80002608 <usertrap+0xa4>
  if(killed(p))
    800025a6:	8526                	mv	a0,s1
    800025a8:	a89ff0ef          	jal	ra,80002030 <killed>
    800025ac:	cd1d                	beqz	a0,800025ea <usertrap+0x86>
    800025ae:	a81d                	j	800025e4 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800025b0:	00005517          	auipc	a0,0x5
    800025b4:	da850513          	addi	a0,a0,-600 # 80007358 <states.0+0x58>
    800025b8:	99efe0ef          	jal	ra,80000756 <panic>
    if(killed(p))
    800025bc:	a75ff0ef          	jal	ra,80002030 <killed>
    800025c0:	e121                	bnez	a0,80002600 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025c2:	6cb8                	ld	a4,88(s1)
    800025c4:	6f1c                	ld	a5,24(a4)
    800025c6:	0791                	addi	a5,a5,4
    800025c8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025ce:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d2:	10079073          	csrw	sstatus,a5
    syscall();
    800025d6:	248000ef          	jal	ra,8000281e <syscall>
  if(killed(p))
    800025da:	8526                	mv	a0,s1
    800025dc:	a55ff0ef          	jal	ra,80002030 <killed>
    800025e0:	c901                	beqz	a0,800025f0 <usertrap+0x8c>
    800025e2:	4901                	li	s2,0
    exit(-1);
    800025e4:	557d                	li	a0,-1
    800025e6:	91fff0ef          	jal	ra,80001f04 <exit>
  if(which_dev == 2)
    800025ea:	4789                	li	a5,2
    800025ec:	04f90563          	beq	s2,a5,80002636 <usertrap+0xd2>
  usertrapret();
    800025f0:	e1fff0ef          	jal	ra,8000240e <usertrapret>
}
    800025f4:	60e2                	ld	ra,24(sp)
    800025f6:	6442                	ld	s0,16(sp)
    800025f8:	64a2                	ld	s1,8(sp)
    800025fa:	6902                	ld	s2,0(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret
      exit(-1);
    80002600:	557d                	li	a0,-1
    80002602:	903ff0ef          	jal	ra,80001f04 <exit>
    80002606:	bf75                	j	800025c2 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002608:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000260c:	5890                	lw	a2,48(s1)
    8000260e:	00005517          	auipc	a0,0x5
    80002612:	d6a50513          	addi	a0,a0,-662 # 80007378 <states.0+0x78>
    80002616:	e8dfd0ef          	jal	ra,800004a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000261a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000261e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002622:	00005517          	auipc	a0,0x5
    80002626:	d8650513          	addi	a0,a0,-634 # 800073a8 <states.0+0xa8>
    8000262a:	e79fd0ef          	jal	ra,800004a2 <printf>
    setkilled(p);
    8000262e:	8526                	mv	a0,s1
    80002630:	9ddff0ef          	jal	ra,8000200c <setkilled>
    80002634:	b75d                	j	800025da <usertrap+0x76>
    yield();
    80002636:	f96ff0ef          	jal	ra,80001dcc <yield>
    8000263a:	bf5d                	j	800025f0 <usertrap+0x8c>

000000008000263c <kerneltrap>:
{
    8000263c:	7179                	addi	sp,sp,-48
    8000263e:	f406                	sd	ra,40(sp)
    80002640:	f022                	sd	s0,32(sp)
    80002642:	ec26                	sd	s1,24(sp)
    80002644:	e84a                	sd	s2,16(sp)
    80002646:	e44e                	sd	s3,8(sp)
    80002648:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000264a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002652:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002656:	1004f793          	andi	a5,s1,256
    8000265a:	c795                	beqz	a5,80002686 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002660:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002662:	eb85                	bnez	a5,80002692 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002664:	e91ff0ef          	jal	ra,800024f4 <devintr>
    80002668:	c91d                	beqz	a0,8000269e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000266a:	4789                	li	a5,2
    8000266c:	04f50a63          	beq	a0,a5,800026c0 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002670:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002674:	10049073          	csrw	sstatus,s1
}
    80002678:	70a2                	ld	ra,40(sp)
    8000267a:	7402                	ld	s0,32(sp)
    8000267c:	64e2                	ld	s1,24(sp)
    8000267e:	6942                	ld	s2,16(sp)
    80002680:	69a2                	ld	s3,8(sp)
    80002682:	6145                	addi	sp,sp,48
    80002684:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002686:	00005517          	auipc	a0,0x5
    8000268a:	d4a50513          	addi	a0,a0,-694 # 800073d0 <states.0+0xd0>
    8000268e:	8c8fe0ef          	jal	ra,80000756 <panic>
    panic("kerneltrap: interrupts enabled");
    80002692:	00005517          	auipc	a0,0x5
    80002696:	d6650513          	addi	a0,a0,-666 # 800073f8 <states.0+0xf8>
    8000269a:	8bcfe0ef          	jal	ra,80000756 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000269e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026a2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026a6:	85ce                	mv	a1,s3
    800026a8:	00005517          	auipc	a0,0x5
    800026ac:	d7050513          	addi	a0,a0,-656 # 80007418 <states.0+0x118>
    800026b0:	df3fd0ef          	jal	ra,800004a2 <printf>
    panic("kerneltrap");
    800026b4:	00005517          	auipc	a0,0x5
    800026b8:	d8c50513          	addi	a0,a0,-628 # 80007440 <states.0+0x140>
    800026bc:	89afe0ef          	jal	ra,80000756 <panic>
  if(which_dev == 2 && myproc() != 0)
    800026c0:	96cff0ef          	jal	ra,8000182c <myproc>
    800026c4:	d555                	beqz	a0,80002670 <kerneltrap+0x34>
    yield();
    800026c6:	f06ff0ef          	jal	ra,80001dcc <yield>
    800026ca:	b75d                	j	80002670 <kerneltrap+0x34>

00000000800026cc <fetchaddr>:


// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    800026cc:	1101                	addi	sp,sp,-32
    800026ce:	ec06                	sd	ra,24(sp)
    800026d0:	e822                	sd	s0,16(sp)
    800026d2:	e426                	sd	s1,8(sp)
    800026d4:	e04a                	sd	s2,0(sp)
    800026d6:	1000                	addi	s0,sp,32
    800026d8:	84aa                	mv	s1,a0
    800026da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800026dc:	950ff0ef          	jal	ra,8000182c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800026e0:	653c                	ld	a5,72(a0)
    800026e2:	02f4f663          	bgeu	s1,a5,8000270e <fetchaddr+0x42>
    800026e6:	00848713          	addi	a4,s1,8
    800026ea:	02e7e463          	bltu	a5,a4,80002712 <fetchaddr+0x46>
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800026ee:	46a1                	li	a3,8
    800026f0:	8626                	mv	a2,s1
    800026f2:	85ca                	mv	a1,s2
    800026f4:	6928                	ld	a0,80(a0)
    800026f6:	ea3fe0ef          	jal	ra,80001598 <copyin>
    800026fa:	00a03533          	snez	a0,a0
    800026fe:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
    80002702:	60e2                	ld	ra,24(sp)
    80002704:	6442                	ld	s0,16(sp)
    80002706:	64a2                	ld	s1,8(sp)
    80002708:	6902                	ld	s2,0(sp)
    8000270a:	6105                	addi	sp,sp,32
    8000270c:	8082                	ret
    return -1;
    8000270e:	557d                	li	a0,-1
    80002710:	bfcd                	j	80002702 <fetchaddr+0x36>
    80002712:	557d                	li	a0,-1
    80002714:	b7fd                	j	80002702 <fetchaddr+0x36>

0000000080002716 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    80002716:	7179                	addi	sp,sp,-48
    80002718:	f406                	sd	ra,40(sp)
    8000271a:	f022                	sd	s0,32(sp)
    8000271c:	ec26                	sd	s1,24(sp)
    8000271e:	e84a                	sd	s2,16(sp)
    80002720:	e44e                	sd	s3,8(sp)
    80002722:	1800                	addi	s0,sp,48
    80002724:	892a                	mv	s2,a0
    80002726:	84ae                	mv	s1,a1
    80002728:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000272a:	902ff0ef          	jal	ra,8000182c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000272e:	86ce                	mv	a3,s3
    80002730:	864a                	mv	a2,s2
    80002732:	85a6                	mv	a1,s1
    80002734:	6928                	ld	a0,80(a0)
    80002736:	ee9fe0ef          	jal	ra,8000161e <copyinstr>
    8000273a:	00054c63          	bltz	a0,80002752 <fetchstr+0x3c>
    return -1;
  return strlen(buf);
    8000273e:	8526                	mv	a0,s1
    80002740:	ea6fe0ef          	jal	ra,80000de6 <strlen>
}
    80002744:	70a2                	ld	ra,40(sp)
    80002746:	7402                	ld	s0,32(sp)
    80002748:	64e2                	ld	s1,24(sp)
    8000274a:	6942                	ld	s2,16(sp)
    8000274c:	69a2                	ld	s3,8(sp)
    8000274e:	6145                	addi	sp,sp,48
    80002750:	8082                	ret
    return -1;
    80002752:	557d                	li	a0,-1
    80002754:	bfc5                	j	80002744 <fetchstr+0x2e>

0000000080002756 <argraw>:

// kernel/syscall.c
uint64
argraw(int n)
{
    80002756:	1101                	addi	sp,sp,-32
    80002758:	ec06                	sd	ra,24(sp)
    8000275a:	e822                	sd	s0,16(sp)
    8000275c:	e426                	sd	s1,8(sp)
    8000275e:	1000                	addi	s0,sp,32
    80002760:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002762:	8caff0ef          	jal	ra,8000182c <myproc>
  switch (n) {
    80002766:	4795                	li	a5,5
    80002768:	0497e163          	bltu	a5,s1,800027aa <argraw+0x54>
    8000276c:	048a                	slli	s1,s1,0x2
    8000276e:	00005717          	auipc	a4,0x5
    80002772:	d0a70713          	addi	a4,a4,-758 # 80007478 <states.0+0x178>
    80002776:	94ba                	add	s1,s1,a4
    80002778:	409c                	lw	a5,0(s1)
    8000277a:	97ba                	add	a5,a5,a4
    8000277c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000277e:	6d3c                	ld	a5,88(a0)
    80002780:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002782:	60e2                	ld	ra,24(sp)
    80002784:	6442                	ld	s0,16(sp)
    80002786:	64a2                	ld	s1,8(sp)
    80002788:	6105                	addi	sp,sp,32
    8000278a:	8082                	ret
    return p->trapframe->a1;
    8000278c:	6d3c                	ld	a5,88(a0)
    8000278e:	7fa8                	ld	a0,120(a5)
    80002790:	bfcd                	j	80002782 <argraw+0x2c>
    return p->trapframe->a2;
    80002792:	6d3c                	ld	a5,88(a0)
    80002794:	63c8                	ld	a0,128(a5)
    80002796:	b7f5                	j	80002782 <argraw+0x2c>
    return p->trapframe->a3;
    80002798:	6d3c                	ld	a5,88(a0)
    8000279a:	67c8                	ld	a0,136(a5)
    8000279c:	b7dd                	j	80002782 <argraw+0x2c>
    return p->trapframe->a4;
    8000279e:	6d3c                	ld	a5,88(a0)
    800027a0:	6bc8                	ld	a0,144(a5)
    800027a2:	b7c5                	j	80002782 <argraw+0x2c>
    return p->trapframe->a5;
    800027a4:	6d3c                	ld	a5,88(a0)
    800027a6:	6fc8                	ld	a0,152(a5)
    800027a8:	bfe9                	j	80002782 <argraw+0x2c>
  panic("argraw");
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	ca650513          	addi	a0,a0,-858 # 80007450 <states.0+0x150>
    800027b2:	fa5fd0ef          	jal	ra,80000756 <panic>

00000000800027b6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	e426                	sd	s1,8(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027c2:	f95ff0ef          	jal	ra,80002756 <argraw>
    800027c6:	c088                	sw	a0,0(s1)
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret

00000000800027d2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027d2:	1101                	addi	sp,sp,-32
    800027d4:	ec06                	sd	ra,24(sp)
    800027d6:	e822                	sd	s0,16(sp)
    800027d8:	e426                	sd	s1,8(sp)
    800027da:	1000                	addi	s0,sp,32
    800027dc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027de:	f79ff0ef          	jal	ra,80002756 <argraw>
    800027e2:	e088                	sd	a0,0(s1)
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	84ae                	mv	s1,a1
    800027fc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027fe:	fd840593          	addi	a1,s0,-40
    80002802:	fd1ff0ef          	jal	ra,800027d2 <argaddr>
  return fetchstr(addr, buf, max);
    80002806:	864a                	mv	a2,s2
    80002808:	85a6                	mv	a1,s1
    8000280a:	fd843503          	ld	a0,-40(s0)
    8000280e:	f09ff0ef          	jal	ra,80002716 <fetchstr>
}
    80002812:	70a2                	ld	ra,40(sp)
    80002814:	7402                	ld	s0,32(sp)
    80002816:	64e2                	ld	s1,24(sp)
    80002818:	6942                	ld	s2,16(sp)
    8000281a:	6145                	addi	sp,sp,48
    8000281c:	8082                	ret

000000008000281e <syscall>:



void
syscall(void)
{
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	e426                	sd	s1,8(sp)
    80002826:	e04a                	sd	s2,0(sp)
    80002828:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000282a:	802ff0ef          	jal	ra,8000182c <myproc>
    8000282e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002830:	05853903          	ld	s2,88(a0)
    80002834:	0a893783          	ld	a5,168(s2)
    80002838:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000283c:	37fd                	addiw	a5,a5,-1
    8000283e:	4761                	li	a4,24
    80002840:	00f76f63          	bltu	a4,a5,8000285e <syscall+0x40>
    80002844:	00369713          	slli	a4,a3,0x3
    80002848:	00005797          	auipc	a5,0x5
    8000284c:	c4878793          	addi	a5,a5,-952 # 80007490 <syscalls>
    80002850:	97ba                	add	a5,a5,a4
    80002852:	639c                	ld	a5,0(a5)
    80002854:	c789                	beqz	a5,8000285e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002856:	9782                	jalr	a5
    80002858:	06a93823          	sd	a0,112(s2)
    8000285c:	a829                	j	80002876 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000285e:	15848613          	addi	a2,s1,344
    80002862:	588c                	lw	a1,48(s1)
    80002864:	00005517          	auipc	a0,0x5
    80002868:	bf450513          	addi	a0,a0,-1036 # 80007458 <states.0+0x158>
    8000286c:	c37fd0ef          	jal	ra,800004a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002870:	6cbc                	ld	a5,88(s1)
    80002872:	577d                	li	a4,-1
    80002874:	fbb8                	sd	a4,112(a5)
  }
}
    80002876:	60e2                	ld	ra,24(sp)
    80002878:	6442                	ld	s0,16(sp)
    8000287a:	64a2                	ld	s1,8(sp)
    8000287c:	6902                	ld	s2,0(sp)
    8000287e:	6105                	addi	sp,sp,32
    80002880:	8082                	ret

0000000080002882 <sys_exit>:
#include "port.h"  


uint64
sys_exit(void)
{
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000288a:	fec40593          	addi	a1,s0,-20
    8000288e:	4501                	li	a0,0
    80002890:	f27ff0ef          	jal	ra,800027b6 <argint>
  exit(n);
    80002894:	fec42503          	lw	a0,-20(s0)
    80002898:	e6cff0ef          	jal	ra,80001f04 <exit>
  return 0;  // not reached
}
    8000289c:	4501                	li	a0,0
    8000289e:	60e2                	ld	ra,24(sp)
    800028a0:	6442                	ld	s0,16(sp)
    800028a2:	6105                	addi	sp,sp,32
    800028a4:	8082                	ret

00000000800028a6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028a6:	1141                	addi	sp,sp,-16
    800028a8:	e406                	sd	ra,8(sp)
    800028aa:	e022                	sd	s0,0(sp)
    800028ac:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028ae:	f7ffe0ef          	jal	ra,8000182c <myproc>
}
    800028b2:	5908                	lw	a0,48(a0)
    800028b4:	60a2                	ld	ra,8(sp)
    800028b6:	6402                	ld	s0,0(sp)
    800028b8:	0141                	addi	sp,sp,16
    800028ba:	8082                	ret

00000000800028bc <sys_fork>:

uint64
sys_fork(void)
{
    800028bc:	1141                	addi	sp,sp,-16
    800028be:	e406                	sd	ra,8(sp)
    800028c0:	e022                	sd	s0,0(sp)
    800028c2:	0800                	addi	s0,sp,16
  return fork();
    800028c4:	a8eff0ef          	jal	ra,80001b52 <fork>
}
    800028c8:	60a2                	ld	ra,8(sp)
    800028ca:	6402                	ld	s0,0(sp)
    800028cc:	0141                	addi	sp,sp,16
    800028ce:	8082                	ret

00000000800028d0 <sys_wait>:

uint64
sys_wait(void)
{
    800028d0:	1101                	addi	sp,sp,-32
    800028d2:	ec06                	sd	ra,24(sp)
    800028d4:	e822                	sd	s0,16(sp)
    800028d6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028d8:	fe840593          	addi	a1,s0,-24
    800028dc:	4501                	li	a0,0
    800028de:	ef5ff0ef          	jal	ra,800027d2 <argaddr>
  return wait(p);
    800028e2:	fe843503          	ld	a0,-24(s0)
    800028e6:	f74ff0ef          	jal	ra,8000205a <wait>
}
    800028ea:	60e2                	ld	ra,24(sp)
    800028ec:	6442                	ld	s0,16(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret

00000000800028f2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800028fc:	fdc40593          	addi	a1,s0,-36
    80002900:	4501                	li	a0,0
    80002902:	eb5ff0ef          	jal	ra,800027b6 <argint>
  addr = myproc()->sz;
    80002906:	f27fe0ef          	jal	ra,8000182c <myproc>
    8000290a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000290c:	fdc42503          	lw	a0,-36(s0)
    80002910:	9f2ff0ef          	jal	ra,80001b02 <growproc>
    80002914:	00054863          	bltz	a0,80002924 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002918:	8526                	mv	a0,s1
    8000291a:	70a2                	ld	ra,40(sp)
    8000291c:	7402                	ld	s0,32(sp)
    8000291e:	64e2                	ld	s1,24(sp)
    80002920:	6145                	addi	sp,sp,48
    80002922:	8082                	ret
    return -1;
    80002924:	54fd                	li	s1,-1
    80002926:	bfcd                	j	80002918 <sys_sbrk+0x26>

0000000080002928 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002928:	7139                	addi	sp,sp,-64
    8000292a:	fc06                	sd	ra,56(sp)
    8000292c:	f822                	sd	s0,48(sp)
    8000292e:	f426                	sd	s1,40(sp)
    80002930:	f04a                	sd	s2,32(sp)
    80002932:	ec4e                	sd	s3,24(sp)
    80002934:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002936:	fcc40593          	addi	a1,s0,-52
    8000293a:	4501                	li	a0,0
    8000293c:	e7bff0ef          	jal	ra,800027b6 <argint>
  if(n < 0)
    80002940:	fcc42783          	lw	a5,-52(s0)
    80002944:	0607c563          	bltz	a5,800029ae <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002948:	00019517          	auipc	a0,0x19
    8000294c:	d5050513          	addi	a0,a0,-688 # 8001b698 <tickslock>
    80002950:	a4afe0ef          	jal	ra,80000b9a <acquire>
  ticks0 = ticks;
    80002954:	00005917          	auipc	s2,0x5
    80002958:	fcc92903          	lw	s2,-52(s2) # 80007920 <ticks>
  while(ticks - ticks0 < n){
    8000295c:	fcc42783          	lw	a5,-52(s0)
    80002960:	cb8d                	beqz	a5,80002992 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002962:	00019997          	auipc	s3,0x19
    80002966:	d3698993          	addi	s3,s3,-714 # 8001b698 <tickslock>
    8000296a:	00005497          	auipc	s1,0x5
    8000296e:	fb648493          	addi	s1,s1,-74 # 80007920 <ticks>
    if(killed(myproc())){
    80002972:	ebbfe0ef          	jal	ra,8000182c <myproc>
    80002976:	ebaff0ef          	jal	ra,80002030 <killed>
    8000297a:	ed0d                	bnez	a0,800029b4 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000297c:	85ce                	mv	a1,s3
    8000297e:	8526                	mv	a0,s1
    80002980:	c78ff0ef          	jal	ra,80001df8 <sleep>
  while(ticks - ticks0 < n){
    80002984:	409c                	lw	a5,0(s1)
    80002986:	412787bb          	subw	a5,a5,s2
    8000298a:	fcc42703          	lw	a4,-52(s0)
    8000298e:	fee7e2e3          	bltu	a5,a4,80002972 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002992:	00019517          	auipc	a0,0x19
    80002996:	d0650513          	addi	a0,a0,-762 # 8001b698 <tickslock>
    8000299a:	a98fe0ef          	jal	ra,80000c32 <release>
  return 0;
    8000299e:	4501                	li	a0,0
}
    800029a0:	70e2                	ld	ra,56(sp)
    800029a2:	7442                	ld	s0,48(sp)
    800029a4:	74a2                	ld	s1,40(sp)
    800029a6:	7902                	ld	s2,32(sp)
    800029a8:	69e2                	ld	s3,24(sp)
    800029aa:	6121                	addi	sp,sp,64
    800029ac:	8082                	ret
    n = 0;
    800029ae:	fc042623          	sw	zero,-52(s0)
    800029b2:	bf59                	j	80002948 <sys_sleep+0x20>
      release(&tickslock);
    800029b4:	00019517          	auipc	a0,0x19
    800029b8:	ce450513          	addi	a0,a0,-796 # 8001b698 <tickslock>
    800029bc:	a76fe0ef          	jal	ra,80000c32 <release>
      return -1;
    800029c0:	557d                	li	a0,-1
    800029c2:	bff9                	j	800029a0 <sys_sleep+0x78>

00000000800029c4 <sys_kill>:

uint64
sys_kill(void)
{
    800029c4:	1101                	addi	sp,sp,-32
    800029c6:	ec06                	sd	ra,24(sp)
    800029c8:	e822                	sd	s0,16(sp)
    800029ca:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029cc:	fec40593          	addi	a1,s0,-20
    800029d0:	4501                	li	a0,0
    800029d2:	de5ff0ef          	jal	ra,800027b6 <argint>
  return kill(pid);
    800029d6:	fec42503          	lw	a0,-20(s0)
    800029da:	dccff0ef          	jal	ra,80001fa6 <kill>
}
    800029de:	60e2                	ld	ra,24(sp)
    800029e0:	6442                	ld	s0,16(sp)
    800029e2:	6105                	addi	sp,sp,32
    800029e4:	8082                	ret

00000000800029e6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800029e6:	1101                	addi	sp,sp,-32
    800029e8:	ec06                	sd	ra,24(sp)
    800029ea:	e822                	sd	s0,16(sp)
    800029ec:	e426                	sd	s1,8(sp)
    800029ee:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800029f0:	00019517          	auipc	a0,0x19
    800029f4:	ca850513          	addi	a0,a0,-856 # 8001b698 <tickslock>
    800029f8:	9a2fe0ef          	jal	ra,80000b9a <acquire>
  xticks = ticks;
    800029fc:	00005497          	auipc	s1,0x5
    80002a00:	f244a483          	lw	s1,-220(s1) # 80007920 <ticks>
  release(&tickslock);
    80002a04:	00019517          	auipc	a0,0x19
    80002a08:	c9450513          	addi	a0,a0,-876 # 8001b698 <tickslock>
    80002a0c:	a26fe0ef          	jal	ra,80000c32 <release>
  return xticks;
}
    80002a10:	02049513          	slli	a0,s1,0x20
    80002a14:	9101                	srli	a0,a0,0x20
    80002a16:	60e2                	ld	ra,24(sp)
    80002a18:	6442                	ld	s0,16(sp)
    80002a1a:	64a2                	ld	s1,8(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret

0000000080002a20 <sys_exit_qemu>:



uint64
sys_exit_qemu(void)
{
    80002a20:	1141                	addi	sp,sp,-16
    80002a22:	e422                	sd	s0,8(sp)
    80002a24:	0800                	addi	s0,sp,16
  // Adresse mémoire spéciale pour fermer QEMU
  volatile uint32 *exit_address = (volatile uint32 *)0x100000;
  *exit_address = 0x5555;  // Valeur magique pour fermer QEMU
    80002a26:	00100737          	lui	a4,0x100
    80002a2a:	6795                	lui	a5,0x5
    80002a2c:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002a30:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002a32:	4501                	li	a0,0
    80002a34:	6422                	ld	s0,8(sp)
    80002a36:	0141                	addi	sp,sp,16
    80002a38:	8082                	ret

0000000080002a3a <sys_getprocs>:


uint64
sys_getprocs(void)
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	1800                	addi	s0,sp,48
    uint64 addr;
    int max;
    struct proc_stat *ps;

    // On ne peut pas vérifier le retour de ces fonctions car elles sont void
    argaddr(0, &addr);
    80002a44:	fd840593          	addi	a1,s0,-40
    80002a48:	4501                	li	a0,0
    80002a4a:	d89ff0ef          	jal	ra,800027d2 <argaddr>
    argint(1, &max);
    80002a4e:	fd440593          	addi	a1,s0,-44
    80002a52:	4505                	li	a0,1
    80002a54:	d63ff0ef          	jal	ra,800027b6 <argint>
    
    // Vérifications de base
    if(max <= 0 || max > NPROC)
    80002a58:	fd442783          	lw	a5,-44(s0)
    80002a5c:	37fd                	addiw	a5,a5,-1
    80002a5e:	03f00713          	li	a4,63
        return -1;
    80002a62:	557d                	li	a0,-1
    if(max <= 0 || max > NPROC)
    80002a64:	02f76763          	bltu	a4,a5,80002a92 <sys_getprocs+0x58>

    // Convertir l'adresse utilisateur en pointeur noyau
    ps = (struct proc_stat*)addr;
    80002a68:	fd843483          	ld	s1,-40(s0)
    
    // Vérifier que l'adresse est valide en essayant de copier une petite quantité de données
    char test;
    if(copyout(myproc()->pagetable, addr, &test, 1) < 0)
    80002a6c:	dc1fe0ef          	jal	ra,8000182c <myproc>
    80002a70:	4685                	li	a3,1
    80002a72:	fd340613          	addi	a2,s0,-45
    80002a76:	fd843583          	ld	a1,-40(s0)
    80002a7a:	6928                	ld	a0,80(a0)
    80002a7c:	a65fe0ef          	jal	ra,800014e0 <copyout>
    80002a80:	87aa                	mv	a5,a0
        return -1;
    80002a82:	557d                	li	a0,-1
    if(copyout(myproc()->pagetable, addr, &test, 1) < 0)
    80002a84:	0007c763          	bltz	a5,80002a92 <sys_getprocs+0x58>

    // Appeler getprocs avec l'adresse validée
    return getprocs(ps, max);
    80002a88:	fd442583          	lw	a1,-44(s0)
    80002a8c:	8526                	mv	a0,s1
    80002a8e:	ffcff0ef          	jal	ra,8000228a <getprocs>
}
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6145                	addi	sp,sp,48
    80002a9a:	8082                	ret

0000000080002a9c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002a9c:	7179                	addi	sp,sp,-48
    80002a9e:	f406                	sd	ra,40(sp)
    80002aa0:	f022                	sd	s0,32(sp)
    80002aa2:	ec26                	sd	s1,24(sp)
    80002aa4:	e84a                	sd	s2,16(sp)
    80002aa6:	e44e                	sd	s3,8(sp)
    80002aa8:	e052                	sd	s4,0(sp)
    80002aaa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002aac:	00005597          	auipc	a1,0x5
    80002ab0:	ab458593          	addi	a1,a1,-1356 # 80007560 <syscalls+0xd0>
    80002ab4:	00019517          	auipc	a0,0x19
    80002ab8:	bfc50513          	addi	a0,a0,-1028 # 8001b6b0 <bcache>
    80002abc:	85efe0ef          	jal	ra,80000b1a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ac0:	00021797          	auipc	a5,0x21
    80002ac4:	bf078793          	addi	a5,a5,-1040 # 800236b0 <bcache+0x8000>
    80002ac8:	00021717          	auipc	a4,0x21
    80002acc:	e5070713          	addi	a4,a4,-432 # 80023918 <bcache+0x8268>
    80002ad0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ad4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ad8:	00019497          	auipc	s1,0x19
    80002adc:	bf048493          	addi	s1,s1,-1040 # 8001b6c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002ae0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ae2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ae4:	00005a17          	auipc	s4,0x5
    80002ae8:	a84a0a13          	addi	s4,s4,-1404 # 80007568 <syscalls+0xd8>
    b->next = bcache.head.next;
    80002aec:	2b893783          	ld	a5,696(s2)
    80002af0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002af2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002af6:	85d2                	mv	a1,s4
    80002af8:	01048513          	addi	a0,s1,16
    80002afc:	226010ef          	jal	ra,80003d22 <initsleeplock>
    bcache.head.next->prev = b;
    80002b00:	2b893783          	ld	a5,696(s2)
    80002b04:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b06:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b0a:	45848493          	addi	s1,s1,1112
    80002b0e:	fd349fe3          	bne	s1,s3,80002aec <binit+0x50>
  }
}
    80002b12:	70a2                	ld	ra,40(sp)
    80002b14:	7402                	ld	s0,32(sp)
    80002b16:	64e2                	ld	s1,24(sp)
    80002b18:	6942                	ld	s2,16(sp)
    80002b1a:	69a2                	ld	s3,8(sp)
    80002b1c:	6a02                	ld	s4,0(sp)
    80002b1e:	6145                	addi	sp,sp,48
    80002b20:	8082                	ret

0000000080002b22 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b22:	7179                	addi	sp,sp,-48
    80002b24:	f406                	sd	ra,40(sp)
    80002b26:	f022                	sd	s0,32(sp)
    80002b28:	ec26                	sd	s1,24(sp)
    80002b2a:	e84a                	sd	s2,16(sp)
    80002b2c:	e44e                	sd	s3,8(sp)
    80002b2e:	1800                	addi	s0,sp,48
    80002b30:	892a                	mv	s2,a0
    80002b32:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b34:	00019517          	auipc	a0,0x19
    80002b38:	b7c50513          	addi	a0,a0,-1156 # 8001b6b0 <bcache>
    80002b3c:	85efe0ef          	jal	ra,80000b9a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b40:	00021497          	auipc	s1,0x21
    80002b44:	e284b483          	ld	s1,-472(s1) # 80023968 <bcache+0x82b8>
    80002b48:	00021797          	auipc	a5,0x21
    80002b4c:	dd078793          	addi	a5,a5,-560 # 80023918 <bcache+0x8268>
    80002b50:	02f48b63          	beq	s1,a5,80002b86 <bread+0x64>
    80002b54:	873e                	mv	a4,a5
    80002b56:	a021                	j	80002b5e <bread+0x3c>
    80002b58:	68a4                	ld	s1,80(s1)
    80002b5a:	02e48663          	beq	s1,a4,80002b86 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b5e:	449c                	lw	a5,8(s1)
    80002b60:	ff279ce3          	bne	a5,s2,80002b58 <bread+0x36>
    80002b64:	44dc                	lw	a5,12(s1)
    80002b66:	ff3799e3          	bne	a5,s3,80002b58 <bread+0x36>
      b->refcnt++;
    80002b6a:	40bc                	lw	a5,64(s1)
    80002b6c:	2785                	addiw	a5,a5,1
    80002b6e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b70:	00019517          	auipc	a0,0x19
    80002b74:	b4050513          	addi	a0,a0,-1216 # 8001b6b0 <bcache>
    80002b78:	8bafe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002b7c:	01048513          	addi	a0,s1,16
    80002b80:	1d8010ef          	jal	ra,80003d58 <acquiresleep>
      return b;
    80002b84:	a889                	j	80002bd6 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b86:	00021497          	auipc	s1,0x21
    80002b8a:	dda4b483          	ld	s1,-550(s1) # 80023960 <bcache+0x82b0>
    80002b8e:	00021797          	auipc	a5,0x21
    80002b92:	d8a78793          	addi	a5,a5,-630 # 80023918 <bcache+0x8268>
    80002b96:	00f48863          	beq	s1,a5,80002ba6 <bread+0x84>
    80002b9a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002b9c:	40bc                	lw	a5,64(s1)
    80002b9e:	cb91                	beqz	a5,80002bb2 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ba0:	64a4                	ld	s1,72(s1)
    80002ba2:	fee49de3          	bne	s1,a4,80002b9c <bread+0x7a>
  panic("bget: no buffers");
    80002ba6:	00005517          	auipc	a0,0x5
    80002baa:	9ca50513          	addi	a0,a0,-1590 # 80007570 <syscalls+0xe0>
    80002bae:	ba9fd0ef          	jal	ra,80000756 <panic>
      b->dev = dev;
    80002bb2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bb6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bba:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002bbe:	4785                	li	a5,1
    80002bc0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bc2:	00019517          	auipc	a0,0x19
    80002bc6:	aee50513          	addi	a0,a0,-1298 # 8001b6b0 <bcache>
    80002bca:	868fe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002bce:	01048513          	addi	a0,s1,16
    80002bd2:	186010ef          	jal	ra,80003d58 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002bd6:	409c                	lw	a5,0(s1)
    80002bd8:	cb89                	beqz	a5,80002bea <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002bda:	8526                	mv	a0,s1
    80002bdc:	70a2                	ld	ra,40(sp)
    80002bde:	7402                	ld	s0,32(sp)
    80002be0:	64e2                	ld	s1,24(sp)
    80002be2:	6942                	ld	s2,16(sp)
    80002be4:	69a2                	ld	s3,8(sp)
    80002be6:	6145                	addi	sp,sp,48
    80002be8:	8082                	ret
    virtio_disk_rw(b, 0);
    80002bea:	4581                	li	a1,0
    80002bec:	8526                	mv	a0,s1
    80002bee:	1df020ef          	jal	ra,800055cc <virtio_disk_rw>
    b->valid = 1;
    80002bf2:	4785                	li	a5,1
    80002bf4:	c09c                	sw	a5,0(s1)
  return b;
    80002bf6:	b7d5                	j	80002bda <bread+0xb8>

0000000080002bf8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002bf8:	1101                	addi	sp,sp,-32
    80002bfa:	ec06                	sd	ra,24(sp)
    80002bfc:	e822                	sd	s0,16(sp)
    80002bfe:	e426                	sd	s1,8(sp)
    80002c00:	1000                	addi	s0,sp,32
    80002c02:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c04:	0541                	addi	a0,a0,16
    80002c06:	1d0010ef          	jal	ra,80003dd6 <holdingsleep>
    80002c0a:	c911                	beqz	a0,80002c1e <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c0c:	4585                	li	a1,1
    80002c0e:	8526                	mv	a0,s1
    80002c10:	1bd020ef          	jal	ra,800055cc <virtio_disk_rw>
}
    80002c14:	60e2                	ld	ra,24(sp)
    80002c16:	6442                	ld	s0,16(sp)
    80002c18:	64a2                	ld	s1,8(sp)
    80002c1a:	6105                	addi	sp,sp,32
    80002c1c:	8082                	ret
    panic("bwrite");
    80002c1e:	00005517          	auipc	a0,0x5
    80002c22:	96a50513          	addi	a0,a0,-1686 # 80007588 <syscalls+0xf8>
    80002c26:	b31fd0ef          	jal	ra,80000756 <panic>

0000000080002c2a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
    80002c36:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c38:	01050913          	addi	s2,a0,16
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	198010ef          	jal	ra,80003dd6 <holdingsleep>
    80002c42:	c13d                	beqz	a0,80002ca8 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002c44:	854a                	mv	a0,s2
    80002c46:	158010ef          	jal	ra,80003d9e <releasesleep>

  acquire(&bcache.lock);
    80002c4a:	00019517          	auipc	a0,0x19
    80002c4e:	a6650513          	addi	a0,a0,-1434 # 8001b6b0 <bcache>
    80002c52:	f49fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002c56:	40bc                	lw	a5,64(s1)
    80002c58:	37fd                	addiw	a5,a5,-1
    80002c5a:	0007871b          	sext.w	a4,a5
    80002c5e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c60:	eb05                	bnez	a4,80002c90 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c62:	68bc                	ld	a5,80(s1)
    80002c64:	64b8                	ld	a4,72(s1)
    80002c66:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002c68:	64bc                	ld	a5,72(s1)
    80002c6a:	68b8                	ld	a4,80(s1)
    80002c6c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c6e:	00021797          	auipc	a5,0x21
    80002c72:	a4278793          	addi	a5,a5,-1470 # 800236b0 <bcache+0x8000>
    80002c76:	2b87b703          	ld	a4,696(a5)
    80002c7a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002c7c:	00021717          	auipc	a4,0x21
    80002c80:	c9c70713          	addi	a4,a4,-868 # 80023918 <bcache+0x8268>
    80002c84:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002c86:	2b87b703          	ld	a4,696(a5)
    80002c8a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002c8c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002c90:	00019517          	auipc	a0,0x19
    80002c94:	a2050513          	addi	a0,a0,-1504 # 8001b6b0 <bcache>
    80002c98:	f9bfd0ef          	jal	ra,80000c32 <release>
}
    80002c9c:	60e2                	ld	ra,24(sp)
    80002c9e:	6442                	ld	s0,16(sp)
    80002ca0:	64a2                	ld	s1,8(sp)
    80002ca2:	6902                	ld	s2,0(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret
    panic("brelse");
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	8e850513          	addi	a0,a0,-1816 # 80007590 <syscalls+0x100>
    80002cb0:	aa7fd0ef          	jal	ra,80000756 <panic>

0000000080002cb4 <bpin>:

void
bpin(struct buf *b) {
    80002cb4:	1101                	addi	sp,sp,-32
    80002cb6:	ec06                	sd	ra,24(sp)
    80002cb8:	e822                	sd	s0,16(sp)
    80002cba:	e426                	sd	s1,8(sp)
    80002cbc:	1000                	addi	s0,sp,32
    80002cbe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cc0:	00019517          	auipc	a0,0x19
    80002cc4:	9f050513          	addi	a0,a0,-1552 # 8001b6b0 <bcache>
    80002cc8:	ed3fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt++;
    80002ccc:	40bc                	lw	a5,64(s1)
    80002cce:	2785                	addiw	a5,a5,1
    80002cd0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002cd2:	00019517          	auipc	a0,0x19
    80002cd6:	9de50513          	addi	a0,a0,-1570 # 8001b6b0 <bcache>
    80002cda:	f59fd0ef          	jal	ra,80000c32 <release>
}
    80002cde:	60e2                	ld	ra,24(sp)
    80002ce0:	6442                	ld	s0,16(sp)
    80002ce2:	64a2                	ld	s1,8(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret

0000000080002ce8 <bunpin>:

void
bunpin(struct buf *b) {
    80002ce8:	1101                	addi	sp,sp,-32
    80002cea:	ec06                	sd	ra,24(sp)
    80002cec:	e822                	sd	s0,16(sp)
    80002cee:	e426                	sd	s1,8(sp)
    80002cf0:	1000                	addi	s0,sp,32
    80002cf2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cf4:	00019517          	auipc	a0,0x19
    80002cf8:	9bc50513          	addi	a0,a0,-1604 # 8001b6b0 <bcache>
    80002cfc:	e9ffd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002d00:	40bc                	lw	a5,64(s1)
    80002d02:	37fd                	addiw	a5,a5,-1
    80002d04:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d06:	00019517          	auipc	a0,0x19
    80002d0a:	9aa50513          	addi	a0,a0,-1622 # 8001b6b0 <bcache>
    80002d0e:	f25fd0ef          	jal	ra,80000c32 <release>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret

0000000080002d1c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	e04a                	sd	s2,0(sp)
    80002d26:	1000                	addi	s0,sp,32
    80002d28:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d2a:	00d5d59b          	srliw	a1,a1,0xd
    80002d2e:	00021797          	auipc	a5,0x21
    80002d32:	05e7a783          	lw	a5,94(a5) # 80023d8c <sb+0x1c>
    80002d36:	9dbd                	addw	a1,a1,a5
    80002d38:	debff0ef          	jal	ra,80002b22 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d3c:	0074f713          	andi	a4,s1,7
    80002d40:	4785                	li	a5,1
    80002d42:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d46:	14ce                	slli	s1,s1,0x33
    80002d48:	90d9                	srli	s1,s1,0x36
    80002d4a:	00950733          	add	a4,a0,s1
    80002d4e:	05874703          	lbu	a4,88(a4)
    80002d52:	00e7f6b3          	and	a3,a5,a4
    80002d56:	c29d                	beqz	a3,80002d7c <bfree+0x60>
    80002d58:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d5a:	94aa                	add	s1,s1,a0
    80002d5c:	fff7c793          	not	a5,a5
    80002d60:	8ff9                	and	a5,a5,a4
    80002d62:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002d66:	6eb000ef          	jal	ra,80003c50 <log_write>
  brelse(bp);
    80002d6a:	854a                	mv	a0,s2
    80002d6c:	ebfff0ef          	jal	ra,80002c2a <brelse>
}
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	64a2                	ld	s1,8(sp)
    80002d76:	6902                	ld	s2,0(sp)
    80002d78:	6105                	addi	sp,sp,32
    80002d7a:	8082                	ret
    panic("freeing free block");
    80002d7c:	00005517          	auipc	a0,0x5
    80002d80:	81c50513          	addi	a0,a0,-2020 # 80007598 <syscalls+0x108>
    80002d84:	9d3fd0ef          	jal	ra,80000756 <panic>

0000000080002d88 <balloc>:
{
    80002d88:	711d                	addi	sp,sp,-96
    80002d8a:	ec86                	sd	ra,88(sp)
    80002d8c:	e8a2                	sd	s0,80(sp)
    80002d8e:	e4a6                	sd	s1,72(sp)
    80002d90:	e0ca                	sd	s2,64(sp)
    80002d92:	fc4e                	sd	s3,56(sp)
    80002d94:	f852                	sd	s4,48(sp)
    80002d96:	f456                	sd	s5,40(sp)
    80002d98:	f05a                	sd	s6,32(sp)
    80002d9a:	ec5e                	sd	s7,24(sp)
    80002d9c:	e862                	sd	s8,16(sp)
    80002d9e:	e466                	sd	s9,8(sp)
    80002da0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002da2:	00021797          	auipc	a5,0x21
    80002da6:	fd27a783          	lw	a5,-46(a5) # 80023d74 <sb+0x4>
    80002daa:	0e078163          	beqz	a5,80002e8c <balloc+0x104>
    80002dae:	8baa                	mv	s7,a0
    80002db0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002db2:	00021b17          	auipc	s6,0x21
    80002db6:	fbeb0b13          	addi	s6,s6,-66 # 80023d70 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002dbc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dbe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002dc0:	6c89                	lui	s9,0x2
    80002dc2:	a0b5                	j	80002e2e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002dc4:	974a                	add	a4,a4,s2
    80002dc6:	8fd5                	or	a5,a5,a3
    80002dc8:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002dcc:	854a                	mv	a0,s2
    80002dce:	683000ef          	jal	ra,80003c50 <log_write>
        brelse(bp);
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	e57ff0ef          	jal	ra,80002c2a <brelse>
  bp = bread(dev, bno);
    80002dd8:	85a6                	mv	a1,s1
    80002dda:	855e                	mv	a0,s7
    80002ddc:	d47ff0ef          	jal	ra,80002b22 <bread>
    80002de0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002de2:	40000613          	li	a2,1024
    80002de6:	4581                	li	a1,0
    80002de8:	05850513          	addi	a0,a0,88
    80002dec:	e83fd0ef          	jal	ra,80000c6e <memset>
  log_write(bp);
    80002df0:	854a                	mv	a0,s2
    80002df2:	65f000ef          	jal	ra,80003c50 <log_write>
  brelse(bp);
    80002df6:	854a                	mv	a0,s2
    80002df8:	e33ff0ef          	jal	ra,80002c2a <brelse>
}
    80002dfc:	8526                	mv	a0,s1
    80002dfe:	60e6                	ld	ra,88(sp)
    80002e00:	6446                	ld	s0,80(sp)
    80002e02:	64a6                	ld	s1,72(sp)
    80002e04:	6906                	ld	s2,64(sp)
    80002e06:	79e2                	ld	s3,56(sp)
    80002e08:	7a42                	ld	s4,48(sp)
    80002e0a:	7aa2                	ld	s5,40(sp)
    80002e0c:	7b02                	ld	s6,32(sp)
    80002e0e:	6be2                	ld	s7,24(sp)
    80002e10:	6c42                	ld	s8,16(sp)
    80002e12:	6ca2                	ld	s9,8(sp)
    80002e14:	6125                	addi	sp,sp,96
    80002e16:	8082                	ret
    brelse(bp);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	e11ff0ef          	jal	ra,80002c2a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e1e:	015c87bb          	addw	a5,s9,s5
    80002e22:	00078a9b          	sext.w	s5,a5
    80002e26:	004b2703          	lw	a4,4(s6)
    80002e2a:	06eaf163          	bgeu	s5,a4,80002e8c <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002e2e:	41fad79b          	sraiw	a5,s5,0x1f
    80002e32:	0137d79b          	srliw	a5,a5,0x13
    80002e36:	015787bb          	addw	a5,a5,s5
    80002e3a:	40d7d79b          	sraiw	a5,a5,0xd
    80002e3e:	01cb2583          	lw	a1,28(s6)
    80002e42:	9dbd                	addw	a1,a1,a5
    80002e44:	855e                	mv	a0,s7
    80002e46:	cddff0ef          	jal	ra,80002b22 <bread>
    80002e4a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e4c:	004b2503          	lw	a0,4(s6)
    80002e50:	000a849b          	sext.w	s1,s5
    80002e54:	8662                	mv	a2,s8
    80002e56:	fca4f1e3          	bgeu	s1,a0,80002e18 <balloc+0x90>
      m = 1 << (bi % 8);
    80002e5a:	41f6579b          	sraiw	a5,a2,0x1f
    80002e5e:	01d7d69b          	srliw	a3,a5,0x1d
    80002e62:	00c6873b          	addw	a4,a3,a2
    80002e66:	00777793          	andi	a5,a4,7
    80002e6a:	9f95                	subw	a5,a5,a3
    80002e6c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e70:	4037571b          	sraiw	a4,a4,0x3
    80002e74:	00e906b3          	add	a3,s2,a4
    80002e78:	0586c683          	lbu	a3,88(a3)
    80002e7c:	00d7f5b3          	and	a1,a5,a3
    80002e80:	d1b1                	beqz	a1,80002dc4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e82:	2605                	addiw	a2,a2,1
    80002e84:	2485                	addiw	s1,s1,1
    80002e86:	fd4618e3          	bne	a2,s4,80002e56 <balloc+0xce>
    80002e8a:	b779                	j	80002e18 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002e8c:	00004517          	auipc	a0,0x4
    80002e90:	72450513          	addi	a0,a0,1828 # 800075b0 <syscalls+0x120>
    80002e94:	e0efd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002e98:	4481                	li	s1,0
    80002e9a:	b78d                	j	80002dfc <balloc+0x74>

0000000080002e9c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002e9c:	7179                	addi	sp,sp,-48
    80002e9e:	f406                	sd	ra,40(sp)
    80002ea0:	f022                	sd	s0,32(sp)
    80002ea2:	ec26                	sd	s1,24(sp)
    80002ea4:	e84a                	sd	s2,16(sp)
    80002ea6:	e44e                	sd	s3,8(sp)
    80002ea8:	e052                	sd	s4,0(sp)
    80002eaa:	1800                	addi	s0,sp,48
    80002eac:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002eae:	47a5                	li	a5,9
    80002eb0:	02b7e563          	bltu	a5,a1,80002eda <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002eb4:	02059493          	slli	s1,a1,0x20
    80002eb8:	9081                	srli	s1,s1,0x20
    80002eba:	048a                	slli	s1,s1,0x2
    80002ebc:	94aa                	add	s1,s1,a0
    80002ebe:	0504a903          	lw	s2,80(s1)
    80002ec2:	06091663          	bnez	s2,80002f2e <bmap+0x92>
      addr = balloc(ip->dev);
    80002ec6:	4108                	lw	a0,0(a0)
    80002ec8:	ec1ff0ef          	jal	ra,80002d88 <balloc>
    80002ecc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ed0:	04090f63          	beqz	s2,80002f2e <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80002ed4:	0524a823          	sw	s2,80(s1)
    80002ed8:	a899                	j	80002f2e <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002eda:	ff65849b          	addiw	s1,a1,-10
    80002ede:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ee2:	0ff00793          	li	a5,255
    80002ee6:	06e7eb63          	bltu	a5,a4,80002f5c <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002eea:	07852903          	lw	s2,120(a0)
    80002eee:	00091b63          	bnez	s2,80002f04 <bmap+0x68>
      addr = balloc(ip->dev);
    80002ef2:	4108                	lw	a0,0(a0)
    80002ef4:	e95ff0ef          	jal	ra,80002d88 <balloc>
    80002ef8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002efc:	02090963          	beqz	s2,80002f2e <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f00:	0729ac23          	sw	s2,120(s3)
    }
    bp = bread(ip->dev, addr);
    80002f04:	85ca                	mv	a1,s2
    80002f06:	0009a503          	lw	a0,0(s3)
    80002f0a:	c19ff0ef          	jal	ra,80002b22 <bread>
    80002f0e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f10:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f14:	02049593          	slli	a1,s1,0x20
    80002f18:	9181                	srli	a1,a1,0x20
    80002f1a:	058a                	slli	a1,a1,0x2
    80002f1c:	00b784b3          	add	s1,a5,a1
    80002f20:	0004a903          	lw	s2,0(s1)
    80002f24:	00090e63          	beqz	s2,80002f40 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f28:	8552                	mv	a0,s4
    80002f2a:	d01ff0ef          	jal	ra,80002c2a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002f2e:	854a                	mv	a0,s2
    80002f30:	70a2                	ld	ra,40(sp)
    80002f32:	7402                	ld	s0,32(sp)
    80002f34:	64e2                	ld	s1,24(sp)
    80002f36:	6942                	ld	s2,16(sp)
    80002f38:	69a2                	ld	s3,8(sp)
    80002f3a:	6a02                	ld	s4,0(sp)
    80002f3c:	6145                	addi	sp,sp,48
    80002f3e:	8082                	ret
      addr = balloc(ip->dev);
    80002f40:	0009a503          	lw	a0,0(s3)
    80002f44:	e45ff0ef          	jal	ra,80002d88 <balloc>
    80002f48:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f4c:	fc090ee3          	beqz	s2,80002f28 <bmap+0x8c>
        a[bn] = addr;
    80002f50:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002f54:	8552                	mv	a0,s4
    80002f56:	4fb000ef          	jal	ra,80003c50 <log_write>
    80002f5a:	b7f9                	j	80002f28 <bmap+0x8c>
  panic("bmap: out of range");
    80002f5c:	00004517          	auipc	a0,0x4
    80002f60:	66c50513          	addi	a0,a0,1644 # 800075c8 <syscalls+0x138>
    80002f64:	ff2fd0ef          	jal	ra,80000756 <panic>

0000000080002f68 <iget>:
{
    80002f68:	7179                	addi	sp,sp,-48
    80002f6a:	f406                	sd	ra,40(sp)
    80002f6c:	f022                	sd	s0,32(sp)
    80002f6e:	ec26                	sd	s1,24(sp)
    80002f70:	e84a                	sd	s2,16(sp)
    80002f72:	e44e                	sd	s3,8(sp)
    80002f74:	e052                	sd	s4,0(sp)
    80002f76:	1800                	addi	s0,sp,48
    80002f78:	89aa                	mv	s3,a0
    80002f7a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f7c:	00021517          	auipc	a0,0x21
    80002f80:	e1450513          	addi	a0,a0,-492 # 80023d90 <itable>
    80002f84:	c17fd0ef          	jal	ra,80000b9a <acquire>
  empty = 0;
    80002f88:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f8a:	00021497          	auipc	s1,0x21
    80002f8e:	e1e48493          	addi	s1,s1,-482 # 80023da8 <itable+0x18>
    80002f92:	00022697          	auipc	a3,0x22
    80002f96:	71668693          	addi	a3,a3,1814 # 800256a8 <log>
    80002f9a:	a039                	j	80002fa8 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f9c:	02090963          	beqz	s2,80002fce <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fa0:	08048493          	addi	s1,s1,128
    80002fa4:	02d48863          	beq	s1,a3,80002fd4 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fa8:	449c                	lw	a5,8(s1)
    80002faa:	fef059e3          	blez	a5,80002f9c <iget+0x34>
    80002fae:	4098                	lw	a4,0(s1)
    80002fb0:	ff3716e3          	bne	a4,s3,80002f9c <iget+0x34>
    80002fb4:	40d8                	lw	a4,4(s1)
    80002fb6:	ff4713e3          	bne	a4,s4,80002f9c <iget+0x34>
      ip->ref++;
    80002fba:	2785                	addiw	a5,a5,1
    80002fbc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fbe:	00021517          	auipc	a0,0x21
    80002fc2:	dd250513          	addi	a0,a0,-558 # 80023d90 <itable>
    80002fc6:	c6dfd0ef          	jal	ra,80000c32 <release>
      return ip;
    80002fca:	8926                	mv	s2,s1
    80002fcc:	a02d                	j	80002ff6 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fce:	fbe9                	bnez	a5,80002fa0 <iget+0x38>
    80002fd0:	8926                	mv	s2,s1
    80002fd2:	b7f9                	j	80002fa0 <iget+0x38>
  if(empty == 0)
    80002fd4:	02090a63          	beqz	s2,80003008 <iget+0xa0>
  ip->dev = dev;
    80002fd8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002fdc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002fe0:	4785                	li	a5,1
    80002fe2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002fe6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002fea:	00021517          	auipc	a0,0x21
    80002fee:	da650513          	addi	a0,a0,-602 # 80023d90 <itable>
    80002ff2:	c41fd0ef          	jal	ra,80000c32 <release>
}
    80002ff6:	854a                	mv	a0,s2
    80002ff8:	70a2                	ld	ra,40(sp)
    80002ffa:	7402                	ld	s0,32(sp)
    80002ffc:	64e2                	ld	s1,24(sp)
    80002ffe:	6942                	ld	s2,16(sp)
    80003000:	69a2                	ld	s3,8(sp)
    80003002:	6a02                	ld	s4,0(sp)
    80003004:	6145                	addi	sp,sp,48
    80003006:	8082                	ret
    panic("iget: no inodes");
    80003008:	00004517          	auipc	a0,0x4
    8000300c:	5d850513          	addi	a0,a0,1496 # 800075e0 <syscalls+0x150>
    80003010:	f46fd0ef          	jal	ra,80000756 <panic>

0000000080003014 <fsinit>:
fsinit(int dev) {
    80003014:	7179                	addi	sp,sp,-48
    80003016:	f406                	sd	ra,40(sp)
    80003018:	f022                	sd	s0,32(sp)
    8000301a:	ec26                	sd	s1,24(sp)
    8000301c:	e84a                	sd	s2,16(sp)
    8000301e:	e44e                	sd	s3,8(sp)
    80003020:	1800                	addi	s0,sp,48
    80003022:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003024:	4585                	li	a1,1
    80003026:	afdff0ef          	jal	ra,80002b22 <bread>
    8000302a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000302c:	00021997          	auipc	s3,0x21
    80003030:	d4498993          	addi	s3,s3,-700 # 80023d70 <sb>
    80003034:	02000613          	li	a2,32
    80003038:	05850593          	addi	a1,a0,88
    8000303c:	854e                	mv	a0,s3
    8000303e:	c8dfd0ef          	jal	ra,80000cca <memmove>
  brelse(bp);
    80003042:	8526                	mv	a0,s1
    80003044:	be7ff0ef          	jal	ra,80002c2a <brelse>
  if(sb.magic != FSMAGIC)
    80003048:	0009a703          	lw	a4,0(s3)
    8000304c:	102037b7          	lui	a5,0x10203
    80003050:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003054:	02f71063          	bne	a4,a5,80003074 <fsinit+0x60>
  initlog(dev, &sb);
    80003058:	00021597          	auipc	a1,0x21
    8000305c:	d1858593          	addi	a1,a1,-744 # 80023d70 <sb>
    80003060:	854a                	mv	a0,s2
    80003062:	1db000ef          	jal	ra,80003a3c <initlog>
}
    80003066:	70a2                	ld	ra,40(sp)
    80003068:	7402                	ld	s0,32(sp)
    8000306a:	64e2                	ld	s1,24(sp)
    8000306c:	6942                	ld	s2,16(sp)
    8000306e:	69a2                	ld	s3,8(sp)
    80003070:	6145                	addi	sp,sp,48
    80003072:	8082                	ret
    panic("invalid file system");
    80003074:	00004517          	auipc	a0,0x4
    80003078:	57c50513          	addi	a0,a0,1404 # 800075f0 <syscalls+0x160>
    8000307c:	edafd0ef          	jal	ra,80000756 <panic>

0000000080003080 <iinit>:
{
    80003080:	7179                	addi	sp,sp,-48
    80003082:	f406                	sd	ra,40(sp)
    80003084:	f022                	sd	s0,32(sp)
    80003086:	ec26                	sd	s1,24(sp)
    80003088:	e84a                	sd	s2,16(sp)
    8000308a:	e44e                	sd	s3,8(sp)
    8000308c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000308e:	00004597          	auipc	a1,0x4
    80003092:	57a58593          	addi	a1,a1,1402 # 80007608 <syscalls+0x178>
    80003096:	00021517          	auipc	a0,0x21
    8000309a:	cfa50513          	addi	a0,a0,-774 # 80023d90 <itable>
    8000309e:	a7dfd0ef          	jal	ra,80000b1a <initlock>
  for(i = 0; i < NINODE; i++) {
    800030a2:	00021497          	auipc	s1,0x21
    800030a6:	d1648493          	addi	s1,s1,-746 # 80023db8 <itable+0x28>
    800030aa:	00022997          	auipc	s3,0x22
    800030ae:	60e98993          	addi	s3,s3,1550 # 800256b8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030b2:	00004917          	auipc	s2,0x4
    800030b6:	55e90913          	addi	s2,s2,1374 # 80007610 <syscalls+0x180>
    800030ba:	85ca                	mv	a1,s2
    800030bc:	8526                	mv	a0,s1
    800030be:	465000ef          	jal	ra,80003d22 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800030c2:	08048493          	addi	s1,s1,128
    800030c6:	ff349ae3          	bne	s1,s3,800030ba <iinit+0x3a>
}
    800030ca:	70a2                	ld	ra,40(sp)
    800030cc:	7402                	ld	s0,32(sp)
    800030ce:	64e2                	ld	s1,24(sp)
    800030d0:	6942                	ld	s2,16(sp)
    800030d2:	69a2                	ld	s3,8(sp)
    800030d4:	6145                	addi	sp,sp,48
    800030d6:	8082                	ret

00000000800030d8 <ialloc>:
{
    800030d8:	715d                	addi	sp,sp,-80
    800030da:	e486                	sd	ra,72(sp)
    800030dc:	e0a2                	sd	s0,64(sp)
    800030de:	fc26                	sd	s1,56(sp)
    800030e0:	f84a                	sd	s2,48(sp)
    800030e2:	f44e                	sd	s3,40(sp)
    800030e4:	f052                	sd	s4,32(sp)
    800030e6:	ec56                	sd	s5,24(sp)
    800030e8:	e85a                	sd	s6,16(sp)
    800030ea:	e45e                	sd	s7,8(sp)
    800030ec:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800030ee:	00021717          	auipc	a4,0x21
    800030f2:	c8e72703          	lw	a4,-882(a4) # 80023d7c <sb+0xc>
    800030f6:	4785                	li	a5,1
    800030f8:	04e7f663          	bgeu	a5,a4,80003144 <ialloc+0x6c>
    800030fc:	8aaa                	mv	s5,a0
    800030fe:	8bae                	mv	s7,a1
    80003100:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003102:	00021a17          	auipc	s4,0x21
    80003106:	c6ea0a13          	addi	s4,s4,-914 # 80023d70 <sb>
    8000310a:	00048b1b          	sext.w	s6,s1
    8000310e:	0044d793          	srli	a5,s1,0x4
    80003112:	018a2583          	lw	a1,24(s4)
    80003116:	9dbd                	addw	a1,a1,a5
    80003118:	8556                	mv	a0,s5
    8000311a:	a09ff0ef          	jal	ra,80002b22 <bread>
    8000311e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003120:	05850993          	addi	s3,a0,88
    80003124:	00f4f793          	andi	a5,s1,15
    80003128:	079a                	slli	a5,a5,0x6
    8000312a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000312c:	00099783          	lh	a5,0(s3)
    80003130:	cf85                	beqz	a5,80003168 <ialloc+0x90>
    brelse(bp);
    80003132:	af9ff0ef          	jal	ra,80002c2a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003136:	0485                	addi	s1,s1,1
    80003138:	00ca2703          	lw	a4,12(s4)
    8000313c:	0004879b          	sext.w	a5,s1
    80003140:	fce7e5e3          	bltu	a5,a4,8000310a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003144:	00004517          	auipc	a0,0x4
    80003148:	4d450513          	addi	a0,a0,1236 # 80007618 <syscalls+0x188>
    8000314c:	b56fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80003150:	4501                	li	a0,0
}
    80003152:	60a6                	ld	ra,72(sp)
    80003154:	6406                	ld	s0,64(sp)
    80003156:	74e2                	ld	s1,56(sp)
    80003158:	7942                	ld	s2,48(sp)
    8000315a:	79a2                	ld	s3,40(sp)
    8000315c:	7a02                	ld	s4,32(sp)
    8000315e:	6ae2                	ld	s5,24(sp)
    80003160:	6b42                	ld	s6,16(sp)
    80003162:	6ba2                	ld	s7,8(sp)
    80003164:	6161                	addi	sp,sp,80
    80003166:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003168:	04000613          	li	a2,64
    8000316c:	4581                	li	a1,0
    8000316e:	854e                	mv	a0,s3
    80003170:	afffd0ef          	jal	ra,80000c6e <memset>
      dip->type = type;
    80003174:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003178:	854a                	mv	a0,s2
    8000317a:	2d7000ef          	jal	ra,80003c50 <log_write>
      brelse(bp);
    8000317e:	854a                	mv	a0,s2
    80003180:	aabff0ef          	jal	ra,80002c2a <brelse>
      return iget(dev, inum);
    80003184:	85da                	mv	a1,s6
    80003186:	8556                	mv	a0,s5
    80003188:	de1ff0ef          	jal	ra,80002f68 <iget>
    8000318c:	b7d9                	j	80003152 <ialloc+0x7a>

000000008000318e <iupdate>:
{
    8000318e:	1101                	addi	sp,sp,-32
    80003190:	ec06                	sd	ra,24(sp)
    80003192:	e822                	sd	s0,16(sp)
    80003194:	e426                	sd	s1,8(sp)
    80003196:	e04a                	sd	s2,0(sp)
    80003198:	1000                	addi	s0,sp,32
    8000319a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000319c:	415c                	lw	a5,4(a0)
    8000319e:	0047d79b          	srliw	a5,a5,0x4
    800031a2:	00021597          	auipc	a1,0x21
    800031a6:	be65a583          	lw	a1,-1050(a1) # 80023d88 <sb+0x18>
    800031aa:	9dbd                	addw	a1,a1,a5
    800031ac:	4108                	lw	a0,0(a0)
    800031ae:	975ff0ef          	jal	ra,80002b22 <bread>
    800031b2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031b4:	05850793          	addi	a5,a0,88
    800031b8:	40c8                	lw	a0,4(s1)
    800031ba:	893d                	andi	a0,a0,15
    800031bc:	051a                	slli	a0,a0,0x6
    800031be:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800031c0:	04449703          	lh	a4,68(s1)
    800031c4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800031c8:	04649703          	lh	a4,70(s1)
    800031cc:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800031d0:	04849703          	lh	a4,72(s1)
    800031d4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800031d8:	04a49703          	lh	a4,74(s1)
    800031dc:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800031e0:	44f8                	lw	a4,76(s1)
    800031e2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031e4:	02c00613          	li	a2,44
    800031e8:	05048593          	addi	a1,s1,80
    800031ec:	0531                	addi	a0,a0,12
    800031ee:	addfd0ef          	jal	ra,80000cca <memmove>
  log_write(bp);
    800031f2:	854a                	mv	a0,s2
    800031f4:	25d000ef          	jal	ra,80003c50 <log_write>
  brelse(bp);
    800031f8:	854a                	mv	a0,s2
    800031fa:	a31ff0ef          	jal	ra,80002c2a <brelse>
}
    800031fe:	60e2                	ld	ra,24(sp)
    80003200:	6442                	ld	s0,16(sp)
    80003202:	64a2                	ld	s1,8(sp)
    80003204:	6902                	ld	s2,0(sp)
    80003206:	6105                	addi	sp,sp,32
    80003208:	8082                	ret

000000008000320a <idup>:
{
    8000320a:	1101                	addi	sp,sp,-32
    8000320c:	ec06                	sd	ra,24(sp)
    8000320e:	e822                	sd	s0,16(sp)
    80003210:	e426                	sd	s1,8(sp)
    80003212:	1000                	addi	s0,sp,32
    80003214:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003216:	00021517          	auipc	a0,0x21
    8000321a:	b7a50513          	addi	a0,a0,-1158 # 80023d90 <itable>
    8000321e:	97dfd0ef          	jal	ra,80000b9a <acquire>
  ip->ref++;
    80003222:	449c                	lw	a5,8(s1)
    80003224:	2785                	addiw	a5,a5,1
    80003226:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003228:	00021517          	auipc	a0,0x21
    8000322c:	b6850513          	addi	a0,a0,-1176 # 80023d90 <itable>
    80003230:	a03fd0ef          	jal	ra,80000c32 <release>
}
    80003234:	8526                	mv	a0,s1
    80003236:	60e2                	ld	ra,24(sp)
    80003238:	6442                	ld	s0,16(sp)
    8000323a:	64a2                	ld	s1,8(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret

0000000080003240 <ilock>:
{
    80003240:	1101                	addi	sp,sp,-32
    80003242:	ec06                	sd	ra,24(sp)
    80003244:	e822                	sd	s0,16(sp)
    80003246:	e426                	sd	s1,8(sp)
    80003248:	e04a                	sd	s2,0(sp)
    8000324a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000324c:	c105                	beqz	a0,8000326c <ilock+0x2c>
    8000324e:	84aa                	mv	s1,a0
    80003250:	451c                	lw	a5,8(a0)
    80003252:	00f05d63          	blez	a5,8000326c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003256:	0541                	addi	a0,a0,16
    80003258:	301000ef          	jal	ra,80003d58 <acquiresleep>
  if(ip->valid == 0){
    8000325c:	40bc                	lw	a5,64(s1)
    8000325e:	cf89                	beqz	a5,80003278 <ilock+0x38>
}
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	64a2                	ld	s1,8(sp)
    80003266:	6902                	ld	s2,0(sp)
    80003268:	6105                	addi	sp,sp,32
    8000326a:	8082                	ret
    panic("ilock");
    8000326c:	00004517          	auipc	a0,0x4
    80003270:	3c450513          	addi	a0,a0,964 # 80007630 <syscalls+0x1a0>
    80003274:	ce2fd0ef          	jal	ra,80000756 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003278:	40dc                	lw	a5,4(s1)
    8000327a:	0047d79b          	srliw	a5,a5,0x4
    8000327e:	00021597          	auipc	a1,0x21
    80003282:	b0a5a583          	lw	a1,-1270(a1) # 80023d88 <sb+0x18>
    80003286:	9dbd                	addw	a1,a1,a5
    80003288:	4088                	lw	a0,0(s1)
    8000328a:	899ff0ef          	jal	ra,80002b22 <bread>
    8000328e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003290:	05850593          	addi	a1,a0,88
    80003294:	40dc                	lw	a5,4(s1)
    80003296:	8bbd                	andi	a5,a5,15
    80003298:	079a                	slli	a5,a5,0x6
    8000329a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000329c:	00059783          	lh	a5,0(a1)
    800032a0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032a4:	00259783          	lh	a5,2(a1)
    800032a8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032ac:	00459783          	lh	a5,4(a1)
    800032b0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032b4:	00659783          	lh	a5,6(a1)
    800032b8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032bc:	459c                	lw	a5,8(a1)
    800032be:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032c0:	02c00613          	li	a2,44
    800032c4:	05b1                	addi	a1,a1,12
    800032c6:	05048513          	addi	a0,s1,80
    800032ca:	a01fd0ef          	jal	ra,80000cca <memmove>
    brelse(bp);
    800032ce:	854a                	mv	a0,s2
    800032d0:	95bff0ef          	jal	ra,80002c2a <brelse>
    ip->valid = 1;
    800032d4:	4785                	li	a5,1
    800032d6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032d8:	04449783          	lh	a5,68(s1)
    800032dc:	f3d1                	bnez	a5,80003260 <ilock+0x20>
      panic("ilock: no type");
    800032de:	00004517          	auipc	a0,0x4
    800032e2:	35a50513          	addi	a0,a0,858 # 80007638 <syscalls+0x1a8>
    800032e6:	c70fd0ef          	jal	ra,80000756 <panic>

00000000800032ea <iunlock>:
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032f6:	c505                	beqz	a0,8000331e <iunlock+0x34>
    800032f8:	84aa                	mv	s1,a0
    800032fa:	01050913          	addi	s2,a0,16
    800032fe:	854a                	mv	a0,s2
    80003300:	2d7000ef          	jal	ra,80003dd6 <holdingsleep>
    80003304:	cd09                	beqz	a0,8000331e <iunlock+0x34>
    80003306:	449c                	lw	a5,8(s1)
    80003308:	00f05b63          	blez	a5,8000331e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000330c:	854a                	mv	a0,s2
    8000330e:	291000ef          	jal	ra,80003d9e <releasesleep>
}
    80003312:	60e2                	ld	ra,24(sp)
    80003314:	6442                	ld	s0,16(sp)
    80003316:	64a2                	ld	s1,8(sp)
    80003318:	6902                	ld	s2,0(sp)
    8000331a:	6105                	addi	sp,sp,32
    8000331c:	8082                	ret
    panic("iunlock");
    8000331e:	00004517          	auipc	a0,0x4
    80003322:	32a50513          	addi	a0,a0,810 # 80007648 <syscalls+0x1b8>
    80003326:	c30fd0ef          	jal	ra,80000756 <panic>

000000008000332a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000332a:	7179                	addi	sp,sp,-48
    8000332c:	f406                	sd	ra,40(sp)
    8000332e:	f022                	sd	s0,32(sp)
    80003330:	ec26                	sd	s1,24(sp)
    80003332:	e84a                	sd	s2,16(sp)
    80003334:	e44e                	sd	s3,8(sp)
    80003336:	e052                	sd	s4,0(sp)
    80003338:	1800                	addi	s0,sp,48
    8000333a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000333c:	05050493          	addi	s1,a0,80
    80003340:	07850913          	addi	s2,a0,120
    80003344:	a021                	j	8000334c <itrunc+0x22>
    80003346:	0491                	addi	s1,s1,4
    80003348:	01248b63          	beq	s1,s2,8000335e <itrunc+0x34>
    if(ip->addrs[i]){
    8000334c:	408c                	lw	a1,0(s1)
    8000334e:	dde5                	beqz	a1,80003346 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003350:	0009a503          	lw	a0,0(s3)
    80003354:	9c9ff0ef          	jal	ra,80002d1c <bfree>
      ip->addrs[i] = 0;
    80003358:	0004a023          	sw	zero,0(s1)
    8000335c:	b7ed                	j	80003346 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000335e:	0789a583          	lw	a1,120(s3)
    80003362:	ed91                	bnez	a1,8000337e <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003364:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003368:	854e                	mv	a0,s3
    8000336a:	e25ff0ef          	jal	ra,8000318e <iupdate>
}
    8000336e:	70a2                	ld	ra,40(sp)
    80003370:	7402                	ld	s0,32(sp)
    80003372:	64e2                	ld	s1,24(sp)
    80003374:	6942                	ld	s2,16(sp)
    80003376:	69a2                	ld	s3,8(sp)
    80003378:	6a02                	ld	s4,0(sp)
    8000337a:	6145                	addi	sp,sp,48
    8000337c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000337e:	0009a503          	lw	a0,0(s3)
    80003382:	fa0ff0ef          	jal	ra,80002b22 <bread>
    80003386:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003388:	05850493          	addi	s1,a0,88
    8000338c:	45850913          	addi	s2,a0,1112
    80003390:	a021                	j	80003398 <itrunc+0x6e>
    80003392:	0491                	addi	s1,s1,4
    80003394:	01248963          	beq	s1,s2,800033a6 <itrunc+0x7c>
      if(a[j])
    80003398:	408c                	lw	a1,0(s1)
    8000339a:	dde5                	beqz	a1,80003392 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    8000339c:	0009a503          	lw	a0,0(s3)
    800033a0:	97dff0ef          	jal	ra,80002d1c <bfree>
    800033a4:	b7fd                	j	80003392 <itrunc+0x68>
    brelse(bp);
    800033a6:	8552                	mv	a0,s4
    800033a8:	883ff0ef          	jal	ra,80002c2a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033ac:	0789a583          	lw	a1,120(s3)
    800033b0:	0009a503          	lw	a0,0(s3)
    800033b4:	969ff0ef          	jal	ra,80002d1c <bfree>
    ip->addrs[NDIRECT] = 0;
    800033b8:	0609ac23          	sw	zero,120(s3)
    800033bc:	b765                	j	80003364 <itrunc+0x3a>

00000000800033be <iput>:
{
    800033be:	1101                	addi	sp,sp,-32
    800033c0:	ec06                	sd	ra,24(sp)
    800033c2:	e822                	sd	s0,16(sp)
    800033c4:	e426                	sd	s1,8(sp)
    800033c6:	e04a                	sd	s2,0(sp)
    800033c8:	1000                	addi	s0,sp,32
    800033ca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033cc:	00021517          	auipc	a0,0x21
    800033d0:	9c450513          	addi	a0,a0,-1596 # 80023d90 <itable>
    800033d4:	fc6fd0ef          	jal	ra,80000b9a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033d8:	4498                	lw	a4,8(s1)
    800033da:	4785                	li	a5,1
    800033dc:	02f70163          	beq	a4,a5,800033fe <iput+0x40>
  ip->ref--;
    800033e0:	449c                	lw	a5,8(s1)
    800033e2:	37fd                	addiw	a5,a5,-1
    800033e4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033e6:	00021517          	auipc	a0,0x21
    800033ea:	9aa50513          	addi	a0,a0,-1622 # 80023d90 <itable>
    800033ee:	845fd0ef          	jal	ra,80000c32 <release>
}
    800033f2:	60e2                	ld	ra,24(sp)
    800033f4:	6442                	ld	s0,16(sp)
    800033f6:	64a2                	ld	s1,8(sp)
    800033f8:	6902                	ld	s2,0(sp)
    800033fa:	6105                	addi	sp,sp,32
    800033fc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033fe:	40bc                	lw	a5,64(s1)
    80003400:	d3e5                	beqz	a5,800033e0 <iput+0x22>
    80003402:	04a49783          	lh	a5,74(s1)
    80003406:	ffe9                	bnez	a5,800033e0 <iput+0x22>
    acquiresleep(&ip->lock);
    80003408:	01048913          	addi	s2,s1,16
    8000340c:	854a                	mv	a0,s2
    8000340e:	14b000ef          	jal	ra,80003d58 <acquiresleep>
    release(&itable.lock);
    80003412:	00021517          	auipc	a0,0x21
    80003416:	97e50513          	addi	a0,a0,-1666 # 80023d90 <itable>
    8000341a:	819fd0ef          	jal	ra,80000c32 <release>
    itrunc(ip);
    8000341e:	8526                	mv	a0,s1
    80003420:	f0bff0ef          	jal	ra,8000332a <itrunc>
    ip->type = 0;
    80003424:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003428:	8526                	mv	a0,s1
    8000342a:	d65ff0ef          	jal	ra,8000318e <iupdate>
    ip->valid = 0;
    8000342e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003432:	854a                	mv	a0,s2
    80003434:	16b000ef          	jal	ra,80003d9e <releasesleep>
    acquire(&itable.lock);
    80003438:	00021517          	auipc	a0,0x21
    8000343c:	95850513          	addi	a0,a0,-1704 # 80023d90 <itable>
    80003440:	f5afd0ef          	jal	ra,80000b9a <acquire>
    80003444:	bf71                	j	800033e0 <iput+0x22>

0000000080003446 <iunlockput>:
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	e426                	sd	s1,8(sp)
    8000344e:	1000                	addi	s0,sp,32
    80003450:	84aa                	mv	s1,a0
  iunlock(ip);
    80003452:	e99ff0ef          	jal	ra,800032ea <iunlock>
  iput(ip);
    80003456:	8526                	mv	a0,s1
    80003458:	f67ff0ef          	jal	ra,800033be <iput>
}
    8000345c:	60e2                	ld	ra,24(sp)
    8000345e:	6442                	ld	s0,16(sp)
    80003460:	64a2                	ld	s1,8(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003466:	1141                	addi	sp,sp,-16
    80003468:	e422                	sd	s0,8(sp)
    8000346a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000346c:	411c                	lw	a5,0(a0)
    8000346e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003470:	415c                	lw	a5,4(a0)
    80003472:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003474:	04451783          	lh	a5,68(a0)
    80003478:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000347c:	04a51783          	lh	a5,74(a0)
    80003480:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003484:	04c56783          	lwu	a5,76(a0)
    80003488:	e99c                	sd	a5,16(a1)
}
    8000348a:	6422                	ld	s0,8(sp)
    8000348c:	0141                	addi	sp,sp,16
    8000348e:	8082                	ret

0000000080003490 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003490:	457c                	lw	a5,76(a0)
    80003492:	0cd7ef63          	bltu	a5,a3,80003570 <readi+0xe0>
{
    80003496:	7159                	addi	sp,sp,-112
    80003498:	f486                	sd	ra,104(sp)
    8000349a:	f0a2                	sd	s0,96(sp)
    8000349c:	eca6                	sd	s1,88(sp)
    8000349e:	e8ca                	sd	s2,80(sp)
    800034a0:	e4ce                	sd	s3,72(sp)
    800034a2:	e0d2                	sd	s4,64(sp)
    800034a4:	fc56                	sd	s5,56(sp)
    800034a6:	f85a                	sd	s6,48(sp)
    800034a8:	f45e                	sd	s7,40(sp)
    800034aa:	f062                	sd	s8,32(sp)
    800034ac:	ec66                	sd	s9,24(sp)
    800034ae:	e86a                	sd	s10,16(sp)
    800034b0:	e46e                	sd	s11,8(sp)
    800034b2:	1880                	addi	s0,sp,112
    800034b4:	8b2a                	mv	s6,a0
    800034b6:	8bae                	mv	s7,a1
    800034b8:	8a32                	mv	s4,a2
    800034ba:	84b6                	mv	s1,a3
    800034bc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800034be:	9f35                	addw	a4,a4,a3
    return 0;
    800034c0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800034c2:	08d76663          	bltu	a4,a3,8000354e <readi+0xbe>
  if(off + n > ip->size)
    800034c6:	00e7f463          	bgeu	a5,a4,800034ce <readi+0x3e>
    n = ip->size - off;
    800034ca:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034ce:	080a8f63          	beqz	s5,8000356c <readi+0xdc>
    800034d2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034d4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800034d8:	5c7d                	li	s8,-1
    800034da:	a80d                	j	8000350c <readi+0x7c>
    800034dc:	020d1d93          	slli	s11,s10,0x20
    800034e0:	020ddd93          	srli	s11,s11,0x20
    800034e4:	05890793          	addi	a5,s2,88
    800034e8:	86ee                	mv	a3,s11
    800034ea:	963e                	add	a2,a2,a5
    800034ec:	85d2                	mv	a1,s4
    800034ee:	855e                	mv	a0,s7
    800034f0:	c65fe0ef          	jal	ra,80002154 <either_copyout>
    800034f4:	05850763          	beq	a0,s8,80003542 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800034f8:	854a                	mv	a0,s2
    800034fa:	f30ff0ef          	jal	ra,80002c2a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034fe:	013d09bb          	addw	s3,s10,s3
    80003502:	009d04bb          	addw	s1,s10,s1
    80003506:	9a6e                	add	s4,s4,s11
    80003508:	0559f163          	bgeu	s3,s5,8000354a <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    8000350c:	00a4d59b          	srliw	a1,s1,0xa
    80003510:	855a                	mv	a0,s6
    80003512:	98bff0ef          	jal	ra,80002e9c <bmap>
    80003516:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000351a:	c985                	beqz	a1,8000354a <readi+0xba>
    bp = bread(ip->dev, addr);
    8000351c:	000b2503          	lw	a0,0(s6)
    80003520:	e02ff0ef          	jal	ra,80002b22 <bread>
    80003524:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003526:	3ff4f613          	andi	a2,s1,1023
    8000352a:	40cc87bb          	subw	a5,s9,a2
    8000352e:	413a873b          	subw	a4,s5,s3
    80003532:	8d3e                	mv	s10,a5
    80003534:	2781                	sext.w	a5,a5
    80003536:	0007069b          	sext.w	a3,a4
    8000353a:	faf6f1e3          	bgeu	a3,a5,800034dc <readi+0x4c>
    8000353e:	8d3a                	mv	s10,a4
    80003540:	bf71                	j	800034dc <readi+0x4c>
      brelse(bp);
    80003542:	854a                	mv	a0,s2
    80003544:	ee6ff0ef          	jal	ra,80002c2a <brelse>
      tot = -1;
    80003548:	59fd                	li	s3,-1
  }
  return tot;
    8000354a:	0009851b          	sext.w	a0,s3
}
    8000354e:	70a6                	ld	ra,104(sp)
    80003550:	7406                	ld	s0,96(sp)
    80003552:	64e6                	ld	s1,88(sp)
    80003554:	6946                	ld	s2,80(sp)
    80003556:	69a6                	ld	s3,72(sp)
    80003558:	6a06                	ld	s4,64(sp)
    8000355a:	7ae2                	ld	s5,56(sp)
    8000355c:	7b42                	ld	s6,48(sp)
    8000355e:	7ba2                	ld	s7,40(sp)
    80003560:	7c02                	ld	s8,32(sp)
    80003562:	6ce2                	ld	s9,24(sp)
    80003564:	6d42                	ld	s10,16(sp)
    80003566:	6da2                	ld	s11,8(sp)
    80003568:	6165                	addi	sp,sp,112
    8000356a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000356c:	89d6                	mv	s3,s5
    8000356e:	bff1                	j	8000354a <readi+0xba>
    return 0;
    80003570:	4501                	li	a0,0
}
    80003572:	8082                	ret

0000000080003574 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003574:	457c                	lw	a5,76(a0)
    80003576:	0ed7eb63          	bltu	a5,a3,8000366c <writei+0xf8>
{
    8000357a:	7159                	addi	sp,sp,-112
    8000357c:	f486                	sd	ra,104(sp)
    8000357e:	f0a2                	sd	s0,96(sp)
    80003580:	eca6                	sd	s1,88(sp)
    80003582:	e8ca                	sd	s2,80(sp)
    80003584:	e4ce                	sd	s3,72(sp)
    80003586:	e0d2                	sd	s4,64(sp)
    80003588:	fc56                	sd	s5,56(sp)
    8000358a:	f85a                	sd	s6,48(sp)
    8000358c:	f45e                	sd	s7,40(sp)
    8000358e:	f062                	sd	s8,32(sp)
    80003590:	ec66                	sd	s9,24(sp)
    80003592:	e86a                	sd	s10,16(sp)
    80003594:	e46e                	sd	s11,8(sp)
    80003596:	1880                	addi	s0,sp,112
    80003598:	8aaa                	mv	s5,a0
    8000359a:	8bae                	mv	s7,a1
    8000359c:	8a32                	mv	s4,a2
    8000359e:	8936                	mv	s2,a3
    800035a0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800035a2:	9f35                	addw	a4,a4,a3
    800035a4:	0cd76663          	bltu	a4,a3,80003670 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800035a8:	000437b7          	lui	a5,0x43
    800035ac:	80078793          	addi	a5,a5,-2048 # 42800 <_entry-0x7ffbd800>
    800035b0:	0ce7e263          	bltu	a5,a4,80003674 <writei+0x100>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035b4:	0a0b0a63          	beqz	s6,80003668 <writei+0xf4>
    800035b8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ba:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800035be:	5c7d                	li	s8,-1
    800035c0:	a825                	j	800035f8 <writei+0x84>
    800035c2:	020d1d93          	slli	s11,s10,0x20
    800035c6:	020ddd93          	srli	s11,s11,0x20
    800035ca:	05848793          	addi	a5,s1,88
    800035ce:	86ee                	mv	a3,s11
    800035d0:	8652                	mv	a2,s4
    800035d2:	85de                	mv	a1,s7
    800035d4:	953e                	add	a0,a0,a5
    800035d6:	bc9fe0ef          	jal	ra,8000219e <either_copyin>
    800035da:	05850a63          	beq	a0,s8,8000362e <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    800035de:	8526                	mv	a0,s1
    800035e0:	670000ef          	jal	ra,80003c50 <log_write>
    brelse(bp);
    800035e4:	8526                	mv	a0,s1
    800035e6:	e44ff0ef          	jal	ra,80002c2a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035ea:	013d09bb          	addw	s3,s10,s3
    800035ee:	012d093b          	addw	s2,s10,s2
    800035f2:	9a6e                	add	s4,s4,s11
    800035f4:	0569f063          	bgeu	s3,s6,80003634 <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    800035f8:	00a9559b          	srliw	a1,s2,0xa
    800035fc:	8556                	mv	a0,s5
    800035fe:	89fff0ef          	jal	ra,80002e9c <bmap>
    80003602:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003606:	c59d                	beqz	a1,80003634 <writei+0xc0>
    bp = bread(ip->dev, addr);
    80003608:	000aa503          	lw	a0,0(s5)
    8000360c:	d16ff0ef          	jal	ra,80002b22 <bread>
    80003610:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003612:	3ff97513          	andi	a0,s2,1023
    80003616:	40ac87bb          	subw	a5,s9,a0
    8000361a:	413b073b          	subw	a4,s6,s3
    8000361e:	8d3e                	mv	s10,a5
    80003620:	2781                	sext.w	a5,a5
    80003622:	0007069b          	sext.w	a3,a4
    80003626:	f8f6fee3          	bgeu	a3,a5,800035c2 <writei+0x4e>
    8000362a:	8d3a                	mv	s10,a4
    8000362c:	bf59                	j	800035c2 <writei+0x4e>
      brelse(bp);
    8000362e:	8526                	mv	a0,s1
    80003630:	dfaff0ef          	jal	ra,80002c2a <brelse>
  }

  if(off > ip->size)
    80003634:	04caa783          	lw	a5,76(s5)
    80003638:	0127f463          	bgeu	a5,s2,80003640 <writei+0xcc>
    ip->size = off;
    8000363c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003640:	8556                	mv	a0,s5
    80003642:	b4dff0ef          	jal	ra,8000318e <iupdate>

  return tot;
    80003646:	0009851b          	sext.w	a0,s3
}
    8000364a:	70a6                	ld	ra,104(sp)
    8000364c:	7406                	ld	s0,96(sp)
    8000364e:	64e6                	ld	s1,88(sp)
    80003650:	6946                	ld	s2,80(sp)
    80003652:	69a6                	ld	s3,72(sp)
    80003654:	6a06                	ld	s4,64(sp)
    80003656:	7ae2                	ld	s5,56(sp)
    80003658:	7b42                	ld	s6,48(sp)
    8000365a:	7ba2                	ld	s7,40(sp)
    8000365c:	7c02                	ld	s8,32(sp)
    8000365e:	6ce2                	ld	s9,24(sp)
    80003660:	6d42                	ld	s10,16(sp)
    80003662:	6da2                	ld	s11,8(sp)
    80003664:	6165                	addi	sp,sp,112
    80003666:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003668:	89da                	mv	s3,s6
    8000366a:	bfd9                	j	80003640 <writei+0xcc>
    return -1;
    8000366c:	557d                	li	a0,-1
}
    8000366e:	8082                	ret
    return -1;
    80003670:	557d                	li	a0,-1
    80003672:	bfe1                	j	8000364a <writei+0xd6>
    return -1;
    80003674:	557d                	li	a0,-1
    80003676:	bfd1                	j	8000364a <writei+0xd6>

0000000080003678 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003678:	1141                	addi	sp,sp,-16
    8000367a:	e406                	sd	ra,8(sp)
    8000367c:	e022                	sd	s0,0(sp)
    8000367e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003680:	4639                	li	a2,14
    80003682:	eb8fd0ef          	jal	ra,80000d3a <strncmp>
}
    80003686:	60a2                	ld	ra,8(sp)
    80003688:	6402                	ld	s0,0(sp)
    8000368a:	0141                	addi	sp,sp,16
    8000368c:	8082                	ret

000000008000368e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000368e:	7139                	addi	sp,sp,-64
    80003690:	fc06                	sd	ra,56(sp)
    80003692:	f822                	sd	s0,48(sp)
    80003694:	f426                	sd	s1,40(sp)
    80003696:	f04a                	sd	s2,32(sp)
    80003698:	ec4e                	sd	s3,24(sp)
    8000369a:	e852                	sd	s4,16(sp)
    8000369c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000369e:	04451703          	lh	a4,68(a0)
    800036a2:	4785                	li	a5,1
    800036a4:	00f71a63          	bne	a4,a5,800036b8 <dirlookup+0x2a>
    800036a8:	892a                	mv	s2,a0
    800036aa:	89ae                	mv	s3,a1
    800036ac:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800036ae:	457c                	lw	a5,76(a0)
    800036b0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800036b2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036b4:	e39d                	bnez	a5,800036da <dirlookup+0x4c>
    800036b6:	a095                	j	8000371a <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800036b8:	00004517          	auipc	a0,0x4
    800036bc:	f9850513          	addi	a0,a0,-104 # 80007650 <syscalls+0x1c0>
    800036c0:	896fd0ef          	jal	ra,80000756 <panic>
      panic("dirlookup read");
    800036c4:	00004517          	auipc	a0,0x4
    800036c8:	fa450513          	addi	a0,a0,-92 # 80007668 <syscalls+0x1d8>
    800036cc:	88afd0ef          	jal	ra,80000756 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036d0:	24c1                	addiw	s1,s1,16
    800036d2:	04c92783          	lw	a5,76(s2)
    800036d6:	04f4f163          	bgeu	s1,a5,80003718 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036da:	4741                	li	a4,16
    800036dc:	86a6                	mv	a3,s1
    800036de:	fc040613          	addi	a2,s0,-64
    800036e2:	4581                	li	a1,0
    800036e4:	854a                	mv	a0,s2
    800036e6:	dabff0ef          	jal	ra,80003490 <readi>
    800036ea:	47c1                	li	a5,16
    800036ec:	fcf51ce3          	bne	a0,a5,800036c4 <dirlookup+0x36>
    if(de.inum == 0)
    800036f0:	fc045783          	lhu	a5,-64(s0)
    800036f4:	dff1                	beqz	a5,800036d0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800036f6:	fc240593          	addi	a1,s0,-62
    800036fa:	854e                	mv	a0,s3
    800036fc:	f7dff0ef          	jal	ra,80003678 <namecmp>
    80003700:	f961                	bnez	a0,800036d0 <dirlookup+0x42>
      if(poff)
    80003702:	000a0463          	beqz	s4,8000370a <dirlookup+0x7c>
        *poff = off;
    80003706:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000370a:	fc045583          	lhu	a1,-64(s0)
    8000370e:	00092503          	lw	a0,0(s2)
    80003712:	857ff0ef          	jal	ra,80002f68 <iget>
    80003716:	a011                	j	8000371a <dirlookup+0x8c>
  return 0;
    80003718:	4501                	li	a0,0
}
    8000371a:	70e2                	ld	ra,56(sp)
    8000371c:	7442                	ld	s0,48(sp)
    8000371e:	74a2                	ld	s1,40(sp)
    80003720:	7902                	ld	s2,32(sp)
    80003722:	69e2                	ld	s3,24(sp)
    80003724:	6a42                	ld	s4,16(sp)
    80003726:	6121                	addi	sp,sp,64
    80003728:	8082                	ret

000000008000372a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000372a:	711d                	addi	sp,sp,-96
    8000372c:	ec86                	sd	ra,88(sp)
    8000372e:	e8a2                	sd	s0,80(sp)
    80003730:	e4a6                	sd	s1,72(sp)
    80003732:	e0ca                	sd	s2,64(sp)
    80003734:	fc4e                	sd	s3,56(sp)
    80003736:	f852                	sd	s4,48(sp)
    80003738:	f456                	sd	s5,40(sp)
    8000373a:	f05a                	sd	s6,32(sp)
    8000373c:	ec5e                	sd	s7,24(sp)
    8000373e:	e862                	sd	s8,16(sp)
    80003740:	e466                	sd	s9,8(sp)
    80003742:	1080                	addi	s0,sp,96
    80003744:	84aa                	mv	s1,a0
    80003746:	8aae                	mv	s5,a1
    80003748:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000374a:	00054703          	lbu	a4,0(a0)
    8000374e:	02f00793          	li	a5,47
    80003752:	00f70f63          	beq	a4,a5,80003770 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003756:	8d6fe0ef          	jal	ra,8000182c <myproc>
    8000375a:	15053503          	ld	a0,336(a0)
    8000375e:	aadff0ef          	jal	ra,8000320a <idup>
    80003762:	89aa                	mv	s3,a0
  while(*path == '/')
    80003764:	02f00913          	li	s2,47
  len = path - s;
    80003768:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000376a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000376c:	4b85                	li	s7,1
    8000376e:	a861                	j	80003806 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80003770:	4585                	li	a1,1
    80003772:	4505                	li	a0,1
    80003774:	ff4ff0ef          	jal	ra,80002f68 <iget>
    80003778:	89aa                	mv	s3,a0
    8000377a:	b7ed                	j	80003764 <namex+0x3a>
      iunlockput(ip);
    8000377c:	854e                	mv	a0,s3
    8000377e:	cc9ff0ef          	jal	ra,80003446 <iunlockput>
      return 0;
    80003782:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003784:	854e                	mv	a0,s3
    80003786:	60e6                	ld	ra,88(sp)
    80003788:	6446                	ld	s0,80(sp)
    8000378a:	64a6                	ld	s1,72(sp)
    8000378c:	6906                	ld	s2,64(sp)
    8000378e:	79e2                	ld	s3,56(sp)
    80003790:	7a42                	ld	s4,48(sp)
    80003792:	7aa2                	ld	s5,40(sp)
    80003794:	7b02                	ld	s6,32(sp)
    80003796:	6be2                	ld	s7,24(sp)
    80003798:	6c42                	ld	s8,16(sp)
    8000379a:	6ca2                	ld	s9,8(sp)
    8000379c:	6125                	addi	sp,sp,96
    8000379e:	8082                	ret
      iunlock(ip);
    800037a0:	854e                	mv	a0,s3
    800037a2:	b49ff0ef          	jal	ra,800032ea <iunlock>
      return ip;
    800037a6:	bff9                	j	80003784 <namex+0x5a>
      iunlockput(ip);
    800037a8:	854e                	mv	a0,s3
    800037aa:	c9dff0ef          	jal	ra,80003446 <iunlockput>
      return 0;
    800037ae:	89e6                	mv	s3,s9
    800037b0:	bfd1                	j	80003784 <namex+0x5a>
  len = path - s;
    800037b2:	40b48633          	sub	a2,s1,a1
    800037b6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800037ba:	079c5c63          	bge	s8,s9,80003832 <namex+0x108>
    memmove(name, s, DIRSIZ);
    800037be:	4639                	li	a2,14
    800037c0:	8552                	mv	a0,s4
    800037c2:	d08fd0ef          	jal	ra,80000cca <memmove>
  while(*path == '/')
    800037c6:	0004c783          	lbu	a5,0(s1)
    800037ca:	01279763          	bne	a5,s2,800037d8 <namex+0xae>
    path++;
    800037ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037d0:	0004c783          	lbu	a5,0(s1)
    800037d4:	ff278de3          	beq	a5,s2,800037ce <namex+0xa4>
    ilock(ip);
    800037d8:	854e                	mv	a0,s3
    800037da:	a67ff0ef          	jal	ra,80003240 <ilock>
    if(ip->type != T_DIR){
    800037de:	04499783          	lh	a5,68(s3)
    800037e2:	f9779de3          	bne	a5,s7,8000377c <namex+0x52>
    if(nameiparent && *path == '\0'){
    800037e6:	000a8563          	beqz	s5,800037f0 <namex+0xc6>
    800037ea:	0004c783          	lbu	a5,0(s1)
    800037ee:	dbcd                	beqz	a5,800037a0 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    800037f0:	865a                	mv	a2,s6
    800037f2:	85d2                	mv	a1,s4
    800037f4:	854e                	mv	a0,s3
    800037f6:	e99ff0ef          	jal	ra,8000368e <dirlookup>
    800037fa:	8caa                	mv	s9,a0
    800037fc:	d555                	beqz	a0,800037a8 <namex+0x7e>
    iunlockput(ip);
    800037fe:	854e                	mv	a0,s3
    80003800:	c47ff0ef          	jal	ra,80003446 <iunlockput>
    ip = next;
    80003804:	89e6                	mv	s3,s9
  while(*path == '/')
    80003806:	0004c783          	lbu	a5,0(s1)
    8000380a:	05279363          	bne	a5,s2,80003850 <namex+0x126>
    path++;
    8000380e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003810:	0004c783          	lbu	a5,0(s1)
    80003814:	ff278de3          	beq	a5,s2,8000380e <namex+0xe4>
  if(*path == 0)
    80003818:	c78d                	beqz	a5,80003842 <namex+0x118>
    path++;
    8000381a:	85a6                	mv	a1,s1
  len = path - s;
    8000381c:	8cda                	mv	s9,s6
    8000381e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003820:	01278963          	beq	a5,s2,80003832 <namex+0x108>
    80003824:	d7d9                	beqz	a5,800037b2 <namex+0x88>
    path++;
    80003826:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003828:	0004c783          	lbu	a5,0(s1)
    8000382c:	ff279ce3          	bne	a5,s2,80003824 <namex+0xfa>
    80003830:	b749                	j	800037b2 <namex+0x88>
    memmove(name, s, len);
    80003832:	2601                	sext.w	a2,a2
    80003834:	8552                	mv	a0,s4
    80003836:	c94fd0ef          	jal	ra,80000cca <memmove>
    name[len] = 0;
    8000383a:	9cd2                	add	s9,s9,s4
    8000383c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003840:	b759                	j	800037c6 <namex+0x9c>
  if(nameiparent){
    80003842:	f40a81e3          	beqz	s5,80003784 <namex+0x5a>
    iput(ip);
    80003846:	854e                	mv	a0,s3
    80003848:	b77ff0ef          	jal	ra,800033be <iput>
    return 0;
    8000384c:	4981                	li	s3,0
    8000384e:	bf1d                	j	80003784 <namex+0x5a>
  if(*path == 0)
    80003850:	dbed                	beqz	a5,80003842 <namex+0x118>
  while(*path != '/' && *path != 0)
    80003852:	0004c783          	lbu	a5,0(s1)
    80003856:	85a6                	mv	a1,s1
    80003858:	b7f1                	j	80003824 <namex+0xfa>

000000008000385a <dirlink>:
{
    8000385a:	7139                	addi	sp,sp,-64
    8000385c:	fc06                	sd	ra,56(sp)
    8000385e:	f822                	sd	s0,48(sp)
    80003860:	f426                	sd	s1,40(sp)
    80003862:	f04a                	sd	s2,32(sp)
    80003864:	ec4e                	sd	s3,24(sp)
    80003866:	e852                	sd	s4,16(sp)
    80003868:	0080                	addi	s0,sp,64
    8000386a:	892a                	mv	s2,a0
    8000386c:	8a2e                	mv	s4,a1
    8000386e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003870:	4601                	li	a2,0
    80003872:	e1dff0ef          	jal	ra,8000368e <dirlookup>
    80003876:	e52d                	bnez	a0,800038e0 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003878:	04c92483          	lw	s1,76(s2)
    8000387c:	c48d                	beqz	s1,800038a6 <dirlink+0x4c>
    8000387e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003880:	4741                	li	a4,16
    80003882:	86a6                	mv	a3,s1
    80003884:	fc040613          	addi	a2,s0,-64
    80003888:	4581                	li	a1,0
    8000388a:	854a                	mv	a0,s2
    8000388c:	c05ff0ef          	jal	ra,80003490 <readi>
    80003890:	47c1                	li	a5,16
    80003892:	04f51b63          	bne	a0,a5,800038e8 <dirlink+0x8e>
    if(de.inum == 0)
    80003896:	fc045783          	lhu	a5,-64(s0)
    8000389a:	c791                	beqz	a5,800038a6 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000389c:	24c1                	addiw	s1,s1,16
    8000389e:	04c92783          	lw	a5,76(s2)
    800038a2:	fcf4efe3          	bltu	s1,a5,80003880 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800038a6:	4639                	li	a2,14
    800038a8:	85d2                	mv	a1,s4
    800038aa:	fc240513          	addi	a0,s0,-62
    800038ae:	cc8fd0ef          	jal	ra,80000d76 <strncpy>
  de.inum = inum;
    800038b2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038b6:	4741                	li	a4,16
    800038b8:	86a6                	mv	a3,s1
    800038ba:	fc040613          	addi	a2,s0,-64
    800038be:	4581                	li	a1,0
    800038c0:	854a                	mv	a0,s2
    800038c2:	cb3ff0ef          	jal	ra,80003574 <writei>
    800038c6:	1541                	addi	a0,a0,-16
    800038c8:	00a03533          	snez	a0,a0
    800038cc:	40a00533          	neg	a0,a0
}
    800038d0:	70e2                	ld	ra,56(sp)
    800038d2:	7442                	ld	s0,48(sp)
    800038d4:	74a2                	ld	s1,40(sp)
    800038d6:	7902                	ld	s2,32(sp)
    800038d8:	69e2                	ld	s3,24(sp)
    800038da:	6a42                	ld	s4,16(sp)
    800038dc:	6121                	addi	sp,sp,64
    800038de:	8082                	ret
    iput(ip);
    800038e0:	adfff0ef          	jal	ra,800033be <iput>
    return -1;
    800038e4:	557d                	li	a0,-1
    800038e6:	b7ed                	j	800038d0 <dirlink+0x76>
      panic("dirlink read");
    800038e8:	00004517          	auipc	a0,0x4
    800038ec:	d9050513          	addi	a0,a0,-624 # 80007678 <syscalls+0x1e8>
    800038f0:	e67fc0ef          	jal	ra,80000756 <panic>

00000000800038f4 <namei>:

struct inode*
namei(char *path)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800038fc:	fe040613          	addi	a2,s0,-32
    80003900:	4581                	li	a1,0
    80003902:	e29ff0ef          	jal	ra,8000372a <namex>
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret

000000008000390e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000390e:	1141                	addi	sp,sp,-16
    80003910:	e406                	sd	ra,8(sp)
    80003912:	e022                	sd	s0,0(sp)
    80003914:	0800                	addi	s0,sp,16
    80003916:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003918:	4585                	li	a1,1
    8000391a:	e11ff0ef          	jal	ra,8000372a <namex>
}
    8000391e:	60a2                	ld	ra,8(sp)
    80003920:	6402                	ld	s0,0(sp)
    80003922:	0141                	addi	sp,sp,16
    80003924:	8082                	ret

0000000080003926 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003926:	1101                	addi	sp,sp,-32
    80003928:	ec06                	sd	ra,24(sp)
    8000392a:	e822                	sd	s0,16(sp)
    8000392c:	e426                	sd	s1,8(sp)
    8000392e:	e04a                	sd	s2,0(sp)
    80003930:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003932:	00022917          	auipc	s2,0x22
    80003936:	d7690913          	addi	s2,s2,-650 # 800256a8 <log>
    8000393a:	01892583          	lw	a1,24(s2)
    8000393e:	02892503          	lw	a0,40(s2)
    80003942:	9e0ff0ef          	jal	ra,80002b22 <bread>
    80003946:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003948:	02c92683          	lw	a3,44(s2)
    8000394c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000394e:	02d05763          	blez	a3,8000397c <write_head+0x56>
    80003952:	00022797          	auipc	a5,0x22
    80003956:	d8678793          	addi	a5,a5,-634 # 800256d8 <log+0x30>
    8000395a:	05c50713          	addi	a4,a0,92
    8000395e:	36fd                	addiw	a3,a3,-1
    80003960:	1682                	slli	a3,a3,0x20
    80003962:	9281                	srli	a3,a3,0x20
    80003964:	068a                	slli	a3,a3,0x2
    80003966:	00022617          	auipc	a2,0x22
    8000396a:	d7660613          	addi	a2,a2,-650 # 800256dc <log+0x34>
    8000396e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003970:	4390                	lw	a2,0(a5)
    80003972:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003974:	0791                	addi	a5,a5,4
    80003976:	0711                	addi	a4,a4,4
    80003978:	fed79ce3          	bne	a5,a3,80003970 <write_head+0x4a>
  }
  bwrite(buf);
    8000397c:	8526                	mv	a0,s1
    8000397e:	a7aff0ef          	jal	ra,80002bf8 <bwrite>
  brelse(buf);
    80003982:	8526                	mv	a0,s1
    80003984:	aa6ff0ef          	jal	ra,80002c2a <brelse>
}
    80003988:	60e2                	ld	ra,24(sp)
    8000398a:	6442                	ld	s0,16(sp)
    8000398c:	64a2                	ld	s1,8(sp)
    8000398e:	6902                	ld	s2,0(sp)
    80003990:	6105                	addi	sp,sp,32
    80003992:	8082                	ret

0000000080003994 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003994:	00022797          	auipc	a5,0x22
    80003998:	d407a783          	lw	a5,-704(a5) # 800256d4 <log+0x2c>
    8000399c:	08f05f63          	blez	a5,80003a3a <install_trans+0xa6>
{
    800039a0:	7139                	addi	sp,sp,-64
    800039a2:	fc06                	sd	ra,56(sp)
    800039a4:	f822                	sd	s0,48(sp)
    800039a6:	f426                	sd	s1,40(sp)
    800039a8:	f04a                	sd	s2,32(sp)
    800039aa:	ec4e                	sd	s3,24(sp)
    800039ac:	e852                	sd	s4,16(sp)
    800039ae:	e456                	sd	s5,8(sp)
    800039b0:	e05a                	sd	s6,0(sp)
    800039b2:	0080                	addi	s0,sp,64
    800039b4:	8b2a                	mv	s6,a0
    800039b6:	00022a97          	auipc	s5,0x22
    800039ba:	d22a8a93          	addi	s5,s5,-734 # 800256d8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039be:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039c0:	00022997          	auipc	s3,0x22
    800039c4:	ce898993          	addi	s3,s3,-792 # 800256a8 <log>
    800039c8:	a829                	j	800039e2 <install_trans+0x4e>
    brelse(lbuf);
    800039ca:	854a                	mv	a0,s2
    800039cc:	a5eff0ef          	jal	ra,80002c2a <brelse>
    brelse(dbuf);
    800039d0:	8526                	mv	a0,s1
    800039d2:	a58ff0ef          	jal	ra,80002c2a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039d6:	2a05                	addiw	s4,s4,1
    800039d8:	0a91                	addi	s5,s5,4
    800039da:	02c9a783          	lw	a5,44(s3)
    800039de:	04fa5463          	bge	s4,a5,80003a26 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039e2:	0189a583          	lw	a1,24(s3)
    800039e6:	014585bb          	addw	a1,a1,s4
    800039ea:	2585                	addiw	a1,a1,1
    800039ec:	0289a503          	lw	a0,40(s3)
    800039f0:	932ff0ef          	jal	ra,80002b22 <bread>
    800039f4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800039f6:	000aa583          	lw	a1,0(s5)
    800039fa:	0289a503          	lw	a0,40(s3)
    800039fe:	924ff0ef          	jal	ra,80002b22 <bread>
    80003a02:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a04:	40000613          	li	a2,1024
    80003a08:	05890593          	addi	a1,s2,88
    80003a0c:	05850513          	addi	a0,a0,88
    80003a10:	abafd0ef          	jal	ra,80000cca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a14:	8526                	mv	a0,s1
    80003a16:	9e2ff0ef          	jal	ra,80002bf8 <bwrite>
    if(recovering == 0)
    80003a1a:	fa0b18e3          	bnez	s6,800039ca <install_trans+0x36>
      bunpin(dbuf);
    80003a1e:	8526                	mv	a0,s1
    80003a20:	ac8ff0ef          	jal	ra,80002ce8 <bunpin>
    80003a24:	b75d                	j	800039ca <install_trans+0x36>
}
    80003a26:	70e2                	ld	ra,56(sp)
    80003a28:	7442                	ld	s0,48(sp)
    80003a2a:	74a2                	ld	s1,40(sp)
    80003a2c:	7902                	ld	s2,32(sp)
    80003a2e:	69e2                	ld	s3,24(sp)
    80003a30:	6a42                	ld	s4,16(sp)
    80003a32:	6aa2                	ld	s5,8(sp)
    80003a34:	6b02                	ld	s6,0(sp)
    80003a36:	6121                	addi	sp,sp,64
    80003a38:	8082                	ret
    80003a3a:	8082                	ret

0000000080003a3c <initlog>:
{
    80003a3c:	7179                	addi	sp,sp,-48
    80003a3e:	f406                	sd	ra,40(sp)
    80003a40:	f022                	sd	s0,32(sp)
    80003a42:	ec26                	sd	s1,24(sp)
    80003a44:	e84a                	sd	s2,16(sp)
    80003a46:	e44e                	sd	s3,8(sp)
    80003a48:	1800                	addi	s0,sp,48
    80003a4a:	892a                	mv	s2,a0
    80003a4c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a4e:	00022497          	auipc	s1,0x22
    80003a52:	c5a48493          	addi	s1,s1,-934 # 800256a8 <log>
    80003a56:	00004597          	auipc	a1,0x4
    80003a5a:	c3258593          	addi	a1,a1,-974 # 80007688 <syscalls+0x1f8>
    80003a5e:	8526                	mv	a0,s1
    80003a60:	8bafd0ef          	jal	ra,80000b1a <initlock>
  log.start = sb->logstart;
    80003a64:	0149a583          	lw	a1,20(s3)
    80003a68:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a6a:	0109a783          	lw	a5,16(s3)
    80003a6e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a70:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a74:	854a                	mv	a0,s2
    80003a76:	8acff0ef          	jal	ra,80002b22 <bread>
  log.lh.n = lh->n;
    80003a7a:	4d34                	lw	a3,88(a0)
    80003a7c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a7e:	02d05563          	blez	a3,80003aa8 <initlog+0x6c>
    80003a82:	05c50793          	addi	a5,a0,92
    80003a86:	00022717          	auipc	a4,0x22
    80003a8a:	c5270713          	addi	a4,a4,-942 # 800256d8 <log+0x30>
    80003a8e:	36fd                	addiw	a3,a3,-1
    80003a90:	1682                	slli	a3,a3,0x20
    80003a92:	9281                	srli	a3,a3,0x20
    80003a94:	068a                	slli	a3,a3,0x2
    80003a96:	06050613          	addi	a2,a0,96
    80003a9a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003a9c:	4390                	lw	a2,0(a5)
    80003a9e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003aa0:	0791                	addi	a5,a5,4
    80003aa2:	0711                	addi	a4,a4,4
    80003aa4:	fed79ce3          	bne	a5,a3,80003a9c <initlog+0x60>
  brelse(buf);
    80003aa8:	982ff0ef          	jal	ra,80002c2a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003aac:	4505                	li	a0,1
    80003aae:	ee7ff0ef          	jal	ra,80003994 <install_trans>
  log.lh.n = 0;
    80003ab2:	00022797          	auipc	a5,0x22
    80003ab6:	c207a123          	sw	zero,-990(a5) # 800256d4 <log+0x2c>
  write_head(); // clear the log
    80003aba:	e6dff0ef          	jal	ra,80003926 <write_head>
}
    80003abe:	70a2                	ld	ra,40(sp)
    80003ac0:	7402                	ld	s0,32(sp)
    80003ac2:	64e2                	ld	s1,24(sp)
    80003ac4:	6942                	ld	s2,16(sp)
    80003ac6:	69a2                	ld	s3,8(sp)
    80003ac8:	6145                	addi	sp,sp,48
    80003aca:	8082                	ret

0000000080003acc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003acc:	1101                	addi	sp,sp,-32
    80003ace:	ec06                	sd	ra,24(sp)
    80003ad0:	e822                	sd	s0,16(sp)
    80003ad2:	e426                	sd	s1,8(sp)
    80003ad4:	e04a                	sd	s2,0(sp)
    80003ad6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ad8:	00022517          	auipc	a0,0x22
    80003adc:	bd050513          	addi	a0,a0,-1072 # 800256a8 <log>
    80003ae0:	8bafd0ef          	jal	ra,80000b9a <acquire>
  while(1){
    if(log.committing){
    80003ae4:	00022497          	auipc	s1,0x22
    80003ae8:	bc448493          	addi	s1,s1,-1084 # 800256a8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003aec:	4979                	li	s2,30
    80003aee:	a029                	j	80003af8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003af0:	85a6                	mv	a1,s1
    80003af2:	8526                	mv	a0,s1
    80003af4:	b04fe0ef          	jal	ra,80001df8 <sleep>
    if(log.committing){
    80003af8:	50dc                	lw	a5,36(s1)
    80003afa:	fbfd                	bnez	a5,80003af0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003afc:	509c                	lw	a5,32(s1)
    80003afe:	0017871b          	addiw	a4,a5,1
    80003b02:	0007069b          	sext.w	a3,a4
    80003b06:	0027179b          	slliw	a5,a4,0x2
    80003b0a:	9fb9                	addw	a5,a5,a4
    80003b0c:	0017979b          	slliw	a5,a5,0x1
    80003b10:	54d8                	lw	a4,44(s1)
    80003b12:	9fb9                	addw	a5,a5,a4
    80003b14:	00f95763          	bge	s2,a5,80003b22 <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b18:	85a6                	mv	a1,s1
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	adcfe0ef          	jal	ra,80001df8 <sleep>
    80003b20:	bfe1                	j	80003af8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003b22:	00022517          	auipc	a0,0x22
    80003b26:	b8650513          	addi	a0,a0,-1146 # 800256a8 <log>
    80003b2a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003b2c:	906fd0ef          	jal	ra,80000c32 <release>
      break;
    }
  }
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6902                	ld	s2,0(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b3c:	7139                	addi	sp,sp,-64
    80003b3e:	fc06                	sd	ra,56(sp)
    80003b40:	f822                	sd	s0,48(sp)
    80003b42:	f426                	sd	s1,40(sp)
    80003b44:	f04a                	sd	s2,32(sp)
    80003b46:	ec4e                	sd	s3,24(sp)
    80003b48:	e852                	sd	s4,16(sp)
    80003b4a:	e456                	sd	s5,8(sp)
    80003b4c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003b4e:	00022497          	auipc	s1,0x22
    80003b52:	b5a48493          	addi	s1,s1,-1190 # 800256a8 <log>
    80003b56:	8526                	mv	a0,s1
    80003b58:	842fd0ef          	jal	ra,80000b9a <acquire>
  log.outstanding -= 1;
    80003b5c:	509c                	lw	a5,32(s1)
    80003b5e:	37fd                	addiw	a5,a5,-1
    80003b60:	0007891b          	sext.w	s2,a5
    80003b64:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b66:	50dc                	lw	a5,36(s1)
    80003b68:	ef9d                	bnez	a5,80003ba6 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b6a:	04091463          	bnez	s2,80003bb2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b6e:	00022497          	auipc	s1,0x22
    80003b72:	b3a48493          	addi	s1,s1,-1222 # 800256a8 <log>
    80003b76:	4785                	li	a5,1
    80003b78:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	8b6fd0ef          	jal	ra,80000c32 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b80:	54dc                	lw	a5,44(s1)
    80003b82:	04f04b63          	bgtz	a5,80003bd8 <end_op+0x9c>
    acquire(&log.lock);
    80003b86:	00022497          	auipc	s1,0x22
    80003b8a:	b2248493          	addi	s1,s1,-1246 # 800256a8 <log>
    80003b8e:	8526                	mv	a0,s1
    80003b90:	80afd0ef          	jal	ra,80000b9a <acquire>
    log.committing = 0;
    80003b94:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b98:	8526                	mv	a0,s1
    80003b9a:	aaafe0ef          	jal	ra,80001e44 <wakeup>
    release(&log.lock);
    80003b9e:	8526                	mv	a0,s1
    80003ba0:	892fd0ef          	jal	ra,80000c32 <release>
}
    80003ba4:	a00d                	j	80003bc6 <end_op+0x8a>
    panic("log.committing");
    80003ba6:	00004517          	auipc	a0,0x4
    80003baa:	aea50513          	addi	a0,a0,-1302 # 80007690 <syscalls+0x200>
    80003bae:	ba9fc0ef          	jal	ra,80000756 <panic>
    wakeup(&log);
    80003bb2:	00022497          	auipc	s1,0x22
    80003bb6:	af648493          	addi	s1,s1,-1290 # 800256a8 <log>
    80003bba:	8526                	mv	a0,s1
    80003bbc:	a88fe0ef          	jal	ra,80001e44 <wakeup>
  release(&log.lock);
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	870fd0ef          	jal	ra,80000c32 <release>
}
    80003bc6:	70e2                	ld	ra,56(sp)
    80003bc8:	7442                	ld	s0,48(sp)
    80003bca:	74a2                	ld	s1,40(sp)
    80003bcc:	7902                	ld	s2,32(sp)
    80003bce:	69e2                	ld	s3,24(sp)
    80003bd0:	6a42                	ld	s4,16(sp)
    80003bd2:	6aa2                	ld	s5,8(sp)
    80003bd4:	6121                	addi	sp,sp,64
    80003bd6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd8:	00022a97          	auipc	s5,0x22
    80003bdc:	b00a8a93          	addi	s5,s5,-1280 # 800256d8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003be0:	00022a17          	auipc	s4,0x22
    80003be4:	ac8a0a13          	addi	s4,s4,-1336 # 800256a8 <log>
    80003be8:	018a2583          	lw	a1,24(s4)
    80003bec:	012585bb          	addw	a1,a1,s2
    80003bf0:	2585                	addiw	a1,a1,1
    80003bf2:	028a2503          	lw	a0,40(s4)
    80003bf6:	f2dfe0ef          	jal	ra,80002b22 <bread>
    80003bfa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003bfc:	000aa583          	lw	a1,0(s5)
    80003c00:	028a2503          	lw	a0,40(s4)
    80003c04:	f1ffe0ef          	jal	ra,80002b22 <bread>
    80003c08:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c0a:	40000613          	li	a2,1024
    80003c0e:	05850593          	addi	a1,a0,88
    80003c12:	05848513          	addi	a0,s1,88
    80003c16:	8b4fd0ef          	jal	ra,80000cca <memmove>
    bwrite(to);  // write the log
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	fddfe0ef          	jal	ra,80002bf8 <bwrite>
    brelse(from);
    80003c20:	854e                	mv	a0,s3
    80003c22:	808ff0ef          	jal	ra,80002c2a <brelse>
    brelse(to);
    80003c26:	8526                	mv	a0,s1
    80003c28:	802ff0ef          	jal	ra,80002c2a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c2c:	2905                	addiw	s2,s2,1
    80003c2e:	0a91                	addi	s5,s5,4
    80003c30:	02ca2783          	lw	a5,44(s4)
    80003c34:	faf94ae3          	blt	s2,a5,80003be8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c38:	cefff0ef          	jal	ra,80003926 <write_head>
    install_trans(0); // Now install writes to home locations
    80003c3c:	4501                	li	a0,0
    80003c3e:	d57ff0ef          	jal	ra,80003994 <install_trans>
    log.lh.n = 0;
    80003c42:	00022797          	auipc	a5,0x22
    80003c46:	a807a923          	sw	zero,-1390(a5) # 800256d4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c4a:	cddff0ef          	jal	ra,80003926 <write_head>
    80003c4e:	bf25                	j	80003b86 <end_op+0x4a>

0000000080003c50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c50:	1101                	addi	sp,sp,-32
    80003c52:	ec06                	sd	ra,24(sp)
    80003c54:	e822                	sd	s0,16(sp)
    80003c56:	e426                	sd	s1,8(sp)
    80003c58:	e04a                	sd	s2,0(sp)
    80003c5a:	1000                	addi	s0,sp,32
    80003c5c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c5e:	00022917          	auipc	s2,0x22
    80003c62:	a4a90913          	addi	s2,s2,-1462 # 800256a8 <log>
    80003c66:	854a                	mv	a0,s2
    80003c68:	f33fc0ef          	jal	ra,80000b9a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c6c:	02c92603          	lw	a2,44(s2)
    80003c70:	47f5                	li	a5,29
    80003c72:	06c7c363          	blt	a5,a2,80003cd8 <log_write+0x88>
    80003c76:	00022797          	auipc	a5,0x22
    80003c7a:	a4e7a783          	lw	a5,-1458(a5) # 800256c4 <log+0x1c>
    80003c7e:	37fd                	addiw	a5,a5,-1
    80003c80:	04f65c63          	bge	a2,a5,80003cd8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c84:	00022797          	auipc	a5,0x22
    80003c88:	a447a783          	lw	a5,-1468(a5) # 800256c8 <log+0x20>
    80003c8c:	04f05c63          	blez	a5,80003ce4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c90:	4781                	li	a5,0
    80003c92:	04c05f63          	blez	a2,80003cf0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c96:	44cc                	lw	a1,12(s1)
    80003c98:	00022717          	auipc	a4,0x22
    80003c9c:	a4070713          	addi	a4,a4,-1472 # 800256d8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ca0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ca2:	4314                	lw	a3,0(a4)
    80003ca4:	04b68663          	beq	a3,a1,80003cf0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003ca8:	2785                	addiw	a5,a5,1
    80003caa:	0711                	addi	a4,a4,4
    80003cac:	fef61be3          	bne	a2,a5,80003ca2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003cb0:	0621                	addi	a2,a2,8
    80003cb2:	060a                	slli	a2,a2,0x2
    80003cb4:	00022797          	auipc	a5,0x22
    80003cb8:	9f478793          	addi	a5,a5,-1548 # 800256a8 <log>
    80003cbc:	963e                	add	a2,a2,a5
    80003cbe:	44dc                	lw	a5,12(s1)
    80003cc0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003cc2:	8526                	mv	a0,s1
    80003cc4:	ff1fe0ef          	jal	ra,80002cb4 <bpin>
    log.lh.n++;
    80003cc8:	00022717          	auipc	a4,0x22
    80003ccc:	9e070713          	addi	a4,a4,-1568 # 800256a8 <log>
    80003cd0:	575c                	lw	a5,44(a4)
    80003cd2:	2785                	addiw	a5,a5,1
    80003cd4:	d75c                	sw	a5,44(a4)
    80003cd6:	a815                	j	80003d0a <log_write+0xba>
    panic("too big a transaction");
    80003cd8:	00004517          	auipc	a0,0x4
    80003cdc:	9c850513          	addi	a0,a0,-1592 # 800076a0 <syscalls+0x210>
    80003ce0:	a77fc0ef          	jal	ra,80000756 <panic>
    panic("log_write outside of trans");
    80003ce4:	00004517          	auipc	a0,0x4
    80003ce8:	9d450513          	addi	a0,a0,-1580 # 800076b8 <syscalls+0x228>
    80003cec:	a6bfc0ef          	jal	ra,80000756 <panic>
  log.lh.block[i] = b->blockno;
    80003cf0:	00878713          	addi	a4,a5,8
    80003cf4:	00271693          	slli	a3,a4,0x2
    80003cf8:	00022717          	auipc	a4,0x22
    80003cfc:	9b070713          	addi	a4,a4,-1616 # 800256a8 <log>
    80003d00:	9736                	add	a4,a4,a3
    80003d02:	44d4                	lw	a3,12(s1)
    80003d04:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003d06:	faf60ee3          	beq	a2,a5,80003cc2 <log_write+0x72>
  }
  release(&log.lock);
    80003d0a:	00022517          	auipc	a0,0x22
    80003d0e:	99e50513          	addi	a0,a0,-1634 # 800256a8 <log>
    80003d12:	f21fc0ef          	jal	ra,80000c32 <release>
}
    80003d16:	60e2                	ld	ra,24(sp)
    80003d18:	6442                	ld	s0,16(sp)
    80003d1a:	64a2                	ld	s1,8(sp)
    80003d1c:	6902                	ld	s2,0(sp)
    80003d1e:	6105                	addi	sp,sp,32
    80003d20:	8082                	ret

0000000080003d22 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d22:	1101                	addi	sp,sp,-32
    80003d24:	ec06                	sd	ra,24(sp)
    80003d26:	e822                	sd	s0,16(sp)
    80003d28:	e426                	sd	s1,8(sp)
    80003d2a:	e04a                	sd	s2,0(sp)
    80003d2c:	1000                	addi	s0,sp,32
    80003d2e:	84aa                	mv	s1,a0
    80003d30:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d32:	00004597          	auipc	a1,0x4
    80003d36:	9a658593          	addi	a1,a1,-1626 # 800076d8 <syscalls+0x248>
    80003d3a:	0521                	addi	a0,a0,8
    80003d3c:	ddffc0ef          	jal	ra,80000b1a <initlock>
  lk->name = name;
    80003d40:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d44:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d48:	0204a423          	sw	zero,40(s1)
}
    80003d4c:	60e2                	ld	ra,24(sp)
    80003d4e:	6442                	ld	s0,16(sp)
    80003d50:	64a2                	ld	s1,8(sp)
    80003d52:	6902                	ld	s2,0(sp)
    80003d54:	6105                	addi	sp,sp,32
    80003d56:	8082                	ret

0000000080003d58 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d58:	1101                	addi	sp,sp,-32
    80003d5a:	ec06                	sd	ra,24(sp)
    80003d5c:	e822                	sd	s0,16(sp)
    80003d5e:	e426                	sd	s1,8(sp)
    80003d60:	e04a                	sd	s2,0(sp)
    80003d62:	1000                	addi	s0,sp,32
    80003d64:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d66:	00850913          	addi	s2,a0,8
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	e2ffc0ef          	jal	ra,80000b9a <acquire>
  while (lk->locked) {
    80003d70:	409c                	lw	a5,0(s1)
    80003d72:	c799                	beqz	a5,80003d80 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d74:	85ca                	mv	a1,s2
    80003d76:	8526                	mv	a0,s1
    80003d78:	880fe0ef          	jal	ra,80001df8 <sleep>
  while (lk->locked) {
    80003d7c:	409c                	lw	a5,0(s1)
    80003d7e:	fbfd                	bnez	a5,80003d74 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003d80:	4785                	li	a5,1
    80003d82:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d84:	aa9fd0ef          	jal	ra,8000182c <myproc>
    80003d88:	591c                	lw	a5,48(a0)
    80003d8a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d8c:	854a                	mv	a0,s2
    80003d8e:	ea5fc0ef          	jal	ra,80000c32 <release>
}
    80003d92:	60e2                	ld	ra,24(sp)
    80003d94:	6442                	ld	s0,16(sp)
    80003d96:	64a2                	ld	s1,8(sp)
    80003d98:	6902                	ld	s2,0(sp)
    80003d9a:	6105                	addi	sp,sp,32
    80003d9c:	8082                	ret

0000000080003d9e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d9e:	1101                	addi	sp,sp,-32
    80003da0:	ec06                	sd	ra,24(sp)
    80003da2:	e822                	sd	s0,16(sp)
    80003da4:	e426                	sd	s1,8(sp)
    80003da6:	e04a                	sd	s2,0(sp)
    80003da8:	1000                	addi	s0,sp,32
    80003daa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003dac:	00850913          	addi	s2,a0,8
    80003db0:	854a                	mv	a0,s2
    80003db2:	de9fc0ef          	jal	ra,80000b9a <acquire>
  lk->locked = 0;
    80003db6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003dba:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	884fe0ef          	jal	ra,80001e44 <wakeup>
  release(&lk->lk);
    80003dc4:	854a                	mv	a0,s2
    80003dc6:	e6dfc0ef          	jal	ra,80000c32 <release>
}
    80003dca:	60e2                	ld	ra,24(sp)
    80003dcc:	6442                	ld	s0,16(sp)
    80003dce:	64a2                	ld	s1,8(sp)
    80003dd0:	6902                	ld	s2,0(sp)
    80003dd2:	6105                	addi	sp,sp,32
    80003dd4:	8082                	ret

0000000080003dd6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003dd6:	7179                	addi	sp,sp,-48
    80003dd8:	f406                	sd	ra,40(sp)
    80003dda:	f022                	sd	s0,32(sp)
    80003ddc:	ec26                	sd	s1,24(sp)
    80003dde:	e84a                	sd	s2,16(sp)
    80003de0:	e44e                	sd	s3,8(sp)
    80003de2:	1800                	addi	s0,sp,48
    80003de4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003de6:	00850913          	addi	s2,a0,8
    80003dea:	854a                	mv	a0,s2
    80003dec:	daffc0ef          	jal	ra,80000b9a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003df0:	409c                	lw	a5,0(s1)
    80003df2:	ef89                	bnez	a5,80003e0c <holdingsleep+0x36>
    80003df4:	4481                	li	s1,0
  release(&lk->lk);
    80003df6:	854a                	mv	a0,s2
    80003df8:	e3bfc0ef          	jal	ra,80000c32 <release>
  return r;
}
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	70a2                	ld	ra,40(sp)
    80003e00:	7402                	ld	s0,32(sp)
    80003e02:	64e2                	ld	s1,24(sp)
    80003e04:	6942                	ld	s2,16(sp)
    80003e06:	69a2                	ld	s3,8(sp)
    80003e08:	6145                	addi	sp,sp,48
    80003e0a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e0c:	0284a983          	lw	s3,40(s1)
    80003e10:	a1dfd0ef          	jal	ra,8000182c <myproc>
    80003e14:	5904                	lw	s1,48(a0)
    80003e16:	413484b3          	sub	s1,s1,s3
    80003e1a:	0014b493          	seqz	s1,s1
    80003e1e:	bfe1                	j	80003df6 <holdingsleep+0x20>

0000000080003e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e20:	1141                	addi	sp,sp,-16
    80003e22:	e406                	sd	ra,8(sp)
    80003e24:	e022                	sd	s0,0(sp)
    80003e26:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e28:	00004597          	auipc	a1,0x4
    80003e2c:	8c058593          	addi	a1,a1,-1856 # 800076e8 <syscalls+0x258>
    80003e30:	00022517          	auipc	a0,0x22
    80003e34:	9c050513          	addi	a0,a0,-1600 # 800257f0 <ftable>
    80003e38:	ce3fc0ef          	jal	ra,80000b1a <initlock>
}
    80003e3c:	60a2                	ld	ra,8(sp)
    80003e3e:	6402                	ld	s0,0(sp)
    80003e40:	0141                	addi	sp,sp,16
    80003e42:	8082                	ret

0000000080003e44 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003e44:	1101                	addi	sp,sp,-32
    80003e46:	ec06                	sd	ra,24(sp)
    80003e48:	e822                	sd	s0,16(sp)
    80003e4a:	e426                	sd	s1,8(sp)
    80003e4c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e4e:	00022517          	auipc	a0,0x22
    80003e52:	9a250513          	addi	a0,a0,-1630 # 800257f0 <ftable>
    80003e56:	d45fc0ef          	jal	ra,80000b9a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e5a:	00022497          	auipc	s1,0x22
    80003e5e:	9ae48493          	addi	s1,s1,-1618 # 80025808 <ftable+0x18>
    80003e62:	00023717          	auipc	a4,0x23
    80003e66:	94670713          	addi	a4,a4,-1722 # 800267a8 <disk>
    if(f->ref == 0){
    80003e6a:	40dc                	lw	a5,4(s1)
    80003e6c:	cf89                	beqz	a5,80003e86 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e6e:	02848493          	addi	s1,s1,40
    80003e72:	fee49ce3          	bne	s1,a4,80003e6a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e76:	00022517          	auipc	a0,0x22
    80003e7a:	97a50513          	addi	a0,a0,-1670 # 800257f0 <ftable>
    80003e7e:	db5fc0ef          	jal	ra,80000c32 <release>
  return 0;
    80003e82:	4481                	li	s1,0
    80003e84:	a809                	j	80003e96 <filealloc+0x52>
      f->ref = 1;
    80003e86:	4785                	li	a5,1
    80003e88:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e8a:	00022517          	auipc	a0,0x22
    80003e8e:	96650513          	addi	a0,a0,-1690 # 800257f0 <ftable>
    80003e92:	da1fc0ef          	jal	ra,80000c32 <release>
}
    80003e96:	8526                	mv	a0,s1
    80003e98:	60e2                	ld	ra,24(sp)
    80003e9a:	6442                	ld	s0,16(sp)
    80003e9c:	64a2                	ld	s1,8(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret

0000000080003ea2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ea2:	1101                	addi	sp,sp,-32
    80003ea4:	ec06                	sd	ra,24(sp)
    80003ea6:	e822                	sd	s0,16(sp)
    80003ea8:	e426                	sd	s1,8(sp)
    80003eaa:	1000                	addi	s0,sp,32
    80003eac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003eae:	00022517          	auipc	a0,0x22
    80003eb2:	94250513          	addi	a0,a0,-1726 # 800257f0 <ftable>
    80003eb6:	ce5fc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003eba:	40dc                	lw	a5,4(s1)
    80003ebc:	02f05063          	blez	a5,80003edc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ec0:	2785                	addiw	a5,a5,1
    80003ec2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ec4:	00022517          	auipc	a0,0x22
    80003ec8:	92c50513          	addi	a0,a0,-1748 # 800257f0 <ftable>
    80003ecc:	d67fc0ef          	jal	ra,80000c32 <release>
  return f;
}
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	60e2                	ld	ra,24(sp)
    80003ed4:	6442                	ld	s0,16(sp)
    80003ed6:	64a2                	ld	s1,8(sp)
    80003ed8:	6105                	addi	sp,sp,32
    80003eda:	8082                	ret
    panic("filedup");
    80003edc:	00004517          	auipc	a0,0x4
    80003ee0:	81450513          	addi	a0,a0,-2028 # 800076f0 <syscalls+0x260>
    80003ee4:	873fc0ef          	jal	ra,80000756 <panic>

0000000080003ee8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ee8:	7139                	addi	sp,sp,-64
    80003eea:	fc06                	sd	ra,56(sp)
    80003eec:	f822                	sd	s0,48(sp)
    80003eee:	f426                	sd	s1,40(sp)
    80003ef0:	f04a                	sd	s2,32(sp)
    80003ef2:	ec4e                	sd	s3,24(sp)
    80003ef4:	e852                	sd	s4,16(sp)
    80003ef6:	e456                	sd	s5,8(sp)
    80003ef8:	0080                	addi	s0,sp,64
    80003efa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003efc:	00022517          	auipc	a0,0x22
    80003f00:	8f450513          	addi	a0,a0,-1804 # 800257f0 <ftable>
    80003f04:	c97fc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003f08:	40dc                	lw	a5,4(s1)
    80003f0a:	04f05963          	blez	a5,80003f5c <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003f0e:	37fd                	addiw	a5,a5,-1
    80003f10:	0007871b          	sext.w	a4,a5
    80003f14:	c0dc                	sw	a5,4(s1)
    80003f16:	04e04963          	bgtz	a4,80003f68 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f1a:	0004a903          	lw	s2,0(s1)
    80003f1e:	0094ca83          	lbu	s5,9(s1)
    80003f22:	0104ba03          	ld	s4,16(s1)
    80003f26:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f2a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f2e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f32:	00022517          	auipc	a0,0x22
    80003f36:	8be50513          	addi	a0,a0,-1858 # 800257f0 <ftable>
    80003f3a:	cf9fc0ef          	jal	ra,80000c32 <release>

  if(ff.type == FD_PIPE){
    80003f3e:	4785                	li	a5,1
    80003f40:	04f90363          	beq	s2,a5,80003f86 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003f44:	3979                	addiw	s2,s2,-2
    80003f46:	4785                	li	a5,1
    80003f48:	0327e663          	bltu	a5,s2,80003f74 <fileclose+0x8c>
    begin_op();
    80003f4c:	b81ff0ef          	jal	ra,80003acc <begin_op>
    iput(ff.ip);
    80003f50:	854e                	mv	a0,s3
    80003f52:	c6cff0ef          	jal	ra,800033be <iput>
    end_op();
    80003f56:	be7ff0ef          	jal	ra,80003b3c <end_op>
    80003f5a:	a829                	j	80003f74 <fileclose+0x8c>
    panic("fileclose");
    80003f5c:	00003517          	auipc	a0,0x3
    80003f60:	79c50513          	addi	a0,a0,1948 # 800076f8 <syscalls+0x268>
    80003f64:	ff2fc0ef          	jal	ra,80000756 <panic>
    release(&ftable.lock);
    80003f68:	00022517          	auipc	a0,0x22
    80003f6c:	88850513          	addi	a0,a0,-1912 # 800257f0 <ftable>
    80003f70:	cc3fc0ef          	jal	ra,80000c32 <release>
  }
}
    80003f74:	70e2                	ld	ra,56(sp)
    80003f76:	7442                	ld	s0,48(sp)
    80003f78:	74a2                	ld	s1,40(sp)
    80003f7a:	7902                	ld	s2,32(sp)
    80003f7c:	69e2                	ld	s3,24(sp)
    80003f7e:	6a42                	ld	s4,16(sp)
    80003f80:	6aa2                	ld	s5,8(sp)
    80003f82:	6121                	addi	sp,sp,64
    80003f84:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003f86:	85d6                	mv	a1,s5
    80003f88:	8552                	mv	a0,s4
    80003f8a:	2ee000ef          	jal	ra,80004278 <pipeclose>
    80003f8e:	b7dd                	j	80003f74 <fileclose+0x8c>

0000000080003f90 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f90:	715d                	addi	sp,sp,-80
    80003f92:	e486                	sd	ra,72(sp)
    80003f94:	e0a2                	sd	s0,64(sp)
    80003f96:	fc26                	sd	s1,56(sp)
    80003f98:	f84a                	sd	s2,48(sp)
    80003f9a:	f44e                	sd	s3,40(sp)
    80003f9c:	0880                	addi	s0,sp,80
    80003f9e:	84aa                	mv	s1,a0
    80003fa0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003fa2:	88bfd0ef          	jal	ra,8000182c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003fa6:	409c                	lw	a5,0(s1)
    80003fa8:	37f9                	addiw	a5,a5,-2
    80003faa:	4705                	li	a4,1
    80003fac:	04f76063          	bltu	a4,a5,80003fec <filestat+0x5c>
    80003fb0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003fb2:	6c88                	ld	a0,24(s1)
    80003fb4:	a8cff0ef          	jal	ra,80003240 <ilock>
    stati(f->ip, &st);
    80003fb8:	fb040593          	addi	a1,s0,-80
    80003fbc:	6c88                	ld	a0,24(s1)
    80003fbe:	ca8ff0ef          	jal	ra,80003466 <stati>
    iunlock(f->ip);
    80003fc2:	6c88                	ld	a0,24(s1)
    80003fc4:	b26ff0ef          	jal	ra,800032ea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003fc8:	02000693          	li	a3,32
    80003fcc:	fb040613          	addi	a2,s0,-80
    80003fd0:	85ce                	mv	a1,s3
    80003fd2:	05093503          	ld	a0,80(s2)
    80003fd6:	d0afd0ef          	jal	ra,800014e0 <copyout>
    80003fda:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003fde:	60a6                	ld	ra,72(sp)
    80003fe0:	6406                	ld	s0,64(sp)
    80003fe2:	74e2                	ld	s1,56(sp)
    80003fe4:	7942                	ld	s2,48(sp)
    80003fe6:	79a2                	ld	s3,40(sp)
    80003fe8:	6161                	addi	sp,sp,80
    80003fea:	8082                	ret
  return -1;
    80003fec:	557d                	li	a0,-1
    80003fee:	bfc5                	j	80003fde <filestat+0x4e>

0000000080003ff0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ff0:	7179                	addi	sp,sp,-48
    80003ff2:	f406                	sd	ra,40(sp)
    80003ff4:	f022                	sd	s0,32(sp)
    80003ff6:	ec26                	sd	s1,24(sp)
    80003ff8:	e84a                	sd	s2,16(sp)
    80003ffa:	e44e                	sd	s3,8(sp)
    80003ffc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ffe:	00854783          	lbu	a5,8(a0)
    80004002:	cbc1                	beqz	a5,80004092 <fileread+0xa2>
    80004004:	84aa                	mv	s1,a0
    80004006:	89ae                	mv	s3,a1
    80004008:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000400a:	411c                	lw	a5,0(a0)
    8000400c:	4705                	li	a4,1
    8000400e:	04e78363          	beq	a5,a4,80004054 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004012:	470d                	li	a4,3
    80004014:	04e78563          	beq	a5,a4,8000405e <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004018:	4709                	li	a4,2
    8000401a:	06e79663          	bne	a5,a4,80004086 <fileread+0x96>
    ilock(f->ip);
    8000401e:	6d08                	ld	a0,24(a0)
    80004020:	a20ff0ef          	jal	ra,80003240 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004024:	874a                	mv	a4,s2
    80004026:	5094                	lw	a3,32(s1)
    80004028:	864e                	mv	a2,s3
    8000402a:	4585                	li	a1,1
    8000402c:	6c88                	ld	a0,24(s1)
    8000402e:	c62ff0ef          	jal	ra,80003490 <readi>
    80004032:	892a                	mv	s2,a0
    80004034:	00a05563          	blez	a0,8000403e <fileread+0x4e>
      f->off += r;
    80004038:	509c                	lw	a5,32(s1)
    8000403a:	9fa9                	addw	a5,a5,a0
    8000403c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000403e:	6c88                	ld	a0,24(s1)
    80004040:	aaaff0ef          	jal	ra,800032ea <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004044:	854a                	mv	a0,s2
    80004046:	70a2                	ld	ra,40(sp)
    80004048:	7402                	ld	s0,32(sp)
    8000404a:	64e2                	ld	s1,24(sp)
    8000404c:	6942                	ld	s2,16(sp)
    8000404e:	69a2                	ld	s3,8(sp)
    80004050:	6145                	addi	sp,sp,48
    80004052:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004054:	6908                	ld	a0,16(a0)
    80004056:	34e000ef          	jal	ra,800043a4 <piperead>
    8000405a:	892a                	mv	s2,a0
    8000405c:	b7e5                	j	80004044 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000405e:	02451783          	lh	a5,36(a0)
    80004062:	03079693          	slli	a3,a5,0x30
    80004066:	92c1                	srli	a3,a3,0x30
    80004068:	4725                	li	a4,9
    8000406a:	02d76663          	bltu	a4,a3,80004096 <fileread+0xa6>
    8000406e:	0792                	slli	a5,a5,0x4
    80004070:	00021717          	auipc	a4,0x21
    80004074:	6e070713          	addi	a4,a4,1760 # 80025750 <devsw>
    80004078:	97ba                	add	a5,a5,a4
    8000407a:	639c                	ld	a5,0(a5)
    8000407c:	cf99                	beqz	a5,8000409a <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000407e:	4505                	li	a0,1
    80004080:	9782                	jalr	a5
    80004082:	892a                	mv	s2,a0
    80004084:	b7c1                	j	80004044 <fileread+0x54>
    panic("fileread");
    80004086:	00003517          	auipc	a0,0x3
    8000408a:	68250513          	addi	a0,a0,1666 # 80007708 <syscalls+0x278>
    8000408e:	ec8fc0ef          	jal	ra,80000756 <panic>
    return -1;
    80004092:	597d                	li	s2,-1
    80004094:	bf45                	j	80004044 <fileread+0x54>
      return -1;
    80004096:	597d                	li	s2,-1
    80004098:	b775                	j	80004044 <fileread+0x54>
    8000409a:	597d                	li	s2,-1
    8000409c:	b765                	j	80004044 <fileread+0x54>

000000008000409e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    8000409e:	715d                	addi	sp,sp,-80
    800040a0:	e486                	sd	ra,72(sp)
    800040a2:	e0a2                	sd	s0,64(sp)
    800040a4:	fc26                	sd	s1,56(sp)
    800040a6:	f84a                	sd	s2,48(sp)
    800040a8:	f44e                	sd	s3,40(sp)
    800040aa:	f052                	sd	s4,32(sp)
    800040ac:	ec56                	sd	s5,24(sp)
    800040ae:	e85a                	sd	s6,16(sp)
    800040b0:	e45e                	sd	s7,8(sp)
    800040b2:	e062                	sd	s8,0(sp)
    800040b4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800040b6:	00954783          	lbu	a5,9(a0)
    800040ba:	0e078863          	beqz	a5,800041aa <filewrite+0x10c>
    800040be:	892a                	mv	s2,a0
    800040c0:	8aae                	mv	s5,a1
    800040c2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800040c4:	411c                	lw	a5,0(a0)
    800040c6:	4705                	li	a4,1
    800040c8:	02e78263          	beq	a5,a4,800040ec <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040cc:	470d                	li	a4,3
    800040ce:	02e78463          	beq	a5,a4,800040f6 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800040d2:	4709                	li	a4,2
    800040d4:	0ce79563          	bne	a5,a4,8000419e <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800040d8:	0ac05163          	blez	a2,8000417a <filewrite+0xdc>
    int i = 0;
    800040dc:	4981                	li	s3,0
    800040de:	6b05                	lui	s6,0x1
    800040e0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800040e4:	6b85                	lui	s7,0x1
    800040e6:	c00b8b9b          	addiw	s7,s7,-1024
    800040ea:	a041                	j	8000416a <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800040ec:	6908                	ld	a0,16(a0)
    800040ee:	1e2000ef          	jal	ra,800042d0 <pipewrite>
    800040f2:	8a2a                	mv	s4,a0
    800040f4:	a071                	j	80004180 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040f6:	02451783          	lh	a5,36(a0)
    800040fa:	03079693          	slli	a3,a5,0x30
    800040fe:	92c1                	srli	a3,a3,0x30
    80004100:	4725                	li	a4,9
    80004102:	0ad76663          	bltu	a4,a3,800041ae <filewrite+0x110>
    80004106:	0792                	slli	a5,a5,0x4
    80004108:	00021717          	auipc	a4,0x21
    8000410c:	64870713          	addi	a4,a4,1608 # 80025750 <devsw>
    80004110:	97ba                	add	a5,a5,a4
    80004112:	679c                	ld	a5,8(a5)
    80004114:	cfd9                	beqz	a5,800041b2 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80004116:	4505                	li	a0,1
    80004118:	9782                	jalr	a5
    8000411a:	8a2a                	mv	s4,a0
    8000411c:	a095                	j	80004180 <filewrite+0xe2>
    8000411e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004122:	9abff0ef          	jal	ra,80003acc <begin_op>
      ilock(f->ip);
    80004126:	01893503          	ld	a0,24(s2)
    8000412a:	916ff0ef          	jal	ra,80003240 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000412e:	8762                	mv	a4,s8
    80004130:	02092683          	lw	a3,32(s2)
    80004134:	01598633          	add	a2,s3,s5
    80004138:	4585                	li	a1,1
    8000413a:	01893503          	ld	a0,24(s2)
    8000413e:	c36ff0ef          	jal	ra,80003574 <writei>
    80004142:	84aa                	mv	s1,a0
    80004144:	00a05763          	blez	a0,80004152 <filewrite+0xb4>
        f->off += r;
    80004148:	02092783          	lw	a5,32(s2)
    8000414c:	9fa9                	addw	a5,a5,a0
    8000414e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004152:	01893503          	ld	a0,24(s2)
    80004156:	994ff0ef          	jal	ra,800032ea <iunlock>
      end_op();
    8000415a:	9e3ff0ef          	jal	ra,80003b3c <end_op>

      if(r != n1){
    8000415e:	009c1f63          	bne	s8,s1,8000417c <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80004162:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004166:	0149db63          	bge	s3,s4,8000417c <filewrite+0xde>
      int n1 = n - i;
    8000416a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000416e:	84be                	mv	s1,a5
    80004170:	2781                	sext.w	a5,a5
    80004172:	fafb56e3          	bge	s6,a5,8000411e <filewrite+0x80>
    80004176:	84de                	mv	s1,s7
    80004178:	b75d                	j	8000411e <filewrite+0x80>
    int i = 0;
    8000417a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000417c:	013a1f63          	bne	s4,s3,8000419a <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004180:	8552                	mv	a0,s4
    80004182:	60a6                	ld	ra,72(sp)
    80004184:	6406                	ld	s0,64(sp)
    80004186:	74e2                	ld	s1,56(sp)
    80004188:	7942                	ld	s2,48(sp)
    8000418a:	79a2                	ld	s3,40(sp)
    8000418c:	7a02                	ld	s4,32(sp)
    8000418e:	6ae2                	ld	s5,24(sp)
    80004190:	6b42                	ld	s6,16(sp)
    80004192:	6ba2                	ld	s7,8(sp)
    80004194:	6c02                	ld	s8,0(sp)
    80004196:	6161                	addi	sp,sp,80
    80004198:	8082                	ret
    ret = (i == n ? n : -1);
    8000419a:	5a7d                	li	s4,-1
    8000419c:	b7d5                	j	80004180 <filewrite+0xe2>
    panic("filewrite");
    8000419e:	00003517          	auipc	a0,0x3
    800041a2:	57a50513          	addi	a0,a0,1402 # 80007718 <syscalls+0x288>
    800041a6:	db0fc0ef          	jal	ra,80000756 <panic>
    return -1;
    800041aa:	5a7d                	li	s4,-1
    800041ac:	bfd1                	j	80004180 <filewrite+0xe2>
      return -1;
    800041ae:	5a7d                	li	s4,-1
    800041b0:	bfc1                	j	80004180 <filewrite+0xe2>
    800041b2:	5a7d                	li	s4,-1
    800041b4:	b7f1                	j	80004180 <filewrite+0xe2>

00000000800041b6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800041b6:	7179                	addi	sp,sp,-48
    800041b8:	f406                	sd	ra,40(sp)
    800041ba:	f022                	sd	s0,32(sp)
    800041bc:	ec26                	sd	s1,24(sp)
    800041be:	e84a                	sd	s2,16(sp)
    800041c0:	e44e                	sd	s3,8(sp)
    800041c2:	e052                	sd	s4,0(sp)
    800041c4:	1800                	addi	s0,sp,48
    800041c6:	84aa                	mv	s1,a0
    800041c8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041ca:	0005b023          	sd	zero,0(a1)
    800041ce:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041d2:	c73ff0ef          	jal	ra,80003e44 <filealloc>
    800041d6:	e088                	sd	a0,0(s1)
    800041d8:	cd35                	beqz	a0,80004254 <pipealloc+0x9e>
    800041da:	c6bff0ef          	jal	ra,80003e44 <filealloc>
    800041de:	00aa3023          	sd	a0,0(s4)
    800041e2:	c52d                	beqz	a0,8000424c <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041e4:	8e7fc0ef          	jal	ra,80000aca <kalloc>
    800041e8:	892a                	mv	s2,a0
    800041ea:	cd31                	beqz	a0,80004246 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800041ec:	4985                	li	s3,1
    800041ee:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041f2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041f6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041fa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041fe:	00003597          	auipc	a1,0x3
    80004202:	52a58593          	addi	a1,a1,1322 # 80007728 <syscalls+0x298>
    80004206:	915fc0ef          	jal	ra,80000b1a <initlock>
  (*f0)->type = FD_PIPE;
    8000420a:	609c                	ld	a5,0(s1)
    8000420c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004210:	609c                	ld	a5,0(s1)
    80004212:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004216:	609c                	ld	a5,0(s1)
    80004218:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000421c:	609c                	ld	a5,0(s1)
    8000421e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004222:	000a3783          	ld	a5,0(s4)
    80004226:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000422a:	000a3783          	ld	a5,0(s4)
    8000422e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004232:	000a3783          	ld	a5,0(s4)
    80004236:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000423a:	000a3783          	ld	a5,0(s4)
    8000423e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004242:	4501                	li	a0,0
    80004244:	a005                	j	80004264 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004246:	6088                	ld	a0,0(s1)
    80004248:	e501                	bnez	a0,80004250 <pipealloc+0x9a>
    8000424a:	a029                	j	80004254 <pipealloc+0x9e>
    8000424c:	6088                	ld	a0,0(s1)
    8000424e:	c11d                	beqz	a0,80004274 <pipealloc+0xbe>
    fileclose(*f0);
    80004250:	c99ff0ef          	jal	ra,80003ee8 <fileclose>
  if(*f1)
    80004254:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004258:	557d                	li	a0,-1
  if(*f1)
    8000425a:	c789                	beqz	a5,80004264 <pipealloc+0xae>
    fileclose(*f1);
    8000425c:	853e                	mv	a0,a5
    8000425e:	c8bff0ef          	jal	ra,80003ee8 <fileclose>
  return -1;
    80004262:	557d                	li	a0,-1
}
    80004264:	70a2                	ld	ra,40(sp)
    80004266:	7402                	ld	s0,32(sp)
    80004268:	64e2                	ld	s1,24(sp)
    8000426a:	6942                	ld	s2,16(sp)
    8000426c:	69a2                	ld	s3,8(sp)
    8000426e:	6a02                	ld	s4,0(sp)
    80004270:	6145                	addi	sp,sp,48
    80004272:	8082                	ret
  return -1;
    80004274:	557d                	li	a0,-1
    80004276:	b7fd                	j	80004264 <pipealloc+0xae>

0000000080004278 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004278:	1101                	addi	sp,sp,-32
    8000427a:	ec06                	sd	ra,24(sp)
    8000427c:	e822                	sd	s0,16(sp)
    8000427e:	e426                	sd	s1,8(sp)
    80004280:	e04a                	sd	s2,0(sp)
    80004282:	1000                	addi	s0,sp,32
    80004284:	84aa                	mv	s1,a0
    80004286:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004288:	913fc0ef          	jal	ra,80000b9a <acquire>
  if(writable){
    8000428c:	02090763          	beqz	s2,800042ba <pipeclose+0x42>
    pi->writeopen = 0;
    80004290:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004294:	21848513          	addi	a0,s1,536
    80004298:	badfd0ef          	jal	ra,80001e44 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000429c:	2204b783          	ld	a5,544(s1)
    800042a0:	e785                	bnez	a5,800042c8 <pipeclose+0x50>
    release(&pi->lock);
    800042a2:	8526                	mv	a0,s1
    800042a4:	98ffc0ef          	jal	ra,80000c32 <release>
    kfree((char*)pi);
    800042a8:	8526                	mv	a0,s1
    800042aa:	f40fc0ef          	jal	ra,800009ea <kfree>
  } else
    release(&pi->lock);
}
    800042ae:	60e2                	ld	ra,24(sp)
    800042b0:	6442                	ld	s0,16(sp)
    800042b2:	64a2                	ld	s1,8(sp)
    800042b4:	6902                	ld	s2,0(sp)
    800042b6:	6105                	addi	sp,sp,32
    800042b8:	8082                	ret
    pi->readopen = 0;
    800042ba:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042be:	21c48513          	addi	a0,s1,540
    800042c2:	b83fd0ef          	jal	ra,80001e44 <wakeup>
    800042c6:	bfd9                	j	8000429c <pipeclose+0x24>
    release(&pi->lock);
    800042c8:	8526                	mv	a0,s1
    800042ca:	969fc0ef          	jal	ra,80000c32 <release>
}
    800042ce:	b7c5                	j	800042ae <pipeclose+0x36>

00000000800042d0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042d0:	711d                	addi	sp,sp,-96
    800042d2:	ec86                	sd	ra,88(sp)
    800042d4:	e8a2                	sd	s0,80(sp)
    800042d6:	e4a6                	sd	s1,72(sp)
    800042d8:	e0ca                	sd	s2,64(sp)
    800042da:	fc4e                	sd	s3,56(sp)
    800042dc:	f852                	sd	s4,48(sp)
    800042de:	f456                	sd	s5,40(sp)
    800042e0:	f05a                	sd	s6,32(sp)
    800042e2:	ec5e                	sd	s7,24(sp)
    800042e4:	e862                	sd	s8,16(sp)
    800042e6:	1080                	addi	s0,sp,96
    800042e8:	84aa                	mv	s1,a0
    800042ea:	8aae                	mv	s5,a1
    800042ec:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042ee:	d3efd0ef          	jal	ra,8000182c <myproc>
    800042f2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042f4:	8526                	mv	a0,s1
    800042f6:	8a5fc0ef          	jal	ra,80000b9a <acquire>
  while(i < n){
    800042fa:	09405c63          	blez	s4,80004392 <pipewrite+0xc2>
  int i = 0;
    800042fe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004300:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004302:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004306:	21c48b93          	addi	s7,s1,540
    8000430a:	a81d                	j	80004340 <pipewrite+0x70>
      release(&pi->lock);
    8000430c:	8526                	mv	a0,s1
    8000430e:	925fc0ef          	jal	ra,80000c32 <release>
      return -1;
    80004312:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004314:	854a                	mv	a0,s2
    80004316:	60e6                	ld	ra,88(sp)
    80004318:	6446                	ld	s0,80(sp)
    8000431a:	64a6                	ld	s1,72(sp)
    8000431c:	6906                	ld	s2,64(sp)
    8000431e:	79e2                	ld	s3,56(sp)
    80004320:	7a42                	ld	s4,48(sp)
    80004322:	7aa2                	ld	s5,40(sp)
    80004324:	7b02                	ld	s6,32(sp)
    80004326:	6be2                	ld	s7,24(sp)
    80004328:	6c42                	ld	s8,16(sp)
    8000432a:	6125                	addi	sp,sp,96
    8000432c:	8082                	ret
      wakeup(&pi->nread);
    8000432e:	8562                	mv	a0,s8
    80004330:	b15fd0ef          	jal	ra,80001e44 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004334:	85a6                	mv	a1,s1
    80004336:	855e                	mv	a0,s7
    80004338:	ac1fd0ef          	jal	ra,80001df8 <sleep>
  while(i < n){
    8000433c:	05495c63          	bge	s2,s4,80004394 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80004340:	2204a783          	lw	a5,544(s1)
    80004344:	d7e1                	beqz	a5,8000430c <pipewrite+0x3c>
    80004346:	854e                	mv	a0,s3
    80004348:	ce9fd0ef          	jal	ra,80002030 <killed>
    8000434c:	f161                	bnez	a0,8000430c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000434e:	2184a783          	lw	a5,536(s1)
    80004352:	21c4a703          	lw	a4,540(s1)
    80004356:	2007879b          	addiw	a5,a5,512
    8000435a:	fcf70ae3          	beq	a4,a5,8000432e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000435e:	4685                	li	a3,1
    80004360:	01590633          	add	a2,s2,s5
    80004364:	faf40593          	addi	a1,s0,-81
    80004368:	0509b503          	ld	a0,80(s3)
    8000436c:	a2cfd0ef          	jal	ra,80001598 <copyin>
    80004370:	03650263          	beq	a0,s6,80004394 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004374:	21c4a783          	lw	a5,540(s1)
    80004378:	0017871b          	addiw	a4,a5,1
    8000437c:	20e4ae23          	sw	a4,540(s1)
    80004380:	1ff7f793          	andi	a5,a5,511
    80004384:	97a6                	add	a5,a5,s1
    80004386:	faf44703          	lbu	a4,-81(s0)
    8000438a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000438e:	2905                	addiw	s2,s2,1
    80004390:	b775                	j	8000433c <pipewrite+0x6c>
  int i = 0;
    80004392:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004394:	21848513          	addi	a0,s1,536
    80004398:	aadfd0ef          	jal	ra,80001e44 <wakeup>
  release(&pi->lock);
    8000439c:	8526                	mv	a0,s1
    8000439e:	895fc0ef          	jal	ra,80000c32 <release>
  return i;
    800043a2:	bf8d                	j	80004314 <pipewrite+0x44>

00000000800043a4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800043a4:	715d                	addi	sp,sp,-80
    800043a6:	e486                	sd	ra,72(sp)
    800043a8:	e0a2                	sd	s0,64(sp)
    800043aa:	fc26                	sd	s1,56(sp)
    800043ac:	f84a                	sd	s2,48(sp)
    800043ae:	f44e                	sd	s3,40(sp)
    800043b0:	f052                	sd	s4,32(sp)
    800043b2:	ec56                	sd	s5,24(sp)
    800043b4:	e85a                	sd	s6,16(sp)
    800043b6:	0880                	addi	s0,sp,80
    800043b8:	84aa                	mv	s1,a0
    800043ba:	892e                	mv	s2,a1
    800043bc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043be:	c6efd0ef          	jal	ra,8000182c <myproc>
    800043c2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043c4:	8526                	mv	a0,s1
    800043c6:	fd4fc0ef          	jal	ra,80000b9a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043ca:	2184a703          	lw	a4,536(s1)
    800043ce:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043d2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043d6:	02f71363          	bne	a4,a5,800043fc <piperead+0x58>
    800043da:	2244a783          	lw	a5,548(s1)
    800043de:	cf99                	beqz	a5,800043fc <piperead+0x58>
    if(killed(pr)){
    800043e0:	8552                	mv	a0,s4
    800043e2:	c4ffd0ef          	jal	ra,80002030 <killed>
    800043e6:	e141                	bnez	a0,80004466 <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043e8:	85a6                	mv	a1,s1
    800043ea:	854e                	mv	a0,s3
    800043ec:	a0dfd0ef          	jal	ra,80001df8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043f0:	2184a703          	lw	a4,536(s1)
    800043f4:	21c4a783          	lw	a5,540(s1)
    800043f8:	fef701e3          	beq	a4,a5,800043da <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043fc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043fe:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004400:	05505163          	blez	s5,80004442 <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    80004404:	2184a783          	lw	a5,536(s1)
    80004408:	21c4a703          	lw	a4,540(s1)
    8000440c:	02f70b63          	beq	a4,a5,80004442 <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004410:	0017871b          	addiw	a4,a5,1
    80004414:	20e4ac23          	sw	a4,536(s1)
    80004418:	1ff7f793          	andi	a5,a5,511
    8000441c:	97a6                	add	a5,a5,s1
    8000441e:	0187c783          	lbu	a5,24(a5)
    80004422:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004426:	4685                	li	a3,1
    80004428:	fbf40613          	addi	a2,s0,-65
    8000442c:	85ca                	mv	a1,s2
    8000442e:	050a3503          	ld	a0,80(s4)
    80004432:	8aefd0ef          	jal	ra,800014e0 <copyout>
    80004436:	01650663          	beq	a0,s6,80004442 <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000443a:	2985                	addiw	s3,s3,1
    8000443c:	0905                	addi	s2,s2,1
    8000443e:	fd3a93e3          	bne	s5,s3,80004404 <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004442:	21c48513          	addi	a0,s1,540
    80004446:	9fffd0ef          	jal	ra,80001e44 <wakeup>
  release(&pi->lock);
    8000444a:	8526                	mv	a0,s1
    8000444c:	fe6fc0ef          	jal	ra,80000c32 <release>
  return i;
}
    80004450:	854e                	mv	a0,s3
    80004452:	60a6                	ld	ra,72(sp)
    80004454:	6406                	ld	s0,64(sp)
    80004456:	74e2                	ld	s1,56(sp)
    80004458:	7942                	ld	s2,48(sp)
    8000445a:	79a2                	ld	s3,40(sp)
    8000445c:	7a02                	ld	s4,32(sp)
    8000445e:	6ae2                	ld	s5,24(sp)
    80004460:	6b42                	ld	s6,16(sp)
    80004462:	6161                	addi	sp,sp,80
    80004464:	8082                	ret
      release(&pi->lock);
    80004466:	8526                	mv	a0,s1
    80004468:	fcafc0ef          	jal	ra,80000c32 <release>
      return -1;
    8000446c:	59fd                	li	s3,-1
    8000446e:	b7cd                	j	80004450 <piperead+0xac>

0000000080004470 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004470:	1141                	addi	sp,sp,-16
    80004472:	e422                	sd	s0,8(sp)
    80004474:	0800                	addi	s0,sp,16
    80004476:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004478:	8905                	andi	a0,a0,1
    8000447a:	c111                	beqz	a0,8000447e <flags2perm+0xe>
      perm = PTE_X;
    8000447c:	4521                	li	a0,8
    if(flags & 0x2)
    8000447e:	8b89                	andi	a5,a5,2
    80004480:	c399                	beqz	a5,80004486 <flags2perm+0x16>
      perm |= PTE_W;
    80004482:	00456513          	ori	a0,a0,4
    return perm;
}
    80004486:	6422                	ld	s0,8(sp)
    80004488:	0141                	addi	sp,sp,16
    8000448a:	8082                	ret

000000008000448c <exec>:

int
exec(char *path, char **argv)
{
    8000448c:	de010113          	addi	sp,sp,-544
    80004490:	20113c23          	sd	ra,536(sp)
    80004494:	20813823          	sd	s0,528(sp)
    80004498:	20913423          	sd	s1,520(sp)
    8000449c:	21213023          	sd	s2,512(sp)
    800044a0:	ffce                	sd	s3,504(sp)
    800044a2:	fbd2                	sd	s4,496(sp)
    800044a4:	f7d6                	sd	s5,488(sp)
    800044a6:	f3da                	sd	s6,480(sp)
    800044a8:	efde                	sd	s7,472(sp)
    800044aa:	ebe2                	sd	s8,464(sp)
    800044ac:	e7e6                	sd	s9,456(sp)
    800044ae:	e3ea                	sd	s10,448(sp)
    800044b0:	ff6e                	sd	s11,440(sp)
    800044b2:	1400                	addi	s0,sp,544
    800044b4:	892a                	mv	s2,a0
    800044b6:	dea43423          	sd	a0,-536(s0)
    800044ba:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800044be:	b6efd0ef          	jal	ra,8000182c <myproc>
    800044c2:	84aa                	mv	s1,a0

  begin_op();
    800044c4:	e08ff0ef          	jal	ra,80003acc <begin_op>

  if((ip = namei(path)) == 0){
    800044c8:	854a                	mv	a0,s2
    800044ca:	c2aff0ef          	jal	ra,800038f4 <namei>
    800044ce:	c13d                	beqz	a0,80004534 <exec+0xa8>
    800044d0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044d2:	d6ffe0ef          	jal	ra,80003240 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044d6:	04000713          	li	a4,64
    800044da:	4681                	li	a3,0
    800044dc:	e5040613          	addi	a2,s0,-432
    800044e0:	4581                	li	a1,0
    800044e2:	8556                	mv	a0,s5
    800044e4:	fadfe0ef          	jal	ra,80003490 <readi>
    800044e8:	04000793          	li	a5,64
    800044ec:	00f51a63          	bne	a0,a5,80004500 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800044f0:	e5042703          	lw	a4,-432(s0)
    800044f4:	464c47b7          	lui	a5,0x464c4
    800044f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044fc:	04f70063          	beq	a4,a5,8000453c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004500:	8556                	mv	a0,s5
    80004502:	f45fe0ef          	jal	ra,80003446 <iunlockput>
    end_op();
    80004506:	e36ff0ef          	jal	ra,80003b3c <end_op>
  }
  return -1;
    8000450a:	557d                	li	a0,-1
}
    8000450c:	21813083          	ld	ra,536(sp)
    80004510:	21013403          	ld	s0,528(sp)
    80004514:	20813483          	ld	s1,520(sp)
    80004518:	20013903          	ld	s2,512(sp)
    8000451c:	79fe                	ld	s3,504(sp)
    8000451e:	7a5e                	ld	s4,496(sp)
    80004520:	7abe                	ld	s5,488(sp)
    80004522:	7b1e                	ld	s6,480(sp)
    80004524:	6bfe                	ld	s7,472(sp)
    80004526:	6c5e                	ld	s8,464(sp)
    80004528:	6cbe                	ld	s9,456(sp)
    8000452a:	6d1e                	ld	s10,448(sp)
    8000452c:	7dfa                	ld	s11,440(sp)
    8000452e:	22010113          	addi	sp,sp,544
    80004532:	8082                	ret
    end_op();
    80004534:	e08ff0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004538:	557d                	li	a0,-1
    8000453a:	bfc9                	j	8000450c <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    8000453c:	8526                	mv	a0,s1
    8000453e:	b96fd0ef          	jal	ra,800018d4 <proc_pagetable>
    80004542:	8b2a                	mv	s6,a0
    80004544:	dd55                	beqz	a0,80004500 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004546:	e7042783          	lw	a5,-400(s0)
    8000454a:	e8845703          	lhu	a4,-376(s0)
    8000454e:	c325                	beqz	a4,800045ae <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004550:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004552:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004556:	6a05                	lui	s4,0x1
    80004558:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000455c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004560:	6d85                	lui	s11,0x1
    80004562:	7d7d                	lui	s10,0xfffff
    80004564:	a411                	j	80004768 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004566:	00003517          	auipc	a0,0x3
    8000456a:	1ca50513          	addi	a0,a0,458 # 80007730 <syscalls+0x2a0>
    8000456e:	9e8fc0ef          	jal	ra,80000756 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004572:	874a                	mv	a4,s2
    80004574:	009c86bb          	addw	a3,s9,s1
    80004578:	4581                	li	a1,0
    8000457a:	8556                	mv	a0,s5
    8000457c:	f15fe0ef          	jal	ra,80003490 <readi>
    80004580:	2501                	sext.w	a0,a0
    80004582:	18a91263          	bne	s2,a0,80004706 <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    80004586:	009d84bb          	addw	s1,s11,s1
    8000458a:	013d09bb          	addw	s3,s10,s3
    8000458e:	1b74fd63          	bgeu	s1,s7,80004748 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    80004592:	02049593          	slli	a1,s1,0x20
    80004596:	9181                	srli	a1,a1,0x20
    80004598:	95e2                	add	a1,a1,s8
    8000459a:	855a                	mv	a0,s6
    8000459c:	9e9fc0ef          	jal	ra,80000f84 <walkaddr>
    800045a0:	862a                	mv	a2,a0
    if(pa == 0)
    800045a2:	d171                	beqz	a0,80004566 <exec+0xda>
      n = PGSIZE;
    800045a4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800045a6:	fd49f6e3          	bgeu	s3,s4,80004572 <exec+0xe6>
      n = sz - i;
    800045aa:	894e                	mv	s2,s3
    800045ac:	b7d9                	j	80004572 <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045ae:	4901                	li	s2,0
  iunlockput(ip);
    800045b0:	8556                	mv	a0,s5
    800045b2:	e95fe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    800045b6:	d86ff0ef          	jal	ra,80003b3c <end_op>
  p = myproc();
    800045ba:	a72fd0ef          	jal	ra,8000182c <myproc>
    800045be:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800045c0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800045c4:	6785                	lui	a5,0x1
    800045c6:	17fd                	addi	a5,a5,-1
    800045c8:	993e                	add	s2,s2,a5
    800045ca:	77fd                	lui	a5,0xfffff
    800045cc:	00f977b3          	and	a5,s2,a5
    800045d0:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800045d4:	4691                	li	a3,4
    800045d6:	6609                	lui	a2,0x2
    800045d8:	963e                	add	a2,a2,a5
    800045da:	85be                	mv	a1,a5
    800045dc:	855a                	mv	a0,s6
    800045de:	cfffc0ef          	jal	ra,800012dc <uvmalloc>
    800045e2:	8c2a                	mv	s8,a0
  ip = 0;
    800045e4:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800045e6:	12050063          	beqz	a0,80004706 <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800045ea:	75f9                	lui	a1,0xffffe
    800045ec:	95aa                	add	a1,a1,a0
    800045ee:	855a                	mv	a0,s6
    800045f0:	ec7fc0ef          	jal	ra,800014b6 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800045f4:	7afd                	lui	s5,0xfffff
    800045f6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800045f8:	df043783          	ld	a5,-528(s0)
    800045fc:	6388                	ld	a0,0(a5)
    800045fe:	c135                	beqz	a0,80004662 <exec+0x1d6>
    80004600:	e9040993          	addi	s3,s0,-368
    80004604:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004608:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000460a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000460c:	fdafc0ef          	jal	ra,80000de6 <strlen>
    80004610:	0015079b          	addiw	a5,a0,1
    80004614:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004618:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000461c:	11596a63          	bltu	s2,s5,80004730 <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004620:	df043d83          	ld	s11,-528(s0)
    80004624:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004628:	8552                	mv	a0,s4
    8000462a:	fbcfc0ef          	jal	ra,80000de6 <strlen>
    8000462e:	0015069b          	addiw	a3,a0,1
    80004632:	8652                	mv	a2,s4
    80004634:	85ca                	mv	a1,s2
    80004636:	855a                	mv	a0,s6
    80004638:	ea9fc0ef          	jal	ra,800014e0 <copyout>
    8000463c:	0e054e63          	bltz	a0,80004738 <exec+0x2ac>
    ustack[argc] = sp;
    80004640:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004644:	0485                	addi	s1,s1,1
    80004646:	008d8793          	addi	a5,s11,8
    8000464a:	def43823          	sd	a5,-528(s0)
    8000464e:	008db503          	ld	a0,8(s11)
    80004652:	c911                	beqz	a0,80004666 <exec+0x1da>
    if(argc >= MAXARG)
    80004654:	09a1                	addi	s3,s3,8
    80004656:	fb3c9be3          	bne	s9,s3,8000460c <exec+0x180>
  sz = sz1;
    8000465a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000465e:	4a81                	li	s5,0
    80004660:	a05d                	j	80004706 <exec+0x27a>
  sp = sz;
    80004662:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004664:	4481                	li	s1,0
  ustack[argc] = 0;
    80004666:	00349793          	slli	a5,s1,0x3
    8000466a:	f9040713          	addi	a4,s0,-112
    8000466e:	97ba                	add	a5,a5,a4
    80004670:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8618>
  sp -= (argc+1) * sizeof(uint64);
    80004674:	00148693          	addi	a3,s1,1
    80004678:	068e                	slli	a3,a3,0x3
    8000467a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000467e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004682:	01597663          	bgeu	s2,s5,8000468e <exec+0x202>
  sz = sz1;
    80004686:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000468a:	4a81                	li	s5,0
    8000468c:	a8ad                	j	80004706 <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000468e:	e9040613          	addi	a2,s0,-368
    80004692:	85ca                	mv	a1,s2
    80004694:	855a                	mv	a0,s6
    80004696:	e4bfc0ef          	jal	ra,800014e0 <copyout>
    8000469a:	0a054363          	bltz	a0,80004740 <exec+0x2b4>
  p->trapframe->a1 = sp;
    8000469e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800046a2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800046a6:	de843783          	ld	a5,-536(s0)
    800046aa:	0007c703          	lbu	a4,0(a5)
    800046ae:	cf11                	beqz	a4,800046ca <exec+0x23e>
    800046b0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800046b2:	02f00693          	li	a3,47
    800046b6:	a039                	j	800046c4 <exec+0x238>
      last = s+1;
    800046b8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800046bc:	0785                	addi	a5,a5,1
    800046be:	fff7c703          	lbu	a4,-1(a5)
    800046c2:	c701                	beqz	a4,800046ca <exec+0x23e>
    if(*s == '/')
    800046c4:	fed71ce3          	bne	a4,a3,800046bc <exec+0x230>
    800046c8:	bfc5                	j	800046b8 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    800046ca:	4641                	li	a2,16
    800046cc:	de843583          	ld	a1,-536(s0)
    800046d0:	158b8513          	addi	a0,s7,344
    800046d4:	ee0fc0ef          	jal	ra,80000db4 <safestrcpy>
  oldpagetable = p->pagetable;
    800046d8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800046dc:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800046e0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046e4:	058bb783          	ld	a5,88(s7)
    800046e8:	e6843703          	ld	a4,-408(s0)
    800046ec:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046ee:	058bb783          	ld	a5,88(s7)
    800046f2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046f6:	85ea                	mv	a1,s10
    800046f8:	a60fd0ef          	jal	ra,80001958 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046fc:	0004851b          	sext.w	a0,s1
    80004700:	b531                	j	8000450c <exec+0x80>
    80004702:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004706:	df843583          	ld	a1,-520(s0)
    8000470a:	855a                	mv	a0,s6
    8000470c:	a4cfd0ef          	jal	ra,80001958 <proc_freepagetable>
  if(ip){
    80004710:	de0a98e3          	bnez	s5,80004500 <exec+0x74>
  return -1;
    80004714:	557d                	li	a0,-1
    80004716:	bbdd                	j	8000450c <exec+0x80>
    80004718:	df243c23          	sd	s2,-520(s0)
    8000471c:	b7ed                	j	80004706 <exec+0x27a>
    8000471e:	df243c23          	sd	s2,-520(s0)
    80004722:	b7d5                	j	80004706 <exec+0x27a>
    80004724:	df243c23          	sd	s2,-520(s0)
    80004728:	bff9                	j	80004706 <exec+0x27a>
    8000472a:	df243c23          	sd	s2,-520(s0)
    8000472e:	bfe1                	j	80004706 <exec+0x27a>
  sz = sz1;
    80004730:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004734:	4a81                	li	s5,0
    80004736:	bfc1                	j	80004706 <exec+0x27a>
  sz = sz1;
    80004738:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000473c:	4a81                	li	s5,0
    8000473e:	b7e1                	j	80004706 <exec+0x27a>
  sz = sz1;
    80004740:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004744:	4a81                	li	s5,0
    80004746:	b7c1                	j	80004706 <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004748:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000474c:	e0843783          	ld	a5,-504(s0)
    80004750:	0017869b          	addiw	a3,a5,1
    80004754:	e0d43423          	sd	a3,-504(s0)
    80004758:	e0043783          	ld	a5,-512(s0)
    8000475c:	0387879b          	addiw	a5,a5,56
    80004760:	e8845703          	lhu	a4,-376(s0)
    80004764:	e4e6d6e3          	bge	a3,a4,800045b0 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004768:	2781                	sext.w	a5,a5
    8000476a:	e0f43023          	sd	a5,-512(s0)
    8000476e:	03800713          	li	a4,56
    80004772:	86be                	mv	a3,a5
    80004774:	e1840613          	addi	a2,s0,-488
    80004778:	4581                	li	a1,0
    8000477a:	8556                	mv	a0,s5
    8000477c:	d15fe0ef          	jal	ra,80003490 <readi>
    80004780:	03800793          	li	a5,56
    80004784:	f6f51fe3          	bne	a0,a5,80004702 <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    80004788:	e1842783          	lw	a5,-488(s0)
    8000478c:	4705                	li	a4,1
    8000478e:	fae79fe3          	bne	a5,a4,8000474c <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    80004792:	e4043483          	ld	s1,-448(s0)
    80004796:	e3843783          	ld	a5,-456(s0)
    8000479a:	f6f4efe3          	bltu	s1,a5,80004718 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000479e:	e2843783          	ld	a5,-472(s0)
    800047a2:	94be                	add	s1,s1,a5
    800047a4:	f6f4ede3          	bltu	s1,a5,8000471e <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    800047a8:	de043703          	ld	a4,-544(s0)
    800047ac:	8ff9                	and	a5,a5,a4
    800047ae:	fbbd                	bnez	a5,80004724 <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047b0:	e1c42503          	lw	a0,-484(s0)
    800047b4:	cbdff0ef          	jal	ra,80004470 <flags2perm>
    800047b8:	86aa                	mv	a3,a0
    800047ba:	8626                	mv	a2,s1
    800047bc:	85ca                	mv	a1,s2
    800047be:	855a                	mv	a0,s6
    800047c0:	b1dfc0ef          	jal	ra,800012dc <uvmalloc>
    800047c4:	dea43c23          	sd	a0,-520(s0)
    800047c8:	d12d                	beqz	a0,8000472a <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047ca:	e2843c03          	ld	s8,-472(s0)
    800047ce:	e2042c83          	lw	s9,-480(s0)
    800047d2:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047d6:	f60b89e3          	beqz	s7,80004748 <exec+0x2bc>
    800047da:	89de                	mv	s3,s7
    800047dc:	4481                	li	s1,0
    800047de:	bb55                	j	80004592 <exec+0x106>

00000000800047e0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	ec26                	sd	s1,24(sp)
    800047e8:	e84a                	sd	s2,16(sp)
    800047ea:	1800                	addi	s0,sp,48
    800047ec:	892e                	mv	s2,a1
    800047ee:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800047f0:	fdc40593          	addi	a1,s0,-36
    800047f4:	fc3fd0ef          	jal	ra,800027b6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047f8:	fdc42703          	lw	a4,-36(s0)
    800047fc:	47bd                	li	a5,15
    800047fe:	02e7e963          	bltu	a5,a4,80004830 <argfd+0x50>
    80004802:	82afd0ef          	jal	ra,8000182c <myproc>
    80004806:	fdc42703          	lw	a4,-36(s0)
    8000480a:	01a70793          	addi	a5,a4,26
    8000480e:	078e                	slli	a5,a5,0x3
    80004810:	953e                	add	a0,a0,a5
    80004812:	611c                	ld	a5,0(a0)
    80004814:	c385                	beqz	a5,80004834 <argfd+0x54>
    return -1;
  if(pfd)
    80004816:	00090463          	beqz	s2,8000481e <argfd+0x3e>
    *pfd = fd;
    8000481a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000481e:	4501                	li	a0,0
  if(pf)
    80004820:	c091                	beqz	s1,80004824 <argfd+0x44>
    *pf = f;
    80004822:	e09c                	sd	a5,0(s1)
}
    80004824:	70a2                	ld	ra,40(sp)
    80004826:	7402                	ld	s0,32(sp)
    80004828:	64e2                	ld	s1,24(sp)
    8000482a:	6942                	ld	s2,16(sp)
    8000482c:	6145                	addi	sp,sp,48
    8000482e:	8082                	ret
    return -1;
    80004830:	557d                	li	a0,-1
    80004832:	bfcd                	j	80004824 <argfd+0x44>
    80004834:	557d                	li	a0,-1
    80004836:	b7fd                	j	80004824 <argfd+0x44>

0000000080004838 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	e426                	sd	s1,8(sp)
    80004840:	1000                	addi	s0,sp,32
    80004842:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004844:	fe9fc0ef          	jal	ra,8000182c <myproc>
    80004848:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000484a:	0d050793          	addi	a5,a0,208
    8000484e:	4501                	li	a0,0
    80004850:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004852:	6398                	ld	a4,0(a5)
    80004854:	cb19                	beqz	a4,8000486a <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004856:	2505                	addiw	a0,a0,1
    80004858:	07a1                	addi	a5,a5,8
    8000485a:	fed51ce3          	bne	a0,a3,80004852 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000485e:	557d                	li	a0,-1
}
    80004860:	60e2                	ld	ra,24(sp)
    80004862:	6442                	ld	s0,16(sp)
    80004864:	64a2                	ld	s1,8(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret
      p->ofile[fd] = f;
    8000486a:	01a50793          	addi	a5,a0,26
    8000486e:	078e                	slli	a5,a5,0x3
    80004870:	963e                	add	a2,a2,a5
    80004872:	e204                	sd	s1,0(a2)
      return fd;
    80004874:	b7f5                	j	80004860 <fdalloc+0x28>

0000000080004876 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004876:	715d                	addi	sp,sp,-80
    80004878:	e486                	sd	ra,72(sp)
    8000487a:	e0a2                	sd	s0,64(sp)
    8000487c:	fc26                	sd	s1,56(sp)
    8000487e:	f84a                	sd	s2,48(sp)
    80004880:	f44e                	sd	s3,40(sp)
    80004882:	f052                	sd	s4,32(sp)
    80004884:	ec56                	sd	s5,24(sp)
    80004886:	e85a                	sd	s6,16(sp)
    80004888:	0880                	addi	s0,sp,80
    8000488a:	8b2e                	mv	s6,a1
    8000488c:	89b2                	mv	s3,a2
    8000488e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004890:	fb040593          	addi	a1,s0,-80
    80004894:	87aff0ef          	jal	ra,8000390e <nameiparent>
    80004898:	84aa                	mv	s1,a0
    8000489a:	10050b63          	beqz	a0,800049b0 <create+0x13a>
    return 0;

  ilock(dp);
    8000489e:	9a3fe0ef          	jal	ra,80003240 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048a2:	4601                	li	a2,0
    800048a4:	fb040593          	addi	a1,s0,-80
    800048a8:	8526                	mv	a0,s1
    800048aa:	de5fe0ef          	jal	ra,8000368e <dirlookup>
    800048ae:	8aaa                	mv	s5,a0
    800048b0:	c521                	beqz	a0,800048f8 <create+0x82>
    iunlockput(dp);
    800048b2:	8526                	mv	a0,s1
    800048b4:	b93fe0ef          	jal	ra,80003446 <iunlockput>
    ilock(ip);
    800048b8:	8556                	mv	a0,s5
    800048ba:	987fe0ef          	jal	ra,80003240 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048be:	000b059b          	sext.w	a1,s6
    800048c2:	4789                	li	a5,2
    800048c4:	02f59563          	bne	a1,a5,800048ee <create+0x78>
    800048c8:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd875c>
    800048cc:	37f9                	addiw	a5,a5,-2
    800048ce:	17c2                	slli	a5,a5,0x30
    800048d0:	93c1                	srli	a5,a5,0x30
    800048d2:	4705                	li	a4,1
    800048d4:	00f76d63          	bltu	a4,a5,800048ee <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048d8:	8556                	mv	a0,s5
    800048da:	60a6                	ld	ra,72(sp)
    800048dc:	6406                	ld	s0,64(sp)
    800048de:	74e2                	ld	s1,56(sp)
    800048e0:	7942                	ld	s2,48(sp)
    800048e2:	79a2                	ld	s3,40(sp)
    800048e4:	7a02                	ld	s4,32(sp)
    800048e6:	6ae2                	ld	s5,24(sp)
    800048e8:	6b42                	ld	s6,16(sp)
    800048ea:	6161                	addi	sp,sp,80
    800048ec:	8082                	ret
    iunlockput(ip);
    800048ee:	8556                	mv	a0,s5
    800048f0:	b57fe0ef          	jal	ra,80003446 <iunlockput>
    return 0;
    800048f4:	4a81                	li	s5,0
    800048f6:	b7cd                	j	800048d8 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    800048f8:	85da                	mv	a1,s6
    800048fa:	4088                	lw	a0,0(s1)
    800048fc:	fdcfe0ef          	jal	ra,800030d8 <ialloc>
    80004900:	8a2a                	mv	s4,a0
    80004902:	cd1d                	beqz	a0,80004940 <create+0xca>
  ilock(ip);
    80004904:	93dfe0ef          	jal	ra,80003240 <ilock>
  ip->major = major;
    80004908:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000490c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004910:	4905                	li	s2,1
    80004912:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004916:	8552                	mv	a0,s4
    80004918:	877fe0ef          	jal	ra,8000318e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000491c:	000b059b          	sext.w	a1,s6
    80004920:	03258563          	beq	a1,s2,8000494a <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80004924:	004a2603          	lw	a2,4(s4)
    80004928:	fb040593          	addi	a1,s0,-80
    8000492c:	8526                	mv	a0,s1
    8000492e:	f2dfe0ef          	jal	ra,8000385a <dirlink>
    80004932:	06054363          	bltz	a0,80004998 <create+0x122>
  iunlockput(dp);
    80004936:	8526                	mv	a0,s1
    80004938:	b0ffe0ef          	jal	ra,80003446 <iunlockput>
  return ip;
    8000493c:	8ad2                	mv	s5,s4
    8000493e:	bf69                	j	800048d8 <create+0x62>
    iunlockput(dp);
    80004940:	8526                	mv	a0,s1
    80004942:	b05fe0ef          	jal	ra,80003446 <iunlockput>
    return 0;
    80004946:	8ad2                	mv	s5,s4
    80004948:	bf41                	j	800048d8 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000494a:	004a2603          	lw	a2,4(s4)
    8000494e:	00003597          	auipc	a1,0x3
    80004952:	e0258593          	addi	a1,a1,-510 # 80007750 <syscalls+0x2c0>
    80004956:	8552                	mv	a0,s4
    80004958:	f03fe0ef          	jal	ra,8000385a <dirlink>
    8000495c:	02054e63          	bltz	a0,80004998 <create+0x122>
    80004960:	40d0                	lw	a2,4(s1)
    80004962:	00003597          	auipc	a1,0x3
    80004966:	df658593          	addi	a1,a1,-522 # 80007758 <syscalls+0x2c8>
    8000496a:	8552                	mv	a0,s4
    8000496c:	eeffe0ef          	jal	ra,8000385a <dirlink>
    80004970:	02054463          	bltz	a0,80004998 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80004974:	004a2603          	lw	a2,4(s4)
    80004978:	fb040593          	addi	a1,s0,-80
    8000497c:	8526                	mv	a0,s1
    8000497e:	eddfe0ef          	jal	ra,8000385a <dirlink>
    80004982:	00054b63          	bltz	a0,80004998 <create+0x122>
    dp->nlink++;  // for ".."
    80004986:	04a4d783          	lhu	a5,74(s1)
    8000498a:	2785                	addiw	a5,a5,1
    8000498c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004990:	8526                	mv	a0,s1
    80004992:	ffcfe0ef          	jal	ra,8000318e <iupdate>
    80004996:	b745                	j	80004936 <create+0xc0>
  ip->nlink = 0;
    80004998:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000499c:	8552                	mv	a0,s4
    8000499e:	ff0fe0ef          	jal	ra,8000318e <iupdate>
  iunlockput(ip);
    800049a2:	8552                	mv	a0,s4
    800049a4:	aa3fe0ef          	jal	ra,80003446 <iunlockput>
  iunlockput(dp);
    800049a8:	8526                	mv	a0,s1
    800049aa:	a9dfe0ef          	jal	ra,80003446 <iunlockput>
  return 0;
    800049ae:	b72d                	j	800048d8 <create+0x62>
    return 0;
    800049b0:	8aaa                	mv	s5,a0
    800049b2:	b71d                	j	800048d8 <create+0x62>

00000000800049b4 <sys_dup>:
{
    800049b4:	7179                	addi	sp,sp,-48
    800049b6:	f406                	sd	ra,40(sp)
    800049b8:	f022                	sd	s0,32(sp)
    800049ba:	ec26                	sd	s1,24(sp)
    800049bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049be:	fd840613          	addi	a2,s0,-40
    800049c2:	4581                	li	a1,0
    800049c4:	4501                	li	a0,0
    800049c6:	e1bff0ef          	jal	ra,800047e0 <argfd>
    return -1;
    800049ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049cc:	00054f63          	bltz	a0,800049ea <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    800049d0:	fd843503          	ld	a0,-40(s0)
    800049d4:	e65ff0ef          	jal	ra,80004838 <fdalloc>
    800049d8:	84aa                	mv	s1,a0
    return -1;
    800049da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049dc:	00054763          	bltz	a0,800049ea <sys_dup+0x36>
  filedup(f);
    800049e0:	fd843503          	ld	a0,-40(s0)
    800049e4:	cbeff0ef          	jal	ra,80003ea2 <filedup>
  return fd;
    800049e8:	87a6                	mv	a5,s1
}
    800049ea:	853e                	mv	a0,a5
    800049ec:	70a2                	ld	ra,40(sp)
    800049ee:	7402                	ld	s0,32(sp)
    800049f0:	64e2                	ld	s1,24(sp)
    800049f2:	6145                	addi	sp,sp,48
    800049f4:	8082                	ret

00000000800049f6 <sys_read>:
{
    800049f6:	7179                	addi	sp,sp,-48
    800049f8:	f406                	sd	ra,40(sp)
    800049fa:	f022                	sd	s0,32(sp)
    800049fc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049fe:	fd840593          	addi	a1,s0,-40
    80004a02:	4505                	li	a0,1
    80004a04:	dcffd0ef          	jal	ra,800027d2 <argaddr>
  argint(2, &n);
    80004a08:	fe440593          	addi	a1,s0,-28
    80004a0c:	4509                	li	a0,2
    80004a0e:	da9fd0ef          	jal	ra,800027b6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a12:	fe840613          	addi	a2,s0,-24
    80004a16:	4581                	li	a1,0
    80004a18:	4501                	li	a0,0
    80004a1a:	dc7ff0ef          	jal	ra,800047e0 <argfd>
    80004a1e:	87aa                	mv	a5,a0
    return -1;
    80004a20:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a22:	0007ca63          	bltz	a5,80004a36 <sys_read+0x40>
  return fileread(f, p, n);
    80004a26:	fe442603          	lw	a2,-28(s0)
    80004a2a:	fd843583          	ld	a1,-40(s0)
    80004a2e:	fe843503          	ld	a0,-24(s0)
    80004a32:	dbeff0ef          	jal	ra,80003ff0 <fileread>
}
    80004a36:	70a2                	ld	ra,40(sp)
    80004a38:	7402                	ld	s0,32(sp)
    80004a3a:	6145                	addi	sp,sp,48
    80004a3c:	8082                	ret

0000000080004a3e <sys_write>:
{
    80004a3e:	7179                	addi	sp,sp,-48
    80004a40:	f406                	sd	ra,40(sp)
    80004a42:	f022                	sd	s0,32(sp)
    80004a44:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a46:	fd840593          	addi	a1,s0,-40
    80004a4a:	4505                	li	a0,1
    80004a4c:	d87fd0ef          	jal	ra,800027d2 <argaddr>
  argint(2, &n);
    80004a50:	fe440593          	addi	a1,s0,-28
    80004a54:	4509                	li	a0,2
    80004a56:	d61fd0ef          	jal	ra,800027b6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a5a:	fe840613          	addi	a2,s0,-24
    80004a5e:	4581                	li	a1,0
    80004a60:	4501                	li	a0,0
    80004a62:	d7fff0ef          	jal	ra,800047e0 <argfd>
    80004a66:	87aa                	mv	a5,a0
    return -1;
    80004a68:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a6a:	0007ca63          	bltz	a5,80004a7e <sys_write+0x40>
  return filewrite(f, p, n);
    80004a6e:	fe442603          	lw	a2,-28(s0)
    80004a72:	fd843583          	ld	a1,-40(s0)
    80004a76:	fe843503          	ld	a0,-24(s0)
    80004a7a:	e24ff0ef          	jal	ra,8000409e <filewrite>
}
    80004a7e:	70a2                	ld	ra,40(sp)
    80004a80:	7402                	ld	s0,32(sp)
    80004a82:	6145                	addi	sp,sp,48
    80004a84:	8082                	ret

0000000080004a86 <sys_close>:
{
    80004a86:	1101                	addi	sp,sp,-32
    80004a88:	ec06                	sd	ra,24(sp)
    80004a8a:	e822                	sd	s0,16(sp)
    80004a8c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a8e:	fe040613          	addi	a2,s0,-32
    80004a92:	fec40593          	addi	a1,s0,-20
    80004a96:	4501                	li	a0,0
    80004a98:	d49ff0ef          	jal	ra,800047e0 <argfd>
    return -1;
    80004a9c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a9e:	02054063          	bltz	a0,80004abe <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004aa2:	d8bfc0ef          	jal	ra,8000182c <myproc>
    80004aa6:	fec42783          	lw	a5,-20(s0)
    80004aaa:	07e9                	addi	a5,a5,26
    80004aac:	078e                	slli	a5,a5,0x3
    80004aae:	97aa                	add	a5,a5,a0
    80004ab0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004ab4:	fe043503          	ld	a0,-32(s0)
    80004ab8:	c30ff0ef          	jal	ra,80003ee8 <fileclose>
  return 0;
    80004abc:	4781                	li	a5,0
}
    80004abe:	853e                	mv	a0,a5
    80004ac0:	60e2                	ld	ra,24(sp)
    80004ac2:	6442                	ld	s0,16(sp)
    80004ac4:	6105                	addi	sp,sp,32
    80004ac6:	8082                	ret

0000000080004ac8 <sys_fstat>:
{
    80004ac8:	1101                	addi	sp,sp,-32
    80004aca:	ec06                	sd	ra,24(sp)
    80004acc:	e822                	sd	s0,16(sp)
    80004ace:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ad0:	fe040593          	addi	a1,s0,-32
    80004ad4:	4505                	li	a0,1
    80004ad6:	cfdfd0ef          	jal	ra,800027d2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004ada:	fe840613          	addi	a2,s0,-24
    80004ade:	4581                	li	a1,0
    80004ae0:	4501                	li	a0,0
    80004ae2:	cffff0ef          	jal	ra,800047e0 <argfd>
    80004ae6:	87aa                	mv	a5,a0
    return -1;
    80004ae8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004aea:	0007c863          	bltz	a5,80004afa <sys_fstat+0x32>
  return filestat(f, st);
    80004aee:	fe043583          	ld	a1,-32(s0)
    80004af2:	fe843503          	ld	a0,-24(s0)
    80004af6:	c9aff0ef          	jal	ra,80003f90 <filestat>
}
    80004afa:	60e2                	ld	ra,24(sp)
    80004afc:	6442                	ld	s0,16(sp)
    80004afe:	6105                	addi	sp,sp,32
    80004b00:	8082                	ret

0000000080004b02 <sys_link>:
{
    80004b02:	7169                	addi	sp,sp,-304
    80004b04:	f606                	sd	ra,296(sp)
    80004b06:	f222                	sd	s0,288(sp)
    80004b08:	ee26                	sd	s1,280(sp)
    80004b0a:	ea4a                	sd	s2,272(sp)
    80004b0c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b0e:	08000613          	li	a2,128
    80004b12:	ed040593          	addi	a1,s0,-304
    80004b16:	4501                	li	a0,0
    80004b18:	cd7fd0ef          	jal	ra,800027ee <argstr>
    return -1;
    80004b1c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b1e:	0c054663          	bltz	a0,80004bea <sys_link+0xe8>
    80004b22:	08000613          	li	a2,128
    80004b26:	f5040593          	addi	a1,s0,-176
    80004b2a:	4505                	li	a0,1
    80004b2c:	cc3fd0ef          	jal	ra,800027ee <argstr>
    return -1;
    80004b30:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b32:	0a054c63          	bltz	a0,80004bea <sys_link+0xe8>
  begin_op();
    80004b36:	f97fe0ef          	jal	ra,80003acc <begin_op>
  if((ip = namei(old)) == 0){
    80004b3a:	ed040513          	addi	a0,s0,-304
    80004b3e:	db7fe0ef          	jal	ra,800038f4 <namei>
    80004b42:	84aa                	mv	s1,a0
    80004b44:	c525                	beqz	a0,80004bac <sys_link+0xaa>
  ilock(ip);
    80004b46:	efafe0ef          	jal	ra,80003240 <ilock>
  if(ip->type == T_DIR){
    80004b4a:	04449703          	lh	a4,68(s1)
    80004b4e:	4785                	li	a5,1
    80004b50:	06f70263          	beq	a4,a5,80004bb4 <sys_link+0xb2>
  ip->nlink++;
    80004b54:	04a4d783          	lhu	a5,74(s1)
    80004b58:	2785                	addiw	a5,a5,1
    80004b5a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	e2efe0ef          	jal	ra,8000318e <iupdate>
  iunlock(ip);
    80004b64:	8526                	mv	a0,s1
    80004b66:	f84fe0ef          	jal	ra,800032ea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b6a:	fd040593          	addi	a1,s0,-48
    80004b6e:	f5040513          	addi	a0,s0,-176
    80004b72:	d9dfe0ef          	jal	ra,8000390e <nameiparent>
    80004b76:	892a                	mv	s2,a0
    80004b78:	c921                	beqz	a0,80004bc8 <sys_link+0xc6>
  ilock(dp);
    80004b7a:	ec6fe0ef          	jal	ra,80003240 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b7e:	00092703          	lw	a4,0(s2)
    80004b82:	409c                	lw	a5,0(s1)
    80004b84:	02f71f63          	bne	a4,a5,80004bc2 <sys_link+0xc0>
    80004b88:	40d0                	lw	a2,4(s1)
    80004b8a:	fd040593          	addi	a1,s0,-48
    80004b8e:	854a                	mv	a0,s2
    80004b90:	ccbfe0ef          	jal	ra,8000385a <dirlink>
    80004b94:	02054763          	bltz	a0,80004bc2 <sys_link+0xc0>
  iunlockput(dp);
    80004b98:	854a                	mv	a0,s2
    80004b9a:	8adfe0ef          	jal	ra,80003446 <iunlockput>
  iput(ip);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	81ffe0ef          	jal	ra,800033be <iput>
  end_op();
    80004ba4:	f99fe0ef          	jal	ra,80003b3c <end_op>
  return 0;
    80004ba8:	4781                	li	a5,0
    80004baa:	a081                	j	80004bea <sys_link+0xe8>
    end_op();
    80004bac:	f91fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004bb0:	57fd                	li	a5,-1
    80004bb2:	a825                	j	80004bea <sys_link+0xe8>
    iunlockput(ip);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	891fe0ef          	jal	ra,80003446 <iunlockput>
    end_op();
    80004bba:	f83fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004bbe:	57fd                	li	a5,-1
    80004bc0:	a02d                	j	80004bea <sys_link+0xe8>
    iunlockput(dp);
    80004bc2:	854a                	mv	a0,s2
    80004bc4:	883fe0ef          	jal	ra,80003446 <iunlockput>
  ilock(ip);
    80004bc8:	8526                	mv	a0,s1
    80004bca:	e76fe0ef          	jal	ra,80003240 <ilock>
  ip->nlink--;
    80004bce:	04a4d783          	lhu	a5,74(s1)
    80004bd2:	37fd                	addiw	a5,a5,-1
    80004bd4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	db4fe0ef          	jal	ra,8000318e <iupdate>
  iunlockput(ip);
    80004bde:	8526                	mv	a0,s1
    80004be0:	867fe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    80004be4:	f59fe0ef          	jal	ra,80003b3c <end_op>
  return -1;
    80004be8:	57fd                	li	a5,-1
}
    80004bea:	853e                	mv	a0,a5
    80004bec:	70b2                	ld	ra,296(sp)
    80004bee:	7412                	ld	s0,288(sp)
    80004bf0:	64f2                	ld	s1,280(sp)
    80004bf2:	6952                	ld	s2,272(sp)
    80004bf4:	6155                	addi	sp,sp,304
    80004bf6:	8082                	ret

0000000080004bf8 <sys_unlink>:
{
    80004bf8:	7151                	addi	sp,sp,-240
    80004bfa:	f586                	sd	ra,232(sp)
    80004bfc:	f1a2                	sd	s0,224(sp)
    80004bfe:	eda6                	sd	s1,216(sp)
    80004c00:	e9ca                	sd	s2,208(sp)
    80004c02:	e5ce                	sd	s3,200(sp)
    80004c04:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c06:	08000613          	li	a2,128
    80004c0a:	f3040593          	addi	a1,s0,-208
    80004c0e:	4501                	li	a0,0
    80004c10:	bdffd0ef          	jal	ra,800027ee <argstr>
    80004c14:	12054b63          	bltz	a0,80004d4a <sys_unlink+0x152>
  begin_op();
    80004c18:	eb5fe0ef          	jal	ra,80003acc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c1c:	fb040593          	addi	a1,s0,-80
    80004c20:	f3040513          	addi	a0,s0,-208
    80004c24:	cebfe0ef          	jal	ra,8000390e <nameiparent>
    80004c28:	84aa                	mv	s1,a0
    80004c2a:	c54d                	beqz	a0,80004cd4 <sys_unlink+0xdc>
  ilock(dp);
    80004c2c:	e14fe0ef          	jal	ra,80003240 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c30:	00003597          	auipc	a1,0x3
    80004c34:	b2058593          	addi	a1,a1,-1248 # 80007750 <syscalls+0x2c0>
    80004c38:	fb040513          	addi	a0,s0,-80
    80004c3c:	a3dfe0ef          	jal	ra,80003678 <namecmp>
    80004c40:	10050a63          	beqz	a0,80004d54 <sys_unlink+0x15c>
    80004c44:	00003597          	auipc	a1,0x3
    80004c48:	b1458593          	addi	a1,a1,-1260 # 80007758 <syscalls+0x2c8>
    80004c4c:	fb040513          	addi	a0,s0,-80
    80004c50:	a29fe0ef          	jal	ra,80003678 <namecmp>
    80004c54:	10050063          	beqz	a0,80004d54 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c58:	f2c40613          	addi	a2,s0,-212
    80004c5c:	fb040593          	addi	a1,s0,-80
    80004c60:	8526                	mv	a0,s1
    80004c62:	a2dfe0ef          	jal	ra,8000368e <dirlookup>
    80004c66:	892a                	mv	s2,a0
    80004c68:	0e050663          	beqz	a0,80004d54 <sys_unlink+0x15c>
  ilock(ip);
    80004c6c:	dd4fe0ef          	jal	ra,80003240 <ilock>
  if(ip->nlink < 1)
    80004c70:	04a91783          	lh	a5,74(s2)
    80004c74:	06f05463          	blez	a5,80004cdc <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c78:	04491703          	lh	a4,68(s2)
    80004c7c:	4785                	li	a5,1
    80004c7e:	06f70563          	beq	a4,a5,80004ce8 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004c82:	4641                	li	a2,16
    80004c84:	4581                	li	a1,0
    80004c86:	fc040513          	addi	a0,s0,-64
    80004c8a:	fe5fb0ef          	jal	ra,80000c6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c8e:	4741                	li	a4,16
    80004c90:	f2c42683          	lw	a3,-212(s0)
    80004c94:	fc040613          	addi	a2,s0,-64
    80004c98:	4581                	li	a1,0
    80004c9a:	8526                	mv	a0,s1
    80004c9c:	8d9fe0ef          	jal	ra,80003574 <writei>
    80004ca0:	47c1                	li	a5,16
    80004ca2:	08f51563          	bne	a0,a5,80004d2c <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004ca6:	04491703          	lh	a4,68(s2)
    80004caa:	4785                	li	a5,1
    80004cac:	08f70663          	beq	a4,a5,80004d38 <sys_unlink+0x140>
  iunlockput(dp);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	f94fe0ef          	jal	ra,80003446 <iunlockput>
  ip->nlink--;
    80004cb6:	04a95783          	lhu	a5,74(s2)
    80004cba:	37fd                	addiw	a5,a5,-1
    80004cbc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	cccfe0ef          	jal	ra,8000318e <iupdate>
  iunlockput(ip);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	f7efe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    80004ccc:	e71fe0ef          	jal	ra,80003b3c <end_op>
  return 0;
    80004cd0:	4501                	li	a0,0
    80004cd2:	a079                	j	80004d60 <sys_unlink+0x168>
    end_op();
    80004cd4:	e69fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004cd8:	557d                	li	a0,-1
    80004cda:	a059                	j	80004d60 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004cdc:	00003517          	auipc	a0,0x3
    80004ce0:	a8450513          	addi	a0,a0,-1404 # 80007760 <syscalls+0x2d0>
    80004ce4:	a73fb0ef          	jal	ra,80000756 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce8:	04c92703          	lw	a4,76(s2)
    80004cec:	02000793          	li	a5,32
    80004cf0:	f8e7f9e3          	bgeu	a5,a4,80004c82 <sys_unlink+0x8a>
    80004cf4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cf8:	4741                	li	a4,16
    80004cfa:	86ce                	mv	a3,s3
    80004cfc:	f1840613          	addi	a2,s0,-232
    80004d00:	4581                	li	a1,0
    80004d02:	854a                	mv	a0,s2
    80004d04:	f8cfe0ef          	jal	ra,80003490 <readi>
    80004d08:	47c1                	li	a5,16
    80004d0a:	00f51b63          	bne	a0,a5,80004d20 <sys_unlink+0x128>
    if(de.inum != 0)
    80004d0e:	f1845783          	lhu	a5,-232(s0)
    80004d12:	ef95                	bnez	a5,80004d4e <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d14:	29c1                	addiw	s3,s3,16
    80004d16:	04c92783          	lw	a5,76(s2)
    80004d1a:	fcf9efe3          	bltu	s3,a5,80004cf8 <sys_unlink+0x100>
    80004d1e:	b795                	j	80004c82 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004d20:	00003517          	auipc	a0,0x3
    80004d24:	a5850513          	addi	a0,a0,-1448 # 80007778 <syscalls+0x2e8>
    80004d28:	a2ffb0ef          	jal	ra,80000756 <panic>
    panic("unlink: writei");
    80004d2c:	00003517          	auipc	a0,0x3
    80004d30:	a6450513          	addi	a0,a0,-1436 # 80007790 <syscalls+0x300>
    80004d34:	a23fb0ef          	jal	ra,80000756 <panic>
    dp->nlink--;
    80004d38:	04a4d783          	lhu	a5,74(s1)
    80004d3c:	37fd                	addiw	a5,a5,-1
    80004d3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d42:	8526                	mv	a0,s1
    80004d44:	c4afe0ef          	jal	ra,8000318e <iupdate>
    80004d48:	b7a5                	j	80004cb0 <sys_unlink+0xb8>
    return -1;
    80004d4a:	557d                	li	a0,-1
    80004d4c:	a811                	j	80004d60 <sys_unlink+0x168>
    iunlockput(ip);
    80004d4e:	854a                	mv	a0,s2
    80004d50:	ef6fe0ef          	jal	ra,80003446 <iunlockput>
  iunlockput(dp);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ef0fe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    80004d5a:	de3fe0ef          	jal	ra,80003b3c <end_op>
  return -1;
    80004d5e:	557d                	li	a0,-1
}
    80004d60:	70ae                	ld	ra,232(sp)
    80004d62:	740e                	ld	s0,224(sp)
    80004d64:	64ee                	ld	s1,216(sp)
    80004d66:	694e                	ld	s2,208(sp)
    80004d68:	69ae                	ld	s3,200(sp)
    80004d6a:	616d                	addi	sp,sp,240
    80004d6c:	8082                	ret

0000000080004d6e <sys_open>:

uint64
sys_open(void)
{
    80004d6e:	7131                	addi	sp,sp,-192
    80004d70:	fd06                	sd	ra,184(sp)
    80004d72:	f922                	sd	s0,176(sp)
    80004d74:	f526                	sd	s1,168(sp)
    80004d76:	f14a                	sd	s2,160(sp)
    80004d78:	ed4e                	sd	s3,152(sp)
    80004d7a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d7c:	f4c40593          	addi	a1,s0,-180
    80004d80:	4505                	li	a0,1
    80004d82:	a35fd0ef          	jal	ra,800027b6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d86:	08000613          	li	a2,128
    80004d8a:	f5040593          	addi	a1,s0,-176
    80004d8e:	4501                	li	a0,0
    80004d90:	a5ffd0ef          	jal	ra,800027ee <argstr>
    80004d94:	87aa                	mv	a5,a0
    return -1;
    80004d96:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d98:	0807cd63          	bltz	a5,80004e32 <sys_open+0xc4>

  begin_op();
    80004d9c:	d31fe0ef          	jal	ra,80003acc <begin_op>

  if(omode & O_CREATE){
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	2007f793          	andi	a5,a5,512
    80004da8:	c3c5                	beqz	a5,80004e48 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004daa:	4681                	li	a3,0
    80004dac:	4601                	li	a2,0
    80004dae:	4589                	li	a1,2
    80004db0:	f5040513          	addi	a0,s0,-176
    80004db4:	ac3ff0ef          	jal	ra,80004876 <create>
    80004db8:	84aa                	mv	s1,a0
    if(ip == 0){
    80004dba:	c159                	beqz	a0,80004e40 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dbc:	04449703          	lh	a4,68(s1)
    80004dc0:	478d                	li	a5,3
    80004dc2:	00f71763          	bne	a4,a5,80004dd0 <sys_open+0x62>
    80004dc6:	0464d703          	lhu	a4,70(s1)
    80004dca:	47a5                	li	a5,9
    80004dcc:	0ae7e963          	bltu	a5,a4,80004e7e <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dd0:	874ff0ef          	jal	ra,80003e44 <filealloc>
    80004dd4:	89aa                	mv	s3,a0
    80004dd6:	0c050963          	beqz	a0,80004ea8 <sys_open+0x13a>
    80004dda:	a5fff0ef          	jal	ra,80004838 <fdalloc>
    80004dde:	892a                	mv	s2,a0
    80004de0:	0c054163          	bltz	a0,80004ea2 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004de4:	04449703          	lh	a4,68(s1)
    80004de8:	478d                	li	a5,3
    80004dea:	0af70163          	beq	a4,a5,80004e8c <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dee:	4789                	li	a5,2
    80004df0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004df4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004df8:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dfc:	f4c42783          	lw	a5,-180(s0)
    80004e00:	0017c713          	xori	a4,a5,1
    80004e04:	8b05                	andi	a4,a4,1
    80004e06:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e0a:	0037f713          	andi	a4,a5,3
    80004e0e:	00e03733          	snez	a4,a4
    80004e12:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e16:	4007f793          	andi	a5,a5,1024
    80004e1a:	c791                	beqz	a5,80004e26 <sys_open+0xb8>
    80004e1c:	04449703          	lh	a4,68(s1)
    80004e20:	4789                	li	a5,2
    80004e22:	06f70c63          	beq	a4,a5,80004e9a <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e26:	8526                	mv	a0,s1
    80004e28:	cc2fe0ef          	jal	ra,800032ea <iunlock>
  end_op();
    80004e2c:	d11fe0ef          	jal	ra,80003b3c <end_op>

  return fd;
    80004e30:	854a                	mv	a0,s2
}
    80004e32:	70ea                	ld	ra,184(sp)
    80004e34:	744a                	ld	s0,176(sp)
    80004e36:	74aa                	ld	s1,168(sp)
    80004e38:	790a                	ld	s2,160(sp)
    80004e3a:	69ea                	ld	s3,152(sp)
    80004e3c:	6129                	addi	sp,sp,192
    80004e3e:	8082                	ret
      end_op();
    80004e40:	cfdfe0ef          	jal	ra,80003b3c <end_op>
      return -1;
    80004e44:	557d                	li	a0,-1
    80004e46:	b7f5                	j	80004e32 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004e48:	f5040513          	addi	a0,s0,-176
    80004e4c:	aa9fe0ef          	jal	ra,800038f4 <namei>
    80004e50:	84aa                	mv	s1,a0
    80004e52:	c115                	beqz	a0,80004e76 <sys_open+0x108>
    ilock(ip);
    80004e54:	becfe0ef          	jal	ra,80003240 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e58:	04449703          	lh	a4,68(s1)
    80004e5c:	4785                	li	a5,1
    80004e5e:	f4f71fe3          	bne	a4,a5,80004dbc <sys_open+0x4e>
    80004e62:	f4c42783          	lw	a5,-180(s0)
    80004e66:	d7ad                	beqz	a5,80004dd0 <sys_open+0x62>
      iunlockput(ip);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	ddcfe0ef          	jal	ra,80003446 <iunlockput>
      end_op();
    80004e6e:	ccffe0ef          	jal	ra,80003b3c <end_op>
      return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	bf7d                	j	80004e32 <sys_open+0xc4>
      end_op();
    80004e76:	cc7fe0ef          	jal	ra,80003b3c <end_op>
      return -1;
    80004e7a:	557d                	li	a0,-1
    80004e7c:	bf5d                	j	80004e32 <sys_open+0xc4>
    iunlockput(ip);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	dc6fe0ef          	jal	ra,80003446 <iunlockput>
    end_op();
    80004e84:	cb9fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	b765                	j	80004e32 <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004e8c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e90:	04649783          	lh	a5,70(s1)
    80004e94:	02f99223          	sh	a5,36(s3)
    80004e98:	b785                	j	80004df8 <sys_open+0x8a>
    itrunc(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	c8efe0ef          	jal	ra,8000332a <itrunc>
    80004ea0:	b759                	j	80004e26 <sys_open+0xb8>
      fileclose(f);
    80004ea2:	854e                	mv	a0,s3
    80004ea4:	844ff0ef          	jal	ra,80003ee8 <fileclose>
    iunlockput(ip);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	d9cfe0ef          	jal	ra,80003446 <iunlockput>
    end_op();
    80004eae:	c8ffe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004eb2:	557d                	li	a0,-1
    80004eb4:	bfbd                	j	80004e32 <sys_open+0xc4>

0000000080004eb6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eb6:	7175                	addi	sp,sp,-144
    80004eb8:	e506                	sd	ra,136(sp)
    80004eba:	e122                	sd	s0,128(sp)
    80004ebc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ebe:	c0ffe0ef          	jal	ra,80003acc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ec2:	08000613          	li	a2,128
    80004ec6:	f7040593          	addi	a1,s0,-144
    80004eca:	4501                	li	a0,0
    80004ecc:	923fd0ef          	jal	ra,800027ee <argstr>
    80004ed0:	02054363          	bltz	a0,80004ef6 <sys_mkdir+0x40>
    80004ed4:	4681                	li	a3,0
    80004ed6:	4601                	li	a2,0
    80004ed8:	4585                	li	a1,1
    80004eda:	f7040513          	addi	a0,s0,-144
    80004ede:	999ff0ef          	jal	ra,80004876 <create>
    80004ee2:	c911                	beqz	a0,80004ef6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ee4:	d62fe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    80004ee8:	c55fe0ef          	jal	ra,80003b3c <end_op>
  return 0;
    80004eec:	4501                	li	a0,0
}
    80004eee:	60aa                	ld	ra,136(sp)
    80004ef0:	640a                	ld	s0,128(sp)
    80004ef2:	6149                	addi	sp,sp,144
    80004ef4:	8082                	ret
    end_op();
    80004ef6:	c47fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004efa:	557d                	li	a0,-1
    80004efc:	bfcd                	j	80004eee <sys_mkdir+0x38>

0000000080004efe <sys_mknod>:

uint64
sys_mknod(void)
{
    80004efe:	7135                	addi	sp,sp,-160
    80004f00:	ed06                	sd	ra,152(sp)
    80004f02:	e922                	sd	s0,144(sp)
    80004f04:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f06:	bc7fe0ef          	jal	ra,80003acc <begin_op>
  argint(1, &major);
    80004f0a:	f6c40593          	addi	a1,s0,-148
    80004f0e:	4505                	li	a0,1
    80004f10:	8a7fd0ef          	jal	ra,800027b6 <argint>
  argint(2, &minor);
    80004f14:	f6840593          	addi	a1,s0,-152
    80004f18:	4509                	li	a0,2
    80004f1a:	89dfd0ef          	jal	ra,800027b6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f1e:	08000613          	li	a2,128
    80004f22:	f7040593          	addi	a1,s0,-144
    80004f26:	4501                	li	a0,0
    80004f28:	8c7fd0ef          	jal	ra,800027ee <argstr>
    80004f2c:	02054563          	bltz	a0,80004f56 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f30:	f6841683          	lh	a3,-152(s0)
    80004f34:	f6c41603          	lh	a2,-148(s0)
    80004f38:	458d                	li	a1,3
    80004f3a:	f7040513          	addi	a0,s0,-144
    80004f3e:	939ff0ef          	jal	ra,80004876 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f42:	c911                	beqz	a0,80004f56 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f44:	d02fe0ef          	jal	ra,80003446 <iunlockput>
  end_op();
    80004f48:	bf5fe0ef          	jal	ra,80003b3c <end_op>
  return 0;
    80004f4c:	4501                	li	a0,0
}
    80004f4e:	60ea                	ld	ra,152(sp)
    80004f50:	644a                	ld	s0,144(sp)
    80004f52:	610d                	addi	sp,sp,160
    80004f54:	8082                	ret
    end_op();
    80004f56:	be7fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	bfcd                	j	80004f4e <sys_mknod+0x50>

0000000080004f5e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f5e:	7135                	addi	sp,sp,-160
    80004f60:	ed06                	sd	ra,152(sp)
    80004f62:	e922                	sd	s0,144(sp)
    80004f64:	e526                	sd	s1,136(sp)
    80004f66:	e14a                	sd	s2,128(sp)
    80004f68:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f6a:	8c3fc0ef          	jal	ra,8000182c <myproc>
    80004f6e:	892a                	mv	s2,a0
  
  begin_op();
    80004f70:	b5dfe0ef          	jal	ra,80003acc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f74:	08000613          	li	a2,128
    80004f78:	f6040593          	addi	a1,s0,-160
    80004f7c:	4501                	li	a0,0
    80004f7e:	871fd0ef          	jal	ra,800027ee <argstr>
    80004f82:	04054163          	bltz	a0,80004fc4 <sys_chdir+0x66>
    80004f86:	f6040513          	addi	a0,s0,-160
    80004f8a:	96bfe0ef          	jal	ra,800038f4 <namei>
    80004f8e:	84aa                	mv	s1,a0
    80004f90:	c915                	beqz	a0,80004fc4 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f92:	aaefe0ef          	jal	ra,80003240 <ilock>
  if(ip->type != T_DIR){
    80004f96:	04449703          	lh	a4,68(s1)
    80004f9a:	4785                	li	a5,1
    80004f9c:	02f71863          	bne	a4,a5,80004fcc <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	b48fe0ef          	jal	ra,800032ea <iunlock>
  iput(p->cwd);
    80004fa6:	15093503          	ld	a0,336(s2)
    80004faa:	c14fe0ef          	jal	ra,800033be <iput>
  end_op();
    80004fae:	b8ffe0ef          	jal	ra,80003b3c <end_op>
  p->cwd = ip;
    80004fb2:	14993823          	sd	s1,336(s2)
  return 0;
    80004fb6:	4501                	li	a0,0
}
    80004fb8:	60ea                	ld	ra,152(sp)
    80004fba:	644a                	ld	s0,144(sp)
    80004fbc:	64aa                	ld	s1,136(sp)
    80004fbe:	690a                	ld	s2,128(sp)
    80004fc0:	610d                	addi	sp,sp,160
    80004fc2:	8082                	ret
    end_op();
    80004fc4:	b79fe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004fc8:	557d                	li	a0,-1
    80004fca:	b7fd                	j	80004fb8 <sys_chdir+0x5a>
    iunlockput(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	c78fe0ef          	jal	ra,80003446 <iunlockput>
    end_op();
    80004fd2:	b6bfe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    80004fd6:	557d                	li	a0,-1
    80004fd8:	b7c5                	j	80004fb8 <sys_chdir+0x5a>

0000000080004fda <sys_exec>:

uint64
sys_exec(void)
{
    80004fda:	7145                	addi	sp,sp,-464
    80004fdc:	e786                	sd	ra,456(sp)
    80004fde:	e3a2                	sd	s0,448(sp)
    80004fe0:	ff26                	sd	s1,440(sp)
    80004fe2:	fb4a                	sd	s2,432(sp)
    80004fe4:	f74e                	sd	s3,424(sp)
    80004fe6:	f352                	sd	s4,416(sp)
    80004fe8:	ef56                	sd	s5,408(sp)
    80004fea:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fec:	e3840593          	addi	a1,s0,-456
    80004ff0:	4505                	li	a0,1
    80004ff2:	fe0fd0ef          	jal	ra,800027d2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ff6:	08000613          	li	a2,128
    80004ffa:	f4040593          	addi	a1,s0,-192
    80004ffe:	4501                	li	a0,0
    80005000:	feefd0ef          	jal	ra,800027ee <argstr>
    80005004:	87aa                	mv	a5,a0
    return -1;
    80005006:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005008:	0a07c463          	bltz	a5,800050b0 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    8000500c:	10000613          	li	a2,256
    80005010:	4581                	li	a1,0
    80005012:	e4040513          	addi	a0,s0,-448
    80005016:	c59fb0ef          	jal	ra,80000c6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000501a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000501e:	89a6                	mv	s3,s1
    80005020:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005022:	02000a13          	li	s4,32
    80005026:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000502a:	00391793          	slli	a5,s2,0x3
    8000502e:	e3040593          	addi	a1,s0,-464
    80005032:	e3843503          	ld	a0,-456(s0)
    80005036:	953e                	add	a0,a0,a5
    80005038:	e94fd0ef          	jal	ra,800026cc <fetchaddr>
    8000503c:	02054663          	bltz	a0,80005068 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80005040:	e3043783          	ld	a5,-464(s0)
    80005044:	cf8d                	beqz	a5,8000507e <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005046:	a85fb0ef          	jal	ra,80000aca <kalloc>
    8000504a:	85aa                	mv	a1,a0
    8000504c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005050:	cd01                	beqz	a0,80005068 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005052:	6605                	lui	a2,0x1
    80005054:	e3043503          	ld	a0,-464(s0)
    80005058:	ebefd0ef          	jal	ra,80002716 <fetchstr>
    8000505c:	00054663          	bltz	a0,80005068 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80005060:	0905                	addi	s2,s2,1
    80005062:	09a1                	addi	s3,s3,8
    80005064:	fd4911e3          	bne	s2,s4,80005026 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005068:	10048913          	addi	s2,s1,256
    8000506c:	6088                	ld	a0,0(s1)
    8000506e:	c121                	beqz	a0,800050ae <sys_exec+0xd4>
    kfree(argv[i]);
    80005070:	97bfb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005074:	04a1                	addi	s1,s1,8
    80005076:	ff249be3          	bne	s1,s2,8000506c <sys_exec+0x92>
  return -1;
    8000507a:	557d                	li	a0,-1
    8000507c:	a815                	j	800050b0 <sys_exec+0xd6>
      argv[i] = 0;
    8000507e:	0a8e                	slli	s5,s5,0x3
    80005080:	fc040793          	addi	a5,s0,-64
    80005084:	9abe                	add	s5,s5,a5
    80005086:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000508a:	e4040593          	addi	a1,s0,-448
    8000508e:	f4040513          	addi	a0,s0,-192
    80005092:	bfaff0ef          	jal	ra,8000448c <exec>
    80005096:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005098:	10048993          	addi	s3,s1,256
    8000509c:	6088                	ld	a0,0(s1)
    8000509e:	c511                	beqz	a0,800050aa <sys_exec+0xd0>
    kfree(argv[i]);
    800050a0:	94bfb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a4:	04a1                	addi	s1,s1,8
    800050a6:	ff349be3          	bne	s1,s3,8000509c <sys_exec+0xc2>
  return ret;
    800050aa:	854a                	mv	a0,s2
    800050ac:	a011                	j	800050b0 <sys_exec+0xd6>
  return -1;
    800050ae:	557d                	li	a0,-1
}
    800050b0:	60be                	ld	ra,456(sp)
    800050b2:	641e                	ld	s0,448(sp)
    800050b4:	74fa                	ld	s1,440(sp)
    800050b6:	795a                	ld	s2,432(sp)
    800050b8:	79ba                	ld	s3,424(sp)
    800050ba:	7a1a                	ld	s4,416(sp)
    800050bc:	6afa                	ld	s5,408(sp)
    800050be:	6179                	addi	sp,sp,464
    800050c0:	8082                	ret

00000000800050c2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050c2:	7139                	addi	sp,sp,-64
    800050c4:	fc06                	sd	ra,56(sp)
    800050c6:	f822                	sd	s0,48(sp)
    800050c8:	f426                	sd	s1,40(sp)
    800050ca:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050cc:	f60fc0ef          	jal	ra,8000182c <myproc>
    800050d0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050d2:	fd840593          	addi	a1,s0,-40
    800050d6:	4501                	li	a0,0
    800050d8:	efafd0ef          	jal	ra,800027d2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050dc:	fc840593          	addi	a1,s0,-56
    800050e0:	fd040513          	addi	a0,s0,-48
    800050e4:	8d2ff0ef          	jal	ra,800041b6 <pipealloc>
    return -1;
    800050e8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ea:	0a054463          	bltz	a0,80005192 <sys_pipe+0xd0>
  fd0 = -1;
    800050ee:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f2:	fd043503          	ld	a0,-48(s0)
    800050f6:	f42ff0ef          	jal	ra,80004838 <fdalloc>
    800050fa:	fca42223          	sw	a0,-60(s0)
    800050fe:	08054163          	bltz	a0,80005180 <sys_pipe+0xbe>
    80005102:	fc843503          	ld	a0,-56(s0)
    80005106:	f32ff0ef          	jal	ra,80004838 <fdalloc>
    8000510a:	fca42023          	sw	a0,-64(s0)
    8000510e:	06054063          	bltz	a0,8000516e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005112:	4691                	li	a3,4
    80005114:	fc440613          	addi	a2,s0,-60
    80005118:	fd843583          	ld	a1,-40(s0)
    8000511c:	68a8                	ld	a0,80(s1)
    8000511e:	bc2fc0ef          	jal	ra,800014e0 <copyout>
    80005122:	00054e63          	bltz	a0,8000513e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005126:	4691                	li	a3,4
    80005128:	fc040613          	addi	a2,s0,-64
    8000512c:	fd843583          	ld	a1,-40(s0)
    80005130:	0591                	addi	a1,a1,4
    80005132:	68a8                	ld	a0,80(s1)
    80005134:	bacfc0ef          	jal	ra,800014e0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005138:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513a:	04055c63          	bgez	a0,80005192 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000513e:	fc442783          	lw	a5,-60(s0)
    80005142:	07e9                	addi	a5,a5,26
    80005144:	078e                	slli	a5,a5,0x3
    80005146:	97a6                	add	a5,a5,s1
    80005148:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000514c:	fc042503          	lw	a0,-64(s0)
    80005150:	0569                	addi	a0,a0,26
    80005152:	050e                	slli	a0,a0,0x3
    80005154:	94aa                	add	s1,s1,a0
    80005156:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000515a:	fd043503          	ld	a0,-48(s0)
    8000515e:	d8bfe0ef          	jal	ra,80003ee8 <fileclose>
    fileclose(wf);
    80005162:	fc843503          	ld	a0,-56(s0)
    80005166:	d83fe0ef          	jal	ra,80003ee8 <fileclose>
    return -1;
    8000516a:	57fd                	li	a5,-1
    8000516c:	a01d                	j	80005192 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000516e:	fc442783          	lw	a5,-60(s0)
    80005172:	0007c763          	bltz	a5,80005180 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005176:	07e9                	addi	a5,a5,26
    80005178:	078e                	slli	a5,a5,0x3
    8000517a:	94be                	add	s1,s1,a5
    8000517c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005180:	fd043503          	ld	a0,-48(s0)
    80005184:	d65fe0ef          	jal	ra,80003ee8 <fileclose>
    fileclose(wf);
    80005188:	fc843503          	ld	a0,-56(s0)
    8000518c:	d5dfe0ef          	jal	ra,80003ee8 <fileclose>
    return -1;
    80005190:	57fd                	li	a5,-1
}
    80005192:	853e                	mv	a0,a5
    80005194:	70e2                	ld	ra,56(sp)
    80005196:	7442                	ld	s0,48(sp)
    80005198:	74a2                	ld	s1,40(sp)
    8000519a:	6121                	addi	sp,sp,64
    8000519c:	8082                	ret

000000008000519e <sys_lseek>:

uint64 sys_lseek(void) {
    8000519e:	7179                	addi	sp,sp,-48
    800051a0:	f406                	sd	ra,40(sp)
    800051a2:	f022                	sd	s0,32(sp)
    800051a4:	1800                	addi	s0,sp,48
    int offset;
    int whence;
    struct file *f;

    // Récupérer les arguments
    argint(0, &fd);
    800051a6:	fec40593          	addi	a1,s0,-20
    800051aa:	4501                	li	a0,0
    800051ac:	e0afd0ef          	jal	ra,800027b6 <argint>
    argint(1, &offset);
    800051b0:	fe840593          	addi	a1,s0,-24
    800051b4:	4505                	li	a0,1
    800051b6:	e00fd0ef          	jal	ra,800027b6 <argint>
    argint(2, &whence);
    800051ba:	fe440593          	addi	a1,s0,-28
    800051be:	4509                	li	a0,2
    800051c0:	df6fd0ef          	jal	ra,800027b6 <argint>

    // Récupérer le descripteur de fichier
    if (argfd(0, &fd, &f) < 0)
    800051c4:	fd840613          	addi	a2,s0,-40
    800051c8:	fec40593          	addi	a1,s0,-20
    800051cc:	4501                	li	a0,0
    800051ce:	e12ff0ef          	jal	ra,800047e0 <argfd>
    800051d2:	04054e63          	bltz	a0,8000522e <sys_lseek+0x90>
        return -1;

    // Vérifier que le fichier est ouvert en lecture/écriture
    if (f->type != FD_INODE || !f->writable || !f->readable)
    800051d6:	fd843783          	ld	a5,-40(s0)
    800051da:	4394                	lw	a3,0(a5)
    800051dc:	4709                	li	a4,2
        return -1;
    800051de:	557d                	li	a0,-1
    if (f->type != FD_INODE || !f->writable || !f->readable)
    800051e0:	02e69663          	bne	a3,a4,8000520c <sys_lseek+0x6e>
    800051e4:	0097c703          	lbu	a4,9(a5)
    800051e8:	c315                	beqz	a4,8000520c <sys_lseek+0x6e>
    800051ea:	0087c703          	lbu	a4,8(a5)
    800051ee:	cf19                	beqz	a4,8000520c <sys_lseek+0x6e>

    // Appliquer le décalage en fonction de whence
    switch (whence) {
    800051f0:	fe442703          	lw	a4,-28(s0)
    800051f4:	4685                	li	a3,1
    800051f6:	00d70f63          	beq	a4,a3,80005214 <sys_lseek+0x76>
    800051fa:	4689                	li	a3,2
    800051fc:	02d70263          	beq	a4,a3,80005220 <sys_lseek+0x82>
    80005200:	e711                	bnez	a4,8000520c <sys_lseek+0x6e>
        case SEEK_SET:
            f->off = offset;
    80005202:	fe842703          	lw	a4,-24(s0)
    80005206:	d398                	sw	a4,32(a5)
            break;
        default:
            return -1;
    }

    return f->off;
    80005208:	0207e503          	lwu	a0,32(a5)
}
    8000520c:	70a2                	ld	ra,40(sp)
    8000520e:	7402                	ld	s0,32(sp)
    80005210:	6145                	addi	sp,sp,48
    80005212:	8082                	ret
            f->off += offset;
    80005214:	5398                	lw	a4,32(a5)
    80005216:	fe842683          	lw	a3,-24(s0)
    8000521a:	9f35                	addw	a4,a4,a3
    8000521c:	d398                	sw	a4,32(a5)
            break;
    8000521e:	b7ed                	j	80005208 <sys_lseek+0x6a>
            f->off = f->ip->size + offset;
    80005220:	6f98                	ld	a4,24(a5)
    80005222:	4778                	lw	a4,76(a4)
    80005224:	fe842683          	lw	a3,-24(s0)
    80005228:	9f35                	addw	a4,a4,a3
    8000522a:	d398                	sw	a4,32(a5)
            break;
    8000522c:	bff1                	j	80005208 <sys_lseek+0x6a>
        return -1;
    8000522e:	557d                	li	a0,-1
    80005230:	bff1                	j	8000520c <sys_lseek+0x6e>

0000000080005232 <sys_chmod>:


uint64
sys_chmod(void) {
    80005232:	7171                	addi	sp,sp,-176
    80005234:	f506                	sd	ra,168(sp)
    80005236:	f122                	sd	s0,160(sp)
    80005238:	ed26                	sd	s1,152(sp)
    8000523a:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  int mode;
  struct inode *ip;
  
  // Récupère le chemin du fichier
  if(argstr(0, path, MAXPATH) == 0) {
    8000523c:	08000613          	li	a2,128
    80005240:	f6040593          	addi	a1,s0,-160
    80005244:	4501                	li	a0,0
    80005246:	da8fd0ef          	jal	ra,800027ee <argstr>
    return -1;
    8000524a:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) == 0) {
    8000524c:	c521                	beqz	a0,80005294 <sys_chmod+0x62>
  }
  
  // Récupère le mode
  argint(1, &mode);
    8000524e:	f5c40593          	addi	a1,s0,-164
    80005252:	4505                	li	a0,1
    80005254:	d62fd0ef          	jal	ra,800027b6 <argint>
  
  begin_op();
    80005258:	875fe0ef          	jal	ra,80003acc <begin_op>
  
  // Obtient l'inode
  if((ip = namei(path)) == 0) {
    8000525c:	f6040513          	addi	a0,s0,-160
    80005260:	e94fe0ef          	jal	ra,800038f4 <namei>
    80005264:	84aa                	mv	s1,a0
    80005266:	cd0d                	beqz	a0,800052a0 <sys_chmod+0x6e>
    end_op();
    return -1;
  }
  
  ilock(ip);
    80005268:	fd9fd0ef          	jal	ra,80003240 <ilock>
  
  // Modifie uniquement les bits de permission (derniers 9 bits)
  ip->type = (ip->type & ~0777) | (mode & 0777);
    8000526c:	0444d783          	lhu	a5,68(s1)
    80005270:	e007f793          	andi	a5,a5,-512
    80005274:	f5c42703          	lw	a4,-164(s0)
    80005278:	1ff77713          	andi	a4,a4,511
    8000527c:	8fd9                	or	a5,a5,a4
    8000527e:	04f49223          	sh	a5,68(s1)
  
  iupdate(ip);
    80005282:	8526                	mv	a0,s1
    80005284:	f0bfd0ef          	jal	ra,8000318e <iupdate>
  iunlock(ip);
    80005288:	8526                	mv	a0,s1
    8000528a:	860fe0ef          	jal	ra,800032ea <iunlock>
  
  end_op();
    8000528e:	8affe0ef          	jal	ra,80003b3c <end_op>
  return 0;
    80005292:	4781                	li	a5,0
}
    80005294:	853e                	mv	a0,a5
    80005296:	70aa                	ld	ra,168(sp)
    80005298:	740a                	ld	s0,160(sp)
    8000529a:	64ea                	ld	s1,152(sp)
    8000529c:	614d                	addi	sp,sp,176
    8000529e:	8082                	ret
    end_op();
    800052a0:	89dfe0ef          	jal	ra,80003b3c <end_op>
    return -1;
    800052a4:	57fd                	li	a5,-1
    800052a6:	b7fd                	j	80005294 <sys_chmod+0x62>
	...

00000000800052b0 <kernelvec>:
    800052b0:	7111                	addi	sp,sp,-256
    800052b2:	e006                	sd	ra,0(sp)
    800052b4:	e40a                	sd	sp,8(sp)
    800052b6:	e80e                	sd	gp,16(sp)
    800052b8:	ec12                	sd	tp,24(sp)
    800052ba:	f016                	sd	t0,32(sp)
    800052bc:	f41a                	sd	t1,40(sp)
    800052be:	f81e                	sd	t2,48(sp)
    800052c0:	e4aa                	sd	a0,72(sp)
    800052c2:	e8ae                	sd	a1,80(sp)
    800052c4:	ecb2                	sd	a2,88(sp)
    800052c6:	f0b6                	sd	a3,96(sp)
    800052c8:	f4ba                	sd	a4,104(sp)
    800052ca:	f8be                	sd	a5,112(sp)
    800052cc:	fcc2                	sd	a6,120(sp)
    800052ce:	e146                	sd	a7,128(sp)
    800052d0:	edf2                	sd	t3,216(sp)
    800052d2:	f1f6                	sd	t4,224(sp)
    800052d4:	f5fa                	sd	t5,232(sp)
    800052d6:	f9fe                	sd	t6,240(sp)
    800052d8:	b64fd0ef          	jal	ra,8000263c <kerneltrap>
    800052dc:	6082                	ld	ra,0(sp)
    800052de:	6122                	ld	sp,8(sp)
    800052e0:	61c2                	ld	gp,16(sp)
    800052e2:	7282                	ld	t0,32(sp)
    800052e4:	7322                	ld	t1,40(sp)
    800052e6:	73c2                	ld	t2,48(sp)
    800052e8:	6526                	ld	a0,72(sp)
    800052ea:	65c6                	ld	a1,80(sp)
    800052ec:	6666                	ld	a2,88(sp)
    800052ee:	7686                	ld	a3,96(sp)
    800052f0:	7726                	ld	a4,104(sp)
    800052f2:	77c6                	ld	a5,112(sp)
    800052f4:	7866                	ld	a6,120(sp)
    800052f6:	688a                	ld	a7,128(sp)
    800052f8:	6e6e                	ld	t3,216(sp)
    800052fa:	7e8e                	ld	t4,224(sp)
    800052fc:	7f2e                	ld	t5,232(sp)
    800052fe:	7fce                	ld	t6,240(sp)
    80005300:	6111                	addi	sp,sp,256
    80005302:	10200073          	sret
	...

000000008000530e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000530e:	1141                	addi	sp,sp,-16
    80005310:	e422                	sd	s0,8(sp)
    80005312:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005314:	0c0007b7          	lui	a5,0xc000
    80005318:	4705                	li	a4,1
    8000531a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000531c:	c3d8                	sw	a4,4(a5)
}
    8000531e:	6422                	ld	s0,8(sp)
    80005320:	0141                	addi	sp,sp,16
    80005322:	8082                	ret

0000000080005324 <plicinithart>:

void
plicinithart(void)
{
    80005324:	1141                	addi	sp,sp,-16
    80005326:	e406                	sd	ra,8(sp)
    80005328:	e022                	sd	s0,0(sp)
    8000532a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000532c:	cd4fc0ef          	jal	ra,80001800 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005330:	0085171b          	slliw	a4,a0,0x8
    80005334:	0c0027b7          	lui	a5,0xc002
    80005338:	97ba                	add	a5,a5,a4
    8000533a:	40200713          	li	a4,1026
    8000533e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005342:	00d5151b          	slliw	a0,a0,0xd
    80005346:	0c2017b7          	lui	a5,0xc201
    8000534a:	953e                	add	a0,a0,a5
    8000534c:	00052023          	sw	zero,0(a0)
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret

0000000080005358 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005358:	1141                	addi	sp,sp,-16
    8000535a:	e406                	sd	ra,8(sp)
    8000535c:	e022                	sd	s0,0(sp)
    8000535e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005360:	ca0fc0ef          	jal	ra,80001800 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005364:	00d5179b          	slliw	a5,a0,0xd
    80005368:	0c201537          	lui	a0,0xc201
    8000536c:	953e                	add	a0,a0,a5
  return irq;
}
    8000536e:	4148                	lw	a0,4(a0)
    80005370:	60a2                	ld	ra,8(sp)
    80005372:	6402                	ld	s0,0(sp)
    80005374:	0141                	addi	sp,sp,16
    80005376:	8082                	ret

0000000080005378 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005378:	1101                	addi	sp,sp,-32
    8000537a:	ec06                	sd	ra,24(sp)
    8000537c:	e822                	sd	s0,16(sp)
    8000537e:	e426                	sd	s1,8(sp)
    80005380:	1000                	addi	s0,sp,32
    80005382:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005384:	c7cfc0ef          	jal	ra,80001800 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005388:	00d5151b          	slliw	a0,a0,0xd
    8000538c:	0c2017b7          	lui	a5,0xc201
    80005390:	97aa                	add	a5,a5,a0
    80005392:	c3c4                	sw	s1,4(a5)
}
    80005394:	60e2                	ld	ra,24(sp)
    80005396:	6442                	ld	s0,16(sp)
    80005398:	64a2                	ld	s1,8(sp)
    8000539a:	6105                	addi	sp,sp,32
    8000539c:	8082                	ret

000000008000539e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000539e:	1141                	addi	sp,sp,-16
    800053a0:	e406                	sd	ra,8(sp)
    800053a2:	e022                	sd	s0,0(sp)
    800053a4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053a6:	479d                	li	a5,7
    800053a8:	04a7ca63          	blt	a5,a0,800053fc <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053ac:	00021797          	auipc	a5,0x21
    800053b0:	3fc78793          	addi	a5,a5,1020 # 800267a8 <disk>
    800053b4:	97aa                	add	a5,a5,a0
    800053b6:	0187c783          	lbu	a5,24(a5)
    800053ba:	e7b9                	bnez	a5,80005408 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053bc:	00451613          	slli	a2,a0,0x4
    800053c0:	00021797          	auipc	a5,0x21
    800053c4:	3e878793          	addi	a5,a5,1000 # 800267a8 <disk>
    800053c8:	6394                	ld	a3,0(a5)
    800053ca:	96b2                	add	a3,a3,a2
    800053cc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053d0:	6398                	ld	a4,0(a5)
    800053d2:	9732                	add	a4,a4,a2
    800053d4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053d8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053dc:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053e0:	953e                	add	a0,a0,a5
    800053e2:	4785                	li	a5,1
    800053e4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800053e8:	00021517          	auipc	a0,0x21
    800053ec:	3d850513          	addi	a0,a0,984 # 800267c0 <disk+0x18>
    800053f0:	a55fc0ef          	jal	ra,80001e44 <wakeup>
}
    800053f4:	60a2                	ld	ra,8(sp)
    800053f6:	6402                	ld	s0,0(sp)
    800053f8:	0141                	addi	sp,sp,16
    800053fa:	8082                	ret
    panic("free_desc 1");
    800053fc:	00002517          	auipc	a0,0x2
    80005400:	3a450513          	addi	a0,a0,932 # 800077a0 <syscalls+0x310>
    80005404:	b52fb0ef          	jal	ra,80000756 <panic>
    panic("free_desc 2");
    80005408:	00002517          	auipc	a0,0x2
    8000540c:	3a850513          	addi	a0,a0,936 # 800077b0 <syscalls+0x320>
    80005410:	b46fb0ef          	jal	ra,80000756 <panic>

0000000080005414 <virtio_disk_init>:
{
    80005414:	1101                	addi	sp,sp,-32
    80005416:	ec06                	sd	ra,24(sp)
    80005418:	e822                	sd	s0,16(sp)
    8000541a:	e426                	sd	s1,8(sp)
    8000541c:	e04a                	sd	s2,0(sp)
    8000541e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005420:	00002597          	auipc	a1,0x2
    80005424:	3a058593          	addi	a1,a1,928 # 800077c0 <syscalls+0x330>
    80005428:	00021517          	auipc	a0,0x21
    8000542c:	4a850513          	addi	a0,a0,1192 # 800268d0 <disk+0x128>
    80005430:	eeafb0ef          	jal	ra,80000b1a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	4398                	lw	a4,0(a5)
    8000543a:	2701                	sext.w	a4,a4
    8000543c:	747277b7          	lui	a5,0x74727
    80005440:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005444:	14f71063          	bne	a4,a5,80005584 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005448:	100017b7          	lui	a5,0x10001
    8000544c:	43dc                	lw	a5,4(a5)
    8000544e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005450:	4709                	li	a4,2
    80005452:	12e79963          	bne	a5,a4,80005584 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	479c                	lw	a5,8(a5)
    8000545c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000545e:	12e79363          	bne	a5,a4,80005584 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005462:	100017b7          	lui	a5,0x10001
    80005466:	47d8                	lw	a4,12(a5)
    80005468:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546a:	554d47b7          	lui	a5,0x554d4
    8000546e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005472:	10f71963          	bne	a4,a5,80005584 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	100017b7          	lui	a5,0x10001
    8000547a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	4705                	li	a4,1
    80005480:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005482:	470d                	li	a4,3
    80005484:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005486:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005488:	c7ffe737          	lui	a4,0xc7ffe
    8000548c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd7e77>
    80005490:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005492:	2701                	sext.w	a4,a4
    80005494:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005496:	472d                	li	a4,11
    80005498:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000549a:	5bbc                	lw	a5,112(a5)
    8000549c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054a0:	8ba1                	andi	a5,a5,8
    800054a2:	0e078763          	beqz	a5,80005590 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054a6:	100017b7          	lui	a5,0x10001
    800054aa:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054ae:	43fc                	lw	a5,68(a5)
    800054b0:	2781                	sext.w	a5,a5
    800054b2:	0e079563          	bnez	a5,8000559c <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054b6:	100017b7          	lui	a5,0x10001
    800054ba:	5bdc                	lw	a5,52(a5)
    800054bc:	2781                	sext.w	a5,a5
  if(max == 0)
    800054be:	0e078563          	beqz	a5,800055a8 <virtio_disk_init+0x194>
  if(max < NUM)
    800054c2:	471d                	li	a4,7
    800054c4:	0ef77863          	bgeu	a4,a5,800055b4 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    800054c8:	e02fb0ef          	jal	ra,80000aca <kalloc>
    800054cc:	00021497          	auipc	s1,0x21
    800054d0:	2dc48493          	addi	s1,s1,732 # 800267a8 <disk>
    800054d4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054d6:	df4fb0ef          	jal	ra,80000aca <kalloc>
    800054da:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054dc:	deefb0ef          	jal	ra,80000aca <kalloc>
    800054e0:	87aa                	mv	a5,a0
    800054e2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054e4:	6088                	ld	a0,0(s1)
    800054e6:	cd69                	beqz	a0,800055c0 <virtio_disk_init+0x1ac>
    800054e8:	00021717          	auipc	a4,0x21
    800054ec:	2c873703          	ld	a4,712(a4) # 800267b0 <disk+0x8>
    800054f0:	cb61                	beqz	a4,800055c0 <virtio_disk_init+0x1ac>
    800054f2:	c7f9                	beqz	a5,800055c0 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    800054f4:	6605                	lui	a2,0x1
    800054f6:	4581                	li	a1,0
    800054f8:	f76fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.avail, 0, PGSIZE);
    800054fc:	00021497          	auipc	s1,0x21
    80005500:	2ac48493          	addi	s1,s1,684 # 800267a8 <disk>
    80005504:	6605                	lui	a2,0x1
    80005506:	4581                	li	a1,0
    80005508:	6488                	ld	a0,8(s1)
    8000550a:	f64fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.used, 0, PGSIZE);
    8000550e:	6605                	lui	a2,0x1
    80005510:	4581                	li	a1,0
    80005512:	6888                	ld	a0,16(s1)
    80005514:	f5afb0ef          	jal	ra,80000c6e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	4721                	li	a4,8
    8000551e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005520:	4098                	lw	a4,0(s1)
    80005522:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005526:	40d8                	lw	a4,4(s1)
    80005528:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000552c:	6498                	ld	a4,8(s1)
    8000552e:	0007069b          	sext.w	a3,a4
    80005532:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005536:	9701                	srai	a4,a4,0x20
    80005538:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000553c:	6898                	ld	a4,16(s1)
    8000553e:	0007069b          	sext.w	a3,a4
    80005542:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005546:	9701                	srai	a4,a4,0x20
    80005548:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000554c:	4705                	li	a4,1
    8000554e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005550:	00e48c23          	sb	a4,24(s1)
    80005554:	00e48ca3          	sb	a4,25(s1)
    80005558:	00e48d23          	sb	a4,26(s1)
    8000555c:	00e48da3          	sb	a4,27(s1)
    80005560:	00e48e23          	sb	a4,28(s1)
    80005564:	00e48ea3          	sb	a4,29(s1)
    80005568:	00e48f23          	sb	a4,30(s1)
    8000556c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005570:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005574:	0727a823          	sw	s2,112(a5)
}
    80005578:	60e2                	ld	ra,24(sp)
    8000557a:	6442                	ld	s0,16(sp)
    8000557c:	64a2                	ld	s1,8(sp)
    8000557e:	6902                	ld	s2,0(sp)
    80005580:	6105                	addi	sp,sp,32
    80005582:	8082                	ret
    panic("could not find virtio disk");
    80005584:	00002517          	auipc	a0,0x2
    80005588:	24c50513          	addi	a0,a0,588 # 800077d0 <syscalls+0x340>
    8000558c:	9cafb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005590:	00002517          	auipc	a0,0x2
    80005594:	26050513          	addi	a0,a0,608 # 800077f0 <syscalls+0x360>
    80005598:	9befb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk should not be ready");
    8000559c:	00002517          	auipc	a0,0x2
    800055a0:	27450513          	addi	a0,a0,628 # 80007810 <syscalls+0x380>
    800055a4:	9b2fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk has no queue 0");
    800055a8:	00002517          	auipc	a0,0x2
    800055ac:	28850513          	addi	a0,a0,648 # 80007830 <syscalls+0x3a0>
    800055b0:	9a6fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk max queue too short");
    800055b4:	00002517          	auipc	a0,0x2
    800055b8:	29c50513          	addi	a0,a0,668 # 80007850 <syscalls+0x3c0>
    800055bc:	99afb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk kalloc");
    800055c0:	00002517          	auipc	a0,0x2
    800055c4:	2b050513          	addi	a0,a0,688 # 80007870 <syscalls+0x3e0>
    800055c8:	98efb0ef          	jal	ra,80000756 <panic>

00000000800055cc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055cc:	7119                	addi	sp,sp,-128
    800055ce:	fc86                	sd	ra,120(sp)
    800055d0:	f8a2                	sd	s0,112(sp)
    800055d2:	f4a6                	sd	s1,104(sp)
    800055d4:	f0ca                	sd	s2,96(sp)
    800055d6:	ecce                	sd	s3,88(sp)
    800055d8:	e8d2                	sd	s4,80(sp)
    800055da:	e4d6                	sd	s5,72(sp)
    800055dc:	e0da                	sd	s6,64(sp)
    800055de:	fc5e                	sd	s7,56(sp)
    800055e0:	f862                	sd	s8,48(sp)
    800055e2:	f466                	sd	s9,40(sp)
    800055e4:	f06a                	sd	s10,32(sp)
    800055e6:	ec6e                	sd	s11,24(sp)
    800055e8:	0100                	addi	s0,sp,128
    800055ea:	8aaa                	mv	s5,a0
    800055ec:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055ee:	00c52d03          	lw	s10,12(a0)
    800055f2:	001d1d1b          	slliw	s10,s10,0x1
    800055f6:	1d02                	slli	s10,s10,0x20
    800055f8:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800055fc:	00021517          	auipc	a0,0x21
    80005600:	2d450513          	addi	a0,a0,724 # 800268d0 <disk+0x128>
    80005604:	d96fb0ef          	jal	ra,80000b9a <acquire>
  for(int i = 0; i < 3; i++){
    80005608:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000560a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000560c:	00021b97          	auipc	s7,0x21
    80005610:	19cb8b93          	addi	s7,s7,412 # 800267a8 <disk>
  for(int i = 0; i < 3; i++){
    80005614:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005616:	00021c97          	auipc	s9,0x21
    8000561a:	2bac8c93          	addi	s9,s9,698 # 800268d0 <disk+0x128>
    8000561e:	a8a9                	j	80005678 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005620:	00fb8733          	add	a4,s7,a5
    80005624:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005628:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000562a:	0207c563          	bltz	a5,80005654 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000562e:	2905                	addiw	s2,s2,1
    80005630:	0611                	addi	a2,a2,4
    80005632:	05690863          	beq	s2,s6,80005682 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005636:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005638:	00021717          	auipc	a4,0x21
    8000563c:	17070713          	addi	a4,a4,368 # 800267a8 <disk>
    80005640:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005642:	01874683          	lbu	a3,24(a4)
    80005646:	fee9                	bnez	a3,80005620 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005648:	2785                	addiw	a5,a5,1
    8000564a:	0705                	addi	a4,a4,1
    8000564c:	fe979be3          	bne	a5,s1,80005642 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005650:	57fd                	li	a5,-1
    80005652:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005654:	01205b63          	blez	s2,8000566a <virtio_disk_rw+0x9e>
    80005658:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000565a:	000a2503          	lw	a0,0(s4)
    8000565e:	d41ff0ef          	jal	ra,8000539e <free_desc>
      for(int j = 0; j < i; j++)
    80005662:	2d85                	addiw	s11,s11,1
    80005664:	0a11                	addi	s4,s4,4
    80005666:	ffb91ae3          	bne	s2,s11,8000565a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000566a:	85e6                	mv	a1,s9
    8000566c:	00021517          	auipc	a0,0x21
    80005670:	15450513          	addi	a0,a0,340 # 800267c0 <disk+0x18>
    80005674:	f84fc0ef          	jal	ra,80001df8 <sleep>
  for(int i = 0; i < 3; i++){
    80005678:	f8040a13          	addi	s4,s0,-128
{
    8000567c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000567e:	894e                	mv	s2,s3
    80005680:	bf5d                	j	80005636 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005682:	f8042583          	lw	a1,-128(s0)
    80005686:	00a58793          	addi	a5,a1,10
    8000568a:	0792                	slli	a5,a5,0x4

  if(write)
    8000568c:	00021617          	auipc	a2,0x21
    80005690:	11c60613          	addi	a2,a2,284 # 800267a8 <disk>
    80005694:	00f60733          	add	a4,a2,a5
    80005698:	018036b3          	snez	a3,s8
    8000569c:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000569e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056a2:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056a6:	f6078693          	addi	a3,a5,-160
    800056aa:	6218                	ld	a4,0(a2)
    800056ac:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ae:	00878513          	addi	a0,a5,8
    800056b2:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056b6:	6208                	ld	a0,0(a2)
    800056b8:	96aa                	add	a3,a3,a0
    800056ba:	4741                	li	a4,16
    800056bc:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056be:	4705                	li	a4,1
    800056c0:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800056c4:	f8442703          	lw	a4,-124(s0)
    800056c8:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056cc:	0712                	slli	a4,a4,0x4
    800056ce:	953a                	add	a0,a0,a4
    800056d0:	058a8693          	addi	a3,s5,88
    800056d4:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800056d6:	6208                	ld	a0,0(a2)
    800056d8:	972a                	add	a4,a4,a0
    800056da:	40000693          	li	a3,1024
    800056de:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056e0:	001c3c13          	seqz	s8,s8
    800056e4:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056e6:	001c6c13          	ori	s8,s8,1
    800056ea:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800056ee:	f8842603          	lw	a2,-120(s0)
    800056f2:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f6:	00021697          	auipc	a3,0x21
    800056fa:	0b268693          	addi	a3,a3,178 # 800267a8 <disk>
    800056fe:	00258713          	addi	a4,a1,2
    80005702:	0712                	slli	a4,a4,0x4
    80005704:	9736                	add	a4,a4,a3
    80005706:	587d                	li	a6,-1
    80005708:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000570c:	0612                	slli	a2,a2,0x4
    8000570e:	9532                	add	a0,a0,a2
    80005710:	f9078793          	addi	a5,a5,-112
    80005714:	97b6                	add	a5,a5,a3
    80005716:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80005718:	629c                	ld	a5,0(a3)
    8000571a:	97b2                	add	a5,a5,a2
    8000571c:	4605                	li	a2,1
    8000571e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005720:	4509                	li	a0,2
    80005722:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80005726:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000572a:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000572e:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005732:	6698                	ld	a4,8(a3)
    80005734:	00275783          	lhu	a5,2(a4)
    80005738:	8b9d                	andi	a5,a5,7
    8000573a:	0786                	slli	a5,a5,0x1
    8000573c:	97ba                	add	a5,a5,a4
    8000573e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005742:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005746:	6698                	ld	a4,8(a3)
    80005748:	00275783          	lhu	a5,2(a4)
    8000574c:	2785                	addiw	a5,a5,1
    8000574e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005752:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005756:	100017b7          	lui	a5,0x10001
    8000575a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000575e:	004aa783          	lw	a5,4(s5)
    80005762:	00c79f63          	bne	a5,a2,80005780 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80005766:	00021917          	auipc	s2,0x21
    8000576a:	16a90913          	addi	s2,s2,362 # 800268d0 <disk+0x128>
  while(b->disk == 1) {
    8000576e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005770:	85ca                	mv	a1,s2
    80005772:	8556                	mv	a0,s5
    80005774:	e84fc0ef          	jal	ra,80001df8 <sleep>
  while(b->disk == 1) {
    80005778:	004aa783          	lw	a5,4(s5)
    8000577c:	fe978ae3          	beq	a5,s1,80005770 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80005780:	f8042903          	lw	s2,-128(s0)
    80005784:	00290793          	addi	a5,s2,2
    80005788:	00479713          	slli	a4,a5,0x4
    8000578c:	00021797          	auipc	a5,0x21
    80005790:	01c78793          	addi	a5,a5,28 # 800267a8 <disk>
    80005794:	97ba                	add	a5,a5,a4
    80005796:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000579a:	00021997          	auipc	s3,0x21
    8000579e:	00e98993          	addi	s3,s3,14 # 800267a8 <disk>
    800057a2:	00491713          	slli	a4,s2,0x4
    800057a6:	0009b783          	ld	a5,0(s3)
    800057aa:	97ba                	add	a5,a5,a4
    800057ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057b0:	854a                	mv	a0,s2
    800057b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b6:	be9ff0ef          	jal	ra,8000539e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ba:	8885                	andi	s1,s1,1
    800057bc:	f0fd                	bnez	s1,800057a2 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057be:	00021517          	auipc	a0,0x21
    800057c2:	11250513          	addi	a0,a0,274 # 800268d0 <disk+0x128>
    800057c6:	c6cfb0ef          	jal	ra,80000c32 <release>
}
    800057ca:	70e6                	ld	ra,120(sp)
    800057cc:	7446                	ld	s0,112(sp)
    800057ce:	74a6                	ld	s1,104(sp)
    800057d0:	7906                	ld	s2,96(sp)
    800057d2:	69e6                	ld	s3,88(sp)
    800057d4:	6a46                	ld	s4,80(sp)
    800057d6:	6aa6                	ld	s5,72(sp)
    800057d8:	6b06                	ld	s6,64(sp)
    800057da:	7be2                	ld	s7,56(sp)
    800057dc:	7c42                	ld	s8,48(sp)
    800057de:	7ca2                	ld	s9,40(sp)
    800057e0:	7d02                	ld	s10,32(sp)
    800057e2:	6de2                	ld	s11,24(sp)
    800057e4:	6109                	addi	sp,sp,128
    800057e6:	8082                	ret

00000000800057e8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057e8:	1101                	addi	sp,sp,-32
    800057ea:	ec06                	sd	ra,24(sp)
    800057ec:	e822                	sd	s0,16(sp)
    800057ee:	e426                	sd	s1,8(sp)
    800057f0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057f2:	00021497          	auipc	s1,0x21
    800057f6:	fb648493          	addi	s1,s1,-74 # 800267a8 <disk>
    800057fa:	00021517          	auipc	a0,0x21
    800057fe:	0d650513          	addi	a0,a0,214 # 800268d0 <disk+0x128>
    80005802:	b98fb0ef          	jal	ra,80000b9a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005806:	10001737          	lui	a4,0x10001
    8000580a:	533c                	lw	a5,96(a4)
    8000580c:	8b8d                	andi	a5,a5,3
    8000580e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005810:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005814:	689c                	ld	a5,16(s1)
    80005816:	0204d703          	lhu	a4,32(s1)
    8000581a:	0027d783          	lhu	a5,2(a5)
    8000581e:	04f70663          	beq	a4,a5,8000586a <virtio_disk_intr+0x82>
    __sync_synchronize();
    80005822:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005826:	6898                	ld	a4,16(s1)
    80005828:	0204d783          	lhu	a5,32(s1)
    8000582c:	8b9d                	andi	a5,a5,7
    8000582e:	078e                	slli	a5,a5,0x3
    80005830:	97ba                	add	a5,a5,a4
    80005832:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005834:	00278713          	addi	a4,a5,2
    80005838:	0712                	slli	a4,a4,0x4
    8000583a:	9726                	add	a4,a4,s1
    8000583c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005840:	e321                	bnez	a4,80005880 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005842:	0789                	addi	a5,a5,2
    80005844:	0792                	slli	a5,a5,0x4
    80005846:	97a6                	add	a5,a5,s1
    80005848:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000584a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000584e:	df6fc0ef          	jal	ra,80001e44 <wakeup>

    disk.used_idx += 1;
    80005852:	0204d783          	lhu	a5,32(s1)
    80005856:	2785                	addiw	a5,a5,1
    80005858:	17c2                	slli	a5,a5,0x30
    8000585a:	93c1                	srli	a5,a5,0x30
    8000585c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005860:	6898                	ld	a4,16(s1)
    80005862:	00275703          	lhu	a4,2(a4)
    80005866:	faf71ee3          	bne	a4,a5,80005822 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000586a:	00021517          	auipc	a0,0x21
    8000586e:	06650513          	addi	a0,a0,102 # 800268d0 <disk+0x128>
    80005872:	bc0fb0ef          	jal	ra,80000c32 <release>
}
    80005876:	60e2                	ld	ra,24(sp)
    80005878:	6442                	ld	s0,16(sp)
    8000587a:	64a2                	ld	s1,8(sp)
    8000587c:	6105                	addi	sp,sp,32
    8000587e:	8082                	ret
      panic("virtio_disk_intr status");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	00850513          	addi	a0,a0,8 # 80007888 <syscalls+0x3f8>
    80005888:	ecffa0ef          	jal	ra,80000756 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
