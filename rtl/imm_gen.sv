module imm_gen ( 
		 input   logic   clk,
		 input   logic   rst,
		 input   [2:0]  sig,
		 input   [31:0]  imm_in,
		 output  logic [31:0]  imm_out
		 );


  logic [31:0] imm;

   always_ff @(posedge clk)
     begin
        if(rst) begin
           imm_out <=0;
        end
        else begin
           imm_out <= imm;
        end
     end

   always_comb// sig,imm_in
     begin
	imm = 0;
	if(sig == 3'b001) begin 
           imm[11:0] = imm_in[31:20];

	end
	else if(sig == 3'b010)begin
           imm[12:5] = imm_in[31:25];
           imm[4:0] = imm_in[11:7];
	end
	else if(sig == 3'b011)begin
           imm[20:0] = imm_in[31:12];
	end
	else if(sig == 3'b100) begin
           imm[4:0] = imm_in[24:20];
	end
     end

endmodule