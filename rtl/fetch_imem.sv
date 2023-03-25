module fetch_imem ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]tab_inst[n:0],
    input   [31:0]  addr,

    output  [31:0]  inst_out,
    )

    logic  [31:0]  inst;
    logic   [8:0]  count = 0;
    alwaysff(posedge clk)
    begin
        if(rst) begin
            inst_out <=0;
            count <= 0;
        end
        else begin
            inst_out = inst;
        end
    end
    
    always @* begin
        count = addr>>2;
        inst = tab_inst[count];

    end



endmodule    