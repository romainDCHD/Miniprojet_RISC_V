;#include <stdio.h>
;//#define DEBUG
;
;#ifdef DEBUG
;void print_binary(int n, int size) {
;    int i;
;    for (i = size - 1; i >= 0; i--) {
;        int k = n >> i;
;        if (k & 1)
;            printf("1");
;        else
;            printf("0");
;    }
;}
;#endif
;
;#define CHECK_VALUE(NOTES, VALUE, SIZE) \
;    printf(NOTES "\n"); \
;    print_binary(VALUE, SIZE); 
;
;#define VALUE1 0x0E
;#define VALUE2 0x0F
;#define VALUE3 0x01
;
;#define VALUE4 0xFFFE
;#define VALUE5 0x000F
;#define VALUE6 0x0000
;
;#define VALUE7 0xFFFFFFFE
;#define VALUE8 0x0F0F0F0F
;#define VALUE9 0x00000000
;
;#define RESET_VAR_VALUES \
;a = VALUE1; \
;b = VALUE2; \
;c = VALUE3; \
;d = VALUE4; \
;e = VALUE5; \
;f = VALUE6; \
;g = VALUE7; \
;h = VALUE8; \
;i = VALUE9;
;
;int main() {
;
;    //----- SB
;    // avec aussi ADDI
;    unsigned char  a = VALUE1;
;    unsigned char  b = VALUE2;
;    unsigned char  c = VALUE3;
;    // SH
;    unsigned short d = VALUE4;
;    unsigned short e = VALUE5;
;    unsigned short f = VALUE6;
;    // SW
;    unsigned int   g = VALUE7;
;    unsigned int   h = VALUE8;
;    unsigned int   i = VALUE9;
;
;    //----- ADD
;    // avec aussi LBU, SB, LW, SW
;    // Pas de test avec un overflow on 8 bit -> detecte par le compilateur
;    // c = a + b + c;
;    asm(
;        "lbu     a4,-17(s0)\n\t"      // a dans a4
;        "lbu     a5,-18(s0)\n\t"      // b dans a5
;        "lbu     a6,-19(s0)\n\t"      // c dans a6
;        "add     a4,a4,a5\n\t"        // a + b
;        "add     a6,a4,a6\n\t"        // (a + b) + c (dependance a gauche)
;        "add     a5,zero,a6\n\t"      // Dependance a droite
;        "sb      a5,-19(s0)\n\t"      // On ecrit c
;    );
;    
;    i = g + h;                        // Debordement
;
;    #ifdef DEBUG
;    CHECK_VALUE("c = a + b + c (ADD)", c, 8)
;    CHECK_VALUE("i = g + h (ADD debordement)", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- AND
;    // avec LW et SW
;    i = g & h;
;    #ifdef DEBUG
;    CHECK_VALUE("i = g & h (AND)", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SLL
;    // avec LHU et SH
;    f = d << e;
;    #ifdef DEBUG
;    CHECK_VALUE("f = d << e (SLL)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SRL
;    // avec LHU et SH
;    asm(                             //f = d >> e avec debordement
;        "lhu     a4,-22(s0)\n\t"
;        "lhu     a5,-24(s0)\n\t"
;        "srl     a5,a4,a5\n\t"
;        "sh      a5,-26(s0)\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("f = d >> e (SRL)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- OR
;    // avec LW et SW
;    i = g | h;
;    #ifdef DEBUG
;    CHECK_VALUE("i = g | h (OR)", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- XOR
;    // avec LW et SW
;    i = g ^ h;
;    #ifdef DEBUG
;    CHECK_VALUE("i = g ^ h (XOR)", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SLTU
;     // avec LBU, LHU, SB, SH et ANDI
;    c = a < b;                        // = 1
;    f = e < d;                        // = 0
;    #ifdef DEBUG
;    CHECK_VALUE("c = a < b (SLTU)", c, 8)
;    CHECK_VALUE("f = e < d (SLTU)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SLT
;    // avec LB, LH, SB, SH et ANDI
;    // c = a < b;
;    // f = d < e;
;    asm(
;        "lb      a4,-17(s0)\n\t"
;        "lb      a5,-18(s0)\n\t"
;        "slt     a5,a4,a5\n\t"
;        "andi    a5,a5,255\n\t"
;        "sb      a5,-19(s0)\n\t"
;        "lh      a4,-24(s0)\n\t"
;        "lh      a5,-22(s0)\n\t"
;        "slt     a5,a5,a4\n\t"
;        "andi    a5,a5,255\n\t"
;        "sh      a5,-26(s0)\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("c = a < b (SLT)", c, 8)
;    CHECK_VALUE("f = e < d (SLT)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SRA
;    // avec LHU et SH
;    f = d >> e;                      // Debordement
;    #ifdef DEBUG
;    CHECK_VALUE("f = d >> e (SRA)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SUB
;    // avec LB, LH, SB et SH
;    c = b - a;
;    f = e - d;                       // Debordement
;    #ifdef DEBUG
;    CHECK_VALUE("c = a - b (SUB)", c, 8)
;    CHECK_VALUE("f = e - d (SUB)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- ADDI --> Deja teste avec les LI
;    //----- ANDI --> Deja teste
;    //----- SLLI
;    // avec LHU, LBU, SB et SH
;    f = d << 5;                      // Debordement
;    c = a << 5;
;    #ifdef DEBUG
;    CHECK_VALUE("f = d << 5 (SLLI)", f, 16)
;    CHECK_VALUE("c = a << 5 (SLLI)", c, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SRLI
;    // avec LHU, LBU, SB et SH
;    //f = d >> 16;                      // Debordement
;    asm(
;        "lhu     a5,-28(s0)\n\t"
;        "srli    a5,a5,16\n\t"
;        "sh      a5,-32(s0)\n\t"
;    );
;    c = a >> 3;
;    #ifdef DEBUG
;    CHECK_VALUE("f = d >> 5 (SRLI)", f, 16)
;    CHECK_VALUE("c = a >> 5 (SRLI)", c, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- ORI
;    // avec LW et SW
;    asm(
;        "lw      a4,-32(s0)\n\t"       // Chargement de g
;        "lw      a5,-36(s0)\n\t"       // Chargement de h
;        "ori     a6,a4,252645135\n\t"  // i = i | VALUE8;
;        "ori     a7,a6,4294967294\n\t" // h = i | VALUE7;
;        "sw      a6,-40(s0)\n\t"       // Stockage de i
;        "sw      a7,-36(s0)\n\t"       // Stockage de h
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("i = g | VALUE8 (ORI)", i, 32)
;    CHECK_VALUE("h = i | 0x0F0F0000 (ORI)", h, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- XORI
;    i = g ^ VALUE8;
;    asm(
;        "lw      a4,-32(s0)\n\t"       // Chargement de g
;        "xori    a6,a4,252645135\n\t"  // i = g ^ VALUE8
;        "sw      a6,-40(s0)\n\t"       // Stockage de i
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("i = g ^ VALUE8 (XORI)", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SLTIU
;    // avec LHU, LBU, SB et SH
;    c = a < VALUE2;
;    // f = d < VALUE5;
;    asm(
;        "lhu     a4,-28(s0)\n\t"
;        "sltiu   a5,a4,15\n\t"
;        "andi    a5,a5,255\n\t"
;        "sh      a5,-26(s0)\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("c = a < VALUE2 (SLTIU)", c, 8)
;    CHECK_VALUE("f = d < VALUE5 (SLTIU)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SLTI
;    // avec LH, LB, SB et SH
;    //c = a < VALUE2;
;    asm(
;        "lb      a4,-17(s0)\n\t"
;        "slti    a5,a4,15\n\t"
;        "andi    a5,a5,255\n\t"
;        "sh      a5,-19(s0)\n\t"
;    );
;    // f = d < VALUE5;
;    asm(
;        "lh      a4,-28(s0)\n\t"
;        "slti    a5,a4,15\n\t"
;        "andi    a5,a5,255\n\t"
;        "sh      a5,-26(s0)\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("c = a < VALUE2 (SLTI)", c, 8)
;    CHECK_VALUE("f = d < VALUE5 (SLTI)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- SRAI
;    // avec LHU et SH
;    //f = d >> VALUE5;                      // Debordement
;    asm(
;        "lhu     a5,-22(s0)\n\t"
;        "srai    a5,a5,15\n\t"
;        "sh      a5,-26(s0)\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("f = d >> VALUE5 (SRAI)", f, 16)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BEQ
;    // avec LBU et ADDI
;    if (a != VALUE1) {
;        a = 0;
;    }
;    #ifdef DEBUG
;    CHECK_VALUE("a != VALUE1 alors a = 0 (BEQ)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BNE
;    // avec LBU et ADDI
;    if (a == VALUE1) {
;        a = 0;
;    }
;    #ifdef DEBUG
;    CHECK_VALUE("a == VALUE1 alors a = 0 (BNE)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BGEU
;    // avec LBU et ADDI
;    /*if (a < VALUE1) {
;        a = 0;
;    }*/
;    asm(
;        "lbu     a4,-17(s0)\n\t"
;        "li      a5,15\n\t"
;        "bgeu    a4,a5,LABEL0\n\t"
;        "sb      zero,-17(s0)\n\t"
;        "LABEL0:\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("a < VALUE1 alors a = 0 (BGEU)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BGE
;    // avec LB et ADDI
;    /*if (a < VALUE1) {
;        a = 0;
;    }*/
;    asm(
;        "lbu     a4,-17(s0)\n\t"
;        "li      a5,15\n\t"
;        "bge     a4,a5,LABEL1\n\t"
;        "sb      zero,-17(s0)\n\t"
;        "LABEL1:\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("a < VALUE1 alors a = 0 (BGE)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BLTU
;    // avec LBU et ADDI
;    /*if (a >= VALUE1) {
;        a = 0;
;    }*/
;    asm(
;        "lbu     a4,-17(s0)\n\t"
;        "li      a5,14\n\t"
;        "bltu    a4,a5,LABEL2\n\t"
;        "sb      zero,-17(s0)\n\t"
;        "LABEL2:\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("a >= VALUE1 alors a = 0 (BLTU)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- BLT
;    // avec LB et ADDI
;    /*if (a >= VALUE1) {
;        a = 0;
;    }*/
;    asm(
;        "lb     a4,-17(s0)\n\t"
;        "li      a5,14\n\t"
;        "blt     a4,a5,LABEL3\n\t"
;        "sb      zero,-17(s0)\n\t"
;        "LABEL3:\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("a >= VALUE1 alors a = 0 (BLT)", a, 8)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- LUI
;    // avec SW et LW
;    // Verifier s'il est necessaire de faire des modifs dans le compilateur
;    asm(
;        "lw      a4,-40(s0)\n\t"        // On charge i
;        "lui     a4,14\n\t"             // lui a4,VALUE1
;        "sw      a4,-40(s0)\n\t"        // On range i
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("LUI i,VALUE1", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- AUIPC
;    // avec SW et LW
;    // Verifier s'il est necessaire de faire des modifs dans le compilateur
;    asm(
;        "lw      a4,-40(s0)\n\t"        // On charge i
;        "auipc   a4,14\n\t"             // auipc a4,VALUE1
;        "sw      a4,-40(s0)\n\t"        // On range i
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("AUIPC i,VALUE1", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- LBU --> Deja teste
;    //----- LHU --> Deja teste
;    //----- LB --> Deja teste
;    //----- LH --> Deja teste
;    //----- LW --> Deja teste
;    //----- JAL
;    // avec du monde
;    a = 0;
;    for (int j = 0; j < 1; j=j+1) {
;        a = a + 1;
;    }
;    asm("sw      r6,-40(s0)\n\t");   // R6 utilise pour remplace l'instruction J par JAL, on le stock dans i
;    #ifdef DEBUG
;    CHECK_VALUE("JAL i,offset", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    //----- JALR
;    asm(
;        "lw      a4,-40(s0)\n\t"        // On charge i
;        "lw      a5,-36(s0)\n\t"        // On charge h
;        "jalr    a4,a5,LABEL4\n\t"
;        "addi    a4,zero,0\n\t"             // Si ca marche pas i = 0
;        "LABEL4:\n\t"
;    );
;    #ifdef DEBUG
;    CHECK_VALUE("JALR i,offset", i, 32)
;    #endif
;    RESET_VAR_VALUES
;
;    return 0;
;}
;        .file   "example.c"
;        .option nopic
;        .attribute arch, "rv32i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
;        .attribute unaligned_access, 0
;        .attribute stack_align, 16

main:
        addi    sp,sp,-48
        sw      s0,44(sp)
        addi    s0,sp,48
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        lbu     a5,-18(s0)
        lbu     a6,-19(s0)
        add     a4,a4,a5
        add     a6,a4,a6
        add     a5,zero,a6
        sb      a5,-19(s0)

        lw      a4,-36(s0)
        lw      a5,-40(s0)
        add     a5,a4,a5
        sw      a5,-44(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-36(s0)
        lw      a5,-40(s0)
        and     a5,a4,a5
        sw      a5,-44(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a4,-28(s0)
        lhu     a5,-30(s0)
        sll     a5,a4,a5
        sh      a5,-32(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a4,-22(s0)
        lhu     a5,-24(s0)
        srl     a5,a4,a5
        sh      a5,-26(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-36(s0)
        lw      a5,-40(s0)
        or      a5,a4,a5
        sw      a5,-44(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-36(s0)
        lw      a5,-40(s0)
        xor     a5,a4,a5
        sw      a5,-44(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        lbu     a5,-25(s0)
        sltu    a5,a4,a5
        andi    a5,a5,255
        sb      a5,-26(s0)
        lhu     a4,-30(s0)
        lhu     a5,-28(s0)
        sltu    a5,a4,a5
        andi    a5,a5,255
        sh      a5,-32(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lb      a4,-17(s0)
        lb      a5,-18(s0)
        slt     a5,a4,a5
        andi    a5,a5,255
        sb      a5,-19(s0)
        lh      a4,-24(s0)
        lh      a5,-22(s0)
        slt     a5,a5,a4
        andi    a5,a5,255
        sh      a5,-26(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a4,-28(s0)
        lhu     a5,-30(s0)
        sra     a5,a4,a5
        sh      a5,-32(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-25(s0)
        lbu     a5,-17(s0)
        sub     a5,a4,a5
        sb      a5,-26(s0)
        lhu     a4,-30(s0)
        lhu     a5,-28(s0)
        sub     a5,a4,a5
        sh      a5,-32(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a5,-28(s0)
        slli    a5,a5,5
        sh      a5,-32(s0)
        lbu     a5,-17(s0)
        slli    a5,a5,5
        sb      a5,-26(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a5,-28(s0)
        srli    a5,a5,16
        sh      a5,-32(s0)

        lbu     a5,-17(s0)
        srli    a5,a5,3
        sb      a5,-26(s0)
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-32(s0)
        lw      a5,-36(s0)
        ori     a6,a4,252645135
        ori     a7,a6,4294967294
        sw      a6,-40(s0)
        sw      a7,-36(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        xor     a5,a4,a5
        sw      a5,-44(s0)
        lw      a4,-32(s0)
        xori    a6,a4,252645135
        sw      a6,-40(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a5,-17(s0)
        sltiu   a5,a5,15
        andi    a5,a5,255
        sb      a5,-26(s0)
        lhu     a4,-28(s0)
        sltiu   a5,a4,15
        andi    a5,a5,255
        sh      a5,-26(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lb      a4,-17(s0)
        slti    a5,a4,15
        andi    a5,a5,255
        sh      a5,-19(s0)

        lh      a4,-28(s0)
        slti    a5,a4,15
        andi    a5,a5,255
        sh      a5,-26(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lhu     a5,-22(s0)
        srai    a5,a5,15
        sh      a5,-26(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        li      a5,14
        beq     a4,a5,.L2
        sb      zero,-17(s0)
.L2:
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        li      a5,14
        bne     a4,a5,.L3
        sb      zero,-17(s0)
.L3:
        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        li      a5,15
        bgeu    a4,a5,LABEL0
        sb      zero,-17(s0)
LABEL0:

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        li      a5,15
        bge     a4,a5,LABEL1
        sb      zero,-17(s0)
LABEL1:

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lbu     a4,-17(s0)
        li      a5,14
        bltu    a4,a5,LABEL2
        sb      zero,-17(s0)
LABEL2:

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lb     a4,-17(s0)
        li      a5,14
        blt     a4,a5,LABEL3
        sb      zero,-17(s0)
LABEL3:

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-40(s0)
        lui     a4,14
        sw      a4,-40(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-40(s0)
        auipc   a4,14
        sw      a4,-40(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        sb      zero,-17(s0)
        sw      zero,-24(s0)
        j       .L4
.L5:
        lbu     a5,-17(s0)
        addi    a5,a5,1
        sb      a5,-17(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L4:
        lw      a5,-24(s0)
        addi    a6,zero,1
        blt     a5,a6,.L5
        sw      r6,-40(s0)

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)
        lw      a4,-40(s0)
        lw      a5,-36(s0)
        jalr    a4,a5,LABEL4
        addi    a4,zero,0
LABEL4:

        li      a5,14
        sb      a5,-17(s0)
        li      a5,15
        sb      a5,-25(s0)
        li      a5,1
        sb      a5,-26(s0)
        li      a5,-2
        sh      a5,-28(s0)
        li      a5,15
        sh      a5,-30(s0)
        sh      zero,-32(s0)
        li      a5,-2
        sw      a5,-36(s0)
        li      a5,252645376
        addi    a5,a5,-241
        sw      a5,-40(s0)
        sw      zero,-44(s0)