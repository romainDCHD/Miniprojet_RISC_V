#ifndef _ASM_LINE_H_
#define _ASM_LINE_H_

#include "../include/rv32ias/list.h"

#define R0_CODE   "00000"
#define R1_CODE   "00001"
#define R2_CODE   "00010"
#define R3_CODE   "00011"
#define R4_CODE   "00100"
#define R5_CODE   "00101"
#define R6_CODE   "00110"
#define R7_CODE   "00111"
#define R8_CODE   "01000"
#define R9_CODE   "01001"
#define R10_CODE  "01010"
#define R11_CODE  "01011"
#define R12_CODE  "01100"
#define R13_CODE  "01101"
#define R14_CODE  "01110"
#define R15_CODE  "01111"
#define R16_CODE  "10000"
#define R17_CODE  "10001"
#define R18_CODE  "10010"
#define R19_CODE  "10011"
#define R20_CODE  "10100"
#define R21_CODE  "10101"
#define R22_CODE  "10110"
#define R23_CODE  "10111"
#define R24_CODE  "11000"
#define R25_CODE  "11001"
#define R26_CODE  "11010"
#define R27_CODE  "11011"
#define R28_CODE  "11100"
#define R29_CODE  "11101"
#define R30_CODE  "11110"
#define R31_CODE  "11111"

#define NOP_OPCODE    "0000000"
#define REGREG_OPCODE "0110011"
#define REGIMM_OPCODE "0010011"
#define LOAD_OPCODE   "0000011"
#define STORE_OPCODE  "0100011"
#define BRANCH_OPCODE "1100011"
#define JAL_OPCODE    "1101111"
#define JALR_OPCODE   "1100111"
#define LUI_OPCODE    "0110111"
#define AUIPC_OPCODE  "0010111"

#define ADDI_FUNCT3  "000"
#define ADD_FUNCT3   "000"
#define ADD_FUNCT7   "0000000"
#define ANDI_FUNCT3  "111"
#define AND_FUNCT3   "111"
#define AND_FUNCT7   "0000000"
#define BEQ_FUNCT3   "000"
#define SLLI_FUNCT3  "001"
#define SRLI_FUNCT3  "101"
#define SLL_FUNCT3   "001"
#define SLL_FUNCT7   "0000000"
#define SRL_FUNCT3   "101"
#define SRL_FUNCT7   "0000000"
#define ORI_FUNCT3   "110"
#define OR_FUNCT3    "110"
#define OR_FUNCT7    "0000000"
#define BNE_FUNCT3   "001"
#define XORI_FUNCT3  "100"
#define XOR_FUNCT3   "100"
#define XOR_FUNCT7   "0000000"
#define BGEU_FUNCT3  "011"
#define BGE_FUNCT3   "101"
#define SLTIU_FUNCT3 "011"
#define SLTI_FUNCT3  "010"
#define SLTU_FUNCT3  "011"
#define SLTU_FUNCT7  "0000000"
#define SLT_FUNCT3   "010"
#define SLT_FUNCT7   "0000000"
#define SRAI_FUNCT3  "101"
#define SRA_FUNCT3   "101"
#define SRA_FUNCT7   "0100000"

typedef enum {
    NOP,
    ADD,
    AND,
    SLL,
    SRL,
    OR,
    XOR,
    SLTU,
    SLT,
    SRA,
    SUB,
    ADDI, // 11
    ANDI,
    SLLI,
    SRLI,
    ORI,
    XORI,
    SLTIU,
    SLTI,
    SRAI,
    BEQ, // 20
    BNE,
    BGEU,
    BGE,
    BLTU,
    BLT,
    LUI, // 26
    AUIPC,
    LBU, // 28
    LHU,
    LB,
    LH,
    LW,
    SB, // 33
    SW,
    SH,
    JAL, // 36
    JALR
} insnset_t;

typedef enum {
    TYPE_NOP,
    TYPE_REGREG,
    TYPE_REGIMM,
    TYPE_LOAD,
    TYPE_STORE,
    TYPE_BRANCH,
    TYPE_JAL,
    TYPE_JALR,
    TYPE_LUI,
    TYPE_AUIPC
} insn_type_t;

typedef enum {
    R0,
    R1,
    R2,
    R3,
    R4,
    R5,
    R6,
    R7,
    R8,
    R9,
    R10,
    R11,
    R12,
    R13,
    R14,
    R15,
    R16,
    R17,
    R18,
    R19,
    R20,
    R21,
    R22,
    R23,
    R24,
    R25,
    R26,
    R27,
    R28,
    R29,
    R30,
    R31
} reg_t;

typedef struct {
    insnset_t insn;
    insn_type_t type;
} insn_t;

typedef struct {
    insn_t insn;
    reg_t rd;
    reg_t rs1;
    reg_t rs2;
    int imm;
} asm_line_t;

/**
 * @brief Retourne une nouvelle instruction
 * 
 * @param insn Nom de l'instruction
 * @param type Type de l'instruction
 * @param opcode Opcode de l'instruction
 * @return void* - Pointeur vers la nouvelle instruction
 */
void* insn_new(insnset_t insn, insn_type_t type);
/**
 * @brief Libère une instruction
 * 
 * @param insn Pointeur vers l'instruction à libérer
 * @return int - 0
 */
int insn_free(void *insn);
/**
 * @brief Initialise la liste des instructions
 * 
 * @param insn_set Liste à initialiser
 */
void init_insn_set(list_t *insn_set);
/**
 * @brief Convertie un nom de lexem en instruction
 * 
 * @param str Nom du lexem
 * @return insnset_t - Instruction correspondante
 */
insnset_t str2insnset(char *str);
/**
 * @brief Convertie une valeur de lexem en registre
 * 
 * @param str Valeur du lexem
 * @return reg_t - Registre correspondant
 */
reg_t str2reg(char *str);
/**
 * @brief Créer une nouvelle ligne assembleur du type REGISTER-REGISTER
 * 
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param rs1 Registre source 1
 * @param rs2 Registre source 2
 * @return void* 
 */
void* asm_line_regreg_new(insn_t insn, reg_t rd, reg_t rs1, reg_t rs2);
#endif