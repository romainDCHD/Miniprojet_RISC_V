//==============================================================================
//  Filename    : wb
//  Description : étage de whrite back (entre l'étage de memoire donné et imem)
//==============================================================================

module wb ( 
    input   logic         clk,
    input   logic         rst,
    // sortie de l'étage memory
    input   logic [31:0]  alu_i,
    input   logic [31:0]  mem_i,
    //selection
    input   logic         wb_sel1_i,
    input   logic         wb_sel2_i,
    input   logic         pc_sel_i,

    output  logic [31:0]  dataD_o,
    output  logic [31:0]  pc_o
    );

    //== Variable Declaration ======================================================
    reg   [31:0]  wb;
    reg   [31:0]  pc_r;
    reg   [31:0]  pc_4_r;


    //----------envoyer le pc de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if  (rst)
        begin
             pc_o <= 32'b0;
        end
        else      
        begin
            pc_o <= pc_r;
        end 
    end

    
    
    //---------MUX entre alu/mem et wb-------------------
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if  (wb_sel1_i == 1) wb <= alu_i;
        else                 wb <= mem_i;
    end

    //---------MUX entre imem et regfile-------------------
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if  (wb_sel2_i == 1) dataD_o <= pc_4_r;
        else                 dataD_o <= wb;
    end

    //---------MUX entre wb et pc_4------------------------
    always_comb // wb, pc_4_i, wb_sel2_i
    begin
        if  (pc_sel_i == 1) pc_r <= wb;
        else                pc_r <= pc_4_r;
    end

    //--------ADD pour faire le PC+4-----------
    always_comb // wb, pc_4, wb_sel2_i
    begin
        pc_4_r <= pc_o + 32'h4 ;
    end

endmodule