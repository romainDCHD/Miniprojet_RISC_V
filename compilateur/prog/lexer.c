#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "../include/pyas/lexem.h"
#include "../include/pyas/regexp.h"
#include "../include/pyas/list.h"
#include "../include/pyas/string.h"

void print_lexem(lexem_t lex) {
    printf("[%s:%d:%d] %s ",
		lex->type,
		lex->line,
		lex->column-1,
		lex->value);
}

int main(int argc, char* argv[]) {

    if (argc < 3) {
        printf("========== Description ==========\n");
        printf("Extrait et affiches les lexems d'un code source.\n\n");
        printf("========== Syntaxe ==========\n");
        printf("%s regexps_file source_file\n", argv[0]);
        printf("regexps_file\tFichier contenant la syntaxe souhaitée\n");
        printf("source_file\tCode source à lire\n");
        return 0;
    }

    list_t regexps;
    list_t lexems;

    regexps = list_new();
    lexems  = list_new();
    
    regexps = regexp_read(argv[1]);
    
    if (lexem_read(argv[2], &lexems, regexps) == -1) {
        list_delete(regexps, regexp_free);
        list_delete(lexems, lexem_delete);
        exit(EXIT_FAILURE);
    }
    for (list_t l = lexems; !list_empty(l); l = list_next(l)) print_lexem(list_first(l));

    list_delete(regexps, regexp_free);
    list_delete(lexems, lexem_delete);

    return 0;
}
