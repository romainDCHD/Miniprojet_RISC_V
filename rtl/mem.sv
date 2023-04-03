module mem #(parameter  n=20) 
( 
    input   logic   clk,
    input   logic   rst,
    input   logic   dmem,
    input   [31:0]  data_w,
    input   [31:0]  addr,
    output  logic [31:0]  data_r
  );
    logic   [31:0]  r_mem[n:0];
    logic   [7:0]  m;
    logic  [31:0]  data_o;
    //logic   [8:0]  count = 0;
    always_ff @(posedge clk)
    begin
        if(rst) begin
            data_r <=0;
        end
        else begin
            data_r <= data_o;
        end
    end
    
    always_comb// dmem, data_w, addr
      begin
        m = addr;
        if(dmem) begin
            data_o = r_mem[m];
        end
        else begin
            r_mem[m] = data_w;
            data_o = 0;
        end

    end



endmodule    