//==============================================================================
//  Filename    : bench_triple_dependance
//  Description : General test bench for the RISC-V processor
//==============================================================================

module bench_triple_dependance();

timeunit      1ns;
timeprecision 1ns;

localparam PROG_SIZE = 20, CLK_PERIOD = 20, NB_TESTS = 5;   // Size of the program memory

int clock_number;                                           // Number of clock cycles since the reset
int passed_test = 0;                                        // Number of passed tests
int done_test = 0;                                          // Number of done tests
int value_ok = 0;                                           // Inidicate if the value read is the expected one

int xpect_clk[2] = {19, 26};                                // Clock numbers when the expected value is read

typedef struct {
    string name;
    int clk;
    logic [32:0] address;
    int size;
    logic [31:0] value;
} tests;

// Test cases : See asm_bench_global.xlsx for more details
//                         name,          clk,  address, size, value
tests test[NB_TESTS] = '{'{"Valeur de a", 22,   28     , 32,   32'h00000003},
                         '{"Valeur de b", 22,   24     , 32,   32'h00000002},
                         '{"Valeur de c", 22,   20     , 32,   32'h00000005},
                         '{"Valeur de d", 22,   16     , 32,   32'h00000003},
                         '{"Valeur de e", 22,   12     , 32,   32'h00000004}
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
initial begin
    clk = 1'b1;
    reset = 1'b1;
    #(CLK_PERIOD) reset = 1'b0;
end

always
    #(CLK_PERIOD/2) clk = ~clk;

// Load the program in the instruction memory from a binary file
initial begin
    // $readmemb("D:/Dossier principal/Documents/Phelma/Miniprojet_RISC_V/prog/asm_triple_dependance.bin", riscv1.imem1.tab_inst);
    $readmemb("C:/Users/Gael/Documents/Phelma/Miniprojet_RISC_V/prog/asm_triple_dependance.bin", riscv1.imem1.tab_inst);
    clk <= 1'b0  ;
    reset <= 1'b1;
    #21 reset <= 1'b0;
    clock_number = 0;
end

always @(posedge clk) begin
    clock_number = clock_number + 1;
    //----- Tests généraux
    for (int i = 0; i < NB_TESTS; i++) begin
        if (clock_number == test[i].clk+3) begin      // +3 because of the stages of the pipeline
            $display("========== Test %s (CLK = %d)", test[i].name, clock_number);
            $display("Expected value : 0x%h @ 0x%h", test[i].value, test[i].address);
            value_ok = 0;
            case (test[i].size)
                8: begin
                    $display(
                        "Read value     : 0x%h @ 0x%h", 
                        riscv1.mem1.mem[test[i].address], 
                        test[i].address
                    );
                    if (riscv1.mem1.mem[test[i].address  ][7:0]  == test[i].value[7:0]) begin
                        value_ok = 1;
                    end
                end
                16: begin
                    $display(
                        "Read value     : 0x%h %h @ 0x%h", 
                        riscv1.mem1.mem[test[i].address+1], 
                        riscv1.mem1.mem[test[i].address], 
                        test[i].address
                    );
                    if (riscv1.mem1.mem[test[i].address  ][7:0]  == test[i].value[7:0] &&
                        riscv1.mem1.mem[test[i].address+1][7:0]  == test[i].value[15:8]) begin
                        value_ok = 1;
                    end
                end
                32: begin
                    $display(
                        "Read value     : 0x%h %h %h %h @ 0x%h", 
                        riscv1.mem1.mem[test[i].address+3], 
                        riscv1.mem1.mem[test[i].address+2], 
                        riscv1.mem1.mem[test[i].address+1], 
                        riscv1.mem1.mem[test[i].address], 
                        test[i].address
                    );
                    if (riscv1.mem1.mem[test[i].address  ][7:0]  == test[i].value[7:0] &&
                        riscv1.mem1.mem[test[i].address+1][7:0]  == test[i].value[15:8] &&
                        riscv1.mem1.mem[test[i].address+2][7:0]  == test[i].value[23:16] &&
                        riscv1.mem1.mem[test[i].address+3][7:0]  == test[i].value[31:24]) begin
                        value_ok = 1;
                    end
                end
                default: begin
                    $display("ERROR : Wrong size");
                    $finish;
                end
            endcase
            if (value_ok == 0) begin
                $display("ERROR : Expected value is not the same as the read value");
                // $finish;
            end
            else begin
                $display("TEST PASSED");
                passed_test = passed_test + 1;
            end
            done_test = done_test + 1;
        end
    end
    if (done_test == NB_TESTS) begin
        $display("");
        $display("========== %d tests passed on %d", passed_test, done_test);
        // $finish;
    end
end

// Monitor the signals
/*initial begin
    $monitor ("time=%t", $time) ;
end*/

endmodule