//==============================================================================
//  Description : Optimization part before the ALU and the Memory 
//==============================================================================

module opti ( 
    input   logic        clk,
    input   logic        rst,
    input   logic  [1:0] A1_sel_i,  // MUX 1
    input   logic  [1:0] B1_sel_i,  // MUX 1
    input   logic        A2_sel_i,  // MUX 2
    input   logic        B2_sel_i,  // MUX 2
    input   logic        BrUn_i,    // to know if unsigned comparision or not
    input         [31:0] reg_rs1_i,
    input         [31:0] reg_rs2_i, // Data from the regfile
    input         [31:0] alu_i,     // Data from the ALU
    input         [31:0] pc_i,      // Next programm counter
    input         [31:0] imm_i,     // Immediate value
    input         [31:0] wb_i,        // write back for the dependencies
    //output
    output  logic        BrEq_o,    // result of comparison to control logic
    output  logic        BrLT_o,
    output  logic [31:0] reg1_o,    // Data send to the ALU
    output  logic [31:0] reg2_o,    // Data send to the ALU
    output  logic [31:0] dataW_o    // Data send to the Memory
    );

    //== Variable Declaration ======================================================
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

        // Default output values
        reg1_o = 0;
        reg2_o = 0;
        // The combinatory part of the module
        case(A1_sel_i)
            2'b00: Br1 = reg_rs1_i;
            2'b01: Br1 = alu_i;
            2'b10: Br1 = wb_i;
            2'b11: Br1 = reg_rs1_i;
        endcase
        case(B1_sel_i)
            2'b00: Br2 = reg_rs2_i;
            2'b01: Br2 = alu_i;
            2'b10: Br2 = wb_i;
            2'b11: Br2 = reg_rs2_i;
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

























