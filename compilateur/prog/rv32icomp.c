#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "../include/rv32ias/lexem.h"
#include "../include/rv32ias/regexp.h"
#include "../include/rv32ias/list.h"
#include "../include/rv32ias/string.h"
#include "../include/rv32ias/parser.h"
#include "../include/rv32ias/asm_line.h"
#include "../include/unitest/logging.h"

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("========== Description ==========\n");
        printf("Extrait et affiches les lexems d'un code source.\n\n");
        printf("========== Syntaxe ==========\n");
        printf("%s source_file regexps_file [-v]\n", argv[0]);
        printf("source_file\tCode source à lire\n");
        printf("regexps_file\tFichier contenant la syntaxe souhaitée\n");
        printf("-v\t\tAffiche la progression du parsing\n");
        return 0;
    }

    char verbose = (argc==4 && argv[3][0]=='-' && argv[3][1]=='v');

    list_t regexps;
    list_t lexems;

    regexps = list_new();
    lexems  = list_new();

    if (verbose) printf("\nLecture des expressions régulières : ");
    regexps = regexp_read(argv[2]);
    #ifdef __MINGW32__
    if (verbose) printf("%lld trouvée(s)\n\n", list_length(regexps));
    #else
    if (verbose) printf("%ld trouvée(s)\n\n", list_length(regexps));
    #endif
    // list_print(regexps, regexp_print);

    if (verbose) printf("Lecture des lexems : \n");
    lexem_read(argv[1], &lexems, regexps);
    list_delete(regexps, regexp_free);

    if (verbose)
        for (list_t l = lexems; !list_empty(l); l = list_next(l))
            lexem_print(list_first(l));

    if (verbose) printf("\n\nParsing des lexems : \n");

    list_t lex = lexems;                          // Sauvegarde du début de la liste pour pouvoir libérer la mémoire à la fin

    // Parsing des lexems
    list_t instructions = list_new();
    int addr = 0;
    if (parse_code(&lex, string_convert(""), verbose, &instructions, &addr) != 0) {
        STYLE(stderr, COLOR_RED, STYLE_BOLD);
        printf("Le parsing a échoué\n");
        if (!verbose) printf("Relancer le programme avec l'option -v pour plus d'information\n");
        STYLE_RESET(stderr);
        list_delete(lexems, lexem_delete);
        exit(EXIT_FAILURE);
    }

    if (verbose) {
        STYLE(stderr, COLOR_GREEN, STYLE_BOLD);
        printf("Aucune erreur dans l'expression !\n");
        STYLE_RESET(stderr);
        printf("\n\nMise à jours des adresses des jumps et des branchement : \n");
        asm_line_update_adress(&instructions);
        list_print(instructions, asm_line_print);
        printf("\n\nEcriture du code assembleur : \n");
    }

    // Ecriture du code assembleur
    printf("33222222222211111111110000000000\n");
    printf("10987654321098765432109876543210\n");
    asm_line_write(&instructions/*, argv[1]*/);
    
    list_delete(lexems, lexem_delete);
    list_delete(instructions, asm_line_free);
    

    return 0;
}

