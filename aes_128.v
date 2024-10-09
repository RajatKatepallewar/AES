`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2024 02:55:45 PM
// Design Name: 
// Module Name: aes_128
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module aes_128(
input clk,
input rst,
input start,
input [127:0] data_in,
input [127:0] key,
output reg [127:0] data_out,
output reg done
    );

reg [127:0] state_in;
wire [127:0] state_out;
reg [127:0] state_in_row;
wire [127:0] state_out_row;
reg [127:0] state_in_col;
wire [127:0] state_out_col;
reg [127:0]cipher_key;
wire [1407:0]expanded_key;
reg [127:0] space;

aes_subbytes subbytes(
.state_in(state_in),
.state_out(state_out)
);

aes_shiftrows shiftrows(
.state_in_row(state_in_row),
.state_out_row(state_out_row)
);

 mixcolumns aes_mixcolumns(
.state_in_col(state_in_col),
.state_out_col(state_out_col)
);

key_exp aes_key_exp(
.cipher_key(cipher_key),
.expanded_key(expanded_key)
);

integer m ;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 128'b0;
        done <= 1'b0;
    end 
    else if (start) begin
        space <= data_in ^ cipher_key;
        state_in <= data_in;
        for (m = 1; m < 10; m = m + 1) begin
            state_in <= space;
            state_in_row <= state_out;
            state_in_col <= state_out_row;
            space <= state_out_col ^ expanded_key[(128 * m) + 127 -: 128];
        end
        state_in <= space;
        state_in_row <= state_out;
        space <= state_out_row ^ expanded_key[(128 * 10) + 127 -: 128];
        data_out <= space;
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end 
endmodule








