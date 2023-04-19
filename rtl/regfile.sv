//==============================================================================
//  Filename    : Register module                                        
//  Designer    : Romain DUCHADEAU
//  Description : Read-Write in registers
//  Ecriture et lecture en meme tps. On doit pas retarder un peu la lecture?
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

    // Outputs
    ,output logic [ 31:0]  DataA_o
    ,output logic [ 31:0]  DataB_o
);	
        
    //definition of the registers
    reg [31:0] Registers[31:0];
    

    //--------------------------------
    //keep the value of AddrD 3 clk
    //--------------------------------
    reg [4:0]  Old_AddrD;
        
    three_dff three_dff_name(
    	.clk	( clk_i     ),
    	.in	( AddrD_i    ),
    	.out	( Old_AddrD ),
    	.reset  ( rst_i     )
    	);
    

    //-----------------------------------------------------------------
    // Synchronous read / write
    //-----------------------------------------------------------------
    
    always_ff @ (posedge clk_i )
    begin
        //reset
        if (rst_i)
	    begin 
			Registers[0]       <= 32'h00000000;
			Registers[1]       <= 32'h00000000;
			Registers[2]       <= 32'h00000000;
			Registers[3]       <= 32'h00000000;
			Registers[4]       <= 32'h00000000;
			Registers[5]       <= 32'h00000000;
			Registers[6]       <= 32'h00000000;
			Registers[7]       <= 32'h00000000;
			Registers[8]       <= 32'h00000000;
			Registers[9]       <= 32'h00000000;
			Registers[10]       <= 32'h00000000;
			Registers[11]       <= 32'h00000000;
			Registers[12]       <= 32'h00000000;
			Registers[13]       <= 32'h00000000;
			Registers[14]       <= 32'h00000000;
			Registers[15]       <= 32'h00000000;
			Registers[16]       <= 32'h00000000;
			Registers[17]       <= 32'h00000000;
			Registers[18]       <= 32'h00000000;
			Registers[19]       <= 32'h00000000;
			Registers[20]       <= 32'h00000000;
			Registers[21]       <= 32'h00000000;
			Registers[22]       <= 32'h00000000;
			Registers[23]       <= 32'h00000000;
			Registers[24]       <= 32'h00000000;
			Registers[25]       <= 32'h00000000;
			Registers[26]       <= 32'h00000000;
			Registers[27]       <= 32'h00000000;
			Registers[28]       <= 32'h00000000;
			Registers[29]       <= 32'h00000000;
			Registers[30]       <= 32'h00000000;
			Registers[31]       <= 32'h00000000;
			DataB_o            <= 32'h00000000;
		    DataA_o            <= 32'h00000000;
	    end
	    
		else 
		begin    
			//ecriture
				if (RegWEn_i == 1)
				begin
					Registers[Old_AddrD]   <= DataD_i; 
				end

			//lecture
			DataA_o       <= Registers[AddrA_i];
			DataB_o       <= Registers[AddrB_i];
		end   
	end


endmodule
