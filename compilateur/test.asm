main:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        li      a5,2
        sw      a5,-28(s0)
        li      a5,1
        sw      a5,-20(s0)
        lw      a4,-28(s0)
        lw      a5,-20(s0)
        beq     a4,a5,.L2
        sw      zero,-24(s0)
        j       .L3
.L4:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L3:
        lw      a4,-24(s0)
        li      a5,4
        ble     a4,a5,.L4
.L2:
        lw      a5,-20(s0)
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra