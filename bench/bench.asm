;int main() {
;	int a[] = {6, 2};       // 26 - unite, dizaine 
;	int b[] = {3, 1};       // 13 - unite, dizaine 
;	int u[] = {0, 0, 0};    // Valeurs intermediares
;	int v[] = {0, 0, 0};
;	int s[] = {0, 0, 0, 0}; // Valeurs final
;	int c;                  // Valeur tampon
;	// Multiplication des unites
;	for (int i = 0; i < 2; i=i+1) {
;		c = 0;
;		for (int i = 0; i < b[0]; i=i+1) {
;			c = c + a[i];
;		}
;		if (c >= 10) {
;			u[i] = u[i] + c - 10;
;			u[i+1] = 1;
;		}
;		else u[i] = u[i] + c;
;	}
;	// Multiplication des dizaines
;	for (int i = 0; i < 2; i=i+1) {
;		c = v[i+1];
;		for (int i = 0; i < b[0]; i=i+1) {
;			c = c + a[i];
;		}
;		if (c >= 10) {
;			v[i+1] = v[i+1] + c - 10;
;			v[i+2] = 1;
;		}
;		else v[i+1] = v[i+1] + c;
;	}
;	// Additions
;	for (int i = 0; i < 3; i=i+1) {
;		c = u[i] + v[i] + s[i];
;		if (c >= 10) {
;			s[i] = c - 10;
;			s[i+1] = 1;
;		}
;		else s[i] = c;
;	}
;	/*
;		On devrait obtenir :
;			u = {8, 7, 0}
;			v = {0, 6, 2}
;			s = {8, 3, 3}
;	*/
;	return 0;
;}
main:
        addi    sp,sp,-96
        sw      s0,92(sp)
        addi    s0,sp,96
        addi    a5,zero,6
        sw      a5,-48(s0)
        addi    a5,zero,2
        sw      a5,-44(s0)
        addi    a5,zero,3
        sw      a5,-56(s0)
        addi    a5,zero,1
        sw      a5,-52(s0)
        sw      zero,-68(s0)
        sw      zero,-64(s0)
        sw      zero,-60(s0)
        sw      zero,-80(s0)
        sw      zero,-76(s0)
        sw      zero,-72(s0)
        sw      zero,-96(s0)
        sw      zero,-92(s0)
        sw      zero,-88(s0)
        sw      zero,-84(s0)
        sw      zero,-24(s0)
        jal     r6,.L2
.L7:
        sw      zero,-20(s0)
        sw      zero,-28(s0)
        jal     r6,.L3
.L4:
        lw      a5,-28(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a5,-32(a5)
        lw      a4,-20(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L3:
        lw      a5,-56(s0)
        lw      a4,-28(s0)
        blt     a4,a5,.L4
        lw      a4,-20(s0)
        addi    a5,zero,10
        blt     a4,a5,.L5
        lw      a5,-24(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a4,-52(a5)
        lw      a5,-20(s0)
        add     a5,a4,a5
        addi    a4,a5,-10
        lw      a5,-24(s0)
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        sw      a4,-52(a5)
        lw      a5,-24(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        addi    a4,zero,1
        sw      a4,-52(a5)
        jal     r6,.L6
.L5:
        lw      a5,-24(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a4,-52(a5)
        lw      a5,-20(s0)
        add     a4,a4,a5
        lw      a5,-24(s0)
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        sw      a4,-52(a5)
.L6:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L2:
        lw      a4,-24(s0)
        addi    a5,zero,2
        blt     a4,a5,.L7
        sw      zero,-32(s0)
        jal     r6,.L8
.L13:
        lw      a5,-32(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a5,-64(a5)
        sw      a5,-20(s0)
        sw      zero,-36(s0)
        jal     r6,.L9
.L10:
        lw      a5,-36(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a5,-32(a5)
        lw      a4,-20(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L9:
        lw      a5,-56(s0)
        lw      a4,-36(s0)
        blt     a4,a5,.L10
        lw      a4,-20(s0)
        addi    a5,zero,10
        blt     a4,a5,.L11
        lw      a5,-32(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a4,-64(a5)
        lw      a5,-20(s0)
        add     a4,a4,a5
        lw      a5,-32(s0)
        addi    a5,a5,1
        addi    a4,a4,-10
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        sw      a4,-64(a5)
        lw      a5,-32(s0)
        addi    a5,a5,2
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        addi    a4,zero,1
        sw      a4,-64(a5)
        jal     r6,.L12
.L11:
        lw      a5,-32(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a3,-64(a5)
        lw      a5,-32(s0)
        addi    a5,a5,1
        lw      a4,-20(s0)
        add     a4,a3,a4
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        sw      a4,-64(a5)
.L12:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L8:
        lw      a4,-32(s0)
        addi    a5,zero,2
        blt     a4,a5,.L13
        sw      zero,-40(s0)
        jal     r6,.L14
.L17:
        lw      a5,-40(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a4,-52(a5)
        lw      a5,-40(s0)
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        lw      a5,-64(a5)
        add     a4,a4,a5
        lw      a5,-40(s0)
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        lw      a5,-80(a5)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a4,-20(s0)
        addi    a5,zero,10
        blt     a4,a5,.L15
        lw      a5,-20(s0)
        addi    a4,a5,-10
        lw      a5,-40(s0)
        slli    a5,a5,2
        addi    a3,s0,-16
        add     a5,a3,a5
        sw      a4,-80(a5)
        lw      a5,-40(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        addi    a4,zero,1
        sw      a4,-80(a5)
        jal     r6,.L16
.L15:
        lw      a5,-40(s0)
        slli    a5,a5,2
        addi    a4,s0,-16
        add     a5,a4,a5
        lw      a4,-20(s0)
        sw      a4,-80(a5)
.L16:
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L14:
        lw      a4,-40(s0)
        addi    a5,zero,3
        blt     a4,a5,.L17