module test_mem ();

timeunit      1ns;
timeprecision 1ns;

bit clk=1'b0;
bit reset;     
logic   dmem;
logic   [31:0]  data_w;
//logic   [31:0]  r_mem[3:0];
logic   [31:0]  addr;
logic [31:0]  data_r;


mem #(3) mem1(
    .clk(clk),
    .rst(reset),
    .dmem(dmem),
    .data_w(data_w),
    .addr(addr),
    .data_r(data_r)
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
    // r_mem[0] = 32'haaaaaaaa;
    // r_mem[1] = 32'hbbbbbbbb;
    // r_mem[2] = 32'hcccccccc;
    // r_mem[3] = 32'hdddddddd;
    dmem = 0;
    data_w = 32'haaaaaaaa;
    addr = 0;
	  #100
    data_w = 32'hbbbbbbbb;
    addr = 1;
	  #100
    data_w = 32'hcccccccc;
    addr = 2;
	  #100
    data_w = 32'hdddddddd;
    addr = 3;
	  #100
    addr = 2;
    dmem = 1;
  	#100;
   end                                                                        

// Automatic checker to compare Filter value with expected Output

endmodule










