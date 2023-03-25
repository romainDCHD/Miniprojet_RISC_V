//==============================================================================
//  Filename    : Control Logic module                                       
//  Designer    : Gaël Ousset
//  Description : Manage blocs across multiple instructions 
//==============================================================================

module control_logic (
    input  logic        clk,             // Main Clock
    input  logic        rst,             // Synchronous active high reset
    // Instruction
    input  logic [31:0] inst_i,          // Input instruction
    // Branch Comparator
    output logic        br_un_o,         // Unsigned comparison input of the branch comparator block
    input  logic        br_eq_i,         // Equal output of the branch comparator block
    input  logic        br_lt_i,         // Less than output of the branch comparator block
    // Multiplexers
    output logic        A1_sel_o,        // Select between the ALU previous output and the first register
    output logic        B1_sel_o,        // Select between the ALU previous output and the second register
    output logic        A2_sel_o,        // Select between the PC and the first mux output
    output logic        B2_sel_o,        // Select between the immediate value and the second mux output
    // ALU
    output logic [3:0]  alu_op_o,        // ALU operation
    // Memory
    output logic        mem_rw_o,        // Memory write enable
    // Writeback
    output logic        wb_sel1_o,       // Select between the data from the ALU and the data from the memory
    output logic        wb_sel2_o,       // Select between the data from the writeback and PC+4
    // Registers
    output logic        reg_w_en_o,      // Register write enable
    // PC
    output logic        pc_sel_o         // Select between the PC+4 and the branch target
);

    //== Variable Declaration ======================================================
    // Registers that will store instructions across multiple cycles
    logic [31:0] inst_reg0,
                 inst_reg1, 
                 inst_reg2;

    //== Main code =================================================================
    //----- Instruction registers
    always_ff @(posedge clk) begin
        if (rst) begin
            inst_reg0 <= 32'h00000000;
            inst_reg1 <= 32'h00000000;
            inst_reg2 <= 32'h00000000;
        end else begin
            inst_reg2 <= inst_reg1;
            inst_reg1 <= inst_reg0;
            inst_reg0 <= inst_i;
        end
    end

    //----- Execute stage
    always_comb begin
        //----- Default values
        A1_sel_o = 1'b0;                 // Select the first register
        B1_sel_o = 1'b0;                 // Select the second register
        A2_sel_o = 1'b0;                 // Select the first register
        B2_sel_o = 1'b0;                 // Select the second register
        alu_op_o = 4'b0000;              // ALU operation is NOP
        mem_rw_o = 1'b0;                 // Memory write is disabled
        wb_sel1_o = 1'b0;                // Select the data from memory
        wb_sel2_o = 1'b0;                // Select the data from the writeback
        reg_w_en_o = 1'b0;               // Register write is disabled
        pc_sel_o = 1'b0;                 // Select the PC+4
        br_un_o = 1'b0;                  // Unsigned comparison is disabled

        if (!rst) begin
            //----- Instruction decoding
            // Detecting dependencies, begin to check if the previous instruction has a result
            if (inst_reg1[6:0] != 7'b1100011 && inst_reg1[6:0] != 7'b0100011) begin
                // Check dependency on the first register
                if (inst_reg1[11:7] == inst_reg0[19:15]) begin
                    A1_sel_o = 1'b1;     // Select the ALU output
                end
                // Check if the current instruction require the second register
                if (inst_reg0[6:0] == 7'b1100011 || inst_reg0[6:0] == 7'b0100011 || inst_reg0[6:0] == 7'b0110011) begin
                    // Check dependency on the second register
                    if (inst_reg1[11:7] == inst_reg0[24:20]) begin
                        B1_sel_o = 1'b1;     // Select the ALU output
                    end
                end
            end
            // Check if the current instruction is a branch or a jump
            if (inst_reg0[6:0] == 7'b1100011 || inst_reg0[6:0] == 7'b1101111 || inst_reg0[6:0] == 7'b1100111)
                A2_sel_o = 1'b1;         // Select PC as ALU input
            // Check if the current instruction is a branch
            if (inst_reg0[6:0] == 7'b1100011) begin
                // Check if it is a unsigned comparison
                if (inst_reg0[14:13] == 2'b11)
                    br_un_o = 1'b1;      // Unsigned comparison is enabled
                // If the instruction is BEQ
                if (inst_reg0[14:12] == 3'b000)
                    // If the comparison is equal
                    if (br_eq_i) pc_sel_o = 1'b1; // Select the branch target
                // If the instruction is BNE
                if (inst_reg0[14:12] == 3'b001)
                    // If the comparison is not equal
                    if (!br_eq_i) pc_sel_o = 1'b1; // Select the branch target
                // If the instruction is BLT or BLTU
                if (inst_reg0[14:12] == 3'b100 || inst_reg0[14:12] == 3'b110)
                    // If the comparison is less than
                    if (br_lt_i) pc_sel_o = 1'b1; // Select the branch target
                // If the instruction is BGE or BGEU
                if (inst_reg0[14:12] == 3'b101 || inst_reg0[14:12] == 3'b111)
                    // If the comparison is greater than or equal
                    if (br_eq_i || !br_lt_i) pc_sel_o = 1'b1; // Select the branch target
            end
            // Check if the current instruction require an immediate value
            if (inst_reg0[6:0] != 7'b0110011)
                B2_sel_o = 1'b1;         // Select the immediate value
            // Select the ALU operation
            /* TODO */

            //----- Memory stage
            // Check if the current instruction is a store
            if (inst_reg1[6:0] == 7'b0100011)
                mem_rw_o = 1'b1;         // Memory write is enabled
            
            //----- Writeback stage
            // Check if the current instruction is a load
            if (inst_reg2[6:0] == 7'b0000011)
                wb_sel1_o = 1'b0;        // Select the data from memory
            // Check if the current instruction require to store PC+4
            if (inst_reg2[6:0] == 7'b1100111 || inst_reg2[6:0] == 7'b1101111)
                wb_sel2_o = 1'b1;        // Select the data from PC+4
            // Check if the current instruction is a branch or a jump
            if (inst_reg2[6:0] == 7'b1100011 || inst_reg2[6:0] == 7'b1101111 || inst_reg2[6:0] == 7'b1100111)
                pc_sel_o = 1'b1;        // Select the data from the branch target
            // Check if the current instruction is a branch or a store
            if (inst_reg2[6:0] == 7'b1100011 || inst_reg2[6:0] == 7'b0100011)
                reg_w_en_o = 1'b1;       // Register write is enabled
        end
    end
endmodule