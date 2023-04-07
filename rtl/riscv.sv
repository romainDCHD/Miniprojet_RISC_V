//==============================================================================
//  Description : Global code of the processsor 
//==============================================================================

module riscv 
(
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  inst_i, //the next instruction will be given by the test bench
    output  logic [31:0]  pc //the programm counter is send back to the test bench
);
//All the Wires of the system
logic [31:0] pc_4;
logic [31:0] wb;
logic [31:0] inst;
logic [2:0]  Immsel;
logic [31:0] Imm;
logic [31:0] Data_o;
logic [31:0] Data_w;
logic [31:0] alu;
logic [31:0] mem;
logic [31:0] Rs1;
logic [31:0] Rs2;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] data_mem;
//Multiplexers
logic A1_sel;
logic B1_sel;
logic A2_sel;
logic B2_sel;
//MUX: choose between PC+4 or the one that come from the ALU
logic pc_sel;
//choose between writing or reading in the destination register
logic RegWen;
//branch_comp
logic BrUn;
logic BrEq;
logic BrLt;
//choose what to do in the ALU
logic [3:0] AluSel;
//choose between writing or reading the memory
logic MemRW;
//choose what to write back
logic [1:0] WBSel;

fetch_in fetch_in1(
    .clk(clk),
    .rst(rst),
    .pc_4(pc_4),
    .wb(wb),
    .pc_sel(pc_sel),
    .pc_out(pc)
);

dff dff1(
    .clk(clk),
    .rst(rst),
    .d(inst_i),
    .q(inst)
);


riscv_regfile riscv_regfile1(
    .clk_i(clk),
    .rst_i(rst),
    .AddrD_i(inst[11:7]),
    .DataD_i(wb),
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
    .data_w(Data_o)
);

dff dff2(
    .clk(clk),
    .rst(rst),
    .d(Data_o),
    .q(Data_w)
);

mem mem1(
    .clk(clk),
    .rst(rst),
    .dmem(MemRW),
    .data_w(Data_w),
    .addr(alu),
    .data_r(data_mem)
);

wb_out wbout1(
    .clk(clk),
    .rst(rst),
    .pc_4_i(pc_4),
    .alu_i(alu),
    .mem_i(data_mem),
    .wb_sel1_i(WBSel[0]),
    .wb_sel2_i(WBSel[1]),
    .pc_sel_i(pc_sel),
    .wb(wb)
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
    .wb_sel_o(WBSel),
    .reg_w_en_o(RegWen),
    .pc_sel_o(pc_sel)
);



endmodule