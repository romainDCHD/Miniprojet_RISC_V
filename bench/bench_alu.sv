//==============================================================================
//  Filename    : Testbench of the alu module        
//  Description : Most exhausitive possible test for the alu module
//==============================================================================
module bench_alu();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;
logic  [  3:0]  alu_op;
logic  [ 31:0]  alu_a;
logic  [ 31:0]  alu_b;
logic [ 31:0]  alu_result;

alu Alu (
     // Inputs
      .alu_op_i	  ( alu_op ),
      .alu_a_i	  ( alu_a ),
      .alu_b_i	  ( alu_b ),
      .clk	  ( clk   ),
     // Outputs
      .alu_result_o  ( alu_result )
 );


// Clock and Reset Definitin
  `define PERIOD 20
  
  initial
    begin
      clk <= 1'b0  ;
    end

  always
    #(`PERIOD/2) clk = ~clk;


// Monitor Results
  initial
	begin
 	$timeformat ( -9, 0, "ns", 3 ) ;	//for details cf notes
	end
	
  // Verify Results
  task xpect (input [31:0] expect_ ) ;
  #3ns;
	if ( alu_result != expect_ )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "alu_result is %d and should be %d", alu_result, expect_ ) ;
	    	$display ( "REGFILE TEST FAILED" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  endtask
  
  
 // Apply Stimulus
 initial
	begin
    @(posedge clk)
    //sans bulles
    @(posedge clk) alu_op = 4'h0; alu_a = 32'h3; alu_b = 32'h4; //ADD (overflow comment on gère?) note : les tests sont décalés d'une clk
    @(posedge clk) alu_op = 4'h1; alu_a = 32'b10011; alu_b = 32'b10101; @(negedge clk) xpect(32'h7); //AND (test du ADD)
    @(posedge clk) alu_op = 4'h2; alu_a = 32'b11000000000000000000000000110000; alu_b = 32'h3; @(negedge clk) xpect(32'b00000000000000000000000000010001); //SLL (overflow -> 0 with logical)
    @(posedge clk) alu_op = 4'h3; alu_a = 32'b00000000000000000000000000110001; alu_b = 32'h3; @(negedge clk) xpect(32'b00000000000000000000000110000000); //SRL
    @(posedge clk) alu_op = 4'h4; alu_a = 32'b10011; alu_b = 32'b10101; @(negedge clk) xpect(32'b00000000000000000000000000000110); //OR
    @(posedge clk) alu_op = 4'h5; alu_a = 32'b10011; alu_b = 32'b10101; @(negedge clk) xpect(32'b10111); //XOR
    @(posedge clk) alu_op = 4'h6; alu_a = 32'b10011; alu_b = 32'b10101; @(negedge clk) xpect(32'b00110); //OUT_ONE
    @(posedge clk) alu_op = 4'h7; alu_a = 32'b10011; alu_b = 32'b10101; @(negedge clk) xpect(32'b1); //OUT_ZERO
    @(posedge clk) alu_op = 4'h8; alu_a = 32'b10000000000000000000000000110000; alu_b = 32'h4; @(negedge clk) xpect(32'b0); //SRA
    @(posedge clk) alu_op = 4'h9; alu_a = 32'b10000000000000000000000000110000; alu_b = 32'h56; @(negedge clk) xpect(32'b1000000000000000000000000011); //LUI
    @(posedge clk) alu_op = 4'h0; alu_a = 32'b0; alu_b = 32'b0; @(negedge clk) xpect(32'b1010110000000000000000000000000); //test LUI

  	$display ( "TEST PASSED" );
  	$stop ;
	end
endmodule
   /*   notes:
               
*  $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
	//Units number suggests the simulation precision time as specified by timescale.
	//Precision number is the number of integers displayed after decimal point.\
	//Suffix string is the string suffixed at the end of time.\
	//Minimum field width suggests the minimum number of characters used to display the time.
   */
