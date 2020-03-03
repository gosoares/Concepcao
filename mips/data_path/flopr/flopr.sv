module flopr(
	input logic clk, rst, d,
	output logic q
);

	always_ff @(posedge clk, posedge rst) begin
		if(rst) q <= 1'b0;
		else q <= d;
	end

endmodule