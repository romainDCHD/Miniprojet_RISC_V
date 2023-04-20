#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "../include/rv32ias/asm_line.h"
#include "../include/rv32ias/list.h"
#include "../include/rv32ias/string.h"
#include "../include/unitest/logging.h"

insn_t insnset2insn(insnset_t insn_set) {
    insn_t insn;
    insn.insn = insn_set;

    if (insn_set < 0)        insn.type = TYPE_UNDEF;
    // NOP instruction
    if      (insn_set == 0)  insn.type = TYPE_NOP;
    // Register-register instructions
    else if (insn_set < 11)  insn.type = TYPE_REGREG;
    // Register-immediate instructions
    else if (insn_set < 20)  insn.type = TYPE_REGIMM;
    // Branch instructions
    else if (insn_set < 26)  insn.type = TYPE_BRANCH;
    // Upper immediate instructions
    else if (insn_set == 26) insn.type = TYPE_LUI;
    else if (insn_set == 27) insn.type = TYPE_AUIPC;
    // Load instructions
    else if (insn_set < 33)  insn.type = TYPE_LOAD;
    // Store instructions
    else if (insn_set < 36)  insn.type = TYPE_STORE;
    // Jump instructions
    else if (insn_set == 36) insn.type = TYPE_JAL;
    else                     insn.type = TYPE_JALR;
    return insn;
}

insn_t str2insn(char *str) {
    int i = 0;

    if (!strcmp(str, "insn::NOP"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::ADD"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::AND"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLL"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SRL"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::OR"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::XOR"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLTU"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLT"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SRA"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SUB"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::ADDI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::ANDI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLLI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SRLI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::ORI"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::XORI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLTIU")) return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SLTI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SRAI"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BEQ"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BNE"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BGEU"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BGE"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BLTU"))  return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::BLT"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LUI"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::AUIPC")) return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LBU"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LHU"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LB"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LH"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::LW"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SB"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SW"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::SH"))    return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::JAL"))   return insnset2insn(i); else i++;
    if (!strcmp(str, "insn::JALR"))  return insnset2insn(i); else i++;

    return insnset2insn(-1);
}

reg_t str2reg(char *str) {
    int i = 0;

    if (!strcmp(str, "r0") || !strcmp(str, "zero"))
                             return i; else i++;
    if (!strcmp(str, "r1") || !strcmp(str, "ra"))
                             return i; else i++;
    if (!strcmp(str, "r2") || !strcmp(str, "sp"))
                             return i; else i++;
    if (!strcmp(str, "r3"))  return i; else i++;
    if (!strcmp(str, "r4"))  return i; else i++;
    if (!strcmp(str, "r5"))  return i; else i++;
    if (!strcmp(str, "r6"))  return i; else i++;
    if (!strcmp(str, "r7"))  return i; else i++;
    if (!strcmp(str, "r8") || !strcmp(str, "s0")) 
                             return i; else i++;
    if (!strcmp(str, "r9") || !strcmp(str, "s1")) 
                             return i; else i++;
    if (!strcmp(str, "r10") || !strcmp(str, "a0"))
                             return i; else i++;
    if (!strcmp(str, "r11") || !strcmp(str, "a1"))
                             return i; else i++;
    if (!strcmp(str, "r12") || !strcmp(str, "a2"))
                             return i; else i++;
    if (!strcmp(str, "r13") || !strcmp(str, "a3"))
                             return i; else i++;
    if (!strcmp(str, "r14") || !strcmp(str, "a4"))
                             return i; else i++;
    if (!strcmp(str, "r15") || !strcmp(str, "a5"))
                             return i; else i++;
    if (!strcmp(str, "r16") || !strcmp(str, "a6"))
                             return i; else i++;
    if (!strcmp(str, "r17") || !strcmp(str, "a7"))
                             return i; else i++;
    if (!strcmp(str, "r18")) return i; else i++;
    if (!strcmp(str, "r19")) return i; else i++;
    if (!strcmp(str, "r20")) return i; else i++;
    if (!strcmp(str, "r21")) return i; else i++;
    if (!strcmp(str, "r22")) return i; else i++;
    if (!strcmp(str, "r23")) return i; else i++;
    if (!strcmp(str, "r24")) return i; else i++;
    if (!strcmp(str, "r25")) return i; else i++;
    if (!strcmp(str, "r26")) return i; else i++;
    if (!strcmp(str, "r27")) return i; else i++;
    if (!strcmp(str, "r28")) return i; else i++;
    if (!strcmp(str, "r29")) return i; else i++;
    if (!strcmp(str, "r30")) return i; else i++;
    if (!strcmp(str, "r31")) return i; else i++;

    return -1;
}

char* reg2code(reg_t reg) {
    switch (reg) {
        case R0 : return R0_CODE;
        case R1 : return R1_CODE;
        case R2 : return R2_CODE;
        case R3 : return R3_CODE;
        case R4 : return R4_CODE;
        case R5 : return R5_CODE;
        case R6 : return R6_CODE;
        case R7 : return R7_CODE;
        case R8 : return R8_CODE;
        case R9 : return R9_CODE;
        case R10: return R10_CODE;
        case R11: return R11_CODE;
        case R12: return R12_CODE;
        case R13: return R13_CODE;
        case R14: return R14_CODE;
        case R15: return R15_CODE;
        case R16: return R16_CODE;
        case R17: return R17_CODE;
        case R18: return R18_CODE;
        case R19: return R19_CODE;
        case R20: return R20_CODE;
        case R21: return R21_CODE;
        case R22: return R22_CODE;
        case R23: return R23_CODE;
        case R24: return R24_CODE;
        case R25: return R25_CODE;
        case R26: return R26_CODE;
        case R27: return R27_CODE;
        case R28: return R28_CODE;
        case R29: return R29_CODE;
        case R30: return R30_CODE;
        case R31: return R31_CODE;
        default: return NULL;
    }
}

asm_line_t* asm_line_new() {
    asm_line_t* line = malloc(sizeof(asm_line_t));
    assert(line);
    line->type = INSN_LINE;
    line->insn_line.insn.insn = NOP;
    line->insn_line.insn.type = TYPE_NOP;
    line->insn_line.rd = 0;
    line->insn_line.rs1 = 0;
    line->insn_line.rs2 = 0;
    line->insn_line.imm = 0;
    string_new(&(line->insn_line.label), "", 0);
    line->insn_line.line_addr = 0;
    return line;
}

void asm_line_regreg_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, reg_t rs2, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.rs1 = rs1;
    line->insn_line.rs2 = rs2;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_imm_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, int imm, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.rs1 = rs1;
    line->insn_line.imm = imm;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_branch_add(list_t* insn_list, insn_t insn, reg_t rs1, reg_t rs2, char* label, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rs1 = rs1;
    line->insn_line.rs2 = rs2;
    line->insn_line.label = string_convert(label);
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_load_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, int imm, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.rs1 = rs1;
    line->insn_line.imm = imm;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_store_add(list_t* insn_list, insn_t insn, reg_t rs1, reg_t rs2, int imm, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rs1 = rs1;
    line->insn_line.rs2 = rs2;
    line->insn_line.imm = imm;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_jal_add(list_t* insn_list, insn_t insn, reg_t rd, char* label, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.label = string_convert(label);
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_jalr_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, char* label, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.rs1 = rs1;
    line->insn_line.label = string_convert(label);
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_upper_add(list_t* insn_list, insn_t insn, reg_t rd, int imm, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    line->insn_line.insn = insn;
    line->insn_line.rd = rd;
    line->insn_line.imm = imm;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_label_add(list_t* insn_list, char* name, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = LABEL_LINE;
    line->label.name = string_convert(name);
    line->label.name.length = line->label.name.length - 1; // On enleve le : de la fin
    line->label.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

void asm_line_nop_add(list_t* insn_list, int line_addr) {
    asm_line_t* line = asm_line_new();
    line->type = INSN_LINE;
    insn_t insn_nop;
    insn_nop.insn = NOP;
    insn_nop.type = TYPE_NOP;
    line->insn_line.insn = insn_nop;
    line->insn_line.line_addr = line_addr;

    *insn_list = list_add_last(*insn_list, line);
}

int asm_line_update_adress(list_t* insn_list) {
    asm_line_t* line;
    int label_found = 0;
    // Cherche tous les instructions de banchement ou de sauft dans le code
    for (list_t l = *insn_list; !list_empty(l) ; l = list_next(l)) {
        label_found = 0;
        line = list_first(l);
        if (line->type == INSN_LINE && (
            line->insn_line.insn.type == TYPE_BRANCH ||
            line->insn_line.insn.type == TYPE_JAL    ||
            line->insn_line.insn.type == TYPE_JALR)) {
                // Cherche le label correspondant
                for (list_t l = *insn_list; !list_empty(l) ; l = list_next(l)) {
                    asm_line_t* line2 = list_first(l);
                    if (line2->type == LABEL_LINE && string_compare(line2->label.name, line->insn_line.label)) {
                        line->insn_line.imm = line2->label.line_addr - line->insn_line.line_addr;
                        label_found = 1;
                    }
                }
                if (!label_found) {
                    STYLE(stderr, COLOR_RED, STYLE_HIGH_INTENSITY_TEXT);
                    printf("Impossible de trouver le label \"");
                    string_print(line->insn_line.label);
                    printf("\".\n");
                    STYLE_RESET(stderr);
                    return -1;
                }
        }
    }
    return 0;
}

void print_binary(FILE* file, int n, int size) {
    int i;
    for (i = size - 1; i >= 0; i--) {
        int k = n >> i;
        if (k & 1)
            fprintf(file, "1");
        else
            fprintf(file, "0");
    }
}

int asm_line_write(list_t* insn_list, char* filename) {
    FILE* file = fopen(filename, "w");
    if (file == NULL) {
        STYLE(stderr, COLOR_RED, STYLE_HIGH_INTENSITY_TEXT);
        printf("Impossible d'ouvrir le fichier \"%s\".\n", filename);
        STYLE_RESET(stderr);
        return -1;
    }

    for (list_t l = *insn_list; !list_empty(l) ; l = list_next(l)) {
        asm_line_t* line = list_first(l);
        if (line->type == INSN_LINE) {
            switch (line->insn_line.insn.type) {
                case TYPE_NOP:
                    print_binary(file, 0, 32);                                          //31-0
                    fprintf(file, "\n");
                break;
                case TYPE_REGREG:
                    switch (line->insn_line.insn.insn) {
                        case ADD:
                            fprintf(file, "%s", ADD_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", ADD_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SUB:
                            fprintf(file, "%s", SUB_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SUB_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case AND:
                            fprintf(file, "%s", AND_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", AND_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case OR:
                            fprintf(file, "%s", OR_FUNCT7);                              // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", OR_FUNCT3);                              // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case XOR:
                            fprintf(file, "%s", XOR_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", XOR_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLL:
                            fprintf(file, "%s", SLL_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLL_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SRL:
                            fprintf(file, "%s", SRL_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SRL_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SRA:
                            fprintf(file, "%s", SRA_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SRA_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLT:
                            fprintf(file, "%s", SLT_FUNCT7);                             // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLT_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLTU:
                            fprintf(file, "%s", SLTU_FUNCT7);                            // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLTU_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        default:

                        break;
                    }
                    fprintf(file, "%s\n", REGREG_OPCODE);                                // 6-0
                break;
                case TYPE_REGIMM:
                    switch (line->insn_line.insn.insn) {
                        case ADDI:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", ADDI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case ANDI:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", ANDI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case ORI:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", ORI_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case XORI:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", XORI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLLI:
                            fprintf(file, "%s", SLLI_FUNCT7);                            // 31-25
                            print_binary(file, line->insn_line.imm, 5);                  // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLLI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SRLI:
                            fprintf(file, "%s", SRLI_FUNCT7);                            // 31-25
                            print_binary(file, line->insn_line.imm, 5);                  // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SRLI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SRAI:
                            fprintf(file, "%s", SRAI_FUNCT7);                            // 31-25
                            print_binary(file, line->insn_line.imm, 5);                  // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SRAI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLTI:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLTI_FUNCT3);                            // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case SLTIU:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SLTIU_FUNCT3);                           // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        default:

                        break;
                    }
                    fprintf(file, "%s\n", REGIMM_OPCODE);                                // 6-0
                break;
                case TYPE_BRANCH:
                    switch (line->insn_line.insn.insn) {
                        case BEQ:
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BEQ_FUNCT3);                             // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        case BNE:
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BNE_FUNCT3);                             // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        case BLT:
                            // fprintf(file, "%d\n", line->insn_line.imm);
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BLT_FUNCT3);                             // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        case BGE:
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BGE_FUNCT3);                             // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        case BLTU:
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BLTU_FUNCT3);                            // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        case BGEU:
                            fprintf(file, "%d", (line->insn_line.imm & 0x1000) >> 12);   // 31
                            print_binary(file, (line->insn_line.imm >> 5) & 0x3F, 6);   // 30-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", BGEU_FUNCT3);                            // 14-12
                            print_binary(file, line->insn_line.imm & 0x1E, 4);          // 11-8
                            fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);    // 7
                        break;
                        default:

                        break;
                    }
                    fprintf(file, "%s\n", BRANCH_OPCODE);                                // 6-0
                break;
                case TYPE_LOAD:
                    switch (line->insn_line.insn.insn) {
                        case LB:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", LB_FUNCT3);                              // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case LH:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", LH_FUNCT3);                              // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case LW:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", LW_FUNCT3);                              // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case LBU:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", LBU_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        case LHU:
                            print_binary(file, line->insn_line.imm, 12);                 // 31-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", LHU_FUNCT3);                             // 14-12
                            fprintf(file, "%s", reg2code(line->insn_line.rd));           // 11-7
                        break;
                        default:

                        break;
                    }
                    fprintf(file, "%s\n", LOAD_OPCODE);                                  // 6-0
                break;
                case TYPE_STORE:
                    switch (line->insn_line.insn.insn) {
                        case SB:
                            print_binary(file, (line->insn_line.imm >> 5), 7);           // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SB_FUNCT3);                              // 14-12
                            print_binary(file, line->insn_line.imm & 0x1F, 5);           // 11-7
                        break;
                        case SH:
                            print_binary(file, (line->insn_line.imm >> 5), 7);           // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SH_FUNCT3);                              // 14-12
                            print_binary(file, line->insn_line.imm & 0x1F, 5);           // 11-7
                        break;
                        case SW:
                            print_binary(file, (line->insn_line.imm >> 5), 7);           // 31-25
                            fprintf(file, "%s", reg2code(line->insn_line.rs2));          // 24-20
                            fprintf(file, "%s", reg2code(line->insn_line.rs1));          // 19-15
                            fprintf(file, "%s", SW_FUNCT3);                              // 14-12
                            print_binary(file, line->insn_line.imm & 0x1F, 5);           // 11-7
                        break;
                        default:

                        break;
                    }
                    fprintf(file, "%s\n", STORE_OPCODE);                                 // 6-0
                break;
                case TYPE_JAL:
                    fprintf(file, "%d", (line->insn_line.imm & 0x10000) >> 20);          // 31
                    print_binary(file, (line->insn_line.imm >> 1) & 0x3FF, 10);         // 30-21
                    fprintf(file, "%d", (line->insn_line.imm & 0x800) >> 11);            // 20
                    print_binary(file, (line->insn_line.imm >> 12) & 0xFF, 8);          // 19-12
                    fprintf(file, "%s", reg2code(line->insn_line.rd));                   // 11-7
                    fprintf(file, "%s\n", JAL_OPCODE);                                   // 6-0
                break;
                case TYPE_JALR:
                    print_binary(file, line->insn_line.imm, 12);                        // 31-20
                    fprintf(file, "%s", reg2code(line->insn_line.rs1));                  // 19-15
                    fprintf(file, "%s", JALR_FUNCT3);                                    // 14-12
                    fprintf(file, "%s", reg2code(line->insn_line.rd));                   // 11-7
                    fprintf(file, "%s\n", JALR_OPCODE);                                  // 6-0
                break;
                case TYPE_LUI:
                    print_binary(file, line->insn_line.imm, 20);                        // 31-12
                    fprintf(file, "%s", reg2code(line->insn_line.rd));                   // 11-7
                    fprintf(file, "%s\n", LUI_OPCODE);                                   // 6-0
                break;
                case TYPE_AUIPC:
                    print_binary(file, line->insn_line.imm >> 12, 20);                  // 31-12
                    fprintf(file, "%s", reg2code(line->insn_line.rd));                   // 11-7
                    fprintf(file, "%s\n", AUIPC_OPCODE);                                 // 6-0
                break;
                default:

                break;
            }
        }
    }

    fclose(file);

    return 0;
}

int asm_line_print(void* asm_line) {
    asm_line_t* line = (asm_line_t*)asm_line;
    printf("----------\n");
    printf("Type : %s", line->type == INSN_LINE ? "INSN_LINE\n" : "LABEL_LINE\n");
    if (line->type == INSN_LINE) {
        printf("Instruction : %d (%d)\n", line->insn_line.insn.insn, line->insn_line.insn.type);
        printf("Rd : %d\n", line->insn_line.rd);
        printf("Rs1 : %d\n", line->insn_line.rs1);
        printf("Rs2 : %d\n", line->insn_line.rs2);
        printf("Imm : %d\n", line->insn_line.imm);
        printf("Label : "); string_print(line->insn_line.label); printf("\n");
        printf("Address : %d\n", line->insn_line.line_addr);
    } else {
        printf("Label : "); string_print(line->label.name); printf("\n");
        printf("Address : %d\n", line->label.line_addr);
    }
    return 0;
}

int asm_line_free(void* asm_line) {
    free(asm_line);
    return 0;
}