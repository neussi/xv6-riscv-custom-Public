#include "kernel/types.h"
#include "user/user.h"

// Fonction pour afficher une ligne de séparation stylisée
void print_separator() {
    printf("\033[1;34m+=====================================================+\033[0m\n"); // Bordure bleue
}

// Fonction pour afficher un titre centré
void print_title(char *title) {
    int len = strlen(title);
    int padding = (50 - len) / 2; // 50 est la largeur du cadre
    printf("\033[1;34m||\033[0m");
    for (int i = 0; i < padding; i++) printf(" ");
    printf("\033[1;36m%s\033[0m", title); // Cyan pour le titre
    for (int i = 0; i < 50 - len - padding; i++) printf(" ");
    printf("\033[1;34m||\033[0m\n");
}

// Fonction pour afficher une option de menu avec alignement manuel
void print_option(int num, char *option) {
    printf("\033[1;34m||\033[0m \033[1;33m%d.\033[0m \033[1;32m%s\033[0m", num, option); // Jaune pour le numéro, vert pour l'option

    // Ajouter des espaces pour aligner le texte à droite
    int len = strlen(option);
    int spaces_to_add = 45 - len; // 45 est la largeur disponible pour l'option
    for (int i = 0; i < spaces_to_add; i++) printf(" ");

    printf("\033[1;34m||\033[0m\n"); // Fermer la ligne
}

// Fonction pour afficher le menu principal
void print_menu() {
    print_separator();
    print_title("XV6 Shell Menu");
    print_separator();
    print_option(1, "List Files (ls)");
    print_option(2, "List Files Detailed (ls -l)");
    print_option(3, "Create File (touch)");
    print_option(4, "Change Permissions (chmod)");
    print_option(5, "Run Script (source)");
    print_option(6, "Clear Screen (clear)");
    print_option(7, "Show Processes (ps)");
    print_option(8, "Create Directory (mkdir)");
    print_option(9, "Sort File Content (sort)");
    print_option(10, "Show File Head (head)");
    print_option(11, "Show File Tail (tail)");
    print_option(12, "Exit");
    print_separator();
}

// Fonction principale
int main() {
    char input[10];

    while (1) {
        print_menu();
        printf("\033[1;35mEnter your choice:\033[0m "); // Magenta pour la question
        gets(input, sizeof(input));

        int choice = atoi(input);

        switch (choice) {
            case 1:
                printf("\033[1;32mExecuting 'ls'...\033[0m\n"); // Vert pour le message d'exécution
                if (fork() == 0) {
                    char *args[] = {"ls", 0};
                    exec("ls", args);
                    exit(0);
                }
                wait(0);
                break;

            case 2:
                printf("\033[1;32mExecuting 'ls -l'...\033[0m\n");
                if (fork() == 0) {
                    char *args[] = {"ls", "-l", 0};
                    exec("ls", args);
                    exit(0);
                }
                wait(0);
                break;

            case 3:
                printf("\033[1;35mEnter file name:\033[0m "); // Magenta pour la question
                char filename[100];
                gets(filename, sizeof(filename));
                if (fork() == 0) {
                    char *args[] = {"touch", filename, 0};
                    exec("touch", args);
                    exit(0);
                }
                wait(0);
                break;

            case 4:
                printf("\033[1;35mEnter file name:\033[0m "); // Magenta pour la question
                char chmod_file[100];
                gets(chmod_file, sizeof(chmod_file));
                printf("\033[1;35mEnter mode (e.g., 755):\033[0m "); // Magenta pour la question
                char mode[10];
                gets(mode, sizeof(mode));
                if (fork() == 0) {
                    char *args[] = {"chmod", mode, chmod_file, 0};
                    exec("chmod", args);
                    exit(0);
                }
                wait(0);
                break;

            case 5:
                printf("\033[1;35mEnter script name:\033[0m "); // Magenta pour la question
                char script[100];
                gets(script, sizeof(script));
                if (fork() == 0) {
                    char *args[] = {"source", script, 0};
                    exec("source", args);
                    exit(0);
                }
                wait(0);
                break;

            case 6:
                if (fork() == 0) {
                    char *args[] = {"clear", 0};
                    exec("clear", args);
                    exit(0);
                }
                wait(0);
                break;

            case 7:
                printf("\033[1;32mExecuting 'ps'...\033[0m\n");
                if (fork() == 0) {
                    char *args[] = {"ps", 0};
                    exec("ps", args);
                    exit(0);
                }
                wait(0);
                break;

            case 8:
                printf("\033[1;35mEnter directory name:\033[0m "); // Magenta pour la question
                char dirname[100];
                gets(dirname, sizeof(dirname));
                if (fork() == 0) {
                    char *args[] = {"mkdir", dirname, 0};
                    exec("mkdir", args);
                    exit(0);
                }
                wait(0);
                break;

            case 9:
                printf("\033[1;35mEnter file name to sort:\033[0m "); // Magenta pour la question
                char sort_file[100];
                gets(sort_file, sizeof(sort_file));
                if (fork() == 0) {
                    char *args[] = {"sort", sort_file, 0};
                    exec("sort", args);
                    exit(0);
                }
                wait(0);
                break;

            case 10:
                printf("\033[1;35mEnter file name for head:\033[0m "); // Magenta pour la question
                char head_file[100];
                gets(head_file, sizeof(head_file));
                if (fork() == 0) {
                    char *args[] = {"head", head_file, 0};
                    exec("head", args);
                    exit(0);
                }
                wait(0);
                break;

            case 11:
                printf("\033[1;35mEnter file name for tail:\033[0m "); // Magenta pour la question
                char tail_file[100];
                gets(tail_file, sizeof(tail_file));
                if (fork() == 0) {
                    char *args[] = {"tail", tail_file, 0};
                    exec("tail", args);
                    exit(0);
                }
                wait(0);
                break;

            case 12:
                printf("\033[1;31mExiting...\033[0m\n"); // Rouge pour le message de sortie
                exit(0);

            default:
                printf("\033[1;31mInvalid choice. Please try again.\033[0m\n"); // Rouge pour l'erreur
                break;
        }

        printf("\n\033[1;35mPress Enter to continue...\033[0m"); // Magenta pour la question
        gets(input, sizeof(input));
    }

    exit(0);
}
