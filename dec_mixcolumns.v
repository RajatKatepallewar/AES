`timescale 1ns / 1ps

module dec_mixcolumns(
    input [127:0] in_col,
    output [127:0] out_col
);

function [7:0] mb2; // Multiply by 2 in GF(2^8)
    input [7:0] x;
    begin 
        mb2 = (x << 1) ^ ((x & 8'h80) ? 8'h1b : 8'h00); 
    end     
endfunction

function [7:0] mb3; // Multiply by 3 in GF(2^8)
    input [7:0] x;
    begin 
        mb3 = mb2(x) ^ x;
    end 
endfunction

function [7:0] mb9; // Multiply by 9 in GF(2^8)
    input [7:0] x;
    begin
        mb9 = mb2(mb2(mb2(x))) ^ x;
    end
endfunction

function [7:0] mbB; // Multiply by B (11 in decimal) in GF(2^8)
    input [7:0] x;
    begin
        mbB = mb2(mb2(mb2(x)) ^ x) ^ x;
    end
endfunction

function [7:0] mbD; // Multiply by D (13 in decimal) in GF(2^8)
    input [7:0] x;
    begin
        mbD = mb2(mb2(mb2(x) ^ x)) ^ x;
    end
endfunction

function [7:0] mbE; // Multiply by E (14 in decimal) in GF(2^8)
    input [7:0] x;
    begin
        mbE = mb2(mb2(mb2(x) ^ x) ^ x);
    end
endfunction

function [31:0] mix_column;
    input [31:0] col;
    reg [7:0] b0, b1, b2, b3;
    reg [7:0] h0, h1, h2, h3;
    begin
        b0 = col[31:24];
        b1 = col[23:16];
        b2 = col[15:8];
        b3 = col[7:0];
        
        h0 = mbE(b0) ^ mbB(b1) ^ mbD(b2) ^ mb9(b3);
        h1 = mb9(b0) ^ mbE(b1) ^ mbB(b2) ^ mbD(b3);
        h2 = mbD(b0) ^ mb9(b1) ^ mbE(b2) ^ mbB(b3);
        h3 = mbB(b0) ^ mbD(b1) ^ mb9(b2) ^ mbE(b3);

        mix_column = {h0, h1, h2, h3};
    end
endfunction

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : mixcols
        assign out_col[(i*32) +: 32] = mix_column(in_col[(i*32) +: 32]);
    end
endgenerate


endmodule
