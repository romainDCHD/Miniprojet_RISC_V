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
<insn-load>   ::= ({'insn::LB'}   | {'insn::LH'}    | {'insn::LW'}   | 
                   {'insn::LBU'}  | {'insn::LHU'}                   {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
<insn-store>  ::= ({'insn::SB'}   | {'insn::SH'}    | {'insn::SW'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
<insn-jal>    ::= {'insn::JAL'}  {‘blank’} {'symbole::register'} {'comma'} {'label'}
<insn-jalr>   ::= ({'insn::JALR'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::label'}
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
#include "../include/rv32ias/parser.h"
#include "../include/rv32ias/list.h"
#include "../include/rv32ias/lexem.h"
#include "../include/rv32ias/string.h"
#include "../include/rv32ias/asm_line.h"

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

    if (list_empty(*lexems)) {ret( 0)}
    else                     {ret(-1)}

    ret(0)
}

// <code-line> ::= <instruction> | {'label'}
int parse_code_line(func_args) {
    upd_depth("code-line");

    if (next_lexem_is(lexems, "label") || parse_insn(args) == 0) {
        if (next_lexem_is(lexems, "label")) {
            asm_line_label_add(instructions, ((lexem_t)(list_first(*lexems)))->value, *line_addr);
            lexem_advance(lexems);
        }
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
    chk_opt_non_term(parse_insn_load, ret(0));
    chk_opt_non_term(parse_insn_store, ret(0));
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
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rd;
            chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            reg_t rs1;
            chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            reg_t rs2;
            chk_term("symbole::register", rs2 = str2reg(((lexem_t)(list_first(*lexems)))->value))

            asm_line_regreg_add(instructions, insn, rd, rs1, rs2, *line_addr);
            *line_addr = *line_addr + 4;

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
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rd;
            chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            reg_t rs1;
            chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            int imm;
            chk_term("integer::dec", imm = atoi(((lexem_t)(list_first(*lexems)))->value))

            asm_line_imm_add(instructions, insn, rd, rs1, imm, *line_addr);
            *line_addr = *line_addr + 4;

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
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rs1;
            chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            reg_t rs2;
            chk_term("symbole::register", rs2 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            char *label;
            chk_term("symbole::label", label = ((lexem_t)(list_first(*lexems)))->value)

            asm_line_branch_add(instructions, insn, rs1, rs2, label, *line_addr);
            *line_addr = *line_addr + 4;
            // Rajoute deux instructions NOP au cas où le saut est effectué
            asm_line_nop_add(instructions, *line_addr);
            *line_addr = *line_addr + 4;
            asm_line_nop_add(instructions, *line_addr);
            *line_addr = *line_addr + 4;

            ret(0)
    }
    
    ret(-1)
}

//<insn-load> ::= ({'insn::LB'}  | {'insn::LH'} | {'insn::LW'} | 
//                 {'insn::LBU'} | {'insn::LHU'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
int parse_insn_load(func_args) {
    upd_depth("insn-memory");

    if (next_lexem_is(lexems, "insn::LB")  ||
        next_lexem_is(lexems, "insn::LH")  ||
        next_lexem_is(lexems, "insn::LW")  ||
        next_lexem_is(lexems, "insn::LBU") ||
        next_lexem_is(lexems, "insn::LHU")) {
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rd;
            chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            int imm;
            chk_term("integer::dec", imm = atoi(((lexem_t)(list_first(*lexems)))->value))
            chk_term("paren::left")
            reg_t rs1;
            chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("paren::right")

            asm_line_memory_add(instructions, insn, rd, rs1, imm, *line_addr);
            *line_addr = *line_addr + 4;

            ret(0)
    }
    ret(-1)
}

// <insn-store> ::= ({'insn::SB'} | {'insn::SH'} | {'insn::SW'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'} {'paren::left'} {'symbole::register'} {'paren::right'}
int parse_insn_store(func_args) {
    upd_depth("insn-memory");

    if (next_lexem_is(lexems, "insn::SB")  ||
        next_lexem_is(lexems, "insn::SH")  ||
        next_lexem_is(lexems, "insn::SW")) {
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rs2;
            chk_term("symbole::register", rs2 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            int imm;
            chk_term("integer::dec", imm = atoi(((lexem_t)(list_first(*lexems)))->value))
            chk_term("paren::left")
            reg_t rs1;
            chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("paren::right")

            asm_line_memory_add(instructions, insn, rd, rs1, imm, *line_addr);
            *line_addr = *line_addr + 4;

            ret(0)
    }
    ret(-1)
}

// <insn-jal> ::= ({'insn::JAL'}) {‘blank’} {'symbole::register'} {'comma'} {'label'}
int parse_insn_jal(func_args) {
    upd_depth("insn-jal");

    insn_t insn;
    chk_term("insn::JAL", insn = str2insn(((lexem_t)(list_first(*lexems)))->type))
    chk_term("blank")
    reg_t rd;
    chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
    chk_term("comma")
    char *label;
    chk_term("symbole::label", label = ((lexem_t)(list_first(*lexems)))->value)

    asm_line_jal_add(instructions, insn, rd, label, *line_addr);
    *line_addr = *line_addr + 4;

    ret(0)
}

// <insn-jalr> ::= ({'insn::JALR'}) {‘blank’} {'symbole::register'} {'comma'} {'symbole::register'} {'comma'} {'symbole::label'}
int parse_insn_jalr(func_args) {
    upd_depth("insn-jalr");

    insn_t insn;
    chk_term("insn::JALR", insn = str2insn(((lexem_t)(list_first(*lexems)))->type))
    chk_term("blank")
    reg_t rd;
    chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
    chk_term("comma")
    reg_t rs1;
    chk_term("symbole::register", rs1 = str2reg(((lexem_t)(list_first(*lexems)))->value))
    chk_term("comma")
    char *label;
    chk_term("symbole::label", label = ((lexem_t)(list_first(*lexems)))->value)

    asm_line_jalr_add(instructions, insn, rd, rs1, label, *line_addr);
    *line_addr = *line_addr + 4;

    ret(0)
}

// <insn-upper> ::= ({'insn::LUI'} | {'insn::AUIPC'}) {‘blank’} {'symbole::register'} {'comma'} {'integer::dec'}
int parse_insn_upper(func_args) {
    upd_depth("insn-upper");

    if (next_lexem_is(lexems, "insn::LUI") ||
        next_lexem_is(lexems, "insn::AUIPC")) {
            insn_t insn = str2insn(((lexem_t)(list_first(*lexems)))->type);
            lexem_advance(lexems);
            chk_term("blank")
            reg_t rd;
            chk_term("symbole::register", rd = str2reg(((lexem_t)(list_first(*lexems)))->value))
            chk_term("comma")
            int imm;
            chk_term("integer::dec", imm = atoi(((lexem_t)(list_first(*lexems)))->value))

            asm_line_upper_add(instructions, insn, rd, imm, *line_addr);
            *line_addr = *line_addr + 4;

            ret(0)
    }
    ret(-1)
}

// <eol> ::= ([{‘blank’}] [{‘comment’}] {‘newline’} [{’blank’}])*
int parse_eol(func_args) {
    // Pour se débaraasser des warnings
    long l = (long)instructions;
    l = (long)line_addr;
    l = l + 1;
    upd_depth("eol")

    while (!list_empty(*lexems) && (next_lexem_is(lexems, "blank") || next_lexem_is(lexems, "comment") || next_lexem_is(lexems, "newline"))) {
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
