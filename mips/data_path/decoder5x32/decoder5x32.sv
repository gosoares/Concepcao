module decoder5x32(
	input logic [4:0] a,
	output logic [31:0] y
);
	assign y = 32'b1 << a;
endmodule