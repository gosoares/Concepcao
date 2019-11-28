module addac4(
    input logic [3:0] a;
    input logic sel0, sel1, clk;
    output logic [3:0] s;
    output logic cout;
);

    logic [2:0] addacs_cout;
    addac addac0(
        .a(a[0]), .sel0(sel0), .sel1(sel1), .cin(sel0), .clk(clk),
        .s(s[0]), .cout(addacs_cout[0])
    );
    addac addac1(
        .a(a[1]), .sel0(sel0), .sel1(sel1), .cin(addacs_cout[0]), .clk(clk),
        .s(s[1]), .cout(addacs_cout[1])
    );
    addac addac2(
        .a(a[2]), .sel0(sel0), .sel1(sel1), .cin(addacs_cout[1]), .clk(clk),
        .s(s[2]), .cout(addacs_cout[2])
    );
    addac addac3(
        .a(a[3]), .sel0(sel0), .sel1(sel1), .cin(addacs_cout[2]), .clk(clk),
        .s(s[3]), .cout(cout)
    );
endmodule
