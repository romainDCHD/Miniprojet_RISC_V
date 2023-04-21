//==============================================================================
//  Description : Top module of the processsor 
//==============================================================================

//== Module Declaration =========================================================
module riscv #(parameter  n=20) (
    input   logic   clk,
    input   logic   rst
);

//== Variable Declaration ======================================================
// Fetch stage
logic [31:0] pc_l;                       // Program counter
logic [31:0] inst_l;                     // Instruction

// Multiplexers selectors
logic        A1_sel_l;                   // Choose between the register and ALU
logic        B1_sel_l;                   // Choose between the register and ALU
logic        A2_sel_l;                   // Choose between the previous multiplexer and PC
logic        B2_sel_l;                   // Choose between the previous multiplexer and the immediate value
logic        pc_sel_l;                   // Choose between PC+4 or the one that come from the ALU
logic        wbsel1_l;                   // Choose between writing back the ALU or the memory
logic        wbsel2_l;                   // Choose between writing back the value from the previous multiplexer or PC+4

// Register file
logic [31:0] datad_l;                    // Data to write in the register file
logic [31:0] reg1_l;                     // Value of the first register
logic [31:0] reg2_l;                     // Value of the second register
logic        RegWen_l;                   // Enable the writing in the register file

// Immediate selector
logic [2:0]  ImmSel_l;                   // Choose the format of the immediate value
logic [31:0] Imm_l;                      // Immediate value

// Branch comparator
logic        BrUn_l;                     // Unconditional branch
logic        BrEq_l;                     // Branch if equal
logic        BrLt_l;                     // Branch if less than

// ALU
logic [31:0] alu_l;                      // ALU output
logic [3:0]  ALUSel_l;                   // Choose what to do in the ALU
logic [31:0] aluA_l;                     // First input of the ALU
logic [31:0] aluB_l;                     // Second input of the ALU

// Memory
logic [31:0] dataW_l;                    // Data to write in the memory
logic        MemRW_l;                    // Enable the writing in the memory
logic [1:0]  dataSize_l;                 // Choose the size of the data to read or write in the memory
logic [31:0] mem_l;                      // Data read from the memory
logic [31:0] alu_mem_l;                  // ALU output after the memory stage

//== Main code =================================================================
imem #(n) imem1  ( 
    .clk(clk),
    .rst(rst),
    .pc(pc_l),
    .inst_out(inst_l)
  );


riscv_regfile regfile1(
    .clk_i(clk),
    .rst_i(rst),
    .AddrD_i(inst_l[11:7]),
    .DataD_i(datad_l),
    .AddrB_i(inst_l[24:20]),
    .AddrA_i(inst_l[19:15]),
    .RegWEn_i(RegWen_l),
    .DataA_o(reg1_l),
    .DataB_o(reg2_l)
);

imm_gen imm_gen1(
    .clk(clk),
    .rst(rst),
    .sel_i(ImmSel_l),
    .imm_i(inst_l),
    .imm_o(Imm_l)
);

opti opti1(
    .clk(clk),
    .rst(rst),
    .A1_sel_i(A1_sel_l),
    .B1_sel_i(B1_sel_l),
    .A2_sel_i(A2_sel_l),
    .B2_sel_i(B2_sel_l),
    .BrUn_i(BrUn_l),
    .BrEq_o(BrEq_l),
    .BrLT_o(BrLt_l),
    .reg_rs1_i(reg1_l),
    .reg_rs2_i(reg2_l),
    .alu_i(alu_l),
    .pc_i(pc_l),
    .imm_i(Imm_l),
    .reg1_o(aluA_l),
    .reg2_o(aluB_l),
    .dataW_o(dataW_l)
);

alu alu1(
     // Inputs
     .alu_op_i(ALUSel_l),
     .alu_a_i(aluA_l),
     .alu_b_i(aluB_l),
     .clk(clk),
     .rst(rst),
     // Outputs
     .alu_result_o(alu_l)
 );

mem #(63) mem1(
    .clk(clk),
    .rst(rst),
    .memRW(MemRW_l),
    .dataSec_i(dataSize_l),
    .dataW_i(dataW_l),
    .addr_i(alu_l),
    // Output
    .data_o(mem_l),
    .alu_o(alu_mem_l)
);

wb wb1(
    .clk(clk),
    .rst(rst),
    .alu_i(alu_mem_l),
    .mem_i(mem_l),
    .wb_sel1_i(wbsel1_l),
    .wb_sel2_i(wbsel2_l),
    .pc_sel_i(pc_sel_l),
    .pc_o(pc_l),
    .dataD_o(datad_l)
);

control_logic control_logic1(
    .clk(clk),
    .rst(rst),
    .inst_i(inst_l),
    .imm_sel_o(ImmSel_l),
    .br_un_o(BrUn_l),
    .br_eq_i(BrEq_l),
    .br_lt_i(BrLt_l),
    .A1_sel_o(A1_sel_l),
    .B1_sel_o(B1_sel_l),
    .A2_sel_o(A2_sel_l),
    .B2_sel_o(B2_sel_l),
    .alu_op_o(ALUSel_l),
    .mem_rw_o(MemRW_l),
    .mem_size_o(dataSize_l),
    .wb_sel1_o(wbsel1_l),
    .wb_sel2_o(wbsel2_l),
    .reg_w_en_o(RegWen_l),
    .pc_sel_o(pc_sel_l)
);

endmodule
