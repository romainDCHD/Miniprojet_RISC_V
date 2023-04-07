//==============================================================================
//  Filename    : Mem
//  Description : c'est l'étage de mémoire donnée. On prend addr sur 32 bit pour ne garder que les 8 bits de poids faible. Au départ nous n'initialisons pas la mémoire à 0
//==============================================================================

module mem #(parameter  n=20) ( 
    input   logic   clk,
    input   logic   rst,
    input   logic   dmem,	// savoir si ecriture(0) ou lecture(1)
    input   [31:0]  data_w,
    input   [31:0]  addr,
    output  logic [31:0]  data_o
  );
  
    logic   [31:0]  r_mem[n:0];
    logic  [31:0]  data_r;
    logic  [7:0]   short_addr;
    
    
    always_ff @(posedge clk)
    begin
        if(rst) 
        begin
            data_o <= 32'b1;
        end
        else 
        begin
            data_o <= data_r;
        end
    end
    
    always_comb// dmem, data_w, addr
      begin
      short_addr = addr;
      	//lecture
        if(dmem == 1'b1) 
        begin
            data_r <= r_mem[ 0 ];
        end
        //ecriture
        else 
        begin
            r_mem[ short_addr ] <= data_w;
            data_r <= 32'b0;
        end
        end



endmodule   
