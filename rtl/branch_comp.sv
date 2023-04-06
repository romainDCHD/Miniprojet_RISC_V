 //==============================================================================
//  Filename    : branch_comp     
//  Description : effectue une comparaison entre in_A et in_B (signée ou non, en fonction de BrUn) dont la valeur de retour est donnée par BrEq et BrLT
//============================================================================== 

 module branch_comp (
	input  logic [31:0]  in_A,
	input  logic [31:0]  in_B,
	input  logic   BrUn,
    	output logic   BrEq,
    	output logic   BrLT
);

logic signed [31:0]  in_A_s;
logic signed [31:0]  in_B_s;
assign in_A_s = in_A;
assign in_B_s = in_B;

    	always_comb //in_A, in_B, BrUn
    	begin
    		if(in_A == in_B)
    			begin	
    				assign BrEq = 1'b1;
    				assign BrLT = 1'b0;
    			end
    		else if (BrUn == 1'b1)
	    		begin
	    			if (in_A_s < in_B_s	)
		    			begin	
		    				assign BrEq = 1'b0;
		    				assign BrLT = 1'b1;
		    			end
	    			else 
		    			begin	
		    				assign BrEq = 1'b0;
		    				assign BrLT = 1'b0;
		    			end
	    		end
    		else
	    		begin
	    			if (in_A < in_B)
		    			begin	
		    				assign BrEq = 1'b0;
		    				assign BrLT = 1'b1;
		    			end
	    			else 
		    			begin	
		    				assign BrEq = 1'b0;
		    				assign BrLT = 1'b0;
		    			end
	    		end
    	end
    	
 endmodule
