//==============================================================================
//  Filename    : bench_opti     
//  Description : Testbench of the execute module (between registers and ALU) 
//==============================================================================

module bench_opti();

timeunit      1ns;
timeprecision 1ns;

bit clk=1'b0;
bit rst;
logic A1_sel;
logic B1_sel;
logic A2_sel;
logic B2_sel;
logic Brun;
logic BrLt;
logic BrEq;
logic [31:0] Rs1;
logic [31:0] Rs2;
logic [31:0] alu;
logic [31:0] pc;
logic [31:0] reg1;
logic [31:0] reg2;
logic [31:0] Imm;
logic [31:0] data_w;


initial $timeformat ( -9, 1, " ns", 12 );

// Clock and Reset Definition

`define PERIOD 10

  initial
    begin
      clk = 1'b1  ;
      rst = 1'b1;
      #1 rst = 1'b0;
    end

always
    #(`PERIOD/2) clk = ~clk;

opti opti1(
    .clk(clk),
    .rst(rst),
    .A1_sel(A1_sel),
    .B1_sel(B1_sel),
    .A2_sel(A2_sel),
    .B2_sel(B2_sel),
    .Brun(BrUn),
    .Breq(BrEq),
    .Brlt(BrLt),
    .reg_rs1(Rs1),
    .reg_rs2(Rs2),
    .alu(alu),
    .pc(pc),
    .imm(Imm),
    .reg1(reg1),
    .reg2(reg2),
    .data_w(data_w)
);

  task xpect (input [31:0] expect_A, input [31:0] expect_B, input [31:0] expect_C ) ;
  #3ns;
	if ( reg1 != expect_A )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "reg1 is %d and should be %d", reg1, expect_A ) ;
	    	$display ( "REGFILE TEST FAILED ON 1" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  	
  	if ( reg2 != expect_B )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "reg2 is %d and should be %d", reg2, expect_B ) ;
	    	$display ( "REGFILE TEST FAILED ON 2" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
    
    if ( data_w != expect_C )
  	begin
	  	$display ( "--------------------------------------------------------------" );
	    	$display ( "data_w is %d and should be %d", data_w, expect_C ) ;
	    	$display ( "REGFILE TEST FAILED ON W" );
	    	$display ( "--------------------------------------------------------------" );
	    	$stop ;
  	end
  	
  	else 
  	begin
  		$display ( "ATOMIC TEST PASSED" );
  	end
  endtask

initial forever
begin
Rs1 = 32'haaaaaaaa;
Rs2 = 32'hcccccccc;
alu = 32'hdddddddd;
pc = 32'heeeeeeee;
Imm = 32'hffffffff;
@(posedge clk)
@(posedge clk) A1_sel = 1'b0; A2_sel = 1'b0; B1_sel = 1'b0; B2_sel = 1'b0; 
@(negedge clk) xpect(Rs1, Rs2, Rs2);
@(posedge clk) A1_sel = 1'b1; A2_sel = 1'b0; B1_sel = 1'b1; B2_sel = 1'b0; 
@(negedge clk) xpect(alu, alu, alu);
@(posedge clk) A1_sel = 1'b1; A2_sel = 1'b1; B1_sel = 1'b1; B2_sel = 1'b1; 
@(negedge clk) xpect(pc, Imm, alu);


end    


endmodule
