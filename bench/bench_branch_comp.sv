//==============================================================================
//  Filename    : Testbench of the branch_comp module 
//  Description : Most exhausitive possible test for the branch_comp module
//==============================================================================
module bench_branch_comp();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;

//declaration des sigaux
logic  [31:0]  in_A;
logic  [31:0]  in_B;
logic  [1:0]   BrUn;
logic   BrEq;
logic   BrLT;

//declaration du module
branch_comp comp (
	.in_A	  ( in_A ),
	.in_B	  ( in_B ),
	.BrUn	  ( BrUn ),
	//output
    .BrEq	  ( BrEq ),
    .BrLT	  ( BrLT )
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
  // Verify Results for sum
  task xpect (input expect_BrEq, input expect_BrLT ) ;
  #3ns;
	if ( BrEq != expect_BrEq )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "BrEq is %d and should be %d", BrEq, expect_BrEq ) ;
	    	$display ( "REGFILE TEST FAILED ON BrEq" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
	end
  	
  	if ( BrLT != expect_BrLT )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "BrLT is %d and should be %d", BrLT, expect_BrLT ) ;
	    	$display ( "REGFILE TEST FAILED ON BrLT" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED WITH BrLT = %d AND BrEq = %d ", BrLT, BrEq);
  	end
  endtask
  
  
 // Apply Stimulus
 initial
	begin
    @(posedge clk) in_A = 32'b00000000000000000000000000000101; in_B = 32'b00000000000000000000000000000101; BrUn = 1'b0;  @(negedge clk) xpect(1'b1, 1'b0); //cas d'égalité non signé
    @(posedge clk) in_A = 32'b00000000000000000000000000000101; in_B = 32'b00000000000000000000000000000101; BrUn = 1'b1;  @(negedge clk) xpect(1'b1, 1'b0); //cas d'égalité signé
    @(posedge clk) in_A = 32'b00000000000000000000000000000101; in_B = 32'b10000000000000000000000000000101; BrUn = 1'b0;  @(negedge clk) xpect(1'b0, 1'b1); //inf non signé
    @(posedge clk) in_A = 32'b10000000000000000000000000000101; in_B = 32'b00000000000000000000000000000101; BrUn = 1'b0;  @(negedge clk) xpect(1'b0, 1'b0); //sup non signé
    @(posedge clk) in_A = 32'b00000000000000000000000000000101; in_B = 32'b10000000000000000000000000000101; BrUn = 1'b1;  @(negedge clk) xpect(1'b0, 1'b0); //inf  signé
    @(posedge clk) in_A = 32'b10000000000000000000000000000101; in_B = 32'b00000000000000000000000000000101; BrUn = 1'b1;  @(negedge clk) xpect(1'b0, 1'b1); //sup  signé

  	$display ( "TEST PASSED" ) ;
  	$stop ;
	end
endmodule

   /*notes
*  On va peut être avoir un problème au début avec le décalage d'addrD --> solution possible : mettre pour les deux premièr clk avec le rst 
  
               
*  $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
	//Units number suggests the simulation precision time as specified by timescale.
	//Precision number is the number of integers displayed after decimal point.\
	//Suffix string is the string suffixed at the end of time.\
	//Minimum field width suggests the minimum number of characters used to display the time.
   */
