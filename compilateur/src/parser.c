/*
<code> ::= [<code-line>] <eol> ( [<code-line>] <eol> )*
<code-line> ::= (<instruction> | {'label'} | <blank-line>)
<instruction> ::= <insn-regreg> | <insn-imm> | <insn-branch> | <insn-memory> | <insn-jump>

<insn-regreg> ::= ({'insn::ADD'}  | {'insn::AND'}   | {'insn::SLL'}  | 
                   {'insn::SRL'}  | {'insn::OR'}    | {'insn::XOR'}  | 
                   {'insn::SLT'}  | {'insn::SLTU'}  | {'insn::SRA'}  | {'insn::SUB'}) {‘blank’} {'reg'} {'comma'} {'reg'} {'comma'} {'reg'}
<insn-imm>    ::= ({'insn::ADDI'} | {'insn::ANDI'}  | {'insn::SLLI'} | 
                   {'insn::SRLI'} | {'insn::ORI'}   | {'insn::XORI'} | 
                   {'insn::SLTI'} | {'insn::SLTIU'} | {'insn::SRAI'}) {‘blank’} {'reg'} {'comma'} {'reg'} {'comma'} {'imm'}
<insn-branch> ::= ({'insn::BEQ'}  | {'insn::BNE'}   | {'insn::BLT'}  | 
                   {'insn::BGE'}  | {'insn::BLTU'}  | {'insn::BGEU'}) {‘blank’} {'reg'} {'comma'} {'reg'} {'comma'} {'label'}
                   ---------------A VERIFIER-----------------
<insn-memory> ::= ({'insn::LB'}   | {'insn::LH'}    | {'insn::LW'}   | 
                   {'insn::LBU'}  | {'insn::LHU'}   | {'insn::SB'}   | 
                   {'insn::SH'}   | {'insn::SW'}) {‘blank’} {'reg'} {'comma'} {'imm'} {'paren::left'} {'reg'} {'paren::right'}

<eol> ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*



<arith-expr> ::= <term>     ( ({op::sum::plus} | {op::sum::minus}) <term>     )*
<term>       ::= <s-factor> ( ({op::prod::mul} | {op::prod::div})  <s-factor> )*
<s-factor>   ::= [{op::sum::plus} | {op::sum::minus}] <factor>
<factor>     ::= {number} | {identifier} | ( {paren::left} <arith-expr> {paren::right} )

<pys> ::= <eol>* <prologue> <code>
<prologue> ::= <set-directives> [<interned-strings>] <constants> <names> [<varnames> <freevars> <cellvars>]
<set-directives> ::= <set-version-pyvm> <set-flags> <set-filename> <set-name> [<set-source-size>] <set-stack-size> <set-arg-count> [set-kwonly-arg-count] [set-posonly-arg-count]
<set-version-pyvm> ::= {‘dir::set’} {‘blank’} {‘version_pyvm’} {‘blank’} {‘integer::dec’} <eol>
<set-flags> ::= {‘dir::set’} {‘blank’} {‘flags’} {‘blank’} {‘integer::hex’} <eol>
<set-filename> ::= {‘dir::set’} {‘blank’} {‘filename’} {‘blank’} {‘string’} <eol>
<set-name> ::= {‘dir::set’} {‘blank’} {‘name’} {‘blank’} {‘string’} <eol>
<set-source-size> ::= {‘dir::set’} {‘blank’} {‘source_size’} {‘blank’} {‘integer::dec’} <eol>
<set-stack-size> ::= {‘dir::set’} {‘blank’} {‘stack_size’} {‘blank’} {‘integer::dec’} <eol>
<set-arg-count> ::= {‘dir::set’} {‘blank’} {‘arg_count’} {‘blank’} {‘integer::dec’} <eol>
<set-kwonly-arg-count> ::= {‘dir::set’} {‘blank’} {‘kwonly_arg_count’} {‘blank’} {‘integer::dec’} <eol>
<set-posonly-arg-count> ::= {‘dir::set’} {‘blank’} {‘posonly_arg_count’} {‘blank’} {‘integer::dec’} <eol>
<interned-strings> ::= {‘dir::interned’} <eol> ( {‘string’} <eol> )*
<constants> ::= {‘dir::consts’} <eol> ( <constant> <eol> )*
<constant> ::= {‘integer’} | {‘float’} | {‘string’} | {‘pycst’} | <tuple>
<list> ::= {‘brack::left’} ({’blank’} <constant>)* [{’blank’}] {‘brack::right’}
<tuple> ::= {‘paren::left’} ({’blank’} <constant>)* [{’blank’}] {‘paren::right’}
<names> ::= {‘dir::names’} <eol> ( {‘string’} <eol> )*
<varnames> ::= {‘dir::varnames’} <eol> ( {‘string’} <eol> )*
<freevars> ::= {‘dir::freevars’} <eol> ( {‘string’} <eol> )*
<cellvars> ::= {‘dir::cellvars’} <eol> ( {‘string’} <eol> )*
<code> ::= {‘dir::text’} <eol> ( <assembly-line> <eol> )*
<assembly-line> ::= <insn> | <source-lineno> | <label>
<label> ::= {‘symbol’} [{‘blank’}] {‘colon’}
<source-lineno> ::= {‘dir::line’} {‘blank’} {‘integer::dec’}
<insn> ::= {‘insn::0’} | {‘insn::1’} ( {‘integer::dec’} | {‘symbol’} )
<eol> ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*

EBNF                    C
====================    =============================================
Concaténation           Suite d’instructions
Alternative  (|)        if(...) { ...; return ...; }
Répétition   (*)        while (...) {...}
Répétition   (+)        if ( !... { return -1; }) + while (...) {...}
Option       ([...])    if ( ... {...} )
Non-terminal            fonction

*/

#include <stdio.h>
#include <stdlib.h>
#include "../include/pyas/parser.h"
#include "../include/pyas/list.h"
#include "../include/pyas/lexem.h"
#include "../include/pyas/string.h"
#include "../include/pyas/pyobj.h"

pyobj_t parse(list_t* lexems, char verbose) {
    pyobj_t obj;
    pyobj_new(&obj);
    pyobj_set_codeblock(obj);

    if (parse_pys(lexems, string_convert(""), obj->py.codeblock, verbose) == -1) {
        pyobj_free(obj);
        return NULL;
    }

    return obj;
}

//<pys> ::= <eol>* <prologue> <code>
// CORRECTION <pys> ::= [<eol>] <prologue> <code>
int parse_pys(func_args) {
    upd_depth("pys");

    parse_eol(args);
    chk_non_term(parse_prologue)
    chk_non_term(parse_code)
    
    ret(-!list_empty(*lexems));           // Retourne 0 si on a pu parser tout le code
}

//<prologue> ::= <set-directives> <interned-strings> <constants> <names> [<varnames> <freevars> <cellvars>]
// CORRECTION <prologue> ::= <set-directives> [<interned-strings>] <constants> <names> [<varnames> <freevars> <cellvars>]
int parse_prologue(func_args) {
    list_t l;

    upd_depth("prologue")
    chk_non_term(parse_set_dir)
    chk_opt_non_term(parse_inter_str)
    chk_non_term(parse_constants)
    chk_non_term(parse_names)

    l = *lexems;
    if (parse_var_name(args) == 0) {
        chk_non_term(parse_freevars)
        chk_non_term(parse_cellvars)
    }
    else *lexems = l;

    ret(0)
}

// <set-directives> ::= <set-version-pyvm> <set-flags> <set-filename> <set-name> [<set-source-size>] <set-stack-size> <set-arg-count> [set-kwonly-arg-count] [set-posonly-arg-count]
int parse_set_dir(func_args) {
    list_t l;
    upd_depth("directive");

    chk_non_term(parse_set_ver_pyvm)
    chk_non_term(parse_set_flags)
    chk_non_term(parse_set_filename)
    chk_non_term(parse_set_name)
    chk_opt_non_term(parse_set_src_sze)
    chk_non_term(parse_set_stack_size)
    chk_non_term(parse_set_arg_cnt)
    chk_opt_non_term(parse_set_kwl_arg_cnt)
    chk_opt_non_term(parse_set_psl_arg_cnt)

    ret(0)
}

// <set-version-pyvm> ::= {‘dir::set’} {‘blank’} {‘version_pyvm’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_ver_pyvm(func_args) {
    upd_depth("set-version-pyvm")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("version_pyvm")
    chk_term("blank")
    chk_term("integer::dec", codeblock->version_pyvm = atoi(lexem_peek(lexems)->value))
    chk_non_term(parse_eol)

    ret(0)
}

// <set-flags> ::= {‘dir::set’} {‘blank’} {‘flags’} {‘blank’} {‘integer::hex’} <eol>
int parse_set_flags(func_args) {
    upd_depth("set-flags")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("flags")
    chk_term("blank")
    chk_term("integer::hex", codeblock->header.flags = strtol(lexem_peek(lexems)->value, NULL, 16))
    chk_non_term(parse_eol)

    ret(0)
}

// <set-filename> ::= {‘dir::set’} {‘blank’} {‘filename’} {‘blank’} {‘string’} <eol>
int parse_set_filename(func_args) {
    upd_depth("set-filename")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("filename")
    chk_term("blank")
    chk_term("string", 
        pyobj_new(&(codeblock->binary.trailer.filename));
        pyobj_set_string(codeblock->binary.trailer.filename, string_convert(lexem_peek(lexems)->value));
    )
    chk_non_term(parse_eol)

    ret(0)
}

// <set-name> ::= {‘dir::set’} {‘blank’} {‘name’} {‘blank’} {‘string’} <eol>
int parse_set_name(func_args) {
    upd_depth("set-name")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("name")
    chk_term("blank")
    chk_term("string",
        pyobj_new(&(codeblock->binary.trailer.name));
        pyobj_set_string(codeblock->binary.trailer.name, string_convert(lexem_peek(lexems)->value));
    )
    chk_non_term(parse_eol)

    ret(0)
}

// <set-source-size> ::= {‘dir::set’} {‘blank’} {‘source_size’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_src_sze(func_args) {
    upd_depth("set-source-size")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("source_size")
    chk_term("blank")
    chk_term("integer::dec",
        codeblock->binary.header.source_size = atoi(lexem_peek(lexems)->value);
    )
    chk_non_term(parse_eol)

    ret(0)
}

// <set-stack-size> ::= {‘dir::set’} {‘blank’} {‘stack_size’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_stack_size(func_args) {
    upd_depth("set-stack-size")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("stack_size")
    chk_term("blank")
    chk_term("integer::dec",
        codeblock->header.stack_size = atoi(lexem_peek(lexems)->value);
    )
    chk_non_term(parse_eol)

    ret(0)
}

// <set-arg-count> ::= {‘dir::set’} {‘blank’} {‘arg_count’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_arg_cnt(func_args) {
    upd_depth("set-arg-count")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("arg_count")
    chk_term("blank")
    chk_term("integer::dec",
        codeblock->header.arg_count = atoi(lexem_peek(lexems)->value);
    )
    chk_non_term(parse_eol)

    ret(0)
}

// <set-kwonly-arg-count> ::= {‘dir::set’} {‘blank’} {‘kwonly_arg_count’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_kwl_arg_cnt(func_args) {
    upd_depth("set-kwonly-arg-count")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("kwonly_arg_count")
    chk_term("blank")
    chk_term("integer::dec")
    chk_non_term(parse_eol)

    ret(0)
}

// <set-posonly-arg-count> ::= {‘dir::set’} {‘blank’} {‘posonly_arg_count’} {‘blank’} {‘integer::dec’} <eol>
int parse_set_psl_arg_cnt(func_args) {
    upd_depth("set-posonly-arg-count")

    chk_term("dir::set")
    chk_term("blank")
    chk_term("posonly_arg_count")
    chk_term("blank")
    chk_term("integer::dec")
    chk_non_term(parse_eol)

    ret(0)
}

// <interned-strings> ::= {‘dir::interned’} <eol> ( {‘string’} <eol> )*
int parse_inter_str(func_args) {
    upd_depth("interned-strings")

    chk_term("dir::interned")
    chk_non_term(parse_eol)

    list_t l = *lexems;                  // Backup la liste lexems
    int length = 0;                      // Longueur de la liste
    pyobj_t* value;                      // Tableau de chaîne de caractères
    // Récupère le nombre de chaines à interné
    while (next_lexem_is(lexems, "string")) {
        lexem_advance(lexems);
        chk_non_term(parse_eol)
        length = length + 1;
    }
    *lexems = l;                         // Restore la liste lexems
    pyobj_new(&(codeblock->binary.content.interned));
    value = calloc(length, sizeof(pyobj_t));

    // Récupère les chaines à interné
    int i = 0;
    while (next_lexem_is(lexems, "string")) {
        pyobj_new(&(value[i]));
        pyobj_set_string(value[i], string_convert(lexem_peek(lexems)->value));
        lexem_advance(lexems);
        chk_non_term(parse_eol)
        i = i + 1;
    }
    pyobj_set_list(codeblock->binary.content.interned, value, length);

    ret(0)
}

// <constants> ::= {‘dir::consts’} <eol> ( <constant> <eol> )*
int parse_constants(func_args) {
    upd_depth("constants")

    chk_term("dir::consts")
    chk_non_term(parse_eol)

    list_t l = *lexems;                  // Backup la liste lexems
    int length = 0;                      // Longueur de la liste
    pyobj_t* value;                      // Tableau de chaîne de caractères
    // Récupère le nombre de chaines à interné et vérifie si la syntaxe est correcte
    while (parse_constant(args) == 0) {
        chk_non_term(parse_eol)
        length = length + 1;
    }

    *lexems = l;                         // Restore la liste lexems
    pyobj_new(&(codeblock->binary.content.consts));
    value = calloc(length, sizeof(pyobj_t));

    // Récupère les constantes
    for (int i = 0; i < length; i=i+1) {
        if (next_lexem_is(lexems, "string")) {
            pyobj_new(&(value[i]));
            pyobj_set_string(value[i], string_convert(lexem_peek(lexems)->value));
            lexem_advance(lexems);
        } else if (next_lexem_is(lexems, "float")) {
            pyobj_new(&(value[i]));
            pyobj_set_float(value[i], atof(lexem_peek(lexems)->value));
            lexem_advance(lexems);
        } else if (next_lexem_is(lexems, "integer")) {
            pyobj_new(&(value[i]));
            pyobj_set_int(value[i], atoi(lexem_peek(lexems)->value));
            lexem_advance(lexems);
        } else if (next_lexem_is(lexems, "pycst")) {
            pyobj_new(&(value[i]));
            if (next_lexem_is(lexems, "pycst::Null" )) pyobj_set_constant(value[i], CST_NULL );
            if (next_lexem_is(lexems, "pycst::True" )) pyobj_set_constant(value[i], CST_TRUE );
            if (next_lexem_is(lexems, "pycst::False")) pyobj_set_constant(value[i], CST_FALSE);
            if (next_lexem_is(lexems, "pycst::None" )) pyobj_set_constant(value[i], CST_NONE );
            lexem_advance(lexems);
        }
        else {
            // A AJOUTER PLUS TARD LES TUPLES
            chk_non_term(parse_tuple)
        }
        chk_non_term(parse_eol)
    }
    pyobj_set_list(codeblock->binary.content.consts, value, length);

    ret(0)
}

// <constant> ::= {‘integer’} | {‘float’} | {‘string’} | {‘pycst’} | <tuple>
int parse_constant(func_args) {
    upd_depth("constant")
    
    if (next_lexem_is(lexems, "integer") || next_lexem_is(lexems, "float") || 
        next_lexem_is(lexems, "string")  || next_lexem_is(lexems, "pycst")) {
        lexem_advance(lexems);
        ret(0)
    }

    chk_non_term(parse_tuple)

    ret(0)
}

// <list> ::= {‘brack::left’} ({’blank’} <constant>)* [{’blank’}] {‘brack::right’}
int parse_list(func_args) {
    upd_depth("list")

    chk_term("brack::left")
    while (next_lexem_is(lexems, "blank")) {
        lexem_advance(lexems);
        chk_non_term(parse_constant)
    }
    if (next_lexem_is(lexems, "blank")) 
        lexem_advance(lexems);
    chk_term("brack::right")

    ret(0)
}

// <tuple> ::= {‘paren::left’} ({’blank’} <constant>)* [{’blank’}] {‘paren::right’}
int parse_tuple(func_args) {
    upd_depth("tuple")

    chk_term("paren::left")
    while (next_lexem_is(lexems, "blank")) {
        lexem_advance(lexems);
        chk_non_term(parse_constant)
    }
    if (next_lexem_is(lexems, "blank")) 
        lexem_advance(lexems);
    chk_term("paren::right")

    ret(0)
}

// <names> ::= {‘dir::names’} <eol> ( {‘string’} <eol> )*
int parse_names(func_args) {
    upd_depth("names")

    chk_term("dir::names")
    chk_non_term(parse_eol)

    list_t l = *lexems;                  // Backup la liste lexems
    int length = 0;                      // Longueur de la liste
    pyobj_t* value;                      // Tableau de chaîne de caractères
    // Récupère le nombre de string et vérifie si la syntaxe est correcte
    while (next_lexem_is(lexems, "string")) {
        lexem_advance(lexems);
        chk_non_term(parse_eol)
        length = length + 1;
    }

    *lexems = l;                         // Restore la liste lexems
    pyobj_new(&(codeblock->binary.content.names));
    value = calloc(length, sizeof(pyobj_t));
    // Récupère les noms
    for (int i = 0; i < length; i=i+1) {
        pyobj_new(&(value[i]));
        pyobj_set_string(value[i], string_convert(lexem_peek(lexems)->value));
        lexem_advance(lexems);
        chk_non_term(parse_eol)
    }
    pyobj_set_list(codeblock->binary.content.names, value, length);

    ret(0)
}

// <varnames> ::= {‘dir::varnames’} <eol> ( {‘string’} <eol> )*
int parse_var_name(func_args) {
    upd_depth("varnames")

    chk_term("dir::varnames")
    chk_non_term(parse_eol)

    list_t l = *lexems;                  // Backup la liste lexems
    int length = 0;                      // Longueur de la liste
    pyobj_t* value;                      // Tableau de chaîne de caractères

    // Récupère le nombre de string et vérifie si la syntaxe est correcte
    while (next_lexem_is(lexems, "string")) {
        lexem_advance(lexems);
        chk_non_term(parse_eol)
        length = length + 1;
    }

    *lexems = l;                         // Restore la liste lexems
    pyobj_new(&(codeblock->binary.content.varnames));
    value = calloc(length, sizeof(pyobj_t));
    // Récupère les noms
    for (int i = 0; i < length; i=i+1) {
        pyobj_new(&(value[i]));
        pyobj_set_string(value[i], string_convert(lexem_peek(lexems)->value));
        lexem_advance(lexems);
        chk_non_term(parse_eol)
    }
    pyobj_set_list(codeblock->binary.content.varnames, value, length);

    ret(0)
}

// <freevars> ::= {‘dir::freevars’} <eol> ( {‘string’} <eol> )*
int parse_freevars(func_args) {
    upd_depth("freevars")

    chk_term("dir::freevars")
    chk_non_term(parse_eol)
    while (next_lexem_is(lexems, "string")) {
        lexem_advance(lexems);
        chk_non_term(parse_eol)
    }

    ret(0)
}

// <cellvars> ::= {‘dir::cellvars’} <eol> ( {‘string’} <eol> )*
int parse_cellvars(func_args) {
    upd_depth("cellvars")

    chk_term("dir::cellvars")
    chk_non_term(parse_eol)
    while (next_lexem_is(lexems, "string")) {
        lexem_advance(lexems);
        chk_non_term(parse_eol)
    }

    ret(0)
}

// <code> ::= {‘dir::text’} <eol> ( <assembly-line> <eol> )*
int parse_code(func_args) {
    upd_depth("code")

    chk_term("dir::text")
    chk_non_term(parse_eol)
    while (parse_ass_line(args) == 0) {
        chk_non_term(parse_eol)
    }

    ret(0)
}

// <assembly-line> ::= <insn> | <source-lineno> | <label>
int parse_ass_line(func_args) {
    upd_depth("assembly-line")

    if (parse_insn(args) == 0 || parse_src_lno(args) == 0 || parse_label(args) == 0) {
        ret(0)
    }

    ret(-1)
}

// <label> ::= {‘symbol’} {‘blank’} {‘colon’}
//CORRECTION <label> ::= {‘symbol’} [{‘blank’}] {‘colon’}
int parse_label(func_args) {
    codeblock++;                         // Pour se débarrasser des warnings
    upd_depth("label")

    chk_term("symbol")
    if (next_lexem_is(lexems, "blank")) 
        lexem_advance(lexems);
    chk_term("colon")

    ret(0)
}

// <source-lineno> ::= {‘dir::line’} {‘blank’} {‘integer::dec’}
int parse_src_lno(func_args) {
    codeblock++;                         // Pour se débarrasser des warnings
    upd_depth("source-lineno")

    chk_term("dir::line")
    chk_term("blank")
    chk_term("integer::dec")

    ret(0)
}

// <insn> ::= {‘insn::0’} | ( {‘insn::1’} {blank} ( {‘integer::dec’} | {‘symbol’} ) )
int parse_insn(func_args) {
    codeblock++;                         // Pour se débarrasser des warnings
    upd_depth("insn")

    if (next_lexem_is(lexems, "insn::0")) {
        lexem_advance(lexems);
        ret(0)
    }

    chk_term("insn::1")
    chk_term("blank")

    if (next_lexem_is(lexems, "integer::dec") || next_lexem_is(lexems, "symbol")) {
        lexem_advance(lexems);
        ret(0)
    }
    
    ret(-1)
}

// <eol> ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*
int parse_eol(func_args) {
    codeblock++;                         // Pour se débarrasser des warnings
    upd_depth("eol")

    while (next_lexem_is(lexems, "blank") || next_lexem_is(lexems, "comment") || next_lexem_is(lexems, "newline")) {
        if (next_lexem_is(lexems, "blank"))
            lexem_advance(lexems);
        if (next_lexem_is(lexems, "comment"))
            lexem_advance(lexems);
        chk_term("newline")
        if (next_lexem_is(lexems, "blank"))
            lexem_advance(lexems);
    }

    ret(0)
}

// Problème avec l'expression
//  2.5*x*x + 4 * b + 2*x) + 1.8/c 
/*
int parse_arith_expr(list_t* lexems) {
    printf("Parsing arithmetic expression\n");

    // Vérifie si un terme est bien écrit
    if (parse_term(lexems) == -1)
        return -1;

    // Vérifie si les 0 ou plus opérateurs et termes sont bien écrit
    while (next_lexem_is(lexems, "op::sum")) {
        lexem_advance (lexems);
        if (parse_term(lexems) == -1)
            return -1;
    }
    // L'expression est correcte si on est arrivé au bout de l'expression
    return 0;
}

int parse_term(list_t* lexems) {
    printf("Parsing term\n");

    // Vérifie si on a une somme de facteur
    if (parse_s_factor(lexems) == -1)
        return -1;

    // Vérifie si les 0 ou plus opérateurs et facteurs sont bien écrit
    while (next_lexem_is(lexems, "op::prod")) {
        lexem_advance(lexems);
        if (parse_s_factor(lexems) == -1)
            return -1;
    }
    // L'expression est correcte
    return 0;
}

int parse_s_factor(list_t* lexems) {
    printf("Parsing s factors\n");

    // On vérifie s'il y a un + ou un - avant le facteur
    if (next_lexem_is(lexems, "op::sum"))
        lexem_advance(lexems);
    return parse_factor(lexems);
}

int parse_factor(list_t* lexems) {
    printf("Parsing factor\n");

    // Vérifie si on a un nombre ou un identifieur bien écrit
    if (next_lexem_is(lexems, "number") || next_lexem_is(lexems, "identifier")) {
        printf("* Found factor : ");
        lexem_print(lexem_peek(lexems));
        printf( "\n");
        lexem_advance(lexems);
        return 0;
    }
    
    // Vérifie si on a une parenthèse ouvrante
    if (next_lexem_is(lexems, "paren::left")) {
        lexem_advance(lexems);
        // Suivie d'une expression arithmétique
        if (parse_arith_expr(lexems) == -1)
            return -1;
        // Suivie d'une parenthèse fermante
        if (next_lexem_is(lexems, "paren::right")) {
            lexem_advance(lexems);
            return 0;
        }
        print_parse_error("Missing right parenthesis", lexems);
        return -1;
    }

    print_parse_error("Unexpected input", lexems);
    return -1;
}
*/
