//==============================================================================
//  Filename    : wb
//  Description : étage de whrite back (entre l'étage de memoire donné et imem)
//==============================================================================

module wb ( 
    input   logic   clk,
    input   logic   rst,
    // sortie de l'étage memory
    input   [31:0]  alu_i,
    input   [31:0]  mem_i,
    //selection
    input   logic [1:0] wb_sel1_i,
    input   logic [1:0] wb_sel2_i,
    input   logic [1:0] pc_sel_i,

    output  logic [31:0]  dataD_o,
    output  logic [31:0]  pc_o
    );

    //== Variable Declaration ======================================================
    logic   [31:0]  wb;
    logic   [31:0]  pc_r;
    logic   [31:0]  pc_4_r;


    //----------envoyer le pc de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if (rst) pc_o <= 1'b0;
        else     pc_o <= pc_r;
    end

    
    
    //---------MUX entre alu/mem et wb-------------------
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if (wb_sel1_i) wb = alu_i;
        else           wb = mem_i;
    end

    //---------MUX entre imem et regfile-------------------
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if (wb_sel2_i) dataD_o = wb;
        else           dataD_o = pc_4_r;
    end

    //---------MUX entre wb et pc_4------------------------
    always_comb // wb, pc_4_i, wb_sel2_i
    begin
        if (pc_sel_i) pc_r = pc_4_r;
        else          pc_r = wb;
    end

    //--------ADD pour faire le PC+4-----------
    always_comb // wb, pc_4, wb_sel2_i
    begin
        pc_4_r = pc_o + 32'h4 ;//pas sur que ça marche
    end

endmodule