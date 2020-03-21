module register_file(
	input logic [4:0] RegA, RegB, RegC,
	input logic clk, reset, dataIn, RegWrite,
	output logic RD1, RD2
);

	logic [31:0] decoderOut;
	decoder5x32 decoder(RegC, decoderOut);
	
	//regWrite & decoderOut
	logic [31:0] writeEnable;
	and ands [31:0] (writeEnable, RegWrite, decoderOut);
	logic [31:0] registersOut;
	flopenr registers [31:0] (clk, writeEnable, reset, dataIn, registersOut); 
	
	
	mux32 MuxA(registersOut, RegA, RD1);
	mux32 MuxB(registersOut, RegB, RD2);
endmodule
