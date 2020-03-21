module shift_left32(
    input logic [31:0] a,
    output logic [31:0] y
);

    assign y = a << 2;

endmodule

