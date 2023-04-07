//==============================================================================
//  Description : Optimization part before the ALU and the Memory 
//==============================================================================

module opti ( 
    input   logic   clk,
    input   logic   rst,
    //MUX
    input   logic   A1_sel,
    input   logic   B1_sel,
    input   logic   A2_sel,
    input   logic   B2_sel,
    //Branch_comp
    input   logic   Brun,
    output  logic   Breq,
    output  logic   Brlt,
    //data from the regfile
    input   [31:0]  reg_rs1,
    input   [31:0]  reg_rs2,
    //data from the ALU
    input   [31:0]  alu,
    //next programm counter
    input   [31:0]  pc,
    //immediate value
    input   [31:0]  imm,
    //data send to the ALU
    output  logic [31:0]  reg1,
    output  logic [31:0]  reg2,
    //data send to the Memory
    output  logic [31:0]  data_w
    );
    logic [31:0]  Br1;
    logic [31:0]  Br2;
    
    //The branch_comp module is included in this module
    branch_comp branch_comp1(
        .in_A(Br1),
        .in_B(Br2),
        .BrUn(Brun),
        .BrEq(Breq),
        .BrLT(Brlt)
    );
    
    always_comb // every input except clk and reset
    begin //combinatory part that represents the logic of the optimization
        case({A1_sel,A2_sel})
            2'b00: reg1 = reg_rs1;
            2'b10: reg1 = alu;
            default: reg1 = pc;
        endcase
        case({B1_sel,B2_sel})
            2'b00: reg2 = reg_rs2;
            2'b10: reg2 = alu;
            default: reg2 = imm;
        endcase
        case(B1_sel)
            1'b0: begin
                data_w = reg_rs2;
                Br2 = reg_rs2;
            end
            1'b1: begin
                data_w = alu;
                Br2 = alu;
            end
        endcase
        case(A1_sel)
            1'b0: Br1 = reg_rs2;
            1'b1: Br1 = alu;
        endcase
    end



endmodule

























