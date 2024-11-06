module mixcolumns(
    input [127:0] state_in,
    output [127:0] state_out
);

function [7:0] xtime;
    input [7:0] x;
    begin
        xtime = (x << 1) ^ ((x & 8'h80) ? 8'h1b : 8'h00);
    end
endfunction

function [7:0] mul_by_3;
    input [7:0] x;
    begin
        mul_by_3 = xtime(x) ^ x;
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
        
        h0 = xtime(b0) ^ mul_by_3(b1) ^ b2 ^ b3;
        h1 = b0 ^ xtime(b1) ^ mul_by_3(b2) ^ b3;
        h2 = b0 ^ b1 ^ xtime(b2) ^ mul_by_3(b3);
        h3 = mul_by_3(b0) ^ b1 ^ b2 ^ xtime(b3);

        mix_column = {h0, h1, h2, h3};
    end
endfunction

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : mixcols
        assign state_out[(i*32) +: 32] = mix_column(state_in[(i*32) +: 32]);
    end
endgenerate

endmodule
