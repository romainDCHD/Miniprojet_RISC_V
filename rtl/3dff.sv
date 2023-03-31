 module three_dff (
    	input clk, reset,
	input [4:0]  in,
    	output logic [4:0] out
);
    	reg [4:0] intermediate1;
    	reg [4:0] intermediate2;
    	reg [4:0] intermediate3;
		    	
    	always_ff @(posedge clk)
		begin
		if (reset == 1)
			begin
				assign out = 1'b0;
				intermediate1 <= 1'b0;
				intermediate2 <= 1'b0;
			end
		else 
			begin
		    		intermediate1 <= in;
		    		intermediate2 <= intermediate1;	
		    		intermediate3 <= intermediate2;		    		
			end
		end
	always_ff @(posedge clk)
		begin
		assign out = intermediate3;
		end
 endmodule
