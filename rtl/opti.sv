//==============================================================================
//  Description : Optimization part before the ALU and the Memory 
//==============================================================================

module opti ( 
    input   logic        clk,
    input   logic        rst,
    // MUX
    input   logic        A1_sel_i,
    input   logic        B1_sel_i,
    input   logic        A2_sel_i,
    input   logic        B2_sel_i,
    // Branch_comp
    input   logic        BrUn_i,
    output  logic        BrEq_o,
    output  logic        BrLT_o,
    // Data from the regfile
    input         [31:0] reg_rs1_i,
    input         [31:0] reg_rs2_i,
    // Data from the ALU
    input         [31:0] alu_i,
    // Next programm counter
    input         [31:0] pc_i,
    // Immediate value
    input         [31:0] imm_i,
    // Data send to the ALU
    output  logic [31:0] reg1_o,
    output  logic [31:0] reg2_o,
    // Data send to the Memory
    output  logic [31:0] dataW_o
    );

    //== Variable Declaration ======================================================
    // logic [31:0] dataW;                  // 
    logic [31:0] Br1;
    logic [31:0] Br2;
    
    // The branch_comp module is included in this module
    branch_comp branch_comp1(
        .A_i(Br1),
        .B_i(Br2),
        .BrUn_i(BrUn_i),
        .BrEq_o(BrEq_o),
        .BrLT_o(BrLT_o)
    );
    
    //== Main code =================================================================
    always_ff @(posedge clk) dataW_o <= Br2;

    always_comb // every input except clk and reset
    begin //combinatory part that represents the logic of the optimization

        /*case({A1_sel_i,A2_sel_i})
            2'b00: reg1_o = reg_rs1_i;
            2'b10: reg1_o = alu_i;
            default: reg1_o = pc_i;
        endcase
        case({B1_sel_i,B2_sel_i})
            2'b00: reg2_o = reg_rs2_i;
            2'b10: reg2_o = alu_i;
            default: reg2_o = imm_i;
        endcase*/

        // Default output values
        reg1_o = 31'b0;
        reg2_o = 31'b0;
        // The combinatory part of the module
        case(A1_sel_i)
            1'b0: Br1 = reg_rs1_i;
            1'b1: Br1 = alu_i;
        endcase
        case(B1_sel_i)
            1'b0: Br2 = reg_rs2_i;
            1'b1: Br2 = alu_i;
        endcase
        case(A2_sel_i)
            1'b0: reg1_o = Br1;
            1'b1: reg1_o = pc_i;
        endcase
        case(B2_sel_i)
            1'b0: reg2_o = Br2;
            1'b1: reg2_o = imm_i;
        endcase
    end
endmodule

























