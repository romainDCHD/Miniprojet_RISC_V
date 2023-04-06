jal     r2,L1
add     r4,r2,r3
add     r5,r6,r7
L1:
bgeu    r2,r3,L1
lb      r2,0(r3)
slt     r5,r6,r7
sltu    r5,r6,r7
slti    r5,r6,r7
sltiu   r5,r6,r7
sb      r2,0(r5)
