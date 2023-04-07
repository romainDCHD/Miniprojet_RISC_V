//==============================================================================
//  Description : Entry's Module of the first block "Fetch" 
//==============================================================================

module fetch_in ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc_4, //next programm counter in the list of instruction 
    input   [31:0]  wb, //programm counter that has been written back
    input   logic   pc_sel,//choice between pc+4 or wb
    output  logic [31:0]  pc_out //next PC to treat
    );
    //Choose to take the initial PC at 0
    logic   [31:0]  PC_INIT = 32'h00000000;
    logic   [31:0]  pc;

    //Synchrone MUX
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

























