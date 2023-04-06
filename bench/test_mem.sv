//==============================================================================
//  Filename    : test_mem
//  Description : fichier test de mem (l'étage de mémoire donnée)
//==============================================================================

module test_mem ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;     
logic   dmem;
logic   [31:0]  data_w;
logic   [31:0]  addr;
logic   [31:0]  data_o;


mem #(5) mem1(
    .clk	( clk    ),
    .rst	( reset  ),
    .dmem       ( dmem   ),
    .data_w     ( data_w ),
    .addr	( addr   ),
    .data_o     ( data_o )
);

initial 
	begin
		$timeformat ( -9, 1, " ns", 12 );
		$monitor ("data_o=%d",data_o);
	end

// Clock and Reset Definition
`define PERIOD 20

  initial
    begin
      clk <= 1'b0  ;
      reset <= 1'b1;
      #21 reset <= 1'b0;
    end

always
    #(`PERIOD/2) clk = ~clk;



initial
   begin  
    @(posedge clk) dmem = 0; data_w = 32'haaaaaaaa; addr = 32'h0; //ecriture dans registre 0
    @(posedge clk) dmem = 0; data_w = 32'haaaaaaaa; addr = 32'h0; //ecriture dans registre 0
    @(posedge clk) dmem = 0; data_w = 32'hbbbbbbbb; addr = 32'h3; //ecriture dans registre 2
    @(posedge clk) dmem = 1; data_w = 32'hcccccccc; addr = 32'h3; //lecture dans registre 2
    @(posedge clk) dmem = 1; data_w = 32'hcccccccc; addr = 32'h0; //lecture dans registre 2
    @(posedge clk) dmem = 1; data_w = 32'hcccccccc; addr = 32'h0; //lecture dans registre 2
    
    
  	$display ( "MEM TEST FINISHED" ) ;
  	$stop ;
   end                                                                        

endmodule
