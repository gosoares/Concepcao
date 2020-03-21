module mux32(
	input logic [31:0] d,
	input logic [4:0] sel,
	output logic y
);

	// first layer of muxes
	logic [7:0] ymuxes1;
	genvar i;
	generate
		for (i = 0; i < 8; i=i+1) begin: generate_muxes1
			mux4 m4(d[4*i + 0], d[4*i + 1], d[4*i + 2], d[4*i + 3], sel[1:0], ymuxes1[i]);
		end
	endgenerate
	
	// second layer of muxes
	logic [1:0] ymuxes2;
	generate
		for (i = 0; i < 2; i=i+1) begin: generate_muxes2
			mux4 m4(ymuxes1[4*i + 0], ymuxes1[4*i + 1], ymuxes1[4*i + 2], ymuxes1[4*i + 3], sel[3:2], ymuxes2[i]);
		end
	endgenerate
	
	// last mux
	mux2 m2(ymuxes2[0], ymuxes2[1], sel[4], y);

endmodule