.L0:
jal r2,.L1
add r4,r2,r3
add r5,r6,r7
.L1:
bgeu r2,r3,.L0
lb r2,0(r3)