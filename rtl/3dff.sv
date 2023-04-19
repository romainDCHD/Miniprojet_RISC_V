module three_dff (
    	input clk, reset,
		input [4:0]  in,
    	output reg [4:0] out
);
	reg [4:0] intermediate1;
	reg [4:0] intermediate2;
	reg [4:0] intermediate3;
			
	always_ff @(posedge clk)
	begin
		if (reset == 1)
		begin
			out           <= 1'b0;
			intermediate1 <= 1'b0;
			intermediate2 <= 1'b0;
		end
		else 
		begin
			intermediate1 <= in;
			intermediate2 <= intermediate1;	
			out           <= intermediate2;	    		
		end
	end

endmodule
