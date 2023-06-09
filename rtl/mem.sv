//==============================================================================
//  Filename    : Mem
//  Description : c'est l'étage de mémoire donnée. On prend addr sur 32 bit pour ne garder que les 8 bits de poids faible. Au départ nous n'initialisons pas la mémoire à 0
//==============================================================================

module mem #(parameter  n=20) ( 
    input          clk,
    input           rst,
    input           memRW,	         // Indicate if we read (0) or write (1)
    input         [1:0]  dataSec_i,      // Indicate the size of the data to write (00: 1 byte, 01: 2 bytes, 10: 4 bytes)
    input         [31:0] dataW_i,        // Data to write
    input         [31:0] addr_i,         // Address to read/write
    output  logic [31:0] data_o,         // Data read
    output  logic [31:0] alu_o           // Pass the value of addr_i to the next stage
);
    //== Variable Declaration ======================================================
    logic [7:0]  mem[n:0];               // Table containing the memory, n required to be a multiple of 4m-1
    // octet_mem r_mem_f[n:0];
    // octet_mem r_mem[n:0];
    logic [31:0] data_r;                 // Async data read
    //logic        reset_sig;              // Pass the reset signal from the sequential block to the combinatorial block
    integer i;
    // integer k;

    //== Main code =================================================================
    always_ff @(posedge clk) begin
        if(rst) begin
            data_o    <= 32'hffffffff;
            alu_o     <= 0;
    //----- Reset the memory
            for (i = 0; i <= n; i=i+1) mem[i] <= 8'hff;             
        end

        else begin
            data_o    <= data_r;
            alu_o     <= addr_i;
            if(memRW) begin
            //----- Write
                case (dataSec_i)
                    // Byte
                    2'b00: mem[addr_i] <= dataW_i[7:0];
                    // Half word
                    2'b01: begin
                        mem[addr_i+1] <= dataW_i[15:8];
                        if (addr_i+1 <= n) mem[addr_i] <= dataW_i[7:0];
                    end
                    // Word
                    2'b10: begin
                        mem[addr_i+3] <= dataW_i[31:24];
                        if (addr_i+1 <= n) mem[addr_i+2] <= dataW_i[23:16];
                        if (addr_i+2 <= n) mem[addr_i+1] <= dataW_i[15:8];
                        if (addr_i+3 <= n) mem[addr_i]   <= dataW_i[7:0];
                    end
                    default: begin
                        /* No write */
                    end
                endcase
            end
        end

    end
    
    always_comb begin                    // memRW, dataW_i, addr
        //----- Default values
        data_r = 32'hffffffff;


        //----- Read, manage the case where the  size of the data is above the size of the memory
        if(!memRW ) begin
            if (addr_i+1 > n) begin
                data_r[31:8] = 24'h000000;
                data_r[7:0]  = mem[addr_i];
            end
            else if (addr_i+2 > n) begin
                data_r[31:16] = 16'h0000;
                data_r[7:0]  = mem[addr_i];
                data_r[15:8]  = mem[addr_i+1];

            end
            else if (addr_i+1 > n) begin
                data_r[31:24] = 8'h00;
                data_r[7:0]  = mem[addr_i];
                data_r[15:8]  = mem[addr_i+1];
                data_r[23:15]  = mem[addr_i+2];

            end
            else begin
                data_r[31:24] = mem[addr_i+3];
                data_r[23:16] = mem[addr_i+2];
                data_r[15:8]  = mem[addr_i+1];
                data_r[7:0]   = mem[addr_i];
            end

            // We mask the data according to the the value of dataSec_i
            case (dataSec_i)
                2'b00: data_r[31:8] = 24'h000000;  // Byte
                2'b01: data_r[31:16] = 16'h0000;   // Half word
                default: begin
                    /* No mask */
                end
            endcase
        end
        
    end
    
endmodule   
