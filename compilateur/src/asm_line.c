#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "../include/rv32ias/asm_line.h"
#include "../include/rv32ias/list.h"
#include "../include/rv32ias/string.h"

void* insn_new(insnset_t insn, insn_type_t type) {
    insn_t* new_insn = malloc(sizeof(insn_t));
    assert(new_insn);
    new_insn->insn = insn;
    new_insn->type = type;
    return new_insn;
}

int insn_free(void *insn) {
    free(insn);
    return 0;
}

void init_insn_set(list_t *insn_set) {
    *insn_set = list_new();

    for (int i = 0; i < 38; i=i+1) {
        // NOP instruction
        if      (i == 0)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_NOP));
        // Register-register instructions
        else if (i < 11)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_REGREG));
        // Register-immediate instructions
        else if (i < 20)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_REGIMM));
        // Branch instructions
        else if (i < 26)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_BRANCH));
        // Upper immediate instructions
        else if (i == 26) list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_LUI));
        else if (i == 27) list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_AUIPC));
        // Load instructions
        else if (i < 33)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_LOAD));
        // Store instructions
        else if (i < 36)  list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_STORE));
        // Jump instructions
        else if (i == 36) list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_JAL));
        else              list_add_last(*insn_set, insn_new((insnset_t)i, TYPE_JALR));
    }
}

insnset_t str2insnset(char *str) {
    int i = 0;

    if (strcmp(str, "insn::NOP"))   return i; else i++;
    if (strcmp(str, "insn::ADD"))   return i; else i++;
    if (strcmp(str, "insn::AND"))   return i; else i++;
    if (strcmp(str, "insn::SLL"))   return i; else i++;
    if (strcmp(str, "insn::SRL"))   return i; else i++;
    if (strcmp(str, "insn::OR"))    return i; else i++;
    if (strcmp(str, "insn::XOR"))   return i; else i++;
    if (strcmp(str, "insn::SLTU"))  return i; else i++;
    if (strcmp(str, "insn::SLT"))   return i; else i++;
    if (strcmp(str, "insn::SRA"))   return i; else i++;
    if (strcmp(str, "insn::SUB"))   return i; else i++;
    if (strcmp(str, "insn::ADDI"))  return i; else i++;
    if (strcmp(str, "insn::ANDI"))  return i; else i++;
    if (strcmp(str, "insn::SLLI"))  return i; else i++;
    if (strcmp(str, "insn::SRLI"))  return i; else i++;
    if (strcmp(str, "insn::ORI"))   return i; else i++;
    if (strcmp(str, "insn::XORI"))  return i; else i++;
    if (strcmp(str, "insn::SLTIU")) return i; else i++;
    if (strcmp(str, "insn::SLTI"))  return i; else i++;
    if (strcmp(str, "insn::SRAI"))  return i; else i++;
    if (strcmp(str, "insn::BEQ"))   return i; else i++;
    if (strcmp(str, "insn::BNE"))   return i; else i++;
    if (strcmp(str, "insn::BGEU"))  return i; else i++;
    if (strcmp(str, "insn::BGE"))   return i; else i++;
    if (strcmp(str, "insn::BLTU"))  return i; else i++;
    if (strcmp(str, "insn::BLT"))   return i; else i++;
    if (strcmp(str, "insn::LUI"))   return i; else i++;
    if (strcmp(str, "insn::AUIPC")) return i; else i++;
    if (strcmp(str, "insn::LBU"))   return i; else i++;
    if (strcmp(str, "insn::LHU"))   return i; else i++;
    if (strcmp(str, "insn::LB"))    return i; else i++;
    if (strcmp(str, "insn::LH"))    return i; else i++;
    if (strcmp(str, "insn::LW"))    return i; else i++;
    if (strcmp(str, "insn::SB"))    return i; else i++;
    if (strcmp(str, "insn::SW"))    return i; else i++;
    if (strcmp(str, "insn::SH"))    return i; else i++;
    if (strcmp(str, "insn::JAL"))   return i; else i++;
    if (strcmp(str, "insn::JALR"))  return i; else i++;
}

reg_t str2reg(char *str) {
    int i = 0;

    if (strcmp(str, "r0") || strcmp(str, "zero"))
                            return i; else i++;
    if (strcmp(str, "r1") || strcmp(str, "ra"))
                            return i; else i++;
    if (strcmp(str, "r2") || strcmp(str, "sp"))
                            return i; else i++;
    if (strcmp(str, "r3"))  return i; else i++;
    if (strcmp(str, "r4"))  return i; else i++;
    if (strcmp(str, "r5"))  return i; else i++;
    if (strcmp(str, "r6"))  return i; else i++;
    if (strcmp(str, "r7"))  return i; else i++;
    if (strcmp(str, "r8"))  return i; else i++;
    if (strcmp(str, "r9"))  return i; else i++;
    if (strcmp(str, "r10")) return i; else i++;
    if (strcmp(str, "r11")) return i; else i++;
    if (strcmp(str, "r12")) return i; else i++;
    if (strcmp(str, "r13")) return i; else i++;
    if (strcmp(str, "r14")) return i; else i++;
    if (strcmp(str, "r15")) return i; else i++;
    if (strcmp(str, "r16")) return i; else i++;
    if (strcmp(str, "r17")) return i; else i++;
    if (strcmp(str, "r18")) return i; else i++;
    if (strcmp(str, "r19")) return i; else i++;
    if (strcmp(str, "r20")) return i; else i++;
    if (strcmp(str, "r21")) return i; else i++;
    if (strcmp(str, "r22")) return i; else i++;
    if (strcmp(str, "r23")) return i; else i++;
    if (strcmp(str, "r24")) return i; else i++;
    if (strcmp(str, "r25")) return i; else i++;
    if (strcmp(str, "r26")) return i; else i++;
    if (strcmp(str, "r27")) return i; else i++;
    if (strcmp(str, "r28")) return i; else i++;
    if (strcmp(str, "r29")) return i; else i++;
    if (strcmp(str, "r30")) return i; else i++;
    if (strcmp(str, "r31")) return i; else i++;
}

void* asm_line_regreg_new(insn_t insn, reg_t rd, reg_t rs1, reg_t rs2) {
    asm_line_t* line = malloc(sizeof(asm_line_t));
    assert(line);
    line->insn = insn;
    line->rd = rd;
    line->rs1 = rs1;
    line->rs2 = rs2;
    return line;
}