module mux8(
	input logic [7:0] d,
	input logic [2:0] sel,
	output logic y
);

	// mux4
	logic [1:0] ymux;
	genvar i;
	generate
		for (i = 0; i < 2; i=i+1) begin: generate_muxes1
			mux4 m4(d[4*i + 0], d[4*i + 1], d[4*i + 2], d[4*i + 3], sel[1:0], ymux[i]);
		end
	endgenerate
	
	// last mux
	mux2 m2(ymux[0], ymux[1], sel[2], y);

endmodule