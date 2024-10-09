`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2024 12:29:57 AM
// Design Name: 
// Module Name: mixcolumns
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


module mixcolumns(
    input [127:0] state_in_col,
    output[127:0] state_out_col
    );
    

function [7:0] mb2; //multiply by 2
	input [7:0] x;
	begin 
			/* multiplication by 2 is shifting on bit to the left, and if the original 8 bits had a 1 @ MSB,
			xor the result with {1b}*/
			if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
			else mb2 = x << 1; 
	end 	
endfunction

function [7:0] mb3; //multiply by 3
	input [7:0] x;
	begin 
			
			mb3 = mb2(x) ^ x;
	end 
endfunction


genvar i;

generate 
for(i=0;i< 4;i=i+1) begin : m_col

	assign state_out_col[i*32 +:8]= mb2(state_in_col[i*32+:8]) ^ mb3(state_in_col[(i*32 + 8)+:8]) ^ state_in_col[(i*32 + 16)+:8] ^ state_in_col[(i*32 + 24)+:8];
	assign state_out_col[(i*32 + 8)+:8]= state_in_col[i*32+:8] ^ mb2(state_in_col[(i*32 + 8)+:8]) ^ mb3(state_in_col[(i*32 + 16)+:8]) ^ state_in_col[(i*32 + 24)+:8];
	assign state_out_col[(i*32 + 16)+:8]= state_in_col[i*32+:8] ^ state_in_col[(i*32 + 8)+:8] ^ mb2(state_in_col[(i*32 + 16)+:8]) ^ mb3(state_in_col[(i*32 + 24)+:8]);
    assign state_out_col[(i*32 + 24)+:8]= mb3(state_in_col[i*32+:8]) ^ state_in_col[(i*32 + 8)+:8] ^ state_in_col[(i*32 + 16)+:8] ^ mb2(state_in_col[(i*32 + 24)+:8]);

end

endgenerate
    
endmodule
