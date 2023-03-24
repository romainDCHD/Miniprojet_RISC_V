//==============================================================================
//  Filename    : Testbench of the register module                                        
//  Designer    : Romain DUCHADEAU
//  Description : 
//==============================================================================
module bench_regfile();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;
logic RegWEn;
logic [4:0]    AddrD;
logic [31:0]   DataD;
logic [4:0]    AddrB;
logic [4:0]    AddrA;
logic [31:0]   DataA;
logic [31:0]   DataB;

module riscv_regfile(
    .clk_i	  ( clk ),
    .rst_i	  ( reset ),	
    .AddrD_i	  ( AddrD ),
    .DataD_i	  ( DataD ),
    .AddrB_i	  ( AddrB ),
    .AddrA_i	  ( AddrA ),
    .RegWEn_i	  ( RegWEn ),
    //output
    .DataA_o	  ( DataA ),
    .DataB_o	  ( DataB ),	 
);

// Clock and Reset Definitin
  `define PERIOD 20
  
  initial
    begin
      clk = 1'b1  ;
      reset = 1'b1;
      #1 reset = 1'b0;
    end

  always
    #(`PERIOD/2) clk = ~clk;


// Monitor Results
  initial
	begin
 	$timeformat ( -9, 0, "ns", 3 ) ;	//for details cf notes
 	$monitor ( "%t sign=%b A=%d B=%d S=%d",
        	$time,   sign,   A,   B,   S ) ;
	end
  // Verify Results for sum
  task xpect (input [31:0] expect_A, input [31:0] expect_B ) ;
	if ( S !== expects )
  	begin
    	$display ( "out is %d and should be %d", S, expects ) ;
    	$display ( "REGFILE TEST FAILED" );
    	$stop ;
  	end
  endtask
  
  
 // Apply Stimulus
 initial
	begin
    A = 4'd15; B = 4'd3; sign = 0; 1#ns xpect(4'd18)
    A = 4'd10; B = 4'd4; sign = 1; 1#ns xpect(4'd6)
  	$display ( "REGFILE TEST PASSED" ) ;
  	$stop ;
	end
endmodule

   //notes  
               
//$timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
	//Units number suggests the simulation precision time as specified by timescale.
	//Precision number is the number of integers displayed after decimal point.\
	//Suffix string is the string suffixed at the end of time.\
	//Minimum field width suggests the minimum number of characters used to display the time.
                                                 

