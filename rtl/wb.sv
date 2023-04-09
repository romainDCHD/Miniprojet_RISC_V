//==============================================================================
//  Filename    : wb
//  Description : étage de whrite back (entre l'étage de memoire et le fetch)
//==============================================================================

module wb ( 
    input   logic   clk,
    input   logic   rst,    //synchrone
    input   [31:0]  alu_i,
    input   [31:0]  mem_i,
    //selection
    input   wb_sel_i,
    input   pc_sel_i,

    output  logic [31:0]  pc_o
    );

    //== Variable Declaration ======================================================
    logic   [31:0]  wb;
    logic   [31:0]  pc_4_r,
    logic   [31:0]  alu_r,
    logic   [31:0]  mem_r,
    logic   [31:0]  pc_4,


    //----------envoyer le pc de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if (rst) pc_o <= 0;
        else     pc_o <= wb;
    end

    //----------recevoir sortie de memory/execute de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if (rst) 
        begin
            pc_4_r <= 0;
            alu_r <= 0;
            mem_r <= 0;
        end
        else     
        begin
            pc_4_r <= pc_4;
            alu_r <= alu_i;
            mem_r <= mem_i;
        end
    end
    
    //---------MUX entre alu/mem et wb-------------------
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if (wb_sel_i) wb <= alu_r;
        else          wb <= mem_r;
    end

    //---------MUX entre wb et pc_4------------------------
    always_comb // wb, pc_4_i, wb_sel2_i
    begin
        if (pc_sel_i) pc_o <= pc_4_r;
        else          pc_o <= wb;
    end

    //--------ADD pour faire le PC+4-----------
    always_comb // wb, pc_4, wb_sel2_i
    begin
        pc_4 <= pc_o + 32'b4 //pas sur que ça marche
    end

endmodule
