//==============================================================================
//  Filename    : bench_mem
//  Description : fichier test de mem (l'étage de mémoire donnée)
//==============================================================================

module bench_mem ();

timeunit      1ns;
timeprecision 1ns;

bit clk;
bit reset;     
logic   dmem;
logic   [31:0]  data_w;
logic   [31:0]  addr;
logic   [31:0]  data_o;
logic   [31:0]  alu_o;
logic   [1:0]   dataSec;


mem #(11) mem1(
    .clk	      ( clk    ),
    .rst	      ( reset  ),
    .memRW     ( dmem   ),
    .dataSec_i  (dataSec),
    .dataW_i    ( data_w ),
    .addr_i     ( addr   ),
    .alu_o     ( alu_o ),
    .data_o   (data_o)
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
    #100
    dmem = 0; data_w = 32'haaaaaaaa; addr = 32'h0; dataSec = 2'b10; //ecriture dans registre 0
    #20
    dmem = 0; data_w = 32'hbbbbbbbb; addr = 32'h4; dataSec = 2'b01;//ecriture dans registre 0
    #20
    dmem = 0; data_w = 32'hcccccccc; addr = 32'h8; dataSec = 2'b00; //ecriture dans registre 2
    #20
    dmem = 1; data_w = 32'hcccccccc; addr = 32'h6; //lecture dans registre 2
    #20
    dmem = 1; data_w = 32'hcccccccc; addr = 32'h0; //lecture dans registre 2
    #20
    dmem = 1; data_w = 32'hcccccccc; addr = 32'h11; //lecture dans registre 2
    
    
  	$display ( "MEM TEST FINISHED" ) ;
  	$stop ;
   end                                                                        

endmodule
