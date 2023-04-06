//==============================================================================
//  Filename    : Testbench de l'architecture principale                                       
//  Designer    : Gaël Ousset
//  Description : OK
//==============================================================================

module bench_riscv();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;

logic pc;
logic inst;

logic [31:0] inst[28,0] = [
    0'b11111110000000010000000100010011,
    0'b00000000011000010010111000100011,
    0'b00000010000000010000001100010011,
    0'b00000000000000000010000110110111,
    0'b01111110001100110010001000100011,
    0'b00000000000000000001000110110111,
    0'b01111110001100110010011000100011,
    0'b11111110010000110010000100000011,
    0'b11111110110000110010000110000011,
    0'b00000100001100010000000001100011,
    0'b00000000000000000000000000000000,
    0'b00000000000000000000000000000000,
    0'b01111110000000110010010000100011,
    0'b00000001110000000000000011101111,
    0'b11111110110000110010000110000011,
    0'b00000000000100011000000110010011,
    0'b01111110001100110010011000100011,
    0'b11111110100000110010000110000011,
    0'b00000000000100011000000110010011,
    0'b01111110001100110010010000100011,
    0'b11111110100000110010000100000011,
    0'b00000000000000000100000110110111,
    0'b11111110001100010100000011100011,
    0'b00000000000000000000000000000000,
    0'b00000000000000000000000000000000,
    0'b11111110110000110010000110000011,
    0'b00000001110000010010001100000011,
    0'b00000010000000010000000100010011,
    0'b11111001000000010000000011100111
 ];

riscv riscv1 (
    .clk(clk),
    .reset(reset),
    .inst_i(inst),
    .pc(pc)
);

imem #(28) imem1 ( 
    .clk(clk),
    .rst(rst),
    .tab_inst(tab_inst),
    .pc(pc),
    inst_out(inst)
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


endmodule