module two_bit_right_shift(data, out);
    input [31:0] x;
    output [31:0] out;
    assign out[29:0] = x[31:2];
    assign out[30] = x[31] ? 1'b1 : 1'b0;
    assign out[31] = x[31];
endmodule