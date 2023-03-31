main:
        addi    sp,sp,-32
        sw      r6,28(sp)
        addi    r6,sp,32
        lui      r3,2
        sw      r3,-28(r6)
        lui      r3,1
        sw      r3,-20(r6)
        lw      r2,-28(r6)
        lw      r3,-20(r6)
        beq     r2,r3,.L2
        sw      zero,-24(r6)
        jal     r1,.L3
.L4:
        lw      r3,-20(r6)
        addi    r3,r3,1
        sw      r3,-20(r6)
        lw      r3,-24(r6)
        addi    r3,r3,1
        sw      r3,-24(r6)
.L3:
        lw      r2,-24(r6)
        lui      r3,4
        blt     r2,r3,.L4
.L2:
        lw      r3,-20(r6)
        lw      r6,28(sp)
        addi    sp,sp,32
        jalr    ra,r2,main
        
;https://godbolt.org/
;int main(void) {
;    int a = 2;
;    int b= 1;
;
;    if (a != b) {
;        for (int i = 0; i < 5; i=i+1) {
;            b = b + 1;
;        }
;    }
;
;    return b;
;}
