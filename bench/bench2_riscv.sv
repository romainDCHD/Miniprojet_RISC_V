//==============================================================================
//  Filename    : bench_riscv
//  Description : bench for the RISC-V processor with spetial instructions
//==============================================================================

module bench2_riscv();

timeunit      1ns;
timeprecision 1ns;

localparam PROG_SIZE = 7, CLK_PERIOD = 20; // Size of the program memory (multiple de 4-1)

bit clk;
bit reset;

// Design Under Test
riscv #(PROG_SIZE) riscv1 (
    .clk(clk),
    .rst(reset)
);

//clock definition
    `define PERIOD 20

    always
    #(`PERIOD/2) clk = ~clk;


initial
    begin
      //permet de charger le fichier binaire dans la mémoire instruction
      $readmemb("prog/asm_bge_2.bin", riscv1.imem1.tab_inst);
      clk <= 1'b0  ;
      reset <= 1'b1;
      #21 reset <= 1'b0;
    end

initial 
    begin
        $timeformat ( -9, 1, " ns", 12 );
        //monitorer les données 
        $monitor ( "time=%t, ",
        	$time,   ) ;
	end

endmodule
