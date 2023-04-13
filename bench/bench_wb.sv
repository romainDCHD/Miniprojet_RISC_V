//==============================================================================
//  Filename    : bench_wb
//  Description : fichier test de l'étage de write back
//==============================================================================

module bench_wb	 ();

timeunit      1ns;
timeprecision 1ns;

//declaration des signaux
bit             clk;
bit             reset;
logic   [31:0]  alu_i;
logic   [31:0]  mem_i;
logic           wb_sel1_i;
logic           wb_sel2_i;
logic           pc_sel_i;
logic   [31:0]  pc_o;
logic   [31:0]  dataD_o;

//declaration du module
wb wb1(
    .clk(clk),
    .rst(reset),
    .alu_i(alu_i),
    .mem_i(mem_i),
    .wb_sel1_i(wb_sel1_i),
    .wb_sel2_i(wb_sel2_i),
    .pc_sel_i(pc_sel_i),
    .pc_o(pc_o),
    .dataD_o(dataD_o)
);

// Clock and Reset Definitin
  `define PERIOD 20
  
  initial
    begin
      clk <= 1'b0  ;
      reset <= 1'b1;
      #21 reset <= 1'b0;
    end

  always
    #(`PERIOD/2) clk = ~clk;


// Monitor Results
  initial
	begin
 	$timeformat ( -9, 0, "ns", 3 ) ;	//for details cf notes
  $monitor ( "time=%t, pc_o=%d, dataD_o=%d, wb=%d",
            $time,     pc_o,    dataD_o,	wb1.wb  ) ;
	end
  // Verify Results for sum
  task xpect (input [31:0] expect_A, input [31:0] expect_B ) ;
  #3ns;
	if ( pc_o != expect_A )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "pc_o is %d and should be %d", pc_o, expect_A ) ;
	    	$display ( "REGFILE TEST FAILED ON pc_o" );
	    	$display ( "--------------------------------------------------------------" );
	    	//$stop ;
  	end
  	  	
  	else if ( dataD_o != expect_B )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "dataD_o is %d and should be %d", dataD_o, expect_B ) ;
	    	$display ( "REGFILE TEST FAILED ON dataD_o" );
	    	$display ( "--------------------------------------------------------------" );
	    	//$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  endtask
  
 // Apply Stimulus
 initial
	begin
    @(posedge clk)	//laisser le tps du reset
	//test wb_sel1
    @(posedge clk) 	alu_i = 32'h2; mem_i = 32'h4; wb_sel1_i = 1'b1; pc_sel_i = 1'b1; wb_sel2_i = 1'b1;
	@(posedge clk) 	alu_i = 32'h5; mem_i = 32'h6; wb_sel1_i = 1'b1; pc_sel_i = 1'b1; wb_sel2_i = 1'b0; @(negedge clk) xpect(32'h2, 32'h6); // expect du tour d'avant
	@(posedge clk) 	alu_i = 32'h7; mem_i = 32'h8; wb_sel1_i = 1'b0; pc_sel_i = 1'b1; wb_sel2_i = 1'b1; @(negedge clk) xpect(32'h5, 32'h5); 
	@(posedge clk) 	alu_i = 32'h2; mem_i = 32'h4; wb_sel1_i = 1'b0; pc_sel_i = 1'b0; wb_sel2_i = 1'b0; @(negedge clk) xpect(32'h8, 32'hC);
	@(posedge clk) 	alu_i = 32'h5; mem_i = 32'h6; wb_sel1_i = 1'b0; pc_sel_i = 1'b0; wb_sel2_i = 1'b0; @(negedge clk) xpect(32'hC, 32'h4);

  	$display ( "WRITE BACK TEST PASSED" ) ;
  	$stop ;
	end
endmodule