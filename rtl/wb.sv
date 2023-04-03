module wb_out ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc_4,
    input   [31:0]  alu,
    input   [31:0]  mem,
    input   [2:0]   wb_sel,
    output  logic [31:0]  wb
    );

    logic   [31:0]  wb_o;
    always_ff @(posedge clk)
    begin
        if(rst) begin
            wb = 0
        end
        else wb = wb_o;

    end
    
    always_comb // pc_4, alu_in
    begin
        if(wb_sel == 2'b00) wb_o = pc_4;
        else if(wb_sel == 2'b01) pc = alu;
        else if(wb_sel == 2'b10) pc = mem;
    end



endmodule

























