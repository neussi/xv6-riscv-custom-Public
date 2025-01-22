#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int i;

    // Si aucun argument n'est passé, affiche une nouvelle ligne
    if (argc < 2) {
        printf("\n");
        exit(0);
    }

    // Affiche tous les arguments, en ignorant les guillemets
    for (i = 1; i < argc; i++) {
        if (argv[i][0] == '"' && argv[i][strlen(argv[i]) - 1] == '"') {
            // Supprime les guillemets
            argv[i][strlen(argv[i]) - 1] = '\0';
            printf("%s", argv[i] + 1);
        } else {
            printf("%s", argv[i]);
        }
        if (i < argc - 1) {
            printf(" ");
        }
    }
    printf("\n");

    exit(0);
}
