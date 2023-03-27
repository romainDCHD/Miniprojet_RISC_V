module test_imm_gen ();

timeunit      1ns;
timeprecision 1ns;

bit clk=1'b0;
bit reset;     
logic   [2:0]   sig; 
logic  [31:0]  imm_in;
logic  [31:0]  imm_out;


imm_gen imm_gen1(
    .clk(clk),
    .rst(rst),
    .sig(sig),
    .imm_in(imm_in),
    .imm_out(imm_out)
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


initial  forever
   begin  
    sig = 3'b001;                                                                    
  	imm_in = 32'hffffffff;
	#100
    sig = 3'b010;
	#100
    sig = 3'b011;
    #100
    sig = 3'b100;
    #100;
   end                                                                        

// Automatic checker to compare Filter value with expected Output

endmodule










