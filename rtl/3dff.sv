 module 3dff (clk, in, out);
    	input clk, in;
    	output out;
    	reg intermediate1;
    	reg intermediate2;
    	reg out;
    	
    	always@(posedge clk)
    		intermediate1 <= in;
    	always@(posedge clk)
    		intermediate2 <= intermediate1;
    	always@(posedge clk)
    		out <= intermediate2;
 endmodule
