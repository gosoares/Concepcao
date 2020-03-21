module alu(
	input logic a, b, slt_in, adder_cin,
	input logic [2:0] op, 
	output logic adder_cout, adder_s, result
);

	logic and_out, or_out, nor_out, xor_out;
	and(and_out, a, b);
	or(or_out, a, b);
	nor(nor_out, a, b);
	xor(xor_out, a, b);
	
	logic adder_b;
	xor(adder_b, b, op[0]); // se op = sub ou slt nega o b
	full_adder full_adder(a, adder_b, adder_cin, adder_s, adder_cout);
	
	logic [7:0]	mux_in;
	assign mux_in[2] = adder_s; // add
	assign mux_in[6] = adder_s; // sub
	assign mux_in[0] = and_out;
	assign mux_in[1] = or_out;
	assign mux_in[5] = nor_out;
	assign mux_in[3] = xor_out;
	assign mux_in[7] = slt_in;
	
	mux8 mux(mux_in, op, result);

endmodule
