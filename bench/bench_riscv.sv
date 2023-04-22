//==============================================================================
//  Filename    : bench_riscv
//  Description : General test bench for the RISC-V processor
//==============================================================================

module bench_riscv();

timeunit      1ns;
timeprecision 1ns;

localparam PROG_SIZE = 648, CLK_PERIOD = 20, NB_TESTS = 25; // Size of the program memory

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
//                         name,                    clk,  address, size, value
tests test[NB_TESTS] = '{'{"ADD sans débordement ", 26,   22     , 32,   32'h0000001E},
                         '{"ADD avec débordement ", 30,   4      , 32,   32'h0F0F070D},
                         '{"AND                  ", 51,   4      , 32,   32'h0F0F070E},
                         '{"SLL                  ", 72,   16     , 16,   32'h00000000},
                         '{"SRL                  ", 93,   16     , 16,   32'h00000002},
                         '{"OR                   ", 114,  4      , 32,   32'hFFFFFFFF},
                         '{"XOR                  ", 135,  4      , 32,   32'hF0F0F8F1},
                         '{"SLTU true            ", 157,  22     , 8,    32'h00000001},
                         '{"SLTU false           ", 162,  16     , 16,   32'h00000000},
                         '{"SLT true             ", 184,  22     , 8,    32'h00000001},
                         '{"SLT false            ", 189,  16     , 16,   32'h00000000},
                         '{"SRA                  ", 210,  16     , 16,   32'h00000002},
                         '{"SUB sans débordement ", 231,  22     , 8,    32'h00000001},
                         '{"SUB avec débordement ", 235,  16     , 16,   32'hFFFF0011},
                         '{"SLLI avec débordement", 255,  16     , 16,   32'h0000FFC0},
                         '{"SLLI sans débordement", 258,  22     , 8,    32'h000000C0},
                         '{"SRLI sans débordement", 278,  16     , 16,   32'h00000001},
                         '{"SRLI avec débordement", 281,  22     , 8,    32'h00000000},
                         '{"ORI                  ", 303,  4      , 32,   32'h0F0F070F},
                         '{"ORI  avec dépendance ", 304,  8      , 32,   32'hFFFFFFFF},
                         '{"XORI                 ", 326,  4      , 32,   32'hF0F0F8F1},
                         '{"SLTIU true           ", 350,  22     , 8,    32'h00000001},
                         '{"SLTIU false          ", 354,  16     , 16,   32'h00000000},
                         '{"SLTI true            ", 375,  22     , 16,   32'h00000001},
                         '{"SLTI false           ", 379,  16     , 16,   32'h00000000}/*,
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
initial begin
    clk = 1'b1;
    reset = 1'b1;
    #(CLK_PERIOD) reset = 1'b0;
end

always
    #(CLK_PERIOD/2) clk = ~clk;

// Load the program in the instruction memory from a binary file
initial begin
    $readmemb("D:/Dossier principal/Documents/Phelma/Miniprojet_RISC_V/prog/asm_bench_global.bin", riscv1.imem1.tab_inst);
    // $readmemb("C:/Users/Gael/Documents/Phelma/Miniprojet_RISC_V/prog/asm_bench_global.bin", riscv1.imem1.tab_inst);
    clk <= 1'b0  ;
    reset <= 1'b1;
    #21 reset <= 1'b0;
    clock_number = 0;
end

always @(posedge clk) begin
    clock_number = clock_number + 1;

    //----- Vérification des valeurs des variables initials
    if (clock_number == 24) begin
        $display("========== Test des valeurs initial (CLK = %d)", clock_number);
        // Valeur de s0
        if (riscv1.mem1.mem[48] == 8'h00 &&
            riscv1.mem1.mem[49] == 8'h00 &&
            riscv1.mem1.mem[50] == 8'h00 &&
            riscv1.mem1.mem[51] == 8'h00) begin
                $display("Valeur de s0 OK");
        end else begin
            $display("Valeur de s0 NOK");
        end
        // Valeur de a
        if (riscv1.mem1.mem[31] == 8'h0E) begin
                $display("Valeur de a  OK");
        end else begin
            $display("Valeur de a  NOK");
        end
        // Valeur de b
        if (riscv1.mem1.mem[23] == 8'h0F) begin
                $display("Valeur de b  OK");
        end else begin
            $display("Valeur de b  NOK");
        end
        // Valeur de c
        if (riscv1.mem1.mem[22] == 8'h01) begin
                $display("Valeur de c  OK");
        end else begin
            $display("Valeur de c  NOK");
        end
        // Valeur de d
        if (riscv1.mem1.mem[20] == 8'hFE &&
            riscv1.mem1.mem[21] == 8'hFF) begin
                $display("Valeur de d  OK");
        end else begin
            $display("Valeur de d  NOK");
        end
        // Valeur de e
        if (riscv1.mem1.mem[18] == 8'h0F &&
            riscv1.mem1.mem[19] == 8'h00) begin
                $display("Valeur de e  OK");
        end else begin
            $display("Valeur de e  NOK");
        end
        // Valeur de f
        if (riscv1.mem1.mem[16] == 8'h00 &&
            riscv1.mem1.mem[17] == 8'h00) begin
                $display("Valeur de f  OK");
        end else begin
            $display("Valeur de f  NOK");
        end
        // Valeur de g
        if (riscv1.mem1.mem[12] == 8'hFE &&
            riscv1.mem1.mem[13] == 8'hFF &&
            riscv1.mem1.mem[14] == 8'hFF &&
            riscv1.mem1.mem[15] == 8'hFF) begin
                $display("Valeur de g  OK");
        end else begin
            $display("Valeur de g  NOK");
        end
        // Valeur de h
        if (riscv1.mem1.mem[8]  == 8'h0F &&
            riscv1.mem1.mem[9]  == 8'h07 &&
            riscv1.mem1.mem[10] == 8'h0F &&
            riscv1.mem1.mem[11] == 8'h0F) begin
                $display("Valeur de h  OK");
        end else begin
            $display("Valeur de h  NOK");
        end
        // Valeur de i
        if (riscv1.mem1.mem[4]  == 8'h00 &&
            riscv1.mem1.mem[5]  == 8'h00 &&
            riscv1.mem1.mem[6]  == 8'h00 &&
            riscv1.mem1.mem[7]  == 8'h00) begin
                $display("Valeur de i  OK");
        end else begin
            $display("Valeur de i  NOK");
        end
    end

    //----- Tests généraux
    for (int i = 0; i < NB_TESTS; i++) begin
        if (clock_number == test[i].clk+4) begin      // +4 because of the stages of the pipeline
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