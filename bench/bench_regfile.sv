//==============================================================================
//  Filename    : Testbench of the register module                                        
//  Designer    : Romain DUCHADEAU
//  Description : Most exhausitive possible test for the register module
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


riscv_regfile regfile (
    .clk_i	  ( clk ),
    .rst_i	  ( reset ),	
    .AddrD_i	  ( AddrD ),
    .DataD_i	  ( DataD ),
    .AddrB_i	  ( AddrB ),
    .AddrA_i	  ( AddrA ),
    .RegWEn_i	  ( RegWEn ),
    //output
    .DataA_o	  ( DataA ),
    .DataB_o	  ( DataB )	 
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
  $monitor ( "time=%t, RegWEn=%b, reset=%d, AddrA=%d, AddrB=%d, AddrD=%d, DataD=%d, DataA=%d, DataB=%d",
            $time,   RegWEn, reset, AddrA,  AddrB, AddrD, DataD, DataA , DataB  ) ;
	end
  // Verify Results for sum
  task xpect (input [31:0] expect_A, input [31:0] expect_B ) ;
  #3ns;
	if ( DataA != expect_A )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "DataA is %d and should be %d", DataA, expect_A ) ;
	    	$display ( "REGFILE TEST FAILED ON A" );
	    	$display ( "--------------------------------------------------------------" );
	    	//$stop ;
  	end
  	
  if ( DataB != expect_B )
  begin
    $display ( "--------------------------------------------------------------" );
      $display ( "DataB is %d and should be %d", DataB, expect_B ) ;
      $display ( "REGFILE TEST FAILED ON B" );
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
    @(posedge clk)
    //sans bulles
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h0; AddrB = 5'h1; AddrD = 5'h2; DataD = 32'd14; 
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h0; AddrB = 5'h1; AddrD = 5'h3; DataD = 32'd15; @(negedge clk) xpect(32'd0, 32'd0); //attente pour les 3clk
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h0; AddrB = 5'h1; AddrD = 5'h8; DataD = 32'd15; @(negedge clk) xpect(32'd0, 32'd0); //attente pour les 3clk
    @(posedge clk) RegWEn = 1'b1; AddrA = 5'h0; AddrB = 5'h1; AddrD = 5'h4; DataD = 32'd16; @(negedge clk) xpect(32'd0, 32'd0); //remplir R2 (3clk avant) avec 16
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h2; AddrB = 5'h1; AddrD = 5'h3; DataD = 32'd17; @(negedge clk) xpect(32'd16, 32'd0); //rien, voir si bien ecrit
    @(posedge clk) RegWEn = 1'b1; AddrA = 5'h2; AddrB = 5'h8; AddrD = 5'h5; DataD = 32'd18; @(negedge clk) xpect(32'd16, 32'd0); //lire R8 / ecrire 18 dans R8
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h8; AddrB = 5'h8; AddrD = 5'h6; DataD = 32'd14; @(negedge clk) xpect(32'd16, 32'd18); //Lire le meme registre
    @(posedge clk) RegWEn = 1'b0; AddrA = 5'h0; AddrB = 5'h0; AddrD = 5'h3; DataD = 32'd14; @(negedge clk) xpect(32'd18, 32'd18); //rien, voir si bien ecrit

  	$display ( "REGFILE TEST PASSED" ) ;
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
