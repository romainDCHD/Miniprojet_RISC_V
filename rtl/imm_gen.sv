//==============================================================================
//  Filename    : Control Logic module                                       
//  Designer    : Antoine Chastand
//  Description : Prepare the immediate value for the ALU. Reviewed by Gaël
//==============================================================================

module imm_gen ( 
		 input   logic         clk,
		 input   logic         rst,
		 input         [2:0]   sel_i,     // Indicates the type of instruction
		 input         [31:0]  imm_i,     // Input instruction
		 output  logic [31:0]  imm_o      // Output immediate value
);

//== Variable Declaration ======================================================
    logic [31:0] imm;                     // Asynchronous immediate value

    // Immediate selection
    typedef enum  {
        IMM_DEFAULT,
        IMM_REGIMM,
        IMM_LOAD,
        IMM_STORE,
        IMM_BRANCH,
        IMM_JALR,
        IMM_JAL,
        IMM_UPPER
    } imm_sel_t;

//== Main code =================================================================
    always_ff @(posedge clk)
    begin
        if(rst) begin
           imm_o <=0;
        end
        else begin
           imm_o <= imm;
        end
      end
 
    always_comb begin                     // sel_i,imm_i
        // Checking if the value is negative
        if (imm_i[31] == 1'b1)
            imm = 32'hFFFFFFFF;
        else
            imm = 0;
        
        case(sel_i)
            IMM_DEFAULT : imm = 0;
            IMM_REGIMM  : imm[11:0] = imm_i[31:20];
            IMM_LOAD    : imm[11:0] = imm_i[31:20];
            IMM_STORE   : begin
                imm[4:0]   = imm_i[11:7 ];
                imm[11:5]  = imm_i[31:25];
            end
            IMM_BRANCH  : begin
                imm[10:5]  = imm_i[30:25];
                imm[4:1]   = imm_i[11:8];
                imm[12]    = imm_i[31];
                imm[11]    = imm_i[7];
            end
            IMM_JALR    : imm[11:0] = imm_i[31:20];
            IMM_JAL     : begin
                imm[19:12] = imm_i[19:12];
                imm[11]    = imm_i[20];
                imm[10:1]  = imm_i[30:21];
                imm[20]    = imm_i[31];
            end
            IMM_UPPER   : imm = imm_i[31:12];
        endcase
    end
 /*
    always_comb// sel_i,imm_i
      begin
 	imm = 0;
 	if(sel_i == 3'b001) begin 
            imm[11:0] = imm_i[31:20];
 
 	end
 	else if(sel_i == 3'b010)begin
            imm[10:5] = imm_i[30:25];
            imm[4:1] = imm_i[11:8];
            imm[12] = imm_i[31];
            imm[11] = imm_i[1];
 	end
 	else if(sel_i == 3'b011)begin
            imm[20:0] = imm_i[31:12];
 	end
 	else if(sel_i == 3'b100) begin
            imm[4:0] = imm_i[24:20];
 	end
      end
 */
endmodule