//==============================================================================
//  Description : Top module of the processsor 
//==============================================================================

module riscv #(parameter  n=20)
(
    input   logic   clk,
    input   logic   rst
);
// All the Wires of the system
logic [31:0] pc;
logic [31:0] data_d;
logic [31:0] inst;
logic [2:0]  Immsel;
logic [31:0] Imm;
logic [31:0] Data_w;
logic [31:0] alu;
logic [31:0] alu_mem_o;
logic [31:0] Rs1;
logic [31:0] Rs2;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] data_mem;
// Multiplexers
logic        A1_sel;
logic        B1_sel;
logic        A2_sel;
logic        B2_sel;
// MUX: choose between PC+4 or the one that come from the ALU
logic        pc_sel;
// Choose between writing or reading in the destination register
logic        RegWen;
// Branch_comp
logic        BrUn;
logic        BrEq;
logic        BrLt;
// Choose what to do in the ALU
logic [3:0]  AluSel;
// Choose between writing or reading the memory
logic        MemRW;
// Choose what to write back
logic        wb_sel1;
logic        wb_sel2;


imem #(n) imem1  ( 
    .clk(clk),
    .rst(rst),
    .pc(pc),
    .inst_out (inst)
  );


riscv_regfile riscv_regfile1(
    .clk_i(clk),
    .rst_i(rst),
    .AddrD_i(inst[11:7]),
    .DataD_i(data_d),
    .AddrB_i(inst[24:20]),
    .AddrA_i(inst[19:15]),
    .RegWEn_i(RegWen),
    .DataA_o(Rs1),
    .DataB_o(Rs2)
);

imm_gen imm_gen1(
    .clk(clk),
    .rst(rst),
    .sig(Immsel),
    .imm_in(inst),
    .imm_out(Imm)
);

opti opti1(
    .clk(clk),
    .rst(rst),
    .A1_sel(A1_sel),
    .B1_sel(B1_sel),
    .A2_sel(A2_sel),
    .B2_sel(B2_sel),
    .Brun(BrUn),
    .Breq(BrEq),
    .Brlt(BrLt),
    .reg_rs1(Rs1),
    .reg_rs2(Rs2),
    .alu(alu),
    .pc(pc),
    .imm(Imm),
    .reg1(reg1),
    .reg2(reg2),
    .data_w(Data_w)
);

alu alu1(
     // Inputs
     .alu_op_i     (AluSel),
     .alu_a_i      (reg1),
     .alu_b_i      (reg2),
     .clk          (clk),
     .rst          (rst),
     // Outputs
     .alu_result_o (alu)
 );

mem #(256) mem1(
    .clk(clk),
    .rst(rst),
    .memRW(MemRW),
    .dataW_i(Data_w),
    .addr_i(alu),
    // Output
    .data_o(data_mem),
    .alu_o(alu_mem_o)
);


wb wb1(
    .clk(clk),
    .rst(rst),
    .alu_i(alu_mem_o),
    .mem_i(data_mem),
    .wb_sel1_i(wb_sel1),
    .wb_sel2_i(wb_sel2),
    .pc_sel_i(pc_sel),
    .pc_o(pc),
    .dataD_o(data_d)
);


control_logic control_logic1(
    .clk(clk),
    .rst(rst),
    .inst_i(inst),
    .br_un_o(BrUn),
    .br_eq_i(BrEq),
    .br_lt_i(BrLt),
    .A1_sel_o(A1_sel),
    .B1_sel_o(B1_sel),
    .A2_sel_o(A2_sel),
    .B2_sel_o(B2_sel),
    .alu_op_o(AluSel),
    .mem_rw_o(MemRW),
    .wb_sel1_o(wb_sel1),
    .wb_sel2_o(wb_sel2),
    .reg_w_en_o(RegWen),
    .pc_sel_o(pc_sel)
);



endmodule
