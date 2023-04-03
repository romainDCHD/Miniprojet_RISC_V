#ifndef _ASM_LINE_H_
#define _ASM_LINE_H_

#include "list.h"
#include "string.h"

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
#define BGEU_FUNCT3  "111"
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
#define SUB_FUNCT3   "000"
#define SUB_FUNCT7   "0100000"
#define BLTU_FUNCT3  "110"
#define BLT_FUNCT3   "100"
#define LB_FUNCT3    "000"
#define LH_FUNCT3    "001"
#define LW_FUNCT3    "010"
#define LBU_FUNCT3   "100"
#define LHU_FUNCT3   "101"
#define SB_FUNCT3    "000"
#define SH_FUNCT3    "001"
#define SW_FUNCT3    "010"
#define JALR_FUNCT3  "000"

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
    TYPE_AUIPC,
    TYPE_UNDEF
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
    insnset_t insn;                    // Nom de l'instruction
    insn_type_t type;                  // Type de l'instruction
} insn_t;

typedef enum {
    INSN_LINE,
    LABEL_LINE
} line_type_t;

typedef struct {
    string_t name;                     // Nom du label
    int line_addr;                     // Adresse de la ligne
} label_t;

typedef struct {
    line_type_t type;                  // Type de la ligne
    union {
        label_t label;                 // Etiquette
        struct {
            insn_t insn;               // Instruction
            reg_t rd;                  // Registre de destination
            reg_t rs1;                 // Registre source 1
            reg_t rs2;                 // Registre source 2
            int imm;                   // Valeur immédiate
            string_t label;            // Nom du label ciblé
            int line_addr;             // Adresse de la ligne
        } insn_line;
    };
} asm_line_t;

/**
 * @brief Convertie une instruction simple en type instruction
 * 
 * @param insn_set Instruction à convertir
 * @return insn_t - Instruction convertie
 */
insn_t insnset2insn(insnset_t insn_set);
/**
 * @brief Convertie un nom de lexem en instruction
 * 
 * @param str Nom du lexem
 * @return insn_t - Instruction correspondante
 */
insn_t str2insn(char *str);
/**
 * @brief Convertie une valeur de lexem en registre
 * 
 * @param str Valeur du lexem
 * @return reg_t - Registre correspondant
 */
reg_t str2reg(char *str);
/**
 * @brief Convertie un registre en code assembleur
 * 
 * @param reg Registre à convertir
 * @return char* - Code assembleur correspondant
 */
char* reg2code(reg_t reg);
/**
 * @brief Renvoie un pointeur sur une nouvelle ligne assembleur initialisée
 * 
 * @return asm_line_t* - Pointeur sur la nouvelle ligne
 */
asm_line_t* asm_line_new();
/**
 * @brief Créer une nouvelle ligne assembleur du type REGISTER-IMMEDIATE et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param rs1 Registre source 1
 * @param rs2 Registre source 2
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_regreg_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, reg_t rs2, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type REGISTER-IMMEDIATE et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param rs1 Registre source 1
 * @param imm Valeur immédiate
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_imm_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, int imm, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type LOAD et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rs1 Registre source 1
 * @param rs2 Registre source 2
 * @param label Label de destination
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_branch_add(list_t* insn_list, insn_t insn, reg_t rs1, reg_t rs2, char* label, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type LOAD et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param rs1 Registre source 1
 * @param imm Valeur immédiate
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_load_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, int imm, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type STORE et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rs1 Registre source 1
 * @param rs2 Registre source 2
 * @param imm Valeur immédiate
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_store_add(list_t* insn_list, insn_t insn, reg_t rs1, reg_t rs2, int imm, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type JAL et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param label Label de destination
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_jal_add(list_t* insn_list, insn_t insn, reg_t rd, char* label, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type JALR et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param rs1 Registre source 1
 * @param imm Valeur immédiate
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_jalr_add(list_t* insn_list, insn_t insn, reg_t rd, reg_t rs1, char* label, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type LUI ou AUIPC et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param insn Code de l'instruction
 * @param rd Registre de destination
 * @param imm Valeur immédiate
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_upper_add(list_t* insn_list, insn_t insn, reg_t rd, int imm, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type LABEL et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param name Nom du label
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_label_add(list_t* insn_list, char* name, int line_addr);
/**
 * @brief Créer une nouvelle ligne assembleur du type NOP et l'ajoute à la liste d'instructions
 * 
 * @param insn_list Pointeur sur la liste où stocker l'instruction
 * @param line_addr Adresse de l'instruction dans le registre d'instructions
 */
void asm_line_nop_add(list_t* insn_list, int line_addr);
/**
 * @brief Met à jour les adresses des jumps et branches
 * 
 * @param insn_list Liste des instructions
 */
void asm_line_update_adress(list_t* insn_list);
/**
 * @brief Affiche un nombre binaire sur la sortie standard
 * 
 * @param n Nombre à afficher
 * @param size Taille du nombre en bits
 */
void print_binary(int n, int size);
/**
 * @brief Ecrit une ligne assembleur dans un fichier
 * 
 * @param asm_line Ligne assembleur à écrire
 * @param file Fichier dans lequel écrire
 */
void asm_line_write(list_t* insn_list/*, FILE* file*/);
/**
 * @brief Affiche une ligne assembleur
 * 
 * @param asm_line Ligne assembleur à afficher
 * @return int - 0
 */
int asm_line_print(void* asm_line);
/**
 * @brief Libère une ligne assembleur
 * 
 * @param asm_line Ligne assembleur à libérer
 * @return int - 0
 */
int asm_line_free(void* asm_line);
#endif