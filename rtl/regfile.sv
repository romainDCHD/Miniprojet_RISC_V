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
    ,input 	        RegWEn_i	// 1 to write in AddrD

    // Outputs
    ,output logic [ 31:0]  DataA_o
    ,output logic [ 31:0]  DataB_o
 );	
        
    //definition of the registers
    reg [31:0] Registers[31:0];
    
    //--------------------------------
    //keep the value of AddrA and B for the current clk
    //--------------------------------
		logic  [4:0]  Old_AddrB_r;
		logic  [4:0]  Old_AddrA_r;

		always_ff @ (posedge clk_i )
			begin
				Old_AddrA_r <= AddrA_i;
				Old_AddrB_r <= AddrB_i;
			end


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
    // Combinational read
    //-----------------------------------------------------------------
		assign DataA_o = Registers[Old_AddrA_r];
		assign DataB_o = Registers[Old_AddrB_r];

	//-----------------------------------------------------------------
    // Synchronous write
    //-----------------------------------------------------------------
    
		always_ff @ (posedge clk_i )
		begin
			//reset
			if (rst_i)
			begin 
				Registers   <= '{default:32'h00000000};
			end
			
			else 
			begin    
				//ecriture
				if (RegWEn_i == 1)
				begin
					Registers[Old_AddrD]   <= DataD_i; 
				end
			end   
		end
endmodule
