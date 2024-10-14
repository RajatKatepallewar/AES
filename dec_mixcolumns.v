`timescale 1ns / 1ps


module mixcolumns(
    input [127:0] state_in_col,
    output [127:0] state_out_col
);

function [7:0] mb2; // Multiply by 2
    input [7:0] x;
    begin 
        if (x[7] == 1) 
            mb2 = ((x << 1) ^ 8'h1b);
        else 
            mb2 = x << 1; 
    end     
endfunction

function [7:0] mb3; // Multiply by 3
    input [7:0] x;
    begin 
        mb3 = mb2(x) ^ x;
    end 
endfunction

function [7:0] mb9; // Multiply by 9
    input [7:0] x;
    begin
        mb9 = mb2(mb2(mb2(x))) ^ x;
    end
endfunction

function [7:0] mbB; // Multiply by B (11 in decimal)
    input [7:0] x;
    begin
        mbB = mb2(mb2(mb2(x)) ^ x) ^ x;
    end
endfunction

function [7:0] mbD; // Multiply by D (13 in decimal)
    input [7:0] x;
    begin
        mbD = mb2(mb2(mb2(x) ^ x)) ^ x;
    end
endfunction

function [7:0] mbE; // Multiply by E (14 in decimal)
    input [7:0] x;
    begin
        mbE = mb2(mb2(mb2(x) ^ x) ^ x);
    end
endfunction

genvar i;

generate 
for (i = 0; i < 4; i = i + 1) begin : m_col

    assign state_out_col[i*32 +:8]   = mbE(state_in_col[i*32 +:8])   ^ mbB(state_in_col[(i*32 + 8) +:8]) ^ mbD(state_in_col[(i*32 + 16) +:8]) ^ mb9(state_in_col[(i*32 + 24) +:8]);
    assign state_out_col[(i*32 + 8) +:8]  = mb9(state_in_col[i*32 +:8])   ^ mbE(state_in_col[(i*32 + 8) +:8]) ^ mbB(state_in_col[(i*32 + 16) +:8]) ^ mbD(state_in_col[(i*32 + 24) +:8]);
    assign state_out_col[(i*32 + 16) +:8] = mbD(state_in_col[i*32 +:8])   ^ mb9(state_in_col[(i*32 + 8) +:8]) ^ mbE(state_in_col[(i*32 + 16) +:8]) ^ mbB(state_in_col[(i*32 + 24) +:8]);
    assign state_out_col[(i*32 + 24) +:8] = mbB(state_in_col[i*32 +:8])   ^ mbD(state_in_col[(i*32 + 8) +:8]) ^ mb9(state_in_col[(i*32 + 16) +:8]) ^ mbE(state_in_col[(i*32 + 24) +:8]);

end
endgenerate
