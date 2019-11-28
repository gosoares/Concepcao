module acc(
    input logic a, clk,
    output logic y
);
    always_ff @(posedge clk)
        y <= a;
endmodule
