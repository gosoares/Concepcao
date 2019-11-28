module mux(
    input logic d0, d1, sel,
    output logic y
);
    assign y = sel ? d1 : d0;
endmodule
