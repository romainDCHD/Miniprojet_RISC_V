//==============================================================================
//  Filename    : bench_riscv
//  Description : Testbench général du processeur
//==============================================================================

module bench_riscv();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;

// le paramètre est la taille de la mémoire imem
riscv #(28) riscv1 (
    .clk(clk),
    .reset(reset)
);




// Clock and Reset Definitin
  `define PERIOD 20

  always
    #(`PERIOD/2) clk = ~clk;
  
  initial
    begin
        //permet de charger le fichier binaire dans la mémoire instruction
        &readmemb("instructions.txt", riscv1.imem.tab_inst);
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