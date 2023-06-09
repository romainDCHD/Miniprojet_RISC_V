`include "./INPUT_DATA/filter.v"

module filter_io ( CLK, RESET, Filter_In, Filter_Out, ADC_Eocb, ADC_Convstb, ADC_Rdb, ADC_csb, DAC_WRb, DAC_csb, LDACb, CLRB );

	input [7:0] Filter_In;
	output [7:0] Filter_Out;
	
	input CLK, RESET, ADC_Eocb;
	output ADC_Convstb, ADC_csb, ADC_Rdb, DAC_WRb, DAC_csb, LDACb, CLRB;
	
	wire CLK_P, RESET_P, ADC_Convstb_P, ADC_Rdb_P, ADC_csb_P, DAC_WRb_P, DAC_csb_P, LDACb_P, CLRB_P;
	wire [7:0] Filter_In_P;
	wire [7:0] Filter_Out_P;



FILTER t_op (	.CLK(CLK_P), .RESET(RESET_P), .Filter_In(Filter_In_P[7:0]), .Filter_Out(Filter_Out_P[7:0]), .ADC_eoc(ADC_Eocb_P), .ADC_convst(ADC_Convstb_P), .ADC_rd(ADC_Rdb_P), .ADC_cs(ADC_csb_P), .DAC_wr(DAC_WRb_P), .DAC_cs(DAC_csb_P), .DAC_ldac(LDACb_P), .DAC_clr(CLRB_P) );


	ITP io_CLK ( .PAD(CLK), .Y(CLK_P) );
	
	ITP io_RESET ( .PAD(RESET), .Y(RESET_P) );	
	

	ITP io_Filter_In_7 ( .PAD(Filter_In[7]), .Y(Filter_In_P[7]) );
	ITP io_Filter_In_6 ( .PAD(Filter_In[6]), .Y(Filter_In_P[6]) );
	ITP io_Filter_In_5 ( .PAD(Filter_In[5]), .Y(Filter_In_P[5]) );
	ITP io_Filter_In_4 ( .PAD(Filter_In[4]), .Y(Filter_In_P[4]) );
	ITP io_Filter_In_3 ( .PAD(Filter_In[3]), .Y(Filter_In_P[3]) );
	ITP io_Filter_In_2 ( .PAD(Filter_In[2]), .Y(Filter_In_P[2]) );
	ITP io_Filter_In_1 ( .PAD(Filter_In[1]), .Y(Filter_In_P[1]) );
	ITP io_Filter_In_0 ( .PAD(Filter_In[0]), .Y(Filter_In_P[0]) );

	BU12SP io_Filter_Out_7 ( .A(Filter_Out_P[7]), .PAD(Filter_Out[7]) );
	BU12SP io_Filter_Out_6 ( .A(Filter_Out_P[6]), .PAD(Filter_Out[6]) );
	BU12SP io_Filter_Out_5 ( .A(Filter_Out_P[5]), .PAD(Filter_Out[5]) );
	BU12SP io_Filter_Out_4 ( .A(Filter_Out_P[4]), .PAD(Filter_Out[4]) );
	BU12SP io_Filter_Out_3 ( .A(Filter_Out_P[3]), .PAD(Filter_Out[3]) );
	BU12SP io_Filter_Out_2 ( .A(Filter_Out_P[2]), .PAD(Filter_Out[2]) );
	BU12SP io_Filter_Out_1 ( .A(Filter_Out_P[1]), .PAD(Filter_Out[1]) );
	BU12SP io_Filter_Out_0 ( .A(Filter_Out_P[0]), .PAD(Filter_Out[0]) );	

	ITP io_ADC_Eocb ( .PAD(ADC_Eocb), .Y(ADC_Eocb_P) );

	BU12SP io_ADC_convstb ( .A(ADC_Convstb_P), .PAD(ADC_Convstb) );
	
	BU12SP io_ADC_Rdb 	 ( .A(ADC_Rdb_P), .PAD(ADC_Rdb) );
	
	BU12SP io_ADC_csb 	 ( .A(ADC_csb_P), .PAD(ADC_csb) );
	
	BU12SP io_DAC_WRb 	 ( .A(DAC_WRb_P), .PAD(DAC_WRb) );
	
	BU12SP io_DAC_csb 	 ( .A(DAC_csb_P), .PAD(DAC_csb) );
	
	BU12SP io_LDACb 	 ( .A(LDACb_P), .PAD(LDACb) );

	BU12SP io_CLRB 	 ( .A(CLRB_P), .PAD(CLRB) );
	
endmodule	
	
