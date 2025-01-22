
user/_menu:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_separator>:
#include "kernel/types.h"
#include "user/user.h"

// Fonction pour afficher une ligne de séparation stylisée
void print_separator() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("\033[1;34m+=====================================================+\033[0m\n"); // Bordure bleue
   8:	00001517          	auipc	a0,0x1
   c:	db850513          	addi	a0,a0,-584 # dc0 <malloc+0xde>
  10:	419000ef          	jal	ra,c28 <printf>
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <print_title>:

// Fonction pour afficher un titre centré
void print_title(char *title) {
  1c:	7139                	addi	sp,sp,-64
  1e:	fc06                	sd	ra,56(sp)
  20:	f822                	sd	s0,48(sp)
  22:	f426                	sd	s1,40(sp)
  24:	f04a                	sd	s2,32(sp)
  26:	ec4e                	sd	s3,24(sp)
  28:	e852                	sd	s4,16(sp)
  2a:	e456                	sd	s5,8(sp)
  2c:	e05a                	sd	s6,0(sp)
  2e:	0080                	addi	s0,sp,64
  30:	8b2a                	mv	s6,a0
    int len = strlen(title);
  32:	5ba000ef          	jal	ra,5ec <strlen>
    int padding = (50 - len) / 2; // 50 est la largeur du cadre
  36:	03200913          	li	s2,50
  3a:	40a9093b          	subw	s2,s2,a0
  3e:	0009049b          	sext.w	s1,s2
  42:	01f95a9b          	srliw	s5,s2,0x1f
  46:	012a8abb          	addw	s5,s5,s2
  4a:	401ada9b          	sraiw	s5,s5,0x1
    printf("\033[1;34m||\033[0m");
  4e:	00001517          	auipc	a0,0x1
  52:	dba50513          	addi	a0,a0,-582 # e08 <malloc+0x126>
  56:	3d3000ef          	jal	ra,c28 <printf>
    for (int i = 0; i < padding; i++) printf(" ");
  5a:	4785                	li	a5,1
  5c:	0097df63          	bge	a5,s1,7a <print_title+0x5e>
  60:	000a899b          	sext.w	s3,s5
  64:	4481                	li	s1,0
  66:	00001a17          	auipc	s4,0x1
  6a:	082a0a13          	addi	s4,s4,130 # 10e8 <malloc+0x406>
  6e:	8552                	mv	a0,s4
  70:	3b9000ef          	jal	ra,c28 <printf>
  74:	2485                	addiw	s1,s1,1
  76:	ff34cce3          	blt	s1,s3,6e <print_title+0x52>
    printf("\033[1;36m%s\033[0m", title); // Cyan pour le titre
  7a:	85da                	mv	a1,s6
  7c:	00001517          	auipc	a0,0x1
  80:	d9c50513          	addi	a0,a0,-612 # e18 <malloc+0x136>
  84:	3a5000ef          	jal	ra,c28 <printf>
    for (int i = 0; i < 50 - len - padding; i++) printf(" ");
  88:	4159093b          	subw	s2,s2,s5
  8c:	01205d63          	blez	s2,a6 <print_title+0x8a>
  90:	4481                	li	s1,0
  92:	00001997          	auipc	s3,0x1
  96:	05698993          	addi	s3,s3,86 # 10e8 <malloc+0x406>
  9a:	854e                	mv	a0,s3
  9c:	38d000ef          	jal	ra,c28 <printf>
  a0:	2485                	addiw	s1,s1,1
  a2:	ff249ce3          	bne	s1,s2,9a <print_title+0x7e>
    printf("\033[1;34m||\033[0m\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	d8250513          	addi	a0,a0,-638 # e28 <malloc+0x146>
  ae:	37b000ef          	jal	ra,c28 <printf>
}
  b2:	70e2                	ld	ra,56(sp)
  b4:	7442                	ld	s0,48(sp)
  b6:	74a2                	ld	s1,40(sp)
  b8:	7902                	ld	s2,32(sp)
  ba:	69e2                	ld	s3,24(sp)
  bc:	6a42                	ld	s4,16(sp)
  be:	6aa2                	ld	s5,8(sp)
  c0:	6b02                	ld	s6,0(sp)
  c2:	6121                	addi	sp,sp,64
  c4:	8082                	ret

00000000000000c6 <print_option>:

// Fonction pour afficher une option de menu avec alignement manuel
void print_option(int num, char *option) {
  c6:	7179                	addi	sp,sp,-48
  c8:	f406                	sd	ra,40(sp)
  ca:	f022                	sd	s0,32(sp)
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
  d2:	1800                	addi	s0,sp,48
  d4:	84ae                	mv	s1,a1
    printf("\033[1;34m||\033[0m \033[1;33m%d.\033[0m \033[1;32m%s\033[0m", num, option); // Jaune pour le numéro, vert pour l'option
  d6:	862e                	mv	a2,a1
  d8:	85aa                	mv	a1,a0
  da:	00001517          	auipc	a0,0x1
  de:	d5e50513          	addi	a0,a0,-674 # e38 <malloc+0x156>
  e2:	347000ef          	jal	ra,c28 <printf>

    // Ajouter des espaces pour aligner le texte à droite
    int len = strlen(option);
  e6:	8526                	mv	a0,s1
  e8:	504000ef          	jal	ra,5ec <strlen>
    int spaces_to_add = 45 - len; // 45 est la largeur disponible pour l'option
  ec:	02d00913          	li	s2,45
  f0:	40a9093b          	subw	s2,s2,a0
    for (int i = 0; i < spaces_to_add; i++) printf(" ");
  f4:	01205d63          	blez	s2,10e <print_option+0x48>
  f8:	4481                	li	s1,0
  fa:	00001997          	auipc	s3,0x1
  fe:	fee98993          	addi	s3,s3,-18 # 10e8 <malloc+0x406>
 102:	854e                	mv	a0,s3
 104:	325000ef          	jal	ra,c28 <printf>
 108:	2485                	addiw	s1,s1,1
 10a:	fe991ce3          	bne	s2,s1,102 <print_option+0x3c>

    printf("\033[1;34m||\033[0m\n"); // Fermer la ligne
 10e:	00001517          	auipc	a0,0x1
 112:	d1a50513          	addi	a0,a0,-742 # e28 <malloc+0x146>
 116:	313000ef          	jal	ra,c28 <printf>
}
 11a:	70a2                	ld	ra,40(sp)
 11c:	7402                	ld	s0,32(sp)
 11e:	64e2                	ld	s1,24(sp)
 120:	6942                	ld	s2,16(sp)
 122:	69a2                	ld	s3,8(sp)
 124:	6145                	addi	sp,sp,48
 126:	8082                	ret

0000000000000128 <print_menu>:

// Fonction pour afficher le menu principal
void print_menu() {
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
    print_separator();
 130:	ed1ff0ef          	jal	ra,0 <print_separator>
    print_title("XV6 Shell Menu");
 134:	00001517          	auipc	a0,0x1
 138:	d3450513          	addi	a0,a0,-716 # e68 <malloc+0x186>
 13c:	ee1ff0ef          	jal	ra,1c <print_title>
    print_separator();
 140:	ec1ff0ef          	jal	ra,0 <print_separator>
    print_option(1, "List Files (ls)");
 144:	00001597          	auipc	a1,0x1
 148:	d3458593          	addi	a1,a1,-716 # e78 <malloc+0x196>
 14c:	4505                	li	a0,1
 14e:	f79ff0ef          	jal	ra,c6 <print_option>
    print_option(2, "List Files Detailed (ls -l)");
 152:	00001597          	auipc	a1,0x1
 156:	d3658593          	addi	a1,a1,-714 # e88 <malloc+0x1a6>
 15a:	4509                	li	a0,2
 15c:	f6bff0ef          	jal	ra,c6 <print_option>
    print_option(3, "Create File (touch)");
 160:	00001597          	auipc	a1,0x1
 164:	d4858593          	addi	a1,a1,-696 # ea8 <malloc+0x1c6>
 168:	450d                	li	a0,3
 16a:	f5dff0ef          	jal	ra,c6 <print_option>
    print_option(4, "Change Permissions (chmod)");
 16e:	00001597          	auipc	a1,0x1
 172:	d5258593          	addi	a1,a1,-686 # ec0 <malloc+0x1de>
 176:	4511                	li	a0,4
 178:	f4fff0ef          	jal	ra,c6 <print_option>
    print_option(5, "Run Script (source)");
 17c:	00001597          	auipc	a1,0x1
 180:	d6458593          	addi	a1,a1,-668 # ee0 <malloc+0x1fe>
 184:	4515                	li	a0,5
 186:	f41ff0ef          	jal	ra,c6 <print_option>
    print_option(6, "Clear Screen (clear)");
 18a:	00001597          	auipc	a1,0x1
 18e:	d6e58593          	addi	a1,a1,-658 # ef8 <malloc+0x216>
 192:	4519                	li	a0,6
 194:	f33ff0ef          	jal	ra,c6 <print_option>
    print_option(7, "Show Processes (ps)");
 198:	00001597          	auipc	a1,0x1
 19c:	d7858593          	addi	a1,a1,-648 # f10 <malloc+0x22e>
 1a0:	451d                	li	a0,7
 1a2:	f25ff0ef          	jal	ra,c6 <print_option>
    print_option(8, "Create Directory (mkdir)");
 1a6:	00001597          	auipc	a1,0x1
 1aa:	d8258593          	addi	a1,a1,-638 # f28 <malloc+0x246>
 1ae:	4521                	li	a0,8
 1b0:	f17ff0ef          	jal	ra,c6 <print_option>
    print_option(9, "Sort File Content (sort)");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	d9458593          	addi	a1,a1,-620 # f48 <malloc+0x266>
 1bc:	4525                	li	a0,9
 1be:	f09ff0ef          	jal	ra,c6 <print_option>
    print_option(10, "Show File Head (head)");
 1c2:	00001597          	auipc	a1,0x1
 1c6:	da658593          	addi	a1,a1,-602 # f68 <malloc+0x286>
 1ca:	4529                	li	a0,10
 1cc:	efbff0ef          	jal	ra,c6 <print_option>
    print_option(11, "Show File Tail (tail)");
 1d0:	00001597          	auipc	a1,0x1
 1d4:	db058593          	addi	a1,a1,-592 # f80 <malloc+0x29e>
 1d8:	452d                	li	a0,11
 1da:	eedff0ef          	jal	ra,c6 <print_option>
    print_option(12, "Exit");
 1de:	00001597          	auipc	a1,0x1
 1e2:	dba58593          	addi	a1,a1,-582 # f98 <malloc+0x2b6>
 1e6:	4531                	li	a0,12
 1e8:	edfff0ef          	jal	ra,c6 <print_option>
    print_separator();
 1ec:	e15ff0ef          	jal	ra,0 <print_separator>
}
 1f0:	60a2                	ld	ra,8(sp)
 1f2:	6402                	ld	s0,0(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <main>:

// Fonction principale
int main() {
 1f8:	7151                	addi	sp,sp,-240
 1fa:	f586                	sd	ra,232(sp)
 1fc:	f1a2                	sd	s0,224(sp)
 1fe:	eda6                	sd	s1,216(sp)
 200:	e9ca                	sd	s2,208(sp)
 202:	e5ce                	sd	s3,200(sp)
 204:	e1d2                	sd	s4,192(sp)
 206:	fd56                	sd	s5,184(sp)
 208:	1980                	addi	s0,sp,240
    char input[10];

    while (1) {
        print_menu();
        printf("\033[1;35mEnter your choice:\033[0m "); // Magenta pour la question
 20a:	00001997          	auipc	s3,0x1
 20e:	d9698993          	addi	s3,s3,-618 # fa0 <malloc+0x2be>
 212:	4931                	li	s2,12
            case 12:
                printf("\033[1;31mExiting...\033[0m\n"); // Rouge pour le message de sortie
                exit(0);

            default:
                printf("\033[1;31mInvalid choice. Please try again.\033[0m\n"); // Rouge pour l'erreur
 214:	00001a97          	auipc	s5,0x1
 218:	f8ca8a93          	addi	s5,s5,-116 # 11a0 <malloc+0x4be>
 21c:	00001497          	auipc	s1,0x1
 220:	fdc48493          	addi	s1,s1,-36 # 11f8 <malloc+0x516>
                printf("\033[1;35mEnter file name for tail:\033[0m "); // Magenta pour la question
 224:	00001a17          	auipc	s4,0x1
 228:	f34a0a13          	addi	s4,s4,-204 # 1158 <malloc+0x476>
 22c:	ae35                	j	568 <main+0x370>
                printf("\033[1;32mExecuting 'ls'...\033[0m\n"); // Vert pour le message d'exécution
 22e:	00001517          	auipc	a0,0x1
 232:	d9250513          	addi	a0,a0,-622 # fc0 <malloc+0x2de>
 236:	1f3000ef          	jal	ra,c28 <printf>
                if (fork() == 0) {
 23a:	5bc000ef          	jal	ra,7f6 <fork>
 23e:	c509                	beqz	a0,248 <main+0x50>
                wait(0);
 240:	4501                	li	a0,0
 242:	5c4000ef          	jal	ra,806 <wait>
                break;
 246:	a631                	j	552 <main+0x35a>
                    char *args[] = {"ls", 0};
 248:	00001517          	auipc	a0,0x1
 24c:	d9850513          	addi	a0,a0,-616 # fe0 <malloc+0x2fe>
 250:	f4a43423          	sd	a0,-184(s0)
 254:	f4043823          	sd	zero,-176(s0)
                    exec("ls", args);
 258:	f4840593          	addi	a1,s0,-184
 25c:	5da000ef          	jal	ra,836 <exec>
                    exit(0);
 260:	4501                	li	a0,0
 262:	59c000ef          	jal	ra,7fe <exit>
                printf("\033[1;32mExecuting 'ls -l'...\033[0m\n");
 266:	00001517          	auipc	a0,0x1
 26a:	d8250513          	addi	a0,a0,-638 # fe8 <malloc+0x306>
 26e:	1bb000ef          	jal	ra,c28 <printf>
                if (fork() == 0) {
 272:	584000ef          	jal	ra,7f6 <fork>
 276:	c509                	beqz	a0,280 <main+0x88>
                wait(0);
 278:	4501                	li	a0,0
 27a:	58c000ef          	jal	ra,806 <wait>
                break;
 27e:	acd1                	j	552 <main+0x35a>
                    char *args[] = {"ls", "-l", 0};
 280:	00001517          	auipc	a0,0x1
 284:	d6050513          	addi	a0,a0,-672 # fe0 <malloc+0x2fe>
 288:	f4a43423          	sd	a0,-184(s0)
 28c:	00001797          	auipc	a5,0x1
 290:	d8478793          	addi	a5,a5,-636 # 1010 <malloc+0x32e>
 294:	f4f43823          	sd	a5,-176(s0)
 298:	f4043c23          	sd	zero,-168(s0)
                    exec("ls", args);
 29c:	f4840593          	addi	a1,s0,-184
 2a0:	596000ef          	jal	ra,836 <exec>
                    exit(0);
 2a4:	4501                	li	a0,0
 2a6:	558000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter file name:\033[0m "); // Magenta pour la question
 2aa:	00001517          	auipc	a0,0x1
 2ae:	d6e50513          	addi	a0,a0,-658 # 1018 <malloc+0x336>
 2b2:	177000ef          	jal	ra,c28 <printf>
                gets(filename, sizeof(filename));
 2b6:	06400593          	li	a1,100
 2ba:	f4840513          	addi	a0,s0,-184
 2be:	39e000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 2c2:	534000ef          	jal	ra,7f6 <fork>
 2c6:	c509                	beqz	a0,2d0 <main+0xd8>
                wait(0);
 2c8:	4501                	li	a0,0
 2ca:	53c000ef          	jal	ra,806 <wait>
                break;
 2ce:	a451                	j	552 <main+0x35a>
                    char *args[] = {"touch", filename, 0};
 2d0:	00001517          	auipc	a0,0x1
 2d4:	d6850513          	addi	a0,a0,-664 # 1038 <malloc+0x356>
 2d8:	f2a43423          	sd	a0,-216(s0)
 2dc:	f4840793          	addi	a5,s0,-184
 2e0:	f2f43823          	sd	a5,-208(s0)
 2e4:	f2043c23          	sd	zero,-200(s0)
                    exec("touch", args);
 2e8:	f2840593          	addi	a1,s0,-216
 2ec:	54a000ef          	jal	ra,836 <exec>
                    exit(0);
 2f0:	4501                	li	a0,0
 2f2:	50c000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter file name:\033[0m "); // Magenta pour la question
 2f6:	00001517          	auipc	a0,0x1
 2fa:	d2250513          	addi	a0,a0,-734 # 1018 <malloc+0x336>
 2fe:	12b000ef          	jal	ra,c28 <printf>
                gets(chmod_file, sizeof(chmod_file));
 302:	06400593          	li	a1,100
 306:	f4840513          	addi	a0,s0,-184
 30a:	352000ef          	jal	ra,65c <gets>
                printf("\033[1;35mEnter mode (e.g., 755):\033[0m "); // Magenta pour la question
 30e:	00001517          	auipc	a0,0x1
 312:	d3250513          	addi	a0,a0,-718 # 1040 <malloc+0x35e>
 316:	113000ef          	jal	ra,c28 <printf>
                gets(mode, sizeof(mode));
 31a:	45a9                	li	a1,10
 31c:	f1840513          	addi	a0,s0,-232
 320:	33c000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 324:	4d2000ef          	jal	ra,7f6 <fork>
 328:	c509                	beqz	a0,332 <main+0x13a>
                wait(0);
 32a:	4501                	li	a0,0
 32c:	4da000ef          	jal	ra,806 <wait>
                break;
 330:	a40d                	j	552 <main+0x35a>
                    char *args[] = {"chmod", mode, chmod_file, 0};
 332:	00001517          	auipc	a0,0x1
 336:	d3650513          	addi	a0,a0,-714 # 1068 <malloc+0x386>
 33a:	f2a43423          	sd	a0,-216(s0)
 33e:	f1840793          	addi	a5,s0,-232
 342:	f2f43823          	sd	a5,-208(s0)
 346:	f4840793          	addi	a5,s0,-184
 34a:	f2f43c23          	sd	a5,-200(s0)
 34e:	f4043023          	sd	zero,-192(s0)
                    exec("chmod", args);
 352:	f2840593          	addi	a1,s0,-216
 356:	4e0000ef          	jal	ra,836 <exec>
                    exit(0);
 35a:	4501                	li	a0,0
 35c:	4a2000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter script name:\033[0m "); // Magenta pour la question
 360:	00001517          	auipc	a0,0x1
 364:	d1050513          	addi	a0,a0,-752 # 1070 <malloc+0x38e>
 368:	0c1000ef          	jal	ra,c28 <printf>
                gets(script, sizeof(script));
 36c:	06400593          	li	a1,100
 370:	f4840513          	addi	a0,s0,-184
 374:	2e8000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 378:	47e000ef          	jal	ra,7f6 <fork>
 37c:	c509                	beqz	a0,386 <main+0x18e>
                wait(0);
 37e:	4501                	li	a0,0
 380:	486000ef          	jal	ra,806 <wait>
                break;
 384:	a2f9                	j	552 <main+0x35a>
                    char *args[] = {"source", script, 0};
 386:	00001517          	auipc	a0,0x1
 38a:	d0a50513          	addi	a0,a0,-758 # 1090 <malloc+0x3ae>
 38e:	f2a43423          	sd	a0,-216(s0)
 392:	f4840793          	addi	a5,s0,-184
 396:	f2f43823          	sd	a5,-208(s0)
 39a:	f2043c23          	sd	zero,-200(s0)
                    exec("source", args);
 39e:	f2840593          	addi	a1,s0,-216
 3a2:	494000ef          	jal	ra,836 <exec>
                    exit(0);
 3a6:	4501                	li	a0,0
 3a8:	456000ef          	jal	ra,7fe <exit>
                if (fork() == 0) {
 3ac:	44a000ef          	jal	ra,7f6 <fork>
 3b0:	c509                	beqz	a0,3ba <main+0x1c2>
                wait(0);
 3b2:	4501                	li	a0,0
 3b4:	452000ef          	jal	ra,806 <wait>
                break;
 3b8:	aa69                	j	552 <main+0x35a>
                    char *args[] = {"clear", 0};
 3ba:	00001517          	auipc	a0,0x1
 3be:	cde50513          	addi	a0,a0,-802 # 1098 <malloc+0x3b6>
 3c2:	f4a43423          	sd	a0,-184(s0)
 3c6:	f4043823          	sd	zero,-176(s0)
                    exec("clear", args);
 3ca:	f4840593          	addi	a1,s0,-184
 3ce:	468000ef          	jal	ra,836 <exec>
                    exit(0);
 3d2:	4501                	li	a0,0
 3d4:	42a000ef          	jal	ra,7fe <exit>
                printf("\033[1;32mExecuting 'ps'...\033[0m\n");
 3d8:	00001517          	auipc	a0,0x1
 3dc:	cc850513          	addi	a0,a0,-824 # 10a0 <malloc+0x3be>
 3e0:	049000ef          	jal	ra,c28 <printf>
                if (fork() == 0) {
 3e4:	412000ef          	jal	ra,7f6 <fork>
 3e8:	c509                	beqz	a0,3f2 <main+0x1fa>
                wait(0);
 3ea:	4501                	li	a0,0
 3ec:	41a000ef          	jal	ra,806 <wait>
                break;
 3f0:	a28d                	j	552 <main+0x35a>
                    char *args[] = {"ps", 0};
 3f2:	00001517          	auipc	a0,0x1
 3f6:	cce50513          	addi	a0,a0,-818 # 10c0 <malloc+0x3de>
 3fa:	f4a43423          	sd	a0,-184(s0)
 3fe:	f4043823          	sd	zero,-176(s0)
                    exec("ps", args);
 402:	f4840593          	addi	a1,s0,-184
 406:	430000ef          	jal	ra,836 <exec>
                    exit(0);
 40a:	4501                	li	a0,0
 40c:	3f2000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter directory name:\033[0m "); // Magenta pour la question
 410:	00001517          	auipc	a0,0x1
 414:	cb850513          	addi	a0,a0,-840 # 10c8 <malloc+0x3e6>
 418:	011000ef          	jal	ra,c28 <printf>
                gets(dirname, sizeof(dirname));
 41c:	06400593          	li	a1,100
 420:	f4840513          	addi	a0,s0,-184
 424:	238000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 428:	3ce000ef          	jal	ra,7f6 <fork>
 42c:	c509                	beqz	a0,436 <main+0x23e>
                wait(0);
 42e:	4501                	li	a0,0
 430:	3d6000ef          	jal	ra,806 <wait>
                break;
 434:	aa39                	j	552 <main+0x35a>
                    char *args[] = {"mkdir", dirname, 0};
 436:	00001517          	auipc	a0,0x1
 43a:	cba50513          	addi	a0,a0,-838 # 10f0 <malloc+0x40e>
 43e:	f2a43423          	sd	a0,-216(s0)
 442:	f4840793          	addi	a5,s0,-184
 446:	f2f43823          	sd	a5,-208(s0)
 44a:	f2043c23          	sd	zero,-200(s0)
                    exec("mkdir", args);
 44e:	f2840593          	addi	a1,s0,-216
 452:	3e4000ef          	jal	ra,836 <exec>
                    exit(0);
 456:	4501                	li	a0,0
 458:	3a6000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter file name to sort:\033[0m "); // Magenta pour la question
 45c:	00001517          	auipc	a0,0x1
 460:	c9c50513          	addi	a0,a0,-868 # 10f8 <malloc+0x416>
 464:	7c4000ef          	jal	ra,c28 <printf>
                gets(sort_file, sizeof(sort_file));
 468:	06400593          	li	a1,100
 46c:	f4840513          	addi	a0,s0,-184
 470:	1ec000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 474:	382000ef          	jal	ra,7f6 <fork>
 478:	c509                	beqz	a0,482 <main+0x28a>
                wait(0);
 47a:	4501                	li	a0,0
 47c:	38a000ef          	jal	ra,806 <wait>
                break;
 480:	a8c9                	j	552 <main+0x35a>
                    char *args[] = {"sort", sort_file, 0};
 482:	00001517          	auipc	a0,0x1
 486:	c9e50513          	addi	a0,a0,-866 # 1120 <malloc+0x43e>
 48a:	f2a43423          	sd	a0,-216(s0)
 48e:	f4840793          	addi	a5,s0,-184
 492:	f2f43823          	sd	a5,-208(s0)
 496:	f2043c23          	sd	zero,-200(s0)
                    exec("sort", args);
 49a:	f2840593          	addi	a1,s0,-216
 49e:	398000ef          	jal	ra,836 <exec>
                    exit(0);
 4a2:	4501                	li	a0,0
 4a4:	35a000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter file name for head:\033[0m "); // Magenta pour la question
 4a8:	00001517          	auipc	a0,0x1
 4ac:	c8050513          	addi	a0,a0,-896 # 1128 <malloc+0x446>
 4b0:	778000ef          	jal	ra,c28 <printf>
                gets(head_file, sizeof(head_file));
 4b4:	06400593          	li	a1,100
 4b8:	f4840513          	addi	a0,s0,-184
 4bc:	1a0000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 4c0:	336000ef          	jal	ra,7f6 <fork>
 4c4:	c509                	beqz	a0,4ce <main+0x2d6>
                wait(0);
 4c6:	4501                	li	a0,0
 4c8:	33e000ef          	jal	ra,806 <wait>
                break;
 4cc:	a059                	j	552 <main+0x35a>
                    char *args[] = {"head", head_file, 0};
 4ce:	00001517          	auipc	a0,0x1
 4d2:	c8250513          	addi	a0,a0,-894 # 1150 <malloc+0x46e>
 4d6:	f2a43423          	sd	a0,-216(s0)
 4da:	f4840793          	addi	a5,s0,-184
 4de:	f2f43823          	sd	a5,-208(s0)
 4e2:	f2043c23          	sd	zero,-200(s0)
                    exec("head", args);
 4e6:	f2840593          	addi	a1,s0,-216
 4ea:	34c000ef          	jal	ra,836 <exec>
                    exit(0);
 4ee:	4501                	li	a0,0
 4f0:	30e000ef          	jal	ra,7fe <exit>
                printf("\033[1;35mEnter file name for tail:\033[0m "); // Magenta pour la question
 4f4:	8552                	mv	a0,s4
 4f6:	732000ef          	jal	ra,c28 <printf>
                gets(tail_file, sizeof(tail_file));
 4fa:	06400593          	li	a1,100
 4fe:	f4840513          	addi	a0,s0,-184
 502:	15a000ef          	jal	ra,65c <gets>
                if (fork() == 0) {
 506:	2f0000ef          	jal	ra,7f6 <fork>
 50a:	c509                	beqz	a0,514 <main+0x31c>
                wait(0);
 50c:	4501                	li	a0,0
 50e:	2f8000ef          	jal	ra,806 <wait>
                break;
 512:	a081                	j	552 <main+0x35a>
                    char *args[] = {"tail", tail_file, 0};
 514:	00001517          	auipc	a0,0x1
 518:	c6c50513          	addi	a0,a0,-916 # 1180 <malloc+0x49e>
 51c:	f2a43423          	sd	a0,-216(s0)
 520:	f4840793          	addi	a5,s0,-184
 524:	f2f43823          	sd	a5,-208(s0)
 528:	f2043c23          	sd	zero,-200(s0)
                    exec("tail", args);
 52c:	f2840593          	addi	a1,s0,-216
 530:	306000ef          	jal	ra,836 <exec>
                    exit(0);
 534:	4501                	li	a0,0
 536:	2c8000ef          	jal	ra,7fe <exit>
                printf("\033[1;31mExiting...\033[0m\n"); // Rouge pour le message de sortie
 53a:	00001517          	auipc	a0,0x1
 53e:	c4e50513          	addi	a0,a0,-946 # 1188 <malloc+0x4a6>
 542:	6e6000ef          	jal	ra,c28 <printf>
                exit(0);
 546:	4501                	li	a0,0
 548:	2b6000ef          	jal	ra,7fe <exit>
                printf("\033[1;31mInvalid choice. Please try again.\033[0m\n"); // Rouge pour l'erreur
 54c:	8556                	mv	a0,s5
 54e:	6da000ef          	jal	ra,c28 <printf>
                break;
        }

        printf("\n\033[1;35mPress Enter to continue...\033[0m"); // Magenta pour la question
 552:	00001517          	auipc	a0,0x1
 556:	c7e50513          	addi	a0,a0,-898 # 11d0 <malloc+0x4ee>
 55a:	6ce000ef          	jal	ra,c28 <printf>
        gets(input, sizeof(input));
 55e:	45a9                	li	a1,10
 560:	fb040513          	addi	a0,s0,-80
 564:	0f8000ef          	jal	ra,65c <gets>
        print_menu();
 568:	bc1ff0ef          	jal	ra,128 <print_menu>
        printf("\033[1;35mEnter your choice:\033[0m "); // Magenta pour la question
 56c:	854e                	mv	a0,s3
 56e:	6ba000ef          	jal	ra,c28 <printf>
        gets(input, sizeof(input));
 572:	45a9                	li	a1,10
 574:	fb040513          	addi	a0,s0,-80
 578:	0e4000ef          	jal	ra,65c <gets>
        int choice = atoi(input);
 57c:	fb040513          	addi	a0,s0,-80
 580:	186000ef          	jal	ra,706 <atoi>
        switch (choice) {
 584:	fca964e3          	bltu	s2,a0,54c <main+0x354>
 588:	050a                	slli	a0,a0,0x2
 58a:	9526                	add	a0,a0,s1
 58c:	411c                	lw	a5,0(a0)
 58e:	97a6                	add	a5,a5,s1
 590:	8782                	jr	a5

0000000000000592 <start>:
//


void
start()
{
 592:	1141                	addi	sp,sp,-16
 594:	e406                	sd	ra,8(sp)
 596:	e022                	sd	s0,0(sp)
 598:	0800                	addi	s0,sp,16
  extern int main();
  main();
 59a:	c5fff0ef          	jal	ra,1f8 <main>
  exit(0);
 59e:	4501                	li	a0,0
 5a0:	25e000ef          	jal	ra,7fe <exit>

00000000000005a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 5a4:	1141                	addi	sp,sp,-16
 5a6:	e422                	sd	s0,8(sp)
 5a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5aa:	87aa                	mv	a5,a0
 5ac:	0585                	addi	a1,a1,1
 5ae:	0785                	addi	a5,a5,1
 5b0:	fff5c703          	lbu	a4,-1(a1)
 5b4:	fee78fa3          	sb	a4,-1(a5)
 5b8:	fb75                	bnez	a4,5ac <strcpy+0x8>
    ;
  return os;
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret

00000000000005c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5c0:	1141                	addi	sp,sp,-16
 5c2:	e422                	sd	s0,8(sp)
 5c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 5c6:	00054783          	lbu	a5,0(a0)
 5ca:	cb91                	beqz	a5,5de <strcmp+0x1e>
 5cc:	0005c703          	lbu	a4,0(a1)
 5d0:	00f71763          	bne	a4,a5,5de <strcmp+0x1e>
    p++, q++;
 5d4:	0505                	addi	a0,a0,1
 5d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 5d8:	00054783          	lbu	a5,0(a0)
 5dc:	fbe5                	bnez	a5,5cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5de:	0005c503          	lbu	a0,0(a1)
}
 5e2:	40a7853b          	subw	a0,a5,a0
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	addi	sp,sp,16
 5ea:	8082                	ret

00000000000005ec <strlen>:

uint
strlen(const char *s)
{
 5ec:	1141                	addi	sp,sp,-16
 5ee:	e422                	sd	s0,8(sp)
 5f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5f2:	00054783          	lbu	a5,0(a0)
 5f6:	cf91                	beqz	a5,612 <strlen+0x26>
 5f8:	0505                	addi	a0,a0,1
 5fa:	87aa                	mv	a5,a0
 5fc:	4685                	li	a3,1
 5fe:	9e89                	subw	a3,a3,a0
 600:	00f6853b          	addw	a0,a3,a5
 604:	0785                	addi	a5,a5,1
 606:	fff7c703          	lbu	a4,-1(a5)
 60a:	fb7d                	bnez	a4,600 <strlen+0x14>
    ;
  return n;
}
 60c:	6422                	ld	s0,8(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret
  for(n = 0; s[n]; n++)
 612:	4501                	li	a0,0
 614:	bfe5                	j	60c <strlen+0x20>

0000000000000616 <memset>:

void*
memset(void *dst, int c, uint n)
{
 616:	1141                	addi	sp,sp,-16
 618:	e422                	sd	s0,8(sp)
 61a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 61c:	ca19                	beqz	a2,632 <memset+0x1c>
 61e:	87aa                	mv	a5,a0
 620:	1602                	slli	a2,a2,0x20
 622:	9201                	srli	a2,a2,0x20
 624:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 628:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 62c:	0785                	addi	a5,a5,1
 62e:	fee79de3          	bne	a5,a4,628 <memset+0x12>
  }
  return dst;
}
 632:	6422                	ld	s0,8(sp)
 634:	0141                	addi	sp,sp,16
 636:	8082                	ret

0000000000000638 <strchr>:

char*
strchr(const char *s, char c)
{
 638:	1141                	addi	sp,sp,-16
 63a:	e422                	sd	s0,8(sp)
 63c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 63e:	00054783          	lbu	a5,0(a0)
 642:	cb99                	beqz	a5,658 <strchr+0x20>
    if(*s == c)
 644:	00f58763          	beq	a1,a5,652 <strchr+0x1a>
  for(; *s; s++)
 648:	0505                	addi	a0,a0,1
 64a:	00054783          	lbu	a5,0(a0)
 64e:	fbfd                	bnez	a5,644 <strchr+0xc>
      return (char*)s;
  return 0;
 650:	4501                	li	a0,0
}
 652:	6422                	ld	s0,8(sp)
 654:	0141                	addi	sp,sp,16
 656:	8082                	ret
  return 0;
 658:	4501                	li	a0,0
 65a:	bfe5                	j	652 <strchr+0x1a>

000000000000065c <gets>:

char*
gets(char *buf, int max)
{
 65c:	711d                	addi	sp,sp,-96
 65e:	ec86                	sd	ra,88(sp)
 660:	e8a2                	sd	s0,80(sp)
 662:	e4a6                	sd	s1,72(sp)
 664:	e0ca                	sd	s2,64(sp)
 666:	fc4e                	sd	s3,56(sp)
 668:	f852                	sd	s4,48(sp)
 66a:	f456                	sd	s5,40(sp)
 66c:	f05a                	sd	s6,32(sp)
 66e:	ec5e                	sd	s7,24(sp)
 670:	1080                	addi	s0,sp,96
 672:	8baa                	mv	s7,a0
 674:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 676:	892a                	mv	s2,a0
 678:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 67a:	4aa9                	li	s5,10
 67c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 67e:	89a6                	mv	s3,s1
 680:	2485                	addiw	s1,s1,1
 682:	0344d663          	bge	s1,s4,6ae <gets+0x52>
    cc = read(0, &c, 1);
 686:	4605                	li	a2,1
 688:	faf40593          	addi	a1,s0,-81
 68c:	4501                	li	a0,0
 68e:	188000ef          	jal	ra,816 <read>
    if(cc < 1)
 692:	00a05e63          	blez	a0,6ae <gets+0x52>
    buf[i++] = c;
 696:	faf44783          	lbu	a5,-81(s0)
 69a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 69e:	01578763          	beq	a5,s5,6ac <gets+0x50>
 6a2:	0905                	addi	s2,s2,1
 6a4:	fd679de3          	bne	a5,s6,67e <gets+0x22>
  for(i=0; i+1 < max; ){
 6a8:	89a6                	mv	s3,s1
 6aa:	a011                	j	6ae <gets+0x52>
 6ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 6ae:	99de                	add	s3,s3,s7
 6b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 6b4:	855e                	mv	a0,s7
 6b6:	60e6                	ld	ra,88(sp)
 6b8:	6446                	ld	s0,80(sp)
 6ba:	64a6                	ld	s1,72(sp)
 6bc:	6906                	ld	s2,64(sp)
 6be:	79e2                	ld	s3,56(sp)
 6c0:	7a42                	ld	s4,48(sp)
 6c2:	7aa2                	ld	s5,40(sp)
 6c4:	7b02                	ld	s6,32(sp)
 6c6:	6be2                	ld	s7,24(sp)
 6c8:	6125                	addi	sp,sp,96
 6ca:	8082                	ret

00000000000006cc <stat>:

int
stat(const char *n, struct stat *st)
{
 6cc:	1101                	addi	sp,sp,-32
 6ce:	ec06                	sd	ra,24(sp)
 6d0:	e822                	sd	s0,16(sp)
 6d2:	e426                	sd	s1,8(sp)
 6d4:	e04a                	sd	s2,0(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6da:	4581                	li	a1,0
 6dc:	162000ef          	jal	ra,83e <open>
  if(fd < 0)
 6e0:	02054163          	bltz	a0,702 <stat+0x36>
 6e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6e6:	85ca                	mv	a1,s2
 6e8:	16e000ef          	jal	ra,856 <fstat>
 6ec:	892a                	mv	s2,a0
  close(fd);
 6ee:	8526                	mv	a0,s1
 6f0:	136000ef          	jal	ra,826 <close>
  return r;
}
 6f4:	854a                	mv	a0,s2
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	64a2                	ld	s1,8(sp)
 6fc:	6902                	ld	s2,0(sp)
 6fe:	6105                	addi	sp,sp,32
 700:	8082                	ret
    return -1;
 702:	597d                	li	s2,-1
 704:	bfc5                	j	6f4 <stat+0x28>

0000000000000706 <atoi>:

int
atoi(const char *s)
{
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 70c:	00054603          	lbu	a2,0(a0)
 710:	fd06079b          	addiw	a5,a2,-48
 714:	0ff7f793          	andi	a5,a5,255
 718:	4725                	li	a4,9
 71a:	02f76963          	bltu	a4,a5,74c <atoi+0x46>
 71e:	86aa                	mv	a3,a0
  n = 0;
 720:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 722:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 724:	0685                	addi	a3,a3,1
 726:	0025179b          	slliw	a5,a0,0x2
 72a:	9fa9                	addw	a5,a5,a0
 72c:	0017979b          	slliw	a5,a5,0x1
 730:	9fb1                	addw	a5,a5,a2
 732:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 736:	0006c603          	lbu	a2,0(a3)
 73a:	fd06071b          	addiw	a4,a2,-48
 73e:	0ff77713          	andi	a4,a4,255
 742:	fee5f1e3          	bgeu	a1,a4,724 <atoi+0x1e>
  return n;
}
 746:	6422                	ld	s0,8(sp)
 748:	0141                	addi	sp,sp,16
 74a:	8082                	ret
  n = 0;
 74c:	4501                	li	a0,0
 74e:	bfe5                	j	746 <atoi+0x40>

0000000000000750 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 750:	1141                	addi	sp,sp,-16
 752:	e422                	sd	s0,8(sp)
 754:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 756:	02b57463          	bgeu	a0,a1,77e <memmove+0x2e>
    while(n-- > 0)
 75a:	00c05f63          	blez	a2,778 <memmove+0x28>
 75e:	1602                	slli	a2,a2,0x20
 760:	9201                	srli	a2,a2,0x20
 762:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 766:	872a                	mv	a4,a0
      *dst++ = *src++;
 768:	0585                	addi	a1,a1,1
 76a:	0705                	addi	a4,a4,1
 76c:	fff5c683          	lbu	a3,-1(a1)
 770:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 774:	fee79ae3          	bne	a5,a4,768 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 778:	6422                	ld	s0,8(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret
    dst += n;
 77e:	00c50733          	add	a4,a0,a2
    src += n;
 782:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 784:	fec05ae3          	blez	a2,778 <memmove+0x28>
 788:	fff6079b          	addiw	a5,a2,-1
 78c:	1782                	slli	a5,a5,0x20
 78e:	9381                	srli	a5,a5,0x20
 790:	fff7c793          	not	a5,a5
 794:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 796:	15fd                	addi	a1,a1,-1
 798:	177d                	addi	a4,a4,-1
 79a:	0005c683          	lbu	a3,0(a1)
 79e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 7a2:	fee79ae3          	bne	a5,a4,796 <memmove+0x46>
 7a6:	bfc9                	j	778 <memmove+0x28>

00000000000007a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e422                	sd	s0,8(sp)
 7ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 7ae:	ca05                	beqz	a2,7de <memcmp+0x36>
 7b0:	fff6069b          	addiw	a3,a2,-1
 7b4:	1682                	slli	a3,a3,0x20
 7b6:	9281                	srli	a3,a3,0x20
 7b8:	0685                	addi	a3,a3,1
 7ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 7bc:	00054783          	lbu	a5,0(a0)
 7c0:	0005c703          	lbu	a4,0(a1)
 7c4:	00e79863          	bne	a5,a4,7d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7c8:	0505                	addi	a0,a0,1
    p2++;
 7ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 7cc:	fed518e3          	bne	a0,a3,7bc <memcmp+0x14>
  }
  return 0;
 7d0:	4501                	li	a0,0
 7d2:	a019                	j	7d8 <memcmp+0x30>
      return *p1 - *p2;
 7d4:	40e7853b          	subw	a0,a5,a4
}
 7d8:	6422                	ld	s0,8(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret
  return 0;
 7de:	4501                	li	a0,0
 7e0:	bfe5                	j	7d8 <memcmp+0x30>

00000000000007e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e406                	sd	ra,8(sp)
 7e6:	e022                	sd	s0,0(sp)
 7e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7ea:	f67ff0ef          	jal	ra,750 <memmove>
}
 7ee:	60a2                	ld	ra,8(sp)
 7f0:	6402                	ld	s0,0(sp)
 7f2:	0141                	addi	sp,sp,16
 7f4:	8082                	ret

00000000000007f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7f6:	4885                	li	a7,1
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 7fe:	4889                	li	a7,2
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <wait>:
.global wait
wait:
 li a7, SYS_wait
 806:	488d                	li	a7,3
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 80e:	4891                	li	a7,4
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <read>:
.global read
read:
 li a7, SYS_read
 816:	4895                	li	a7,5
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <write>:
.global write
write:
 li a7, SYS_write
 81e:	48c1                	li	a7,16
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <close>:
.global close
close:
 li a7, SYS_close
 826:	48d5                	li	a7,21
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <kill>:
.global kill
kill:
 li a7, SYS_kill
 82e:	4899                	li	a7,6
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <exec>:
.global exec
exec:
 li a7, SYS_exec
 836:	489d                	li	a7,7
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <open>:
.global open
open:
 li a7, SYS_open
 83e:	48bd                	li	a7,15
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 846:	48c5                	li	a7,17
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 84e:	48c9                	li	a7,18
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 856:	48a1                	li	a7,8
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <link>:
.global link
link:
 li a7, SYS_link
 85e:	48cd                	li	a7,19
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 866:	48d1                	li	a7,20
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 86e:	48a5                	li	a7,9
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <dup>:
.global dup
dup:
 li a7, SYS_dup
 876:	48a9                	li	a7,10
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 87e:	48ad                	li	a7,11
 ecall
 880:	00000073          	ecall
 ret
 884:	8082                	ret

0000000000000886 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 886:	48b1                	li	a7,12
 ecall
 888:	00000073          	ecall
 ret
 88c:	8082                	ret

000000000000088e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 88e:	48b5                	li	a7,13
 ecall
 890:	00000073          	ecall
 ret
 894:	8082                	ret

0000000000000896 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 896:	48b9                	li	a7,14
 ecall
 898:	00000073          	ecall
 ret
 89c:	8082                	ret

000000000000089e <lseek>:
.global lseek
lseek:
 li a7, SYS_lseek
 89e:	48d9                	li	a7,22
 ecall
 8a0:	00000073          	ecall
 ret
 8a4:	8082                	ret

00000000000008a6 <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 8a6:	48dd                	li	a7,23
 ecall
 8a8:	00000073          	ecall
 ret
 8ac:	8082                	ret

00000000000008ae <exit_qemu>:
.global exit_qemu
exit_qemu:
 li a7, SYS_exit_qemu
 8ae:	48e1                	li	a7,24
 ecall
 8b0:	00000073          	ecall
 ret
 8b4:	8082                	ret

00000000000008b6 <chmod>:
.global chmod
chmod:
 li a7, SYS_chmod
 8b6:	48e5                	li	a7,25
 ecall
 8b8:	00000073          	ecall
 ret
 8bc:	8082                	ret

00000000000008be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8be:	1101                	addi	sp,sp,-32
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	addi	s0,sp,32
 8c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8ca:	4605                	li	a2,1
 8cc:	fef40593          	addi	a1,s0,-17
 8d0:	f4fff0ef          	jal	ra,81e <write>
}
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6105                	addi	sp,sp,32
 8da:	8082                	ret

00000000000008dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	ec4e                	sd	s3,24(sp)
 8e8:	0080                	addi	s0,sp,64
 8ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8ec:	c299                	beqz	a3,8f2 <printint+0x16>
 8ee:	0805c663          	bltz	a1,97a <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8f2:	2581                	sext.w	a1,a1
  neg = 0;
 8f4:	4881                	li	a7,0
 8f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8fc:	2601                	sext.w	a2,a2
 8fe:	00001517          	auipc	a0,0x1
 902:	93a50513          	addi	a0,a0,-1734 # 1238 <digits>
 906:	883a                	mv	a6,a4
 908:	2705                	addiw	a4,a4,1
 90a:	02c5f7bb          	remuw	a5,a1,a2
 90e:	1782                	slli	a5,a5,0x20
 910:	9381                	srli	a5,a5,0x20
 912:	97aa                	add	a5,a5,a0
 914:	0007c783          	lbu	a5,0(a5)
 918:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 91c:	0005879b          	sext.w	a5,a1
 920:	02c5d5bb          	divuw	a1,a1,a2
 924:	0685                	addi	a3,a3,1
 926:	fec7f0e3          	bgeu	a5,a2,906 <printint+0x2a>
  if(neg)
 92a:	00088b63          	beqz	a7,940 <printint+0x64>
    buf[i++] = '-';
 92e:	fd040793          	addi	a5,s0,-48
 932:	973e                	add	a4,a4,a5
 934:	02d00793          	li	a5,45
 938:	fef70823          	sb	a5,-16(a4)
 93c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 940:	02e05663          	blez	a4,96c <printint+0x90>
 944:	fc040793          	addi	a5,s0,-64
 948:	00e78933          	add	s2,a5,a4
 94c:	fff78993          	addi	s3,a5,-1
 950:	99ba                	add	s3,s3,a4
 952:	377d                	addiw	a4,a4,-1
 954:	1702                	slli	a4,a4,0x20
 956:	9301                	srli	a4,a4,0x20
 958:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 95c:	fff94583          	lbu	a1,-1(s2)
 960:	8526                	mv	a0,s1
 962:	f5dff0ef          	jal	ra,8be <putc>
  while(--i >= 0)
 966:	197d                	addi	s2,s2,-1
 968:	ff391ae3          	bne	s2,s3,95c <printint+0x80>
}
 96c:	70e2                	ld	ra,56(sp)
 96e:	7442                	ld	s0,48(sp)
 970:	74a2                	ld	s1,40(sp)
 972:	7902                	ld	s2,32(sp)
 974:	69e2                	ld	s3,24(sp)
 976:	6121                	addi	sp,sp,64
 978:	8082                	ret
    x = -xx;
 97a:	40b005bb          	negw	a1,a1
    neg = 1;
 97e:	4885                	li	a7,1
    x = -xx;
 980:	bf9d                	j	8f6 <printint+0x1a>

0000000000000982 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 982:	7119                	addi	sp,sp,-128
 984:	fc86                	sd	ra,120(sp)
 986:	f8a2                	sd	s0,112(sp)
 988:	f4a6                	sd	s1,104(sp)
 98a:	f0ca                	sd	s2,96(sp)
 98c:	ecce                	sd	s3,88(sp)
 98e:	e8d2                	sd	s4,80(sp)
 990:	e4d6                	sd	s5,72(sp)
 992:	e0da                	sd	s6,64(sp)
 994:	fc5e                	sd	s7,56(sp)
 996:	f862                	sd	s8,48(sp)
 998:	f466                	sd	s9,40(sp)
 99a:	f06a                	sd	s10,32(sp)
 99c:	ec6e                	sd	s11,24(sp)
 99e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9a0:	0005c903          	lbu	s2,0(a1)
 9a4:	22090e63          	beqz	s2,be0 <vprintf+0x25e>
 9a8:	8b2a                	mv	s6,a0
 9aa:	8a2e                	mv	s4,a1
 9ac:	8bb2                	mv	s7,a2
  state = 0;
 9ae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 9b0:	4481                	li	s1,0
 9b2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9b4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9bc:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9c0:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c4:	00001c97          	auipc	s9,0x1
 9c8:	874c8c93          	addi	s9,s9,-1932 # 1238 <digits>
 9cc:	a005                	j	9ec <vprintf+0x6a>
        putc(fd, c0);
 9ce:	85ca                	mv	a1,s2
 9d0:	855a                	mv	a0,s6
 9d2:	eedff0ef          	jal	ra,8be <putc>
 9d6:	a019                	j	9dc <vprintf+0x5a>
    } else if(state == '%'){
 9d8:	03598263          	beq	s3,s5,9fc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 9dc:	2485                	addiw	s1,s1,1
 9de:	8726                	mv	a4,s1
 9e0:	009a07b3          	add	a5,s4,s1
 9e4:	0007c903          	lbu	s2,0(a5)
 9e8:	1e090c63          	beqz	s2,be0 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 9ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9f0:	fe0994e3          	bnez	s3,9d8 <vprintf+0x56>
      if(c0 == '%'){
 9f4:	fd579de3          	bne	a5,s5,9ce <vprintf+0x4c>
        state = '%';
 9f8:	89be                	mv	s3,a5
 9fa:	b7cd                	j	9dc <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 9fc:	cfa5                	beqz	a5,a74 <vprintf+0xf2>
 9fe:	00ea06b3          	add	a3,s4,a4
 a02:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a06:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a08:	c681                	beqz	a3,a10 <vprintf+0x8e>
 a0a:	9752                	add	a4,a4,s4
 a0c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a10:	03878a63          	beq	a5,s8,a44 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 a14:	05a78463          	beq	a5,s10,a5c <vprintf+0xda>
      } else if(c0 == 'u'){
 a18:	0db78763          	beq	a5,s11,ae6 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a1c:	07800713          	li	a4,120
 a20:	10e78963          	beq	a5,a4,b32 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a24:	07000713          	li	a4,112
 a28:	12e78e63          	beq	a5,a4,b64 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a2c:	07300713          	li	a4,115
 a30:	16e78b63          	beq	a5,a4,ba6 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a34:	05579063          	bne	a5,s5,a74 <vprintf+0xf2>
        putc(fd, '%');
 a38:	85d6                	mv	a1,s5
 a3a:	855a                	mv	a0,s6
 a3c:	e83ff0ef          	jal	ra,8be <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a40:	4981                	li	s3,0
 a42:	bf69                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 a44:	008b8913          	addi	s2,s7,8
 a48:	4685                	li	a3,1
 a4a:	4629                	li	a2,10
 a4c:	000ba583          	lw	a1,0(s7)
 a50:	855a                	mv	a0,s6
 a52:	e8bff0ef          	jal	ra,8dc <printint>
 a56:	8bca                	mv	s7,s2
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	b749                	j	9dc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 a5c:	03868663          	beq	a3,s8,a88 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a60:	05a68163          	beq	a3,s10,aa2 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 a64:	09b68d63          	beq	a3,s11,afe <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a68:	03a68f63          	beq	a3,s10,aa6 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 a6c:	07800793          	li	a5,120
 a70:	0cf68d63          	beq	a3,a5,b4a <vprintf+0x1c8>
        putc(fd, '%');
 a74:	85d6                	mv	a1,s5
 a76:	855a                	mv	a0,s6
 a78:	e47ff0ef          	jal	ra,8be <putc>
        putc(fd, c0);
 a7c:	85ca                	mv	a1,s2
 a7e:	855a                	mv	a0,s6
 a80:	e3fff0ef          	jal	ra,8be <putc>
      state = 0;
 a84:	4981                	li	s3,0
 a86:	bf99                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a88:	008b8913          	addi	s2,s7,8
 a8c:	4685                	li	a3,1
 a8e:	4629                	li	a2,10
 a90:	000ba583          	lw	a1,0(s7)
 a94:	855a                	mv	a0,s6
 a96:	e47ff0ef          	jal	ra,8dc <printint>
        i += 1;
 a9a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a9c:	8bca                	mv	s7,s2
      state = 0;
 a9e:	4981                	li	s3,0
        i += 1;
 aa0:	bf35                	j	9dc <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 aa2:	03860563          	beq	a2,s8,acc <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 aa6:	07b60963          	beq	a2,s11,b18 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 aaa:	07800793          	li	a5,120
 aae:	fcf613e3          	bne	a2,a5,a74 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ab2:	008b8913          	addi	s2,s7,8
 ab6:	4681                	li	a3,0
 ab8:	4641                	li	a2,16
 aba:	000ba583          	lw	a1,0(s7)
 abe:	855a                	mv	a0,s6
 ac0:	e1dff0ef          	jal	ra,8dc <printint>
        i += 2;
 ac4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 ac6:	8bca                	mv	s7,s2
      state = 0;
 ac8:	4981                	li	s3,0
        i += 2;
 aca:	bf09                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 acc:	008b8913          	addi	s2,s7,8
 ad0:	4685                	li	a3,1
 ad2:	4629                	li	a2,10
 ad4:	000ba583          	lw	a1,0(s7)
 ad8:	855a                	mv	a0,s6
 ada:	e03ff0ef          	jal	ra,8dc <printint>
        i += 2;
 ade:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 ae0:	8bca                	mv	s7,s2
      state = 0;
 ae2:	4981                	li	s3,0
        i += 2;
 ae4:	bde5                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 ae6:	008b8913          	addi	s2,s7,8
 aea:	4681                	li	a3,0
 aec:	4629                	li	a2,10
 aee:	000ba583          	lw	a1,0(s7)
 af2:	855a                	mv	a0,s6
 af4:	de9ff0ef          	jal	ra,8dc <printint>
 af8:	8bca                	mv	s7,s2
      state = 0;
 afa:	4981                	li	s3,0
 afc:	b5c5                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 afe:	008b8913          	addi	s2,s7,8
 b02:	4681                	li	a3,0
 b04:	4629                	li	a2,10
 b06:	000ba583          	lw	a1,0(s7)
 b0a:	855a                	mv	a0,s6
 b0c:	dd1ff0ef          	jal	ra,8dc <printint>
        i += 1;
 b10:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b12:	8bca                	mv	s7,s2
      state = 0;
 b14:	4981                	li	s3,0
        i += 1;
 b16:	b5d9                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b18:	008b8913          	addi	s2,s7,8
 b1c:	4681                	li	a3,0
 b1e:	4629                	li	a2,10
 b20:	000ba583          	lw	a1,0(s7)
 b24:	855a                	mv	a0,s6
 b26:	db7ff0ef          	jal	ra,8dc <printint>
        i += 2;
 b2a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b2c:	8bca                	mv	s7,s2
      state = 0;
 b2e:	4981                	li	s3,0
        i += 2;
 b30:	b575                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 b32:	008b8913          	addi	s2,s7,8
 b36:	4681                	li	a3,0
 b38:	4641                	li	a2,16
 b3a:	000ba583          	lw	a1,0(s7)
 b3e:	855a                	mv	a0,s6
 b40:	d9dff0ef          	jal	ra,8dc <printint>
 b44:	8bca                	mv	s7,s2
      state = 0;
 b46:	4981                	li	s3,0
 b48:	bd51                	j	9dc <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b4a:	008b8913          	addi	s2,s7,8
 b4e:	4681                	li	a3,0
 b50:	4641                	li	a2,16
 b52:	000ba583          	lw	a1,0(s7)
 b56:	855a                	mv	a0,s6
 b58:	d85ff0ef          	jal	ra,8dc <printint>
        i += 1;
 b5c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b5e:	8bca                	mv	s7,s2
      state = 0;
 b60:	4981                	li	s3,0
        i += 1;
 b62:	bdad                	j	9dc <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 b64:	008b8793          	addi	a5,s7,8
 b68:	f8f43423          	sd	a5,-120(s0)
 b6c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b70:	03000593          	li	a1,48
 b74:	855a                	mv	a0,s6
 b76:	d49ff0ef          	jal	ra,8be <putc>
  putc(fd, 'x');
 b7a:	07800593          	li	a1,120
 b7e:	855a                	mv	a0,s6
 b80:	d3fff0ef          	jal	ra,8be <putc>
 b84:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b86:	03c9d793          	srli	a5,s3,0x3c
 b8a:	97e6                	add	a5,a5,s9
 b8c:	0007c583          	lbu	a1,0(a5)
 b90:	855a                	mv	a0,s6
 b92:	d2dff0ef          	jal	ra,8be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b96:	0992                	slli	s3,s3,0x4
 b98:	397d                	addiw	s2,s2,-1
 b9a:	fe0916e3          	bnez	s2,b86 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 b9e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 ba2:	4981                	li	s3,0
 ba4:	bd25                	j	9dc <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 ba6:	008b8993          	addi	s3,s7,8
 baa:	000bb903          	ld	s2,0(s7)
 bae:	00090f63          	beqz	s2,bcc <vprintf+0x24a>
        for(; *s; s++)
 bb2:	00094583          	lbu	a1,0(s2)
 bb6:	c195                	beqz	a1,bda <vprintf+0x258>
          putc(fd, *s);
 bb8:	855a                	mv	a0,s6
 bba:	d05ff0ef          	jal	ra,8be <putc>
        for(; *s; s++)
 bbe:	0905                	addi	s2,s2,1
 bc0:	00094583          	lbu	a1,0(s2)
 bc4:	f9f5                	bnez	a1,bb8 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 bc6:	8bce                	mv	s7,s3
      state = 0;
 bc8:	4981                	li	s3,0
 bca:	bd09                	j	9dc <vprintf+0x5a>
          s = "(null)";
 bcc:	00000917          	auipc	s2,0x0
 bd0:	66490913          	addi	s2,s2,1636 # 1230 <malloc+0x54e>
        for(; *s; s++)
 bd4:	02800593          	li	a1,40
 bd8:	b7c5                	j	bb8 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 bda:	8bce                	mv	s7,s3
      state = 0;
 bdc:	4981                	li	s3,0
 bde:	bbfd                	j	9dc <vprintf+0x5a>
    }
  }
}
 be0:	70e6                	ld	ra,120(sp)
 be2:	7446                	ld	s0,112(sp)
 be4:	74a6                	ld	s1,104(sp)
 be6:	7906                	ld	s2,96(sp)
 be8:	69e6                	ld	s3,88(sp)
 bea:	6a46                	ld	s4,80(sp)
 bec:	6aa6                	ld	s5,72(sp)
 bee:	6b06                	ld	s6,64(sp)
 bf0:	7be2                	ld	s7,56(sp)
 bf2:	7c42                	ld	s8,48(sp)
 bf4:	7ca2                	ld	s9,40(sp)
 bf6:	7d02                	ld	s10,32(sp)
 bf8:	6de2                	ld	s11,24(sp)
 bfa:	6109                	addi	sp,sp,128
 bfc:	8082                	ret

0000000000000bfe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bfe:	715d                	addi	sp,sp,-80
 c00:	ec06                	sd	ra,24(sp)
 c02:	e822                	sd	s0,16(sp)
 c04:	1000                	addi	s0,sp,32
 c06:	e010                	sd	a2,0(s0)
 c08:	e414                	sd	a3,8(s0)
 c0a:	e818                	sd	a4,16(s0)
 c0c:	ec1c                	sd	a5,24(s0)
 c0e:	03043023          	sd	a6,32(s0)
 c12:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c16:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c1a:	8622                	mv	a2,s0
 c1c:	d67ff0ef          	jal	ra,982 <vprintf>
}
 c20:	60e2                	ld	ra,24(sp)
 c22:	6442                	ld	s0,16(sp)
 c24:	6161                	addi	sp,sp,80
 c26:	8082                	ret

0000000000000c28 <printf>:

void
printf(const char *fmt, ...)
{
 c28:	711d                	addi	sp,sp,-96
 c2a:	ec06                	sd	ra,24(sp)
 c2c:	e822                	sd	s0,16(sp)
 c2e:	1000                	addi	s0,sp,32
 c30:	e40c                	sd	a1,8(s0)
 c32:	e810                	sd	a2,16(s0)
 c34:	ec14                	sd	a3,24(s0)
 c36:	f018                	sd	a4,32(s0)
 c38:	f41c                	sd	a5,40(s0)
 c3a:	03043823          	sd	a6,48(s0)
 c3e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c42:	00840613          	addi	a2,s0,8
 c46:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c4a:	85aa                	mv	a1,a0
 c4c:	4505                	li	a0,1
 c4e:	d35ff0ef          	jal	ra,982 <vprintf>
}
 c52:	60e2                	ld	ra,24(sp)
 c54:	6442                	ld	s0,16(sp)
 c56:	6125                	addi	sp,sp,96
 c58:	8082                	ret

0000000000000c5a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c5a:	1141                	addi	sp,sp,-16
 c5c:	e422                	sd	s0,8(sp)
 c5e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c60:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c64:	00001797          	auipc	a5,0x1
 c68:	39c7b783          	ld	a5,924(a5) # 2000 <freep>
 c6c:	a805                	j	c9c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c6e:	4618                	lw	a4,8(a2)
 c70:	9db9                	addw	a1,a1,a4
 c72:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c76:	6398                	ld	a4,0(a5)
 c78:	6318                	ld	a4,0(a4)
 c7a:	fee53823          	sd	a4,-16(a0)
 c7e:	a091                	j	cc2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c80:	ff852703          	lw	a4,-8(a0)
 c84:	9e39                	addw	a2,a2,a4
 c86:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 c88:	ff053703          	ld	a4,-16(a0)
 c8c:	e398                	sd	a4,0(a5)
 c8e:	a099                	j	cd4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c90:	6398                	ld	a4,0(a5)
 c92:	00e7e463          	bltu	a5,a4,c9a <free+0x40>
 c96:	00e6ea63          	bltu	a3,a4,caa <free+0x50>
{
 c9a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c9c:	fed7fae3          	bgeu	a5,a3,c90 <free+0x36>
 ca0:	6398                	ld	a4,0(a5)
 ca2:	00e6e463          	bltu	a3,a4,caa <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ca6:	fee7eae3          	bltu	a5,a4,c9a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 caa:	ff852583          	lw	a1,-8(a0)
 cae:	6390                	ld	a2,0(a5)
 cb0:	02059713          	slli	a4,a1,0x20
 cb4:	9301                	srli	a4,a4,0x20
 cb6:	0712                	slli	a4,a4,0x4
 cb8:	9736                	add	a4,a4,a3
 cba:	fae60ae3          	beq	a2,a4,c6e <free+0x14>
    bp->s.ptr = p->s.ptr;
 cbe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 cc2:	4790                	lw	a2,8(a5)
 cc4:	02061713          	slli	a4,a2,0x20
 cc8:	9301                	srli	a4,a4,0x20
 cca:	0712                	slli	a4,a4,0x4
 ccc:	973e                	add	a4,a4,a5
 cce:	fae689e3          	beq	a3,a4,c80 <free+0x26>
  } else
    p->s.ptr = bp;
 cd2:	e394                	sd	a3,0(a5)
  freep = p;
 cd4:	00001717          	auipc	a4,0x1
 cd8:	32f73623          	sd	a5,812(a4) # 2000 <freep>
}
 cdc:	6422                	ld	s0,8(sp)
 cde:	0141                	addi	sp,sp,16
 ce0:	8082                	ret

0000000000000ce2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ce2:	7139                	addi	sp,sp,-64
 ce4:	fc06                	sd	ra,56(sp)
 ce6:	f822                	sd	s0,48(sp)
 ce8:	f426                	sd	s1,40(sp)
 cea:	f04a                	sd	s2,32(sp)
 cec:	ec4e                	sd	s3,24(sp)
 cee:	e852                	sd	s4,16(sp)
 cf0:	e456                	sd	s5,8(sp)
 cf2:	e05a                	sd	s6,0(sp)
 cf4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cf6:	02051493          	slli	s1,a0,0x20
 cfa:	9081                	srli	s1,s1,0x20
 cfc:	04bd                	addi	s1,s1,15
 cfe:	8091                	srli	s1,s1,0x4
 d00:	0014899b          	addiw	s3,s1,1
 d04:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d06:	00001517          	auipc	a0,0x1
 d0a:	2fa53503          	ld	a0,762(a0) # 2000 <freep>
 d0e:	c515                	beqz	a0,d3a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d12:	4798                	lw	a4,8(a5)
 d14:	02977f63          	bgeu	a4,s1,d52 <malloc+0x70>
 d18:	8a4e                	mv	s4,s3
 d1a:	0009871b          	sext.w	a4,s3
 d1e:	6685                	lui	a3,0x1
 d20:	00d77363          	bgeu	a4,a3,d26 <malloc+0x44>
 d24:	6a05                	lui	s4,0x1
 d26:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d2a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d2e:	00001917          	auipc	s2,0x1
 d32:	2d290913          	addi	s2,s2,722 # 2000 <freep>
  if(p == (char*)-1)
 d36:	5afd                	li	s5,-1
 d38:	a0bd                	j	da6 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 d3a:	00001797          	auipc	a5,0x1
 d3e:	2d678793          	addi	a5,a5,726 # 2010 <base>
 d42:	00001717          	auipc	a4,0x1
 d46:	2af73f23          	sd	a5,702(a4) # 2000 <freep>
 d4a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d4c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d50:	b7e1                	j	d18 <malloc+0x36>
      if(p->s.size == nunits)
 d52:	02e48b63          	beq	s1,a4,d88 <malloc+0xa6>
        p->s.size -= nunits;
 d56:	4137073b          	subw	a4,a4,s3
 d5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d5c:	1702                	slli	a4,a4,0x20
 d5e:	9301                	srli	a4,a4,0x20
 d60:	0712                	slli	a4,a4,0x4
 d62:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d64:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d68:	00001717          	auipc	a4,0x1
 d6c:	28a73c23          	sd	a0,664(a4) # 2000 <freep>
      return (void*)(p + 1);
 d70:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d74:	70e2                	ld	ra,56(sp)
 d76:	7442                	ld	s0,48(sp)
 d78:	74a2                	ld	s1,40(sp)
 d7a:	7902                	ld	s2,32(sp)
 d7c:	69e2                	ld	s3,24(sp)
 d7e:	6a42                	ld	s4,16(sp)
 d80:	6aa2                	ld	s5,8(sp)
 d82:	6b02                	ld	s6,0(sp)
 d84:	6121                	addi	sp,sp,64
 d86:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d88:	6398                	ld	a4,0(a5)
 d8a:	e118                	sd	a4,0(a0)
 d8c:	bff1                	j	d68 <malloc+0x86>
  hp->s.size = nu;
 d8e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d92:	0541                	addi	a0,a0,16
 d94:	ec7ff0ef          	jal	ra,c5a <free>
  return freep;
 d98:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d9c:	dd61                	beqz	a0,d74 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d9e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 da0:	4798                	lw	a4,8(a5)
 da2:	fa9778e3          	bgeu	a4,s1,d52 <malloc+0x70>
    if(p == freep)
 da6:	00093703          	ld	a4,0(s2)
 daa:	853e                	mv	a0,a5
 dac:	fef719e3          	bne	a4,a5,d9e <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 db0:	8552                	mv	a0,s4
 db2:	ad5ff0ef          	jal	ra,886 <sbrk>
  if(p == (char*)-1)
 db6:	fd551ce3          	bne	a0,s5,d8e <malloc+0xac>
        return 0;
 dba:	4501                	li	a0,0
 dbc:	bf65                	j	d74 <malloc+0x92>
