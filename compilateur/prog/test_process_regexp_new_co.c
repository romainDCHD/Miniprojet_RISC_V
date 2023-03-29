#include <stdio.h>
#include <stdlib.h>
#include "../include/pyas/regexp.h"
#include "../include/pyas/string.h"


int main (int argc, char *argv[]) { 
    string_t input;
    string_t name;
    regexp_t regexp;
    
    if (argc < 4) {
        printf("========== Description ==========\n");
        printf("Teste la fonction regexp_new.\n\n");
        printf("========== Syntaxe ==========\n");
        printf("%s regexp nb_char value_display\n", argv[0]);
        printf("regexp\t\tExpression régulière à interpréter\n");
        printf("nb_char\t\tNombre de caractères dans l'expression régulière\n");
        printf("value_display\tValeur de la char_group à afficher\n");
        return 1;
    }

    name = string_convert(argv[1]);
    input = string_convert(argv[2]);
    
    printf("Expression lu : ");
    string_print(input);
    printf("\n");
    for (int i = 0; i < string_length(input); i=i+1) {
        printf("[%d]\t%d\t'%c'\n", i, string_get(input)[i], string_get(input)[i]);
    }
    printf("Caractère à afficher : %d\n\n", atoi(argv[3]));

    regexp = regexp_new(name, input);

    if (regexp) regexp_print(regexp);
    else        printf("Erreur dans l'expression\n");

    regexp_free(regexp);
    
    return 0;
}