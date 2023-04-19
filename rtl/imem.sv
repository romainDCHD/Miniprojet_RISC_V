//==============================================================================
//  Description : Instruction memory module (charged in instruction direclty in the general testbench) 
//==============================================================================

module imem #(parameter  n=20) 
( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc,
    output  logic [31:0]  inst_out
  );
   
    logic [31:0]  tab_inst [n:0];
    logic  [31:0]  inst;
    logic   [8:0]  count = 0;

    always_ff @(posedge clk)
    begin
        if(rst) begin
            inst_out <=0;
        end
        else begin
            inst_out <= inst;
        end
    end
    
    always_comb// tab_inst, addr, pc
      begin
        count = pc/4;
        inst = tab_inst[count];
     end


endmodule    