module addac(
    input logic a, sel0, sel1, cin, clk,
    output logic s, cout
);
    
    logic a_inv;
    inv inv0(.a(a), .y(a_inv));

    logic mux0_y;
    mux mux0(.d0(a), .d1(a_inv), .sel(sel0), .y(mux0_y));

    logic acc_y, adder_y;
    adder adder0(.a(mux0_y), .b(acc_y), .cin(cin), .s(adder_y), .cout(cout));

    mux mux1(.d0(mux0_y), .d1(adder_y), .sel(sel1), .y(s));

    acc acc0(.a(s), .clk(clk), .y(acc_y));

endmodule
