module flopenr(
	input logic clk, en, rst, d,
	output logic q
);

	always_ff @(posedge clk, posedge rst) begin
		if(rst) q <= 1'b0;
		else if (en) q <= d;
	end

endmodule