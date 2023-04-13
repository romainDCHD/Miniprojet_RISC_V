//==============================================================================
//  Filename    : bench_riscv
//  Description : General test bench for the RISC-V processor
//==============================================================================

module bench_riscv();

timeunit      1ns;
timeprecision 1ns;

localparam PROG_SIZE = 648, CLK_PERIOD = 20;                // Size of the program memory

int clock_number;                                           // Number of clock cycles since the reset

int xpect_clk[2] = {19, 26};                                // Clock numbers when the expected value is read

typedef struct {
    string name;
    int clk;
    logic [32:0] address;
    int size;
    logic [31:0] value;
} tests;

// Test cases : See asm_bench_global.xlsx for more details
//                 name,                    clk,  address, size, value
tests test[25] = '{{"ADD sans débordement ", 26,   22     , 32,   32'h0000001E},
                   {"ADD avec débordement ", 30,   4      , 32,   32'h0F0F0F0D},
                   {"AND                  ", 51,   4      , 32,   32'h0F0F0F0E},
                   {"SLL                  ", 72,   16     , 16,   32'h00000000},
                   {"SRL                  ", 93,   16     , 16,   32'h00000002},
                   {"XOR                  ", 135,  4      , 32,   32'hF0F0F0F1},
                   {"SLTU true            ", 157,  22     , 8,    32'h00000001},
                   {"SLTU false           ", 162,  16     , 16,   32'h00000000},
                   {"SLT true             ", 184,  22     , 8,    32'h00000001},
                   {"SLT false            ", 189,  16     , 16,   32'h00000000},
                   {"SRA                  ", 210,  16     , 16,   32'h00000002},
                   {"SUB avec débordement ", 235,  16     , 16,   32'hFFFF0011},
                   {"SUB sans débordement ", 231,  22     , 8,    32'h00000001},
                   {"SLLI avec débordement", 255,  16     , 16,   32'h0000FFC0},
                   {"SLLI sans débordement", 258,  22     , 8,    32'h000000C0},
                   {"SRLI sans débordement", 278,  16     , 16,   32'h00000001},
                   {"SRLI avec débordement", 281,  22     , 8,    32'h00000000},
                   {"ORI                  ", 303,  4      , 32,   32'h0F0F0F0F},
                   {"ORI  avec dépendance ", 304,  8      , 32,   32'hFFFFFFFF},
                   {"XORI                 ", 326,  4      , 32,   32'hF0F0F0F1},
                   {"XORI                 ", 326,  4      , 32,   32'hF0F0F0F1},
                   {"SLTIU true           ", 350,  22     , 8,    32'h00000001},
                   {"SLTIU false          ", 354,  16     , 16,   32'h00000000},
                   {"SLTI true            ", 375,  22     , 16,   32'h00000001},
                   {"SLTI false           ", 379,  16     , 16,   32'h00000000}/*,
                   TODO : tests sur les branchements*/
                 };

bit clk;
bit reset;

// Design Under Test
riscv #(PROG_SIZE) riscv1 (
    .clk(clk),
    .rst(reset)
);

initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definitin
// `define PERIOD 20

initial begin
    clk = 1'b1;
    reset = 1'b1;
    #(CLK_PERIOD) reset = 1'b0;
end

always
    #(CLK_PERIOD/2) clk = ~clk;

// Load the program in the instruction memory from a binary file
initial begin
    // $readmemb("instructions/binary/test.bin", riscv1.imem1.tab_inst);
    $readmemb("C:/Users/Gael/Documents/Phelma/Miniprojet_RISC_V/prog/asm_bench_global.bin", riscv1.imem1.tab_inst);
    clk <= 1'b0  ;
    reset <= 1'b1;
    #21 reset <= 1'b0;
    clock_number = 0;
end

always @(posedge clk) begin
    clock_number = clock_number + 1;
    // $display("CLOCK=%d", clock_number);
    /* TODO : tests sur les valeurs initiales des variables */
    for (int i = 0; i < 2; i++) begin
        if (clock_number == test[i].clk) begin
            $display("========== Test %s (CLK = %d)", test[i].name, clock_number);
            $display("Expected value : %h", test[i].value);
            $display("Read value     : %h", riscv1.mem1.r_mem[test[i].address]);
            if (riscv1.mem1.r_mem[test[i].address] != test[i].value) begin
                $display("ERROR : Expected value is not the same as the read value");
                // $finish;
            end
        end
    end
    // if (riscv1.pc == 32'h00000000) begin
    //     $display("Program finished");
    //     $finish;
    // end
end

// Monitor the signals
/*initial begin
    $monitor ("time=%t", $time) ;
end*/

endmodule