//==============================================================================
//  Filename    : bench_fetch_in        
//  Description : Testbench of the fetch stage module
//==============================================================================

module bench_fetch_in ();

timeunit      1ns;
timeprecision 1ns;

bit clk=1'b0;
bit reset;     
logic   [31:0]  pc_4;
logic   [31:0]  alu_in;
logic   pc_sel;
logic  [31:0]  pc_out;

fetch_in fetch_in1(
    .clk(clk),
    .rst(reset),
    .pc_4(pc_4),
    .alu_in(alu_in),
    .pc_sel(pc_sel),
    .pc_out(pc_out)

);

initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definition
`define PERIOD 10

  initial
    begin
      clk = 1'b1  ;
      reset = 1'b1;
      #1 reset = 1'b0;
    end

always
    #(`PERIOD/2) clk = ~clk;



  initial
    begin
      clk = 1'b1  ;
      reset = 1'b1;
      #1 reset = 1'b0;
    end

initial  forever
   begin  
    	pc_sel = 1;                                                                    
  	alu_in = 32'haaaaaaaa;
   	pc_4 = 32'h33333333;
	#100
    	pc_sel = 0;
	#100;

   end                                                                        

// Automatic checker to compare Filter value with expected Output

endmodule










