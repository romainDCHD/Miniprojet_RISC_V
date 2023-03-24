//==============================================================================
//  Filename    : Testbench of the Control Logic module                                       
//  Designer    : Gaël Ousset
//  Description :  TODO : regarder le wbsel1 qui ne se met pas à 1, Prendre en compte le cas où tous les bits sont à 0 dans l'instruction. 
//==============================================================================

module bench_control_logic();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;

logic [31:0] inst;
logic        br_un;
logic        br_eq;
logic        br_lt;
logic        A1_sel;
logic        B1_sel;
logic        A2_sel;
logic        B2_sel;
logic [3:0]  alu_op;
logic        mem_rw;
logic        wb_sel1;
logic        wb_sel2;
logic        reg_w_en;
logic        pc_sel;

control_logic control_logic_inst(
    .clk(clk),
    .rst(reset),
    .inst_i(inst),
    .br_un_o(br_un),
    .br_eq_i(br_eq),
    .br_lt_i(br_lt),
    .A1_sel_o(A1_sel),
    .B1_sel_o(B1_sel),
    .A2_sel_o(A2_sel),
    .B2_sel_o(B2_sel),
    .alu_op_o(alu_op),
    .mem_rw_o(mem_rw),
    .wb_sel1_o(wb_sel1),
    .wb_sel2_o(wb_sel2),
    .reg_w_en_o(reg_w_en),
    .pc_sel_o(pc_sel)
);

initial $timeformat ( -9, 1, " ns", 12 );

// Clock and reset definition
`define CLK_PERIOD 20

initial begin
    clk = 1'b1;
    reset = 1'b1;
    #1 reset = 1'b0;
end

always
    #(`CLK_PERIOD/2) clk = ~clk;

// Testbench
initial begin
    //                      33222222222211111111110000000000
    //                      10987654321098765432109876543210
    #`CLK_PERIOD inst = 32'b00000000000000001111000101101111;
    // #`CLK_PERIOD inst = 32'b00000000001100010000001000110011;  // x[r4] = x[r2] + x[r3]
    // #`CLK_PERIOD inst = 32'b00000000011100110000001010110011;  // x[r5] = x[r6] + x[r7]
    #`CLK_PERIOD inst = 32'b00000000000000000000000000000000;
    #`CLK_PERIOD inst = 32'b00000000000000000000000000000000;
    #`CLK_PERIOD inst = 32'b00000000000000000000000000000000;
end

endmodule