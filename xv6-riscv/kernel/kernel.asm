
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd7717>
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
    800000fa:	0ea020ef          	jal	ra,800021e4 <either_copyin>
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
    80000186:	6f1010ef          	jal	ra,80002076 <killed>
    8000018a:	e125                	bnez	a0,800001ea <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000018c:	85a6                	mv	a1,s1
    8000018e:	854a                	mv	a0,s2
    80000190:	4af010ef          	jal	ra,80001e3e <sleep>
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
    800001c8:	7d3010ef          	jal	ra,8000219a <either_copyout>
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
    80000288:	7a7010ef          	jal	ra,8000222e <procdump>
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
    800003c4:	2c7010ef          	jal	ra,80001e8a <wakeup>
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
    800003ea:	00026797          	auipc	a5,0x26
    800003ee:	b6678793          	addi	a5,a5,-1178 # 80025f50 <devsw>
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
    800008aa:	5e0010ef          	jal	ra,80001e8a <wakeup>
    
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
    8000093c:	502010ef          	jal	ra,80001e3e <sleep>
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
    80000a02:	6ea78793          	addi	a5,a5,1770 # 800270e8 <end>
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
    80000aba:	63250513          	addi	a0,a0,1586 # 800270e8 <end>
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
    80000e46:	60c010ef          	jal	ra,80002452 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e4a:	48a040ef          	jal	ra,800052d4 <plicinithart>
  }

  scheduler();        
    80000e4e:	625000ef          	jal	ra,80001c72 <scheduler>
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
    80000e8e:	5a0010ef          	jal	ra,8000242e <trapinit>
    trapinithart();  // install kernel trap vector
    80000e92:	5c0010ef          	jal	ra,80002452 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e96:	428040ef          	jal	ra,800052be <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e9a:	43a040ef          	jal	ra,800052d4 <plicinithart>
    binit();         // buffer cache
    80000e9e:	429010ef          	jal	ra,80002ac6 <binit>
    iinit();         // inode table
    80000ea2:	208020ef          	jal	ra,800030aa <iinit>
    fileinit();      // file table
    80000ea6:	7a5020ef          	jal	ra,80003e4a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eaa:	51a040ef          	jal	ra,800053c4 <virtio_disk_init>
    userinit();      // first user process
    80000eae:	3fb000ef          	jal	ra,80001aa8 <userinit>
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
    800016e8:	7b448493          	addi	s1,s1,1972 # 80015e98 <proc>
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
    80001702:	79aa0a13          	addi	s4,s4,1946 # 8001be98 <tickslock>
    char *pa = kalloc();
    80001706:	bc4ff0ef          	jal	ra,80000aca <kalloc>
    8000170a:	862a                	mv	a2,a0
    if(pa == 0)
    8000170c:	c121                	beqz	a0,8000174c <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    8000170e:	416485b3          	sub	a1,s1,s6
    80001712:	859d                	srai	a1,a1,0x7
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
    80001730:	18048493          	addi	s1,s1,384
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
    80001798:	70448493          	addi	s1,s1,1796 # 80015e98 <proc>
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
    800017ba:	6e298993          	addi	s3,s3,1762 # 8001be98 <tickslock>
      initlock(&p->lock, "proc");
    800017be:	85da                	mv	a1,s6
    800017c0:	8526                	mv	a0,s1
    800017c2:	b58ff0ef          	jal	ra,80000b1a <initlock>
      p->state = UNUSED;
    800017c6:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017ca:	415487b3          	sub	a5,s1,s5
    800017ce:	879d                	srai	a5,a5,0x7
    800017d0:	000a3703          	ld	a4,0(s4)
    800017d4:	02e787b3          	mul	a5,a5,a4
    800017d8:	2785                	addiw	a5,a5,1
    800017da:	00d7979b          	slliw	a5,a5,0xd
    800017de:	40f907b3          	sub	a5,s2,a5
    800017e2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e4:	18048493          	addi	s1,s1,384
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
    80001876:	3f5000ef          	jal	ra,8000246a <usertrapret>
}
    8000187a:	60a2                	ld	ra,8(sp)
    8000187c:	6402                	ld	s0,0(sp)
    8000187e:	0141                	addi	sp,sp,16
    80001880:	8082                	ret
    fsinit(ROOTDEV);
    80001882:	4505                	li	a0,1
    80001884:	7ba010ef          	jal	ra,8000303e <fsinit>
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
    800019fe:	49e48493          	addi	s1,s1,1182 # 80015e98 <proc>
    80001a02:	0001a917          	auipc	s2,0x1a
    80001a06:	49690913          	addi	s2,s2,1174 # 8001be98 <tickslock>
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
    80001a1a:	18048493          	addi	s1,s1,384
    80001a1e:	ff2496e3          	bne	s1,s2,80001a0a <allocproc+0x1c>
  return 0;
    80001a22:	4481                	li	s1,0
    80001a24:	a899                	j	80001a7a <allocproc+0x8c>
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
    80001a38:	c921                	beqz	a0,80001a88 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	e99ff0ef          	jal	ra,800018d4 <proc_pagetable>
    80001a40:	892a                	mv	s2,a0
    80001a42:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a44:	c931                	beqz	a0,80001a98 <allocproc+0xaa>
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
  p->creation_time = ticks;
    80001a66:	00006797          	auipc	a5,0x6
    80001a6a:	eba7e783          	lwu	a5,-326(a5) # 80007920 <ticks>
    80001a6e:	16f4b423          	sd	a5,360(s1)
  p->cpu_usage = 0;
    80001a72:	1604b823          	sd	zero,368(s1)
  p->total_runtime = 0;
    80001a76:	1604bc23          	sd	zero,376(s1)
}
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	60e2                	ld	ra,24(sp)
    80001a7e:	6442                	ld	s0,16(sp)
    80001a80:	64a2                	ld	s1,8(sp)
    80001a82:	6902                	ld	s2,0(sp)
    80001a84:	6105                	addi	sp,sp,32
    80001a86:	8082                	ret
    freeproc(p);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	f15ff0ef          	jal	ra,8000199e <freeproc>
    release(&p->lock);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	9a2ff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001a94:	84ca                	mv	s1,s2
    80001a96:	b7d5                	j	80001a7a <allocproc+0x8c>
    freeproc(p);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	f05ff0ef          	jal	ra,8000199e <freeproc>
    release(&p->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	992ff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001aa4:	84ca                	mv	s1,s2
    80001aa6:	bfd1                	j	80001a7a <allocproc+0x8c>

0000000080001aa8 <userinit>:
{
    80001aa8:	1101                	addi	sp,sp,-32
    80001aaa:	ec06                	sd	ra,24(sp)
    80001aac:	e822                	sd	s0,16(sp)
    80001aae:	e426                	sd	s1,8(sp)
    80001ab0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ab2:	f3dff0ef          	jal	ra,800019ee <allocproc>
    80001ab6:	84aa                	mv	s1,a0
  initproc = p;
    80001ab8:	00006797          	auipc	a5,0x6
    80001abc:	e6a7b023          	sd	a0,-416(a5) # 80007918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ac0:	03400613          	li	a2,52
    80001ac4:	00006597          	auipc	a1,0x6
    80001ac8:	dec58593          	addi	a1,a1,-532 # 800078b0 <initcode>
    80001acc:	6928                	ld	a0,80(a0)
    80001ace:	f6cff0ef          	jal	ra,8000123a <uvmfirst>
  p->sz = PGSIZE;
    80001ad2:	6785                	lui	a5,0x1
    80001ad4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ad6:	6cb8                	ld	a4,88(s1)
    80001ad8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001adc:	6cb8                	ld	a4,88(s1)
    80001ade:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ae0:	4641                	li	a2,16
    80001ae2:	00005597          	auipc	a1,0x5
    80001ae6:	75658593          	addi	a1,a1,1878 # 80007238 <digits+0x200>
    80001aea:	15848513          	addi	a0,s1,344
    80001aee:	ac6ff0ef          	jal	ra,80000db4 <safestrcpy>
  p->cwd = namei("/");
    80001af2:	00005517          	auipc	a0,0x5
    80001af6:	75650513          	addi	a0,a0,1878 # 80007248 <digits+0x210>
    80001afa:	625010ef          	jal	ra,8000391e <namei>
    80001afe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b02:	478d                	li	a5,3
    80001b04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b06:	8526                	mv	a0,s1
    80001b08:	92aff0ef          	jal	ra,80000c32 <release>
}
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6105                	addi	sp,sp,32
    80001b14:	8082                	ret

0000000080001b16 <growproc>:
{
    80001b16:	1101                	addi	sp,sp,-32
    80001b18:	ec06                	sd	ra,24(sp)
    80001b1a:	e822                	sd	s0,16(sp)
    80001b1c:	e426                	sd	s1,8(sp)
    80001b1e:	e04a                	sd	s2,0(sp)
    80001b20:	1000                	addi	s0,sp,32
    80001b22:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b24:	d09ff0ef          	jal	ra,8000182c <myproc>
    80001b28:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b2c:	01204c63          	bgtz	s2,80001b44 <growproc+0x2e>
  } else if(n < 0){
    80001b30:	02094463          	bltz	s2,80001b58 <growproc+0x42>
  p->sz = sz;
    80001b34:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b36:	4501                	li	a0,0
}
    80001b38:	60e2                	ld	ra,24(sp)
    80001b3a:	6442                	ld	s0,16(sp)
    80001b3c:	64a2                	ld	s1,8(sp)
    80001b3e:	6902                	ld	s2,0(sp)
    80001b40:	6105                	addi	sp,sp,32
    80001b42:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b44:	4691                	li	a3,4
    80001b46:	00b90633          	add	a2,s2,a1
    80001b4a:	6928                	ld	a0,80(a0)
    80001b4c:	f90ff0ef          	jal	ra,800012dc <uvmalloc>
    80001b50:	85aa                	mv	a1,a0
    80001b52:	f16d                	bnez	a0,80001b34 <growproc+0x1e>
      return -1;
    80001b54:	557d                	li	a0,-1
    80001b56:	b7cd                	j	80001b38 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b58:	00b90633          	add	a2,s2,a1
    80001b5c:	6928                	ld	a0,80(a0)
    80001b5e:	f3aff0ef          	jal	ra,80001298 <uvmdealloc>
    80001b62:	85aa                	mv	a1,a0
    80001b64:	bfc1                	j	80001b34 <growproc+0x1e>

0000000080001b66 <fork>:
{
    80001b66:	7139                	addi	sp,sp,-64
    80001b68:	fc06                	sd	ra,56(sp)
    80001b6a:	f822                	sd	s0,48(sp)
    80001b6c:	f426                	sd	s1,40(sp)
    80001b6e:	f04a                	sd	s2,32(sp)
    80001b70:	ec4e                	sd	s3,24(sp)
    80001b72:	e852                	sd	s4,16(sp)
    80001b74:	e456                	sd	s5,8(sp)
    80001b76:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b78:	cb5ff0ef          	jal	ra,8000182c <myproc>
    80001b7c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b7e:	e71ff0ef          	jal	ra,800019ee <allocproc>
    80001b82:	0e050663          	beqz	a0,80001c6e <fork+0x108>
    80001b86:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b88:	048ab603          	ld	a2,72(s5)
    80001b8c:	692c                	ld	a1,80(a0)
    80001b8e:	050ab503          	ld	a0,80(s5)
    80001b92:	873ff0ef          	jal	ra,80001404 <uvmcopy>
    80001b96:	04054863          	bltz	a0,80001be6 <fork+0x80>
  np->sz = p->sz;
    80001b9a:	048ab783          	ld	a5,72(s5)
    80001b9e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001ba2:	058ab683          	ld	a3,88(s5)
    80001ba6:	87b6                	mv	a5,a3
    80001ba8:	058a3703          	ld	a4,88(s4)
    80001bac:	12068693          	addi	a3,a3,288
    80001bb0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001bb4:	6788                	ld	a0,8(a5)
    80001bb6:	6b8c                	ld	a1,16(a5)
    80001bb8:	6f90                	ld	a2,24(a5)
    80001bba:	01073023          	sd	a6,0(a4)
    80001bbe:	e708                	sd	a0,8(a4)
    80001bc0:	eb0c                	sd	a1,16(a4)
    80001bc2:	ef10                	sd	a2,24(a4)
    80001bc4:	02078793          	addi	a5,a5,32
    80001bc8:	02070713          	addi	a4,a4,32
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bd0:	058a3783          	ld	a5,88(s4)
    80001bd4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bd8:	0d0a8493          	addi	s1,s5,208
    80001bdc:	0d0a0913          	addi	s2,s4,208
    80001be0:	150a8993          	addi	s3,s5,336
    80001be4:	a829                	j	80001bfe <fork+0x98>
    freeproc(np);
    80001be6:	8552                	mv	a0,s4
    80001be8:	db7ff0ef          	jal	ra,8000199e <freeproc>
    release(&np->lock);
    80001bec:	8552                	mv	a0,s4
    80001bee:	844ff0ef          	jal	ra,80000c32 <release>
    return -1;
    80001bf2:	597d                	li	s2,-1
    80001bf4:	a09d                	j	80001c5a <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001bf6:	04a1                	addi	s1,s1,8
    80001bf8:	0921                	addi	s2,s2,8
    80001bfa:	01348963          	beq	s1,s3,80001c0c <fork+0xa6>
    if(p->ofile[i])
    80001bfe:	6088                	ld	a0,0(s1)
    80001c00:	d97d                	beqz	a0,80001bf6 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c02:	2ca020ef          	jal	ra,80003ecc <filedup>
    80001c06:	00a93023          	sd	a0,0(s2)
    80001c0a:	b7f5                	j	80001bf6 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001c0c:	150ab503          	ld	a0,336(s5)
    80001c10:	624010ef          	jal	ra,80003234 <idup>
    80001c14:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c18:	4641                	li	a2,16
    80001c1a:	158a8593          	addi	a1,s5,344
    80001c1e:	158a0513          	addi	a0,s4,344
    80001c22:	992ff0ef          	jal	ra,80000db4 <safestrcpy>
  pid = np->pid;
    80001c26:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c2a:	8552                	mv	a0,s4
    80001c2c:	806ff0ef          	jal	ra,80000c32 <release>
  acquire(&wait_lock);
    80001c30:	0000e497          	auipc	s1,0xe
    80001c34:	e3848493          	addi	s1,s1,-456 # 8000fa68 <wait_lock>
    80001c38:	8526                	mv	a0,s1
    80001c3a:	f61fe0ef          	jal	ra,80000b9a <acquire>
  np->parent = p;
    80001c3e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c42:	8526                	mv	a0,s1
    80001c44:	feffe0ef          	jal	ra,80000c32 <release>
  acquire(&np->lock);
    80001c48:	8552                	mv	a0,s4
    80001c4a:	f51fe0ef          	jal	ra,80000b9a <acquire>
  np->state = RUNNABLE;
    80001c4e:	478d                	li	a5,3
    80001c50:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c54:	8552                	mv	a0,s4
    80001c56:	fddfe0ef          	jal	ra,80000c32 <release>
}
    80001c5a:	854a                	mv	a0,s2
    80001c5c:	70e2                	ld	ra,56(sp)
    80001c5e:	7442                	ld	s0,48(sp)
    80001c60:	74a2                	ld	s1,40(sp)
    80001c62:	7902                	ld	s2,32(sp)
    80001c64:	69e2                	ld	s3,24(sp)
    80001c66:	6a42                	ld	s4,16(sp)
    80001c68:	6aa2                	ld	s5,8(sp)
    80001c6a:	6121                	addi	sp,sp,64
    80001c6c:	8082                	ret
    return -1;
    80001c6e:	597d                	li	s2,-1
    80001c70:	b7ed                	j	80001c5a <fork+0xf4>

0000000080001c72 <scheduler>:
{
    80001c72:	711d                	addi	sp,sp,-96
    80001c74:	ec86                	sd	ra,88(sp)
    80001c76:	e8a2                	sd	s0,80(sp)
    80001c78:	e4a6                	sd	s1,72(sp)
    80001c7a:	e0ca                	sd	s2,64(sp)
    80001c7c:	fc4e                	sd	s3,56(sp)
    80001c7e:	f852                	sd	s4,48(sp)
    80001c80:	f456                	sd	s5,40(sp)
    80001c82:	f05a                	sd	s6,32(sp)
    80001c84:	ec5e                	sd	s7,24(sp)
    80001c86:	e862                	sd	s8,16(sp)
    80001c88:	e466                	sd	s9,8(sp)
    80001c8a:	1080                	addi	s0,sp,96
    80001c8c:	8792                	mv	a5,tp
  int id = r_tp();
    80001c8e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c90:	00779c13          	slli	s8,a5,0x7
    80001c94:	0000e717          	auipc	a4,0xe
    80001c98:	dbc70713          	addi	a4,a4,-580 # 8000fa50 <pid_lock>
    80001c9c:	9762                	add	a4,a4,s8
    80001c9e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ca2:	0000e717          	auipc	a4,0xe
    80001ca6:	de670713          	addi	a4,a4,-538 # 8000fa88 <cpus+0x8>
    80001caa:	9c3a                	add	s8,s8,a4
          p->total_runtime = ticks - p->creation_time;
    80001cac:	00006a17          	auipc	s4,0x6
    80001cb0:	c74a0a13          	addi	s4,s4,-908 # 80007920 <ticks>
        c->proc = p;
    80001cb4:	079e                	slli	a5,a5,0x7
    80001cb6:	0000ea97          	auipc	s5,0xe
    80001cba:	d9aa8a93          	addi	s5,s5,-614 # 8000fa50 <pid_lock>
    80001cbe:	9abe                	add	s5,s5,a5
        found = 1;
    80001cc0:	4c85                	li	s9,1
    80001cc2:	a88d                	j	80001d34 <scheduler+0xc2>
        p->state = RUNNING;
    80001cc4:	0174ac23          	sw	s7,24(s1)
        p->cpu_usage++;  // Incrémente le temps CPU
    80001cc8:	1704b783          	ld	a5,368(s1)
    80001ccc:	0785                	addi	a5,a5,1
    80001cce:	16f4b823          	sd	a5,368(s1)
        p->total_runtime = ticks - p->creation_time;  // Met à jour le temps total
    80001cd2:	000a6783          	lwu	a5,0(s4)
    80001cd6:	1684b703          	ld	a4,360(s1)
    80001cda:	8f99                	sub	a5,a5,a4
    80001cdc:	16f4bc23          	sd	a5,376(s1)
        c->proc = p;
    80001ce0:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001ce4:	06048593          	addi	a1,s1,96
    80001ce8:	8562                	mv	a0,s8
    80001cea:	6da000ef          	jal	ra,800023c4 <swtch>
        c->proc = 0;
    80001cee:	020ab823          	sd	zero,48(s5)
        found = 1;
    80001cf2:	8b66                	mv	s6,s9
      release(&p->lock);
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	f3dfe0ef          	jal	ra,80000c32 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cfa:	18048493          	addi	s1,s1,384
    80001cfe:	03348163          	beq	s1,s3,80001d20 <scheduler+0xae>
      acquire(&p->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	e97fe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == RUNNABLE) {
    80001d08:	4c9c                	lw	a5,24(s1)
    80001d0a:	fb278de3          	beq	a5,s2,80001cc4 <scheduler+0x52>
        if(p->state != UNUSED) {
    80001d0e:	d3fd                	beqz	a5,80001cf4 <scheduler+0x82>
          p->total_runtime = ticks - p->creation_time;
    80001d10:	000a6783          	lwu	a5,0(s4)
    80001d14:	1684b703          	ld	a4,360(s1)
    80001d18:	8f99                	sub	a5,a5,a4
    80001d1a:	16f4bc23          	sd	a5,376(s1)
    80001d1e:	bfd9                	j	80001cf4 <scheduler+0x82>
    if(found == 0) {
    80001d20:	000b1e63          	bnez	s6,80001d3c <scheduler+0xca>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d30:	10500073          	wfi
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d34:	0001a997          	auipc	s3,0x1a
    80001d38:	16498993          	addi	s3,s3,356 # 8001be98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d44:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d48:	4b01                	li	s6,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d4a:	00014497          	auipc	s1,0x14
    80001d4e:	14e48493          	addi	s1,s1,334 # 80015e98 <proc>
      if(p->state == RUNNABLE) {
    80001d52:	490d                	li	s2,3
        p->state = RUNNING;
    80001d54:	4b91                	li	s7,4
    80001d56:	b775                	j	80001d02 <scheduler+0x90>

0000000080001d58 <sched>:
{
    80001d58:	7179                	addi	sp,sp,-48
    80001d5a:	f406                	sd	ra,40(sp)
    80001d5c:	f022                	sd	s0,32(sp)
    80001d5e:	ec26                	sd	s1,24(sp)
    80001d60:	e84a                	sd	s2,16(sp)
    80001d62:	e44e                	sd	s3,8(sp)
    80001d64:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d66:	ac7ff0ef          	jal	ra,8000182c <myproc>
    80001d6a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d6c:	dc5fe0ef          	jal	ra,80000b30 <holding>
    80001d70:	c92d                	beqz	a0,80001de2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d72:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d74:	2781                	sext.w	a5,a5
    80001d76:	079e                	slli	a5,a5,0x7
    80001d78:	0000e717          	auipc	a4,0xe
    80001d7c:	cd870713          	addi	a4,a4,-808 # 8000fa50 <pid_lock>
    80001d80:	97ba                	add	a5,a5,a4
    80001d82:	0a87a703          	lw	a4,168(a5)
    80001d86:	4785                	li	a5,1
    80001d88:	06f71363          	bne	a4,a5,80001dee <sched+0x96>
  if(p->state == RUNNING)
    80001d8c:	4c98                	lw	a4,24(s1)
    80001d8e:	4791                	li	a5,4
    80001d90:	06f70563          	beq	a4,a5,80001dfa <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d94:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d98:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d9a:	e7b5                	bnez	a5,80001e06 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d9c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d9e:	0000e917          	auipc	s2,0xe
    80001da2:	cb290913          	addi	s2,s2,-846 # 8000fa50 <pid_lock>
    80001da6:	2781                	sext.w	a5,a5
    80001da8:	079e                	slli	a5,a5,0x7
    80001daa:	97ca                	add	a5,a5,s2
    80001dac:	0ac7a983          	lw	s3,172(a5)
    80001db0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001db2:	2781                	sext.w	a5,a5
    80001db4:	079e                	slli	a5,a5,0x7
    80001db6:	0000e597          	auipc	a1,0xe
    80001dba:	cd258593          	addi	a1,a1,-814 # 8000fa88 <cpus+0x8>
    80001dbe:	95be                	add	a1,a1,a5
    80001dc0:	06048513          	addi	a0,s1,96
    80001dc4:	600000ef          	jal	ra,800023c4 <swtch>
    80001dc8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001dca:	2781                	sext.w	a5,a5
    80001dcc:	079e                	slli	a5,a5,0x7
    80001dce:	97ca                	add	a5,a5,s2
    80001dd0:	0b37a623          	sw	s3,172(a5)
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6145                	addi	sp,sp,48
    80001de0:	8082                	ret
    panic("sched p->lock");
    80001de2:	00005517          	auipc	a0,0x5
    80001de6:	46e50513          	addi	a0,a0,1134 # 80007250 <digits+0x218>
    80001dea:	96dfe0ef          	jal	ra,80000756 <panic>
    panic("sched locks");
    80001dee:	00005517          	auipc	a0,0x5
    80001df2:	47250513          	addi	a0,a0,1138 # 80007260 <digits+0x228>
    80001df6:	961fe0ef          	jal	ra,80000756 <panic>
    panic("sched running");
    80001dfa:	00005517          	auipc	a0,0x5
    80001dfe:	47650513          	addi	a0,a0,1142 # 80007270 <digits+0x238>
    80001e02:	955fe0ef          	jal	ra,80000756 <panic>
    panic("sched interruptible");
    80001e06:	00005517          	auipc	a0,0x5
    80001e0a:	47a50513          	addi	a0,a0,1146 # 80007280 <digits+0x248>
    80001e0e:	949fe0ef          	jal	ra,80000756 <panic>

0000000080001e12 <yield>:
{
    80001e12:	1101                	addi	sp,sp,-32
    80001e14:	ec06                	sd	ra,24(sp)
    80001e16:	e822                	sd	s0,16(sp)
    80001e18:	e426                	sd	s1,8(sp)
    80001e1a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e1c:	a11ff0ef          	jal	ra,8000182c <myproc>
    80001e20:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e22:	d79fe0ef          	jal	ra,80000b9a <acquire>
  p->state = RUNNABLE;
    80001e26:	478d                	li	a5,3
    80001e28:	cc9c                	sw	a5,24(s1)
  sched();
    80001e2a:	f2fff0ef          	jal	ra,80001d58 <sched>
  release(&p->lock);
    80001e2e:	8526                	mv	a0,s1
    80001e30:	e03fe0ef          	jal	ra,80000c32 <release>
}
    80001e34:	60e2                	ld	ra,24(sp)
    80001e36:	6442                	ld	s0,16(sp)
    80001e38:	64a2                	ld	s1,8(sp)
    80001e3a:	6105                	addi	sp,sp,32
    80001e3c:	8082                	ret

0000000080001e3e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001e3e:	7179                	addi	sp,sp,-48
    80001e40:	f406                	sd	ra,40(sp)
    80001e42:	f022                	sd	s0,32(sp)
    80001e44:	ec26                	sd	s1,24(sp)
    80001e46:	e84a                	sd	s2,16(sp)
    80001e48:	e44e                	sd	s3,8(sp)
    80001e4a:	1800                	addi	s0,sp,48
    80001e4c:	89aa                	mv	s3,a0
    80001e4e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e50:	9ddff0ef          	jal	ra,8000182c <myproc>
    80001e54:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e56:	d45fe0ef          	jal	ra,80000b9a <acquire>
  release(lk);
    80001e5a:	854a                	mv	a0,s2
    80001e5c:	dd7fe0ef          	jal	ra,80000c32 <release>

  // Go to sleep.
  p->chan = chan;
    80001e60:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e64:	4789                	li	a5,2
    80001e66:	cc9c                	sw	a5,24(s1)

  sched();
    80001e68:	ef1ff0ef          	jal	ra,80001d58 <sched>

  // Tidy up.
  p->chan = 0;
    80001e6c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e70:	8526                	mv	a0,s1
    80001e72:	dc1fe0ef          	jal	ra,80000c32 <release>
  acquire(lk);
    80001e76:	854a                	mv	a0,s2
    80001e78:	d23fe0ef          	jal	ra,80000b9a <acquire>
}
    80001e7c:	70a2                	ld	ra,40(sp)
    80001e7e:	7402                	ld	s0,32(sp)
    80001e80:	64e2                	ld	s1,24(sp)
    80001e82:	6942                	ld	s2,16(sp)
    80001e84:	69a2                	ld	s3,8(sp)
    80001e86:	6145                	addi	sp,sp,48
    80001e88:	8082                	ret

0000000080001e8a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e8a:	7139                	addi	sp,sp,-64
    80001e8c:	fc06                	sd	ra,56(sp)
    80001e8e:	f822                	sd	s0,48(sp)
    80001e90:	f426                	sd	s1,40(sp)
    80001e92:	f04a                	sd	s2,32(sp)
    80001e94:	ec4e                	sd	s3,24(sp)
    80001e96:	e852                	sd	s4,16(sp)
    80001e98:	e456                	sd	s5,8(sp)
    80001e9a:	0080                	addi	s0,sp,64
    80001e9c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e9e:	00014497          	auipc	s1,0x14
    80001ea2:	ffa48493          	addi	s1,s1,-6 # 80015e98 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001ea6:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001ea8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001eaa:	0001a917          	auipc	s2,0x1a
    80001eae:	fee90913          	addi	s2,s2,-18 # 8001be98 <tickslock>
    80001eb2:	a801                	j	80001ec2 <wakeup+0x38>
      }
      release(&p->lock);
    80001eb4:	8526                	mv	a0,s1
    80001eb6:	d7dfe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001eba:	18048493          	addi	s1,s1,384
    80001ebe:	03248263          	beq	s1,s2,80001ee2 <wakeup+0x58>
    if(p != myproc()){
    80001ec2:	96bff0ef          	jal	ra,8000182c <myproc>
    80001ec6:	fea48ae3          	beq	s1,a0,80001eba <wakeup+0x30>
      acquire(&p->lock);
    80001eca:	8526                	mv	a0,s1
    80001ecc:	ccffe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001ed0:	4c9c                	lw	a5,24(s1)
    80001ed2:	ff3791e3          	bne	a5,s3,80001eb4 <wakeup+0x2a>
    80001ed6:	709c                	ld	a5,32(s1)
    80001ed8:	fd479ee3          	bne	a5,s4,80001eb4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001edc:	0154ac23          	sw	s5,24(s1)
    80001ee0:	bfd1                	j	80001eb4 <wakeup+0x2a>
    }
  }
}
    80001ee2:	70e2                	ld	ra,56(sp)
    80001ee4:	7442                	ld	s0,48(sp)
    80001ee6:	74a2                	ld	s1,40(sp)
    80001ee8:	7902                	ld	s2,32(sp)
    80001eea:	69e2                	ld	s3,24(sp)
    80001eec:	6a42                	ld	s4,16(sp)
    80001eee:	6aa2                	ld	s5,8(sp)
    80001ef0:	6121                	addi	sp,sp,64
    80001ef2:	8082                	ret

0000000080001ef4 <reparent>:
{
    80001ef4:	7179                	addi	sp,sp,-48
    80001ef6:	f406                	sd	ra,40(sp)
    80001ef8:	f022                	sd	s0,32(sp)
    80001efa:	ec26                	sd	s1,24(sp)
    80001efc:	e84a                	sd	s2,16(sp)
    80001efe:	e44e                	sd	s3,8(sp)
    80001f00:	e052                	sd	s4,0(sp)
    80001f02:	1800                	addi	s0,sp,48
    80001f04:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f06:	00014497          	auipc	s1,0x14
    80001f0a:	f9248493          	addi	s1,s1,-110 # 80015e98 <proc>
      pp->parent = initproc;
    80001f0e:	00006a17          	auipc	s4,0x6
    80001f12:	a0aa0a13          	addi	s4,s4,-1526 # 80007918 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f16:	0001a997          	auipc	s3,0x1a
    80001f1a:	f8298993          	addi	s3,s3,-126 # 8001be98 <tickslock>
    80001f1e:	a029                	j	80001f28 <reparent+0x34>
    80001f20:	18048493          	addi	s1,s1,384
    80001f24:	01348b63          	beq	s1,s3,80001f3a <reparent+0x46>
    if(pp->parent == p){
    80001f28:	7c9c                	ld	a5,56(s1)
    80001f2a:	ff279be3          	bne	a5,s2,80001f20 <reparent+0x2c>
      pp->parent = initproc;
    80001f2e:	000a3503          	ld	a0,0(s4)
    80001f32:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f34:	f57ff0ef          	jal	ra,80001e8a <wakeup>
    80001f38:	b7e5                	j	80001f20 <reparent+0x2c>
}
    80001f3a:	70a2                	ld	ra,40(sp)
    80001f3c:	7402                	ld	s0,32(sp)
    80001f3e:	64e2                	ld	s1,24(sp)
    80001f40:	6942                	ld	s2,16(sp)
    80001f42:	69a2                	ld	s3,8(sp)
    80001f44:	6a02                	ld	s4,0(sp)
    80001f46:	6145                	addi	sp,sp,48
    80001f48:	8082                	ret

0000000080001f4a <exit>:
{
    80001f4a:	7179                	addi	sp,sp,-48
    80001f4c:	f406                	sd	ra,40(sp)
    80001f4e:	f022                	sd	s0,32(sp)
    80001f50:	ec26                	sd	s1,24(sp)
    80001f52:	e84a                	sd	s2,16(sp)
    80001f54:	e44e                	sd	s3,8(sp)
    80001f56:	e052                	sd	s4,0(sp)
    80001f58:	1800                	addi	s0,sp,48
    80001f5a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f5c:	8d1ff0ef          	jal	ra,8000182c <myproc>
    80001f60:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f62:	00006797          	auipc	a5,0x6
    80001f66:	9b67b783          	ld	a5,-1610(a5) # 80007918 <initproc>
    80001f6a:	0d050493          	addi	s1,a0,208
    80001f6e:	15050913          	addi	s2,a0,336
    80001f72:	00a79f63          	bne	a5,a0,80001f90 <exit+0x46>
    panic("init exiting");
    80001f76:	00005517          	auipc	a0,0x5
    80001f7a:	32250513          	addi	a0,a0,802 # 80007298 <digits+0x260>
    80001f7e:	fd8fe0ef          	jal	ra,80000756 <panic>
      fileclose(f);
    80001f82:	791010ef          	jal	ra,80003f12 <fileclose>
      p->ofile[fd] = 0;
    80001f86:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f8a:	04a1                	addi	s1,s1,8
    80001f8c:	01248563          	beq	s1,s2,80001f96 <exit+0x4c>
    if(p->ofile[fd]){
    80001f90:	6088                	ld	a0,0(s1)
    80001f92:	f965                	bnez	a0,80001f82 <exit+0x38>
    80001f94:	bfdd                	j	80001f8a <exit+0x40>
  begin_op();
    80001f96:	361010ef          	jal	ra,80003af6 <begin_op>
  iput(p->cwd);
    80001f9a:	1509b503          	ld	a0,336(s3)
    80001f9e:	44a010ef          	jal	ra,800033e8 <iput>
  end_op();
    80001fa2:	3c5010ef          	jal	ra,80003b66 <end_op>
  p->cwd = 0;
    80001fa6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001faa:	0000e497          	auipc	s1,0xe
    80001fae:	abe48493          	addi	s1,s1,-1346 # 8000fa68 <wait_lock>
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	be7fe0ef          	jal	ra,80000b9a <acquire>
  reparent(p);
    80001fb8:	854e                	mv	a0,s3
    80001fba:	f3bff0ef          	jal	ra,80001ef4 <reparent>
  wakeup(p->parent);
    80001fbe:	0389b503          	ld	a0,56(s3)
    80001fc2:	ec9ff0ef          	jal	ra,80001e8a <wakeup>
  acquire(&p->lock);
    80001fc6:	854e                	mv	a0,s3
    80001fc8:	bd3fe0ef          	jal	ra,80000b9a <acquire>
  p->xstate = status;
    80001fcc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001fd0:	4795                	li	a5,5
    80001fd2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	c5bfe0ef          	jal	ra,80000c32 <release>
  sched();
    80001fdc:	d7dff0ef          	jal	ra,80001d58 <sched>
  panic("zombie exit");
    80001fe0:	00005517          	auipc	a0,0x5
    80001fe4:	2c850513          	addi	a0,a0,712 # 800072a8 <digits+0x270>
    80001fe8:	f6efe0ef          	jal	ra,80000756 <panic>

0000000080001fec <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	1800                	addi	s0,sp,48
    80001ffa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001ffc:	00014497          	auipc	s1,0x14
    80002000:	e9c48493          	addi	s1,s1,-356 # 80015e98 <proc>
    80002004:	0001a997          	auipc	s3,0x1a
    80002008:	e9498993          	addi	s3,s3,-364 # 8001be98 <tickslock>
    acquire(&p->lock);
    8000200c:	8526                	mv	a0,s1
    8000200e:	b8dfe0ef          	jal	ra,80000b9a <acquire>
    if(p->pid == pid){
    80002012:	589c                	lw	a5,48(s1)
    80002014:	01278b63          	beq	a5,s2,8000202a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002018:	8526                	mv	a0,s1
    8000201a:	c19fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000201e:	18048493          	addi	s1,s1,384
    80002022:	ff3495e3          	bne	s1,s3,8000200c <kill+0x20>
  }
  return -1;
    80002026:	557d                	li	a0,-1
    80002028:	a819                	j	8000203e <kill+0x52>
      p->killed = 1;
    8000202a:	4785                	li	a5,1
    8000202c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000202e:	4c98                	lw	a4,24(s1)
    80002030:	4789                	li	a5,2
    80002032:	00f70d63          	beq	a4,a5,8000204c <kill+0x60>
      release(&p->lock);
    80002036:	8526                	mv	a0,s1
    80002038:	bfbfe0ef          	jal	ra,80000c32 <release>
      return 0;
    8000203c:	4501                	li	a0,0
}
    8000203e:	70a2                	ld	ra,40(sp)
    80002040:	7402                	ld	s0,32(sp)
    80002042:	64e2                	ld	s1,24(sp)
    80002044:	6942                	ld	s2,16(sp)
    80002046:	69a2                	ld	s3,8(sp)
    80002048:	6145                	addi	sp,sp,48
    8000204a:	8082                	ret
        p->state = RUNNABLE;
    8000204c:	478d                	li	a5,3
    8000204e:	cc9c                	sw	a5,24(s1)
    80002050:	b7dd                	j	80002036 <kill+0x4a>

0000000080002052 <setkilled>:

void
setkilled(struct proc *p)
{
    80002052:	1101                	addi	sp,sp,-32
    80002054:	ec06                	sd	ra,24(sp)
    80002056:	e822                	sd	s0,16(sp)
    80002058:	e426                	sd	s1,8(sp)
    8000205a:	1000                	addi	s0,sp,32
    8000205c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000205e:	b3dfe0ef          	jal	ra,80000b9a <acquire>
  p->killed = 1;
    80002062:	4785                	li	a5,1
    80002064:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002066:	8526                	mv	a0,s1
    80002068:	bcbfe0ef          	jal	ra,80000c32 <release>
}
    8000206c:	60e2                	ld	ra,24(sp)
    8000206e:	6442                	ld	s0,16(sp)
    80002070:	64a2                	ld	s1,8(sp)
    80002072:	6105                	addi	sp,sp,32
    80002074:	8082                	ret

0000000080002076 <killed>:

int
killed(struct proc *p)
{
    80002076:	1101                	addi	sp,sp,-32
    80002078:	ec06                	sd	ra,24(sp)
    8000207a:	e822                	sd	s0,16(sp)
    8000207c:	e426                	sd	s1,8(sp)
    8000207e:	e04a                	sd	s2,0(sp)
    80002080:	1000                	addi	s0,sp,32
    80002082:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002084:	b17fe0ef          	jal	ra,80000b9a <acquire>
  k = p->killed;
    80002088:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000208c:	8526                	mv	a0,s1
    8000208e:	ba5fe0ef          	jal	ra,80000c32 <release>
  return k;
}
    80002092:	854a                	mv	a0,s2
    80002094:	60e2                	ld	ra,24(sp)
    80002096:	6442                	ld	s0,16(sp)
    80002098:	64a2                	ld	s1,8(sp)
    8000209a:	6902                	ld	s2,0(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret

00000000800020a0 <wait>:
{
    800020a0:	715d                	addi	sp,sp,-80
    800020a2:	e486                	sd	ra,72(sp)
    800020a4:	e0a2                	sd	s0,64(sp)
    800020a6:	fc26                	sd	s1,56(sp)
    800020a8:	f84a                	sd	s2,48(sp)
    800020aa:	f44e                	sd	s3,40(sp)
    800020ac:	f052                	sd	s4,32(sp)
    800020ae:	ec56                	sd	s5,24(sp)
    800020b0:	e85a                	sd	s6,16(sp)
    800020b2:	e45e                	sd	s7,8(sp)
    800020b4:	e062                	sd	s8,0(sp)
    800020b6:	0880                	addi	s0,sp,80
    800020b8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020ba:	f72ff0ef          	jal	ra,8000182c <myproc>
    800020be:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020c0:	0000e517          	auipc	a0,0xe
    800020c4:	9a850513          	addi	a0,a0,-1624 # 8000fa68 <wait_lock>
    800020c8:	ad3fe0ef          	jal	ra,80000b9a <acquire>
    havekids = 0;
    800020cc:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800020ce:	4a15                	li	s4,5
        havekids = 1;
    800020d0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020d2:	0001a997          	auipc	s3,0x1a
    800020d6:	dc698993          	addi	s3,s3,-570 # 8001be98 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020da:	0000ec17          	auipc	s8,0xe
    800020de:	98ec0c13          	addi	s8,s8,-1650 # 8000fa68 <wait_lock>
    havekids = 0;
    800020e2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020e4:	00014497          	auipc	s1,0x14
    800020e8:	db448493          	addi	s1,s1,-588 # 80015e98 <proc>
    800020ec:	a899                	j	80002142 <wait+0xa2>
          pid = pp->pid;
    800020ee:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020f2:	000b0c63          	beqz	s6,8000210a <wait+0x6a>
    800020f6:	4691                	li	a3,4
    800020f8:	02c48613          	addi	a2,s1,44
    800020fc:	85da                	mv	a1,s6
    800020fe:	05093503          	ld	a0,80(s2)
    80002102:	bdeff0ef          	jal	ra,800014e0 <copyout>
    80002106:	00054f63          	bltz	a0,80002124 <wait+0x84>
          freeproc(pp);
    8000210a:	8526                	mv	a0,s1
    8000210c:	893ff0ef          	jal	ra,8000199e <freeproc>
          release(&pp->lock);
    80002110:	8526                	mv	a0,s1
    80002112:	b21fe0ef          	jal	ra,80000c32 <release>
          release(&wait_lock);
    80002116:	0000e517          	auipc	a0,0xe
    8000211a:	95250513          	addi	a0,a0,-1710 # 8000fa68 <wait_lock>
    8000211e:	b15fe0ef          	jal	ra,80000c32 <release>
          return pid;
    80002122:	a891                	j	80002176 <wait+0xd6>
            release(&pp->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	b0dfe0ef          	jal	ra,80000c32 <release>
            release(&wait_lock);
    8000212a:	0000e517          	auipc	a0,0xe
    8000212e:	93e50513          	addi	a0,a0,-1730 # 8000fa68 <wait_lock>
    80002132:	b01fe0ef          	jal	ra,80000c32 <release>
            return -1;
    80002136:	59fd                	li	s3,-1
    80002138:	a83d                	j	80002176 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000213a:	18048493          	addi	s1,s1,384
    8000213e:	03348063          	beq	s1,s3,8000215e <wait+0xbe>
      if(pp->parent == p){
    80002142:	7c9c                	ld	a5,56(s1)
    80002144:	ff279be3          	bne	a5,s2,8000213a <wait+0x9a>
        acquire(&pp->lock);
    80002148:	8526                	mv	a0,s1
    8000214a:	a51fe0ef          	jal	ra,80000b9a <acquire>
        if(pp->state == ZOMBIE){
    8000214e:	4c9c                	lw	a5,24(s1)
    80002150:	f9478fe3          	beq	a5,s4,800020ee <wait+0x4e>
        release(&pp->lock);
    80002154:	8526                	mv	a0,s1
    80002156:	addfe0ef          	jal	ra,80000c32 <release>
        havekids = 1;
    8000215a:	8756                	mv	a4,s5
    8000215c:	bff9                	j	8000213a <wait+0x9a>
    if(!havekids || killed(p)){
    8000215e:	c709                	beqz	a4,80002168 <wait+0xc8>
    80002160:	854a                	mv	a0,s2
    80002162:	f15ff0ef          	jal	ra,80002076 <killed>
    80002166:	c50d                	beqz	a0,80002190 <wait+0xf0>
      release(&wait_lock);
    80002168:	0000e517          	auipc	a0,0xe
    8000216c:	90050513          	addi	a0,a0,-1792 # 8000fa68 <wait_lock>
    80002170:	ac3fe0ef          	jal	ra,80000c32 <release>
      return -1;
    80002174:	59fd                	li	s3,-1
}
    80002176:	854e                	mv	a0,s3
    80002178:	60a6                	ld	ra,72(sp)
    8000217a:	6406                	ld	s0,64(sp)
    8000217c:	74e2                	ld	s1,56(sp)
    8000217e:	7942                	ld	s2,48(sp)
    80002180:	79a2                	ld	s3,40(sp)
    80002182:	7a02                	ld	s4,32(sp)
    80002184:	6ae2                	ld	s5,24(sp)
    80002186:	6b42                	ld	s6,16(sp)
    80002188:	6ba2                	ld	s7,8(sp)
    8000218a:	6c02                	ld	s8,0(sp)
    8000218c:	6161                	addi	sp,sp,80
    8000218e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002190:	85e2                	mv	a1,s8
    80002192:	854a                	mv	a0,s2
    80002194:	cabff0ef          	jal	ra,80001e3e <sleep>
    havekids = 0;
    80002198:	b7a9                	j	800020e2 <wait+0x42>

000000008000219a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000219a:	7179                	addi	sp,sp,-48
    8000219c:	f406                	sd	ra,40(sp)
    8000219e:	f022                	sd	s0,32(sp)
    800021a0:	ec26                	sd	s1,24(sp)
    800021a2:	e84a                	sd	s2,16(sp)
    800021a4:	e44e                	sd	s3,8(sp)
    800021a6:	e052                	sd	s4,0(sp)
    800021a8:	1800                	addi	s0,sp,48
    800021aa:	84aa                	mv	s1,a0
    800021ac:	892e                	mv	s2,a1
    800021ae:	89b2                	mv	s3,a2
    800021b0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021b2:	e7aff0ef          	jal	ra,8000182c <myproc>
  if(user_dst){
    800021b6:	cc99                	beqz	s1,800021d4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800021b8:	86d2                	mv	a3,s4
    800021ba:	864e                	mv	a2,s3
    800021bc:	85ca                	mv	a1,s2
    800021be:	6928                	ld	a0,80(a0)
    800021c0:	b20ff0ef          	jal	ra,800014e0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800021c4:	70a2                	ld	ra,40(sp)
    800021c6:	7402                	ld	s0,32(sp)
    800021c8:	64e2                	ld	s1,24(sp)
    800021ca:	6942                	ld	s2,16(sp)
    800021cc:	69a2                	ld	s3,8(sp)
    800021ce:	6a02                	ld	s4,0(sp)
    800021d0:	6145                	addi	sp,sp,48
    800021d2:	8082                	ret
    memmove((char *)dst, src, len);
    800021d4:	000a061b          	sext.w	a2,s4
    800021d8:	85ce                	mv	a1,s3
    800021da:	854a                	mv	a0,s2
    800021dc:	aeffe0ef          	jal	ra,80000cca <memmove>
    return 0;
    800021e0:	8526                	mv	a0,s1
    800021e2:	b7cd                	j	800021c4 <either_copyout+0x2a>

00000000800021e4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021e4:	7179                	addi	sp,sp,-48
    800021e6:	f406                	sd	ra,40(sp)
    800021e8:	f022                	sd	s0,32(sp)
    800021ea:	ec26                	sd	s1,24(sp)
    800021ec:	e84a                	sd	s2,16(sp)
    800021ee:	e44e                	sd	s3,8(sp)
    800021f0:	e052                	sd	s4,0(sp)
    800021f2:	1800                	addi	s0,sp,48
    800021f4:	892a                	mv	s2,a0
    800021f6:	84ae                	mv	s1,a1
    800021f8:	89b2                	mv	s3,a2
    800021fa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021fc:	e30ff0ef          	jal	ra,8000182c <myproc>
  if(user_src){
    80002200:	cc99                	beqz	s1,8000221e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002202:	86d2                	mv	a3,s4
    80002204:	864e                	mv	a2,s3
    80002206:	85ca                	mv	a1,s2
    80002208:	6928                	ld	a0,80(a0)
    8000220a:	b8eff0ef          	jal	ra,80001598 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000220e:	70a2                	ld	ra,40(sp)
    80002210:	7402                	ld	s0,32(sp)
    80002212:	64e2                	ld	s1,24(sp)
    80002214:	6942                	ld	s2,16(sp)
    80002216:	69a2                	ld	s3,8(sp)
    80002218:	6a02                	ld	s4,0(sp)
    8000221a:	6145                	addi	sp,sp,48
    8000221c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000221e:	000a061b          	sext.w	a2,s4
    80002222:	85ce                	mv	a1,s3
    80002224:	854a                	mv	a0,s2
    80002226:	aa5fe0ef          	jal	ra,80000cca <memmove>
    return 0;
    8000222a:	8526                	mv	a0,s1
    8000222c:	b7cd                	j	8000220e <either_copyin+0x2a>

000000008000222e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000222e:	715d                	addi	sp,sp,-80
    80002230:	e486                	sd	ra,72(sp)
    80002232:	e0a2                	sd	s0,64(sp)
    80002234:	fc26                	sd	s1,56(sp)
    80002236:	f84a                	sd	s2,48(sp)
    80002238:	f44e                	sd	s3,40(sp)
    8000223a:	f052                	sd	s4,32(sp)
    8000223c:	ec56                	sd	s5,24(sp)
    8000223e:	e85a                	sd	s6,16(sp)
    80002240:	e45e                	sd	s7,8(sp)
    80002242:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002244:	00005517          	auipc	a0,0x5
    80002248:	e7c50513          	addi	a0,a0,-388 # 800070c0 <digits+0x88>
    8000224c:	a56fe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002250:	00014497          	auipc	s1,0x14
    80002254:	da048493          	addi	s1,s1,-608 # 80015ff0 <proc+0x158>
    80002258:	0001a917          	auipc	s2,0x1a
    8000225c:	d9890913          	addi	s2,s2,-616 # 8001bff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002260:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002262:	00005997          	auipc	s3,0x5
    80002266:	05698993          	addi	s3,s3,86 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    8000226a:	00005a97          	auipc	s5,0x5
    8000226e:	056a8a93          	addi	s5,s5,86 # 800072c0 <digits+0x288>
    printf("\n");
    80002272:	00005a17          	auipc	s4,0x5
    80002276:	e4ea0a13          	addi	s4,s4,-434 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000227a:	00005b97          	auipc	s7,0x5
    8000227e:	086b8b93          	addi	s7,s7,134 # 80007300 <states.0>
    80002282:	a829                	j	8000229c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002284:	ed86a583          	lw	a1,-296(a3)
    80002288:	8556                	mv	a0,s5
    8000228a:	a18fe0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    8000228e:	8552                	mv	a0,s4
    80002290:	a12fe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002294:	18048493          	addi	s1,s1,384
    80002298:	03248163          	beq	s1,s2,800022ba <procdump+0x8c>
    if(p->state == UNUSED)
    8000229c:	86a6                	mv	a3,s1
    8000229e:	ec04a783          	lw	a5,-320(s1)
    800022a2:	dbed                	beqz	a5,80002294 <procdump+0x66>
      state = "???";
    800022a4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022a6:	fcfb6fe3          	bltu	s6,a5,80002284 <procdump+0x56>
    800022aa:	1782                	slli	a5,a5,0x20
    800022ac:	9381                	srli	a5,a5,0x20
    800022ae:	078e                	slli	a5,a5,0x3
    800022b0:	97de                	add	a5,a5,s7
    800022b2:	6390                	ld	a2,0(a5)
    800022b4:	fa61                	bnez	a2,80002284 <procdump+0x56>
      state = "???";
    800022b6:	864e                	mv	a2,s3
    800022b8:	b7f1                	j	80002284 <procdump+0x56>
  }
}
    800022ba:	60a6                	ld	ra,72(sp)
    800022bc:	6406                	ld	s0,64(sp)
    800022be:	74e2                	ld	s1,56(sp)
    800022c0:	7942                	ld	s2,48(sp)
    800022c2:	79a2                	ld	s3,40(sp)
    800022c4:	7a02                	ld	s4,32(sp)
    800022c6:	6ae2                	ld	s5,24(sp)
    800022c8:	6b42                	ld	s6,16(sp)
    800022ca:	6ba2                	ld	s7,8(sp)
    800022cc:	6161                	addi	sp,sp,80
    800022ce:	8082                	ret

00000000800022d0 <initprocstat>:



void
initprocstat(struct proc *p)
{
    800022d0:	1141                	addi	sp,sp,-16
    800022d2:	e422                	sd	s0,8(sp)
    800022d4:	0800                	addi	s0,sp,16
  p->creation_time = ticks;
    800022d6:	00005797          	auipc	a5,0x5
    800022da:	64a7e783          	lwu	a5,1610(a5) # 80007920 <ticks>
    800022de:	16f53423          	sd	a5,360(a0)
  p->cpu_usage = 0;
    800022e2:	16053823          	sd	zero,368(a0)
  p->total_runtime = 0;
    800022e6:	16053c23          	sd	zero,376(a0)
}
    800022ea:	6422                	ld	s0,8(sp)
    800022ec:	0141                	addi	sp,sp,16
    800022ee:	8082                	ret

00000000800022f0 <updateprocstat>:

// Met à jour les statistiques du processus
void
updateprocstat(struct proc *p)
{
    800022f0:	1141                	addi	sp,sp,-16
    800022f2:	e422                	sd	s0,8(sp)
    800022f4:	0800                	addi	s0,sp,16
  if(p->state == RUNNING) {
    800022f6:	4d18                	lw	a4,24(a0)
    800022f8:	4791                	li	a5,4
    800022fa:	00f70e63          	beq	a4,a5,80002316 <updateprocstat+0x26>
    p->cpu_usage++;
  }
  p->total_runtime = ticks - p->creation_time;
    800022fe:	00005797          	auipc	a5,0x5
    80002302:	6227e783          	lwu	a5,1570(a5) # 80007920 <ticks>
    80002306:	16853703          	ld	a4,360(a0)
    8000230a:	8f99                	sub	a5,a5,a4
    8000230c:	16f53c23          	sd	a5,376(a0)
}
    80002310:	6422                	ld	s0,8(sp)
    80002312:	0141                	addi	sp,sp,16
    80002314:	8082                	ret
    p->cpu_usage++;
    80002316:	17053783          	ld	a5,368(a0)
    8000231a:	0785                	addi	a5,a5,1
    8000231c:	16f53823          	sd	a5,368(a0)
    80002320:	bff9                	j	800022fe <updateprocstat+0xe>

0000000080002322 <getprocs>:

// Fonction pour obtenir les statistiques des processus
int
getprocs(struct proc_stat *stats, int max)
{
    80002322:	7139                	addi	sp,sp,-64
    80002324:	fc06                	sd	ra,56(sp)
    80002326:	f822                	sd	s0,48(sp)
    80002328:	f426                	sd	s1,40(sp)
    8000232a:	f04a                	sd	s2,32(sp)
    8000232c:	ec4e                	sd	s3,24(sp)
    8000232e:	e852                	sd	s4,16(sp)
    80002330:	e456                	sd	s5,8(sp)
    80002332:	e05a                	sd	s6,0(sp)
    80002334:	0080                	addi	s0,sp,64
  struct proc *p;
  int count = 0;
  
  for(p = proc; p < &proc[NPROC] && count < max; p++) {
    80002336:	06b05b63          	blez	a1,800023ac <getprocs+0x8a>
    8000233a:	8b2a                	mv	s6,a0
    8000233c:	8a2e                	mv	s4,a1
  int count = 0;
    8000233e:	4981                	li	s3,0
  for(p = proc; p < &proc[NPROC] && count < max; p++) {
    80002340:	00014497          	auipc	s1,0x14
    80002344:	b5848493          	addi	s1,s1,-1192 # 80015e98 <proc>
    80002348:	0001aa97          	auipc	s5,0x1a
    8000234c:	b50a8a93          	addi	s5,s5,-1200 # 8001be98 <tickslock>
    80002350:	a811                	j	80002364 <getprocs+0x42>
      stats[count].cpu_usage = p->cpu_usage;
      stats[count].runtime = p->total_runtime;
      stats[count].memory = p->sz;
      count++;
    }
    release(&p->lock);
    80002352:	8526                	mv	a0,s1
    80002354:	8dffe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC] && count < max; p++) {
    80002358:	18048493          	addi	s1,s1,384
    8000235c:	05548963          	beq	s1,s5,800023ae <getprocs+0x8c>
    80002360:	0549d763          	bge	s3,s4,800023ae <getprocs+0x8c>
    acquire(&p->lock);
    80002364:	8526                	mv	a0,s1
    80002366:	835fe0ef          	jal	ra,80000b9a <acquire>
    if(p->state != UNUSED) {
    8000236a:	4c9c                	lw	a5,24(s1)
    8000236c:	d3fd                	beqz	a5,80002352 <getprocs+0x30>
      stats[count].pid = p->pid;
    8000236e:	00199913          	slli	s2,s3,0x1
    80002372:	994e                	add	s2,s2,s3
    80002374:	0912                	slli	s2,s2,0x4
    80002376:	995a                	add	s2,s2,s6
    80002378:	589c                	lw	a5,48(s1)
    8000237a:	00f92023          	sw	a5,0(s2)
      stats[count].state = p->state;
    8000237e:	4c9c                	lw	a5,24(s1)
    80002380:	00f92223          	sw	a5,4(s2)
      safestrcpy(stats[count].name, p->name, sizeof(stats[count].name));
    80002384:	4641                	li	a2,16
    80002386:	15848593          	addi	a1,s1,344
    8000238a:	00890513          	addi	a0,s2,8
    8000238e:	a27fe0ef          	jal	ra,80000db4 <safestrcpy>
      stats[count].cpu_usage = p->cpu_usage;
    80002392:	1704b783          	ld	a5,368(s1)
    80002396:	00f93c23          	sd	a5,24(s2)
      stats[count].runtime = p->total_runtime;
    8000239a:	1784b783          	ld	a5,376(s1)
    8000239e:	02f93023          	sd	a5,32(s2)
      stats[count].memory = p->sz;
    800023a2:	64bc                	ld	a5,72(s1)
    800023a4:	02f93423          	sd	a5,40(s2)
      count++;
    800023a8:	2985                	addiw	s3,s3,1
    800023aa:	b765                	j	80002352 <getprocs+0x30>
  int count = 0;
    800023ac:	4981                	li	s3,0
  }
  return count;
}
    800023ae:	854e                	mv	a0,s3
    800023b0:	70e2                	ld	ra,56(sp)
    800023b2:	7442                	ld	s0,48(sp)
    800023b4:	74a2                	ld	s1,40(sp)
    800023b6:	7902                	ld	s2,32(sp)
    800023b8:	69e2                	ld	s3,24(sp)
    800023ba:	6a42                	ld	s4,16(sp)
    800023bc:	6aa2                	ld	s5,8(sp)
    800023be:	6b02                	ld	s6,0(sp)
    800023c0:	6121                	addi	sp,sp,64
    800023c2:	8082                	ret

00000000800023c4 <swtch>:
    800023c4:	00153023          	sd	ra,0(a0)
    800023c8:	00253423          	sd	sp,8(a0)
    800023cc:	e900                	sd	s0,16(a0)
    800023ce:	ed04                	sd	s1,24(a0)
    800023d0:	03253023          	sd	s2,32(a0)
    800023d4:	03353423          	sd	s3,40(a0)
    800023d8:	03453823          	sd	s4,48(a0)
    800023dc:	03553c23          	sd	s5,56(a0)
    800023e0:	05653023          	sd	s6,64(a0)
    800023e4:	05753423          	sd	s7,72(a0)
    800023e8:	05853823          	sd	s8,80(a0)
    800023ec:	05953c23          	sd	s9,88(a0)
    800023f0:	07a53023          	sd	s10,96(a0)
    800023f4:	07b53423          	sd	s11,104(a0)
    800023f8:	0005b083          	ld	ra,0(a1)
    800023fc:	0085b103          	ld	sp,8(a1)
    80002400:	6980                	ld	s0,16(a1)
    80002402:	6d84                	ld	s1,24(a1)
    80002404:	0205b903          	ld	s2,32(a1)
    80002408:	0285b983          	ld	s3,40(a1)
    8000240c:	0305ba03          	ld	s4,48(a1)
    80002410:	0385ba83          	ld	s5,56(a1)
    80002414:	0405bb03          	ld	s6,64(a1)
    80002418:	0485bb83          	ld	s7,72(a1)
    8000241c:	0505bc03          	ld	s8,80(a1)
    80002420:	0585bc83          	ld	s9,88(a1)
    80002424:	0605bd03          	ld	s10,96(a1)
    80002428:	0685bd83          	ld	s11,104(a1)
    8000242c:	8082                	ret

000000008000242e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000242e:	1141                	addi	sp,sp,-16
    80002430:	e406                	sd	ra,8(sp)
    80002432:	e022                	sd	s0,0(sp)
    80002434:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002436:	00005597          	auipc	a1,0x5
    8000243a:	efa58593          	addi	a1,a1,-262 # 80007330 <states.0+0x30>
    8000243e:	0001a517          	auipc	a0,0x1a
    80002442:	a5a50513          	addi	a0,a0,-1446 # 8001be98 <tickslock>
    80002446:	ed4fe0ef          	jal	ra,80000b1a <initlock>
}
    8000244a:	60a2                	ld	ra,8(sp)
    8000244c:	6402                	ld	s0,0(sp)
    8000244e:	0141                	addi	sp,sp,16
    80002450:	8082                	ret

0000000080002452 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002452:	1141                	addi	sp,sp,-16
    80002454:	e422                	sd	s0,8(sp)
    80002456:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002458:	00003797          	auipc	a5,0x3
    8000245c:	e0878793          	addi	a5,a5,-504 # 80005260 <kernelvec>
    80002460:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002464:	6422                	ld	s0,8(sp)
    80002466:	0141                	addi	sp,sp,16
    80002468:	8082                	ret

000000008000246a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000246a:	1141                	addi	sp,sp,-16
    8000246c:	e406                	sd	ra,8(sp)
    8000246e:	e022                	sd	s0,0(sp)
    80002470:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002472:	bbaff0ef          	jal	ra,8000182c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002476:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000247a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000247c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002480:	00004617          	auipc	a2,0x4
    80002484:	b8060613          	addi	a2,a2,-1152 # 80006000 <_trampoline>
    80002488:	00004697          	auipc	a3,0x4
    8000248c:	b7868693          	addi	a3,a3,-1160 # 80006000 <_trampoline>
    80002490:	8e91                	sub	a3,a3,a2
    80002492:	040007b7          	lui	a5,0x4000
    80002496:	17fd                	addi	a5,a5,-1
    80002498:	07b2                	slli	a5,a5,0xc
    8000249a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249c:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024a0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024a2:	180026f3          	csrr	a3,satp
    800024a6:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024a8:	6d38                	ld	a4,88(a0)
    800024aa:	6134                	ld	a3,64(a0)
    800024ac:	6585                	lui	a1,0x1
    800024ae:	96ae                	add	a3,a3,a1
    800024b0:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024b2:	6d38                	ld	a4,88(a0)
    800024b4:	00000697          	auipc	a3,0x0
    800024b8:	10c68693          	addi	a3,a3,268 # 800025c0 <usertrap>
    800024bc:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024be:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024c0:	8692                	mv	a3,tp
    800024c2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024c4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024c8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024cc:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024d0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024d4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024d6:	6f18                	ld	a4,24(a4)
    800024d8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024dc:	6928                	ld	a0,80(a0)
    800024de:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800024e0:	00004717          	auipc	a4,0x4
    800024e4:	bbc70713          	addi	a4,a4,-1092 # 8000609c <userret>
    800024e8:	8f11                	sub	a4,a4,a2
    800024ea:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800024ec:	577d                	li	a4,-1
    800024ee:	177e                	slli	a4,a4,0x3f
    800024f0:	8d59                	or	a0,a0,a4
    800024f2:	9782                	jalr	a5
}
    800024f4:	60a2                	ld	ra,8(sp)
    800024f6:	6402                	ld	s0,0(sp)
    800024f8:	0141                	addi	sp,sp,16
    800024fa:	8082                	ret

00000000800024fc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024fc:	1101                	addi	sp,sp,-32
    800024fe:	ec06                	sd	ra,24(sp)
    80002500:	e822                	sd	s0,16(sp)
    80002502:	e426                	sd	s1,8(sp)
    80002504:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002506:	afaff0ef          	jal	ra,80001800 <cpuid>
    8000250a:	cd19                	beqz	a0,80002528 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000250c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002510:	000f4737          	lui	a4,0xf4
    80002514:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002518:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000251a:	14d79073          	csrw	0x14d,a5
}
    8000251e:	60e2                	ld	ra,24(sp)
    80002520:	6442                	ld	s0,16(sp)
    80002522:	64a2                	ld	s1,8(sp)
    80002524:	6105                	addi	sp,sp,32
    80002526:	8082                	ret
    acquire(&tickslock);
    80002528:	0001a497          	auipc	s1,0x1a
    8000252c:	97048493          	addi	s1,s1,-1680 # 8001be98 <tickslock>
    80002530:	8526                	mv	a0,s1
    80002532:	e68fe0ef          	jal	ra,80000b9a <acquire>
    ticks++;
    80002536:	00005517          	auipc	a0,0x5
    8000253a:	3ea50513          	addi	a0,a0,1002 # 80007920 <ticks>
    8000253e:	411c                	lw	a5,0(a0)
    80002540:	2785                	addiw	a5,a5,1
    80002542:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002544:	947ff0ef          	jal	ra,80001e8a <wakeup>
    release(&tickslock);
    80002548:	8526                	mv	a0,s1
    8000254a:	ee8fe0ef          	jal	ra,80000c32 <release>
    8000254e:	bf7d                	j	8000250c <clockintr+0x10>

0000000080002550 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000255a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000255e:	57fd                	li	a5,-1
    80002560:	17fe                	slli	a5,a5,0x3f
    80002562:	07a5                	addi	a5,a5,9
    80002564:	00f70d63          	beq	a4,a5,8000257e <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002568:	57fd                	li	a5,-1
    8000256a:	17fe                	slli	a5,a5,0x3f
    8000256c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000256e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002570:	04f70463          	beq	a4,a5,800025b8 <devintr+0x68>
  }
}
    80002574:	60e2                	ld	ra,24(sp)
    80002576:	6442                	ld	s0,16(sp)
    80002578:	64a2                	ld	s1,8(sp)
    8000257a:	6105                	addi	sp,sp,32
    8000257c:	8082                	ret
    int irq = plic_claim();
    8000257e:	58b020ef          	jal	ra,80005308 <plic_claim>
    80002582:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002584:	47a9                	li	a5,10
    80002586:	02f50363          	beq	a0,a5,800025ac <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000258a:	4785                	li	a5,1
    8000258c:	02f50363          	beq	a0,a5,800025b2 <devintr+0x62>
    return 1;
    80002590:	4505                	li	a0,1
    } else if(irq){
    80002592:	d0ed                	beqz	s1,80002574 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002594:	85a6                	mv	a1,s1
    80002596:	00005517          	auipc	a0,0x5
    8000259a:	da250513          	addi	a0,a0,-606 # 80007338 <states.0+0x38>
    8000259e:	f05fd0ef          	jal	ra,800004a2 <printf>
      plic_complete(irq);
    800025a2:	8526                	mv	a0,s1
    800025a4:	585020ef          	jal	ra,80005328 <plic_complete>
    return 1;
    800025a8:	4505                	li	a0,1
    800025aa:	b7e9                	j	80002574 <devintr+0x24>
      uartintr();
    800025ac:	c02fe0ef          	jal	ra,800009ae <uartintr>
    800025b0:	bfcd                	j	800025a2 <devintr+0x52>
      virtio_disk_intr();
    800025b2:	1e6030ef          	jal	ra,80005798 <virtio_disk_intr>
    800025b6:	b7f5                	j	800025a2 <devintr+0x52>
    clockintr();
    800025b8:	f45ff0ef          	jal	ra,800024fc <clockintr>
    return 2;
    800025bc:	4509                	li	a0,2
    800025be:	bf5d                	j	80002574 <devintr+0x24>

00000000800025c0 <usertrap>:
{
    800025c0:	1101                	addi	sp,sp,-32
    800025c2:	ec06                	sd	ra,24(sp)
    800025c4:	e822                	sd	s0,16(sp)
    800025c6:	e426                	sd	s1,8(sp)
    800025c8:	e04a                	sd	s2,0(sp)
    800025ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025cc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025d0:	1007f793          	andi	a5,a5,256
    800025d4:	ef85                	bnez	a5,8000260c <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025d6:	00003797          	auipc	a5,0x3
    800025da:	c8a78793          	addi	a5,a5,-886 # 80005260 <kernelvec>
    800025de:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025e2:	a4aff0ef          	jal	ra,8000182c <myproc>
    800025e6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025e8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025ea:	14102773          	csrr	a4,sepc
    800025ee:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025f0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025f4:	47a1                	li	a5,8
    800025f6:	02f70163          	beq	a4,a5,80002618 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800025fa:	f57ff0ef          	jal	ra,80002550 <devintr>
    800025fe:	892a                	mv	s2,a0
    80002600:	c135                	beqz	a0,80002664 <usertrap+0xa4>
  if(killed(p))
    80002602:	8526                	mv	a0,s1
    80002604:	a73ff0ef          	jal	ra,80002076 <killed>
    80002608:	cd1d                	beqz	a0,80002646 <usertrap+0x86>
    8000260a:	a81d                	j	80002640 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000260c:	00005517          	auipc	a0,0x5
    80002610:	d4c50513          	addi	a0,a0,-692 # 80007358 <states.0+0x58>
    80002614:	942fe0ef          	jal	ra,80000756 <panic>
    if(killed(p))
    80002618:	a5fff0ef          	jal	ra,80002076 <killed>
    8000261c:	e121                	bnez	a0,8000265c <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000261e:	6cb8                	ld	a4,88(s1)
    80002620:	6f1c                	ld	a5,24(a4)
    80002622:	0791                	addi	a5,a5,4
    80002624:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002626:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000262a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000262e:	10079073          	csrw	sstatus,a5
    syscall();
    80002632:	248000ef          	jal	ra,8000287a <syscall>
  if(killed(p))
    80002636:	8526                	mv	a0,s1
    80002638:	a3fff0ef          	jal	ra,80002076 <killed>
    8000263c:	c901                	beqz	a0,8000264c <usertrap+0x8c>
    8000263e:	4901                	li	s2,0
    exit(-1);
    80002640:	557d                	li	a0,-1
    80002642:	909ff0ef          	jal	ra,80001f4a <exit>
  if(which_dev == 2)
    80002646:	4789                	li	a5,2
    80002648:	04f90563          	beq	s2,a5,80002692 <usertrap+0xd2>
  usertrapret();
    8000264c:	e1fff0ef          	jal	ra,8000246a <usertrapret>
}
    80002650:	60e2                	ld	ra,24(sp)
    80002652:	6442                	ld	s0,16(sp)
    80002654:	64a2                	ld	s1,8(sp)
    80002656:	6902                	ld	s2,0(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret
      exit(-1);
    8000265c:	557d                	li	a0,-1
    8000265e:	8edff0ef          	jal	ra,80001f4a <exit>
    80002662:	bf75                	j	8000261e <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002664:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002668:	5890                	lw	a2,48(s1)
    8000266a:	00005517          	auipc	a0,0x5
    8000266e:	d0e50513          	addi	a0,a0,-754 # 80007378 <states.0+0x78>
    80002672:	e31fd0ef          	jal	ra,800004a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002676:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000267a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000267e:	00005517          	auipc	a0,0x5
    80002682:	d2a50513          	addi	a0,a0,-726 # 800073a8 <states.0+0xa8>
    80002686:	e1dfd0ef          	jal	ra,800004a2 <printf>
    setkilled(p);
    8000268a:	8526                	mv	a0,s1
    8000268c:	9c7ff0ef          	jal	ra,80002052 <setkilled>
    80002690:	b75d                	j	80002636 <usertrap+0x76>
    yield();
    80002692:	f80ff0ef          	jal	ra,80001e12 <yield>
    80002696:	bf5d                	j	8000264c <usertrap+0x8c>

0000000080002698 <kerneltrap>:
{
    80002698:	7179                	addi	sp,sp,-48
    8000269a:	f406                	sd	ra,40(sp)
    8000269c:	f022                	sd	s0,32(sp)
    8000269e:	ec26                	sd	s1,24(sp)
    800026a0:	e84a                	sd	s2,16(sp)
    800026a2:	e44e                	sd	s3,8(sp)
    800026a4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026a6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026aa:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026ae:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026b2:	1004f793          	andi	a5,s1,256
    800026b6:	c795                	beqz	a5,800026e2 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026bc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026be:	eb85                	bnez	a5,800026ee <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026c0:	e91ff0ef          	jal	ra,80002550 <devintr>
    800026c4:	c91d                	beqz	a0,800026fa <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026c6:	4789                	li	a5,2
    800026c8:	04f50a63          	beq	a0,a5,8000271c <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026cc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026d0:	10049073          	csrw	sstatus,s1
}
    800026d4:	70a2                	ld	ra,40(sp)
    800026d6:	7402                	ld	s0,32(sp)
    800026d8:	64e2                	ld	s1,24(sp)
    800026da:	6942                	ld	s2,16(sp)
    800026dc:	69a2                	ld	s3,8(sp)
    800026de:	6145                	addi	sp,sp,48
    800026e0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026e2:	00005517          	auipc	a0,0x5
    800026e6:	cee50513          	addi	a0,a0,-786 # 800073d0 <states.0+0xd0>
    800026ea:	86cfe0ef          	jal	ra,80000756 <panic>
    panic("kerneltrap: interrupts enabled");
    800026ee:	00005517          	auipc	a0,0x5
    800026f2:	d0a50513          	addi	a0,a0,-758 # 800073f8 <states.0+0xf8>
    800026f6:	860fe0ef          	jal	ra,80000756 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026fa:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026fe:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002702:	85ce                	mv	a1,s3
    80002704:	00005517          	auipc	a0,0x5
    80002708:	d1450513          	addi	a0,a0,-748 # 80007418 <states.0+0x118>
    8000270c:	d97fd0ef          	jal	ra,800004a2 <printf>
    panic("kerneltrap");
    80002710:	00005517          	auipc	a0,0x5
    80002714:	d3050513          	addi	a0,a0,-720 # 80007440 <states.0+0x140>
    80002718:	83efe0ef          	jal	ra,80000756 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000271c:	910ff0ef          	jal	ra,8000182c <myproc>
    80002720:	d555                	beqz	a0,800026cc <kerneltrap+0x34>
    yield();
    80002722:	ef0ff0ef          	jal	ra,80001e12 <yield>
    80002726:	b75d                	j	800026cc <kerneltrap+0x34>

0000000080002728 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002728:	1101                	addi	sp,sp,-32
    8000272a:	ec06                	sd	ra,24(sp)
    8000272c:	e822                	sd	s0,16(sp)
    8000272e:	e426                	sd	s1,8(sp)
    80002730:	1000                	addi	s0,sp,32
    80002732:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002734:	8f8ff0ef          	jal	ra,8000182c <myproc>
  switch (n) {
    80002738:	4795                	li	a5,5
    8000273a:	0497e163          	bltu	a5,s1,8000277c <argraw+0x54>
    8000273e:	048a                	slli	s1,s1,0x2
    80002740:	00005717          	auipc	a4,0x5
    80002744:	d3870713          	addi	a4,a4,-712 # 80007478 <states.0+0x178>
    80002748:	94ba                	add	s1,s1,a4
    8000274a:	409c                	lw	a5,0(s1)
    8000274c:	97ba                	add	a5,a5,a4
    8000274e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002750:	6d3c                	ld	a5,88(a0)
    80002752:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002754:	60e2                	ld	ra,24(sp)
    80002756:	6442                	ld	s0,16(sp)
    80002758:	64a2                	ld	s1,8(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret
    return p->trapframe->a1;
    8000275e:	6d3c                	ld	a5,88(a0)
    80002760:	7fa8                	ld	a0,120(a5)
    80002762:	bfcd                	j	80002754 <argraw+0x2c>
    return p->trapframe->a2;
    80002764:	6d3c                	ld	a5,88(a0)
    80002766:	63c8                	ld	a0,128(a5)
    80002768:	b7f5                	j	80002754 <argraw+0x2c>
    return p->trapframe->a3;
    8000276a:	6d3c                	ld	a5,88(a0)
    8000276c:	67c8                	ld	a0,136(a5)
    8000276e:	b7dd                	j	80002754 <argraw+0x2c>
    return p->trapframe->a4;
    80002770:	6d3c                	ld	a5,88(a0)
    80002772:	6bc8                	ld	a0,144(a5)
    80002774:	b7c5                	j	80002754 <argraw+0x2c>
    return p->trapframe->a5;
    80002776:	6d3c                	ld	a5,88(a0)
    80002778:	6fc8                	ld	a0,152(a5)
    8000277a:	bfe9                	j	80002754 <argraw+0x2c>
  panic("argraw");
    8000277c:	00005517          	auipc	a0,0x5
    80002780:	cd450513          	addi	a0,a0,-812 # 80007450 <states.0+0x150>
    80002784:	fd3fd0ef          	jal	ra,80000756 <panic>

0000000080002788 <fetchaddr>:
{
    80002788:	1101                	addi	sp,sp,-32
    8000278a:	ec06                	sd	ra,24(sp)
    8000278c:	e822                	sd	s0,16(sp)
    8000278e:	e426                	sd	s1,8(sp)
    80002790:	e04a                	sd	s2,0(sp)
    80002792:	1000                	addi	s0,sp,32
    80002794:	84aa                	mv	s1,a0
    80002796:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002798:	894ff0ef          	jal	ra,8000182c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000279c:	653c                	ld	a5,72(a0)
    8000279e:	02f4f663          	bgeu	s1,a5,800027ca <fetchaddr+0x42>
    800027a2:	00848713          	addi	a4,s1,8
    800027a6:	02e7e463          	bltu	a5,a4,800027ce <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027aa:	46a1                	li	a3,8
    800027ac:	8626                	mv	a2,s1
    800027ae:	85ca                	mv	a1,s2
    800027b0:	6928                	ld	a0,80(a0)
    800027b2:	de7fe0ef          	jal	ra,80001598 <copyin>
    800027b6:	00a03533          	snez	a0,a0
    800027ba:	40a00533          	neg	a0,a0
}
    800027be:	60e2                	ld	ra,24(sp)
    800027c0:	6442                	ld	s0,16(sp)
    800027c2:	64a2                	ld	s1,8(sp)
    800027c4:	6902                	ld	s2,0(sp)
    800027c6:	6105                	addi	sp,sp,32
    800027c8:	8082                	ret
    return -1;
    800027ca:	557d                	li	a0,-1
    800027cc:	bfcd                	j	800027be <fetchaddr+0x36>
    800027ce:	557d                	li	a0,-1
    800027d0:	b7fd                	j	800027be <fetchaddr+0x36>

00000000800027d2 <fetchstr>:
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	1800                	addi	s0,sp,48
    800027e0:	892a                	mv	s2,a0
    800027e2:	84ae                	mv	s1,a1
    800027e4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800027e6:	846ff0ef          	jal	ra,8000182c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800027ea:	86ce                	mv	a3,s3
    800027ec:	864a                	mv	a2,s2
    800027ee:	85a6                	mv	a1,s1
    800027f0:	6928                	ld	a0,80(a0)
    800027f2:	e2dfe0ef          	jal	ra,8000161e <copyinstr>
    800027f6:	00054c63          	bltz	a0,8000280e <fetchstr+0x3c>
  return strlen(buf);
    800027fa:	8526                	mv	a0,s1
    800027fc:	deafe0ef          	jal	ra,80000de6 <strlen>
}
    80002800:	70a2                	ld	ra,40(sp)
    80002802:	7402                	ld	s0,32(sp)
    80002804:	64e2                	ld	s1,24(sp)
    80002806:	6942                	ld	s2,16(sp)
    80002808:	69a2                	ld	s3,8(sp)
    8000280a:	6145                	addi	sp,sp,48
    8000280c:	8082                	ret
    return -1;
    8000280e:	557d                	li	a0,-1
    80002810:	bfc5                	j	80002800 <fetchstr+0x2e>

0000000080002812 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002812:	1101                	addi	sp,sp,-32
    80002814:	ec06                	sd	ra,24(sp)
    80002816:	e822                	sd	s0,16(sp)
    80002818:	e426                	sd	s1,8(sp)
    8000281a:	1000                	addi	s0,sp,32
    8000281c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000281e:	f0bff0ef          	jal	ra,80002728 <argraw>
    80002822:	c088                	sw	a0,0(s1)
}
    80002824:	60e2                	ld	ra,24(sp)
    80002826:	6442                	ld	s0,16(sp)
    80002828:	64a2                	ld	s1,8(sp)
    8000282a:	6105                	addi	sp,sp,32
    8000282c:	8082                	ret

000000008000282e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	1000                	addi	s0,sp,32
    80002838:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000283a:	eefff0ef          	jal	ra,80002728 <argraw>
    8000283e:	e088                	sd	a0,0(s1)
}
    80002840:	60e2                	ld	ra,24(sp)
    80002842:	6442                	ld	s0,16(sp)
    80002844:	64a2                	ld	s1,8(sp)
    80002846:	6105                	addi	sp,sp,32
    80002848:	8082                	ret

000000008000284a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000284a:	7179                	addi	sp,sp,-48
    8000284c:	f406                	sd	ra,40(sp)
    8000284e:	f022                	sd	s0,32(sp)
    80002850:	ec26                	sd	s1,24(sp)
    80002852:	e84a                	sd	s2,16(sp)
    80002854:	1800                	addi	s0,sp,48
    80002856:	84ae                	mv	s1,a1
    80002858:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000285a:	fd840593          	addi	a1,s0,-40
    8000285e:	fd1ff0ef          	jal	ra,8000282e <argaddr>
  return fetchstr(addr, buf, max);
    80002862:	864a                	mv	a2,s2
    80002864:	85a6                	mv	a1,s1
    80002866:	fd843503          	ld	a0,-40(s0)
    8000286a:	f69ff0ef          	jal	ra,800027d2 <fetchstr>
}
    8000286e:	70a2                	ld	ra,40(sp)
    80002870:	7402                	ld	s0,32(sp)
    80002872:	64e2                	ld	s1,24(sp)
    80002874:	6942                	ld	s2,16(sp)
    80002876:	6145                	addi	sp,sp,48
    80002878:	8082                	ret

000000008000287a <syscall>:



void
syscall(void)
{
    8000287a:	1101                	addi	sp,sp,-32
    8000287c:	ec06                	sd	ra,24(sp)
    8000287e:	e822                	sd	s0,16(sp)
    80002880:	e426                	sd	s1,8(sp)
    80002882:	e04a                	sd	s2,0(sp)
    80002884:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002886:	fa7fe0ef          	jal	ra,8000182c <myproc>
    8000288a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000288c:	05853903          	ld	s2,88(a0)
    80002890:	0a893783          	ld	a5,168(s2)
    80002894:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002898:	37fd                	addiw	a5,a5,-1
    8000289a:	475d                	li	a4,23
    8000289c:	00f76f63          	bltu	a4,a5,800028ba <syscall+0x40>
    800028a0:	00369713          	slli	a4,a3,0x3
    800028a4:	00005797          	auipc	a5,0x5
    800028a8:	bec78793          	addi	a5,a5,-1044 # 80007490 <syscalls>
    800028ac:	97ba                	add	a5,a5,a4
    800028ae:	639c                	ld	a5,0(a5)
    800028b0:	c789                	beqz	a5,800028ba <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028b2:	9782                	jalr	a5
    800028b4:	06a93823          	sd	a0,112(s2)
    800028b8:	a829                	j	800028d2 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028ba:	15848613          	addi	a2,s1,344
    800028be:	588c                	lw	a1,48(s1)
    800028c0:	00005517          	auipc	a0,0x5
    800028c4:	b9850513          	addi	a0,a0,-1128 # 80007458 <states.0+0x158>
    800028c8:	bdbfd0ef          	jal	ra,800004a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028cc:	6cbc                	ld	a5,88(s1)
    800028ce:	577d                	li	a4,-1
    800028d0:	fbb8                	sd	a4,112(a5)
  }
}
    800028d2:	60e2                	ld	ra,24(sp)
    800028d4:	6442                	ld	s0,16(sp)
    800028d6:	64a2                	ld	s1,8(sp)
    800028d8:	6902                	ld	s2,0(sp)
    800028da:	6105                	addi	sp,sp,32
    800028dc:	8082                	ret

00000000800028de <sys_exit>:
#include "port.h"  


uint64
sys_exit(void)
{
    800028de:	1101                	addi	sp,sp,-32
    800028e0:	ec06                	sd	ra,24(sp)
    800028e2:	e822                	sd	s0,16(sp)
    800028e4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028e6:	fec40593          	addi	a1,s0,-20
    800028ea:	4501                	li	a0,0
    800028ec:	f27ff0ef          	jal	ra,80002812 <argint>
  exit(n);
    800028f0:	fec42503          	lw	a0,-20(s0)
    800028f4:	e56ff0ef          	jal	ra,80001f4a <exit>
  return 0;  // not reached
}
    800028f8:	4501                	li	a0,0
    800028fa:	60e2                	ld	ra,24(sp)
    800028fc:	6442                	ld	s0,16(sp)
    800028fe:	6105                	addi	sp,sp,32
    80002900:	8082                	ret

0000000080002902 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002902:	1141                	addi	sp,sp,-16
    80002904:	e406                	sd	ra,8(sp)
    80002906:	e022                	sd	s0,0(sp)
    80002908:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000290a:	f23fe0ef          	jal	ra,8000182c <myproc>
}
    8000290e:	5908                	lw	a0,48(a0)
    80002910:	60a2                	ld	ra,8(sp)
    80002912:	6402                	ld	s0,0(sp)
    80002914:	0141                	addi	sp,sp,16
    80002916:	8082                	ret

0000000080002918 <sys_fork>:

uint64
sys_fork(void)
{
    80002918:	1141                	addi	sp,sp,-16
    8000291a:	e406                	sd	ra,8(sp)
    8000291c:	e022                	sd	s0,0(sp)
    8000291e:	0800                	addi	s0,sp,16
  return fork();
    80002920:	a46ff0ef          	jal	ra,80001b66 <fork>
}
    80002924:	60a2                	ld	ra,8(sp)
    80002926:	6402                	ld	s0,0(sp)
    80002928:	0141                	addi	sp,sp,16
    8000292a:	8082                	ret

000000008000292c <sys_wait>:

uint64
sys_wait(void)
{
    8000292c:	1101                	addi	sp,sp,-32
    8000292e:	ec06                	sd	ra,24(sp)
    80002930:	e822                	sd	s0,16(sp)
    80002932:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002934:	fe840593          	addi	a1,s0,-24
    80002938:	4501                	li	a0,0
    8000293a:	ef5ff0ef          	jal	ra,8000282e <argaddr>
  return wait(p);
    8000293e:	fe843503          	ld	a0,-24(s0)
    80002942:	f5eff0ef          	jal	ra,800020a0 <wait>
}
    80002946:	60e2                	ld	ra,24(sp)
    80002948:	6442                	ld	s0,16(sp)
    8000294a:	6105                	addi	sp,sp,32
    8000294c:	8082                	ret

000000008000294e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000294e:	7179                	addi	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002958:	fdc40593          	addi	a1,s0,-36
    8000295c:	4501                	li	a0,0
    8000295e:	eb5ff0ef          	jal	ra,80002812 <argint>
  addr = myproc()->sz;
    80002962:	ecbfe0ef          	jal	ra,8000182c <myproc>
    80002966:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002968:	fdc42503          	lw	a0,-36(s0)
    8000296c:	9aaff0ef          	jal	ra,80001b16 <growproc>
    80002970:	00054863          	bltz	a0,80002980 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002974:	8526                	mv	a0,s1
    80002976:	70a2                	ld	ra,40(sp)
    80002978:	7402                	ld	s0,32(sp)
    8000297a:	64e2                	ld	s1,24(sp)
    8000297c:	6145                	addi	sp,sp,48
    8000297e:	8082                	ret
    return -1;
    80002980:	54fd                	li	s1,-1
    80002982:	bfcd                	j	80002974 <sys_sbrk+0x26>

0000000080002984 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002984:	7139                	addi	sp,sp,-64
    80002986:	fc06                	sd	ra,56(sp)
    80002988:	f822                	sd	s0,48(sp)
    8000298a:	f426                	sd	s1,40(sp)
    8000298c:	f04a                	sd	s2,32(sp)
    8000298e:	ec4e                	sd	s3,24(sp)
    80002990:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002992:	fcc40593          	addi	a1,s0,-52
    80002996:	4501                	li	a0,0
    80002998:	e7bff0ef          	jal	ra,80002812 <argint>
  if(n < 0)
    8000299c:	fcc42783          	lw	a5,-52(s0)
    800029a0:	0607c563          	bltz	a5,80002a0a <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800029a4:	00019517          	auipc	a0,0x19
    800029a8:	4f450513          	addi	a0,a0,1268 # 8001be98 <tickslock>
    800029ac:	9eefe0ef          	jal	ra,80000b9a <acquire>
  ticks0 = ticks;
    800029b0:	00005917          	auipc	s2,0x5
    800029b4:	f7092903          	lw	s2,-144(s2) # 80007920 <ticks>
  while(ticks - ticks0 < n){
    800029b8:	fcc42783          	lw	a5,-52(s0)
    800029bc:	cb8d                	beqz	a5,800029ee <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800029be:	00019997          	auipc	s3,0x19
    800029c2:	4da98993          	addi	s3,s3,1242 # 8001be98 <tickslock>
    800029c6:	00005497          	auipc	s1,0x5
    800029ca:	f5a48493          	addi	s1,s1,-166 # 80007920 <ticks>
    if(killed(myproc())){
    800029ce:	e5ffe0ef          	jal	ra,8000182c <myproc>
    800029d2:	ea4ff0ef          	jal	ra,80002076 <killed>
    800029d6:	ed0d                	bnez	a0,80002a10 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800029d8:	85ce                	mv	a1,s3
    800029da:	8526                	mv	a0,s1
    800029dc:	c62ff0ef          	jal	ra,80001e3e <sleep>
  while(ticks - ticks0 < n){
    800029e0:	409c                	lw	a5,0(s1)
    800029e2:	412787bb          	subw	a5,a5,s2
    800029e6:	fcc42703          	lw	a4,-52(s0)
    800029ea:	fee7e2e3          	bltu	a5,a4,800029ce <sys_sleep+0x4a>
  }
  release(&tickslock);
    800029ee:	00019517          	auipc	a0,0x19
    800029f2:	4aa50513          	addi	a0,a0,1194 # 8001be98 <tickslock>
    800029f6:	a3cfe0ef          	jal	ra,80000c32 <release>
  return 0;
    800029fa:	4501                	li	a0,0
}
    800029fc:	70e2                	ld	ra,56(sp)
    800029fe:	7442                	ld	s0,48(sp)
    80002a00:	74a2                	ld	s1,40(sp)
    80002a02:	7902                	ld	s2,32(sp)
    80002a04:	69e2                	ld	s3,24(sp)
    80002a06:	6121                	addi	sp,sp,64
    80002a08:	8082                	ret
    n = 0;
    80002a0a:	fc042623          	sw	zero,-52(s0)
    80002a0e:	bf59                	j	800029a4 <sys_sleep+0x20>
      release(&tickslock);
    80002a10:	00019517          	auipc	a0,0x19
    80002a14:	48850513          	addi	a0,a0,1160 # 8001be98 <tickslock>
    80002a18:	a1afe0ef          	jal	ra,80000c32 <release>
      return -1;
    80002a1c:	557d                	li	a0,-1
    80002a1e:	bff9                	j	800029fc <sys_sleep+0x78>

0000000080002a20 <sys_kill>:

uint64
sys_kill(void)
{
    80002a20:	1101                	addi	sp,sp,-32
    80002a22:	ec06                	sd	ra,24(sp)
    80002a24:	e822                	sd	s0,16(sp)
    80002a26:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a28:	fec40593          	addi	a1,s0,-20
    80002a2c:	4501                	li	a0,0
    80002a2e:	de5ff0ef          	jal	ra,80002812 <argint>
  return kill(pid);
    80002a32:	fec42503          	lw	a0,-20(s0)
    80002a36:	db6ff0ef          	jal	ra,80001fec <kill>
}
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	6105                	addi	sp,sp,32
    80002a40:	8082                	ret

0000000080002a42 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a42:	1101                	addi	sp,sp,-32
    80002a44:	ec06                	sd	ra,24(sp)
    80002a46:	e822                	sd	s0,16(sp)
    80002a48:	e426                	sd	s1,8(sp)
    80002a4a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a4c:	00019517          	auipc	a0,0x19
    80002a50:	44c50513          	addi	a0,a0,1100 # 8001be98 <tickslock>
    80002a54:	946fe0ef          	jal	ra,80000b9a <acquire>
  xticks = ticks;
    80002a58:	00005497          	auipc	s1,0x5
    80002a5c:	ec84a483          	lw	s1,-312(s1) # 80007920 <ticks>
  release(&tickslock);
    80002a60:	00019517          	auipc	a0,0x19
    80002a64:	43850513          	addi	a0,a0,1080 # 8001be98 <tickslock>
    80002a68:	9cafe0ef          	jal	ra,80000c32 <release>
  return xticks;
}
    80002a6c:	02049513          	slli	a0,s1,0x20
    80002a70:	9101                	srli	a0,a0,0x20
    80002a72:	60e2                	ld	ra,24(sp)
    80002a74:	6442                	ld	s0,16(sp)
    80002a76:	64a2                	ld	s1,8(sp)
    80002a78:	6105                	addi	sp,sp,32
    80002a7a:	8082                	ret

0000000080002a7c <sys_exit_qemu>:



uint64
sys_exit_qemu(void)
{
    80002a7c:	1141                	addi	sp,sp,-16
    80002a7e:	e422                	sd	s0,8(sp)
    80002a80:	0800                	addi	s0,sp,16
  // Adresse mémoire spéciale pour fermer QEMU
  volatile uint32 *exit_address = (volatile uint32 *)0x100000;
  *exit_address = 0x5555;  // Valeur magique pour fermer QEMU
    80002a82:	00100737          	lui	a4,0x100
    80002a86:	6795                	lui	a5,0x5
    80002a88:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002a8c:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002a8e:	4501                	li	a0,0
    80002a90:	6422                	ld	s0,8(sp)
    80002a92:	0141                	addi	sp,sp,16
    80002a94:	8082                	ret

0000000080002a96 <sys_getprocs>:


uint64
sys_getprocs(void)
{
    80002a96:	1101                	addi	sp,sp,-32
    80002a98:	ec06                	sd	ra,24(sp)
    80002a9a:	e822                	sd	s0,16(sp)
    80002a9c:	1000                	addi	s0,sp,32
  uint64 stats_addr;
  int max;
  
  argaddr(0, &stats_addr);
    80002a9e:	fe840593          	addi	a1,s0,-24
    80002aa2:	4501                	li	a0,0
    80002aa4:	d8bff0ef          	jal	ra,8000282e <argaddr>
  argint(1, &max);
    80002aa8:	fe440593          	addi	a1,s0,-28
    80002aac:	4505                	li	a0,1
    80002aae:	d65ff0ef          	jal	ra,80002812 <argint>
  
  struct proc_stat *stats = (struct proc_stat*)stats_addr;
  return getprocs(stats, max);
    80002ab2:	fe442583          	lw	a1,-28(s0)
    80002ab6:	fe843503          	ld	a0,-24(s0)
    80002aba:	869ff0ef          	jal	ra,80002322 <getprocs>
}
    80002abe:	60e2                	ld	ra,24(sp)
    80002ac0:	6442                	ld	s0,16(sp)
    80002ac2:	6105                	addi	sp,sp,32
    80002ac4:	8082                	ret

0000000080002ac6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ac6:	7179                	addi	sp,sp,-48
    80002ac8:	f406                	sd	ra,40(sp)
    80002aca:	f022                	sd	s0,32(sp)
    80002acc:	ec26                	sd	s1,24(sp)
    80002ace:	e84a                	sd	s2,16(sp)
    80002ad0:	e44e                	sd	s3,8(sp)
    80002ad2:	e052                	sd	s4,0(sp)
    80002ad4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ad6:	00005597          	auipc	a1,0x5
    80002ada:	a8258593          	addi	a1,a1,-1406 # 80007558 <syscalls+0xc8>
    80002ade:	00019517          	auipc	a0,0x19
    80002ae2:	3d250513          	addi	a0,a0,978 # 8001beb0 <bcache>
    80002ae6:	834fe0ef          	jal	ra,80000b1a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002aea:	00021797          	auipc	a5,0x21
    80002aee:	3c678793          	addi	a5,a5,966 # 80023eb0 <bcache+0x8000>
    80002af2:	00021717          	auipc	a4,0x21
    80002af6:	62670713          	addi	a4,a4,1574 # 80024118 <bcache+0x8268>
    80002afa:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002afe:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b02:	00019497          	auipc	s1,0x19
    80002b06:	3c648493          	addi	s1,s1,966 # 8001bec8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b0a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b0c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b0e:	00005a17          	auipc	s4,0x5
    80002b12:	a52a0a13          	addi	s4,s4,-1454 # 80007560 <syscalls+0xd0>
    b->next = bcache.head.next;
    80002b16:	2b893783          	ld	a5,696(s2)
    80002b1a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b1c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b20:	85d2                	mv	a1,s4
    80002b22:	01048513          	addi	a0,s1,16
    80002b26:	226010ef          	jal	ra,80003d4c <initsleeplock>
    bcache.head.next->prev = b;
    80002b2a:	2b893783          	ld	a5,696(s2)
    80002b2e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b30:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b34:	45848493          	addi	s1,s1,1112
    80002b38:	fd349fe3          	bne	s1,s3,80002b16 <binit+0x50>
  }
}
    80002b3c:	70a2                	ld	ra,40(sp)
    80002b3e:	7402                	ld	s0,32(sp)
    80002b40:	64e2                	ld	s1,24(sp)
    80002b42:	6942                	ld	s2,16(sp)
    80002b44:	69a2                	ld	s3,8(sp)
    80002b46:	6a02                	ld	s4,0(sp)
    80002b48:	6145                	addi	sp,sp,48
    80002b4a:	8082                	ret

0000000080002b4c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b4c:	7179                	addi	sp,sp,-48
    80002b4e:	f406                	sd	ra,40(sp)
    80002b50:	f022                	sd	s0,32(sp)
    80002b52:	ec26                	sd	s1,24(sp)
    80002b54:	e84a                	sd	s2,16(sp)
    80002b56:	e44e                	sd	s3,8(sp)
    80002b58:	1800                	addi	s0,sp,48
    80002b5a:	892a                	mv	s2,a0
    80002b5c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b5e:	00019517          	auipc	a0,0x19
    80002b62:	35250513          	addi	a0,a0,850 # 8001beb0 <bcache>
    80002b66:	834fe0ef          	jal	ra,80000b9a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b6a:	00021497          	auipc	s1,0x21
    80002b6e:	5fe4b483          	ld	s1,1534(s1) # 80024168 <bcache+0x82b8>
    80002b72:	00021797          	auipc	a5,0x21
    80002b76:	5a678793          	addi	a5,a5,1446 # 80024118 <bcache+0x8268>
    80002b7a:	02f48b63          	beq	s1,a5,80002bb0 <bread+0x64>
    80002b7e:	873e                	mv	a4,a5
    80002b80:	a021                	j	80002b88 <bread+0x3c>
    80002b82:	68a4                	ld	s1,80(s1)
    80002b84:	02e48663          	beq	s1,a4,80002bb0 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b88:	449c                	lw	a5,8(s1)
    80002b8a:	ff279ce3          	bne	a5,s2,80002b82 <bread+0x36>
    80002b8e:	44dc                	lw	a5,12(s1)
    80002b90:	ff3799e3          	bne	a5,s3,80002b82 <bread+0x36>
      b->refcnt++;
    80002b94:	40bc                	lw	a5,64(s1)
    80002b96:	2785                	addiw	a5,a5,1
    80002b98:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b9a:	00019517          	auipc	a0,0x19
    80002b9e:	31650513          	addi	a0,a0,790 # 8001beb0 <bcache>
    80002ba2:	890fe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002ba6:	01048513          	addi	a0,s1,16
    80002baa:	1d8010ef          	jal	ra,80003d82 <acquiresleep>
      return b;
    80002bae:	a889                	j	80002c00 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bb0:	00021497          	auipc	s1,0x21
    80002bb4:	5b04b483          	ld	s1,1456(s1) # 80024160 <bcache+0x82b0>
    80002bb8:	00021797          	auipc	a5,0x21
    80002bbc:	56078793          	addi	a5,a5,1376 # 80024118 <bcache+0x8268>
    80002bc0:	00f48863          	beq	s1,a5,80002bd0 <bread+0x84>
    80002bc4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bc6:	40bc                	lw	a5,64(s1)
    80002bc8:	cb91                	beqz	a5,80002bdc <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bca:	64a4                	ld	s1,72(s1)
    80002bcc:	fee49de3          	bne	s1,a4,80002bc6 <bread+0x7a>
  panic("bget: no buffers");
    80002bd0:	00005517          	auipc	a0,0x5
    80002bd4:	99850513          	addi	a0,a0,-1640 # 80007568 <syscalls+0xd8>
    80002bd8:	b7ffd0ef          	jal	ra,80000756 <panic>
      b->dev = dev;
    80002bdc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002be0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002be4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002be8:	4785                	li	a5,1
    80002bea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bec:	00019517          	auipc	a0,0x19
    80002bf0:	2c450513          	addi	a0,a0,708 # 8001beb0 <bcache>
    80002bf4:	83efe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002bf8:	01048513          	addi	a0,s1,16
    80002bfc:	186010ef          	jal	ra,80003d82 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c00:	409c                	lw	a5,0(s1)
    80002c02:	cb89                	beqz	a5,80002c14 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c04:	8526                	mv	a0,s1
    80002c06:	70a2                	ld	ra,40(sp)
    80002c08:	7402                	ld	s0,32(sp)
    80002c0a:	64e2                	ld	s1,24(sp)
    80002c0c:	6942                	ld	s2,16(sp)
    80002c0e:	69a2                	ld	s3,8(sp)
    80002c10:	6145                	addi	sp,sp,48
    80002c12:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c14:	4581                	li	a1,0
    80002c16:	8526                	mv	a0,s1
    80002c18:	165020ef          	jal	ra,8000557c <virtio_disk_rw>
    b->valid = 1;
    80002c1c:	4785                	li	a5,1
    80002c1e:	c09c                	sw	a5,0(s1)
  return b;
    80002c20:	b7d5                	j	80002c04 <bread+0xb8>

0000000080002c22 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c22:	1101                	addi	sp,sp,-32
    80002c24:	ec06                	sd	ra,24(sp)
    80002c26:	e822                	sd	s0,16(sp)
    80002c28:	e426                	sd	s1,8(sp)
    80002c2a:	1000                	addi	s0,sp,32
    80002c2c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c2e:	0541                	addi	a0,a0,16
    80002c30:	1d0010ef          	jal	ra,80003e00 <holdingsleep>
    80002c34:	c911                	beqz	a0,80002c48 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c36:	4585                	li	a1,1
    80002c38:	8526                	mv	a0,s1
    80002c3a:	143020ef          	jal	ra,8000557c <virtio_disk_rw>
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6105                	addi	sp,sp,32
    80002c46:	8082                	ret
    panic("bwrite");
    80002c48:	00005517          	auipc	a0,0x5
    80002c4c:	93850513          	addi	a0,a0,-1736 # 80007580 <syscalls+0xf0>
    80002c50:	b07fd0ef          	jal	ra,80000756 <panic>

0000000080002c54 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	e04a                	sd	s2,0(sp)
    80002c5e:	1000                	addi	s0,sp,32
    80002c60:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c62:	01050913          	addi	s2,a0,16
    80002c66:	854a                	mv	a0,s2
    80002c68:	198010ef          	jal	ra,80003e00 <holdingsleep>
    80002c6c:	c13d                	beqz	a0,80002cd2 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002c6e:	854a                	mv	a0,s2
    80002c70:	158010ef          	jal	ra,80003dc8 <releasesleep>

  acquire(&bcache.lock);
    80002c74:	00019517          	auipc	a0,0x19
    80002c78:	23c50513          	addi	a0,a0,572 # 8001beb0 <bcache>
    80002c7c:	f1ffd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002c80:	40bc                	lw	a5,64(s1)
    80002c82:	37fd                	addiw	a5,a5,-1
    80002c84:	0007871b          	sext.w	a4,a5
    80002c88:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c8a:	eb05                	bnez	a4,80002cba <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c8c:	68bc                	ld	a5,80(s1)
    80002c8e:	64b8                	ld	a4,72(s1)
    80002c90:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002c92:	64bc                	ld	a5,72(s1)
    80002c94:	68b8                	ld	a4,80(s1)
    80002c96:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c98:	00021797          	auipc	a5,0x21
    80002c9c:	21878793          	addi	a5,a5,536 # 80023eb0 <bcache+0x8000>
    80002ca0:	2b87b703          	ld	a4,696(a5)
    80002ca4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002ca6:	00021717          	auipc	a4,0x21
    80002caa:	47270713          	addi	a4,a4,1138 # 80024118 <bcache+0x8268>
    80002cae:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cb0:	2b87b703          	ld	a4,696(a5)
    80002cb4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cb6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002cba:	00019517          	auipc	a0,0x19
    80002cbe:	1f650513          	addi	a0,a0,502 # 8001beb0 <bcache>
    80002cc2:	f71fd0ef          	jal	ra,80000c32 <release>
}
    80002cc6:	60e2                	ld	ra,24(sp)
    80002cc8:	6442                	ld	s0,16(sp)
    80002cca:	64a2                	ld	s1,8(sp)
    80002ccc:	6902                	ld	s2,0(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret
    panic("brelse");
    80002cd2:	00005517          	auipc	a0,0x5
    80002cd6:	8b650513          	addi	a0,a0,-1866 # 80007588 <syscalls+0xf8>
    80002cda:	a7dfd0ef          	jal	ra,80000756 <panic>

0000000080002cde <bpin>:

void
bpin(struct buf *b) {
    80002cde:	1101                	addi	sp,sp,-32
    80002ce0:	ec06                	sd	ra,24(sp)
    80002ce2:	e822                	sd	s0,16(sp)
    80002ce4:	e426                	sd	s1,8(sp)
    80002ce6:	1000                	addi	s0,sp,32
    80002ce8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cea:	00019517          	auipc	a0,0x19
    80002cee:	1c650513          	addi	a0,a0,454 # 8001beb0 <bcache>
    80002cf2:	ea9fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt++;
    80002cf6:	40bc                	lw	a5,64(s1)
    80002cf8:	2785                	addiw	a5,a5,1
    80002cfa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002cfc:	00019517          	auipc	a0,0x19
    80002d00:	1b450513          	addi	a0,a0,436 # 8001beb0 <bcache>
    80002d04:	f2ffd0ef          	jal	ra,80000c32 <release>
}
    80002d08:	60e2                	ld	ra,24(sp)
    80002d0a:	6442                	ld	s0,16(sp)
    80002d0c:	64a2                	ld	s1,8(sp)
    80002d0e:	6105                	addi	sp,sp,32
    80002d10:	8082                	ret

0000000080002d12 <bunpin>:

void
bunpin(struct buf *b) {
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	1000                	addi	s0,sp,32
    80002d1c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d1e:	00019517          	auipc	a0,0x19
    80002d22:	19250513          	addi	a0,a0,402 # 8001beb0 <bcache>
    80002d26:	e75fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002d2a:	40bc                	lw	a5,64(s1)
    80002d2c:	37fd                	addiw	a5,a5,-1
    80002d2e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d30:	00019517          	auipc	a0,0x19
    80002d34:	18050513          	addi	a0,a0,384 # 8001beb0 <bcache>
    80002d38:	efbfd0ef          	jal	ra,80000c32 <release>
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6105                	addi	sp,sp,32
    80002d44:	8082                	ret

0000000080002d46 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
    80002d52:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d54:	00d5d59b          	srliw	a1,a1,0xd
    80002d58:	00022797          	auipc	a5,0x22
    80002d5c:	8347a783          	lw	a5,-1996(a5) # 8002458c <sb+0x1c>
    80002d60:	9dbd                	addw	a1,a1,a5
    80002d62:	debff0ef          	jal	ra,80002b4c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d66:	0074f713          	andi	a4,s1,7
    80002d6a:	4785                	li	a5,1
    80002d6c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d70:	14ce                	slli	s1,s1,0x33
    80002d72:	90d9                	srli	s1,s1,0x36
    80002d74:	00950733          	add	a4,a0,s1
    80002d78:	05874703          	lbu	a4,88(a4)
    80002d7c:	00e7f6b3          	and	a3,a5,a4
    80002d80:	c29d                	beqz	a3,80002da6 <bfree+0x60>
    80002d82:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d84:	94aa                	add	s1,s1,a0
    80002d86:	fff7c793          	not	a5,a5
    80002d8a:	8ff9                	and	a5,a5,a4
    80002d8c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002d90:	6eb000ef          	jal	ra,80003c7a <log_write>
  brelse(bp);
    80002d94:	854a                	mv	a0,s2
    80002d96:	ebfff0ef          	jal	ra,80002c54 <brelse>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
    panic("freeing free block");
    80002da6:	00004517          	auipc	a0,0x4
    80002daa:	7ea50513          	addi	a0,a0,2026 # 80007590 <syscalls+0x100>
    80002dae:	9a9fd0ef          	jal	ra,80000756 <panic>

0000000080002db2 <balloc>:
{
    80002db2:	711d                	addi	sp,sp,-96
    80002db4:	ec86                	sd	ra,88(sp)
    80002db6:	e8a2                	sd	s0,80(sp)
    80002db8:	e4a6                	sd	s1,72(sp)
    80002dba:	e0ca                	sd	s2,64(sp)
    80002dbc:	fc4e                	sd	s3,56(sp)
    80002dbe:	f852                	sd	s4,48(sp)
    80002dc0:	f456                	sd	s5,40(sp)
    80002dc2:	f05a                	sd	s6,32(sp)
    80002dc4:	ec5e                	sd	s7,24(sp)
    80002dc6:	e862                	sd	s8,16(sp)
    80002dc8:	e466                	sd	s9,8(sp)
    80002dca:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002dcc:	00021797          	auipc	a5,0x21
    80002dd0:	7a87a783          	lw	a5,1960(a5) # 80024574 <sb+0x4>
    80002dd4:	0e078163          	beqz	a5,80002eb6 <balloc+0x104>
    80002dd8:	8baa                	mv	s7,a0
    80002dda:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ddc:	00021b17          	auipc	s6,0x21
    80002de0:	794b0b13          	addi	s6,s6,1940 # 80024570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002de4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002de6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002de8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002dea:	6c89                	lui	s9,0x2
    80002dec:	a0b5                	j	80002e58 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002dee:	974a                	add	a4,a4,s2
    80002df0:	8fd5                	or	a5,a5,a3
    80002df2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002df6:	854a                	mv	a0,s2
    80002df8:	683000ef          	jal	ra,80003c7a <log_write>
        brelse(bp);
    80002dfc:	854a                	mv	a0,s2
    80002dfe:	e57ff0ef          	jal	ra,80002c54 <brelse>
  bp = bread(dev, bno);
    80002e02:	85a6                	mv	a1,s1
    80002e04:	855e                	mv	a0,s7
    80002e06:	d47ff0ef          	jal	ra,80002b4c <bread>
    80002e0a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e0c:	40000613          	li	a2,1024
    80002e10:	4581                	li	a1,0
    80002e12:	05850513          	addi	a0,a0,88
    80002e16:	e59fd0ef          	jal	ra,80000c6e <memset>
  log_write(bp);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	65f000ef          	jal	ra,80003c7a <log_write>
  brelse(bp);
    80002e20:	854a                	mv	a0,s2
    80002e22:	e33ff0ef          	jal	ra,80002c54 <brelse>
}
    80002e26:	8526                	mv	a0,s1
    80002e28:	60e6                	ld	ra,88(sp)
    80002e2a:	6446                	ld	s0,80(sp)
    80002e2c:	64a6                	ld	s1,72(sp)
    80002e2e:	6906                	ld	s2,64(sp)
    80002e30:	79e2                	ld	s3,56(sp)
    80002e32:	7a42                	ld	s4,48(sp)
    80002e34:	7aa2                	ld	s5,40(sp)
    80002e36:	7b02                	ld	s6,32(sp)
    80002e38:	6be2                	ld	s7,24(sp)
    80002e3a:	6c42                	ld	s8,16(sp)
    80002e3c:	6ca2                	ld	s9,8(sp)
    80002e3e:	6125                	addi	sp,sp,96
    80002e40:	8082                	ret
    brelse(bp);
    80002e42:	854a                	mv	a0,s2
    80002e44:	e11ff0ef          	jal	ra,80002c54 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e48:	015c87bb          	addw	a5,s9,s5
    80002e4c:	00078a9b          	sext.w	s5,a5
    80002e50:	004b2703          	lw	a4,4(s6)
    80002e54:	06eaf163          	bgeu	s5,a4,80002eb6 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002e58:	41fad79b          	sraiw	a5,s5,0x1f
    80002e5c:	0137d79b          	srliw	a5,a5,0x13
    80002e60:	015787bb          	addw	a5,a5,s5
    80002e64:	40d7d79b          	sraiw	a5,a5,0xd
    80002e68:	01cb2583          	lw	a1,28(s6)
    80002e6c:	9dbd                	addw	a1,a1,a5
    80002e6e:	855e                	mv	a0,s7
    80002e70:	cddff0ef          	jal	ra,80002b4c <bread>
    80002e74:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e76:	004b2503          	lw	a0,4(s6)
    80002e7a:	000a849b          	sext.w	s1,s5
    80002e7e:	8662                	mv	a2,s8
    80002e80:	fca4f1e3          	bgeu	s1,a0,80002e42 <balloc+0x90>
      m = 1 << (bi % 8);
    80002e84:	41f6579b          	sraiw	a5,a2,0x1f
    80002e88:	01d7d69b          	srliw	a3,a5,0x1d
    80002e8c:	00c6873b          	addw	a4,a3,a2
    80002e90:	00777793          	andi	a5,a4,7
    80002e94:	9f95                	subw	a5,a5,a3
    80002e96:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e9a:	4037571b          	sraiw	a4,a4,0x3
    80002e9e:	00e906b3          	add	a3,s2,a4
    80002ea2:	0586c683          	lbu	a3,88(a3)
    80002ea6:	00d7f5b3          	and	a1,a5,a3
    80002eaa:	d1b1                	beqz	a1,80002dee <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eac:	2605                	addiw	a2,a2,1
    80002eae:	2485                	addiw	s1,s1,1
    80002eb0:	fd4618e3          	bne	a2,s4,80002e80 <balloc+0xce>
    80002eb4:	b779                	j	80002e42 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002eb6:	00004517          	auipc	a0,0x4
    80002eba:	6f250513          	addi	a0,a0,1778 # 800075a8 <syscalls+0x118>
    80002ebe:	de4fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002ec2:	4481                	li	s1,0
    80002ec4:	b78d                	j	80002e26 <balloc+0x74>

0000000080002ec6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ec6:	7179                	addi	sp,sp,-48
    80002ec8:	f406                	sd	ra,40(sp)
    80002eca:	f022                	sd	s0,32(sp)
    80002ecc:	ec26                	sd	s1,24(sp)
    80002ece:	e84a                	sd	s2,16(sp)
    80002ed0:	e44e                	sd	s3,8(sp)
    80002ed2:	e052                	sd	s4,0(sp)
    80002ed4:	1800                	addi	s0,sp,48
    80002ed6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ed8:	47a5                	li	a5,9
    80002eda:	02b7e563          	bltu	a5,a1,80002f04 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002ede:	02059493          	slli	s1,a1,0x20
    80002ee2:	9081                	srli	s1,s1,0x20
    80002ee4:	048a                	slli	s1,s1,0x2
    80002ee6:	94aa                	add	s1,s1,a0
    80002ee8:	0504a903          	lw	s2,80(s1)
    80002eec:	06091663          	bnez	s2,80002f58 <bmap+0x92>
      addr = balloc(ip->dev);
    80002ef0:	4108                	lw	a0,0(a0)
    80002ef2:	ec1ff0ef          	jal	ra,80002db2 <balloc>
    80002ef6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002efa:	04090f63          	beqz	s2,80002f58 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80002efe:	0524a823          	sw	s2,80(s1)
    80002f02:	a899                	j	80002f58 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f04:	ff65849b          	addiw	s1,a1,-10
    80002f08:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f0c:	0ff00793          	li	a5,255
    80002f10:	06e7eb63          	bltu	a5,a4,80002f86 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f14:	07852903          	lw	s2,120(a0)
    80002f18:	00091b63          	bnez	s2,80002f2e <bmap+0x68>
      addr = balloc(ip->dev);
    80002f1c:	4108                	lw	a0,0(a0)
    80002f1e:	e95ff0ef          	jal	ra,80002db2 <balloc>
    80002f22:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f26:	02090963          	beqz	s2,80002f58 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f2a:	0729ac23          	sw	s2,120(s3)
    }
    bp = bread(ip->dev, addr);
    80002f2e:	85ca                	mv	a1,s2
    80002f30:	0009a503          	lw	a0,0(s3)
    80002f34:	c19ff0ef          	jal	ra,80002b4c <bread>
    80002f38:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f3a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f3e:	02049593          	slli	a1,s1,0x20
    80002f42:	9181                	srli	a1,a1,0x20
    80002f44:	058a                	slli	a1,a1,0x2
    80002f46:	00b784b3          	add	s1,a5,a1
    80002f4a:	0004a903          	lw	s2,0(s1)
    80002f4e:	00090e63          	beqz	s2,80002f6a <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f52:	8552                	mv	a0,s4
    80002f54:	d01ff0ef          	jal	ra,80002c54 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002f58:	854a                	mv	a0,s2
    80002f5a:	70a2                	ld	ra,40(sp)
    80002f5c:	7402                	ld	s0,32(sp)
    80002f5e:	64e2                	ld	s1,24(sp)
    80002f60:	6942                	ld	s2,16(sp)
    80002f62:	69a2                	ld	s3,8(sp)
    80002f64:	6a02                	ld	s4,0(sp)
    80002f66:	6145                	addi	sp,sp,48
    80002f68:	8082                	ret
      addr = balloc(ip->dev);
    80002f6a:	0009a503          	lw	a0,0(s3)
    80002f6e:	e45ff0ef          	jal	ra,80002db2 <balloc>
    80002f72:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f76:	fc090ee3          	beqz	s2,80002f52 <bmap+0x8c>
        a[bn] = addr;
    80002f7a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002f7e:	8552                	mv	a0,s4
    80002f80:	4fb000ef          	jal	ra,80003c7a <log_write>
    80002f84:	b7f9                	j	80002f52 <bmap+0x8c>
  panic("bmap: out of range");
    80002f86:	00004517          	auipc	a0,0x4
    80002f8a:	63a50513          	addi	a0,a0,1594 # 800075c0 <syscalls+0x130>
    80002f8e:	fc8fd0ef          	jal	ra,80000756 <panic>

0000000080002f92 <iget>:
{
    80002f92:	7179                	addi	sp,sp,-48
    80002f94:	f406                	sd	ra,40(sp)
    80002f96:	f022                	sd	s0,32(sp)
    80002f98:	ec26                	sd	s1,24(sp)
    80002f9a:	e84a                	sd	s2,16(sp)
    80002f9c:	e44e                	sd	s3,8(sp)
    80002f9e:	e052                	sd	s4,0(sp)
    80002fa0:	1800                	addi	s0,sp,48
    80002fa2:	89aa                	mv	s3,a0
    80002fa4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fa6:	00021517          	auipc	a0,0x21
    80002faa:	5ea50513          	addi	a0,a0,1514 # 80024590 <itable>
    80002fae:	bedfd0ef          	jal	ra,80000b9a <acquire>
  empty = 0;
    80002fb2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fb4:	00021497          	auipc	s1,0x21
    80002fb8:	5f448493          	addi	s1,s1,1524 # 800245a8 <itable+0x18>
    80002fbc:	00023697          	auipc	a3,0x23
    80002fc0:	eec68693          	addi	a3,a3,-276 # 80025ea8 <log>
    80002fc4:	a039                	j	80002fd2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fc6:	02090963          	beqz	s2,80002ff8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fca:	08048493          	addi	s1,s1,128
    80002fce:	02d48863          	beq	s1,a3,80002ffe <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fd2:	449c                	lw	a5,8(s1)
    80002fd4:	fef059e3          	blez	a5,80002fc6 <iget+0x34>
    80002fd8:	4098                	lw	a4,0(s1)
    80002fda:	ff3716e3          	bne	a4,s3,80002fc6 <iget+0x34>
    80002fde:	40d8                	lw	a4,4(s1)
    80002fe0:	ff4713e3          	bne	a4,s4,80002fc6 <iget+0x34>
      ip->ref++;
    80002fe4:	2785                	addiw	a5,a5,1
    80002fe6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fe8:	00021517          	auipc	a0,0x21
    80002fec:	5a850513          	addi	a0,a0,1448 # 80024590 <itable>
    80002ff0:	c43fd0ef          	jal	ra,80000c32 <release>
      return ip;
    80002ff4:	8926                	mv	s2,s1
    80002ff6:	a02d                	j	80003020 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ff8:	fbe9                	bnez	a5,80002fca <iget+0x38>
    80002ffa:	8926                	mv	s2,s1
    80002ffc:	b7f9                	j	80002fca <iget+0x38>
  if(empty == 0)
    80002ffe:	02090a63          	beqz	s2,80003032 <iget+0xa0>
  ip->dev = dev;
    80003002:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003006:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000300a:	4785                	li	a5,1
    8000300c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003010:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003014:	00021517          	auipc	a0,0x21
    80003018:	57c50513          	addi	a0,a0,1404 # 80024590 <itable>
    8000301c:	c17fd0ef          	jal	ra,80000c32 <release>
}
    80003020:	854a                	mv	a0,s2
    80003022:	70a2                	ld	ra,40(sp)
    80003024:	7402                	ld	s0,32(sp)
    80003026:	64e2                	ld	s1,24(sp)
    80003028:	6942                	ld	s2,16(sp)
    8000302a:	69a2                	ld	s3,8(sp)
    8000302c:	6a02                	ld	s4,0(sp)
    8000302e:	6145                	addi	sp,sp,48
    80003030:	8082                	ret
    panic("iget: no inodes");
    80003032:	00004517          	auipc	a0,0x4
    80003036:	5a650513          	addi	a0,a0,1446 # 800075d8 <syscalls+0x148>
    8000303a:	f1cfd0ef          	jal	ra,80000756 <panic>

000000008000303e <fsinit>:
fsinit(int dev) {
    8000303e:	7179                	addi	sp,sp,-48
    80003040:	f406                	sd	ra,40(sp)
    80003042:	f022                	sd	s0,32(sp)
    80003044:	ec26                	sd	s1,24(sp)
    80003046:	e84a                	sd	s2,16(sp)
    80003048:	e44e                	sd	s3,8(sp)
    8000304a:	1800                	addi	s0,sp,48
    8000304c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000304e:	4585                	li	a1,1
    80003050:	afdff0ef          	jal	ra,80002b4c <bread>
    80003054:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003056:	00021997          	auipc	s3,0x21
    8000305a:	51a98993          	addi	s3,s3,1306 # 80024570 <sb>
    8000305e:	02000613          	li	a2,32
    80003062:	05850593          	addi	a1,a0,88
    80003066:	854e                	mv	a0,s3
    80003068:	c63fd0ef          	jal	ra,80000cca <memmove>
  brelse(bp);
    8000306c:	8526                	mv	a0,s1
    8000306e:	be7ff0ef          	jal	ra,80002c54 <brelse>
  if(sb.magic != FSMAGIC)
    80003072:	0009a703          	lw	a4,0(s3)
    80003076:	102037b7          	lui	a5,0x10203
    8000307a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000307e:	02f71063          	bne	a4,a5,8000309e <fsinit+0x60>
  initlog(dev, &sb);
    80003082:	00021597          	auipc	a1,0x21
    80003086:	4ee58593          	addi	a1,a1,1262 # 80024570 <sb>
    8000308a:	854a                	mv	a0,s2
    8000308c:	1db000ef          	jal	ra,80003a66 <initlog>
}
    80003090:	70a2                	ld	ra,40(sp)
    80003092:	7402                	ld	s0,32(sp)
    80003094:	64e2                	ld	s1,24(sp)
    80003096:	6942                	ld	s2,16(sp)
    80003098:	69a2                	ld	s3,8(sp)
    8000309a:	6145                	addi	sp,sp,48
    8000309c:	8082                	ret
    panic("invalid file system");
    8000309e:	00004517          	auipc	a0,0x4
    800030a2:	54a50513          	addi	a0,a0,1354 # 800075e8 <syscalls+0x158>
    800030a6:	eb0fd0ef          	jal	ra,80000756 <panic>

00000000800030aa <iinit>:
{
    800030aa:	7179                	addi	sp,sp,-48
    800030ac:	f406                	sd	ra,40(sp)
    800030ae:	f022                	sd	s0,32(sp)
    800030b0:	ec26                	sd	s1,24(sp)
    800030b2:	e84a                	sd	s2,16(sp)
    800030b4:	e44e                	sd	s3,8(sp)
    800030b6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800030b8:	00004597          	auipc	a1,0x4
    800030bc:	54858593          	addi	a1,a1,1352 # 80007600 <syscalls+0x170>
    800030c0:	00021517          	auipc	a0,0x21
    800030c4:	4d050513          	addi	a0,a0,1232 # 80024590 <itable>
    800030c8:	a53fd0ef          	jal	ra,80000b1a <initlock>
  for(i = 0; i < NINODE; i++) {
    800030cc:	00021497          	auipc	s1,0x21
    800030d0:	4ec48493          	addi	s1,s1,1260 # 800245b8 <itable+0x28>
    800030d4:	00023997          	auipc	s3,0x23
    800030d8:	de498993          	addi	s3,s3,-540 # 80025eb8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030dc:	00004917          	auipc	s2,0x4
    800030e0:	52c90913          	addi	s2,s2,1324 # 80007608 <syscalls+0x178>
    800030e4:	85ca                	mv	a1,s2
    800030e6:	8526                	mv	a0,s1
    800030e8:	465000ef          	jal	ra,80003d4c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800030ec:	08048493          	addi	s1,s1,128
    800030f0:	ff349ae3          	bne	s1,s3,800030e4 <iinit+0x3a>
}
    800030f4:	70a2                	ld	ra,40(sp)
    800030f6:	7402                	ld	s0,32(sp)
    800030f8:	64e2                	ld	s1,24(sp)
    800030fa:	6942                	ld	s2,16(sp)
    800030fc:	69a2                	ld	s3,8(sp)
    800030fe:	6145                	addi	sp,sp,48
    80003100:	8082                	ret

0000000080003102 <ialloc>:
{
    80003102:	715d                	addi	sp,sp,-80
    80003104:	e486                	sd	ra,72(sp)
    80003106:	e0a2                	sd	s0,64(sp)
    80003108:	fc26                	sd	s1,56(sp)
    8000310a:	f84a                	sd	s2,48(sp)
    8000310c:	f44e                	sd	s3,40(sp)
    8000310e:	f052                	sd	s4,32(sp)
    80003110:	ec56                	sd	s5,24(sp)
    80003112:	e85a                	sd	s6,16(sp)
    80003114:	e45e                	sd	s7,8(sp)
    80003116:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003118:	00021717          	auipc	a4,0x21
    8000311c:	46472703          	lw	a4,1124(a4) # 8002457c <sb+0xc>
    80003120:	4785                	li	a5,1
    80003122:	04e7f663          	bgeu	a5,a4,8000316e <ialloc+0x6c>
    80003126:	8aaa                	mv	s5,a0
    80003128:	8bae                	mv	s7,a1
    8000312a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000312c:	00021a17          	auipc	s4,0x21
    80003130:	444a0a13          	addi	s4,s4,1092 # 80024570 <sb>
    80003134:	00048b1b          	sext.w	s6,s1
    80003138:	0044d793          	srli	a5,s1,0x4
    8000313c:	018a2583          	lw	a1,24(s4)
    80003140:	9dbd                	addw	a1,a1,a5
    80003142:	8556                	mv	a0,s5
    80003144:	a09ff0ef          	jal	ra,80002b4c <bread>
    80003148:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000314a:	05850993          	addi	s3,a0,88
    8000314e:	00f4f793          	andi	a5,s1,15
    80003152:	079a                	slli	a5,a5,0x6
    80003154:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003156:	00099783          	lh	a5,0(s3)
    8000315a:	cf85                	beqz	a5,80003192 <ialloc+0x90>
    brelse(bp);
    8000315c:	af9ff0ef          	jal	ra,80002c54 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003160:	0485                	addi	s1,s1,1
    80003162:	00ca2703          	lw	a4,12(s4)
    80003166:	0004879b          	sext.w	a5,s1
    8000316a:	fce7e5e3          	bltu	a5,a4,80003134 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    8000316e:	00004517          	auipc	a0,0x4
    80003172:	4a250513          	addi	a0,a0,1186 # 80007610 <syscalls+0x180>
    80003176:	b2cfd0ef          	jal	ra,800004a2 <printf>
  return 0;
    8000317a:	4501                	li	a0,0
}
    8000317c:	60a6                	ld	ra,72(sp)
    8000317e:	6406                	ld	s0,64(sp)
    80003180:	74e2                	ld	s1,56(sp)
    80003182:	7942                	ld	s2,48(sp)
    80003184:	79a2                	ld	s3,40(sp)
    80003186:	7a02                	ld	s4,32(sp)
    80003188:	6ae2                	ld	s5,24(sp)
    8000318a:	6b42                	ld	s6,16(sp)
    8000318c:	6ba2                	ld	s7,8(sp)
    8000318e:	6161                	addi	sp,sp,80
    80003190:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003192:	04000613          	li	a2,64
    80003196:	4581                	li	a1,0
    80003198:	854e                	mv	a0,s3
    8000319a:	ad5fd0ef          	jal	ra,80000c6e <memset>
      dip->type = type;
    8000319e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800031a2:	854a                	mv	a0,s2
    800031a4:	2d7000ef          	jal	ra,80003c7a <log_write>
      brelse(bp);
    800031a8:	854a                	mv	a0,s2
    800031aa:	aabff0ef          	jal	ra,80002c54 <brelse>
      return iget(dev, inum);
    800031ae:	85da                	mv	a1,s6
    800031b0:	8556                	mv	a0,s5
    800031b2:	de1ff0ef          	jal	ra,80002f92 <iget>
    800031b6:	b7d9                	j	8000317c <ialloc+0x7a>

00000000800031b8 <iupdate>:
{
    800031b8:	1101                	addi	sp,sp,-32
    800031ba:	ec06                	sd	ra,24(sp)
    800031bc:	e822                	sd	s0,16(sp)
    800031be:	e426                	sd	s1,8(sp)
    800031c0:	e04a                	sd	s2,0(sp)
    800031c2:	1000                	addi	s0,sp,32
    800031c4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031c6:	415c                	lw	a5,4(a0)
    800031c8:	0047d79b          	srliw	a5,a5,0x4
    800031cc:	00021597          	auipc	a1,0x21
    800031d0:	3bc5a583          	lw	a1,956(a1) # 80024588 <sb+0x18>
    800031d4:	9dbd                	addw	a1,a1,a5
    800031d6:	4108                	lw	a0,0(a0)
    800031d8:	975ff0ef          	jal	ra,80002b4c <bread>
    800031dc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031de:	05850793          	addi	a5,a0,88
    800031e2:	40c8                	lw	a0,4(s1)
    800031e4:	893d                	andi	a0,a0,15
    800031e6:	051a                	slli	a0,a0,0x6
    800031e8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800031ea:	04449703          	lh	a4,68(s1)
    800031ee:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800031f2:	04649703          	lh	a4,70(s1)
    800031f6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800031fa:	04849703          	lh	a4,72(s1)
    800031fe:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003202:	04a49703          	lh	a4,74(s1)
    80003206:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000320a:	44f8                	lw	a4,76(s1)
    8000320c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000320e:	02c00613          	li	a2,44
    80003212:	05048593          	addi	a1,s1,80
    80003216:	0531                	addi	a0,a0,12
    80003218:	ab3fd0ef          	jal	ra,80000cca <memmove>
  log_write(bp);
    8000321c:	854a                	mv	a0,s2
    8000321e:	25d000ef          	jal	ra,80003c7a <log_write>
  brelse(bp);
    80003222:	854a                	mv	a0,s2
    80003224:	a31ff0ef          	jal	ra,80002c54 <brelse>
}
    80003228:	60e2                	ld	ra,24(sp)
    8000322a:	6442                	ld	s0,16(sp)
    8000322c:	64a2                	ld	s1,8(sp)
    8000322e:	6902                	ld	s2,0(sp)
    80003230:	6105                	addi	sp,sp,32
    80003232:	8082                	ret

0000000080003234 <idup>:
{
    80003234:	1101                	addi	sp,sp,-32
    80003236:	ec06                	sd	ra,24(sp)
    80003238:	e822                	sd	s0,16(sp)
    8000323a:	e426                	sd	s1,8(sp)
    8000323c:	1000                	addi	s0,sp,32
    8000323e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003240:	00021517          	auipc	a0,0x21
    80003244:	35050513          	addi	a0,a0,848 # 80024590 <itable>
    80003248:	953fd0ef          	jal	ra,80000b9a <acquire>
  ip->ref++;
    8000324c:	449c                	lw	a5,8(s1)
    8000324e:	2785                	addiw	a5,a5,1
    80003250:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003252:	00021517          	auipc	a0,0x21
    80003256:	33e50513          	addi	a0,a0,830 # 80024590 <itable>
    8000325a:	9d9fd0ef          	jal	ra,80000c32 <release>
}
    8000325e:	8526                	mv	a0,s1
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	64a2                	ld	s1,8(sp)
    80003266:	6105                	addi	sp,sp,32
    80003268:	8082                	ret

000000008000326a <ilock>:
{
    8000326a:	1101                	addi	sp,sp,-32
    8000326c:	ec06                	sd	ra,24(sp)
    8000326e:	e822                	sd	s0,16(sp)
    80003270:	e426                	sd	s1,8(sp)
    80003272:	e04a                	sd	s2,0(sp)
    80003274:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003276:	c105                	beqz	a0,80003296 <ilock+0x2c>
    80003278:	84aa                	mv	s1,a0
    8000327a:	451c                	lw	a5,8(a0)
    8000327c:	00f05d63          	blez	a5,80003296 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003280:	0541                	addi	a0,a0,16
    80003282:	301000ef          	jal	ra,80003d82 <acquiresleep>
  if(ip->valid == 0){
    80003286:	40bc                	lw	a5,64(s1)
    80003288:	cf89                	beqz	a5,800032a2 <ilock+0x38>
}
    8000328a:	60e2                	ld	ra,24(sp)
    8000328c:	6442                	ld	s0,16(sp)
    8000328e:	64a2                	ld	s1,8(sp)
    80003290:	6902                	ld	s2,0(sp)
    80003292:	6105                	addi	sp,sp,32
    80003294:	8082                	ret
    panic("ilock");
    80003296:	00004517          	auipc	a0,0x4
    8000329a:	39250513          	addi	a0,a0,914 # 80007628 <syscalls+0x198>
    8000329e:	cb8fd0ef          	jal	ra,80000756 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032a2:	40dc                	lw	a5,4(s1)
    800032a4:	0047d79b          	srliw	a5,a5,0x4
    800032a8:	00021597          	auipc	a1,0x21
    800032ac:	2e05a583          	lw	a1,736(a1) # 80024588 <sb+0x18>
    800032b0:	9dbd                	addw	a1,a1,a5
    800032b2:	4088                	lw	a0,0(s1)
    800032b4:	899ff0ef          	jal	ra,80002b4c <bread>
    800032b8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032ba:	05850593          	addi	a1,a0,88
    800032be:	40dc                	lw	a5,4(s1)
    800032c0:	8bbd                	andi	a5,a5,15
    800032c2:	079a                	slli	a5,a5,0x6
    800032c4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032c6:	00059783          	lh	a5,0(a1)
    800032ca:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032ce:	00259783          	lh	a5,2(a1)
    800032d2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032d6:	00459783          	lh	a5,4(a1)
    800032da:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032de:	00659783          	lh	a5,6(a1)
    800032e2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032e6:	459c                	lw	a5,8(a1)
    800032e8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032ea:	02c00613          	li	a2,44
    800032ee:	05b1                	addi	a1,a1,12
    800032f0:	05048513          	addi	a0,s1,80
    800032f4:	9d7fd0ef          	jal	ra,80000cca <memmove>
    brelse(bp);
    800032f8:	854a                	mv	a0,s2
    800032fa:	95bff0ef          	jal	ra,80002c54 <brelse>
    ip->valid = 1;
    800032fe:	4785                	li	a5,1
    80003300:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003302:	04449783          	lh	a5,68(s1)
    80003306:	f3d1                	bnez	a5,8000328a <ilock+0x20>
      panic("ilock: no type");
    80003308:	00004517          	auipc	a0,0x4
    8000330c:	32850513          	addi	a0,a0,808 # 80007630 <syscalls+0x1a0>
    80003310:	c46fd0ef          	jal	ra,80000756 <panic>

0000000080003314 <iunlock>:
{
    80003314:	1101                	addi	sp,sp,-32
    80003316:	ec06                	sd	ra,24(sp)
    80003318:	e822                	sd	s0,16(sp)
    8000331a:	e426                	sd	s1,8(sp)
    8000331c:	e04a                	sd	s2,0(sp)
    8000331e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003320:	c505                	beqz	a0,80003348 <iunlock+0x34>
    80003322:	84aa                	mv	s1,a0
    80003324:	01050913          	addi	s2,a0,16
    80003328:	854a                	mv	a0,s2
    8000332a:	2d7000ef          	jal	ra,80003e00 <holdingsleep>
    8000332e:	cd09                	beqz	a0,80003348 <iunlock+0x34>
    80003330:	449c                	lw	a5,8(s1)
    80003332:	00f05b63          	blez	a5,80003348 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003336:	854a                	mv	a0,s2
    80003338:	291000ef          	jal	ra,80003dc8 <releasesleep>
}
    8000333c:	60e2                	ld	ra,24(sp)
    8000333e:	6442                	ld	s0,16(sp)
    80003340:	64a2                	ld	s1,8(sp)
    80003342:	6902                	ld	s2,0(sp)
    80003344:	6105                	addi	sp,sp,32
    80003346:	8082                	ret
    panic("iunlock");
    80003348:	00004517          	auipc	a0,0x4
    8000334c:	2f850513          	addi	a0,a0,760 # 80007640 <syscalls+0x1b0>
    80003350:	c06fd0ef          	jal	ra,80000756 <panic>

0000000080003354 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003354:	7179                	addi	sp,sp,-48
    80003356:	f406                	sd	ra,40(sp)
    80003358:	f022                	sd	s0,32(sp)
    8000335a:	ec26                	sd	s1,24(sp)
    8000335c:	e84a                	sd	s2,16(sp)
    8000335e:	e44e                	sd	s3,8(sp)
    80003360:	e052                	sd	s4,0(sp)
    80003362:	1800                	addi	s0,sp,48
    80003364:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003366:	05050493          	addi	s1,a0,80
    8000336a:	07850913          	addi	s2,a0,120
    8000336e:	a021                	j	80003376 <itrunc+0x22>
    80003370:	0491                	addi	s1,s1,4
    80003372:	01248b63          	beq	s1,s2,80003388 <itrunc+0x34>
    if(ip->addrs[i]){
    80003376:	408c                	lw	a1,0(s1)
    80003378:	dde5                	beqz	a1,80003370 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000337a:	0009a503          	lw	a0,0(s3)
    8000337e:	9c9ff0ef          	jal	ra,80002d46 <bfree>
      ip->addrs[i] = 0;
    80003382:	0004a023          	sw	zero,0(s1)
    80003386:	b7ed                	j	80003370 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003388:	0789a583          	lw	a1,120(s3)
    8000338c:	ed91                	bnez	a1,800033a8 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000338e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003392:	854e                	mv	a0,s3
    80003394:	e25ff0ef          	jal	ra,800031b8 <iupdate>
}
    80003398:	70a2                	ld	ra,40(sp)
    8000339a:	7402                	ld	s0,32(sp)
    8000339c:	64e2                	ld	s1,24(sp)
    8000339e:	6942                	ld	s2,16(sp)
    800033a0:	69a2                	ld	s3,8(sp)
    800033a2:	6a02                	ld	s4,0(sp)
    800033a4:	6145                	addi	sp,sp,48
    800033a6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800033a8:	0009a503          	lw	a0,0(s3)
    800033ac:	fa0ff0ef          	jal	ra,80002b4c <bread>
    800033b0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800033b2:	05850493          	addi	s1,a0,88
    800033b6:	45850913          	addi	s2,a0,1112
    800033ba:	a021                	j	800033c2 <itrunc+0x6e>
    800033bc:	0491                	addi	s1,s1,4
    800033be:	01248963          	beq	s1,s2,800033d0 <itrunc+0x7c>
      if(a[j])
    800033c2:	408c                	lw	a1,0(s1)
    800033c4:	dde5                	beqz	a1,800033bc <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800033c6:	0009a503          	lw	a0,0(s3)
    800033ca:	97dff0ef          	jal	ra,80002d46 <bfree>
    800033ce:	b7fd                	j	800033bc <itrunc+0x68>
    brelse(bp);
    800033d0:	8552                	mv	a0,s4
    800033d2:	883ff0ef          	jal	ra,80002c54 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033d6:	0789a583          	lw	a1,120(s3)
    800033da:	0009a503          	lw	a0,0(s3)
    800033de:	969ff0ef          	jal	ra,80002d46 <bfree>
    ip->addrs[NDIRECT] = 0;
    800033e2:	0609ac23          	sw	zero,120(s3)
    800033e6:	b765                	j	8000338e <itrunc+0x3a>

00000000800033e8 <iput>:
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
    800033f4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033f6:	00021517          	auipc	a0,0x21
    800033fa:	19a50513          	addi	a0,a0,410 # 80024590 <itable>
    800033fe:	f9cfd0ef          	jal	ra,80000b9a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003402:	4498                	lw	a4,8(s1)
    80003404:	4785                	li	a5,1
    80003406:	02f70163          	beq	a4,a5,80003428 <iput+0x40>
  ip->ref--;
    8000340a:	449c                	lw	a5,8(s1)
    8000340c:	37fd                	addiw	a5,a5,-1
    8000340e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003410:	00021517          	auipc	a0,0x21
    80003414:	18050513          	addi	a0,a0,384 # 80024590 <itable>
    80003418:	81bfd0ef          	jal	ra,80000c32 <release>
}
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	64a2                	ld	s1,8(sp)
    80003422:	6902                	ld	s2,0(sp)
    80003424:	6105                	addi	sp,sp,32
    80003426:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003428:	40bc                	lw	a5,64(s1)
    8000342a:	d3e5                	beqz	a5,8000340a <iput+0x22>
    8000342c:	04a49783          	lh	a5,74(s1)
    80003430:	ffe9                	bnez	a5,8000340a <iput+0x22>
    acquiresleep(&ip->lock);
    80003432:	01048913          	addi	s2,s1,16
    80003436:	854a                	mv	a0,s2
    80003438:	14b000ef          	jal	ra,80003d82 <acquiresleep>
    release(&itable.lock);
    8000343c:	00021517          	auipc	a0,0x21
    80003440:	15450513          	addi	a0,a0,340 # 80024590 <itable>
    80003444:	feefd0ef          	jal	ra,80000c32 <release>
    itrunc(ip);
    80003448:	8526                	mv	a0,s1
    8000344a:	f0bff0ef          	jal	ra,80003354 <itrunc>
    ip->type = 0;
    8000344e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003452:	8526                	mv	a0,s1
    80003454:	d65ff0ef          	jal	ra,800031b8 <iupdate>
    ip->valid = 0;
    80003458:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000345c:	854a                	mv	a0,s2
    8000345e:	16b000ef          	jal	ra,80003dc8 <releasesleep>
    acquire(&itable.lock);
    80003462:	00021517          	auipc	a0,0x21
    80003466:	12e50513          	addi	a0,a0,302 # 80024590 <itable>
    8000346a:	f30fd0ef          	jal	ra,80000b9a <acquire>
    8000346e:	bf71                	j	8000340a <iput+0x22>

0000000080003470 <iunlockput>:
{
    80003470:	1101                	addi	sp,sp,-32
    80003472:	ec06                	sd	ra,24(sp)
    80003474:	e822                	sd	s0,16(sp)
    80003476:	e426                	sd	s1,8(sp)
    80003478:	1000                	addi	s0,sp,32
    8000347a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000347c:	e99ff0ef          	jal	ra,80003314 <iunlock>
  iput(ip);
    80003480:	8526                	mv	a0,s1
    80003482:	f67ff0ef          	jal	ra,800033e8 <iput>
}
    80003486:	60e2                	ld	ra,24(sp)
    80003488:	6442                	ld	s0,16(sp)
    8000348a:	64a2                	ld	s1,8(sp)
    8000348c:	6105                	addi	sp,sp,32
    8000348e:	8082                	ret

0000000080003490 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003490:	1141                	addi	sp,sp,-16
    80003492:	e422                	sd	s0,8(sp)
    80003494:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003496:	411c                	lw	a5,0(a0)
    80003498:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000349a:	415c                	lw	a5,4(a0)
    8000349c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000349e:	04451783          	lh	a5,68(a0)
    800034a2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800034a6:	04a51783          	lh	a5,74(a0)
    800034aa:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800034ae:	04c56783          	lwu	a5,76(a0)
    800034b2:	e99c                	sd	a5,16(a1)
}
    800034b4:	6422                	ld	s0,8(sp)
    800034b6:	0141                	addi	sp,sp,16
    800034b8:	8082                	ret

00000000800034ba <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800034ba:	457c                	lw	a5,76(a0)
    800034bc:	0cd7ef63          	bltu	a5,a3,8000359a <readi+0xe0>
{
    800034c0:	7159                	addi	sp,sp,-112
    800034c2:	f486                	sd	ra,104(sp)
    800034c4:	f0a2                	sd	s0,96(sp)
    800034c6:	eca6                	sd	s1,88(sp)
    800034c8:	e8ca                	sd	s2,80(sp)
    800034ca:	e4ce                	sd	s3,72(sp)
    800034cc:	e0d2                	sd	s4,64(sp)
    800034ce:	fc56                	sd	s5,56(sp)
    800034d0:	f85a                	sd	s6,48(sp)
    800034d2:	f45e                	sd	s7,40(sp)
    800034d4:	f062                	sd	s8,32(sp)
    800034d6:	ec66                	sd	s9,24(sp)
    800034d8:	e86a                	sd	s10,16(sp)
    800034da:	e46e                	sd	s11,8(sp)
    800034dc:	1880                	addi	s0,sp,112
    800034de:	8b2a                	mv	s6,a0
    800034e0:	8bae                	mv	s7,a1
    800034e2:	8a32                	mv	s4,a2
    800034e4:	84b6                	mv	s1,a3
    800034e6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800034e8:	9f35                	addw	a4,a4,a3
    return 0;
    800034ea:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800034ec:	08d76663          	bltu	a4,a3,80003578 <readi+0xbe>
  if(off + n > ip->size)
    800034f0:	00e7f463          	bgeu	a5,a4,800034f8 <readi+0x3e>
    n = ip->size - off;
    800034f4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034f8:	080a8f63          	beqz	s5,80003596 <readi+0xdc>
    800034fc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034fe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003502:	5c7d                	li	s8,-1
    80003504:	a80d                	j	80003536 <readi+0x7c>
    80003506:	020d1d93          	slli	s11,s10,0x20
    8000350a:	020ddd93          	srli	s11,s11,0x20
    8000350e:	05890793          	addi	a5,s2,88
    80003512:	86ee                	mv	a3,s11
    80003514:	963e                	add	a2,a2,a5
    80003516:	85d2                	mv	a1,s4
    80003518:	855e                	mv	a0,s7
    8000351a:	c81fe0ef          	jal	ra,8000219a <either_copyout>
    8000351e:	05850763          	beq	a0,s8,8000356c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003522:	854a                	mv	a0,s2
    80003524:	f30ff0ef          	jal	ra,80002c54 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003528:	013d09bb          	addw	s3,s10,s3
    8000352c:	009d04bb          	addw	s1,s10,s1
    80003530:	9a6e                	add	s4,s4,s11
    80003532:	0559f163          	bgeu	s3,s5,80003574 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80003536:	00a4d59b          	srliw	a1,s1,0xa
    8000353a:	855a                	mv	a0,s6
    8000353c:	98bff0ef          	jal	ra,80002ec6 <bmap>
    80003540:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003544:	c985                	beqz	a1,80003574 <readi+0xba>
    bp = bread(ip->dev, addr);
    80003546:	000b2503          	lw	a0,0(s6)
    8000354a:	e02ff0ef          	jal	ra,80002b4c <bread>
    8000354e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003550:	3ff4f613          	andi	a2,s1,1023
    80003554:	40cc87bb          	subw	a5,s9,a2
    80003558:	413a873b          	subw	a4,s5,s3
    8000355c:	8d3e                	mv	s10,a5
    8000355e:	2781                	sext.w	a5,a5
    80003560:	0007069b          	sext.w	a3,a4
    80003564:	faf6f1e3          	bgeu	a3,a5,80003506 <readi+0x4c>
    80003568:	8d3a                	mv	s10,a4
    8000356a:	bf71                	j	80003506 <readi+0x4c>
      brelse(bp);
    8000356c:	854a                	mv	a0,s2
    8000356e:	ee6ff0ef          	jal	ra,80002c54 <brelse>
      tot = -1;
    80003572:	59fd                	li	s3,-1
  }
  return tot;
    80003574:	0009851b          	sext.w	a0,s3
}
    80003578:	70a6                	ld	ra,104(sp)
    8000357a:	7406                	ld	s0,96(sp)
    8000357c:	64e6                	ld	s1,88(sp)
    8000357e:	6946                	ld	s2,80(sp)
    80003580:	69a6                	ld	s3,72(sp)
    80003582:	6a06                	ld	s4,64(sp)
    80003584:	7ae2                	ld	s5,56(sp)
    80003586:	7b42                	ld	s6,48(sp)
    80003588:	7ba2                	ld	s7,40(sp)
    8000358a:	7c02                	ld	s8,32(sp)
    8000358c:	6ce2                	ld	s9,24(sp)
    8000358e:	6d42                	ld	s10,16(sp)
    80003590:	6da2                	ld	s11,8(sp)
    80003592:	6165                	addi	sp,sp,112
    80003594:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003596:	89d6                	mv	s3,s5
    80003598:	bff1                	j	80003574 <readi+0xba>
    return 0;
    8000359a:	4501                	li	a0,0
}
    8000359c:	8082                	ret

000000008000359e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000359e:	457c                	lw	a5,76(a0)
    800035a0:	0ed7eb63          	bltu	a5,a3,80003696 <writei+0xf8>
{
    800035a4:	7159                	addi	sp,sp,-112
    800035a6:	f486                	sd	ra,104(sp)
    800035a8:	f0a2                	sd	s0,96(sp)
    800035aa:	eca6                	sd	s1,88(sp)
    800035ac:	e8ca                	sd	s2,80(sp)
    800035ae:	e4ce                	sd	s3,72(sp)
    800035b0:	e0d2                	sd	s4,64(sp)
    800035b2:	fc56                	sd	s5,56(sp)
    800035b4:	f85a                	sd	s6,48(sp)
    800035b6:	f45e                	sd	s7,40(sp)
    800035b8:	f062                	sd	s8,32(sp)
    800035ba:	ec66                	sd	s9,24(sp)
    800035bc:	e86a                	sd	s10,16(sp)
    800035be:	e46e                	sd	s11,8(sp)
    800035c0:	1880                	addi	s0,sp,112
    800035c2:	8aaa                	mv	s5,a0
    800035c4:	8bae                	mv	s7,a1
    800035c6:	8a32                	mv	s4,a2
    800035c8:	8936                	mv	s2,a3
    800035ca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800035cc:	9f35                	addw	a4,a4,a3
    800035ce:	0cd76663          	bltu	a4,a3,8000369a <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800035d2:	000437b7          	lui	a5,0x43
    800035d6:	80078793          	addi	a5,a5,-2048 # 42800 <_entry-0x7ffbd800>
    800035da:	0ce7e263          	bltu	a5,a4,8000369e <writei+0x100>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035de:	0a0b0a63          	beqz	s6,80003692 <writei+0xf4>
    800035e2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035e4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800035e8:	5c7d                	li	s8,-1
    800035ea:	a825                	j	80003622 <writei+0x84>
    800035ec:	020d1d93          	slli	s11,s10,0x20
    800035f0:	020ddd93          	srli	s11,s11,0x20
    800035f4:	05848793          	addi	a5,s1,88
    800035f8:	86ee                	mv	a3,s11
    800035fa:	8652                	mv	a2,s4
    800035fc:	85de                	mv	a1,s7
    800035fe:	953e                	add	a0,a0,a5
    80003600:	be5fe0ef          	jal	ra,800021e4 <either_copyin>
    80003604:	05850a63          	beq	a0,s8,80003658 <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003608:	8526                	mv	a0,s1
    8000360a:	670000ef          	jal	ra,80003c7a <log_write>
    brelse(bp);
    8000360e:	8526                	mv	a0,s1
    80003610:	e44ff0ef          	jal	ra,80002c54 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003614:	013d09bb          	addw	s3,s10,s3
    80003618:	012d093b          	addw	s2,s10,s2
    8000361c:	9a6e                	add	s4,s4,s11
    8000361e:	0569f063          	bgeu	s3,s6,8000365e <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    80003622:	00a9559b          	srliw	a1,s2,0xa
    80003626:	8556                	mv	a0,s5
    80003628:	89fff0ef          	jal	ra,80002ec6 <bmap>
    8000362c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003630:	c59d                	beqz	a1,8000365e <writei+0xc0>
    bp = bread(ip->dev, addr);
    80003632:	000aa503          	lw	a0,0(s5)
    80003636:	d16ff0ef          	jal	ra,80002b4c <bread>
    8000363a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000363c:	3ff97513          	andi	a0,s2,1023
    80003640:	40ac87bb          	subw	a5,s9,a0
    80003644:	413b073b          	subw	a4,s6,s3
    80003648:	8d3e                	mv	s10,a5
    8000364a:	2781                	sext.w	a5,a5
    8000364c:	0007069b          	sext.w	a3,a4
    80003650:	f8f6fee3          	bgeu	a3,a5,800035ec <writei+0x4e>
    80003654:	8d3a                	mv	s10,a4
    80003656:	bf59                	j	800035ec <writei+0x4e>
      brelse(bp);
    80003658:	8526                	mv	a0,s1
    8000365a:	dfaff0ef          	jal	ra,80002c54 <brelse>
  }

  if(off > ip->size)
    8000365e:	04caa783          	lw	a5,76(s5)
    80003662:	0127f463          	bgeu	a5,s2,8000366a <writei+0xcc>
    ip->size = off;
    80003666:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000366a:	8556                	mv	a0,s5
    8000366c:	b4dff0ef          	jal	ra,800031b8 <iupdate>

  return tot;
    80003670:	0009851b          	sext.w	a0,s3
}
    80003674:	70a6                	ld	ra,104(sp)
    80003676:	7406                	ld	s0,96(sp)
    80003678:	64e6                	ld	s1,88(sp)
    8000367a:	6946                	ld	s2,80(sp)
    8000367c:	69a6                	ld	s3,72(sp)
    8000367e:	6a06                	ld	s4,64(sp)
    80003680:	7ae2                	ld	s5,56(sp)
    80003682:	7b42                	ld	s6,48(sp)
    80003684:	7ba2                	ld	s7,40(sp)
    80003686:	7c02                	ld	s8,32(sp)
    80003688:	6ce2                	ld	s9,24(sp)
    8000368a:	6d42                	ld	s10,16(sp)
    8000368c:	6da2                	ld	s11,8(sp)
    8000368e:	6165                	addi	sp,sp,112
    80003690:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003692:	89da                	mv	s3,s6
    80003694:	bfd9                	j	8000366a <writei+0xcc>
    return -1;
    80003696:	557d                	li	a0,-1
}
    80003698:	8082                	ret
    return -1;
    8000369a:	557d                	li	a0,-1
    8000369c:	bfe1                	j	80003674 <writei+0xd6>
    return -1;
    8000369e:	557d                	li	a0,-1
    800036a0:	bfd1                	j	80003674 <writei+0xd6>

00000000800036a2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800036a2:	1141                	addi	sp,sp,-16
    800036a4:	e406                	sd	ra,8(sp)
    800036a6:	e022                	sd	s0,0(sp)
    800036a8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800036aa:	4639                	li	a2,14
    800036ac:	e8efd0ef          	jal	ra,80000d3a <strncmp>
}
    800036b0:	60a2                	ld	ra,8(sp)
    800036b2:	6402                	ld	s0,0(sp)
    800036b4:	0141                	addi	sp,sp,16
    800036b6:	8082                	ret

00000000800036b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800036b8:	7139                	addi	sp,sp,-64
    800036ba:	fc06                	sd	ra,56(sp)
    800036bc:	f822                	sd	s0,48(sp)
    800036be:	f426                	sd	s1,40(sp)
    800036c0:	f04a                	sd	s2,32(sp)
    800036c2:	ec4e                	sd	s3,24(sp)
    800036c4:	e852                	sd	s4,16(sp)
    800036c6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800036c8:	04451703          	lh	a4,68(a0)
    800036cc:	4785                	li	a5,1
    800036ce:	00f71a63          	bne	a4,a5,800036e2 <dirlookup+0x2a>
    800036d2:	892a                	mv	s2,a0
    800036d4:	89ae                	mv	s3,a1
    800036d6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800036d8:	457c                	lw	a5,76(a0)
    800036da:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800036dc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036de:	e39d                	bnez	a5,80003704 <dirlookup+0x4c>
    800036e0:	a095                	j	80003744 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800036e2:	00004517          	auipc	a0,0x4
    800036e6:	f6650513          	addi	a0,a0,-154 # 80007648 <syscalls+0x1b8>
    800036ea:	86cfd0ef          	jal	ra,80000756 <panic>
      panic("dirlookup read");
    800036ee:	00004517          	auipc	a0,0x4
    800036f2:	f7250513          	addi	a0,a0,-142 # 80007660 <syscalls+0x1d0>
    800036f6:	860fd0ef          	jal	ra,80000756 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036fa:	24c1                	addiw	s1,s1,16
    800036fc:	04c92783          	lw	a5,76(s2)
    80003700:	04f4f163          	bgeu	s1,a5,80003742 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003704:	4741                	li	a4,16
    80003706:	86a6                	mv	a3,s1
    80003708:	fc040613          	addi	a2,s0,-64
    8000370c:	4581                	li	a1,0
    8000370e:	854a                	mv	a0,s2
    80003710:	dabff0ef          	jal	ra,800034ba <readi>
    80003714:	47c1                	li	a5,16
    80003716:	fcf51ce3          	bne	a0,a5,800036ee <dirlookup+0x36>
    if(de.inum == 0)
    8000371a:	fc045783          	lhu	a5,-64(s0)
    8000371e:	dff1                	beqz	a5,800036fa <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003720:	fc240593          	addi	a1,s0,-62
    80003724:	854e                	mv	a0,s3
    80003726:	f7dff0ef          	jal	ra,800036a2 <namecmp>
    8000372a:	f961                	bnez	a0,800036fa <dirlookup+0x42>
      if(poff)
    8000372c:	000a0463          	beqz	s4,80003734 <dirlookup+0x7c>
        *poff = off;
    80003730:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003734:	fc045583          	lhu	a1,-64(s0)
    80003738:	00092503          	lw	a0,0(s2)
    8000373c:	857ff0ef          	jal	ra,80002f92 <iget>
    80003740:	a011                	j	80003744 <dirlookup+0x8c>
  return 0;
    80003742:	4501                	li	a0,0
}
    80003744:	70e2                	ld	ra,56(sp)
    80003746:	7442                	ld	s0,48(sp)
    80003748:	74a2                	ld	s1,40(sp)
    8000374a:	7902                	ld	s2,32(sp)
    8000374c:	69e2                	ld	s3,24(sp)
    8000374e:	6a42                	ld	s4,16(sp)
    80003750:	6121                	addi	sp,sp,64
    80003752:	8082                	ret

0000000080003754 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003754:	711d                	addi	sp,sp,-96
    80003756:	ec86                	sd	ra,88(sp)
    80003758:	e8a2                	sd	s0,80(sp)
    8000375a:	e4a6                	sd	s1,72(sp)
    8000375c:	e0ca                	sd	s2,64(sp)
    8000375e:	fc4e                	sd	s3,56(sp)
    80003760:	f852                	sd	s4,48(sp)
    80003762:	f456                	sd	s5,40(sp)
    80003764:	f05a                	sd	s6,32(sp)
    80003766:	ec5e                	sd	s7,24(sp)
    80003768:	e862                	sd	s8,16(sp)
    8000376a:	e466                	sd	s9,8(sp)
    8000376c:	1080                	addi	s0,sp,96
    8000376e:	84aa                	mv	s1,a0
    80003770:	8aae                	mv	s5,a1
    80003772:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003774:	00054703          	lbu	a4,0(a0)
    80003778:	02f00793          	li	a5,47
    8000377c:	00f70f63          	beq	a4,a5,8000379a <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003780:	8acfe0ef          	jal	ra,8000182c <myproc>
    80003784:	15053503          	ld	a0,336(a0)
    80003788:	aadff0ef          	jal	ra,80003234 <idup>
    8000378c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000378e:	02f00913          	li	s2,47
  len = path - s;
    80003792:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003794:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003796:	4b85                	li	s7,1
    80003798:	a861                	j	80003830 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    8000379a:	4585                	li	a1,1
    8000379c:	4505                	li	a0,1
    8000379e:	ff4ff0ef          	jal	ra,80002f92 <iget>
    800037a2:	89aa                	mv	s3,a0
    800037a4:	b7ed                	j	8000378e <namex+0x3a>
      iunlockput(ip);
    800037a6:	854e                	mv	a0,s3
    800037a8:	cc9ff0ef          	jal	ra,80003470 <iunlockput>
      return 0;
    800037ac:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800037ae:	854e                	mv	a0,s3
    800037b0:	60e6                	ld	ra,88(sp)
    800037b2:	6446                	ld	s0,80(sp)
    800037b4:	64a6                	ld	s1,72(sp)
    800037b6:	6906                	ld	s2,64(sp)
    800037b8:	79e2                	ld	s3,56(sp)
    800037ba:	7a42                	ld	s4,48(sp)
    800037bc:	7aa2                	ld	s5,40(sp)
    800037be:	7b02                	ld	s6,32(sp)
    800037c0:	6be2                	ld	s7,24(sp)
    800037c2:	6c42                	ld	s8,16(sp)
    800037c4:	6ca2                	ld	s9,8(sp)
    800037c6:	6125                	addi	sp,sp,96
    800037c8:	8082                	ret
      iunlock(ip);
    800037ca:	854e                	mv	a0,s3
    800037cc:	b49ff0ef          	jal	ra,80003314 <iunlock>
      return ip;
    800037d0:	bff9                	j	800037ae <namex+0x5a>
      iunlockput(ip);
    800037d2:	854e                	mv	a0,s3
    800037d4:	c9dff0ef          	jal	ra,80003470 <iunlockput>
      return 0;
    800037d8:	89e6                	mv	s3,s9
    800037da:	bfd1                	j	800037ae <namex+0x5a>
  len = path - s;
    800037dc:	40b48633          	sub	a2,s1,a1
    800037e0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800037e4:	079c5c63          	bge	s8,s9,8000385c <namex+0x108>
    memmove(name, s, DIRSIZ);
    800037e8:	4639                	li	a2,14
    800037ea:	8552                	mv	a0,s4
    800037ec:	cdefd0ef          	jal	ra,80000cca <memmove>
  while(*path == '/')
    800037f0:	0004c783          	lbu	a5,0(s1)
    800037f4:	01279763          	bne	a5,s2,80003802 <namex+0xae>
    path++;
    800037f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037fa:	0004c783          	lbu	a5,0(s1)
    800037fe:	ff278de3          	beq	a5,s2,800037f8 <namex+0xa4>
    ilock(ip);
    80003802:	854e                	mv	a0,s3
    80003804:	a67ff0ef          	jal	ra,8000326a <ilock>
    if(ip->type != T_DIR){
    80003808:	04499783          	lh	a5,68(s3)
    8000380c:	f9779de3          	bne	a5,s7,800037a6 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80003810:	000a8563          	beqz	s5,8000381a <namex+0xc6>
    80003814:	0004c783          	lbu	a5,0(s1)
    80003818:	dbcd                	beqz	a5,800037ca <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000381a:	865a                	mv	a2,s6
    8000381c:	85d2                	mv	a1,s4
    8000381e:	854e                	mv	a0,s3
    80003820:	e99ff0ef          	jal	ra,800036b8 <dirlookup>
    80003824:	8caa                	mv	s9,a0
    80003826:	d555                	beqz	a0,800037d2 <namex+0x7e>
    iunlockput(ip);
    80003828:	854e                	mv	a0,s3
    8000382a:	c47ff0ef          	jal	ra,80003470 <iunlockput>
    ip = next;
    8000382e:	89e6                	mv	s3,s9
  while(*path == '/')
    80003830:	0004c783          	lbu	a5,0(s1)
    80003834:	05279363          	bne	a5,s2,8000387a <namex+0x126>
    path++;
    80003838:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000383a:	0004c783          	lbu	a5,0(s1)
    8000383e:	ff278de3          	beq	a5,s2,80003838 <namex+0xe4>
  if(*path == 0)
    80003842:	c78d                	beqz	a5,8000386c <namex+0x118>
    path++;
    80003844:	85a6                	mv	a1,s1
  len = path - s;
    80003846:	8cda                	mv	s9,s6
    80003848:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000384a:	01278963          	beq	a5,s2,8000385c <namex+0x108>
    8000384e:	d7d9                	beqz	a5,800037dc <namex+0x88>
    path++;
    80003850:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003852:	0004c783          	lbu	a5,0(s1)
    80003856:	ff279ce3          	bne	a5,s2,8000384e <namex+0xfa>
    8000385a:	b749                	j	800037dc <namex+0x88>
    memmove(name, s, len);
    8000385c:	2601                	sext.w	a2,a2
    8000385e:	8552                	mv	a0,s4
    80003860:	c6afd0ef          	jal	ra,80000cca <memmove>
    name[len] = 0;
    80003864:	9cd2                	add	s9,s9,s4
    80003866:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000386a:	b759                	j	800037f0 <namex+0x9c>
  if(nameiparent){
    8000386c:	f40a81e3          	beqz	s5,800037ae <namex+0x5a>
    iput(ip);
    80003870:	854e                	mv	a0,s3
    80003872:	b77ff0ef          	jal	ra,800033e8 <iput>
    return 0;
    80003876:	4981                	li	s3,0
    80003878:	bf1d                	j	800037ae <namex+0x5a>
  if(*path == 0)
    8000387a:	dbed                	beqz	a5,8000386c <namex+0x118>
  while(*path != '/' && *path != 0)
    8000387c:	0004c783          	lbu	a5,0(s1)
    80003880:	85a6                	mv	a1,s1
    80003882:	b7f1                	j	8000384e <namex+0xfa>

0000000080003884 <dirlink>:
{
    80003884:	7139                	addi	sp,sp,-64
    80003886:	fc06                	sd	ra,56(sp)
    80003888:	f822                	sd	s0,48(sp)
    8000388a:	f426                	sd	s1,40(sp)
    8000388c:	f04a                	sd	s2,32(sp)
    8000388e:	ec4e                	sd	s3,24(sp)
    80003890:	e852                	sd	s4,16(sp)
    80003892:	0080                	addi	s0,sp,64
    80003894:	892a                	mv	s2,a0
    80003896:	8a2e                	mv	s4,a1
    80003898:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000389a:	4601                	li	a2,0
    8000389c:	e1dff0ef          	jal	ra,800036b8 <dirlookup>
    800038a0:	e52d                	bnez	a0,8000390a <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038a2:	04c92483          	lw	s1,76(s2)
    800038a6:	c48d                	beqz	s1,800038d0 <dirlink+0x4c>
    800038a8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038aa:	4741                	li	a4,16
    800038ac:	86a6                	mv	a3,s1
    800038ae:	fc040613          	addi	a2,s0,-64
    800038b2:	4581                	li	a1,0
    800038b4:	854a                	mv	a0,s2
    800038b6:	c05ff0ef          	jal	ra,800034ba <readi>
    800038ba:	47c1                	li	a5,16
    800038bc:	04f51b63          	bne	a0,a5,80003912 <dirlink+0x8e>
    if(de.inum == 0)
    800038c0:	fc045783          	lhu	a5,-64(s0)
    800038c4:	c791                	beqz	a5,800038d0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038c6:	24c1                	addiw	s1,s1,16
    800038c8:	04c92783          	lw	a5,76(s2)
    800038cc:	fcf4efe3          	bltu	s1,a5,800038aa <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800038d0:	4639                	li	a2,14
    800038d2:	85d2                	mv	a1,s4
    800038d4:	fc240513          	addi	a0,s0,-62
    800038d8:	c9efd0ef          	jal	ra,80000d76 <strncpy>
  de.inum = inum;
    800038dc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038e0:	4741                	li	a4,16
    800038e2:	86a6                	mv	a3,s1
    800038e4:	fc040613          	addi	a2,s0,-64
    800038e8:	4581                	li	a1,0
    800038ea:	854a                	mv	a0,s2
    800038ec:	cb3ff0ef          	jal	ra,8000359e <writei>
    800038f0:	1541                	addi	a0,a0,-16
    800038f2:	00a03533          	snez	a0,a0
    800038f6:	40a00533          	neg	a0,a0
}
    800038fa:	70e2                	ld	ra,56(sp)
    800038fc:	7442                	ld	s0,48(sp)
    800038fe:	74a2                	ld	s1,40(sp)
    80003900:	7902                	ld	s2,32(sp)
    80003902:	69e2                	ld	s3,24(sp)
    80003904:	6a42                	ld	s4,16(sp)
    80003906:	6121                	addi	sp,sp,64
    80003908:	8082                	ret
    iput(ip);
    8000390a:	adfff0ef          	jal	ra,800033e8 <iput>
    return -1;
    8000390e:	557d                	li	a0,-1
    80003910:	b7ed                	j	800038fa <dirlink+0x76>
      panic("dirlink read");
    80003912:	00004517          	auipc	a0,0x4
    80003916:	d5e50513          	addi	a0,a0,-674 # 80007670 <syscalls+0x1e0>
    8000391a:	e3dfc0ef          	jal	ra,80000756 <panic>

000000008000391e <namei>:

struct inode*
namei(char *path)
{
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003926:	fe040613          	addi	a2,s0,-32
    8000392a:	4581                	li	a1,0
    8000392c:	e29ff0ef          	jal	ra,80003754 <namex>
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003938:	1141                	addi	sp,sp,-16
    8000393a:	e406                	sd	ra,8(sp)
    8000393c:	e022                	sd	s0,0(sp)
    8000393e:	0800                	addi	s0,sp,16
    80003940:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003942:	4585                	li	a1,1
    80003944:	e11ff0ef          	jal	ra,80003754 <namex>
}
    80003948:	60a2                	ld	ra,8(sp)
    8000394a:	6402                	ld	s0,0(sp)
    8000394c:	0141                	addi	sp,sp,16
    8000394e:	8082                	ret

0000000080003950 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	e04a                	sd	s2,0(sp)
    8000395a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000395c:	00022917          	auipc	s2,0x22
    80003960:	54c90913          	addi	s2,s2,1356 # 80025ea8 <log>
    80003964:	01892583          	lw	a1,24(s2)
    80003968:	02892503          	lw	a0,40(s2)
    8000396c:	9e0ff0ef          	jal	ra,80002b4c <bread>
    80003970:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003972:	02c92683          	lw	a3,44(s2)
    80003976:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003978:	02d05763          	blez	a3,800039a6 <write_head+0x56>
    8000397c:	00022797          	auipc	a5,0x22
    80003980:	55c78793          	addi	a5,a5,1372 # 80025ed8 <log+0x30>
    80003984:	05c50713          	addi	a4,a0,92
    80003988:	36fd                	addiw	a3,a3,-1
    8000398a:	1682                	slli	a3,a3,0x20
    8000398c:	9281                	srli	a3,a3,0x20
    8000398e:	068a                	slli	a3,a3,0x2
    80003990:	00022617          	auipc	a2,0x22
    80003994:	54c60613          	addi	a2,a2,1356 # 80025edc <log+0x34>
    80003998:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000399a:	4390                	lw	a2,0(a5)
    8000399c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000399e:	0791                	addi	a5,a5,4
    800039a0:	0711                	addi	a4,a4,4
    800039a2:	fed79ce3          	bne	a5,a3,8000399a <write_head+0x4a>
  }
  bwrite(buf);
    800039a6:	8526                	mv	a0,s1
    800039a8:	a7aff0ef          	jal	ra,80002c22 <bwrite>
  brelse(buf);
    800039ac:	8526                	mv	a0,s1
    800039ae:	aa6ff0ef          	jal	ra,80002c54 <brelse>
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6902                	ld	s2,0(sp)
    800039ba:	6105                	addi	sp,sp,32
    800039bc:	8082                	ret

00000000800039be <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800039be:	00022797          	auipc	a5,0x22
    800039c2:	5167a783          	lw	a5,1302(a5) # 80025ed4 <log+0x2c>
    800039c6:	08f05f63          	blez	a5,80003a64 <install_trans+0xa6>
{
    800039ca:	7139                	addi	sp,sp,-64
    800039cc:	fc06                	sd	ra,56(sp)
    800039ce:	f822                	sd	s0,48(sp)
    800039d0:	f426                	sd	s1,40(sp)
    800039d2:	f04a                	sd	s2,32(sp)
    800039d4:	ec4e                	sd	s3,24(sp)
    800039d6:	e852                	sd	s4,16(sp)
    800039d8:	e456                	sd	s5,8(sp)
    800039da:	e05a                	sd	s6,0(sp)
    800039dc:	0080                	addi	s0,sp,64
    800039de:	8b2a                	mv	s6,a0
    800039e0:	00022a97          	auipc	s5,0x22
    800039e4:	4f8a8a93          	addi	s5,s5,1272 # 80025ed8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039e8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039ea:	00022997          	auipc	s3,0x22
    800039ee:	4be98993          	addi	s3,s3,1214 # 80025ea8 <log>
    800039f2:	a829                	j	80003a0c <install_trans+0x4e>
    brelse(lbuf);
    800039f4:	854a                	mv	a0,s2
    800039f6:	a5eff0ef          	jal	ra,80002c54 <brelse>
    brelse(dbuf);
    800039fa:	8526                	mv	a0,s1
    800039fc:	a58ff0ef          	jal	ra,80002c54 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a00:	2a05                	addiw	s4,s4,1
    80003a02:	0a91                	addi	s5,s5,4
    80003a04:	02c9a783          	lw	a5,44(s3)
    80003a08:	04fa5463          	bge	s4,a5,80003a50 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a0c:	0189a583          	lw	a1,24(s3)
    80003a10:	014585bb          	addw	a1,a1,s4
    80003a14:	2585                	addiw	a1,a1,1
    80003a16:	0289a503          	lw	a0,40(s3)
    80003a1a:	932ff0ef          	jal	ra,80002b4c <bread>
    80003a1e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003a20:	000aa583          	lw	a1,0(s5)
    80003a24:	0289a503          	lw	a0,40(s3)
    80003a28:	924ff0ef          	jal	ra,80002b4c <bread>
    80003a2c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a2e:	40000613          	li	a2,1024
    80003a32:	05890593          	addi	a1,s2,88
    80003a36:	05850513          	addi	a0,a0,88
    80003a3a:	a90fd0ef          	jal	ra,80000cca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a3e:	8526                	mv	a0,s1
    80003a40:	9e2ff0ef          	jal	ra,80002c22 <bwrite>
    if(recovering == 0)
    80003a44:	fa0b18e3          	bnez	s6,800039f4 <install_trans+0x36>
      bunpin(dbuf);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	ac8ff0ef          	jal	ra,80002d12 <bunpin>
    80003a4e:	b75d                	j	800039f4 <install_trans+0x36>
}
    80003a50:	70e2                	ld	ra,56(sp)
    80003a52:	7442                	ld	s0,48(sp)
    80003a54:	74a2                	ld	s1,40(sp)
    80003a56:	7902                	ld	s2,32(sp)
    80003a58:	69e2                	ld	s3,24(sp)
    80003a5a:	6a42                	ld	s4,16(sp)
    80003a5c:	6aa2                	ld	s5,8(sp)
    80003a5e:	6b02                	ld	s6,0(sp)
    80003a60:	6121                	addi	sp,sp,64
    80003a62:	8082                	ret
    80003a64:	8082                	ret

0000000080003a66 <initlog>:
{
    80003a66:	7179                	addi	sp,sp,-48
    80003a68:	f406                	sd	ra,40(sp)
    80003a6a:	f022                	sd	s0,32(sp)
    80003a6c:	ec26                	sd	s1,24(sp)
    80003a6e:	e84a                	sd	s2,16(sp)
    80003a70:	e44e                	sd	s3,8(sp)
    80003a72:	1800                	addi	s0,sp,48
    80003a74:	892a                	mv	s2,a0
    80003a76:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a78:	00022497          	auipc	s1,0x22
    80003a7c:	43048493          	addi	s1,s1,1072 # 80025ea8 <log>
    80003a80:	00004597          	auipc	a1,0x4
    80003a84:	c0058593          	addi	a1,a1,-1024 # 80007680 <syscalls+0x1f0>
    80003a88:	8526                	mv	a0,s1
    80003a8a:	890fd0ef          	jal	ra,80000b1a <initlock>
  log.start = sb->logstart;
    80003a8e:	0149a583          	lw	a1,20(s3)
    80003a92:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a94:	0109a783          	lw	a5,16(s3)
    80003a98:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a9a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	8acff0ef          	jal	ra,80002b4c <bread>
  log.lh.n = lh->n;
    80003aa4:	4d34                	lw	a3,88(a0)
    80003aa6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003aa8:	02d05563          	blez	a3,80003ad2 <initlog+0x6c>
    80003aac:	05c50793          	addi	a5,a0,92
    80003ab0:	00022717          	auipc	a4,0x22
    80003ab4:	42870713          	addi	a4,a4,1064 # 80025ed8 <log+0x30>
    80003ab8:	36fd                	addiw	a3,a3,-1
    80003aba:	1682                	slli	a3,a3,0x20
    80003abc:	9281                	srli	a3,a3,0x20
    80003abe:	068a                	slli	a3,a3,0x2
    80003ac0:	06050613          	addi	a2,a0,96
    80003ac4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003ac6:	4390                	lw	a2,0(a5)
    80003ac8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003aca:	0791                	addi	a5,a5,4
    80003acc:	0711                	addi	a4,a4,4
    80003ace:	fed79ce3          	bne	a5,a3,80003ac6 <initlog+0x60>
  brelse(buf);
    80003ad2:	982ff0ef          	jal	ra,80002c54 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003ad6:	4505                	li	a0,1
    80003ad8:	ee7ff0ef          	jal	ra,800039be <install_trans>
  log.lh.n = 0;
    80003adc:	00022797          	auipc	a5,0x22
    80003ae0:	3e07ac23          	sw	zero,1016(a5) # 80025ed4 <log+0x2c>
  write_head(); // clear the log
    80003ae4:	e6dff0ef          	jal	ra,80003950 <write_head>
}
    80003ae8:	70a2                	ld	ra,40(sp)
    80003aea:	7402                	ld	s0,32(sp)
    80003aec:	64e2                	ld	s1,24(sp)
    80003aee:	6942                	ld	s2,16(sp)
    80003af0:	69a2                	ld	s3,8(sp)
    80003af2:	6145                	addi	sp,sp,48
    80003af4:	8082                	ret

0000000080003af6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003af6:	1101                	addi	sp,sp,-32
    80003af8:	ec06                	sd	ra,24(sp)
    80003afa:	e822                	sd	s0,16(sp)
    80003afc:	e426                	sd	s1,8(sp)
    80003afe:	e04a                	sd	s2,0(sp)
    80003b00:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003b02:	00022517          	auipc	a0,0x22
    80003b06:	3a650513          	addi	a0,a0,934 # 80025ea8 <log>
    80003b0a:	890fd0ef          	jal	ra,80000b9a <acquire>
  while(1){
    if(log.committing){
    80003b0e:	00022497          	auipc	s1,0x22
    80003b12:	39a48493          	addi	s1,s1,922 # 80025ea8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b16:	4979                	li	s2,30
    80003b18:	a029                	j	80003b22 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003b1a:	85a6                	mv	a1,s1
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	b20fe0ef          	jal	ra,80001e3e <sleep>
    if(log.committing){
    80003b22:	50dc                	lw	a5,36(s1)
    80003b24:	fbfd                	bnez	a5,80003b1a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b26:	509c                	lw	a5,32(s1)
    80003b28:	0017871b          	addiw	a4,a5,1
    80003b2c:	0007069b          	sext.w	a3,a4
    80003b30:	0027179b          	slliw	a5,a4,0x2
    80003b34:	9fb9                	addw	a5,a5,a4
    80003b36:	0017979b          	slliw	a5,a5,0x1
    80003b3a:	54d8                	lw	a4,44(s1)
    80003b3c:	9fb9                	addw	a5,a5,a4
    80003b3e:	00f95763          	bge	s2,a5,80003b4c <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b42:	85a6                	mv	a1,s1
    80003b44:	8526                	mv	a0,s1
    80003b46:	af8fe0ef          	jal	ra,80001e3e <sleep>
    80003b4a:	bfe1                	j	80003b22 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003b4c:	00022517          	auipc	a0,0x22
    80003b50:	35c50513          	addi	a0,a0,860 # 80025ea8 <log>
    80003b54:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003b56:	8dcfd0ef          	jal	ra,80000c32 <release>
      break;
    }
  }
}
    80003b5a:	60e2                	ld	ra,24(sp)
    80003b5c:	6442                	ld	s0,16(sp)
    80003b5e:	64a2                	ld	s1,8(sp)
    80003b60:	6902                	ld	s2,0(sp)
    80003b62:	6105                	addi	sp,sp,32
    80003b64:	8082                	ret

0000000080003b66 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b66:	7139                	addi	sp,sp,-64
    80003b68:	fc06                	sd	ra,56(sp)
    80003b6a:	f822                	sd	s0,48(sp)
    80003b6c:	f426                	sd	s1,40(sp)
    80003b6e:	f04a                	sd	s2,32(sp)
    80003b70:	ec4e                	sd	s3,24(sp)
    80003b72:	e852                	sd	s4,16(sp)
    80003b74:	e456                	sd	s5,8(sp)
    80003b76:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003b78:	00022497          	auipc	s1,0x22
    80003b7c:	33048493          	addi	s1,s1,816 # 80025ea8 <log>
    80003b80:	8526                	mv	a0,s1
    80003b82:	818fd0ef          	jal	ra,80000b9a <acquire>
  log.outstanding -= 1;
    80003b86:	509c                	lw	a5,32(s1)
    80003b88:	37fd                	addiw	a5,a5,-1
    80003b8a:	0007891b          	sext.w	s2,a5
    80003b8e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b90:	50dc                	lw	a5,36(s1)
    80003b92:	ef9d                	bnez	a5,80003bd0 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b94:	04091463          	bnez	s2,80003bdc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b98:	00022497          	auipc	s1,0x22
    80003b9c:	31048493          	addi	s1,s1,784 # 80025ea8 <log>
    80003ba0:	4785                	li	a5,1
    80003ba2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	88cfd0ef          	jal	ra,80000c32 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003baa:	54dc                	lw	a5,44(s1)
    80003bac:	04f04b63          	bgtz	a5,80003c02 <end_op+0x9c>
    acquire(&log.lock);
    80003bb0:	00022497          	auipc	s1,0x22
    80003bb4:	2f848493          	addi	s1,s1,760 # 80025ea8 <log>
    80003bb8:	8526                	mv	a0,s1
    80003bba:	fe1fc0ef          	jal	ra,80000b9a <acquire>
    log.committing = 0;
    80003bbe:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003bc2:	8526                	mv	a0,s1
    80003bc4:	ac6fe0ef          	jal	ra,80001e8a <wakeup>
    release(&log.lock);
    80003bc8:	8526                	mv	a0,s1
    80003bca:	868fd0ef          	jal	ra,80000c32 <release>
}
    80003bce:	a00d                	j	80003bf0 <end_op+0x8a>
    panic("log.committing");
    80003bd0:	00004517          	auipc	a0,0x4
    80003bd4:	ab850513          	addi	a0,a0,-1352 # 80007688 <syscalls+0x1f8>
    80003bd8:	b7ffc0ef          	jal	ra,80000756 <panic>
    wakeup(&log);
    80003bdc:	00022497          	auipc	s1,0x22
    80003be0:	2cc48493          	addi	s1,s1,716 # 80025ea8 <log>
    80003be4:	8526                	mv	a0,s1
    80003be6:	aa4fe0ef          	jal	ra,80001e8a <wakeup>
  release(&log.lock);
    80003bea:	8526                	mv	a0,s1
    80003bec:	846fd0ef          	jal	ra,80000c32 <release>
}
    80003bf0:	70e2                	ld	ra,56(sp)
    80003bf2:	7442                	ld	s0,48(sp)
    80003bf4:	74a2                	ld	s1,40(sp)
    80003bf6:	7902                	ld	s2,32(sp)
    80003bf8:	69e2                	ld	s3,24(sp)
    80003bfa:	6a42                	ld	s4,16(sp)
    80003bfc:	6aa2                	ld	s5,8(sp)
    80003bfe:	6121                	addi	sp,sp,64
    80003c00:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c02:	00022a97          	auipc	s5,0x22
    80003c06:	2d6a8a93          	addi	s5,s5,726 # 80025ed8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003c0a:	00022a17          	auipc	s4,0x22
    80003c0e:	29ea0a13          	addi	s4,s4,670 # 80025ea8 <log>
    80003c12:	018a2583          	lw	a1,24(s4)
    80003c16:	012585bb          	addw	a1,a1,s2
    80003c1a:	2585                	addiw	a1,a1,1
    80003c1c:	028a2503          	lw	a0,40(s4)
    80003c20:	f2dfe0ef          	jal	ra,80002b4c <bread>
    80003c24:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003c26:	000aa583          	lw	a1,0(s5)
    80003c2a:	028a2503          	lw	a0,40(s4)
    80003c2e:	f1ffe0ef          	jal	ra,80002b4c <bread>
    80003c32:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c34:	40000613          	li	a2,1024
    80003c38:	05850593          	addi	a1,a0,88
    80003c3c:	05848513          	addi	a0,s1,88
    80003c40:	88afd0ef          	jal	ra,80000cca <memmove>
    bwrite(to);  // write the log
    80003c44:	8526                	mv	a0,s1
    80003c46:	fddfe0ef          	jal	ra,80002c22 <bwrite>
    brelse(from);
    80003c4a:	854e                	mv	a0,s3
    80003c4c:	808ff0ef          	jal	ra,80002c54 <brelse>
    brelse(to);
    80003c50:	8526                	mv	a0,s1
    80003c52:	802ff0ef          	jal	ra,80002c54 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c56:	2905                	addiw	s2,s2,1
    80003c58:	0a91                	addi	s5,s5,4
    80003c5a:	02ca2783          	lw	a5,44(s4)
    80003c5e:	faf94ae3          	blt	s2,a5,80003c12 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c62:	cefff0ef          	jal	ra,80003950 <write_head>
    install_trans(0); // Now install writes to home locations
    80003c66:	4501                	li	a0,0
    80003c68:	d57ff0ef          	jal	ra,800039be <install_trans>
    log.lh.n = 0;
    80003c6c:	00022797          	auipc	a5,0x22
    80003c70:	2607a423          	sw	zero,616(a5) # 80025ed4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c74:	cddff0ef          	jal	ra,80003950 <write_head>
    80003c78:	bf25                	j	80003bb0 <end_op+0x4a>

0000000080003c7a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c7a:	1101                	addi	sp,sp,-32
    80003c7c:	ec06                	sd	ra,24(sp)
    80003c7e:	e822                	sd	s0,16(sp)
    80003c80:	e426                	sd	s1,8(sp)
    80003c82:	e04a                	sd	s2,0(sp)
    80003c84:	1000                	addi	s0,sp,32
    80003c86:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c88:	00022917          	auipc	s2,0x22
    80003c8c:	22090913          	addi	s2,s2,544 # 80025ea8 <log>
    80003c90:	854a                	mv	a0,s2
    80003c92:	f09fc0ef          	jal	ra,80000b9a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c96:	02c92603          	lw	a2,44(s2)
    80003c9a:	47f5                	li	a5,29
    80003c9c:	06c7c363          	blt	a5,a2,80003d02 <log_write+0x88>
    80003ca0:	00022797          	auipc	a5,0x22
    80003ca4:	2247a783          	lw	a5,548(a5) # 80025ec4 <log+0x1c>
    80003ca8:	37fd                	addiw	a5,a5,-1
    80003caa:	04f65c63          	bge	a2,a5,80003d02 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003cae:	00022797          	auipc	a5,0x22
    80003cb2:	21a7a783          	lw	a5,538(a5) # 80025ec8 <log+0x20>
    80003cb6:	04f05c63          	blez	a5,80003d0e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003cba:	4781                	li	a5,0
    80003cbc:	04c05f63          	blez	a2,80003d1a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cc0:	44cc                	lw	a1,12(s1)
    80003cc2:	00022717          	auipc	a4,0x22
    80003cc6:	21670713          	addi	a4,a4,534 # 80025ed8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003cca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ccc:	4314                	lw	a3,0(a4)
    80003cce:	04b68663          	beq	a3,a1,80003d1a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003cd2:	2785                	addiw	a5,a5,1
    80003cd4:	0711                	addi	a4,a4,4
    80003cd6:	fef61be3          	bne	a2,a5,80003ccc <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003cda:	0621                	addi	a2,a2,8
    80003cdc:	060a                	slli	a2,a2,0x2
    80003cde:	00022797          	auipc	a5,0x22
    80003ce2:	1ca78793          	addi	a5,a5,458 # 80025ea8 <log>
    80003ce6:	963e                	add	a2,a2,a5
    80003ce8:	44dc                	lw	a5,12(s1)
    80003cea:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003cec:	8526                	mv	a0,s1
    80003cee:	ff1fe0ef          	jal	ra,80002cde <bpin>
    log.lh.n++;
    80003cf2:	00022717          	auipc	a4,0x22
    80003cf6:	1b670713          	addi	a4,a4,438 # 80025ea8 <log>
    80003cfa:	575c                	lw	a5,44(a4)
    80003cfc:	2785                	addiw	a5,a5,1
    80003cfe:	d75c                	sw	a5,44(a4)
    80003d00:	a815                	j	80003d34 <log_write+0xba>
    panic("too big a transaction");
    80003d02:	00004517          	auipc	a0,0x4
    80003d06:	99650513          	addi	a0,a0,-1642 # 80007698 <syscalls+0x208>
    80003d0a:	a4dfc0ef          	jal	ra,80000756 <panic>
    panic("log_write outside of trans");
    80003d0e:	00004517          	auipc	a0,0x4
    80003d12:	9a250513          	addi	a0,a0,-1630 # 800076b0 <syscalls+0x220>
    80003d16:	a41fc0ef          	jal	ra,80000756 <panic>
  log.lh.block[i] = b->blockno;
    80003d1a:	00878713          	addi	a4,a5,8
    80003d1e:	00271693          	slli	a3,a4,0x2
    80003d22:	00022717          	auipc	a4,0x22
    80003d26:	18670713          	addi	a4,a4,390 # 80025ea8 <log>
    80003d2a:	9736                	add	a4,a4,a3
    80003d2c:	44d4                	lw	a3,12(s1)
    80003d2e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003d30:	faf60ee3          	beq	a2,a5,80003cec <log_write+0x72>
  }
  release(&log.lock);
    80003d34:	00022517          	auipc	a0,0x22
    80003d38:	17450513          	addi	a0,a0,372 # 80025ea8 <log>
    80003d3c:	ef7fc0ef          	jal	ra,80000c32 <release>
}
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6902                	ld	s2,0(sp)
    80003d48:	6105                	addi	sp,sp,32
    80003d4a:	8082                	ret

0000000080003d4c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d4c:	1101                	addi	sp,sp,-32
    80003d4e:	ec06                	sd	ra,24(sp)
    80003d50:	e822                	sd	s0,16(sp)
    80003d52:	e426                	sd	s1,8(sp)
    80003d54:	e04a                	sd	s2,0(sp)
    80003d56:	1000                	addi	s0,sp,32
    80003d58:	84aa                	mv	s1,a0
    80003d5a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d5c:	00004597          	auipc	a1,0x4
    80003d60:	97458593          	addi	a1,a1,-1676 # 800076d0 <syscalls+0x240>
    80003d64:	0521                	addi	a0,a0,8
    80003d66:	db5fc0ef          	jal	ra,80000b1a <initlock>
  lk->name = name;
    80003d6a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d72:	0204a423          	sw	zero,40(s1)
}
    80003d76:	60e2                	ld	ra,24(sp)
    80003d78:	6442                	ld	s0,16(sp)
    80003d7a:	64a2                	ld	s1,8(sp)
    80003d7c:	6902                	ld	s2,0(sp)
    80003d7e:	6105                	addi	sp,sp,32
    80003d80:	8082                	ret

0000000080003d82 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d82:	1101                	addi	sp,sp,-32
    80003d84:	ec06                	sd	ra,24(sp)
    80003d86:	e822                	sd	s0,16(sp)
    80003d88:	e426                	sd	s1,8(sp)
    80003d8a:	e04a                	sd	s2,0(sp)
    80003d8c:	1000                	addi	s0,sp,32
    80003d8e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d90:	00850913          	addi	s2,a0,8
    80003d94:	854a                	mv	a0,s2
    80003d96:	e05fc0ef          	jal	ra,80000b9a <acquire>
  while (lk->locked) {
    80003d9a:	409c                	lw	a5,0(s1)
    80003d9c:	c799                	beqz	a5,80003daa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d9e:	85ca                	mv	a1,s2
    80003da0:	8526                	mv	a0,s1
    80003da2:	89cfe0ef          	jal	ra,80001e3e <sleep>
  while (lk->locked) {
    80003da6:	409c                	lw	a5,0(s1)
    80003da8:	fbfd                	bnez	a5,80003d9e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003daa:	4785                	li	a5,1
    80003dac:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003dae:	a7ffd0ef          	jal	ra,8000182c <myproc>
    80003db2:	591c                	lw	a5,48(a0)
    80003db4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003db6:	854a                	mv	a0,s2
    80003db8:	e7bfc0ef          	jal	ra,80000c32 <release>
}
    80003dbc:	60e2                	ld	ra,24(sp)
    80003dbe:	6442                	ld	s0,16(sp)
    80003dc0:	64a2                	ld	s1,8(sp)
    80003dc2:	6902                	ld	s2,0(sp)
    80003dc4:	6105                	addi	sp,sp,32
    80003dc6:	8082                	ret

0000000080003dc8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003dc8:	1101                	addi	sp,sp,-32
    80003dca:	ec06                	sd	ra,24(sp)
    80003dcc:	e822                	sd	s0,16(sp)
    80003dce:	e426                	sd	s1,8(sp)
    80003dd0:	e04a                	sd	s2,0(sp)
    80003dd2:	1000                	addi	s0,sp,32
    80003dd4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003dd6:	00850913          	addi	s2,a0,8
    80003dda:	854a                	mv	a0,s2
    80003ddc:	dbffc0ef          	jal	ra,80000b9a <acquire>
  lk->locked = 0;
    80003de0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003de4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003de8:	8526                	mv	a0,s1
    80003dea:	8a0fe0ef          	jal	ra,80001e8a <wakeup>
  release(&lk->lk);
    80003dee:	854a                	mv	a0,s2
    80003df0:	e43fc0ef          	jal	ra,80000c32 <release>
}
    80003df4:	60e2                	ld	ra,24(sp)
    80003df6:	6442                	ld	s0,16(sp)
    80003df8:	64a2                	ld	s1,8(sp)
    80003dfa:	6902                	ld	s2,0(sp)
    80003dfc:	6105                	addi	sp,sp,32
    80003dfe:	8082                	ret

0000000080003e00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003e00:	7179                	addi	sp,sp,-48
    80003e02:	f406                	sd	ra,40(sp)
    80003e04:	f022                	sd	s0,32(sp)
    80003e06:	ec26                	sd	s1,24(sp)
    80003e08:	e84a                	sd	s2,16(sp)
    80003e0a:	e44e                	sd	s3,8(sp)
    80003e0c:	1800                	addi	s0,sp,48
    80003e0e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e10:	00850913          	addi	s2,a0,8
    80003e14:	854a                	mv	a0,s2
    80003e16:	d85fc0ef          	jal	ra,80000b9a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e1a:	409c                	lw	a5,0(s1)
    80003e1c:	ef89                	bnez	a5,80003e36 <holdingsleep+0x36>
    80003e1e:	4481                	li	s1,0
  release(&lk->lk);
    80003e20:	854a                	mv	a0,s2
    80003e22:	e11fc0ef          	jal	ra,80000c32 <release>
  return r;
}
    80003e26:	8526                	mv	a0,s1
    80003e28:	70a2                	ld	ra,40(sp)
    80003e2a:	7402                	ld	s0,32(sp)
    80003e2c:	64e2                	ld	s1,24(sp)
    80003e2e:	6942                	ld	s2,16(sp)
    80003e30:	69a2                	ld	s3,8(sp)
    80003e32:	6145                	addi	sp,sp,48
    80003e34:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e36:	0284a983          	lw	s3,40(s1)
    80003e3a:	9f3fd0ef          	jal	ra,8000182c <myproc>
    80003e3e:	5904                	lw	s1,48(a0)
    80003e40:	413484b3          	sub	s1,s1,s3
    80003e44:	0014b493          	seqz	s1,s1
    80003e48:	bfe1                	j	80003e20 <holdingsleep+0x20>

0000000080003e4a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e4a:	1141                	addi	sp,sp,-16
    80003e4c:	e406                	sd	ra,8(sp)
    80003e4e:	e022                	sd	s0,0(sp)
    80003e50:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e52:	00004597          	auipc	a1,0x4
    80003e56:	88e58593          	addi	a1,a1,-1906 # 800076e0 <syscalls+0x250>
    80003e5a:	00022517          	auipc	a0,0x22
    80003e5e:	19650513          	addi	a0,a0,406 # 80025ff0 <ftable>
    80003e62:	cb9fc0ef          	jal	ra,80000b1a <initlock>
}
    80003e66:	60a2                	ld	ra,8(sp)
    80003e68:	6402                	ld	s0,0(sp)
    80003e6a:	0141                	addi	sp,sp,16
    80003e6c:	8082                	ret

0000000080003e6e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003e6e:	1101                	addi	sp,sp,-32
    80003e70:	ec06                	sd	ra,24(sp)
    80003e72:	e822                	sd	s0,16(sp)
    80003e74:	e426                	sd	s1,8(sp)
    80003e76:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e78:	00022517          	auipc	a0,0x22
    80003e7c:	17850513          	addi	a0,a0,376 # 80025ff0 <ftable>
    80003e80:	d1bfc0ef          	jal	ra,80000b9a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e84:	00022497          	auipc	s1,0x22
    80003e88:	18448493          	addi	s1,s1,388 # 80026008 <ftable+0x18>
    80003e8c:	00023717          	auipc	a4,0x23
    80003e90:	11c70713          	addi	a4,a4,284 # 80026fa8 <disk>
    if(f->ref == 0){
    80003e94:	40dc                	lw	a5,4(s1)
    80003e96:	cf89                	beqz	a5,80003eb0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e98:	02848493          	addi	s1,s1,40
    80003e9c:	fee49ce3          	bne	s1,a4,80003e94 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ea0:	00022517          	auipc	a0,0x22
    80003ea4:	15050513          	addi	a0,a0,336 # 80025ff0 <ftable>
    80003ea8:	d8bfc0ef          	jal	ra,80000c32 <release>
  return 0;
    80003eac:	4481                	li	s1,0
    80003eae:	a809                	j	80003ec0 <filealloc+0x52>
      f->ref = 1;
    80003eb0:	4785                	li	a5,1
    80003eb2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003eb4:	00022517          	auipc	a0,0x22
    80003eb8:	13c50513          	addi	a0,a0,316 # 80025ff0 <ftable>
    80003ebc:	d77fc0ef          	jal	ra,80000c32 <release>
}
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	60e2                	ld	ra,24(sp)
    80003ec4:	6442                	ld	s0,16(sp)
    80003ec6:	64a2                	ld	s1,8(sp)
    80003ec8:	6105                	addi	sp,sp,32
    80003eca:	8082                	ret

0000000080003ecc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ecc:	1101                	addi	sp,sp,-32
    80003ece:	ec06                	sd	ra,24(sp)
    80003ed0:	e822                	sd	s0,16(sp)
    80003ed2:	e426                	sd	s1,8(sp)
    80003ed4:	1000                	addi	s0,sp,32
    80003ed6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ed8:	00022517          	auipc	a0,0x22
    80003edc:	11850513          	addi	a0,a0,280 # 80025ff0 <ftable>
    80003ee0:	cbbfc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003ee4:	40dc                	lw	a5,4(s1)
    80003ee6:	02f05063          	blez	a5,80003f06 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003eea:	2785                	addiw	a5,a5,1
    80003eec:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003eee:	00022517          	auipc	a0,0x22
    80003ef2:	10250513          	addi	a0,a0,258 # 80025ff0 <ftable>
    80003ef6:	d3dfc0ef          	jal	ra,80000c32 <release>
  return f;
}
    80003efa:	8526                	mv	a0,s1
    80003efc:	60e2                	ld	ra,24(sp)
    80003efe:	6442                	ld	s0,16(sp)
    80003f00:	64a2                	ld	s1,8(sp)
    80003f02:	6105                	addi	sp,sp,32
    80003f04:	8082                	ret
    panic("filedup");
    80003f06:	00003517          	auipc	a0,0x3
    80003f0a:	7e250513          	addi	a0,a0,2018 # 800076e8 <syscalls+0x258>
    80003f0e:	849fc0ef          	jal	ra,80000756 <panic>

0000000080003f12 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f12:	7139                	addi	sp,sp,-64
    80003f14:	fc06                	sd	ra,56(sp)
    80003f16:	f822                	sd	s0,48(sp)
    80003f18:	f426                	sd	s1,40(sp)
    80003f1a:	f04a                	sd	s2,32(sp)
    80003f1c:	ec4e                	sd	s3,24(sp)
    80003f1e:	e852                	sd	s4,16(sp)
    80003f20:	e456                	sd	s5,8(sp)
    80003f22:	0080                	addi	s0,sp,64
    80003f24:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f26:	00022517          	auipc	a0,0x22
    80003f2a:	0ca50513          	addi	a0,a0,202 # 80025ff0 <ftable>
    80003f2e:	c6dfc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003f32:	40dc                	lw	a5,4(s1)
    80003f34:	04f05963          	blez	a5,80003f86 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003f38:	37fd                	addiw	a5,a5,-1
    80003f3a:	0007871b          	sext.w	a4,a5
    80003f3e:	c0dc                	sw	a5,4(s1)
    80003f40:	04e04963          	bgtz	a4,80003f92 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f44:	0004a903          	lw	s2,0(s1)
    80003f48:	0094ca83          	lbu	s5,9(s1)
    80003f4c:	0104ba03          	ld	s4,16(s1)
    80003f50:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f54:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f58:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f5c:	00022517          	auipc	a0,0x22
    80003f60:	09450513          	addi	a0,a0,148 # 80025ff0 <ftable>
    80003f64:	ccffc0ef          	jal	ra,80000c32 <release>

  if(ff.type == FD_PIPE){
    80003f68:	4785                	li	a5,1
    80003f6a:	04f90363          	beq	s2,a5,80003fb0 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003f6e:	3979                	addiw	s2,s2,-2
    80003f70:	4785                	li	a5,1
    80003f72:	0327e663          	bltu	a5,s2,80003f9e <fileclose+0x8c>
    begin_op();
    80003f76:	b81ff0ef          	jal	ra,80003af6 <begin_op>
    iput(ff.ip);
    80003f7a:	854e                	mv	a0,s3
    80003f7c:	c6cff0ef          	jal	ra,800033e8 <iput>
    end_op();
    80003f80:	be7ff0ef          	jal	ra,80003b66 <end_op>
    80003f84:	a829                	j	80003f9e <fileclose+0x8c>
    panic("fileclose");
    80003f86:	00003517          	auipc	a0,0x3
    80003f8a:	76a50513          	addi	a0,a0,1898 # 800076f0 <syscalls+0x260>
    80003f8e:	fc8fc0ef          	jal	ra,80000756 <panic>
    release(&ftable.lock);
    80003f92:	00022517          	auipc	a0,0x22
    80003f96:	05e50513          	addi	a0,a0,94 # 80025ff0 <ftable>
    80003f9a:	c99fc0ef          	jal	ra,80000c32 <release>
  }
}
    80003f9e:	70e2                	ld	ra,56(sp)
    80003fa0:	7442                	ld	s0,48(sp)
    80003fa2:	74a2                	ld	s1,40(sp)
    80003fa4:	7902                	ld	s2,32(sp)
    80003fa6:	69e2                	ld	s3,24(sp)
    80003fa8:	6a42                	ld	s4,16(sp)
    80003faa:	6aa2                	ld	s5,8(sp)
    80003fac:	6121                	addi	sp,sp,64
    80003fae:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003fb0:	85d6                	mv	a1,s5
    80003fb2:	8552                	mv	a0,s4
    80003fb4:	2ec000ef          	jal	ra,800042a0 <pipeclose>
    80003fb8:	b7dd                	j	80003f9e <fileclose+0x8c>

0000000080003fba <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003fba:	715d                	addi	sp,sp,-80
    80003fbc:	e486                	sd	ra,72(sp)
    80003fbe:	e0a2                	sd	s0,64(sp)
    80003fc0:	fc26                	sd	s1,56(sp)
    80003fc2:	f84a                	sd	s2,48(sp)
    80003fc4:	f44e                	sd	s3,40(sp)
    80003fc6:	0880                	addi	s0,sp,80
    80003fc8:	84aa                	mv	s1,a0
    80003fca:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003fcc:	861fd0ef          	jal	ra,8000182c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003fd0:	409c                	lw	a5,0(s1)
    80003fd2:	37f9                	addiw	a5,a5,-2
    80003fd4:	4705                	li	a4,1
    80003fd6:	02f76f63          	bltu	a4,a5,80004014 <filestat+0x5a>
    80003fda:	892a                	mv	s2,a0
    ilock(f->ip);
    80003fdc:	6c88                	ld	a0,24(s1)
    80003fde:	a8cff0ef          	jal	ra,8000326a <ilock>
    stati(f->ip, &st);
    80003fe2:	fb840593          	addi	a1,s0,-72
    80003fe6:	6c88                	ld	a0,24(s1)
    80003fe8:	ca8ff0ef          	jal	ra,80003490 <stati>
    iunlock(f->ip);
    80003fec:	6c88                	ld	a0,24(s1)
    80003fee:	b26ff0ef          	jal	ra,80003314 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ff2:	46e1                	li	a3,24
    80003ff4:	fb840613          	addi	a2,s0,-72
    80003ff8:	85ce                	mv	a1,s3
    80003ffa:	05093503          	ld	a0,80(s2)
    80003ffe:	ce2fd0ef          	jal	ra,800014e0 <copyout>
    80004002:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004006:	60a6                	ld	ra,72(sp)
    80004008:	6406                	ld	s0,64(sp)
    8000400a:	74e2                	ld	s1,56(sp)
    8000400c:	7942                	ld	s2,48(sp)
    8000400e:	79a2                	ld	s3,40(sp)
    80004010:	6161                	addi	sp,sp,80
    80004012:	8082                	ret
  return -1;
    80004014:	557d                	li	a0,-1
    80004016:	bfc5                	j	80004006 <filestat+0x4c>

0000000080004018 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004018:	7179                	addi	sp,sp,-48
    8000401a:	f406                	sd	ra,40(sp)
    8000401c:	f022                	sd	s0,32(sp)
    8000401e:	ec26                	sd	s1,24(sp)
    80004020:	e84a                	sd	s2,16(sp)
    80004022:	e44e                	sd	s3,8(sp)
    80004024:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004026:	00854783          	lbu	a5,8(a0)
    8000402a:	cbc1                	beqz	a5,800040ba <fileread+0xa2>
    8000402c:	84aa                	mv	s1,a0
    8000402e:	89ae                	mv	s3,a1
    80004030:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004032:	411c                	lw	a5,0(a0)
    80004034:	4705                	li	a4,1
    80004036:	04e78363          	beq	a5,a4,8000407c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000403a:	470d                	li	a4,3
    8000403c:	04e78563          	beq	a5,a4,80004086 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004040:	4709                	li	a4,2
    80004042:	06e79663          	bne	a5,a4,800040ae <fileread+0x96>
    ilock(f->ip);
    80004046:	6d08                	ld	a0,24(a0)
    80004048:	a22ff0ef          	jal	ra,8000326a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000404c:	874a                	mv	a4,s2
    8000404e:	5094                	lw	a3,32(s1)
    80004050:	864e                	mv	a2,s3
    80004052:	4585                	li	a1,1
    80004054:	6c88                	ld	a0,24(s1)
    80004056:	c64ff0ef          	jal	ra,800034ba <readi>
    8000405a:	892a                	mv	s2,a0
    8000405c:	00a05563          	blez	a0,80004066 <fileread+0x4e>
      f->off += r;
    80004060:	509c                	lw	a5,32(s1)
    80004062:	9fa9                	addw	a5,a5,a0
    80004064:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004066:	6c88                	ld	a0,24(s1)
    80004068:	aacff0ef          	jal	ra,80003314 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000406c:	854a                	mv	a0,s2
    8000406e:	70a2                	ld	ra,40(sp)
    80004070:	7402                	ld	s0,32(sp)
    80004072:	64e2                	ld	s1,24(sp)
    80004074:	6942                	ld	s2,16(sp)
    80004076:	69a2                	ld	s3,8(sp)
    80004078:	6145                	addi	sp,sp,48
    8000407a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000407c:	6908                	ld	a0,16(a0)
    8000407e:	34e000ef          	jal	ra,800043cc <piperead>
    80004082:	892a                	mv	s2,a0
    80004084:	b7e5                	j	8000406c <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004086:	02451783          	lh	a5,36(a0)
    8000408a:	03079693          	slli	a3,a5,0x30
    8000408e:	92c1                	srli	a3,a3,0x30
    80004090:	4725                	li	a4,9
    80004092:	02d76663          	bltu	a4,a3,800040be <fileread+0xa6>
    80004096:	0792                	slli	a5,a5,0x4
    80004098:	00022717          	auipc	a4,0x22
    8000409c:	eb870713          	addi	a4,a4,-328 # 80025f50 <devsw>
    800040a0:	97ba                	add	a5,a5,a4
    800040a2:	639c                	ld	a5,0(a5)
    800040a4:	cf99                	beqz	a5,800040c2 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    800040a6:	4505                	li	a0,1
    800040a8:	9782                	jalr	a5
    800040aa:	892a                	mv	s2,a0
    800040ac:	b7c1                	j	8000406c <fileread+0x54>
    panic("fileread");
    800040ae:	00003517          	auipc	a0,0x3
    800040b2:	65250513          	addi	a0,a0,1618 # 80007700 <syscalls+0x270>
    800040b6:	ea0fc0ef          	jal	ra,80000756 <panic>
    return -1;
    800040ba:	597d                	li	s2,-1
    800040bc:	bf45                	j	8000406c <fileread+0x54>
      return -1;
    800040be:	597d                	li	s2,-1
    800040c0:	b775                	j	8000406c <fileread+0x54>
    800040c2:	597d                	li	s2,-1
    800040c4:	b765                	j	8000406c <fileread+0x54>

00000000800040c6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800040c6:	715d                	addi	sp,sp,-80
    800040c8:	e486                	sd	ra,72(sp)
    800040ca:	e0a2                	sd	s0,64(sp)
    800040cc:	fc26                	sd	s1,56(sp)
    800040ce:	f84a                	sd	s2,48(sp)
    800040d0:	f44e                	sd	s3,40(sp)
    800040d2:	f052                	sd	s4,32(sp)
    800040d4:	ec56                	sd	s5,24(sp)
    800040d6:	e85a                	sd	s6,16(sp)
    800040d8:	e45e                	sd	s7,8(sp)
    800040da:	e062                	sd	s8,0(sp)
    800040dc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800040de:	00954783          	lbu	a5,9(a0)
    800040e2:	0e078863          	beqz	a5,800041d2 <filewrite+0x10c>
    800040e6:	892a                	mv	s2,a0
    800040e8:	8aae                	mv	s5,a1
    800040ea:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800040ec:	411c                	lw	a5,0(a0)
    800040ee:	4705                	li	a4,1
    800040f0:	02e78263          	beq	a5,a4,80004114 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040f4:	470d                	li	a4,3
    800040f6:	02e78463          	beq	a5,a4,8000411e <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800040fa:	4709                	li	a4,2
    800040fc:	0ce79563          	bne	a5,a4,800041c6 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004100:	0ac05163          	blez	a2,800041a2 <filewrite+0xdc>
    int i = 0;
    80004104:	4981                	li	s3,0
    80004106:	6b05                	lui	s6,0x1
    80004108:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000410c:	6b85                	lui	s7,0x1
    8000410e:	c00b8b9b          	addiw	s7,s7,-1024
    80004112:	a041                	j	80004192 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004114:	6908                	ld	a0,16(a0)
    80004116:	1e2000ef          	jal	ra,800042f8 <pipewrite>
    8000411a:	8a2a                	mv	s4,a0
    8000411c:	a071                	j	800041a8 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000411e:	02451783          	lh	a5,36(a0)
    80004122:	03079693          	slli	a3,a5,0x30
    80004126:	92c1                	srli	a3,a3,0x30
    80004128:	4725                	li	a4,9
    8000412a:	0ad76663          	bltu	a4,a3,800041d6 <filewrite+0x110>
    8000412e:	0792                	slli	a5,a5,0x4
    80004130:	00022717          	auipc	a4,0x22
    80004134:	e2070713          	addi	a4,a4,-480 # 80025f50 <devsw>
    80004138:	97ba                	add	a5,a5,a4
    8000413a:	679c                	ld	a5,8(a5)
    8000413c:	cfd9                	beqz	a5,800041da <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    8000413e:	4505                	li	a0,1
    80004140:	9782                	jalr	a5
    80004142:	8a2a                	mv	s4,a0
    80004144:	a095                	j	800041a8 <filewrite+0xe2>
    80004146:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000414a:	9adff0ef          	jal	ra,80003af6 <begin_op>
      ilock(f->ip);
    8000414e:	01893503          	ld	a0,24(s2)
    80004152:	918ff0ef          	jal	ra,8000326a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004156:	8762                	mv	a4,s8
    80004158:	02092683          	lw	a3,32(s2)
    8000415c:	01598633          	add	a2,s3,s5
    80004160:	4585                	li	a1,1
    80004162:	01893503          	ld	a0,24(s2)
    80004166:	c38ff0ef          	jal	ra,8000359e <writei>
    8000416a:	84aa                	mv	s1,a0
    8000416c:	00a05763          	blez	a0,8000417a <filewrite+0xb4>
        f->off += r;
    80004170:	02092783          	lw	a5,32(s2)
    80004174:	9fa9                	addw	a5,a5,a0
    80004176:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000417a:	01893503          	ld	a0,24(s2)
    8000417e:	996ff0ef          	jal	ra,80003314 <iunlock>
      end_op();
    80004182:	9e5ff0ef          	jal	ra,80003b66 <end_op>

      if(r != n1){
    80004186:	009c1f63          	bne	s8,s1,800041a4 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000418a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000418e:	0149db63          	bge	s3,s4,800041a4 <filewrite+0xde>
      int n1 = n - i;
    80004192:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004196:	84be                	mv	s1,a5
    80004198:	2781                	sext.w	a5,a5
    8000419a:	fafb56e3          	bge	s6,a5,80004146 <filewrite+0x80>
    8000419e:	84de                	mv	s1,s7
    800041a0:	b75d                	j	80004146 <filewrite+0x80>
    int i = 0;
    800041a2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800041a4:	013a1f63          	bne	s4,s3,800041c2 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800041a8:	8552                	mv	a0,s4
    800041aa:	60a6                	ld	ra,72(sp)
    800041ac:	6406                	ld	s0,64(sp)
    800041ae:	74e2                	ld	s1,56(sp)
    800041b0:	7942                	ld	s2,48(sp)
    800041b2:	79a2                	ld	s3,40(sp)
    800041b4:	7a02                	ld	s4,32(sp)
    800041b6:	6ae2                	ld	s5,24(sp)
    800041b8:	6b42                	ld	s6,16(sp)
    800041ba:	6ba2                	ld	s7,8(sp)
    800041bc:	6c02                	ld	s8,0(sp)
    800041be:	6161                	addi	sp,sp,80
    800041c0:	8082                	ret
    ret = (i == n ? n : -1);
    800041c2:	5a7d                	li	s4,-1
    800041c4:	b7d5                	j	800041a8 <filewrite+0xe2>
    panic("filewrite");
    800041c6:	00003517          	auipc	a0,0x3
    800041ca:	54a50513          	addi	a0,a0,1354 # 80007710 <syscalls+0x280>
    800041ce:	d88fc0ef          	jal	ra,80000756 <panic>
    return -1;
    800041d2:	5a7d                	li	s4,-1
    800041d4:	bfd1                	j	800041a8 <filewrite+0xe2>
      return -1;
    800041d6:	5a7d                	li	s4,-1
    800041d8:	bfc1                	j	800041a8 <filewrite+0xe2>
    800041da:	5a7d                	li	s4,-1
    800041dc:	b7f1                	j	800041a8 <filewrite+0xe2>

00000000800041de <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800041de:	7179                	addi	sp,sp,-48
    800041e0:	f406                	sd	ra,40(sp)
    800041e2:	f022                	sd	s0,32(sp)
    800041e4:	ec26                	sd	s1,24(sp)
    800041e6:	e84a                	sd	s2,16(sp)
    800041e8:	e44e                	sd	s3,8(sp)
    800041ea:	e052                	sd	s4,0(sp)
    800041ec:	1800                	addi	s0,sp,48
    800041ee:	84aa                	mv	s1,a0
    800041f0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041f2:	0005b023          	sd	zero,0(a1)
    800041f6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041fa:	c75ff0ef          	jal	ra,80003e6e <filealloc>
    800041fe:	e088                	sd	a0,0(s1)
    80004200:	cd35                	beqz	a0,8000427c <pipealloc+0x9e>
    80004202:	c6dff0ef          	jal	ra,80003e6e <filealloc>
    80004206:	00aa3023          	sd	a0,0(s4)
    8000420a:	c52d                	beqz	a0,80004274 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000420c:	8bffc0ef          	jal	ra,80000aca <kalloc>
    80004210:	892a                	mv	s2,a0
    80004212:	cd31                	beqz	a0,8000426e <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004214:	4985                	li	s3,1
    80004216:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000421a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000421e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004222:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004226:	00003597          	auipc	a1,0x3
    8000422a:	4fa58593          	addi	a1,a1,1274 # 80007720 <syscalls+0x290>
    8000422e:	8edfc0ef          	jal	ra,80000b1a <initlock>
  (*f0)->type = FD_PIPE;
    80004232:	609c                	ld	a5,0(s1)
    80004234:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004238:	609c                	ld	a5,0(s1)
    8000423a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000423e:	609c                	ld	a5,0(s1)
    80004240:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004244:	609c                	ld	a5,0(s1)
    80004246:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000424a:	000a3783          	ld	a5,0(s4)
    8000424e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004252:	000a3783          	ld	a5,0(s4)
    80004256:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000425a:	000a3783          	ld	a5,0(s4)
    8000425e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004262:	000a3783          	ld	a5,0(s4)
    80004266:	0127b823          	sd	s2,16(a5)
  return 0;
    8000426a:	4501                	li	a0,0
    8000426c:	a005                	j	8000428c <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000426e:	6088                	ld	a0,0(s1)
    80004270:	e501                	bnez	a0,80004278 <pipealloc+0x9a>
    80004272:	a029                	j	8000427c <pipealloc+0x9e>
    80004274:	6088                	ld	a0,0(s1)
    80004276:	c11d                	beqz	a0,8000429c <pipealloc+0xbe>
    fileclose(*f0);
    80004278:	c9bff0ef          	jal	ra,80003f12 <fileclose>
  if(*f1)
    8000427c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004280:	557d                	li	a0,-1
  if(*f1)
    80004282:	c789                	beqz	a5,8000428c <pipealloc+0xae>
    fileclose(*f1);
    80004284:	853e                	mv	a0,a5
    80004286:	c8dff0ef          	jal	ra,80003f12 <fileclose>
  return -1;
    8000428a:	557d                	li	a0,-1
}
    8000428c:	70a2                	ld	ra,40(sp)
    8000428e:	7402                	ld	s0,32(sp)
    80004290:	64e2                	ld	s1,24(sp)
    80004292:	6942                	ld	s2,16(sp)
    80004294:	69a2                	ld	s3,8(sp)
    80004296:	6a02                	ld	s4,0(sp)
    80004298:	6145                	addi	sp,sp,48
    8000429a:	8082                	ret
  return -1;
    8000429c:	557d                	li	a0,-1
    8000429e:	b7fd                	j	8000428c <pipealloc+0xae>

00000000800042a0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800042a0:	1101                	addi	sp,sp,-32
    800042a2:	ec06                	sd	ra,24(sp)
    800042a4:	e822                	sd	s0,16(sp)
    800042a6:	e426                	sd	s1,8(sp)
    800042a8:	e04a                	sd	s2,0(sp)
    800042aa:	1000                	addi	s0,sp,32
    800042ac:	84aa                	mv	s1,a0
    800042ae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800042b0:	8ebfc0ef          	jal	ra,80000b9a <acquire>
  if(writable){
    800042b4:	02090763          	beqz	s2,800042e2 <pipeclose+0x42>
    pi->writeopen = 0;
    800042b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800042bc:	21848513          	addi	a0,s1,536
    800042c0:	bcbfd0ef          	jal	ra,80001e8a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800042c4:	2204b783          	ld	a5,544(s1)
    800042c8:	e785                	bnez	a5,800042f0 <pipeclose+0x50>
    release(&pi->lock);
    800042ca:	8526                	mv	a0,s1
    800042cc:	967fc0ef          	jal	ra,80000c32 <release>
    kfree((char*)pi);
    800042d0:	8526                	mv	a0,s1
    800042d2:	f18fc0ef          	jal	ra,800009ea <kfree>
  } else
    release(&pi->lock);
}
    800042d6:	60e2                	ld	ra,24(sp)
    800042d8:	6442                	ld	s0,16(sp)
    800042da:	64a2                	ld	s1,8(sp)
    800042dc:	6902                	ld	s2,0(sp)
    800042de:	6105                	addi	sp,sp,32
    800042e0:	8082                	ret
    pi->readopen = 0;
    800042e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042e6:	21c48513          	addi	a0,s1,540
    800042ea:	ba1fd0ef          	jal	ra,80001e8a <wakeup>
    800042ee:	bfd9                	j	800042c4 <pipeclose+0x24>
    release(&pi->lock);
    800042f0:	8526                	mv	a0,s1
    800042f2:	941fc0ef          	jal	ra,80000c32 <release>
}
    800042f6:	b7c5                	j	800042d6 <pipeclose+0x36>

00000000800042f8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042f8:	711d                	addi	sp,sp,-96
    800042fa:	ec86                	sd	ra,88(sp)
    800042fc:	e8a2                	sd	s0,80(sp)
    800042fe:	e4a6                	sd	s1,72(sp)
    80004300:	e0ca                	sd	s2,64(sp)
    80004302:	fc4e                	sd	s3,56(sp)
    80004304:	f852                	sd	s4,48(sp)
    80004306:	f456                	sd	s5,40(sp)
    80004308:	f05a                	sd	s6,32(sp)
    8000430a:	ec5e                	sd	s7,24(sp)
    8000430c:	e862                	sd	s8,16(sp)
    8000430e:	1080                	addi	s0,sp,96
    80004310:	84aa                	mv	s1,a0
    80004312:	8aae                	mv	s5,a1
    80004314:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004316:	d16fd0ef          	jal	ra,8000182c <myproc>
    8000431a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000431c:	8526                	mv	a0,s1
    8000431e:	87dfc0ef          	jal	ra,80000b9a <acquire>
  while(i < n){
    80004322:	09405c63          	blez	s4,800043ba <pipewrite+0xc2>
  int i = 0;
    80004326:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004328:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000432a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000432e:	21c48b93          	addi	s7,s1,540
    80004332:	a81d                	j	80004368 <pipewrite+0x70>
      release(&pi->lock);
    80004334:	8526                	mv	a0,s1
    80004336:	8fdfc0ef          	jal	ra,80000c32 <release>
      return -1;
    8000433a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000433c:	854a                	mv	a0,s2
    8000433e:	60e6                	ld	ra,88(sp)
    80004340:	6446                	ld	s0,80(sp)
    80004342:	64a6                	ld	s1,72(sp)
    80004344:	6906                	ld	s2,64(sp)
    80004346:	79e2                	ld	s3,56(sp)
    80004348:	7a42                	ld	s4,48(sp)
    8000434a:	7aa2                	ld	s5,40(sp)
    8000434c:	7b02                	ld	s6,32(sp)
    8000434e:	6be2                	ld	s7,24(sp)
    80004350:	6c42                	ld	s8,16(sp)
    80004352:	6125                	addi	sp,sp,96
    80004354:	8082                	ret
      wakeup(&pi->nread);
    80004356:	8562                	mv	a0,s8
    80004358:	b33fd0ef          	jal	ra,80001e8a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000435c:	85a6                	mv	a1,s1
    8000435e:	855e                	mv	a0,s7
    80004360:	adffd0ef          	jal	ra,80001e3e <sleep>
  while(i < n){
    80004364:	05495c63          	bge	s2,s4,800043bc <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80004368:	2204a783          	lw	a5,544(s1)
    8000436c:	d7e1                	beqz	a5,80004334 <pipewrite+0x3c>
    8000436e:	854e                	mv	a0,s3
    80004370:	d07fd0ef          	jal	ra,80002076 <killed>
    80004374:	f161                	bnez	a0,80004334 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004376:	2184a783          	lw	a5,536(s1)
    8000437a:	21c4a703          	lw	a4,540(s1)
    8000437e:	2007879b          	addiw	a5,a5,512
    80004382:	fcf70ae3          	beq	a4,a5,80004356 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004386:	4685                	li	a3,1
    80004388:	01590633          	add	a2,s2,s5
    8000438c:	faf40593          	addi	a1,s0,-81
    80004390:	0509b503          	ld	a0,80(s3)
    80004394:	a04fd0ef          	jal	ra,80001598 <copyin>
    80004398:	03650263          	beq	a0,s6,800043bc <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000439c:	21c4a783          	lw	a5,540(s1)
    800043a0:	0017871b          	addiw	a4,a5,1
    800043a4:	20e4ae23          	sw	a4,540(s1)
    800043a8:	1ff7f793          	andi	a5,a5,511
    800043ac:	97a6                	add	a5,a5,s1
    800043ae:	faf44703          	lbu	a4,-81(s0)
    800043b2:	00e78c23          	sb	a4,24(a5)
      i++;
    800043b6:	2905                	addiw	s2,s2,1
    800043b8:	b775                	j	80004364 <pipewrite+0x6c>
  int i = 0;
    800043ba:	4901                	li	s2,0
  wakeup(&pi->nread);
    800043bc:	21848513          	addi	a0,s1,536
    800043c0:	acbfd0ef          	jal	ra,80001e8a <wakeup>
  release(&pi->lock);
    800043c4:	8526                	mv	a0,s1
    800043c6:	86dfc0ef          	jal	ra,80000c32 <release>
  return i;
    800043ca:	bf8d                	j	8000433c <pipewrite+0x44>

00000000800043cc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800043cc:	715d                	addi	sp,sp,-80
    800043ce:	e486                	sd	ra,72(sp)
    800043d0:	e0a2                	sd	s0,64(sp)
    800043d2:	fc26                	sd	s1,56(sp)
    800043d4:	f84a                	sd	s2,48(sp)
    800043d6:	f44e                	sd	s3,40(sp)
    800043d8:	f052                	sd	s4,32(sp)
    800043da:	ec56                	sd	s5,24(sp)
    800043dc:	e85a                	sd	s6,16(sp)
    800043de:	0880                	addi	s0,sp,80
    800043e0:	84aa                	mv	s1,a0
    800043e2:	892e                	mv	s2,a1
    800043e4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043e6:	c46fd0ef          	jal	ra,8000182c <myproc>
    800043ea:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043ec:	8526                	mv	a0,s1
    800043ee:	facfc0ef          	jal	ra,80000b9a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043f2:	2184a703          	lw	a4,536(s1)
    800043f6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043fa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043fe:	02f71363          	bne	a4,a5,80004424 <piperead+0x58>
    80004402:	2244a783          	lw	a5,548(s1)
    80004406:	cf99                	beqz	a5,80004424 <piperead+0x58>
    if(killed(pr)){
    80004408:	8552                	mv	a0,s4
    8000440a:	c6dfd0ef          	jal	ra,80002076 <killed>
    8000440e:	e141                	bnez	a0,8000448e <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004410:	85a6                	mv	a1,s1
    80004412:	854e                	mv	a0,s3
    80004414:	a2bfd0ef          	jal	ra,80001e3e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004418:	2184a703          	lw	a4,536(s1)
    8000441c:	21c4a783          	lw	a5,540(s1)
    80004420:	fef701e3          	beq	a4,a5,80004402 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004424:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004426:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004428:	05505163          	blez	s5,8000446a <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    8000442c:	2184a783          	lw	a5,536(s1)
    80004430:	21c4a703          	lw	a4,540(s1)
    80004434:	02f70b63          	beq	a4,a5,8000446a <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004438:	0017871b          	addiw	a4,a5,1
    8000443c:	20e4ac23          	sw	a4,536(s1)
    80004440:	1ff7f793          	andi	a5,a5,511
    80004444:	97a6                	add	a5,a5,s1
    80004446:	0187c783          	lbu	a5,24(a5)
    8000444a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000444e:	4685                	li	a3,1
    80004450:	fbf40613          	addi	a2,s0,-65
    80004454:	85ca                	mv	a1,s2
    80004456:	050a3503          	ld	a0,80(s4)
    8000445a:	886fd0ef          	jal	ra,800014e0 <copyout>
    8000445e:	01650663          	beq	a0,s6,8000446a <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004462:	2985                	addiw	s3,s3,1
    80004464:	0905                	addi	s2,s2,1
    80004466:	fd3a93e3          	bne	s5,s3,8000442c <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000446a:	21c48513          	addi	a0,s1,540
    8000446e:	a1dfd0ef          	jal	ra,80001e8a <wakeup>
  release(&pi->lock);
    80004472:	8526                	mv	a0,s1
    80004474:	fbefc0ef          	jal	ra,80000c32 <release>
  return i;
}
    80004478:	854e                	mv	a0,s3
    8000447a:	60a6                	ld	ra,72(sp)
    8000447c:	6406                	ld	s0,64(sp)
    8000447e:	74e2                	ld	s1,56(sp)
    80004480:	7942                	ld	s2,48(sp)
    80004482:	79a2                	ld	s3,40(sp)
    80004484:	7a02                	ld	s4,32(sp)
    80004486:	6ae2                	ld	s5,24(sp)
    80004488:	6b42                	ld	s6,16(sp)
    8000448a:	6161                	addi	sp,sp,80
    8000448c:	8082                	ret
      release(&pi->lock);
    8000448e:	8526                	mv	a0,s1
    80004490:	fa2fc0ef          	jal	ra,80000c32 <release>
      return -1;
    80004494:	59fd                	li	s3,-1
    80004496:	b7cd                	j	80004478 <piperead+0xac>

0000000080004498 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004498:	1141                	addi	sp,sp,-16
    8000449a:	e422                	sd	s0,8(sp)
    8000449c:	0800                	addi	s0,sp,16
    8000449e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800044a0:	8905                	andi	a0,a0,1
    800044a2:	c111                	beqz	a0,800044a6 <flags2perm+0xe>
      perm = PTE_X;
    800044a4:	4521                	li	a0,8
    if(flags & 0x2)
    800044a6:	8b89                	andi	a5,a5,2
    800044a8:	c399                	beqz	a5,800044ae <flags2perm+0x16>
      perm |= PTE_W;
    800044aa:	00456513          	ori	a0,a0,4
    return perm;
}
    800044ae:	6422                	ld	s0,8(sp)
    800044b0:	0141                	addi	sp,sp,16
    800044b2:	8082                	ret

00000000800044b4 <exec>:

int
exec(char *path, char **argv)
{
    800044b4:	de010113          	addi	sp,sp,-544
    800044b8:	20113c23          	sd	ra,536(sp)
    800044bc:	20813823          	sd	s0,528(sp)
    800044c0:	20913423          	sd	s1,520(sp)
    800044c4:	21213023          	sd	s2,512(sp)
    800044c8:	ffce                	sd	s3,504(sp)
    800044ca:	fbd2                	sd	s4,496(sp)
    800044cc:	f7d6                	sd	s5,488(sp)
    800044ce:	f3da                	sd	s6,480(sp)
    800044d0:	efde                	sd	s7,472(sp)
    800044d2:	ebe2                	sd	s8,464(sp)
    800044d4:	e7e6                	sd	s9,456(sp)
    800044d6:	e3ea                	sd	s10,448(sp)
    800044d8:	ff6e                	sd	s11,440(sp)
    800044da:	1400                	addi	s0,sp,544
    800044dc:	892a                	mv	s2,a0
    800044de:	dea43423          	sd	a0,-536(s0)
    800044e2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800044e6:	b46fd0ef          	jal	ra,8000182c <myproc>
    800044ea:	84aa                	mv	s1,a0

  begin_op();
    800044ec:	e0aff0ef          	jal	ra,80003af6 <begin_op>

  if((ip = namei(path)) == 0){
    800044f0:	854a                	mv	a0,s2
    800044f2:	c2cff0ef          	jal	ra,8000391e <namei>
    800044f6:	c13d                	beqz	a0,8000455c <exec+0xa8>
    800044f8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044fa:	d71fe0ef          	jal	ra,8000326a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044fe:	04000713          	li	a4,64
    80004502:	4681                	li	a3,0
    80004504:	e5040613          	addi	a2,s0,-432
    80004508:	4581                	li	a1,0
    8000450a:	8556                	mv	a0,s5
    8000450c:	faffe0ef          	jal	ra,800034ba <readi>
    80004510:	04000793          	li	a5,64
    80004514:	00f51a63          	bne	a0,a5,80004528 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004518:	e5042703          	lw	a4,-432(s0)
    8000451c:	464c47b7          	lui	a5,0x464c4
    80004520:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004524:	04f70063          	beq	a4,a5,80004564 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004528:	8556                	mv	a0,s5
    8000452a:	f47fe0ef          	jal	ra,80003470 <iunlockput>
    end_op();
    8000452e:	e38ff0ef          	jal	ra,80003b66 <end_op>
  }
  return -1;
    80004532:	557d                	li	a0,-1
}
    80004534:	21813083          	ld	ra,536(sp)
    80004538:	21013403          	ld	s0,528(sp)
    8000453c:	20813483          	ld	s1,520(sp)
    80004540:	20013903          	ld	s2,512(sp)
    80004544:	79fe                	ld	s3,504(sp)
    80004546:	7a5e                	ld	s4,496(sp)
    80004548:	7abe                	ld	s5,488(sp)
    8000454a:	7b1e                	ld	s6,480(sp)
    8000454c:	6bfe                	ld	s7,472(sp)
    8000454e:	6c5e                	ld	s8,464(sp)
    80004550:	6cbe                	ld	s9,456(sp)
    80004552:	6d1e                	ld	s10,448(sp)
    80004554:	7dfa                	ld	s11,440(sp)
    80004556:	22010113          	addi	sp,sp,544
    8000455a:	8082                	ret
    end_op();
    8000455c:	e0aff0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004560:	557d                	li	a0,-1
    80004562:	bfc9                	j	80004534 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80004564:	8526                	mv	a0,s1
    80004566:	b6efd0ef          	jal	ra,800018d4 <proc_pagetable>
    8000456a:	8b2a                	mv	s6,a0
    8000456c:	dd55                	beqz	a0,80004528 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000456e:	e7042783          	lw	a5,-400(s0)
    80004572:	e8845703          	lhu	a4,-376(s0)
    80004576:	c325                	beqz	a4,800045d6 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004578:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000457a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000457e:	6a05                	lui	s4,0x1
    80004580:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004584:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004588:	6d85                	lui	s11,0x1
    8000458a:	7d7d                	lui	s10,0xfffff
    8000458c:	a411                	j	80004790 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000458e:	00003517          	auipc	a0,0x3
    80004592:	19a50513          	addi	a0,a0,410 # 80007728 <syscalls+0x298>
    80004596:	9c0fc0ef          	jal	ra,80000756 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000459a:	874a                	mv	a4,s2
    8000459c:	009c86bb          	addw	a3,s9,s1
    800045a0:	4581                	li	a1,0
    800045a2:	8556                	mv	a0,s5
    800045a4:	f17fe0ef          	jal	ra,800034ba <readi>
    800045a8:	2501                	sext.w	a0,a0
    800045aa:	18a91263          	bne	s2,a0,8000472e <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    800045ae:	009d84bb          	addw	s1,s11,s1
    800045b2:	013d09bb          	addw	s3,s10,s3
    800045b6:	1b74fd63          	bgeu	s1,s7,80004770 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    800045ba:	02049593          	slli	a1,s1,0x20
    800045be:	9181                	srli	a1,a1,0x20
    800045c0:	95e2                	add	a1,a1,s8
    800045c2:	855a                	mv	a0,s6
    800045c4:	9c1fc0ef          	jal	ra,80000f84 <walkaddr>
    800045c8:	862a                	mv	a2,a0
    if(pa == 0)
    800045ca:	d171                	beqz	a0,8000458e <exec+0xda>
      n = PGSIZE;
    800045cc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800045ce:	fd49f6e3          	bgeu	s3,s4,8000459a <exec+0xe6>
      n = sz - i;
    800045d2:	894e                	mv	s2,s3
    800045d4:	b7d9                	j	8000459a <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045d6:	4901                	li	s2,0
  iunlockput(ip);
    800045d8:	8556                	mv	a0,s5
    800045da:	e97fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    800045de:	d88ff0ef          	jal	ra,80003b66 <end_op>
  p = myproc();
    800045e2:	a4afd0ef          	jal	ra,8000182c <myproc>
    800045e6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800045e8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800045ec:	6785                	lui	a5,0x1
    800045ee:	17fd                	addi	a5,a5,-1
    800045f0:	993e                	add	s2,s2,a5
    800045f2:	77fd                	lui	a5,0xfffff
    800045f4:	00f977b3          	and	a5,s2,a5
    800045f8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800045fc:	4691                	li	a3,4
    800045fe:	6609                	lui	a2,0x2
    80004600:	963e                	add	a2,a2,a5
    80004602:	85be                	mv	a1,a5
    80004604:	855a                	mv	a0,s6
    80004606:	cd7fc0ef          	jal	ra,800012dc <uvmalloc>
    8000460a:	8c2a                	mv	s8,a0
  ip = 0;
    8000460c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000460e:	12050063          	beqz	a0,8000472e <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004612:	75f9                	lui	a1,0xffffe
    80004614:	95aa                	add	a1,a1,a0
    80004616:	855a                	mv	a0,s6
    80004618:	e9ffc0ef          	jal	ra,800014b6 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000461c:	7afd                	lui	s5,0xfffff
    8000461e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004620:	df043783          	ld	a5,-528(s0)
    80004624:	6388                	ld	a0,0(a5)
    80004626:	c135                	beqz	a0,8000468a <exec+0x1d6>
    80004628:	e9040993          	addi	s3,s0,-368
    8000462c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004630:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004632:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004634:	fb2fc0ef          	jal	ra,80000de6 <strlen>
    80004638:	0015079b          	addiw	a5,a0,1
    8000463c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004640:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004644:	11596a63          	bltu	s2,s5,80004758 <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004648:	df043d83          	ld	s11,-528(s0)
    8000464c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004650:	8552                	mv	a0,s4
    80004652:	f94fc0ef          	jal	ra,80000de6 <strlen>
    80004656:	0015069b          	addiw	a3,a0,1
    8000465a:	8652                	mv	a2,s4
    8000465c:	85ca                	mv	a1,s2
    8000465e:	855a                	mv	a0,s6
    80004660:	e81fc0ef          	jal	ra,800014e0 <copyout>
    80004664:	0e054e63          	bltz	a0,80004760 <exec+0x2ac>
    ustack[argc] = sp;
    80004668:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000466c:	0485                	addi	s1,s1,1
    8000466e:	008d8793          	addi	a5,s11,8
    80004672:	def43823          	sd	a5,-528(s0)
    80004676:	008db503          	ld	a0,8(s11)
    8000467a:	c911                	beqz	a0,8000468e <exec+0x1da>
    if(argc >= MAXARG)
    8000467c:	09a1                	addi	s3,s3,8
    8000467e:	fb3c9be3          	bne	s9,s3,80004634 <exec+0x180>
  sz = sz1;
    80004682:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004686:	4a81                	li	s5,0
    80004688:	a05d                	j	8000472e <exec+0x27a>
  sp = sz;
    8000468a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000468c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000468e:	00349793          	slli	a5,s1,0x3
    80004692:	f9040713          	addi	a4,s0,-112
    80004696:	97ba                	add	a5,a5,a4
    80004698:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd7e18>
  sp -= (argc+1) * sizeof(uint64);
    8000469c:	00148693          	addi	a3,s1,1
    800046a0:	068e                	slli	a3,a3,0x3
    800046a2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800046a6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800046aa:	01597663          	bgeu	s2,s5,800046b6 <exec+0x202>
  sz = sz1;
    800046ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800046b2:	4a81                	li	s5,0
    800046b4:	a8ad                	j	8000472e <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800046b6:	e9040613          	addi	a2,s0,-368
    800046ba:	85ca                	mv	a1,s2
    800046bc:	855a                	mv	a0,s6
    800046be:	e23fc0ef          	jal	ra,800014e0 <copyout>
    800046c2:	0a054363          	bltz	a0,80004768 <exec+0x2b4>
  p->trapframe->a1 = sp;
    800046c6:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800046ca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800046ce:	de843783          	ld	a5,-536(s0)
    800046d2:	0007c703          	lbu	a4,0(a5)
    800046d6:	cf11                	beqz	a4,800046f2 <exec+0x23e>
    800046d8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800046da:	02f00693          	li	a3,47
    800046de:	a039                	j	800046ec <exec+0x238>
      last = s+1;
    800046e0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800046e4:	0785                	addi	a5,a5,1
    800046e6:	fff7c703          	lbu	a4,-1(a5)
    800046ea:	c701                	beqz	a4,800046f2 <exec+0x23e>
    if(*s == '/')
    800046ec:	fed71ce3          	bne	a4,a3,800046e4 <exec+0x230>
    800046f0:	bfc5                	j	800046e0 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    800046f2:	4641                	li	a2,16
    800046f4:	de843583          	ld	a1,-536(s0)
    800046f8:	158b8513          	addi	a0,s7,344
    800046fc:	eb8fc0ef          	jal	ra,80000db4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004700:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004704:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004708:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000470c:	058bb783          	ld	a5,88(s7)
    80004710:	e6843703          	ld	a4,-408(s0)
    80004714:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004716:	058bb783          	ld	a5,88(s7)
    8000471a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000471e:	85ea                	mv	a1,s10
    80004720:	a38fd0ef          	jal	ra,80001958 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004724:	0004851b          	sext.w	a0,s1
    80004728:	b531                	j	80004534 <exec+0x80>
    8000472a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000472e:	df843583          	ld	a1,-520(s0)
    80004732:	855a                	mv	a0,s6
    80004734:	a24fd0ef          	jal	ra,80001958 <proc_freepagetable>
  if(ip){
    80004738:	de0a98e3          	bnez	s5,80004528 <exec+0x74>
  return -1;
    8000473c:	557d                	li	a0,-1
    8000473e:	bbdd                	j	80004534 <exec+0x80>
    80004740:	df243c23          	sd	s2,-520(s0)
    80004744:	b7ed                	j	8000472e <exec+0x27a>
    80004746:	df243c23          	sd	s2,-520(s0)
    8000474a:	b7d5                	j	8000472e <exec+0x27a>
    8000474c:	df243c23          	sd	s2,-520(s0)
    80004750:	bff9                	j	8000472e <exec+0x27a>
    80004752:	df243c23          	sd	s2,-520(s0)
    80004756:	bfe1                	j	8000472e <exec+0x27a>
  sz = sz1;
    80004758:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000475c:	4a81                	li	s5,0
    8000475e:	bfc1                	j	8000472e <exec+0x27a>
  sz = sz1;
    80004760:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004764:	4a81                	li	s5,0
    80004766:	b7e1                	j	8000472e <exec+0x27a>
  sz = sz1;
    80004768:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000476c:	4a81                	li	s5,0
    8000476e:	b7c1                	j	8000472e <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004770:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004774:	e0843783          	ld	a5,-504(s0)
    80004778:	0017869b          	addiw	a3,a5,1
    8000477c:	e0d43423          	sd	a3,-504(s0)
    80004780:	e0043783          	ld	a5,-512(s0)
    80004784:	0387879b          	addiw	a5,a5,56
    80004788:	e8845703          	lhu	a4,-376(s0)
    8000478c:	e4e6d6e3          	bge	a3,a4,800045d8 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004790:	2781                	sext.w	a5,a5
    80004792:	e0f43023          	sd	a5,-512(s0)
    80004796:	03800713          	li	a4,56
    8000479a:	86be                	mv	a3,a5
    8000479c:	e1840613          	addi	a2,s0,-488
    800047a0:	4581                	li	a1,0
    800047a2:	8556                	mv	a0,s5
    800047a4:	d17fe0ef          	jal	ra,800034ba <readi>
    800047a8:	03800793          	li	a5,56
    800047ac:	f6f51fe3          	bne	a0,a5,8000472a <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    800047b0:	e1842783          	lw	a5,-488(s0)
    800047b4:	4705                	li	a4,1
    800047b6:	fae79fe3          	bne	a5,a4,80004774 <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    800047ba:	e4043483          	ld	s1,-448(s0)
    800047be:	e3843783          	ld	a5,-456(s0)
    800047c2:	f6f4efe3          	bltu	s1,a5,80004740 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047c6:	e2843783          	ld	a5,-472(s0)
    800047ca:	94be                	add	s1,s1,a5
    800047cc:	f6f4ede3          	bltu	s1,a5,80004746 <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    800047d0:	de043703          	ld	a4,-544(s0)
    800047d4:	8ff9                	and	a5,a5,a4
    800047d6:	fbbd                	bnez	a5,8000474c <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047d8:	e1c42503          	lw	a0,-484(s0)
    800047dc:	cbdff0ef          	jal	ra,80004498 <flags2perm>
    800047e0:	86aa                	mv	a3,a0
    800047e2:	8626                	mv	a2,s1
    800047e4:	85ca                	mv	a1,s2
    800047e6:	855a                	mv	a0,s6
    800047e8:	af5fc0ef          	jal	ra,800012dc <uvmalloc>
    800047ec:	dea43c23          	sd	a0,-520(s0)
    800047f0:	d12d                	beqz	a0,80004752 <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047f2:	e2843c03          	ld	s8,-472(s0)
    800047f6:	e2042c83          	lw	s9,-480(s0)
    800047fa:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047fe:	f60b89e3          	beqz	s7,80004770 <exec+0x2bc>
    80004802:	89de                	mv	s3,s7
    80004804:	4481                	li	s1,0
    80004806:	bb55                	j	800045ba <exec+0x106>

0000000080004808 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004808:	7179                	addi	sp,sp,-48
    8000480a:	f406                	sd	ra,40(sp)
    8000480c:	f022                	sd	s0,32(sp)
    8000480e:	ec26                	sd	s1,24(sp)
    80004810:	e84a                	sd	s2,16(sp)
    80004812:	1800                	addi	s0,sp,48
    80004814:	892e                	mv	s2,a1
    80004816:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004818:	fdc40593          	addi	a1,s0,-36
    8000481c:	ff7fd0ef          	jal	ra,80002812 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004820:	fdc42703          	lw	a4,-36(s0)
    80004824:	47bd                	li	a5,15
    80004826:	02e7e963          	bltu	a5,a4,80004858 <argfd+0x50>
    8000482a:	802fd0ef          	jal	ra,8000182c <myproc>
    8000482e:	fdc42703          	lw	a4,-36(s0)
    80004832:	01a70793          	addi	a5,a4,26
    80004836:	078e                	slli	a5,a5,0x3
    80004838:	953e                	add	a0,a0,a5
    8000483a:	611c                	ld	a5,0(a0)
    8000483c:	c385                	beqz	a5,8000485c <argfd+0x54>
    return -1;
  if(pfd)
    8000483e:	00090463          	beqz	s2,80004846 <argfd+0x3e>
    *pfd = fd;
    80004842:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004846:	4501                	li	a0,0
  if(pf)
    80004848:	c091                	beqz	s1,8000484c <argfd+0x44>
    *pf = f;
    8000484a:	e09c                	sd	a5,0(s1)
}
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	64e2                	ld	s1,24(sp)
    80004852:	6942                	ld	s2,16(sp)
    80004854:	6145                	addi	sp,sp,48
    80004856:	8082                	ret
    return -1;
    80004858:	557d                	li	a0,-1
    8000485a:	bfcd                	j	8000484c <argfd+0x44>
    8000485c:	557d                	li	a0,-1
    8000485e:	b7fd                	j	8000484c <argfd+0x44>

0000000080004860 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004860:	1101                	addi	sp,sp,-32
    80004862:	ec06                	sd	ra,24(sp)
    80004864:	e822                	sd	s0,16(sp)
    80004866:	e426                	sd	s1,8(sp)
    80004868:	1000                	addi	s0,sp,32
    8000486a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000486c:	fc1fc0ef          	jal	ra,8000182c <myproc>
    80004870:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004872:	0d050793          	addi	a5,a0,208
    80004876:	4501                	li	a0,0
    80004878:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000487a:	6398                	ld	a4,0(a5)
    8000487c:	cb19                	beqz	a4,80004892 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000487e:	2505                	addiw	a0,a0,1
    80004880:	07a1                	addi	a5,a5,8
    80004882:	fed51ce3          	bne	a0,a3,8000487a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004886:	557d                	li	a0,-1
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	64a2                	ld	s1,8(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret
      p->ofile[fd] = f;
    80004892:	01a50793          	addi	a5,a0,26
    80004896:	078e                	slli	a5,a5,0x3
    80004898:	963e                	add	a2,a2,a5
    8000489a:	e204                	sd	s1,0(a2)
      return fd;
    8000489c:	b7f5                	j	80004888 <fdalloc+0x28>

000000008000489e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000489e:	715d                	addi	sp,sp,-80
    800048a0:	e486                	sd	ra,72(sp)
    800048a2:	e0a2                	sd	s0,64(sp)
    800048a4:	fc26                	sd	s1,56(sp)
    800048a6:	f84a                	sd	s2,48(sp)
    800048a8:	f44e                	sd	s3,40(sp)
    800048aa:	f052                	sd	s4,32(sp)
    800048ac:	ec56                	sd	s5,24(sp)
    800048ae:	e85a                	sd	s6,16(sp)
    800048b0:	0880                	addi	s0,sp,80
    800048b2:	8b2e                	mv	s6,a1
    800048b4:	89b2                	mv	s3,a2
    800048b6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048b8:	fb040593          	addi	a1,s0,-80
    800048bc:	87cff0ef          	jal	ra,80003938 <nameiparent>
    800048c0:	84aa                	mv	s1,a0
    800048c2:	10050b63          	beqz	a0,800049d8 <create+0x13a>
    return 0;

  ilock(dp);
    800048c6:	9a5fe0ef          	jal	ra,8000326a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048ca:	4601                	li	a2,0
    800048cc:	fb040593          	addi	a1,s0,-80
    800048d0:	8526                	mv	a0,s1
    800048d2:	de7fe0ef          	jal	ra,800036b8 <dirlookup>
    800048d6:	8aaa                	mv	s5,a0
    800048d8:	c521                	beqz	a0,80004920 <create+0x82>
    iunlockput(dp);
    800048da:	8526                	mv	a0,s1
    800048dc:	b95fe0ef          	jal	ra,80003470 <iunlockput>
    ilock(ip);
    800048e0:	8556                	mv	a0,s5
    800048e2:	989fe0ef          	jal	ra,8000326a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048e6:	000b059b          	sext.w	a1,s6
    800048ea:	4789                	li	a5,2
    800048ec:	02f59563          	bne	a1,a5,80004916 <create+0x78>
    800048f0:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd7f5c>
    800048f4:	37f9                	addiw	a5,a5,-2
    800048f6:	17c2                	slli	a5,a5,0x30
    800048f8:	93c1                	srli	a5,a5,0x30
    800048fa:	4705                	li	a4,1
    800048fc:	00f76d63          	bltu	a4,a5,80004916 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004900:	8556                	mv	a0,s5
    80004902:	60a6                	ld	ra,72(sp)
    80004904:	6406                	ld	s0,64(sp)
    80004906:	74e2                	ld	s1,56(sp)
    80004908:	7942                	ld	s2,48(sp)
    8000490a:	79a2                	ld	s3,40(sp)
    8000490c:	7a02                	ld	s4,32(sp)
    8000490e:	6ae2                	ld	s5,24(sp)
    80004910:	6b42                	ld	s6,16(sp)
    80004912:	6161                	addi	sp,sp,80
    80004914:	8082                	ret
    iunlockput(ip);
    80004916:	8556                	mv	a0,s5
    80004918:	b59fe0ef          	jal	ra,80003470 <iunlockput>
    return 0;
    8000491c:	4a81                	li	s5,0
    8000491e:	b7cd                	j	80004900 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004920:	85da                	mv	a1,s6
    80004922:	4088                	lw	a0,0(s1)
    80004924:	fdefe0ef          	jal	ra,80003102 <ialloc>
    80004928:	8a2a                	mv	s4,a0
    8000492a:	cd1d                	beqz	a0,80004968 <create+0xca>
  ilock(ip);
    8000492c:	93ffe0ef          	jal	ra,8000326a <ilock>
  ip->major = major;
    80004930:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004934:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004938:	4905                	li	s2,1
    8000493a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000493e:	8552                	mv	a0,s4
    80004940:	879fe0ef          	jal	ra,800031b8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004944:	000b059b          	sext.w	a1,s6
    80004948:	03258563          	beq	a1,s2,80004972 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    8000494c:	004a2603          	lw	a2,4(s4)
    80004950:	fb040593          	addi	a1,s0,-80
    80004954:	8526                	mv	a0,s1
    80004956:	f2ffe0ef          	jal	ra,80003884 <dirlink>
    8000495a:	06054363          	bltz	a0,800049c0 <create+0x122>
  iunlockput(dp);
    8000495e:	8526                	mv	a0,s1
    80004960:	b11fe0ef          	jal	ra,80003470 <iunlockput>
  return ip;
    80004964:	8ad2                	mv	s5,s4
    80004966:	bf69                	j	80004900 <create+0x62>
    iunlockput(dp);
    80004968:	8526                	mv	a0,s1
    8000496a:	b07fe0ef          	jal	ra,80003470 <iunlockput>
    return 0;
    8000496e:	8ad2                	mv	s5,s4
    80004970:	bf41                	j	80004900 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004972:	004a2603          	lw	a2,4(s4)
    80004976:	00003597          	auipc	a1,0x3
    8000497a:	dd258593          	addi	a1,a1,-558 # 80007748 <syscalls+0x2b8>
    8000497e:	8552                	mv	a0,s4
    80004980:	f05fe0ef          	jal	ra,80003884 <dirlink>
    80004984:	02054e63          	bltz	a0,800049c0 <create+0x122>
    80004988:	40d0                	lw	a2,4(s1)
    8000498a:	00003597          	auipc	a1,0x3
    8000498e:	dc658593          	addi	a1,a1,-570 # 80007750 <syscalls+0x2c0>
    80004992:	8552                	mv	a0,s4
    80004994:	ef1fe0ef          	jal	ra,80003884 <dirlink>
    80004998:	02054463          	bltz	a0,800049c0 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    8000499c:	004a2603          	lw	a2,4(s4)
    800049a0:	fb040593          	addi	a1,s0,-80
    800049a4:	8526                	mv	a0,s1
    800049a6:	edffe0ef          	jal	ra,80003884 <dirlink>
    800049aa:	00054b63          	bltz	a0,800049c0 <create+0x122>
    dp->nlink++;  // for ".."
    800049ae:	04a4d783          	lhu	a5,74(s1)
    800049b2:	2785                	addiw	a5,a5,1
    800049b4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffefe0ef          	jal	ra,800031b8 <iupdate>
    800049be:	b745                	j	8000495e <create+0xc0>
  ip->nlink = 0;
    800049c0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049c4:	8552                	mv	a0,s4
    800049c6:	ff2fe0ef          	jal	ra,800031b8 <iupdate>
  iunlockput(ip);
    800049ca:	8552                	mv	a0,s4
    800049cc:	aa5fe0ef          	jal	ra,80003470 <iunlockput>
  iunlockput(dp);
    800049d0:	8526                	mv	a0,s1
    800049d2:	a9ffe0ef          	jal	ra,80003470 <iunlockput>
  return 0;
    800049d6:	b72d                	j	80004900 <create+0x62>
    return 0;
    800049d8:	8aaa                	mv	s5,a0
    800049da:	b71d                	j	80004900 <create+0x62>

00000000800049dc <sys_dup>:
{
    800049dc:	7179                	addi	sp,sp,-48
    800049de:	f406                	sd	ra,40(sp)
    800049e0:	f022                	sd	s0,32(sp)
    800049e2:	ec26                	sd	s1,24(sp)
    800049e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049e6:	fd840613          	addi	a2,s0,-40
    800049ea:	4581                	li	a1,0
    800049ec:	4501                	li	a0,0
    800049ee:	e1bff0ef          	jal	ra,80004808 <argfd>
    return -1;
    800049f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049f4:	00054f63          	bltz	a0,80004a12 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    800049f8:	fd843503          	ld	a0,-40(s0)
    800049fc:	e65ff0ef          	jal	ra,80004860 <fdalloc>
    80004a00:	84aa                	mv	s1,a0
    return -1;
    80004a02:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a04:	00054763          	bltz	a0,80004a12 <sys_dup+0x36>
  filedup(f);
    80004a08:	fd843503          	ld	a0,-40(s0)
    80004a0c:	cc0ff0ef          	jal	ra,80003ecc <filedup>
  return fd;
    80004a10:	87a6                	mv	a5,s1
}
    80004a12:	853e                	mv	a0,a5
    80004a14:	70a2                	ld	ra,40(sp)
    80004a16:	7402                	ld	s0,32(sp)
    80004a18:	64e2                	ld	s1,24(sp)
    80004a1a:	6145                	addi	sp,sp,48
    80004a1c:	8082                	ret

0000000080004a1e <sys_read>:
{
    80004a1e:	7179                	addi	sp,sp,-48
    80004a20:	f406                	sd	ra,40(sp)
    80004a22:	f022                	sd	s0,32(sp)
    80004a24:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a26:	fd840593          	addi	a1,s0,-40
    80004a2a:	4505                	li	a0,1
    80004a2c:	e03fd0ef          	jal	ra,8000282e <argaddr>
  argint(2, &n);
    80004a30:	fe440593          	addi	a1,s0,-28
    80004a34:	4509                	li	a0,2
    80004a36:	dddfd0ef          	jal	ra,80002812 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a3a:	fe840613          	addi	a2,s0,-24
    80004a3e:	4581                	li	a1,0
    80004a40:	4501                	li	a0,0
    80004a42:	dc7ff0ef          	jal	ra,80004808 <argfd>
    80004a46:	87aa                	mv	a5,a0
    return -1;
    80004a48:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a4a:	0007ca63          	bltz	a5,80004a5e <sys_read+0x40>
  return fileread(f, p, n);
    80004a4e:	fe442603          	lw	a2,-28(s0)
    80004a52:	fd843583          	ld	a1,-40(s0)
    80004a56:	fe843503          	ld	a0,-24(s0)
    80004a5a:	dbeff0ef          	jal	ra,80004018 <fileread>
}
    80004a5e:	70a2                	ld	ra,40(sp)
    80004a60:	7402                	ld	s0,32(sp)
    80004a62:	6145                	addi	sp,sp,48
    80004a64:	8082                	ret

0000000080004a66 <sys_write>:
{
    80004a66:	7179                	addi	sp,sp,-48
    80004a68:	f406                	sd	ra,40(sp)
    80004a6a:	f022                	sd	s0,32(sp)
    80004a6c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a6e:	fd840593          	addi	a1,s0,-40
    80004a72:	4505                	li	a0,1
    80004a74:	dbbfd0ef          	jal	ra,8000282e <argaddr>
  argint(2, &n);
    80004a78:	fe440593          	addi	a1,s0,-28
    80004a7c:	4509                	li	a0,2
    80004a7e:	d95fd0ef          	jal	ra,80002812 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a82:	fe840613          	addi	a2,s0,-24
    80004a86:	4581                	li	a1,0
    80004a88:	4501                	li	a0,0
    80004a8a:	d7fff0ef          	jal	ra,80004808 <argfd>
    80004a8e:	87aa                	mv	a5,a0
    return -1;
    80004a90:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a92:	0007ca63          	bltz	a5,80004aa6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004a96:	fe442603          	lw	a2,-28(s0)
    80004a9a:	fd843583          	ld	a1,-40(s0)
    80004a9e:	fe843503          	ld	a0,-24(s0)
    80004aa2:	e24ff0ef          	jal	ra,800040c6 <filewrite>
}
    80004aa6:	70a2                	ld	ra,40(sp)
    80004aa8:	7402                	ld	s0,32(sp)
    80004aaa:	6145                	addi	sp,sp,48
    80004aac:	8082                	ret

0000000080004aae <sys_close>:
{
    80004aae:	1101                	addi	sp,sp,-32
    80004ab0:	ec06                	sd	ra,24(sp)
    80004ab2:	e822                	sd	s0,16(sp)
    80004ab4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ab6:	fe040613          	addi	a2,s0,-32
    80004aba:	fec40593          	addi	a1,s0,-20
    80004abe:	4501                	li	a0,0
    80004ac0:	d49ff0ef          	jal	ra,80004808 <argfd>
    return -1;
    80004ac4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ac6:	02054063          	bltz	a0,80004ae6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004aca:	d63fc0ef          	jal	ra,8000182c <myproc>
    80004ace:	fec42783          	lw	a5,-20(s0)
    80004ad2:	07e9                	addi	a5,a5,26
    80004ad4:	078e                	slli	a5,a5,0x3
    80004ad6:	97aa                	add	a5,a5,a0
    80004ad8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004adc:	fe043503          	ld	a0,-32(s0)
    80004ae0:	c32ff0ef          	jal	ra,80003f12 <fileclose>
  return 0;
    80004ae4:	4781                	li	a5,0
}
    80004ae6:	853e                	mv	a0,a5
    80004ae8:	60e2                	ld	ra,24(sp)
    80004aea:	6442                	ld	s0,16(sp)
    80004aec:	6105                	addi	sp,sp,32
    80004aee:	8082                	ret

0000000080004af0 <sys_fstat>:
{
    80004af0:	1101                	addi	sp,sp,-32
    80004af2:	ec06                	sd	ra,24(sp)
    80004af4:	e822                	sd	s0,16(sp)
    80004af6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004af8:	fe040593          	addi	a1,s0,-32
    80004afc:	4505                	li	a0,1
    80004afe:	d31fd0ef          	jal	ra,8000282e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b02:	fe840613          	addi	a2,s0,-24
    80004b06:	4581                	li	a1,0
    80004b08:	4501                	li	a0,0
    80004b0a:	cffff0ef          	jal	ra,80004808 <argfd>
    80004b0e:	87aa                	mv	a5,a0
    return -1;
    80004b10:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b12:	0007c863          	bltz	a5,80004b22 <sys_fstat+0x32>
  return filestat(f, st);
    80004b16:	fe043583          	ld	a1,-32(s0)
    80004b1a:	fe843503          	ld	a0,-24(s0)
    80004b1e:	c9cff0ef          	jal	ra,80003fba <filestat>
}
    80004b22:	60e2                	ld	ra,24(sp)
    80004b24:	6442                	ld	s0,16(sp)
    80004b26:	6105                	addi	sp,sp,32
    80004b28:	8082                	ret

0000000080004b2a <sys_link>:
{
    80004b2a:	7169                	addi	sp,sp,-304
    80004b2c:	f606                	sd	ra,296(sp)
    80004b2e:	f222                	sd	s0,288(sp)
    80004b30:	ee26                	sd	s1,280(sp)
    80004b32:	ea4a                	sd	s2,272(sp)
    80004b34:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b36:	08000613          	li	a2,128
    80004b3a:	ed040593          	addi	a1,s0,-304
    80004b3e:	4501                	li	a0,0
    80004b40:	d0bfd0ef          	jal	ra,8000284a <argstr>
    return -1;
    80004b44:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b46:	0c054663          	bltz	a0,80004c12 <sys_link+0xe8>
    80004b4a:	08000613          	li	a2,128
    80004b4e:	f5040593          	addi	a1,s0,-176
    80004b52:	4505                	li	a0,1
    80004b54:	cf7fd0ef          	jal	ra,8000284a <argstr>
    return -1;
    80004b58:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b5a:	0a054c63          	bltz	a0,80004c12 <sys_link+0xe8>
  begin_op();
    80004b5e:	f99fe0ef          	jal	ra,80003af6 <begin_op>
  if((ip = namei(old)) == 0){
    80004b62:	ed040513          	addi	a0,s0,-304
    80004b66:	db9fe0ef          	jal	ra,8000391e <namei>
    80004b6a:	84aa                	mv	s1,a0
    80004b6c:	c525                	beqz	a0,80004bd4 <sys_link+0xaa>
  ilock(ip);
    80004b6e:	efcfe0ef          	jal	ra,8000326a <ilock>
  if(ip->type == T_DIR){
    80004b72:	04449703          	lh	a4,68(s1)
    80004b76:	4785                	li	a5,1
    80004b78:	06f70263          	beq	a4,a5,80004bdc <sys_link+0xb2>
  ip->nlink++;
    80004b7c:	04a4d783          	lhu	a5,74(s1)
    80004b80:	2785                	addiw	a5,a5,1
    80004b82:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b86:	8526                	mv	a0,s1
    80004b88:	e30fe0ef          	jal	ra,800031b8 <iupdate>
  iunlock(ip);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	f86fe0ef          	jal	ra,80003314 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b92:	fd040593          	addi	a1,s0,-48
    80004b96:	f5040513          	addi	a0,s0,-176
    80004b9a:	d9ffe0ef          	jal	ra,80003938 <nameiparent>
    80004b9e:	892a                	mv	s2,a0
    80004ba0:	c921                	beqz	a0,80004bf0 <sys_link+0xc6>
  ilock(dp);
    80004ba2:	ec8fe0ef          	jal	ra,8000326a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ba6:	00092703          	lw	a4,0(s2)
    80004baa:	409c                	lw	a5,0(s1)
    80004bac:	02f71f63          	bne	a4,a5,80004bea <sys_link+0xc0>
    80004bb0:	40d0                	lw	a2,4(s1)
    80004bb2:	fd040593          	addi	a1,s0,-48
    80004bb6:	854a                	mv	a0,s2
    80004bb8:	ccdfe0ef          	jal	ra,80003884 <dirlink>
    80004bbc:	02054763          	bltz	a0,80004bea <sys_link+0xc0>
  iunlockput(dp);
    80004bc0:	854a                	mv	a0,s2
    80004bc2:	8affe0ef          	jal	ra,80003470 <iunlockput>
  iput(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	821fe0ef          	jal	ra,800033e8 <iput>
  end_op();
    80004bcc:	f9bfe0ef          	jal	ra,80003b66 <end_op>
  return 0;
    80004bd0:	4781                	li	a5,0
    80004bd2:	a081                	j	80004c12 <sys_link+0xe8>
    end_op();
    80004bd4:	f93fe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004bd8:	57fd                	li	a5,-1
    80004bda:	a825                	j	80004c12 <sys_link+0xe8>
    iunlockput(ip);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	893fe0ef          	jal	ra,80003470 <iunlockput>
    end_op();
    80004be2:	f85fe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004be6:	57fd                	li	a5,-1
    80004be8:	a02d                	j	80004c12 <sys_link+0xe8>
    iunlockput(dp);
    80004bea:	854a                	mv	a0,s2
    80004bec:	885fe0ef          	jal	ra,80003470 <iunlockput>
  ilock(ip);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	e78fe0ef          	jal	ra,8000326a <ilock>
  ip->nlink--;
    80004bf6:	04a4d783          	lhu	a5,74(s1)
    80004bfa:	37fd                	addiw	a5,a5,-1
    80004bfc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c00:	8526                	mv	a0,s1
    80004c02:	db6fe0ef          	jal	ra,800031b8 <iupdate>
  iunlockput(ip);
    80004c06:	8526                	mv	a0,s1
    80004c08:	869fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    80004c0c:	f5bfe0ef          	jal	ra,80003b66 <end_op>
  return -1;
    80004c10:	57fd                	li	a5,-1
}
    80004c12:	853e                	mv	a0,a5
    80004c14:	70b2                	ld	ra,296(sp)
    80004c16:	7412                	ld	s0,288(sp)
    80004c18:	64f2                	ld	s1,280(sp)
    80004c1a:	6952                	ld	s2,272(sp)
    80004c1c:	6155                	addi	sp,sp,304
    80004c1e:	8082                	ret

0000000080004c20 <sys_unlink>:
{
    80004c20:	7151                	addi	sp,sp,-240
    80004c22:	f586                	sd	ra,232(sp)
    80004c24:	f1a2                	sd	s0,224(sp)
    80004c26:	eda6                	sd	s1,216(sp)
    80004c28:	e9ca                	sd	s2,208(sp)
    80004c2a:	e5ce                	sd	s3,200(sp)
    80004c2c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c2e:	08000613          	li	a2,128
    80004c32:	f3040593          	addi	a1,s0,-208
    80004c36:	4501                	li	a0,0
    80004c38:	c13fd0ef          	jal	ra,8000284a <argstr>
    80004c3c:	12054b63          	bltz	a0,80004d72 <sys_unlink+0x152>
  begin_op();
    80004c40:	eb7fe0ef          	jal	ra,80003af6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c44:	fb040593          	addi	a1,s0,-80
    80004c48:	f3040513          	addi	a0,s0,-208
    80004c4c:	cedfe0ef          	jal	ra,80003938 <nameiparent>
    80004c50:	84aa                	mv	s1,a0
    80004c52:	c54d                	beqz	a0,80004cfc <sys_unlink+0xdc>
  ilock(dp);
    80004c54:	e16fe0ef          	jal	ra,8000326a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c58:	00003597          	auipc	a1,0x3
    80004c5c:	af058593          	addi	a1,a1,-1296 # 80007748 <syscalls+0x2b8>
    80004c60:	fb040513          	addi	a0,s0,-80
    80004c64:	a3ffe0ef          	jal	ra,800036a2 <namecmp>
    80004c68:	10050a63          	beqz	a0,80004d7c <sys_unlink+0x15c>
    80004c6c:	00003597          	auipc	a1,0x3
    80004c70:	ae458593          	addi	a1,a1,-1308 # 80007750 <syscalls+0x2c0>
    80004c74:	fb040513          	addi	a0,s0,-80
    80004c78:	a2bfe0ef          	jal	ra,800036a2 <namecmp>
    80004c7c:	10050063          	beqz	a0,80004d7c <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c80:	f2c40613          	addi	a2,s0,-212
    80004c84:	fb040593          	addi	a1,s0,-80
    80004c88:	8526                	mv	a0,s1
    80004c8a:	a2ffe0ef          	jal	ra,800036b8 <dirlookup>
    80004c8e:	892a                	mv	s2,a0
    80004c90:	0e050663          	beqz	a0,80004d7c <sys_unlink+0x15c>
  ilock(ip);
    80004c94:	dd6fe0ef          	jal	ra,8000326a <ilock>
  if(ip->nlink < 1)
    80004c98:	04a91783          	lh	a5,74(s2)
    80004c9c:	06f05463          	blez	a5,80004d04 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ca0:	04491703          	lh	a4,68(s2)
    80004ca4:	4785                	li	a5,1
    80004ca6:	06f70563          	beq	a4,a5,80004d10 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004caa:	4641                	li	a2,16
    80004cac:	4581                	li	a1,0
    80004cae:	fc040513          	addi	a0,s0,-64
    80004cb2:	fbdfb0ef          	jal	ra,80000c6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb6:	4741                	li	a4,16
    80004cb8:	f2c42683          	lw	a3,-212(s0)
    80004cbc:	fc040613          	addi	a2,s0,-64
    80004cc0:	4581                	li	a1,0
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	8dbfe0ef          	jal	ra,8000359e <writei>
    80004cc8:	47c1                	li	a5,16
    80004cca:	08f51563          	bne	a0,a5,80004d54 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004cce:	04491703          	lh	a4,68(s2)
    80004cd2:	4785                	li	a5,1
    80004cd4:	08f70663          	beq	a4,a5,80004d60 <sys_unlink+0x140>
  iunlockput(dp);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	f96fe0ef          	jal	ra,80003470 <iunlockput>
  ip->nlink--;
    80004cde:	04a95783          	lhu	a5,74(s2)
    80004ce2:	37fd                	addiw	a5,a5,-1
    80004ce4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ce8:	854a                	mv	a0,s2
    80004cea:	ccefe0ef          	jal	ra,800031b8 <iupdate>
  iunlockput(ip);
    80004cee:	854a                	mv	a0,s2
    80004cf0:	f80fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    80004cf4:	e73fe0ef          	jal	ra,80003b66 <end_op>
  return 0;
    80004cf8:	4501                	li	a0,0
    80004cfa:	a079                	j	80004d88 <sys_unlink+0x168>
    end_op();
    80004cfc:	e6bfe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	a059                	j	80004d88 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004d04:	00003517          	auipc	a0,0x3
    80004d08:	a5450513          	addi	a0,a0,-1452 # 80007758 <syscalls+0x2c8>
    80004d0c:	a4bfb0ef          	jal	ra,80000756 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d10:	04c92703          	lw	a4,76(s2)
    80004d14:	02000793          	li	a5,32
    80004d18:	f8e7f9e3          	bgeu	a5,a4,80004caa <sys_unlink+0x8a>
    80004d1c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d20:	4741                	li	a4,16
    80004d22:	86ce                	mv	a3,s3
    80004d24:	f1840613          	addi	a2,s0,-232
    80004d28:	4581                	li	a1,0
    80004d2a:	854a                	mv	a0,s2
    80004d2c:	f8efe0ef          	jal	ra,800034ba <readi>
    80004d30:	47c1                	li	a5,16
    80004d32:	00f51b63          	bne	a0,a5,80004d48 <sys_unlink+0x128>
    if(de.inum != 0)
    80004d36:	f1845783          	lhu	a5,-232(s0)
    80004d3a:	ef95                	bnez	a5,80004d76 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d3c:	29c1                	addiw	s3,s3,16
    80004d3e:	04c92783          	lw	a5,76(s2)
    80004d42:	fcf9efe3          	bltu	s3,a5,80004d20 <sys_unlink+0x100>
    80004d46:	b795                	j	80004caa <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004d48:	00003517          	auipc	a0,0x3
    80004d4c:	a2850513          	addi	a0,a0,-1496 # 80007770 <syscalls+0x2e0>
    80004d50:	a07fb0ef          	jal	ra,80000756 <panic>
    panic("unlink: writei");
    80004d54:	00003517          	auipc	a0,0x3
    80004d58:	a3450513          	addi	a0,a0,-1484 # 80007788 <syscalls+0x2f8>
    80004d5c:	9fbfb0ef          	jal	ra,80000756 <panic>
    dp->nlink--;
    80004d60:	04a4d783          	lhu	a5,74(s1)
    80004d64:	37fd                	addiw	a5,a5,-1
    80004d66:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	c4cfe0ef          	jal	ra,800031b8 <iupdate>
    80004d70:	b7a5                	j	80004cd8 <sys_unlink+0xb8>
    return -1;
    80004d72:	557d                	li	a0,-1
    80004d74:	a811                	j	80004d88 <sys_unlink+0x168>
    iunlockput(ip);
    80004d76:	854a                	mv	a0,s2
    80004d78:	ef8fe0ef          	jal	ra,80003470 <iunlockput>
  iunlockput(dp);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ef2fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    80004d82:	de5fe0ef          	jal	ra,80003b66 <end_op>
  return -1;
    80004d86:	557d                	li	a0,-1
}
    80004d88:	70ae                	ld	ra,232(sp)
    80004d8a:	740e                	ld	s0,224(sp)
    80004d8c:	64ee                	ld	s1,216(sp)
    80004d8e:	694e                	ld	s2,208(sp)
    80004d90:	69ae                	ld	s3,200(sp)
    80004d92:	616d                	addi	sp,sp,240
    80004d94:	8082                	ret

0000000080004d96 <sys_open>:

uint64
sys_open(void)
{
    80004d96:	7131                	addi	sp,sp,-192
    80004d98:	fd06                	sd	ra,184(sp)
    80004d9a:	f922                	sd	s0,176(sp)
    80004d9c:	f526                	sd	s1,168(sp)
    80004d9e:	f14a                	sd	s2,160(sp)
    80004da0:	ed4e                	sd	s3,152(sp)
    80004da2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004da4:	f4c40593          	addi	a1,s0,-180
    80004da8:	4505                	li	a0,1
    80004daa:	a69fd0ef          	jal	ra,80002812 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dae:	08000613          	li	a2,128
    80004db2:	f5040593          	addi	a1,s0,-176
    80004db6:	4501                	li	a0,0
    80004db8:	a93fd0ef          	jal	ra,8000284a <argstr>
    80004dbc:	87aa                	mv	a5,a0
    return -1;
    80004dbe:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dc0:	0807cd63          	bltz	a5,80004e5a <sys_open+0xc4>

  begin_op();
    80004dc4:	d33fe0ef          	jal	ra,80003af6 <begin_op>

  if(omode & O_CREATE){
    80004dc8:	f4c42783          	lw	a5,-180(s0)
    80004dcc:	2007f793          	andi	a5,a5,512
    80004dd0:	c3c5                	beqz	a5,80004e70 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004dd2:	4681                	li	a3,0
    80004dd4:	4601                	li	a2,0
    80004dd6:	4589                	li	a1,2
    80004dd8:	f5040513          	addi	a0,s0,-176
    80004ddc:	ac3ff0ef          	jal	ra,8000489e <create>
    80004de0:	84aa                	mv	s1,a0
    if(ip == 0){
    80004de2:	c159                	beqz	a0,80004e68 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004de4:	04449703          	lh	a4,68(s1)
    80004de8:	478d                	li	a5,3
    80004dea:	00f71763          	bne	a4,a5,80004df8 <sys_open+0x62>
    80004dee:	0464d703          	lhu	a4,70(s1)
    80004df2:	47a5                	li	a5,9
    80004df4:	0ae7e963          	bltu	a5,a4,80004ea6 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004df8:	876ff0ef          	jal	ra,80003e6e <filealloc>
    80004dfc:	89aa                	mv	s3,a0
    80004dfe:	0c050963          	beqz	a0,80004ed0 <sys_open+0x13a>
    80004e02:	a5fff0ef          	jal	ra,80004860 <fdalloc>
    80004e06:	892a                	mv	s2,a0
    80004e08:	0c054163          	bltz	a0,80004eca <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e0c:	04449703          	lh	a4,68(s1)
    80004e10:	478d                	li	a5,3
    80004e12:	0af70163          	beq	a4,a5,80004eb4 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e16:	4789                	li	a5,2
    80004e18:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e1c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e20:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e24:	f4c42783          	lw	a5,-180(s0)
    80004e28:	0017c713          	xori	a4,a5,1
    80004e2c:	8b05                	andi	a4,a4,1
    80004e2e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e32:	0037f713          	andi	a4,a5,3
    80004e36:	00e03733          	snez	a4,a4
    80004e3a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e3e:	4007f793          	andi	a5,a5,1024
    80004e42:	c791                	beqz	a5,80004e4e <sys_open+0xb8>
    80004e44:	04449703          	lh	a4,68(s1)
    80004e48:	4789                	li	a5,2
    80004e4a:	06f70c63          	beq	a4,a5,80004ec2 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e4e:	8526                	mv	a0,s1
    80004e50:	cc4fe0ef          	jal	ra,80003314 <iunlock>
  end_op();
    80004e54:	d13fe0ef          	jal	ra,80003b66 <end_op>

  return fd;
    80004e58:	854a                	mv	a0,s2
}
    80004e5a:	70ea                	ld	ra,184(sp)
    80004e5c:	744a                	ld	s0,176(sp)
    80004e5e:	74aa                	ld	s1,168(sp)
    80004e60:	790a                	ld	s2,160(sp)
    80004e62:	69ea                	ld	s3,152(sp)
    80004e64:	6129                	addi	sp,sp,192
    80004e66:	8082                	ret
      end_op();
    80004e68:	cfffe0ef          	jal	ra,80003b66 <end_op>
      return -1;
    80004e6c:	557d                	li	a0,-1
    80004e6e:	b7f5                	j	80004e5a <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004e70:	f5040513          	addi	a0,s0,-176
    80004e74:	aabfe0ef          	jal	ra,8000391e <namei>
    80004e78:	84aa                	mv	s1,a0
    80004e7a:	c115                	beqz	a0,80004e9e <sys_open+0x108>
    ilock(ip);
    80004e7c:	beefe0ef          	jal	ra,8000326a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e80:	04449703          	lh	a4,68(s1)
    80004e84:	4785                	li	a5,1
    80004e86:	f4f71fe3          	bne	a4,a5,80004de4 <sys_open+0x4e>
    80004e8a:	f4c42783          	lw	a5,-180(s0)
    80004e8e:	d7ad                	beqz	a5,80004df8 <sys_open+0x62>
      iunlockput(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ddefe0ef          	jal	ra,80003470 <iunlockput>
      end_op();
    80004e96:	cd1fe0ef          	jal	ra,80003b66 <end_op>
      return -1;
    80004e9a:	557d                	li	a0,-1
    80004e9c:	bf7d                	j	80004e5a <sys_open+0xc4>
      end_op();
    80004e9e:	cc9fe0ef          	jal	ra,80003b66 <end_op>
      return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	bf5d                	j	80004e5a <sys_open+0xc4>
    iunlockput(ip);
    80004ea6:	8526                	mv	a0,s1
    80004ea8:	dc8fe0ef          	jal	ra,80003470 <iunlockput>
    end_op();
    80004eac:	cbbfe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b765                	j	80004e5a <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004eb4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eb8:	04649783          	lh	a5,70(s1)
    80004ebc:	02f99223          	sh	a5,36(s3)
    80004ec0:	b785                	j	80004e20 <sys_open+0x8a>
    itrunc(ip);
    80004ec2:	8526                	mv	a0,s1
    80004ec4:	c90fe0ef          	jal	ra,80003354 <itrunc>
    80004ec8:	b759                	j	80004e4e <sys_open+0xb8>
      fileclose(f);
    80004eca:	854e                	mv	a0,s3
    80004ecc:	846ff0ef          	jal	ra,80003f12 <fileclose>
    iunlockput(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	d9efe0ef          	jal	ra,80003470 <iunlockput>
    end_op();
    80004ed6:	c91fe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004eda:	557d                	li	a0,-1
    80004edc:	bfbd                	j	80004e5a <sys_open+0xc4>

0000000080004ede <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ede:	7175                	addi	sp,sp,-144
    80004ee0:	e506                	sd	ra,136(sp)
    80004ee2:	e122                	sd	s0,128(sp)
    80004ee4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee6:	c11fe0ef          	jal	ra,80003af6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004eea:	08000613          	li	a2,128
    80004eee:	f7040593          	addi	a1,s0,-144
    80004ef2:	4501                	li	a0,0
    80004ef4:	957fd0ef          	jal	ra,8000284a <argstr>
    80004ef8:	02054363          	bltz	a0,80004f1e <sys_mkdir+0x40>
    80004efc:	4681                	li	a3,0
    80004efe:	4601                	li	a2,0
    80004f00:	4585                	li	a1,1
    80004f02:	f7040513          	addi	a0,s0,-144
    80004f06:	999ff0ef          	jal	ra,8000489e <create>
    80004f0a:	c911                	beqz	a0,80004f1e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f0c:	d64fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    80004f10:	c57fe0ef          	jal	ra,80003b66 <end_op>
  return 0;
    80004f14:	4501                	li	a0,0
}
    80004f16:	60aa                	ld	ra,136(sp)
    80004f18:	640a                	ld	s0,128(sp)
    80004f1a:	6149                	addi	sp,sp,144
    80004f1c:	8082                	ret
    end_op();
    80004f1e:	c49fe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	bfcd                	j	80004f16 <sys_mkdir+0x38>

0000000080004f26 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f26:	7135                	addi	sp,sp,-160
    80004f28:	ed06                	sd	ra,152(sp)
    80004f2a:	e922                	sd	s0,144(sp)
    80004f2c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f2e:	bc9fe0ef          	jal	ra,80003af6 <begin_op>
  argint(1, &major);
    80004f32:	f6c40593          	addi	a1,s0,-148
    80004f36:	4505                	li	a0,1
    80004f38:	8dbfd0ef          	jal	ra,80002812 <argint>
  argint(2, &minor);
    80004f3c:	f6840593          	addi	a1,s0,-152
    80004f40:	4509                	li	a0,2
    80004f42:	8d1fd0ef          	jal	ra,80002812 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f46:	08000613          	li	a2,128
    80004f4a:	f7040593          	addi	a1,s0,-144
    80004f4e:	4501                	li	a0,0
    80004f50:	8fbfd0ef          	jal	ra,8000284a <argstr>
    80004f54:	02054563          	bltz	a0,80004f7e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f58:	f6841683          	lh	a3,-152(s0)
    80004f5c:	f6c41603          	lh	a2,-148(s0)
    80004f60:	458d                	li	a1,3
    80004f62:	f7040513          	addi	a0,s0,-144
    80004f66:	939ff0ef          	jal	ra,8000489e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6a:	c911                	beqz	a0,80004f7e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f6c:	d04fe0ef          	jal	ra,80003470 <iunlockput>
  end_op();
    80004f70:	bf7fe0ef          	jal	ra,80003b66 <end_op>
  return 0;
    80004f74:	4501                	li	a0,0
}
    80004f76:	60ea                	ld	ra,152(sp)
    80004f78:	644a                	ld	s0,144(sp)
    80004f7a:	610d                	addi	sp,sp,160
    80004f7c:	8082                	ret
    end_op();
    80004f7e:	be9fe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004f82:	557d                	li	a0,-1
    80004f84:	bfcd                	j	80004f76 <sys_mknod+0x50>

0000000080004f86 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f86:	7135                	addi	sp,sp,-160
    80004f88:	ed06                	sd	ra,152(sp)
    80004f8a:	e922                	sd	s0,144(sp)
    80004f8c:	e526                	sd	s1,136(sp)
    80004f8e:	e14a                	sd	s2,128(sp)
    80004f90:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f92:	89bfc0ef          	jal	ra,8000182c <myproc>
    80004f96:	892a                	mv	s2,a0
  
  begin_op();
    80004f98:	b5ffe0ef          	jal	ra,80003af6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f9c:	08000613          	li	a2,128
    80004fa0:	f6040593          	addi	a1,s0,-160
    80004fa4:	4501                	li	a0,0
    80004fa6:	8a5fd0ef          	jal	ra,8000284a <argstr>
    80004faa:	04054163          	bltz	a0,80004fec <sys_chdir+0x66>
    80004fae:	f6040513          	addi	a0,s0,-160
    80004fb2:	96dfe0ef          	jal	ra,8000391e <namei>
    80004fb6:	84aa                	mv	s1,a0
    80004fb8:	c915                	beqz	a0,80004fec <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fba:	ab0fe0ef          	jal	ra,8000326a <ilock>
  if(ip->type != T_DIR){
    80004fbe:	04449703          	lh	a4,68(s1)
    80004fc2:	4785                	li	a5,1
    80004fc4:	02f71863          	bne	a4,a5,80004ff4 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	b4afe0ef          	jal	ra,80003314 <iunlock>
  iput(p->cwd);
    80004fce:	15093503          	ld	a0,336(s2)
    80004fd2:	c16fe0ef          	jal	ra,800033e8 <iput>
  end_op();
    80004fd6:	b91fe0ef          	jal	ra,80003b66 <end_op>
  p->cwd = ip;
    80004fda:	14993823          	sd	s1,336(s2)
  return 0;
    80004fde:	4501                	li	a0,0
}
    80004fe0:	60ea                	ld	ra,152(sp)
    80004fe2:	644a                	ld	s0,144(sp)
    80004fe4:	64aa                	ld	s1,136(sp)
    80004fe6:	690a                	ld	s2,128(sp)
    80004fe8:	610d                	addi	sp,sp,160
    80004fea:	8082                	ret
    end_op();
    80004fec:	b7bfe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004ff0:	557d                	li	a0,-1
    80004ff2:	b7fd                	j	80004fe0 <sys_chdir+0x5a>
    iunlockput(ip);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	c7afe0ef          	jal	ra,80003470 <iunlockput>
    end_op();
    80004ffa:	b6dfe0ef          	jal	ra,80003b66 <end_op>
    return -1;
    80004ffe:	557d                	li	a0,-1
    80005000:	b7c5                	j	80004fe0 <sys_chdir+0x5a>

0000000080005002 <sys_exec>:

uint64
sys_exec(void)
{
    80005002:	7145                	addi	sp,sp,-464
    80005004:	e786                	sd	ra,456(sp)
    80005006:	e3a2                	sd	s0,448(sp)
    80005008:	ff26                	sd	s1,440(sp)
    8000500a:	fb4a                	sd	s2,432(sp)
    8000500c:	f74e                	sd	s3,424(sp)
    8000500e:	f352                	sd	s4,416(sp)
    80005010:	ef56                	sd	s5,408(sp)
    80005012:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005014:	e3840593          	addi	a1,s0,-456
    80005018:	4505                	li	a0,1
    8000501a:	815fd0ef          	jal	ra,8000282e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000501e:	08000613          	li	a2,128
    80005022:	f4040593          	addi	a1,s0,-192
    80005026:	4501                	li	a0,0
    80005028:	823fd0ef          	jal	ra,8000284a <argstr>
    8000502c:	87aa                	mv	a5,a0
    return -1;
    8000502e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005030:	0a07c463          	bltz	a5,800050d8 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80005034:	10000613          	li	a2,256
    80005038:	4581                	li	a1,0
    8000503a:	e4040513          	addi	a0,s0,-448
    8000503e:	c31fb0ef          	jal	ra,80000c6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005042:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005046:	89a6                	mv	s3,s1
    80005048:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000504a:	02000a13          	li	s4,32
    8000504e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005052:	00391793          	slli	a5,s2,0x3
    80005056:	e3040593          	addi	a1,s0,-464
    8000505a:	e3843503          	ld	a0,-456(s0)
    8000505e:	953e                	add	a0,a0,a5
    80005060:	f28fd0ef          	jal	ra,80002788 <fetchaddr>
    80005064:	02054663          	bltz	a0,80005090 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80005068:	e3043783          	ld	a5,-464(s0)
    8000506c:	cf8d                	beqz	a5,800050a6 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000506e:	a5dfb0ef          	jal	ra,80000aca <kalloc>
    80005072:	85aa                	mv	a1,a0
    80005074:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005078:	cd01                	beqz	a0,80005090 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000507a:	6605                	lui	a2,0x1
    8000507c:	e3043503          	ld	a0,-464(s0)
    80005080:	f52fd0ef          	jal	ra,800027d2 <fetchstr>
    80005084:	00054663          	bltz	a0,80005090 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80005088:	0905                	addi	s2,s2,1
    8000508a:	09a1                	addi	s3,s3,8
    8000508c:	fd4911e3          	bne	s2,s4,8000504e <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005090:	10048913          	addi	s2,s1,256
    80005094:	6088                	ld	a0,0(s1)
    80005096:	c121                	beqz	a0,800050d6 <sys_exec+0xd4>
    kfree(argv[i]);
    80005098:	953fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509c:	04a1                	addi	s1,s1,8
    8000509e:	ff249be3          	bne	s1,s2,80005094 <sys_exec+0x92>
  return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	a815                	j	800050d8 <sys_exec+0xd6>
      argv[i] = 0;
    800050a6:	0a8e                	slli	s5,s5,0x3
    800050a8:	fc040793          	addi	a5,s0,-64
    800050ac:	9abe                	add	s5,s5,a5
    800050ae:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050b2:	e4040593          	addi	a1,s0,-448
    800050b6:	f4040513          	addi	a0,s0,-192
    800050ba:	bfaff0ef          	jal	ra,800044b4 <exec>
    800050be:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c0:	10048993          	addi	s3,s1,256
    800050c4:	6088                	ld	a0,0(s1)
    800050c6:	c511                	beqz	a0,800050d2 <sys_exec+0xd0>
    kfree(argv[i]);
    800050c8:	923fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050cc:	04a1                	addi	s1,s1,8
    800050ce:	ff349be3          	bne	s1,s3,800050c4 <sys_exec+0xc2>
  return ret;
    800050d2:	854a                	mv	a0,s2
    800050d4:	a011                	j	800050d8 <sys_exec+0xd6>
  return -1;
    800050d6:	557d                	li	a0,-1
}
    800050d8:	60be                	ld	ra,456(sp)
    800050da:	641e                	ld	s0,448(sp)
    800050dc:	74fa                	ld	s1,440(sp)
    800050de:	795a                	ld	s2,432(sp)
    800050e0:	79ba                	ld	s3,424(sp)
    800050e2:	7a1a                	ld	s4,416(sp)
    800050e4:	6afa                	ld	s5,408(sp)
    800050e6:	6179                	addi	sp,sp,464
    800050e8:	8082                	ret

00000000800050ea <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ea:	7139                	addi	sp,sp,-64
    800050ec:	fc06                	sd	ra,56(sp)
    800050ee:	f822                	sd	s0,48(sp)
    800050f0:	f426                	sd	s1,40(sp)
    800050f2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050f4:	f38fc0ef          	jal	ra,8000182c <myproc>
    800050f8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050fa:	fd840593          	addi	a1,s0,-40
    800050fe:	4501                	li	a0,0
    80005100:	f2efd0ef          	jal	ra,8000282e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005104:	fc840593          	addi	a1,s0,-56
    80005108:	fd040513          	addi	a0,s0,-48
    8000510c:	8d2ff0ef          	jal	ra,800041de <pipealloc>
    return -1;
    80005110:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005112:	0a054463          	bltz	a0,800051ba <sys_pipe+0xd0>
  fd0 = -1;
    80005116:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000511a:	fd043503          	ld	a0,-48(s0)
    8000511e:	f42ff0ef          	jal	ra,80004860 <fdalloc>
    80005122:	fca42223          	sw	a0,-60(s0)
    80005126:	08054163          	bltz	a0,800051a8 <sys_pipe+0xbe>
    8000512a:	fc843503          	ld	a0,-56(s0)
    8000512e:	f32ff0ef          	jal	ra,80004860 <fdalloc>
    80005132:	fca42023          	sw	a0,-64(s0)
    80005136:	06054063          	bltz	a0,80005196 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513a:	4691                	li	a3,4
    8000513c:	fc440613          	addi	a2,s0,-60
    80005140:	fd843583          	ld	a1,-40(s0)
    80005144:	68a8                	ld	a0,80(s1)
    80005146:	b9afc0ef          	jal	ra,800014e0 <copyout>
    8000514a:	00054e63          	bltz	a0,80005166 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000514e:	4691                	li	a3,4
    80005150:	fc040613          	addi	a2,s0,-64
    80005154:	fd843583          	ld	a1,-40(s0)
    80005158:	0591                	addi	a1,a1,4
    8000515a:	68a8                	ld	a0,80(s1)
    8000515c:	b84fc0ef          	jal	ra,800014e0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005160:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005162:	04055c63          	bgez	a0,800051ba <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005166:	fc442783          	lw	a5,-60(s0)
    8000516a:	07e9                	addi	a5,a5,26
    8000516c:	078e                	slli	a5,a5,0x3
    8000516e:	97a6                	add	a5,a5,s1
    80005170:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005174:	fc042503          	lw	a0,-64(s0)
    80005178:	0569                	addi	a0,a0,26
    8000517a:	050e                	slli	a0,a0,0x3
    8000517c:	94aa                	add	s1,s1,a0
    8000517e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	d8dfe0ef          	jal	ra,80003f12 <fileclose>
    fileclose(wf);
    8000518a:	fc843503          	ld	a0,-56(s0)
    8000518e:	d85fe0ef          	jal	ra,80003f12 <fileclose>
    return -1;
    80005192:	57fd                	li	a5,-1
    80005194:	a01d                	j	800051ba <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005196:	fc442783          	lw	a5,-60(s0)
    8000519a:	0007c763          	bltz	a5,800051a8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000519e:	07e9                	addi	a5,a5,26
    800051a0:	078e                	slli	a5,a5,0x3
    800051a2:	94be                	add	s1,s1,a5
    800051a4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051a8:	fd043503          	ld	a0,-48(s0)
    800051ac:	d67fe0ef          	jal	ra,80003f12 <fileclose>
    fileclose(wf);
    800051b0:	fc843503          	ld	a0,-56(s0)
    800051b4:	d5ffe0ef          	jal	ra,80003f12 <fileclose>
    return -1;
    800051b8:	57fd                	li	a5,-1
}
    800051ba:	853e                	mv	a0,a5
    800051bc:	70e2                	ld	ra,56(sp)
    800051be:	7442                	ld	s0,48(sp)
    800051c0:	74a2                	ld	s1,40(sp)
    800051c2:	6121                	addi	sp,sp,64
    800051c4:	8082                	ret

00000000800051c6 <sys_lseek>:

uint64 sys_lseek(void) {
    800051c6:	7179                	addi	sp,sp,-48
    800051c8:	f406                	sd	ra,40(sp)
    800051ca:	f022                	sd	s0,32(sp)
    800051cc:	1800                	addi	s0,sp,48
    int offset;
    int whence;
    struct file *f;

    // Récupérer les arguments
    argint(0, &fd);
    800051ce:	fec40593          	addi	a1,s0,-20
    800051d2:	4501                	li	a0,0
    800051d4:	e3efd0ef          	jal	ra,80002812 <argint>
    argint(1, &offset);
    800051d8:	fe840593          	addi	a1,s0,-24
    800051dc:	4505                	li	a0,1
    800051de:	e34fd0ef          	jal	ra,80002812 <argint>
    argint(2, &whence);
    800051e2:	fe440593          	addi	a1,s0,-28
    800051e6:	4509                	li	a0,2
    800051e8:	e2afd0ef          	jal	ra,80002812 <argint>

    // Récupérer le descripteur de fichier
    if (argfd(0, &fd, &f) < 0)
    800051ec:	fd840613          	addi	a2,s0,-40
    800051f0:	fec40593          	addi	a1,s0,-20
    800051f4:	4501                	li	a0,0
    800051f6:	e12ff0ef          	jal	ra,80004808 <argfd>
    800051fa:	04054e63          	bltz	a0,80005256 <sys_lseek+0x90>
        return -1;

    // Vérifier que le fichier est ouvert en lecture/écriture
    if (f->type != FD_INODE || !f->writable || !f->readable)
    800051fe:	fd843783          	ld	a5,-40(s0)
    80005202:	4394                	lw	a3,0(a5)
    80005204:	4709                	li	a4,2
        return -1;
    80005206:	557d                	li	a0,-1
    if (f->type != FD_INODE || !f->writable || !f->readable)
    80005208:	02e69663          	bne	a3,a4,80005234 <sys_lseek+0x6e>
    8000520c:	0097c703          	lbu	a4,9(a5)
    80005210:	c315                	beqz	a4,80005234 <sys_lseek+0x6e>
    80005212:	0087c703          	lbu	a4,8(a5)
    80005216:	cf19                	beqz	a4,80005234 <sys_lseek+0x6e>

    // Appliquer le décalage en fonction de whence
    switch (whence) {
    80005218:	fe442703          	lw	a4,-28(s0)
    8000521c:	4685                	li	a3,1
    8000521e:	00d70f63          	beq	a4,a3,8000523c <sys_lseek+0x76>
    80005222:	4689                	li	a3,2
    80005224:	02d70263          	beq	a4,a3,80005248 <sys_lseek+0x82>
    80005228:	e711                	bnez	a4,80005234 <sys_lseek+0x6e>
        case SEEK_SET:
            f->off = offset;
    8000522a:	fe842703          	lw	a4,-24(s0)
    8000522e:	d398                	sw	a4,32(a5)
            break;
        default:
            return -1;
    }

    return f->off;
    80005230:	0207e503          	lwu	a0,32(a5)
}
    80005234:	70a2                	ld	ra,40(sp)
    80005236:	7402                	ld	s0,32(sp)
    80005238:	6145                	addi	sp,sp,48
    8000523a:	8082                	ret
            f->off += offset;
    8000523c:	5398                	lw	a4,32(a5)
    8000523e:	fe842683          	lw	a3,-24(s0)
    80005242:	9f35                	addw	a4,a4,a3
    80005244:	d398                	sw	a4,32(a5)
            break;
    80005246:	b7ed                	j	80005230 <sys_lseek+0x6a>
            f->off = f->ip->size + offset;
    80005248:	6f98                	ld	a4,24(a5)
    8000524a:	4778                	lw	a4,76(a4)
    8000524c:	fe842683          	lw	a3,-24(s0)
    80005250:	9f35                	addw	a4,a4,a3
    80005252:	d398                	sw	a4,32(a5)
            break;
    80005254:	bff1                	j	80005230 <sys_lseek+0x6a>
        return -1;
    80005256:	557d                	li	a0,-1
    80005258:	bff1                	j	80005234 <sys_lseek+0x6e>
    8000525a:	0000                	unimp
    8000525c:	0000                	unimp
	...

0000000080005260 <kernelvec>:
    80005260:	7111                	addi	sp,sp,-256
    80005262:	e006                	sd	ra,0(sp)
    80005264:	e40a                	sd	sp,8(sp)
    80005266:	e80e                	sd	gp,16(sp)
    80005268:	ec12                	sd	tp,24(sp)
    8000526a:	f016                	sd	t0,32(sp)
    8000526c:	f41a                	sd	t1,40(sp)
    8000526e:	f81e                	sd	t2,48(sp)
    80005270:	e4aa                	sd	a0,72(sp)
    80005272:	e8ae                	sd	a1,80(sp)
    80005274:	ecb2                	sd	a2,88(sp)
    80005276:	f0b6                	sd	a3,96(sp)
    80005278:	f4ba                	sd	a4,104(sp)
    8000527a:	f8be                	sd	a5,112(sp)
    8000527c:	fcc2                	sd	a6,120(sp)
    8000527e:	e146                	sd	a7,128(sp)
    80005280:	edf2                	sd	t3,216(sp)
    80005282:	f1f6                	sd	t4,224(sp)
    80005284:	f5fa                	sd	t5,232(sp)
    80005286:	f9fe                	sd	t6,240(sp)
    80005288:	c10fd0ef          	jal	ra,80002698 <kerneltrap>
    8000528c:	6082                	ld	ra,0(sp)
    8000528e:	6122                	ld	sp,8(sp)
    80005290:	61c2                	ld	gp,16(sp)
    80005292:	7282                	ld	t0,32(sp)
    80005294:	7322                	ld	t1,40(sp)
    80005296:	73c2                	ld	t2,48(sp)
    80005298:	6526                	ld	a0,72(sp)
    8000529a:	65c6                	ld	a1,80(sp)
    8000529c:	6666                	ld	a2,88(sp)
    8000529e:	7686                	ld	a3,96(sp)
    800052a0:	7726                	ld	a4,104(sp)
    800052a2:	77c6                	ld	a5,112(sp)
    800052a4:	7866                	ld	a6,120(sp)
    800052a6:	688a                	ld	a7,128(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
	...

00000000800052be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052be:	1141                	addi	sp,sp,-16
    800052c0:	e422                	sd	s0,8(sp)
    800052c2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052c4:	0c0007b7          	lui	a5,0xc000
    800052c8:	4705                	li	a4,1
    800052ca:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052cc:	c3d8                	sw	a4,4(a5)
}
    800052ce:	6422                	ld	s0,8(sp)
    800052d0:	0141                	addi	sp,sp,16
    800052d2:	8082                	ret

00000000800052d4 <plicinithart>:

void
plicinithart(void)
{
    800052d4:	1141                	addi	sp,sp,-16
    800052d6:	e406                	sd	ra,8(sp)
    800052d8:	e022                	sd	s0,0(sp)
    800052da:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052dc:	d24fc0ef          	jal	ra,80001800 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052e0:	0085171b          	slliw	a4,a0,0x8
    800052e4:	0c0027b7          	lui	a5,0xc002
    800052e8:	97ba                	add	a5,a5,a4
    800052ea:	40200713          	li	a4,1026
    800052ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052f2:	00d5151b          	slliw	a0,a0,0xd
    800052f6:	0c2017b7          	lui	a5,0xc201
    800052fa:	953e                	add	a0,a0,a5
    800052fc:	00052023          	sw	zero,0(a0)
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret

0000000080005308 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005308:	1141                	addi	sp,sp,-16
    8000530a:	e406                	sd	ra,8(sp)
    8000530c:	e022                	sd	s0,0(sp)
    8000530e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005310:	cf0fc0ef          	jal	ra,80001800 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005314:	00d5179b          	slliw	a5,a0,0xd
    80005318:	0c201537          	lui	a0,0xc201
    8000531c:	953e                	add	a0,a0,a5
  return irq;
}
    8000531e:	4148                	lw	a0,4(a0)
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005328:	1101                	addi	sp,sp,-32
    8000532a:	ec06                	sd	ra,24(sp)
    8000532c:	e822                	sd	s0,16(sp)
    8000532e:	e426                	sd	s1,8(sp)
    80005330:	1000                	addi	s0,sp,32
    80005332:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005334:	cccfc0ef          	jal	ra,80001800 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005338:	00d5151b          	slliw	a0,a0,0xd
    8000533c:	0c2017b7          	lui	a5,0xc201
    80005340:	97aa                	add	a5,a5,a0
    80005342:	c3c4                	sw	s1,4(a5)
}
    80005344:	60e2                	ld	ra,24(sp)
    80005346:	6442                	ld	s0,16(sp)
    80005348:	64a2                	ld	s1,8(sp)
    8000534a:	6105                	addi	sp,sp,32
    8000534c:	8082                	ret

000000008000534e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000534e:	1141                	addi	sp,sp,-16
    80005350:	e406                	sd	ra,8(sp)
    80005352:	e022                	sd	s0,0(sp)
    80005354:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005356:	479d                	li	a5,7
    80005358:	04a7ca63          	blt	a5,a0,800053ac <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000535c:	00022797          	auipc	a5,0x22
    80005360:	c4c78793          	addi	a5,a5,-948 # 80026fa8 <disk>
    80005364:	97aa                	add	a5,a5,a0
    80005366:	0187c783          	lbu	a5,24(a5)
    8000536a:	e7b9                	bnez	a5,800053b8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000536c:	00451613          	slli	a2,a0,0x4
    80005370:	00022797          	auipc	a5,0x22
    80005374:	c3878793          	addi	a5,a5,-968 # 80026fa8 <disk>
    80005378:	6394                	ld	a3,0(a5)
    8000537a:	96b2                	add	a3,a3,a2
    8000537c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005380:	6398                	ld	a4,0(a5)
    80005382:	9732                	add	a4,a4,a2
    80005384:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005388:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000538c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005390:	953e                	add	a0,a0,a5
    80005392:	4785                	li	a5,1
    80005394:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005398:	00022517          	auipc	a0,0x22
    8000539c:	c2850513          	addi	a0,a0,-984 # 80026fc0 <disk+0x18>
    800053a0:	aebfc0ef          	jal	ra,80001e8a <wakeup>
}
    800053a4:	60a2                	ld	ra,8(sp)
    800053a6:	6402                	ld	s0,0(sp)
    800053a8:	0141                	addi	sp,sp,16
    800053aa:	8082                	ret
    panic("free_desc 1");
    800053ac:	00002517          	auipc	a0,0x2
    800053b0:	3ec50513          	addi	a0,a0,1004 # 80007798 <syscalls+0x308>
    800053b4:	ba2fb0ef          	jal	ra,80000756 <panic>
    panic("free_desc 2");
    800053b8:	00002517          	auipc	a0,0x2
    800053bc:	3f050513          	addi	a0,a0,1008 # 800077a8 <syscalls+0x318>
    800053c0:	b96fb0ef          	jal	ra,80000756 <panic>

00000000800053c4 <virtio_disk_init>:
{
    800053c4:	1101                	addi	sp,sp,-32
    800053c6:	ec06                	sd	ra,24(sp)
    800053c8:	e822                	sd	s0,16(sp)
    800053ca:	e426                	sd	s1,8(sp)
    800053cc:	e04a                	sd	s2,0(sp)
    800053ce:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053d0:	00002597          	auipc	a1,0x2
    800053d4:	3e858593          	addi	a1,a1,1000 # 800077b8 <syscalls+0x328>
    800053d8:	00022517          	auipc	a0,0x22
    800053dc:	cf850513          	addi	a0,a0,-776 # 800270d0 <disk+0x128>
    800053e0:	f3afb0ef          	jal	ra,80000b1a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	14f71063          	bne	a4,a5,80005534 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4709                	li	a4,2
    80005402:	12e79963          	bne	a5,a4,80005534 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000540e:	12e79363          	bne	a5,a4,80005534 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005412:	100017b7          	lui	a5,0x10001
    80005416:	47d8                	lw	a4,12(a5)
    80005418:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541a:	554d47b7          	lui	a5,0x554d4
    8000541e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005422:	10f71963          	bne	a4,a5,80005534 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	4705                	li	a4,1
    80005430:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005432:	470d                	li	a4,3
    80005434:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005436:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005438:	c7ffe737          	lui	a4,0xc7ffe
    8000543c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd7677>
    80005440:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005442:	2701                	sext.w	a4,a4
    80005444:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005446:	472d                	li	a4,11
    80005448:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000544a:	5bbc                	lw	a5,112(a5)
    8000544c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005450:	8ba1                	andi	a5,a5,8
    80005452:	0e078763          	beqz	a5,80005540 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000545e:	43fc                	lw	a5,68(a5)
    80005460:	2781                	sext.w	a5,a5
    80005462:	0e079563          	bnez	a5,8000554c <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	5bdc                	lw	a5,52(a5)
    8000546c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000546e:	0e078563          	beqz	a5,80005558 <virtio_disk_init+0x194>
  if(max < NUM)
    80005472:	471d                	li	a4,7
    80005474:	0ef77863          	bgeu	a4,a5,80005564 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    80005478:	e52fb0ef          	jal	ra,80000aca <kalloc>
    8000547c:	00022497          	auipc	s1,0x22
    80005480:	b2c48493          	addi	s1,s1,-1236 # 80026fa8 <disk>
    80005484:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005486:	e44fb0ef          	jal	ra,80000aca <kalloc>
    8000548a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000548c:	e3efb0ef          	jal	ra,80000aca <kalloc>
    80005490:	87aa                	mv	a5,a0
    80005492:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005494:	6088                	ld	a0,0(s1)
    80005496:	cd69                	beqz	a0,80005570 <virtio_disk_init+0x1ac>
    80005498:	00022717          	auipc	a4,0x22
    8000549c:	b1873703          	ld	a4,-1256(a4) # 80026fb0 <disk+0x8>
    800054a0:	cb61                	beqz	a4,80005570 <virtio_disk_init+0x1ac>
    800054a2:	c7f9                	beqz	a5,80005570 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    800054a4:	6605                	lui	a2,0x1
    800054a6:	4581                	li	a1,0
    800054a8:	fc6fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.avail, 0, PGSIZE);
    800054ac:	00022497          	auipc	s1,0x22
    800054b0:	afc48493          	addi	s1,s1,-1284 # 80026fa8 <disk>
    800054b4:	6605                	lui	a2,0x1
    800054b6:	4581                	li	a1,0
    800054b8:	6488                	ld	a0,8(s1)
    800054ba:	fb4fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.used, 0, PGSIZE);
    800054be:	6605                	lui	a2,0x1
    800054c0:	4581                	li	a1,0
    800054c2:	6888                	ld	a0,16(s1)
    800054c4:	faafb0ef          	jal	ra,80000c6e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	4721                	li	a4,8
    800054ce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054d0:	4098                	lw	a4,0(s1)
    800054d2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054d6:	40d8                	lw	a4,4(s1)
    800054d8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054dc:	6498                	ld	a4,8(s1)
    800054de:	0007069b          	sext.w	a3,a4
    800054e2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054e6:	9701                	srai	a4,a4,0x20
    800054e8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054ec:	6898                	ld	a4,16(s1)
    800054ee:	0007069b          	sext.w	a3,a4
    800054f2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054f6:	9701                	srai	a4,a4,0x20
    800054f8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054fc:	4705                	li	a4,1
    800054fe:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005500:	00e48c23          	sb	a4,24(s1)
    80005504:	00e48ca3          	sb	a4,25(s1)
    80005508:	00e48d23          	sb	a4,26(s1)
    8000550c:	00e48da3          	sb	a4,27(s1)
    80005510:	00e48e23          	sb	a4,28(s1)
    80005514:	00e48ea3          	sb	a4,29(s1)
    80005518:	00e48f23          	sb	a4,30(s1)
    8000551c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005520:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005524:	0727a823          	sw	s2,112(a5)
}
    80005528:	60e2                	ld	ra,24(sp)
    8000552a:	6442                	ld	s0,16(sp)
    8000552c:	64a2                	ld	s1,8(sp)
    8000552e:	6902                	ld	s2,0(sp)
    80005530:	6105                	addi	sp,sp,32
    80005532:	8082                	ret
    panic("could not find virtio disk");
    80005534:	00002517          	auipc	a0,0x2
    80005538:	29450513          	addi	a0,a0,660 # 800077c8 <syscalls+0x338>
    8000553c:	a1afb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005540:	00002517          	auipc	a0,0x2
    80005544:	2a850513          	addi	a0,a0,680 # 800077e8 <syscalls+0x358>
    80005548:	a0efb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk should not be ready");
    8000554c:	00002517          	auipc	a0,0x2
    80005550:	2bc50513          	addi	a0,a0,700 # 80007808 <syscalls+0x378>
    80005554:	a02fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk has no queue 0");
    80005558:	00002517          	auipc	a0,0x2
    8000555c:	2d050513          	addi	a0,a0,720 # 80007828 <syscalls+0x398>
    80005560:	9f6fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk max queue too short");
    80005564:	00002517          	auipc	a0,0x2
    80005568:	2e450513          	addi	a0,a0,740 # 80007848 <syscalls+0x3b8>
    8000556c:	9eafb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk kalloc");
    80005570:	00002517          	auipc	a0,0x2
    80005574:	2f850513          	addi	a0,a0,760 # 80007868 <syscalls+0x3d8>
    80005578:	9defb0ef          	jal	ra,80000756 <panic>

000000008000557c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000557c:	7119                	addi	sp,sp,-128
    8000557e:	fc86                	sd	ra,120(sp)
    80005580:	f8a2                	sd	s0,112(sp)
    80005582:	f4a6                	sd	s1,104(sp)
    80005584:	f0ca                	sd	s2,96(sp)
    80005586:	ecce                	sd	s3,88(sp)
    80005588:	e8d2                	sd	s4,80(sp)
    8000558a:	e4d6                	sd	s5,72(sp)
    8000558c:	e0da                	sd	s6,64(sp)
    8000558e:	fc5e                	sd	s7,56(sp)
    80005590:	f862                	sd	s8,48(sp)
    80005592:	f466                	sd	s9,40(sp)
    80005594:	f06a                	sd	s10,32(sp)
    80005596:	ec6e                	sd	s11,24(sp)
    80005598:	0100                	addi	s0,sp,128
    8000559a:	8aaa                	mv	s5,a0
    8000559c:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000559e:	00c52d03          	lw	s10,12(a0)
    800055a2:	001d1d1b          	slliw	s10,s10,0x1
    800055a6:	1d02                	slli	s10,s10,0x20
    800055a8:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800055ac:	00022517          	auipc	a0,0x22
    800055b0:	b2450513          	addi	a0,a0,-1244 # 800270d0 <disk+0x128>
    800055b4:	de6fb0ef          	jal	ra,80000b9a <acquire>
  for(int i = 0; i < 3; i++){
    800055b8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055ba:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055bc:	00022b97          	auipc	s7,0x22
    800055c0:	9ecb8b93          	addi	s7,s7,-1556 # 80026fa8 <disk>
  for(int i = 0; i < 3; i++){
    800055c4:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c6:	00022c97          	auipc	s9,0x22
    800055ca:	b0ac8c93          	addi	s9,s9,-1270 # 800270d0 <disk+0x128>
    800055ce:	a8a9                	j	80005628 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800055d0:	00fb8733          	add	a4,s7,a5
    800055d4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055d8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055da:	0207c563          	bltz	a5,80005604 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055de:	2905                	addiw	s2,s2,1
    800055e0:	0611                	addi	a2,a2,4
    800055e2:	05690863          	beq	s2,s6,80005632 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800055e6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055e8:	00022717          	auipc	a4,0x22
    800055ec:	9c070713          	addi	a4,a4,-1600 # 80026fa8 <disk>
    800055f0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055f2:	01874683          	lbu	a3,24(a4)
    800055f6:	fee9                	bnez	a3,800055d0 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800055f8:	2785                	addiw	a5,a5,1
    800055fa:	0705                	addi	a4,a4,1
    800055fc:	fe979be3          	bne	a5,s1,800055f2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005600:	57fd                	li	a5,-1
    80005602:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005604:	01205b63          	blez	s2,8000561a <virtio_disk_rw+0x9e>
    80005608:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000560a:	000a2503          	lw	a0,0(s4)
    8000560e:	d41ff0ef          	jal	ra,8000534e <free_desc>
      for(int j = 0; j < i; j++)
    80005612:	2d85                	addiw	s11,s11,1
    80005614:	0a11                	addi	s4,s4,4
    80005616:	ffb91ae3          	bne	s2,s11,8000560a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000561a:	85e6                	mv	a1,s9
    8000561c:	00022517          	auipc	a0,0x22
    80005620:	9a450513          	addi	a0,a0,-1628 # 80026fc0 <disk+0x18>
    80005624:	81bfc0ef          	jal	ra,80001e3e <sleep>
  for(int i = 0; i < 3; i++){
    80005628:	f8040a13          	addi	s4,s0,-128
{
    8000562c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000562e:	894e                	mv	s2,s3
    80005630:	bf5d                	j	800055e6 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005632:	f8042583          	lw	a1,-128(s0)
    80005636:	00a58793          	addi	a5,a1,10
    8000563a:	0792                	slli	a5,a5,0x4

  if(write)
    8000563c:	00022617          	auipc	a2,0x22
    80005640:	96c60613          	addi	a2,a2,-1684 # 80026fa8 <disk>
    80005644:	00f60733          	add	a4,a2,a5
    80005648:	018036b3          	snez	a3,s8
    8000564c:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000564e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005652:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005656:	f6078693          	addi	a3,a5,-160
    8000565a:	6218                	ld	a4,0(a2)
    8000565c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000565e:	00878513          	addi	a0,a5,8
    80005662:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005664:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005666:	6208                	ld	a0,0(a2)
    80005668:	96aa                	add	a3,a3,a0
    8000566a:	4741                	li	a4,16
    8000566c:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000566e:	4705                	li	a4,1
    80005670:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005674:	f8442703          	lw	a4,-124(s0)
    80005678:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000567c:	0712                	slli	a4,a4,0x4
    8000567e:	953a                	add	a0,a0,a4
    80005680:	058a8693          	addi	a3,s5,88
    80005684:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80005686:	6208                	ld	a0,0(a2)
    80005688:	972a                	add	a4,a4,a0
    8000568a:	40000693          	li	a3,1024
    8000568e:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005690:	001c3c13          	seqz	s8,s8
    80005694:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005696:	001c6c13          	ori	s8,s8,1
    8000569a:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000569e:	f8842603          	lw	a2,-120(s0)
    800056a2:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a6:	00022697          	auipc	a3,0x22
    800056aa:	90268693          	addi	a3,a3,-1790 # 80026fa8 <disk>
    800056ae:	00258713          	addi	a4,a1,2
    800056b2:	0712                	slli	a4,a4,0x4
    800056b4:	9736                	add	a4,a4,a3
    800056b6:	587d                	li	a6,-1
    800056b8:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056bc:	0612                	slli	a2,a2,0x4
    800056be:	9532                	add	a0,a0,a2
    800056c0:	f9078793          	addi	a5,a5,-112
    800056c4:	97b6                	add	a5,a5,a3
    800056c6:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800056c8:	629c                	ld	a5,0(a3)
    800056ca:	97b2                	add	a5,a5,a2
    800056cc:	4605                	li	a2,1
    800056ce:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056d0:	4509                	li	a0,2
    800056d2:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800056d6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056da:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800056de:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056e2:	6698                	ld	a4,8(a3)
    800056e4:	00275783          	lhu	a5,2(a4)
    800056e8:	8b9d                	andi	a5,a5,7
    800056ea:	0786                	slli	a5,a5,0x1
    800056ec:	97ba                	add	a5,a5,a4
    800056ee:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056f2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056f6:	6698                	ld	a4,8(a3)
    800056f8:	00275783          	lhu	a5,2(a4)
    800056fc:	2785                	addiw	a5,a5,1
    800056fe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005702:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005706:	100017b7          	lui	a5,0x10001
    8000570a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000570e:	004aa783          	lw	a5,4(s5)
    80005712:	00c79f63          	bne	a5,a2,80005730 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80005716:	00022917          	auipc	s2,0x22
    8000571a:	9ba90913          	addi	s2,s2,-1606 # 800270d0 <disk+0x128>
  while(b->disk == 1) {
    8000571e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005720:	85ca                	mv	a1,s2
    80005722:	8556                	mv	a0,s5
    80005724:	f1afc0ef          	jal	ra,80001e3e <sleep>
  while(b->disk == 1) {
    80005728:	004aa783          	lw	a5,4(s5)
    8000572c:	fe978ae3          	beq	a5,s1,80005720 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80005730:	f8042903          	lw	s2,-128(s0)
    80005734:	00290793          	addi	a5,s2,2
    80005738:	00479713          	slli	a4,a5,0x4
    8000573c:	00022797          	auipc	a5,0x22
    80005740:	86c78793          	addi	a5,a5,-1940 # 80026fa8 <disk>
    80005744:	97ba                	add	a5,a5,a4
    80005746:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000574a:	00022997          	auipc	s3,0x22
    8000574e:	85e98993          	addi	s3,s3,-1954 # 80026fa8 <disk>
    80005752:	00491713          	slli	a4,s2,0x4
    80005756:	0009b783          	ld	a5,0(s3)
    8000575a:	97ba                	add	a5,a5,a4
    8000575c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005760:	854a                	mv	a0,s2
    80005762:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005766:	be9ff0ef          	jal	ra,8000534e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0fd                	bnez	s1,80005752 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	00022517          	auipc	a0,0x22
    80005772:	96250513          	addi	a0,a0,-1694 # 800270d0 <disk+0x128>
    80005776:	cbcfb0ef          	jal	ra,80000c32 <release>
}
    8000577a:	70e6                	ld	ra,120(sp)
    8000577c:	7446                	ld	s0,112(sp)
    8000577e:	74a6                	ld	s1,104(sp)
    80005780:	7906                	ld	s2,96(sp)
    80005782:	69e6                	ld	s3,88(sp)
    80005784:	6a46                	ld	s4,80(sp)
    80005786:	6aa6                	ld	s5,72(sp)
    80005788:	6b06                	ld	s6,64(sp)
    8000578a:	7be2                	ld	s7,56(sp)
    8000578c:	7c42                	ld	s8,48(sp)
    8000578e:	7ca2                	ld	s9,40(sp)
    80005790:	7d02                	ld	s10,32(sp)
    80005792:	6de2                	ld	s11,24(sp)
    80005794:	6109                	addi	sp,sp,128
    80005796:	8082                	ret

0000000080005798 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005798:	1101                	addi	sp,sp,-32
    8000579a:	ec06                	sd	ra,24(sp)
    8000579c:	e822                	sd	s0,16(sp)
    8000579e:	e426                	sd	s1,8(sp)
    800057a0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a2:	00022497          	auipc	s1,0x22
    800057a6:	80648493          	addi	s1,s1,-2042 # 80026fa8 <disk>
    800057aa:	00022517          	auipc	a0,0x22
    800057ae:	92650513          	addi	a0,a0,-1754 # 800270d0 <disk+0x128>
    800057b2:	be8fb0ef          	jal	ra,80000b9a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b6:	10001737          	lui	a4,0x10001
    800057ba:	533c                	lw	a5,96(a4)
    800057bc:	8b8d                	andi	a5,a5,3
    800057be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057c0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c4:	689c                	ld	a5,16(s1)
    800057c6:	0204d703          	lhu	a4,32(s1)
    800057ca:	0027d783          	lhu	a5,2(a5)
    800057ce:	04f70663          	beq	a4,a5,8000581a <virtio_disk_intr+0x82>
    __sync_synchronize();
    800057d2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d6:	6898                	ld	a4,16(s1)
    800057d8:	0204d783          	lhu	a5,32(s1)
    800057dc:	8b9d                	andi	a5,a5,7
    800057de:	078e                	slli	a5,a5,0x3
    800057e0:	97ba                	add	a5,a5,a4
    800057e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057e4:	00278713          	addi	a4,a5,2
    800057e8:	0712                	slli	a4,a4,0x4
    800057ea:	9726                	add	a4,a4,s1
    800057ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057f0:	e321                	bnez	a4,80005830 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f2:	0789                	addi	a5,a5,2
    800057f4:	0792                	slli	a5,a5,0x4
    800057f6:	97a6                	add	a5,a5,s1
    800057f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057fe:	e8cfc0ef          	jal	ra,80001e8a <wakeup>

    disk.used_idx += 1;
    80005802:	0204d783          	lhu	a5,32(s1)
    80005806:	2785                	addiw	a5,a5,1
    80005808:	17c2                	slli	a5,a5,0x30
    8000580a:	93c1                	srli	a5,a5,0x30
    8000580c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005810:	6898                	ld	a4,16(s1)
    80005812:	00275703          	lhu	a4,2(a4)
    80005816:	faf71ee3          	bne	a4,a5,800057d2 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000581a:	00022517          	auipc	a0,0x22
    8000581e:	8b650513          	addi	a0,a0,-1866 # 800270d0 <disk+0x128>
    80005822:	c10fb0ef          	jal	ra,80000c32 <release>
}
    80005826:	60e2                	ld	ra,24(sp)
    80005828:	6442                	ld	s0,16(sp)
    8000582a:	64a2                	ld	s1,8(sp)
    8000582c:	6105                	addi	sp,sp,32
    8000582e:	8082                	ret
      panic("virtio_disk_intr status");
    80005830:	00002517          	auipc	a0,0x2
    80005834:	05050513          	addi	a0,a0,80 # 80007880 <syscalls+0x3f0>
    80005838:	f1ffa0ef          	jal	ra,80000756 <panic>
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
