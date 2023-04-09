//==============================================================================
//  Filename    : Mem
//  Description : c'est l'étage de mémoire donnée. On prend addr sur 32 bit pour ne garder que les 8 bits de poids faible. Au départ nous n'initialisons pas la mémoire à 0
//==============================================================================

module mem #(parameter  n=20) ( 
    input   logic   clk,
    input   logic   rst,
    input   logic   memRW,	// savoir si ecriture(0) ou lecture(1)
    input   [31:0]  dataW_i,
    input   [31:0]  addr_i,
    output  logic [31:0]  data_o,
    output  logic [31:0]  alu_o
  );
  
    logic   [31:0]  r_mem[n:0]; // la memoire à proprement parler
    logic  [31:0]  data_r;
    logic  [7:0]   short_addr;
    logic  [7:0]   alu_r;
    
    
    //----------sortie de memory/execute de manière synchrone -------
    always_ff @(posedge clk)
    begin
        if(rst) 
        begin
            data_o <= 32'b1;
            alu_o = 1'b0;
        end
        else 
        begin
            data_o <= data_r;
            alu_o = addr_i;
        end
    end
    
    //----------l'accès à la mémoire-----------------
    always_comb// memRW, dataW_i, addr
      begin
      short_addr = addr_i;
      	//lecture
        if(memRW == 1'b1) 
        begin
            data_r <= r_mem[ 0 ];
        end
        //ecriture
        else 
        begin
            r_mem[ short_addr ] <= dataW_i;
            data_r <= 32'b0;
        end
        end

endmodule   
