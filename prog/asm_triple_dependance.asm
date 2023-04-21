;int main() {
;
;    int a = 1;
;    int b = 2;
;    int c = 0;
;    int d = 3;
;    int e = 0;
;    
;    asm(
;        "lw      a0,-20(s0) ; Chargement de a\n\t"
;        "lw      a1,-24(s0) ; Chargement de b\n\t"
;        "lw      a3,-32(s0) ; Chargement de d\n\t"
;        "add     a0,a0,a1   ; a = a + b\n\t"
;        "add     a2,a1,a3   ; c = b + d\n\t"
;        "add     a4,a3,a0   ; e = d + a\n\t"
;        "sw      a0,-20(s0) ; Ecriture de a\n\t"
;        "sw      a2,-28(s0) ; Ecriture de c\n\t"
;        "sw      a4,-36(s0) ; Ecriture de e\n\t"
;    );
;
;    /*
;        On doit obtenir :
;        a = 3
;        b = 2
;        c = 5
;        d = 3
;        e = 6
;    */
;
;    return 0;
;}
;        .file   "example.c"
;        .option nopic
;        .attribute arch, "rv32i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
;        .attribute unaligned_access, 0
;        .attribute stack_align, 16

main:
        addi    sp,sp,0
        sw      s0,48(sp)
        addi    s0,sp,48
        li      a5,1
        sw      a5,-20(s0)
        li      a5,2
        sw      a5,-24(s0)
        sw      zero,-28(s0)
        li      a5,3
        sw      a5,-32(s0)
        sw      zero,-36(s0)
        lw      a0,-20(s0) ; Chargement de a
        lw      a1,-24(s0) ; Chargement de b
        lw      a3,-32(s0) ; Chargement de d
        add     a0,a0,a1   ; a = a + b
        add     a2,a1,a3   ; c = b + d
        add     a4,a3,a0   ; e = d + a
        sw      a0,-20(s0) ; Ecriture de a
        sw      a2,-28(s0) ; Ecriture de c
        sw      a4,-36(s0) ; Ecriture de e
