/*
EBNF                    C
====================    =============================================
Concaténation           Suite d’instructions
Alternative  (|)        if(...) { ...; return ...; }
Répétition   (*)        while (...) {...}
Répétition   (+)        if ( !... { return -1; }) + while (...) {...}
Option       ([...])    if ( ... {...} )
Non-terminal            fonction

*/

#include "list.h"
#include "lexem.h"
#include "../unitest/logging.h"

#define func_args list_t* lexems, string_t depth, char verbose, list_t* instructions, int* line_addr
#define args lexems, curr_depth, verbose, instructions, line_addr

#define upd_depth(name) \
    string_t curr_depth; \
    if (verbose) { \
        curr_depth.length = depth.length + string_convert(name).length + 1; \
        curr_depth.content = calloc(string_length(curr_depth), sizeof(char)); \
        for (int i = 0; i < string_length(depth); i=i+1) \
            string_get(curr_depth)[i] = string_get(depth)[i]; \
        string_get(curr_depth)[string_length(depth)] = '\\'; \
        for (int i = 0; name[i] != '\0'; i=i+1) \
            string_get(curr_depth)[i+string_length(depth)+1] = name[i]; \
        string_print(curr_depth); \
        printf("\t"); \
        if (!list_empty(*lexems)) lexem_print(list_first(*lexems)); \
        printf("\n"); \
    }

#define ret(code) \
    if (verbose) { \
        string_print(curr_depth); \
        if (!code) STYLE(stderr, COLOR_GREEN, STYLE_HIGH_INTENSITY_TEXT); \
        else       STYLE(stderr, COLOR_RED, STYLE_HIGH_INTENSITY_TEXT); \
        printf("\treturn\t%d\n", code); \
        STYLE_RESET(stderr); \
        string_free(&curr_depth); \
    } \
    return code;

#define chk_non_term(func) \
    if (func(args) == -1) { \
        ret(-1); \
    }

#define chk_term(term, ...) \
    if (next_lexem_is(lexems, term)) { \
        __VA_ARGS__; \
        lexem_advance(lexems); \
    } \
    else { \
        if (verbose) print_parse_error(term " attendu", lexems); \
        ret(-1); \
    }

#define chk_opt_non_term(func, ...) \
    l = *lexems; \
    if (func(args) == -1) { \
        *lexems = l; \
    } \
    else { \
        __VA_ARGS__; \
    }

/**
 * @brief Parse une liste de lexèmes
 * 
 * @param lexems Liste de lexemes à parser
 * @param verbose Afficher les détails du parsing
 * @return pyobj_t - Objet Python de type py_codeblock contenant les informations du code.
 *                  NULL si une erreur est survenue.
 */
// pyobj_t parse(list_t* lexems, char verbose);

/**
 * @brief Parse une expression arithmétique selon des règles EBNF
 * 
 * @param lexems Liste de lexem devant respecté cette règle
 * @return int - 0 si la liste de lexems respecte les règles, -1 sinon
 */
int parse_code(func_args);
int parse_code_line(func_args);
int parse_insn(func_args);
int parse_insn_regreg(func_args);
int parse_insn_imm(func_args);
int parse_insn_branch(func_args);
int parse_insn_load(func_args);
int parse_insn_store(func_args);
int parse_insn_jal(func_args);
int parse_insn_jalr(func_args);
int parse_insn_upper(func_args);
int parse_unsninsn(func_args);
int parse_unsninsn_j(func_args);
int parse_unsninsn_li(func_args);
int parse_unsninsn_mv(func_args);
int parse_unsninsn_ble(func_args);
int parse_eol(func_args);
