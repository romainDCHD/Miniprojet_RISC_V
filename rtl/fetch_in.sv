module fetch_in ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc_4,
    input   [31:0]  wb,
    input   logic   pc_sel,
    output  logic [31:0]  pc_out
    );
    logic   [31:0]  PC_INIT = 32'h00000000;
    logic   [31:0]  pc;
    always_ff @(posedge clk)
    begin
        if(rst) pc_out = PC_INIT;
        else pc_out <= pc;

    end
    
    always_comb // pc_4, alu_in
    begin
        if(pc_sel) pc = pc_4;
        else pc = wb;
    end



endmodule

























