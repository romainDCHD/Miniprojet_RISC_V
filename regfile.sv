//==============================================================================
//  Filename    : Register module                                        
//  Designer    : Romain DUCHADEAU
//  Description : Read-Write in registers
//==============================================================================

module riscv_regfile(
    // Inputs
     input           clk_i
    ,input           rst_i	
    ,input  [  4:0]  AddrD_i
    ,input  [ 31:0]  DataD_i
    ,input  [  4:0]  AddrB_i
    ,input  [  4:0]  AddrA_i
    ,input 	     RegWEn_i	// 1 to write in AddrD
    ,input  	     stall_i	// pas sur encore

    // Outputs
    ,output [ 31:0]  DataA_o
    ,output [ 31:0]  DataB_o
);
    // counter for loops
    integer num;	
    
    //definition of the register who say if a register is avaliable to read
    reg [31:0] wait_for_data
    
    //definition of the registers
    reg [31:0] Registers [31:0];

    //--------------------------------
    //keep the value of AddrD 3 clk
    //--------------------------------
    wire [4:0]  Old_AddrD;
        
    3dff(
    	.clk	( clk_i     ),
    	.in	( AddrD     ),
    	.out	( Old_AddrD )
    	);
    

    //--------------------------------
    // Synchronous register write back
    //--------------------------------
    always @ (posedge clk_i )
    if (rst_i)
    begin
    wait_for_data       <= 32'h00000000;
    
    for (num = 0; num < 32; num =num + 1) 
    begin
    	Registers[num]       <= 32'h00000000;
    end
    end
    
    else if (RegWEn_i == 1)
    begin
       	Registers[Old_AddrD]       <= DataD_i;
       	wait_for_data[AddrD_i]	   <= 1'b0;
       	
    end
     

    //-----------------------------------------------------------------
    // Synchronous read
    //-----------------------------------------------------------------
    
    always @ (posedge clk_i )
    
    //Set the wait_for_data register for the destination register
    wait_for_data[AddrD_i]	<= 1'b1;
    
    if (wait_for_data[AddrA_i] == 0)    
     	DataA_o       <= Registers[AddrA_i];
    else
    	DataA_o       <= 32'h00000000;	// cas d'erreur, a améliorer/ voir ce qu'on fait.
    	
    if(wait_for_data[AddrB_i] == 0)
     	DataB_o       <= Registers[AddrB_i];
    else
     	DataB_o       <= 32'h00000000;	// idem
     
    
    end

endmodule
