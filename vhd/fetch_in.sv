module fetch_in ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc_4,
    input   [31:0]  alu_in,
    input   logic   pc_sel,
    output  [31:0]  pc_out,
    )
    logic   [31:0]  PC_INIT = 32'h00000000;
    logic   [31:0]  pc;
    alwaysff(posedge clk)
    begin
        if(rst) pc_out = PC_INIT;
        else pc_out <= pc;

    end
    
    always @* begin
        if(pc_sel) pc = pc_4;
        else pc = alu_in;
    end



endmodule

























