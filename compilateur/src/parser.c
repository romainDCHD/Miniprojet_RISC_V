/*
<code>        ::= <code-line> <eol> ( [<code-line>] <eol> )*
<code-line>   ::= <instruction> | {'label'}
<instruction> ::= <insn-regreg> | <insn-imm> | <insn-branch> | <insn-memory> | <insn-jal> | <insn-jalr> | <insn-upper>

<insn-regreg> ::= ({'insn::ADD'}  | {'insn::AND'}   | {'insn::SLL'}  | 
                   {'insn::SRL'}  | {'insn::OR'}    | {'insn::XOR'}  | 
                   {'insn::SLT'}  | {'insn::SLTU'}  | {'insn::SRA'}  | {'insn::SUB'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::register'}
<insn-imm>    ::= ({'insn::ADDI'} | {'insn::ANDI'}  | {'insn::SLLI'} | 
                   {'insn::SRLI'} | {'insn::ORI'}   | {'insn::XORI'} | 
                   {'insn::SLTI'} | {'insn::SLTIU'} | {'insn::SRAI'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'integer::dec'}
<insn-branch> ::= ({'insn::BEQ'}  | {'insn::BNE'}   | {'insn::BLT'}  | 
                   {'insn::BGE'}  | {'insn::BLTU'}  | {'insn::BGEU'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::label'}
<insn-memory> ::= ({'insn::LB'}   | {'insn::LH'}    | {'insn::LW'}   | 
                   {'insn::LBU'}  | {'insn::LHU'}   | {'insn::SB'}   | 
                   {'insn::SH'}   | {'insn::SW'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
<insn-jal>    ::= {'insn::JAL'}  {‘blank’} {'symbole::register'} {'comma'} {'label'}
<insn-jalr>   ::= {'insn::JALR'} {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'integer::dec'}
<insn-upper>  ::= ({'insn::LUI'} | {'insn::AUIPC'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'}

<eol>         ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*

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

// pyobj_t parse(list_t* lexems, char verbose) {
//     pyobj_t obj;
//     pyobj_new(&obj);
//     pyobj_set_codeblock(obj);

//     if (parse_pys(lexems, string_convert(""), obj->py.codeblock, verbose) == -1) {
//         pyobj_free(obj);
//         return NULL;
//     }

//     return obj;
// }

// <code> ::= [<code-line>] <eol> ( [<code-line>] <eol> )*
int parse_code(func_args) {
    upd_depth("code");

    chk_non_term(parse_code_line);
    chk_non_term(parse_eol);
    while (parse_code_line(args) == 0) {
        chk_non_term(parse_eol)
    }

    ret(0)
}

// <code-line> ::= <instruction> | {'label'}
int parse_code_line(func_args) {
    upd_depth("code-line");

    if (next_lexem_is(lexems, "label") || parse_insn(args) == 0) {
        if (next_lexem_is(lexems, "label"))
            lexem_advance(lexems);
        ret(0)
    }
    ret(-1)
}

// <instruction> ::= <insn-regreg> | <insn-imm> | <insn-branch> | <insn-memory> | <insn-jal> | <insn-jalr> | <insn-upper>
int parse_insn(func_args) {
    upd_depth("insn");

    list_t l;

    chk_opt_non_term(parse_insn_regreg, ret(0));
    chk_opt_non_term(parse_insn_imm, ret(0));
    chk_opt_non_term(parse_insn_branch, ret(0));
    chk_opt_non_term(parse_insn_memory, ret(0));
    chk_opt_non_term(parse_insn_jal, ret(0));
    chk_opt_non_term(parse_insn_jalr, ret(0));
    chk_opt_non_term(parse_insn_upper, ret(0));

    ret(-1)
}

// <insn-regreg> ::= ({'insn::ADD'}  | {'insn::AND'}   | {'insn::SLL'}  |
//                    {'insn::SRL'}  | {'insn::OR'}    | {'insn::XOR'}  |
//                    {'insn::SLT'}  | {'insn::SLTU'}  | {'insn::SRA'}  | {'insn::SUB'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::register'}
int parse_insn_regreg(func_args) {
    upd_depth("insn-regreg");

    list_t l = *lexems;                  // Backup la liste lexems
    if (next_lexem_is(lexems, "insn::ADD")  ||
        next_lexem_is(lexems, "insn::AND")  ||
        next_lexem_is(lexems, "insn::SLL")  ||
        next_lexem_is(lexems, "insn::SRL")  ||
        next_lexem_is(lexems, "insn::OR")   ||
        next_lexem_is(lexems, "insn::XOR")  ||
        next_lexem_is(lexems, "insn::SLT")  ||
        next_lexem_is(lexems, "insn::SLTU") ||
        next_lexem_is(lexems, "insn::SRA")  ||
        next_lexem_is(lexems, "insn::SUB")) {
            lexem_advance(lexems);
            chk_term("blank")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("symbole::register")
            ret(0)
    }

    ret(-1)
}

// <insn-imm> ::= ({'insn::ADDI'} | {'insn::ANDI'} | {'insn::SLLI'} |
//                 {'insn::SRLI'} | {'insn::ORI'} | {'insn::XORI'} |
//                 {'insn::SLTI'} | {'insn::SLTIU'} | {'insn::SRAI'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'integer::dec'}
int parse_insn_imm(func_args) {
    upd_depth("insn-imm");

    if (next_lexem_is(lexems, "insn::ADDI")  ||
        next_lexem_is(lexems, "insn::ANDI")  ||
        next_lexem_is(lexems, "insn::SLLI")  ||
        next_lexem_is(lexems, "insn::SRLI")  ||
        next_lexem_is(lexems, "insn::ORI")   ||
        next_lexem_is(lexems, "insn::XORI")  ||
        next_lexem_is(lexems, "insn::SLTI")  ||
        next_lexem_is(lexems, "insn::SLTIU") ||
        next_lexem_is(lexems, "insn::SRAI")) {
            lexem_advance(lexems);
            chk_term("blank")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("integer::dec")
            ret(0)
    }
    ret(-1)
}

// <insn-branch> ::= ({'insn::BEQ'} | {'insn::BNE'}  | {'insn::BLT'} | 
//                    {'insn::BGE'} | {'insn::BLTU'} | {'insn::BGEU'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::label'}
int parse_insn_branch(func_args) {
    upd_depth("insn-branch");

    if (next_lexem_is(lexems, "insn::BEQ")  ||
        next_lexem_is(lexems, "insn::BNE")  ||
        next_lexem_is(lexems, "insn::BLT")  ||
        next_lexem_is(lexems, "insn::BGE")  ||
        next_lexem_is(lexems, "insn::BLTU") ||
        next_lexem_is(lexems, "insn::BGEU")) {
            lexem_advance(lexems);
            chk_term("blank")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("symbole::label")
            ret(0)
    }
    
    ret(-1)
}

// <insn-memory> ::= ({'insn::LB'}  | {'insn::LH'}  | {'insn::LW'} | 
//                    {'insn::LBU'} | {'insn::LHU'} | {'insn::SB'} |
//                    {'insn::SH'}  | {'insn::SW'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
int parse_insn_memory(func_args) {
    upd_depth("insn-memory");

    if (next_lexem_is(lexems, "insn::LB")  ||
        next_lexem_is(lexems, "insn::LH")  ||
        next_lexem_is(lexems, "insn::LW")  ||
        next_lexem_is(lexems, "insn::LBU") ||
        next_lexem_is(lexems, "insn::LHU") ||
        next_lexem_is(lexems, "insn::SB")  ||
        next_lexem_is(lexems, "insn::SH")  ||
        next_lexem_is(lexems, "insn::SW")) {
            lexem_advance(lexems);
            chk_term("blank")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("integer::dec")
            chk_term("paren::left")
            chk_term("symbole::register")
            chk_term("paren::right")
            ret(0)
    }
    ret(-1)
}

// <insn-jal> ::= ({'insn::JAL'}) {‘blank’} {'symbole::register'} {'comma'} {'label'}
int parse_insn_jal(func_args) {
    upd_depth("insn-jal");

    chk_term("insn::JAL")
    chk_term("blank")
    chk_term("symbole::register")
    chk_term("comma")
    chk_term("symbole::label")

    ret(0)
}

// <insn-jalr> ::= ({'insn::JALR'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'integer::dec'}
int parse_insn_jalr(func_args) {
    upd_depth("insn-jalr");

    chk_term("insn::JALR")
    chk_term("blank")
    chk_term("symbole::register")
    chk_term("comma")
    chk_term("symbole::register")
    chk_term("comma")
    chk_term("integer::dec")

    ret(0)
}

// <insn-upper> ::= ({'insn::LUI'} | {'insn::AUIPC'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'}
int parse_insn_upper(func_args) {
    upd_depth("insn-upper");

    if (next_lexem_is(lexems, "insn::LUI") ||
        next_lexem_is(lexems, "insn::AUIPC")) {
            lexem_advance(lexems);
            chk_term("blank")
            chk_term("symbole::register")
            chk_term("comma")
            chk_term("integer::dec")
            ret(0)
    }
    ret(-1)
}

// <eol> ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*
int parse_eol(func_args) {
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
