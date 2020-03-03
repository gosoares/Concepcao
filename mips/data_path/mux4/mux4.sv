module mux4(
    input logic d0, d1, d2, d3,
    input logic [1:0] sel,
    output logic y
);
	logic mux0_y, mux1_y;
    mux2 mux0(d0, d1, sel[0], mux0_y);
    mux2 mux1(d2, d3, sel[0], mux1_y);
    mux2 finalmux(mux0_y, mux1_y, sel[1], y);
endmodule
