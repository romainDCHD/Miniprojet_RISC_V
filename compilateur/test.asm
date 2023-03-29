main:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        lui      a5,2
        sw      a5,-28(s0)
        lui      a5,1
        sw      a5,-20(s0)
        lw      a4,-28(s0)
        lw      a5,-20(s0)
        beq     a4,a5,.L2
        sw      zero,-24(s0)
        jal     r1,.L3
.L4:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L3:
        lw      a4,-24(s0)
        lui      a5,4
        blt     a4,a5,.L4
.L2:
        lw      a5,-20(s0)
        lw      s0,28(sp)
        addi    sp,sp,32
        jalr    r2,r1,32
        
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