//==============================================================================
//  Filename    : wb
//  Description : étage de write back (entre l'étage de memoire et le fetch)
//==============================================================================

// Review par Gaël
// ATTENTION : Voir quel bloc gère les éléments synchrones
//             Non pris en compte ici

module wb ( 
    input   logic   clk,
    input   logic   rst,
    input   [31:0]  pc_4_i,
    input   [31:0]  alu_i,
    input   [31:0]  mem_i,
    input   [1:0]   wb_sel1_i,
    input   [1:0]   wb_sel2_i,
    // input   [1:0]   pc_sel_i,

    output  logic [31:0]  wb_o,
    output  logic [31:0]  datad_o
    // output  logic [31:0]  pc_o
    );

    //== Variable Declaration ======================================================
    logic   [31:0]  wb;

    //== Main code =================================================================
    //----- MUX entre alu, mem et wb
    always_comb // alu_i, mem_i, wb_sel1_i
    begin
        if (wb_sel1_i) wb = alu_i;
        else           wb = mem_i;
    end

    //----- MUX entre wb et pc_4
    always_comb // wb, pc_4_i, wb_sel2_i
    begin
        if (wb_sel2_i) wb_o = pc_4_i;
        else           wb_o = wb;
    end

    //----- MUX entre wb et pc_4
    // always_comb // wb, pc_4_i, pc_sel_i
    // begin
    //     if (pc_sel_i) pc_o = wb;
    //     else          pc_o = pc_4_i;
    // end

endmodule