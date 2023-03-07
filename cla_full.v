module cla_full_adder(a, b, cin, s);
    input [31:0] a, b;
    input cin;
    output [31:0] s;
    
    wire [3:0] Po, Go;
    wire[31:0] p,g;
    wire [4:0] c;
    wire c_out;


    //first block cin line is input to cell
    assign c[0] = cin;
    //last bit of carry line is outPout cout of block
    assign c_out = c[4];

    //setup p and g lines
    bitwise_or prp(a, b, p);
    bitwise_and gen(a, b, g);
    //chain blocks 
    cla_block b0(a[7:0], b[7:0], c[0], p[7:0], g[7:0], Po[0], Go[0], s[7:0]);
    cla_block b1(a[15:8], b[15:8], c[1], p[15:8], g[15:8], Po[1], Go[1], s[15:8]);
    cla_block b2(a[23:16], b[23:16], c[2], p[23:16], g[23:16], Po[2], Go[2], s[23:16]);
    cla_block b3(a[31:24], b[31:24], c[3], p[31:24], g[31:24], Po[3], Go[3], s[31:24]);

    wire w_b0;
    and b0_and1(w_b0, Po[0], c[0]);
    or b0_or(c[1], Go[0], w_b0);

    wire [1:0] w_b1;
    and b1_and1(w_b1[0], Po[1], Go[0]);
    and b1_and2(w_b1[1], Po[1], Po[0], c[0]);
    or b1_or(c[2], Go[1], w_b1[0], w_b1[1]);

    wire [2:0] w_b2;
    and b2_and1(w_b2[0], Po[2], Go[1]);
    and b2_and2(w_b2[1], Po[2], Po[1], Go[0]);
    and b2_and3(w_b2[2], Po[2], Po[1], Po[0], c[0]);
    or b2_or(c[3], Go[2], w_b2[0], w_b2[1], w_b2[2]);

    wire [3:0] w_b3;
    and b3_and1(w_b3[0], Po[3], Go[2]);
    and b3_and2(w_b3[1], Po[3], Po[2], Go[1]);
    and b3_and3(w_b3[2], Po[3], Po[2], Po[1], Go[0]);
    and b3_and4(w_b3[3], Po[3], Po[2], Po[1], Po[0], c[0]);
    or b3_or(c[4], Go[3], w_b3[0], w_b3[1], w_b3[2], w_b3[3]);

 


endmodule