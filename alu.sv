//==============================================================================
//  Filename    : ALU module                                        
//  Designer    : Romain DUCHADEAU
//  Description : Perform operations with variables 
//==============================================================================

 
 module riscv_alu (
     // Inputs
      input  [  3:0]  alu_op_i
     ,input  [ 31:0]  alu_a_i
     ,input  [ 31:0]  alu_b_i

     // Outputs
     ,output [ 31:0]  alu_result_o
 );
 
 `define ADD 0		// also used for BEQ, BNE, BGE, BGEU, AUIPC
 `define AND 6
 `define BEQ 8
 `define SLL 7
 `define SRL 8
 `define OR 5
 `define XOR 4
 `define OUT_ONE 2	// usefull for SLT, SLTU instructions
 `define OUT_ZERO 2
 `define SRA 9
 `define LUI 8		// just take the immediate value (already returned on the right format)
 `define SUB 1
 

reg [31:0]      result_r;
reg[4:0]        buffer;
wire byte_zero;
wire byte_one;

assign byte_zero	<= 32'h00000000;
assign byte_one		<= 32'h11111111;

//-----------------------------------------------------------------
// ALU
//-----------------------------------------------------------------
always @ (alu_op_i or alu_a_i or alu_b_i)
begin
    case (alu_op_i)         
       //----------------------------------------------
       // Arithmetic
       //----------------------------------------------
       `ADD : 
       begin
            result_r      = (alu_a_i + alu_b_i);
       end
       `SUB : 
       begin
            result_r      = (alu_a_i - alu_b_i);
       end
       //----------------------------------------------
       // Logical
       //----------------------------------------------       
       `AND : 
       begin
            result_r      = (alu_a_i & alu_b_i);
       end
       `OR  : 
       begin
            result_r      = (alu_a_i | alu_b_i);
       end
       `XOR : 
       begin
            result_r      = (alu_a_i ^ alu_b_i);
       end
       //----------------------------------------------
       // Shift
       //----------------------------------------------
       `SLL : 
       begin
       	    buffer	 <= alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r      = (alu_a_i << buffer);
       end
       `SRL : 
       begin
            buffer	 <= alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r      = (alu_a_i >> buffer);
       end
       `SRA : 
       begin
            buffer	 <= alu_b_i[4:0];//ne sais pas si ça marche pour prendre les bits de poids faible
            result_r      = (alu_a_i >>> buffer);
       end
       `LUI : 
       begin
            result_r      = (alu_b_i);
       end
       //----------------------------------------------
       // Others
       //----------------------------------------------
       `OUT_ONE : 
       begin
            result_r      = byte_one;
       end
       `OUT_ZERO : 
       begin
            result_r      = byte_zero;
       end
       
       
    endcase
end

assign alu_result_o    = result_r;

endmodule0
