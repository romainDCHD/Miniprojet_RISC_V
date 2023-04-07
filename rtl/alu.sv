//==============================================================================
//  Filename    : ALU module
//  Description : Perform mathematical operations between alu_a and alu_b
//==============================================================================
 
 module alu (
     // Inputs
      input  [  3:0]  alu_op_i
     ,input  [ 31:0]  alu_a_i
     ,input  [ 31:0]  alu_b_i
     ,input clk

     // Outputs
     ,output logic [ 31:0]  alu_result_o
 );
  
 typedef enum  {
        ADD,		// Also used for BEQ, BNE, BGE, BGEU, AUIPC
        AND,
        SLL,
        SRL,
        OR,
        XOR,
        OUT_ONE,    // Usefull for SLT, SLTU instructions
        OUT_ZERO,
        SRA,
        LUI,		// Just take the immediate value (already returned on the right format)
        SUB
    } alu_op_t;

reg [31:0]      result_r;
reg[4:0]        buffer;
wire byte_zero;
wire byte_one;

assign byte_zero = 32'h00000000;
assign byte_one  = 32'h11111111;

//-----------------------------------------------------------------
// ALU
//-----------------------------------------------------------------
always @ (alu_op_i or alu_a_i or alu_b_i)
begin
    case (alu_op_i)         
       //----------------------------------------------
       // Arithmetic
       //----------------------------------------------
       ADD : 
       begin
            result_r      = (alu_a_i + alu_b_i);
       end
       SUB : 
       begin
            result_r      = (alu_a_i - alu_b_i);
       end
       //----------------------------------------------
       // Logical
       //----------------------------------------------       
       AND : 
       begin
            result_r      = (alu_a_i & alu_b_i);
       end
       OR  : 
       begin
            result_r      = (alu_a_i | alu_b_i);
       end
       XOR : 
       begin
            result_r      = (alu_a_i ^ alu_b_i);
       end
       //----------------------------------------------
       // Shift
       //----------------------------------------------
       SLL : 
       begin
       	    buffer	 = alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r     = (alu_a_i << buffer);
       end
       SRL : 
       begin
            buffer	 = alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r     = (alu_a_i >> buffer);
       end
       SRA : 
       begin
            buffer	  = alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r      = (alu_a_i >>> buffer);
       end
       LUI : 
       begin
            result_r      = (alu_b_i << 12);
       end
       //----------------------------------------------
       // Others
       //----------------------------------------------
       OUT_ONE : 
       begin
            result_r      = byte_one;
       end
       OUT_ZERO : 
       begin
            result_r      = byte_zero;
       end
       
       
    endcase
end

always_ff @(posedge clk)
	alu_result_o  <= result_r;

endmodule
