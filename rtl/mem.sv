//==============================================================================
//  Filename    : Mem
//  Description : c'est l'étage de mémoire donnée. On prend addr sur 32 bit pour ne garder que les 8 bits de poids faible. Au départ nous n'initialisons pas la mémoire à 0
//==============================================================================

module mem #(parameter  n=20) ( 
    input   logic   clk,
    input   logic   rst,
    input   logic   memRW,	// savoir si ecriture(0) ou lecture(1)
    input   [1:0]   dataSec_i,
    input   [31:0]  dataW_i,
    input   [31:0]  addr_i,
    output  logic [31:0]  data_o,
    output  logic [31:0]  alu_o
  );
    typedef logic [7:0] octet_mem;
    octet_mem r_mem[n:0]; // la memoire à proprement parler avec n un multiple de 4 (-1)
    logic  [31:0]  data_r;
    logic  [7:0]   short_addr;
    integer i;

    
    //----------sortie de memory/execute de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if(rst) 
        begin
            data_o <= 32'hffffffff;
            alu_o = 32'b0;
            // for(i = 0; i<n;i=i+1) r_mem[i] <= 8'hff;
        end
        else 
        begin
            data_o <= data_r;
            alu_o <= addr_i;
        end
    end
    
    //----------l'accès à la mémoire-----------------
   

    always_comb// memRW, dataW_i, addr
      begin
      	//lecture
        if(rst) 
        begin
            for(int i = 0; i<=n;i=i+1) r_mem[i] <= 8'hff;
        end
        if(!rst)
        begin
            if(memRW == 1'b1) 
            begin
                data_r[31:24] = r_mem[ addr_i ];
                if(addr_i +1 >n) data_r[23:16] = 8'b0;
                else data_r[23:16] = r_mem[ addr_i + 1];
                if(addr_i +2 >n) data_r[15:8] = 8'b0;
                else data_r[15:8] = r_mem[ addr_i + 2];
                if(addr_i +3 >n) data_r[7:0] = 8'b0;
                else data_r[7:0] = r_mem[ addr_i + 3];      
            end
            //ecriture
            else 
            begin
                data_r <= 32'b0;
                if(dataSec_i == 2'b00) r_mem[ addr_i ] <= dataW_i[7:0];
                else if(dataSec_i == 2'b01)
                begin
                    r_mem[ addr_i ] <= dataW_i[15:8];
                    if(addr_i + 1 <= n) r_mem[ addr_i + 1] = dataW_i[7:0];
                end
                else if(dataSec_i == 2'b10)
                begin
                    r_mem[ addr_i ] = dataW_i[31:24];
                    if(addr_i + 1 <= n) r_mem[ addr_i + 1] = dataW_i[23:16];
                    if(addr_i+2<=n) r_mem[addr_i + 2] = dataW_i[15:8];
                    if(addr_i+3<=n) r_mem[addr_i + 3] = dataW_i[7:0];
                end  
            end
        end
        end

endmodule   
