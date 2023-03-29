#include <stdio.h>
#include <stdlib.h>
#include "../include/pyas/char_group.h"
#include "../include/pyas/string.h"


int main (int argc, char *argv[]) { 
    string_t input;
    char_group group;
    
    if (argc < 3) {
        printf("========== Description ==========\n");
        printf("Teste la fonction process_char_group.\n\n");
        printf("========== Syntaxe ==========\n");
        printf("%s regexp value_display\n", argv[0]);
        printf("regexp\t\tExpression régulière à interpréter\n");
        printf("value_display\tValeur de la char_group à afficher\n");
        return -1;
    }

    input = string_convert(argv[1]);
    
    printf("Expression lu : ");
    string_print(input);
    printf("\nCaractère à afficher : %d\n\n", atoi(argv[2]));

    if (!process_char_group(input, &group)) {
        print_char_group(group, atoi(argv[2]));
    }
    else {
        printf("Erreur dans l'expression\n");
    }
    
    return 0;
}