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
    output logic [1:0]  A1_sel_o,        // Select between the ALU previous output and the first register
    output logic [1:0]  B1_sel_o,        // Select between the ALU previous output and the second register
    output logic [1:0]  A2_sel_o,        // Select between the PC and the first mux output
    output logic [1:0]  B2_sel_o,        // Select between the immediate value and the second mux output
    // ALU
    output logic [3:0]  alu_op_o,        // ALU operation
    // Memory
    output logic        mem_rw_o,        // Memory write enable
    // Writeback
    output logic [1:0]  wb_sel1_o,       // Select between the data from the ALU and the data from the memory
    output logic [1:0]  wb_sel2_o,       // Select between the data from the writeback and PC+4
    // Registers
    output logic        reg_w_en_o,      // Register write enable
    // PC
    output logic [1:0]  pc_sel_o         // Select between the PC+4 and the branch target
);

    //== Variable Declaration ======================================================
    // Registers that will store instructions across multiple cycles
    logic [31:0] inst_reg0,
                 inst_reg1, 
                 inst_reg2;
    
    // Instruction types
    `define INST_REGREG 7'b0110011       // Register-register instruction
    `define INST_REGIMM 7'b0010011       // Register-immediate instruction
    `define INST_LOAD   7'b0000011       // Load instruction
    `define INST_STORE  7'b0100011       // Store instruction
    `define INST_BRANCH 7'b1100011       // Branch instruction
    `define INST_JALR   7'b1100111       // Jump and link register instruction
    `define INST_JAL    7'b1101111       // Jump and link instruction
    `define INST_LUI    7'b0110111       // Load upper immediate instruction
    `define INST_AUIPC  7'b0010111       // Add upper immediate to PC instruction
    `define INST_NOP    7'b0000000       // No operation instruction

    // ALU operations
    typedef enum  {
        ADD,		// Also used for BEQ, BNE, BGE, BGEU, AUIPC
        AND,
        SLL,
        SRL,
        OR,
        XOR,
        OUT_ONE,    // Usefull for SLT, SLTU instructions
        OUT_ZERO,
        SRA,
        LUI,		// Just take the immediate value (already returned on the right format)
        SUB
    } alu_op_t;

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
        alu_op_o = OUT_ZERO;             // ALU operation is NOP
        mem_rw_o = 1'b0;                 // Memory write is disabled
        wb_sel1_o = 1'b0;                // Select the data from memory
        wb_sel2_o = 1'b0;                // Select the data from the writeback
        reg_w_en_o = 1'b0;               // Register write is disabled
        pc_sel_o = 1'b0;                 // Select the PC+4
        br_un_o = 1'b0;                  // Unsigned comparison is disabled

        if (!rst) begin
            //----- Instruction decoding
            if (inst_reg0[6:0] != `INST_NOP) begin
                // Detecting dependencies, begin to check if the previous instruction has a result
                if (inst_reg1[6:0] != `INST_BRANCH && inst_reg1[6:0] != `INST_STORE) begin
                    // Check dependency on the first register
                    if (inst_reg1[11:7] == inst_reg0[19:15]) begin
                        A1_sel_o = 1'b1;     // Select the ALU output
                    end
                    // Check if the current instruction require the second register
                    if (inst_reg0[6:0] == `INST_BRANCH || inst_reg0[6:0] == `INST_STORE || inst_reg0[6:0] == `INST_REGREG) begin
                        // Check dependency on the second register
                        if (inst_reg1[11:7] == inst_reg0[24:20]) begin
                            B1_sel_o = 1'b1;     // Select the ALU output
                        end
                    end
                end
                // Check if the current instruction is a branch or a jump
                if (inst_reg0[6:0] == `INST_BRANCH || inst_reg0[6:0] == `INST_JAL || inst_reg0[6:0] == `INST_JALR)
                    A2_sel_o = 1'b1;         // Select PC as ALU input
                // Check if the current instruction is a branch
                if (inst_reg0[6:0] == `INST_BRANCH) begin
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
                if (inst_reg0[6:0] != `INST_REGREG)
                    B2_sel_o = 1'b1;         // Select the immediate value
                // Select the ALU operation
                case (inst_reg0[6:0])
                    `INST_REGREG: begin
                        if (inst_reg0[14:12] == 3'b000 && inst_reg0[31:25] == 7'b0000000)
                            alu_op_o = ADD;
                        if (inst_reg0[14:12] == 3'b000 && inst_reg0[31:25] == 7'b0100000)
                            alu_op_o = SUB;
                        if (inst_reg0[14:12] == 3'b001)
                            alu_op_o = SLL;
                        if (inst_reg0[14:12] == 3'b010) begin  // SLT
                            if (br_lt_i && !br_eq_i) alu_op_o = OUT_ONE;
                            else                     alu_op_o = OUT_ZERO;
                        end
                        if (inst_reg0[14:12] == 3'b011) begin  // SLTU
                            br_un_o = 1'b1;                    // Unsigned comparison is enabled
                            if (br_lt_i && !br_eq_i) alu_op_o = OUT_ONE;
                            else                     alu_op_o = OUT_ZERO;
                        end
                        if (inst_reg0[14:12] == 3'b100)
                            alu_op_o = XOR;
                        if (inst_reg0[14:12] == 3'b101 && inst_reg0[31:25] == 7'b0000000)
                            alu_op_o = SRL;
                        if (inst_reg0[14:12] == 3'b101 && inst_reg0[31:25] == 7'b0100000)
                            alu_op_o = SRA;
                        if (inst_reg0[14:12] == 3'b110)
                            alu_op_o = OR;
                        if (inst_reg0[14:12] == 3'b111) 
                            alu_op_o = AND;
                    end
                    `INST_REGIMM: begin
                        case (inst_reg0[14:12])
                            3'b000: alu_op_o = ADD;
                            3'b001: alu_op_o = SLL;
                            3'b010: begin // SLT
                                if (br_lt_i && !br_eq_i) alu_op_o = OUT_ONE;
                                else                     alu_op_o = OUT_ZERO;
                            end
                            3'b011: begin // SLTU
                                br_un_o = 1'b1;                // Unsigned comparison is enabled
                                if (br_lt_i && !br_eq_i) alu_op_o = OUT_ONE;
                                else                     alu_op_o = OUT_ZERO;
                            end
                            3'b100: alu_op_o = XOR;
                            3'b110: alu_op_o = OR;
                            3'b111: alu_op_o = AND;
                        endcase
                    end
                    `INST_LOAD: begin
                        alu_op_o = ADD;
                    end	
                    `INST_STORE: begin
                        alu_op_o = ADD;
                    end
                    `INST_BRANCH: begin
                        case (inst_reg0[14:12])
                            3'b000: if (br_eq_i)             alu_op_o = ADD;  // BEQ
                            3'b001: if (!br_eq_i)            alu_op_o = ADD;  // BNE
                            3'b100: if (br_lt_i)             alu_op_o = ADD;  // BLT
                            3'b101: if (br_eq_i || !br_lt_i) alu_op_o = ADD;  // BGE
                            3'b110: if (br_lt_i)             alu_op_o = ADD;  // BLTU
                            3'b111: if (br_eq_i || !br_lt_i) alu_op_o = ADD;  // BGEU
                        endcase
                    end
                    `INST_JALR: begin
                        alu_op_o = ADD;
                    end
                    `INST_JAL: begin
                        alu_op_o = ADD;
                    end
                    `INST_LUI: begin
                        alu_op_o = LUI;
                    end
                    `INST_AUIPC: begin
                        alu_op_o = ADD;
                    end
                    `INST_NOP: begin
                        alu_op_o = OUT_ZERO;
                    end
                endcase
            end

            //----- Memory stage
            if (inst_reg1[6:0] != `INST_NOP) begin
                // Check if the current instruction is a store
                if (inst_reg1[6:0] == `INST_STORE)
                    mem_rw_o = 1'b1;         // Memory write is enabled
            end
            
            //----- Writeback stage
            if (inst_reg2[6:0] != `INST_NOP) begin
                // Manage wb_sel1_o signal
                if (inst_reg2[6:0] == `INST_LOAD)
                    wb_sel1_o = 1'b0;        // Select the data from memory
                // Check if the current instruction require to store PC+4
                if (inst_reg2[6:0] == `INST_JALR || inst_reg2[6:0] == `INST_JAL)
                    wb_sel2_o = 1'b1;        // Select the data from PC+4
                // Manage pc_sel_o signal
                if (inst_reg2[6:0] == `INST_BRANCH || inst_reg2[6:0] == `INST_JAL || inst_reg2[6:0] == `INST_JALR)
                    pc_sel_o = 1'b1;        // Select the data from the branch target
                // Manage reg_w_en_o signal
                if (inst_reg2[6:0] != `INST_BRANCH && inst_reg2[6:0] != `INST_STORE)
                    reg_w_en_o = 1'b1;       // Register write is enabled
            end
        end
    end
endmodule