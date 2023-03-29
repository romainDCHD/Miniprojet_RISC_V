/*
<arith-expr> ::= <term>     ( ({op::sum::plus} | {op::sum::minus}) <term>     )*
<term>       ::= <s-factor> ( ({op::prod::mul} | {op::prod::div})  <s-factor> )*
<s-factor>   ::= [{op::sum::plus} | {op::sum::minus}] <factor>
<factor>     ::= {number} | {identifier} | ( {paren::left} <arith-expr> {paren::right} )

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
#include "pyobj.h"

#define func_args list_t* lexems, string_t depth, py_codeblock* codeblock, char verbose
#define args lexems, curr_depth, codeblock, verbose

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
        printf("\treturn\t%d\n", code); \
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

#define chk_opt_non_term(func) \
    l = *lexems; \
    if (func(args) == -1) { \
        *lexems = l; \
    }

/**
 * @brief Parse une liste de lexèmes
 * 
 * @param lexems Liste de lexemes à parser
 * @param verbose Afficher les détails du parsing
 * @return pyobj_t - Objet Python de type py_codeblock contenant les informations du code.
 *                  NULL si une erreur est survenue.
 */
pyobj_t parse(list_t* lexems, char verbose);

/**
 * @brief Parse une expression arithmétique selon des règles EBNF
 * 
 * @param lexems Liste de lexem devant respecté cette règle
 * @return int - 0 si la liste de lexems respecte les règles, -1 sinon
 */
int parse_pys(func_args);
int parse_prologue(func_args);
int parse_set_dir(func_args);
int parse_set_ver_pyvm(func_args);
int parse_set_flags(func_args);
int parse_set_filename(func_args);
int parse_set_name(func_args);
int parse_set_src_sze(func_args);
int parse_set_stack_size(func_args);
int parse_set_arg_cnt(func_args);
int parse_set_kwl_arg_cnt(func_args);
int parse_set_psl_arg_cnt(func_args);
int parse_inter_str(func_args);
int parse_constants(func_args);
int parse_constant(func_args);
int parse_list(func_args);
int parse_tuple(func_args);
int parse_names(func_args);
int parse_var_name(func_args);
int parse_freevars(func_args);
int parse_cellvars(func_args);
int parse_code(func_args);
int parse_ass_line(func_args);
int parse_label(func_args);
int parse_src_lno(func_args);
int parse_insn(func_args);
int parse_eol(func_args);


// /**
//  * @brief Parse une expression arithmétique selon la règle EBNF
//  * <arith-expr> ::= <term> ( ({op::sum::plus} | {op::sum::minus}) <term> )*
//  * 
//  * @param lexems Liste de lexem devant respecté cette règle
//  * @return int - 0 si la liste de lexems respecte la règle, -1 sinon
//  */
// int parse_arith_expr(list_t* lexems);

// /**
//  * @brief Parse une expression arithmétique selon la règle EBNF
//  * <term> ::= <s-factor> ( ({op::prod::mul} | {op::prod::div})  <s-factor> )*
//  * 
//  * @param lexems Liste de lexem devant respecté cette règle
//  * @return int - 0 si la liste de lexems respecte la règle, -1 sinon
//  */
// int parse_term(list_t* lexems);

// /**
//  * @brief Parse une expression arithmétique selon la règle EBNF
//  * <s-factor> ::= [{op::sum::plus} | {op::sum::minus}] <factor>
//  * 
//  * @param lexems Liste de lexem devant respecté cette règle
//  * @return int - 0 si la liste de lexems respecte la règle, -1 sinon
//  */
// int parse_s_factor(list_t* lexems);

// /**
//  * @brief Parse une expression arithmétique selon la règle EBNF
//  * <factor> ::= {number} | {identifier} | ( {paren::left} <arith-expr> {paren::right} )
//  * @param lexems Liste de lexem devant respecté cette règle
//  * @return int - 0 si la liste de lexems respecte la règle, -1 sinon
//  */
// int parse_factor(list_t* lexems);
