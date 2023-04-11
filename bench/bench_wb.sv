//==============================================================================
//  Filename    : bench_wb
//  Description : fichier test de l'étage de write back
//==============================================================================

module bench_mem ();

timeunit      1ns;
timeprecision 1ns;

//declaration des signaux
bit             clk;
bit             rst;
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
    .rst(rst),
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
  $monitor ( "time=%t, pc_o=%d, dataD_o=%d",
            $time,     pc_o,    dataD_o  ) ;
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
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  	
  	if ( dataD_o != expect_B )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "dataD_o is %d and should be %d", dataD_o, expect_B ) ;
	    	$display ( "REGFILE TEST FAILED ON dataD_o" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  endtask
  
  //------------------A FAIRE-------------------------
 // Apply Stimulus
 initial
	begin
    @(posedge clk)
    //sans bulles
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h0; AddrB = 5'h1; AddrD = 5'h2; DataD = 32'h14; @(negedge clk) xpect(32'h0, 32'h0); //test 0 juste apres le reset
    
  	$display ( "REGFILE TEST PASSED" ) ;
  	$stop ;
	end
endmodule