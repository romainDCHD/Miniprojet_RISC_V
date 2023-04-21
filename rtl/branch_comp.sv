 //==============================================================================
//  Filename    : branch_comp     
//  Description : effectue une comparaison entre A_i et B_i (signée ou non, en fonction de BrUn_i) dont la valeur de retour est donnée par BrLT_o et BrLT_o
//============================================================================== 

 module branch_comp (
	input  logic [31:0] A_i,
	input  logic [31:0] B_i,
	input  logic   		BrUn_i,
    output logic   		BrEq_o,
    output logic   		BrLT_o
);

logic signed [31:0]  A_i_s;
logic signed [31:0]  B_i_s;
assign A_i_s = A_i;
assign B_i_s = B_i;

    	always_comb //A_i, B_i, BrUn_i
    	begin
    		if(A_i == B_i)
    			begin	
    				BrEq_o = 1'b1;
    				BrLT_o = 1'b0;
    			end
    		else if (BrUn_i == 1'b1)
	    		begin
	    			if (A_i_s < B_i_s	)
		    			begin	
		    				BrEq_o = 1'b0;
		    				BrLT_o = 1'b1;
		    			end
	    			else 
		    			begin	
		    				BrEq_o = 1'b0;
		    				BrLT_o = 1'b0;
		    			end
	    		end
    		else
	    		begin
	    			if (A_i < B_i)
		    			begin	
		    				BrEq_o = 1'b0;
		    				BrLT_o = 1'b1;
		    			end
	    			else 
		    			begin	
		    				BrEq_o = 1'b0;
		    				BrLT_o = 1'b0;
		    			end
	    		end
    	end
    	
 endmodule
